" cfengine syntax file
" Filename:     cfengine.vim
" Language:     cfengine configuration file 
" Maintainer:   Marcus Spading <ms@fragmentum.net>
" URL:          http://vim.sourceforge.net/scripts/script.php?script_id=329
" Last Change:  2003 Jan 29
" Version:      0.3
"
" Credits:      Brian Youngstrom <byoung@cs.washington.edu> (minor fixes)
"
" cfengine action
" action-type:
"   compound-class::
"       declaration

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case ignore

syn match   cfengineCompoundClass      "^\s*.*::\s*$"
"syn match   cfengineAssignmentOperator "="
syn match   cfengineLinkOperator       "[-+]>[!]\{0,1}"
syn match   cfengineVariable           "$(.\{-})"
syn match   cfengineVariable           "${.\{-}}"
syn region  cfengineVariableDef matchgroup=cfengineVariable start="(\s*" end="\s*)" contains=cfengineKeyword,cfengineHelpers,cfengineActions,cfengineIPAddress,cfengineVariable
syn match   cfengineNumber             "\<\d\+\|inf\>"
syn match   cfengineIPAddress          "\<\d\{1,3}.\d\{1,3}.\d\{1,3}.\d\{1,3}\>"
syn region  cfengineBlock  start="{" end="}" contains=cfengineBlock,cfengineEditAction,cfengineString,cfengineVariable
syn region  cfengineString start=+"+ skip=+\\\\\|\\"+ end=+"+ oneline contains=cfengineVariable containedin=cfengineBlock
syn region  cfengineString start=+'+ skip=+\\\\\|\\'+ end=+'+ oneline contains=cfengineVariable containedin=cfengineBlock

syn keyword cfengineBoolean    on off true false 

syn keyword cfengineKeyword    access actionsequence addclasses addinstallable binarypaddingchar
syn keyword cfengineKeyword    checksumdatabase checksumupdates childlibpath copylinks defaultcopytype
syn keyword cfengineKeyword    deletenonuserfiles deletenonownerfiles deletenonusermail deletenonownermail
syn keyword cfengineKeyword    domain dryrun editbinaryfilesize editfilesize emptyresolvconf exclamation
syn keyword cfengineKeyword    excludecopy excludelinks expireafter homepattern ifelapsed inform interfacename
syn keyword cfengineKeyword    fileextensions linkcopies logdirectory logtidyhomefiles moduledirectory
syn keyword cfengineKeyword    mountpattern netmask nonalphanumfiles nfstype repchar repository schedule
syn keyword cfengineKeyword    secureinputs sensiblecount sensiblesize showactions site faculty splaytime split 
syn keyword cfengineKeyword    smtpserver spooldirectories suspiciousnames sysadm syslog timezone timeout 
syn keyword cfengineKeyword    verbose warnings warnnonuserfiles warnnonownerfiles warnnonusermail warnnonownermail
" cfservd keywords
syn case match
syn keyword cfengineKeyword    AllowConnectionsFrom AllowMultipleConnectionsFrom AllowUser AutoExecCommand
syn keyword cfengineKeyword    AutoExecInterval cfrunCommand DenyBadClocks DenyConnectionsFrom IfElapsed
syn keyword cfengineKeyword    LogAllConnections MaxConnections TrustKeysFrom DynamicAddresses 
syn keyword cfengineKeyword    AllowRedefinitionOf AutoDefine ChecksumPurge DefaultPkgMgr HostnameKeys RPMcommand
syn keyword cfengineKeyword    SingleCopy SyslogFacility MultipleConnections MaxCfengines AllowUsers SkipVerify
syn keyword cfengineKeyword    BindToInterface HostnameKeys
syn case ignore

syn keyword cfengineActions    addmounts checktimezone copy directories disable editfiles files links mailcheck module
syn keyword cfengineActions    mountall mountinfo netconfig required resolve shellcommands tidy unmount processes
syn keyword cfengineActions    packages

syn region  cfengineHelpers    matchgroup=cfengineKeyword start="FileExists(" end=")"     contained oneline 
syn region  cfengineHelpers    matchgroup=cfengineKeyword start="IsDir(" end=")"          contained oneline 
syn region  cfengineHelpers    matchgroup=cfengineKeyword start="IsNewerThan(" end=")"    contained oneline 
syn region  cfengineHelpers    matchgroup=cfengineKeyword start="AccessedBefore(" end=")" contained oneline
syn region  cfengineHelpers    matchgroup=cfengineKeyword start="ChangedBefore(" end=")"  contained oneline
syn region  cfengineHelpers    matchgroup=cfengineKeyword start="IPRange(" end=")"        contained oneline
syn region  cfengineHelpers    matchgroup=cfengineKeyword start="IsLink(" end=")"         contained oneline
syn region  cfengineHelpers    matchgroup=cfengineKeyword start="IsPlain(" end=")"        contained oneline
syn region  cfengineHelpers    matchgroup=cfengineKeyword start="ReturnsZero(" end=")"    contained oneline

syn keyword cfengineOption     age acl dest m[ode] o[wner] g[roup] act[ion] silent fix preserve keep backup repository stealth timestamps
syn keyword cfengineOption     chroot chdir symlink incl[ude] excl[ude] ignore filter r[ecurse] type linktype typecheck define elsedefine
syn keyword cfengineOption     force forcedirs forceipv4 size server trustkey encrypt verify oldserver purge syslog inform
syn keyword cfengineOption     pat[tern] rotate flags links stop traverse tidy checksum matches dirlinks rmdirs deletedir deletefstab
syn keyword cfengineOption     xdev failover findertype deadlinks nofile expireafter cmp version useshell umask copytype
syn keyword cfengineOption     returnvars returnclasses pkgmgr rpm background preview noabspath ifelapsed 

syn keyword cfengineOptionVal  warnall warndirs warnplain
syn keyword cfengineOptionVal  fixall fixdirs fixplain
syn keyword cfengineOptionVal  touch linkchildren create compress alert
syn keyword cfengineOptionVal  stop traverse tidy md5 sha inf
syn keyword cfengineOptionVal  hard relative absolute checksum ctime kill force
syn keyword cfengineOptionVal  true false dump signal do warn bymatch 
syn keyword cfengineOptionVal  empty truncate all sub
syn keyword cfengineOptionVal  mtime atime
syn keyword cfengineOptionVal  symbolic none copy byte binary preserve keep on off

syn keyword cfengineSigVal     hup int quit ill trap iot emt fpe kill bus segv sys pipe alrm term urg stop
syn keyword cfengineSigVal     tstp cont chld gttin gttou io xcpu xfsz vtalrm prof winch lost usr1 usr2 

syn keyword cfengineEditAction AbortAtLineMatching Append contained
syn keyword cfengineEditAction AppendIfNoSuchLine AppendIfNoLineMatching AppendToLineIfNotContains contained
syn keyword cfengineEditAction AutoCreate AutomountDirectResources Backup contained
syn keyword cfengineEditAction BeginGroupIfDefined BeginGroupIfNotDefined contained
syn keyword cfengineEditAction BeginGroupIfFileExists BeginGroupIfFileIsNewer contained
syn keyword cfengineEditAction BeginGroupIfNoLineContaining BeginGroupIfNoLineMatching BeginGroupIfNoMatch BeginGroupIfNoSuchLine contained
syn keyword cfengineEditAction BreakIfLineMatches CatchAbort contained
syn keyword cfengineEditAction CommentLinesMatching CommentLinesStarting CommentNLines CommentToLineMatching contained
syn keyword cfengineEditAction DefineClasses DeleteLinesAfterThisMatching DeleteLinesContaining DeleteLinesMatching contained
syn keyword cfengineEditAction DeleteLinesStarting DeleteNLines DeleteToLineMatching contained
syn keyword cfengineEditAction EditMode EmptyEntireFilePlease ElseDefineClasses EndGroup EndLoop contained
syn keyword cfengineEditAction Filter FixEndOfLines ForEachLineIn GotoLastLine contained 
syn keyword cfengineEditAction HashCommentLinesContaining HashCommentLinesMatching HashCommentLinesStarting contained
syn keyword cfengineEditAction IncrementPointer Inform InsertFile InsertLine LocateLineMatching contained
syn keyword cfengineEditAction PercentCommentLinesContaining PercentCommentLinesMatching PercentCommentLinesStarting contained
syn keyword cfengineEditAction Prepend PrependIfNoLineMatching PrependifNoSuchLine contained
syn keyword cfengineEditAction Recurse ReplaceLineWith ReplaceAll ReplaceLinesMatchingField Repository contained
syn keyword cfengineEditAction ResetSearch RunScript RunScriptIfLineMatching RunScriptIfNoLineMatching contained
syn keyword cfengineEditAction SetCommentStart SetCommentEnd SetLine SetScript contained
syn keyword cfengineEditAction SlashCommentLinesContaining SlashCommentLinesMatching SlashCommentLinesStarting contained
syn keyword cfengineEditAction SplitOn Syslog Umask UnCommentLinesContaining UnCommentLinesMatching UnCommentNLines contained
syn keyword cfengineEditAction UnsetAbort UseShell WarnIfLineContaining WarnIfLineMatching WarnIfLineStarting contained
syn keyword cfengineEditAction WarnIfNoLineContaining WarnIfNoLineMatching WarnIfNoLineStarting WarnIfNoSuchLine contained
syn keyword cfengineEditAction ReplaceAll WarnIfContainsString WarnIfContainsFile contained
syn keyword cfengineEditAction DefineInGroup DeleteLinesNotMatching ExpireAfter IfElapsed contained

syn keyword cfengineFilter     Owner Atime Ctime Mtime FromAtime FromCtime FromMtime ToAtime ToCtime ToMtime contained
syn keyword cfengineFilter     Type reg link dir socket fifo door char block contained
syn keyword cfengineFilter     ExecRegex NameRegex IsSymLinkTo ExecProgram Result contained
syn keyword cfengineFilter     PID PPID PGID RSize VSize Status Command FromTTime ToTTime FromSTime ToSTime TTY contained
syn keyword cfengineFilter     Priority Threads contained
syn keyword cfengineFilter     Group Mode FromSize ToSize contained

syn keyword cfengineActionType control: files: acl: binservers: broadcast: control: copy: defaultroute:
syn keyword cfengineActionType disks: directories: disable: editfiles: files: filters: groups: classes:
syn keyword cfengineActionType homeservers: ignore: import: interfaces: links: mailserver: miscmounts:
syn keyword cfengineActionType mountables: processes: required: resolve: shellcommands: tidy: unmount: 
syn keyword cfengineActionType packages: alerts: admit: deny: methods:

" comments last overriding everything else
syn match   cfengineComment            "\s*#.*$" contains=cfengineTodo
syn keyword cfengineTodo               TODO NOTE FIXME XXX contained

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_cfengine_syn_inits")
  if version < 508
    let did_cfengine_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  "HiLink cfengineAssignmentOperator String
  HiLink cfengineLinkOperator       String
  HiLink cfengineVariable           Special
  HiLink cfengineVariableDef        NONE
  HiLink cfengineBoolean            Boolean
  HiLink cfengineEditAction         Identifier
  HiLink cfengineFilter             Identifier
  HiLink cfengineKeyword            Statement
  HiLink cfengineOption             Statement
  HiLink cfengineCompoundClass      Type
  HiLink cfengineActionType         PreProc
  HiLink cfengineActions            PreProc
  HiLink cfengineComment            Comment
  HiLink cfengineNumber             Number
  HiLink cfengineIPAddress          Number
  HiLink cfengineQuota              Number
  HiLink cfengineString             String
  HiLink cfengineTodo               Todo
  HiLink cfengineOptionVal          Constant
  HiLink cfengineSigVal             Constant

  delcommand HiLink
endif

let b:current_syntax = "cfengine"
