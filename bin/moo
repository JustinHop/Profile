#!/usr/bin/env python

import dbus, dbus.mainloop.glib, logging
import subprocess

from traceback import format_exc

dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)

class Signature(dbus.Signature):
	def __iter__(self):
		return ( Signature(x) for x in dbus.Signature.__iter__(self) )
	
	def py2dbus(self, py):
		assert(len(str(self)) > 0)
		
		if len(tuple(self)) > 1:
			return map((lambda s,p: getattr("py2dbus", s)(p)), self, py)
		
		ct, cc = self.container_type(), self.container_content()
		
		if ct == dbus.Array:
			return dbus.Array(map(cc.py2dbus, py), signature=cc)
		elif ct == dbus.Struct:
			return dbus.Struct(cc.py2dbus(py), signature=cc)
		elif ct == dbus.Dictionary:
			return dbus.Dictionary(map(cc.py2dbus, py.iteritems()), signature=cc)
		elif str(self) == 'v':       return py
		elif str(self) in 'sog':     return unicode(py)
		elif str(self) == 'b':       return bool(py)
		elif str(self) == 'd':       return float(py)
		elif str(self) in 'yinqtux': return int(py)
		else:
			raise ValueError, "Invalid dbus type: %s" % self
	
	def container_type(self):
		if self.startswith("("): return dbus.Struct
		elif self.startswith("a{"): return dbus.Dictionary
		elif self.startswith("a"): return dbus.Array
		else: return None
	
	def container_content(self):
		if self.container_type() == dbus.Struct: return Signature(self[1:-1])
		elif self.container_type() == dbus.Dictionary: return Signature(self[2:-1])
		elif self.container_type() == dbus.Array: return Signature(self[1:])
		else: return None

#
# Utility functions
#
def get_childs(node, child_type):
	childs = node.childNodes or ()
	for child in childs:
		if child.nodeName == child_type:
			yield child

def load_config():
	import os, logging.config
	from xml.dom import minidom
	from xdg.BaseDirectory import load_config_paths
	
	map(logging.config.fileConfig, load_config_paths("moo.conf"))
	
	logger = logging.getLogger("moo")
	logger.info("Reading configuration")
	
	signals = []
	
	for conf_xml_dir in load_config_paths("moo.d"):
		for conf_xml_file in os.listdir(conf_xml_dir):
			conf_xml_path = os.path.join(conf_xml_dir, conf_xml_file)
			if not os.path.isfile(conf_xml_path):
				continue
			conf_xml_fd = open(conf_xml_path)
			conf_xml = conf_xml_fd.read()
			conf_xml_fd.close()
			
			xml = minidom.parseString(conf_xml)
			
			map(signals.append, map(Signal, get_childs(xml.firstChild, "signal")))
			
			logger.info("Added configuration file: %s" % conf_xml_path)
	
	return signals

def eval_safe(expr, env):
	if not expr:
		return expr
	
	if expr[0] != '%' or len(expr) == 1:
		return expr
	else:
		expr = expr[1:]
	
	globals = {}
	globals['a'] = globals['Array']      = globals['list']   = dbus.Array
	globals['b'] = globals['Boolean']    = globals['bool']   = dbus.Boolean
	globals['d'] = globals['Double']     = globals['float']  = dbus.Double
	globals['e'] = globals['Dictionary'] = globals['dict']   = dbus.Dictionary
	globals['g'] = globals['Signature']  = globals['sig']    = Signature
	globals['i'] = globals['Int32']      = globals['int']    = dbus.Int32
	globals['n'] = globals['Int16']      = globals['short']  = dbus.Int16
	globals['o'] = globals['ObjectPath'] = globals['id']     = dbus.ObjectPath
	globals['q'] = globals['UInt16']     = globals['ushort'] = dbus.UInt16
	globals['r'] = globals['Struct']     = globals['tuple']  = dbus.Struct
	globals['s'] = globals['String']     = globals['str']    = dbus.String
	globals['t'] = globals['UInt64']     = globals['ulong']  = dbus.UInt64
	globals['u'] = globals['UInt32']     = globals['uint']   = dbus.UInt32
	globals['x'] = globals['UInt64']     = globals['ulong']  = dbus.UInt64
	
	globals['session'] = SessionBus
	globals['system']  = SystemBus
	globals['None']    = None
	globals['True']    = True
	globals['False']   = False
	
	for builtin in ('abs', 'all', 'any', 'cmp', 'len', 'map', 'reduce', 'min', 'range', 'sum', 'zip'):
		globals[builtin] = getattr(__builtins__, builtin)
	
	return eval(expr, {'__builtins__': globals}, env)

def action_from_xml(xml):
	return Actions[xml.getAttribute('type')](xml)

#
# Basic classes
#
class XML(object):
	class Wrapper:
		""" Wrapper to automatically pass attributes into eval_safe
		e.g. Wrapper(self, env).x is equilavent to eval_safe(self.x, env)
		used with __getitem__ below, it can be used like this:
		self[env].x is equivalent to eval_save(self.x, env) """
		def __init__(self, wrapped, env):
			self.wrapped = wrapped
			self.env = env
		
		def __getattr__(self, attr):
			if attr.startswith('__'):
				raise AttributeError, attr
			return eval_safe(getattr(self.wrapped, attr), self.env)
	
	def __init__(self, xml):
		self.xml = xml
	
	def __getattr__(self, attr):
		if attr.startswith('__'):
			raise AttributeError, attr
		return self.xml.getAttribute(attr) or None
	
	def __getitem__(self, env):
		return XML.Wrapper(self, env)

class Argument(XML):
	def __init__(self, xml):
		self.xml = xml
		
		# An argument has a name attribute XOR a value attribute
		# name attribute is for "in" arguments (which values are set to env)
		# and value attribute is for "out" arguments
		assert(self.isin() ^ self.isout())
		
		if self.type:
			self.type = Signature(self.type)
			assert(len(tuple(self.type)) == 1)
	
	def __repr__(self):
		return '<%s name=%r type=%r value=%r>' % (self.__class__.__name__, self.name, self.type, self.value)
	
	def isin(self):
		return self.value is None
	
	def isout(self):
		return self.name is None
	
	def evalin(self, env, val):
		# Put val into the current environment
		name = self[env].name
		if self.type:
			val = self.type.py2dbus(val)
		env[name] = val
	
	def evalout(self, env):
		# Return the current value of the argument
		if self.type:
			return self.type.py2dbus(self[env].value)
		else:
			return eval_safe(self.value, env)

class ArgumentsContainer(XML):
	def __init__(self, xml):
		self.xml = xml
		self.args = map(Argument, get_childs(xml, 'arg'))
	
	def inargs(self):
		def _isin(arg): return arg.isin()
		return filter(_isin, self.args)
	
	def outargs(self):
		def _isout(arg): return arg.isout()
		return filter(_isout, self.args)
	
	def evalin(self, env, vals):
		def _evalin(arg,val):
			if arg: arg.evalin(env, val)
		map(_evalin, self.inargs(), vals)
	
	def evalout(self, env):
		def _evalout(arg):
			if arg: return arg.evalout(env)
		return map(_evalout, self.outargs())

class DBusCallable(ArgumentsContainer):
	""" Represents a DBus method or signal """
	def __init__(self, xml):
		ArgumentsContainer.__init__(self, xml)
	
	def __repr__(self):
		return "<%s bus=%r service=%r path=%r interface=%r name=%r>" % (self.__class__.__name__,
			self.bus, self.service, self.path, self.interface, self.name)
	
class Signal(DBusCallable):
	Actions = None
	
	def __init__(self, xml):
		DBusCallable.__init__(self, xml)
		
		self.logger = logging.getLogger("moo.signal")
		self.actions = map(action_from_xml, get_childs(xml, 'action'))
		
		assert(self.name != None)
	
	def __call__(self, args):
		env = {}
		self.evalin(env, args)
		
		for action in self.actions:
			self.logger.debug("Executing %r" % action)
			try:
				if not action(env):
					self.logger.debug('"normal" failure')
					return False
				else:
					self.logger.debug("OK")
			except:
				self.logger.warning("Action failed. Error:\n %s" % format_exc())
				return False
		
		return True

#
# Actions
#
def actionLogger(xml):
	return logging.getLogger("moo.actions.%s" % xml.getAttribute("type"))

class Method(DBusCallable):
	""" Call a DBus method """
	def __init__(self, xml):
		DBusCallable.__init__(self, xml)
		
		self.logger = actionLogger(xml)
		self.bus = self.bus or "%session"
		
		assert(self.service != None)
		assert(self.path != None)
		assert(self.name != None)
	
	def __call__(self, env):
		obj = self[env].bus.get_object(self[env].service, self[env].path)
		method = obj.get_dbus_method(self[env].name, self[env].interface)
		ret = method(*self.evalout(env))
		
		if not isinstance(ret, tuple) or isinstance(ret, dbus.Struct):
			ret = (ret,)
		
		self.evalin(env, ret)
		
		return True

class Command(ArgumentsContainer):
	""" Execute command.
		stdout: if present, redirect stdout to this variable
			if not present, redirect to /dev/null
		stderr: like stdout
		stdin: write the evaluation of this to stdin
		return_code: if present, return code is put on this variable
			if not present, stop actions on ret code > 0
		
		Example:
		<action type="command" stdout="out" stderr="err" stdin="%''.join(names)" return_code="retval" />
		<action type="check" expr="%retval == 0 and err == ''" /> """
	
	def __init__(self, xml):
		ArgumentsContainer.__init__(self, xml)
		
		self.logger = actionLogger(xml)
		
		assert(self.cmd)
	
	def __repr__(self):
		return '<%s cmd=%r>' % (self.__class__.__name__, self.cmd)
	
	def __call__(self, env):
		cmd    = self[env].cmd
		stdout = self[env].stdout
		stderr = self[env].stderr
		stdin  = self[env].stdin
		ret    = self[env].return_code
		null   = stdout = stderr = open('/dev/null', 'w')
		
		if stdout: fdout = subprocess.PIPE
		if stderr: fderr = subprocess.PIPE
		
		args = [cmd]
		args.extend(self.evalout(env))
		
		self.logger.debug(repr((args, stdin, stdout, stderr, ret)))
		
		sub = subprocess.Popen(args, 0, cmd, subprocess.PIPE, fdout, fderr)
		if stdin: sub.stdin.write(stdin)
		sub.stdin.close()
		if stdout: env[stdout] = sub.stdout.read()
		if stderr: env[stderr] = sub.stderr.read()
		retcode = sub.wait()
		
		self.logger.debug("Exit code: %d" % retcode)
		
		if ret:
			env[ret] = retcode
			return True
		else:
			return (retcode == 0)

class Check(XML):
	""" Stop actions if expression is evlauted to False
	Usage: <action type="check" expr="%event_type == 'ButtonPressed' and event_class == 'power'" /> """
	
	def __init__(self, xml):
		self.xml = xml
		self.logger = actionLogger(xml)
		
		assert(self.expr)
	
	def __repr__(self):
		return '<%s expr=%r>' % (self.__class__.__name__, self.expr)
	
	def __call__(self, env):
		ret = self[env].expr
		if ret:
			return True
		else:
			return False

class Print(XML):
	""" Print evaluated expression (to logger)
	Usage: <action type="print" expr="%foo" logname="bar" /> """
	
	def __init__(self, xml):
		self.xml = xml
		self.logger = actionLogger(xml)
		self.logname = self.logname or "moo.actions.print"
		
		assert(self.expr)
	
	def __call__(self, env):
		ret = self[env].expr
		log = self[env].logname
		logging.getLogger(log).info(ret)
		
		return True

class Async(XML):
	""" Actions in a async group are independants - order of execution isn't guaranted,
	and failure of one action don't affect other actions """
	
	def __init__(self, xml):
		self.xml = xml
		self.logger = actionLogger(xml)
		self.actions = map(action_from_xml, get_childs(xml, 'action'))
	
	def __call__(self, env):
		for action in self.actions:
			self.logger.debug('Executing %r' % action)
			try:
				if action(env):
					self.logger.debug('OK')
				else:
					self.logger.debug('"normal" failure')
			except:
				self.logger.warning("Action failed. Error:\n %s" % format_exc())
		return True

class Sync(XML):
	""" Actions in a sync group are dependants - order of execution is guaranted,
	and failure of one action disallow excecution of following actions
	
	It's the same behavior as <signal> """
	
	def __init__(self, xml):
		self.xml = xml
		self.logger = actionLogger(xml)
		self.actions = map(action_from_xml, get_childs(xml, 'action'))
	
	def __call__(self, env):
		for action in self.actions:
			self.logger.debug('Executing %r', action)
			try:
				if not action(env):
					self.logger.debug('"normal" failure')
					return False
				else:
					self.logger.debug('OK')
			except:
				self.logger.warning("Action failed. Error:\n%s" % format_exc())
				return False
		
		return True

#
# Some constants
#
SessionBus = dbus.SessionBus()
SystemBus = dbus.SystemBus()
Actions = {
	'method': Method,
	'command': Command,
	'check': Check,
	'check': Check,
	'print': Print,
	'async': Async,
	'sync': Sync
}

#
# Let's go :)
#

if __name__ == "__main__":
	import gobject
	
	class SignalHandler(object):
		def __init__(self, bus, signals):
			self._bus = bus
			self._signals = signals
			self.logger = logging.getLogger("moo.sighandler")
		
		def __call__(self, *args, **kwargs):
			try:
				kwargs['args'] = args
				self._handle(**kwargs)
			except:
				self.logger.critical('REALLY unexpected error ! This went wrong:\n%s' % format_exc())
		
		def _handle(self, args, sender, destination, interface, member, path, **kwargs):
			if interface+"."+member == "org.freedesktop.DBus.NameOwnerChanged":
				# These signals are pretty useless and noisy, just get rid of them
				return
			
			if destination != None:
				self.logger.debug("Ignoring message for %s" % destination)
				return
			
			self.logger.debug("Received %s %s%s %s.%s%s" % (self._bus, sender, path, interface, member, args))
			
			for sig in self._signals:
				if sig.bus != None and sig.bus != self._bus:
					continue
				if sig.service != None and sig.service != sender:
					continue
				if sig.interface != None and sig.interface != interface:
					continue
				if sig.path != None and sig.path != path:
					continue
				if sig.name != None and sig.name != member:
					continue
				
				try:
					sig(args)
				except:
					self.logger.error("Can't dispatch signal %r. Error:\n%s" % (sig, format_exc()))
	
	signals = load_config()
	logger  = logging.getLogger("moo")
	logger.debug("Read config done")
	
	for bus in SystemBus,SessionBus:
		bus.add_signal_receiver(SignalHandler(bus, signals), sender_keyword = "sender", destination_keyword = "destination",
			interface_keyword = "interface", member_keyword = "member", path_keyword = "path")
	
	logger.info("Moo started")
	
	gobject.MainLoop().run()
