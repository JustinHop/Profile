" Filename:    spec.vim
" Purpose:     Vim syntax file
" Language:    SPEC: Build/install scripts for PLD Linux RPM packages
" Maintainer:  PLD Linux <feedback@pld-linux.org>
" URL:	       http://www.pld-linux.org/
" Last Change: $Date: 2012/01/25 22:13:20 $ (UTC)
" Version:     $Revision: 1.120 $

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" we're quite strict on spec syntax, so match case for everything
syn case match

syn sync minlines=1000

syn cluster specLimitedVisibility contains=specConfOpts,specConfOptsBcond,specConfOptsName,specDescriptionLimit

syn match specSpecialChar contained '[][!$()\\|>^;:]'
syn match specColon       contained ':'
syn match specPercent     contained '%'
syn match specSubstChar   contained '[#%]'

syn match specVariables   contained '\$\h\w*' contains=specSpecialVariablesNames,specSpecialChar
syn match specVariables   contained '\${\w*}' contains=specSpecialVariablesNames,specSpecialChar
syn match specVariables   contained '\${\w*[#%][^}]*}' contains=specSubstChar

syn match specMacroIdentifier contained '%\h\w*' contains=specMacroNameLocal,specMacroNameOther,specPercent,specSpecialChar
syn region specMacroIdentifier oneline matchgroup=Special start='%{' skip='\\}' end='}' contains=specConfOpts,specMacroNameLocal,specMacroNameOther,specPercent,specSpecialChar
syn match specBcond contained '%{with\(out\)\?\s\+[a-zA-Z0-9_-]\+}'

syn match specConfOpts contained '{\@<=__with\(_without\)\?' nextgroup=specConfOptsBcond
syn match specConfOpts contained '{\@<=__without' nextgroup=specConfOptsBcond
syn match specConfOpts contained '{\@<=__enable\(_disable\)\?' nextgroup=specConfOptsBcond
syn match specConfOpts contained '{\@<=__disable' nextgroup=specConfOptsBcond
syn match specConfOptsBcond contained '\s\+[a-zA-Z0-9_]\+' nextgroup=specConfOptsName
syn match specConfOptsName contained '\s\+[a-zA-Z0-9_-]\+'

syn match specSpecialVariables contained '\$[0-9]\|\${[0-9]}'
syn match specCommandOpts      contained '\(\s\|:\)\@<=\(-\w\+\|--\w[a-zA-Z0-9_-]\+\)'
syn match specComment '^\s*#.*$' contains=@specCommentGroup

" specTodo: contains common special-notices for comments
" Use the specCommentGroup cluster to add your own in vimrc
syn keyword specTodo contained	FIXME TODO XXX
syn cluster specCommentGroup	contains=specTodo,@Spell

" matches with no highlight
syn match specNoNumberHilite 'X11\|X11R6\|[a-zA-Z]*\.\d\|[a-zA-Z][-/]\d'
syn match specManpageFile '[a-zA-Z]\.1'

" Day, Month and most used license acronyms
syn keyword specLicense contained GPL LGPL BSD MIT GNU Apache PHP
syn keyword specLicenseWarning contained unknown
syn match specLicenseWarning contained /same as perl/
syn match specLicenseWarning contained "(enter GPL/LGPL/BSD/BSD-like/Artistic/other license name here)"
syn keyword specWeekday contained Mon Tue Wed Thu Fri Sat Sun
syn keyword specMonth   contained Jan Feb Mar Apr Jun Jul Aug Sep Oct Nov Dec
syn keyword specMonth   contained January February March April May June July August September October November December

" #, @, www
syn match specNumber '\(^-\=\|[ \t]-\=\|-\)[0-9.-]*[0-9]'
syn match specEmail contained "<\=\<[A-Za-z0-9_.-]\+@\([A-Za-z0-9_-]\+\.\)\+[A-Za-z]\+\>>\="
syn match specURL      contained '\<\(\(https\{0,1}\|ftp\)://\|\(www[23]\{0,1}\.\|ftp\.\)\)[A-Za-z0-9._/~:,#+?=-]\+\>'
syn match specURLMacro contained '\<\(\(https\{0,1}\|ftp\)://\|\(www[23]\{0,1}\.\|ftp\.\)\)[A-Za-z0-9._/~:,#+%{}-]\+\>' contains=specMacroIdentifier

" TODO take specSpecialVariables out of the cluster for the sh* contains (ALLBUT)
" Special system directories
syn match specListedFilesPrefix contained '/\(usr\|local\|opt\|X11R6\|X11\)/'me=e-1
syn match specListedFilesBin    contained '/s\=bin/'me=e-1
syn match specListedFilesLib    contained '/\(lib\|include\)/'me=e-1
syn match specListedFilesDoc    contained '/\(man\d*\|doc\|info\)\>'
syn match specListedFilesEtc    contained '/etc/'me=e-1
syn match specListedFilesShare  contained '/share/'me=e-1
syn cluster specListedFiles contains=specListedFilesBin,specListedFilesLib,specListedFilesDoc,specListedFilesEtc,specListedFilesShare,specListedFilesPrefix,specSpecialChar

" specComands
syn match   specConfigure  contained '\./configure'
syn match   specTarCommand contained '\<tar\s\+[cxvpzjf]\{,5}\s*'

" XXX don't forget to update specScriptArea when updating specMacro
syn match   specMacro contained '%\(group\|user\)\(add\|remove\)'
syn match   specMacro contained '%\(depmod\|banner\|service\|addusertogroup\|env_update\)'
syn match   specMacro contained '%\(\(nsplugin\|apache_config\)_\(un\)\?install\)'
syn match   specMacro contained '%\(\(openldap_schema\|webapp\)_\(un\)\?register\)'
syn match   specMacro contained '%\(pear_package_\(setup\|install\)\)'
syn match   specMacro contained '%\(py_o\?comp\|py_postclean\|py_lint\)'
syn match   specMacro contained '%\(build\|install\)_kernel_modules'
syn match   specMacro contained '%ant'
syn match   specMacro contained '%\(php\|php4\)_webserver_restart'
syn match   specMacro contained '%update_browser_plugins\|%browser_plugins_add_browser'
syn match   specMacro contained '%gconf_schema_\(un\)?install\|%glib_compile_schemas'
syn match   specMacro contained '%scrollkeeper_update_post\(un\)?'
syn match   specMacro contained '%update_icon_cache\|%update_mime_database'
syn match   specMacro contained '%update_desktop_database_post\|%update_desktop_database_postun'
syn match   specMacro contained '%undos'
syn match   specMacro contained '%nagios_nrpe'
syn match   specMacro contained '%cacti_import_template'

syn keyword specCommandSpecial contained root
syn keyword specCommand		contained make xmkmf mkdir chmod find sed rm strip moc echo grep ls rm mv mkdir chown install cp pwd cat tail then else elif cd gzip rmdir ln eval export touch unzip bzip2
syn cluster specCommands contains=specCommand,specTarCommand,specConfigure,specCommandSpecial,specMacro

" frequently used rpm env vars
syn keyword specSpecialVariablesNames contained RPM_BUILD_ROOT RPM_BUILD_DIR RPM_SOURCE_DIR RPM_OPT_FLAGS LDFLAGS CC CC_FLAGS CPPNAME CFLAGS CXX CXXFLAGS CPPFLAGS

" valid macro names from /usr/lib/rpm/macros*
syn keyword specMacroNameOther contained ix86 x8664 ppc arm
syn keyword specMacroNameOther contained bootstrap_release buildrequires_jdk buildroot buildsubdir distribution disturl name nil optflags perl_sitearch release requires_eq vendor version
syn keyword specMacroNameOther contained __kernel_ver date debugcflags debuginfocflags epoch kgcc kgcc_package packager
syn keyword specMacroNameOther contained pear_package_install pear_package_setup perl_archlib perl_privlib perl_sitelib
syn keyword specMacroNameOther contained perl_vendorarch perl_vendorlib php_pear_dir php_data_dir py_sitedir py_scriptdir py_sitescriptdir
syn keyword specMacroNameOther contained required_jdk requires_php_extension requires_php_pdo_module
syn keyword specMacroNameOther contained requires_zend_extension ruby_mod_ver_requires_eq ruby_ver_requires_eq rpmcflags rpmcppflags rpmcxxflags rpmldflags tmpdir
syn keyword specMacroNameOther contained ruby_archdir ruby_rubylibdir ruby_vendorarchdir ruby_vendorlibdir ruby_ridir ruby_sitearchdir ruby_sitelibdir ruby_version ruby_rdocdir
syn keyword specMacroNameOther contained apache_modules_api php_sysconfdir php_includedir php_extensiondir _browserpluginsdir _browserpluginsconfdir
syn keyword specMacroNameOther contained releq_kernel releq_kernel_up releq_kernel_smp requires_releq_kernel requires_releq_kernel_up requires_releq_kernel_smp
syn keyword specMacroNameOther contained pyrequires_eq
syn keyword specMacroNameOther contained nodejs_libdir

syn match   specMacroNameOther contained '\<\(PATCH\|SOURCE\)\d*\>'

" valid _macro names from /usr/lib/rpm/macros*
syn keyword specMacroNameLocal contained _aclocaldir _applnkdir _arch _binary_payload _bindir _build _build_arch _build_alias
syn keyword specMacroNameLocal contained _build_cpu _builddir _build_os _buildshell _buildsubdir _build_vendor _bzip2bin _datadir
syn keyword specMacroNameLocal contained _dbpath _dbpath_rebuild _defaultdocdir _desktopdir _docdir _examplesdir _excludedocs _kdedocdir
syn keyword specMacroNameLocal contained _exec_prefix _fixgroup _fixowner _fixperms _fontsdir _ftpport _ftpproxy _gnu _gpg_name
syn keyword specMacroNameLocal contained _gpg_path _gtkdocdir _gzipbin _host _host_alias _host_cpu _host_os _host_vendor
syn keyword specMacroNameLocal contained _httpport _httpproxy _iconsdir _includedir _infodir _initrddir _install_langs
syn keyword specMacroNameLocal contained _install_script_path _instchangelog _javaclasspath _javadir _javadocdir _javasrcdir _kernelsrcdir
syn keyword specMacroNameLocal contained _kernel_ver _kernel_ver_str _kernel_vermagic _langpatt _lib _libdir _libexecdir _localstatedir _mandir
syn keyword specMacroNameLocal contained _netsharedpath _oldincludedir _omf_dest_dir _os _package_version _pgpbin _pgp_name
syn keyword specMacroNameLocal contained _pgp_path _pixmapsdir _pkgconfigdir _npkgconfigdir _prefix _preScriptEnvironment _provides _rpmdir
syn keyword specMacroNameLocal contained _rpmfilename _sbindir _sharedstatedir _signature _smp_mflags _sourcedir _source_payload
syn keyword specMacroNameLocal contained _specdir _srcrpmdir _sysconfdir _target _target_alias _target_cpu _target_os _target_platform
syn keyword specMacroNameLocal contained _target_vendor _target_base_arch _timecheck _tmppath _topdir _usr _usrsrc _var _vendor
syn keyword specMacroNameLocal contained __cxx __cc __ar __libtoolize __autopoint __aclocal __autoconf __automake __autoheader __gnome_doc_common
syn keyword specMacroNameLocal contained __gettextize __glib_gettextize __gtkdocize __intltoolize
syn keyword specMacroNameLocal contained __bzip2 __cat __chgrp __chmod __chown __cp   __cpio __file __gpg __grep __gzip
syn keyword specMacroNameLocal contained __id  __install __ld   __make   __mkdir __mkdir_p __mv __nm  __objcopy __objdump
syn keyword specMacroNameLocal contained __patch __perl __pgp __python __rm __rsh  __sed __ssh __strip  __tar __unzip __lzma
" jpackage macros (defined in macros.build)
syn keyword specMacroNameLocal contained _jnidir _jvmdir _jvmjardir _jvmprivdir _jvmlibdir _jvmdatadir _jvmsysconfdir _jvmcommonlibdir _jvmcommondatadir _jvmcommonsysconfdir
syn keyword specMacroNameLocal contained java_home jar java javac javadoc


" ------------------------------------------------------------------------------
" here's is all the spec sections definitions: PreAmble, Description, Package,
"   Scripts, Files and Changelog

" One line macros - valid in all ScriptAreas
" tip: remember do include new items on specScriptArea's skip section
syn region specSectionMacroArea oneline matchgroup=specSectionMacro start='^%\(\(un\)\?define\|dump\|trace\|patch\d*\|setup\|configure2_13\|configure\|GNUconfigure\|find_lang\|makeinstall\|cmake\|scons\|waf\|bcond_with\(out\)\?\|include\)\>' end='$' contains=specCommandOpts,specMacroIdentifier,specSectionMacroBcondArea
syn region specSectionMacroBracketArea oneline matchgroup=specSectionMacro start='^%{\(configure2_13\|configure\|GNUconfigure\|find_lang\|makeinstall\|cmake\|scons\|waf\)}' end='$' contains=specCommandOpts,specMacroIdentifier
syn region specSectionMacroBcondArea oneline matchgroup=specBlock start='%{!\??\(with\(out\)\?_[a-zA-Z0-9_]\+\|debug\):' skip='\\}' end='}' contains=ALLBUT,@specLimitedVisibility

" %% Files Section %%
" TODO %config valid parameters: missingok\|noreplace
" TODO %verify valid parameters: \(not\)\= \(md5\|atime\|...\)
syn region specFilesArea matchgroup=specSection start="^%files\>"
	\ skip="%\(attrib\|defattr\|attr\|dir\|config\|docdir\|doc\|lang\|verify\|ghost\|exclude\|dev\|if\|ifarch\|ifnarch\|else\|endif\)\>"
	\ end='^%[a-zA-Z]'me=e-2
	\ contains=specFilesOpts,specFilesDirective,@specListedFiles,specComment,specCommandSpecial,specMacroIdentifier,specSectionMacroBcondArea,specIf

" tip: remember to include new items in specFilesArea above
syn match  specFilesDirective contained '%\(dir\|docdir\|doc\|ghost\|exclude\)\>'
syn region specFilesDirective contained start="%\(attrib\|attr\|defattr\|config\|lang\|verify\|dev\)(" end=")" contains=specAttr transparent
syn match  specAttr contained "%\(attrib\|attr\|defattr\|config\|lang\|verify\|dev\)"

" valid options for certain section headers
syn match specDescriptionOpts contained '\s-[ln]\s\a'ms=s+1,me=e-1 contains=specDescriptionCharset
"syn match specDescriptionOptLang contained '\s-l\s*[a-zA-Z0-9.-]\+'ms=s+1
syn match specPackageOpts     contained    '\s-n\s*\w'ms=s+1,me=e-1
syn match specFilesOpts       contained    '\s-f\s*\w'ms=s+1,me=e-1

" charset: et,et.UTF-8,pl.UTF-8,pt_BR, ... etc
syn match specDescriptionCharset         contained '-l\s[a-z_A-Z]\+\(\.UTF-8\)\?'ms=s+2
syn match specPreAmbleCharset         contained '([a-z_A-Z]\+\(\.UTF-8\)\?):'

" limit description width to 70 columns
syn match specDescriptionLimit contained '\%>70v.\+'

" %% PreAmble Section %%
" Copyright and Serial were deprecated by License and Epoch
" PreReq and BuildPreReq deprecated by Requires ans BuildRequires
syn region specPreAmbleDeprecated oneline matchgroup=specError start='^\(Copyright\|Serial\|PreReq\|BuildPreReq\(uires\)\?\)' end='$' contains=specEmail,specURL,specURLMacro,specLicense,specColon,specVariables,specSpecialChar,specMacroIdentifier
syn region specPreAmble oneline matchgroup=specPreambleField
	\ start='\(^\|\(^%{!\??\(with\(out\)\?_[a-zA-Z0-9_]\+\|debug\):\)\@<=\)\(Name\|Version\|Packager\|Requires\|Suggests\|Icon\|URL\|Source\d*\|Patch\d*\|Prefix\|Packager\|Group\|License\|Release\|BuildRoot\|Distribution\|Vendor\|Provides\|ExclusiveArch\|ExcludeArch\|ExclusiveOS\|Obsoletes\|BuildArch\|BuildArchitectures\|BuildRequires\|BuildConflicts\|Conflicts\|AutoRequires\|AutoReqProv\|AutoReq\|AutoProv\|Epoch\|NoSource\)'
	\ end='$\|}\@='
	\ contains=specEmail,specURL,specURLMacro,specLicense,specLicenseWarning,specColon,specVariables,specSpecialChar,specMacroIdentifier,specSectionMacroBcondArea

syn region specPreAmble oneline matchgroup=specPreambleField
	\ start='\(Summary\)'
	\ end='$\|}\@='
	\ contains=specPreambleCharset,specURLMacro,specMacroIdentifier,specSectionMacroBcondArea

" %% Description Section %%
syn region specDescriptionArea matchgroup=specSection start='^%description' end='^%'me=e-1
	\ contains=specDescriptionOpts,specEmail,specURL,specNumber,specMacroIdentifier,specComment,specDescriptionLimit

" %% Package Section %%
syn region specPackageArea matchgroup=specSection start='^%package' end='^%'me=e-1
	\ contains=specPackageOpts,specPreAmble,specComment,specMacroNameOther

" %% Scripts Section %%
syn region specScriptArea matchgroup=specSection
	\ start='^%\(prep\|build\|install\|clean\|pre\|postun\|preun\|post\|triggerprein\|triggerin\|triggerun\|triggerpostun\|pretrans\|posttrans\|verifyscript\|check\)\>'
	\ skip='^%{\|^%\(define\|patch\d*\|configure2_13\|configure\|ant\|GNUconfigure\|setup\|find_lang\|makeinstall\|cmake\|scons\|waf\|useradd\|groupadd\|addusertogroup\|banner\|service\|env_update\|py_o\?comp\|py_postclean\|py_lint\|\(openldap_schema\|webapp\)_\(un\)\?register\|depmod\|pear_package_\(setup\|install\)\|\(build\|install\)_kernel_modules\|php_webserver_restart\|php4_webserver_restart\|update_browser_plugins\|gconf_schema_\(un\)?install\|glib_compile_schemas\|scrollkeeper_update_post\(un\)?\|update_icon_cache\|update_mime_database\|undos\|nagios_nrpe\|cacti_import_template\)\>'
	\ end='^%'me=e-1
	\ contains=specSpecialVariables,specVariables,@specCommands,specVariables,shDo,shFor,shCaseEsac,specNoNumberHilite,specCommandOpts,shComment,shIf,specSpecialChar,specMacroIdentifier,specSectionMacroArea,specSectionMacroBracketArea,shOperator,shQuote1,shQuote2,specSectionMacroBcondArea
" XXX don't forget to update specMacro when updating specScriptArea skip definition

" %% Changelog Section %%
syn region specChangelogArea matchgroup=specSection start='^%changelog' end='^%'me=e-1
	\ contains=specEmail,specURL,specWeekday,specMonth,specNumber,specComment,specLicense,specRevision,specLogMessage,specLogError

syn match specRevision contained "^Revision [.0-9]\+  [-/0-9]\+ [:0-9]\+  [a-zA-Z0-9.]\+$"
syn region specLogMessage contained start="^[- ] " end="$" contains=specLogError,specURL,specEmail
syn match specLogError contained "%%"

" ------------------------------------------------------------------------------
" here's the shell syntax for all the Script Sections

" sh-like comment style, only valid in script part
syn match shComment contained '#.*$' contains=@specCommentGroup

syn region shQuote1 contained matchgroup=shQuoteDelim start=+'+ skip=+\\'+ end=+'+ contains=specMacroIdentifier
syn region shQuote2 contained matchgroup=shQuoteDelim start=+"+ skip=+\\"+ end=+"+ contains=specVariables,specMacroIdentifier,specSectionMacroBcondArea

syn match shOperator contained '[><|!&;]\|[!=]='
syn region shDo transparent matchgroup=specBlock start="\(^\|\s\)do\(\s\|$\)" end="\(^\|\s\)done\(\s\|$\)" contains=ALLBUT,shDoError,shCase,specPreAmble,@specListedFiles,@specLimitedVisibility
syn region shIf transparent matchgroup=specBlock start="\(^\|\s\)if\(\s\|$\)" end="\(^\|\s\)fi\(\s\|$\)" contains=ALLBUT,shIfError,shCase,@specListedFiles,@specLimitedVisibility
syn region shFor  matchgroup=specBlock start="\(^\|\s\)for\(\s\|$\)" end="\(^\|\s\)in\(\s\|$\)" contains=ALLBUT,shInError,shCase,@specListedFiles,@specLimitedVisibility

syn region shCaseEsac transparent matchgroup=specBlock start="\(^\|\s\)case\(\s\|$\)" matchgroup=NONE end="\(^\|\s\)in\(\s\|$\)"me=s-1 contains=ALLBUT,@specListedFiles,@specLimitedVisibility nextgroup=shCaseEsac
syn region shCaseEsac matchgroup=specBlock start="\(^\|\s\)in\(\s\|$\)" end="\(^\|\s\)esac\(\s\|$\)" contains=ALLBUT,@specListedFilesBin,@specLimitedVisibility
syn region shCase matchgroup=specBlock contained start=")"  end=";;" contains=ALLBUT,shCase,@specListedFiles,@specLimitedVisibility

syn sync match shDoSync       grouphere  shDo       "\<do\>"
syn sync match shDoSync       groupthere shDo       "\<done\>"
syn sync match shIfSync       grouphere  shIf       "\<if\>"
syn sync match shIfSync       groupthere shIf       "\<fi\>"
syn sync match shForSync      grouphere  shFor      "\<for\>"
syn sync match shForSync      groupthere shFor      "\<in\>"
syn sync match shCaseEsacSync grouphere  shCaseEsac "\<case\>"
syn sync match shCaseEsacSync groupthere shCaseEsac "\<esac\>"

syn region specIf  matchgroup=specBlock start="%ifosf\|%ifos\|%ifnos\|%ifarch\|%ifnarch\|ifdef\|ifndef\|%if\|%else"  end='%endif' contains=ALLBUT,specOutSkip,specOut2,@specLimitedVisibility

" %if 0 handing
if exists("spec_if0")
    syn region specOut start="^\s*%if\s\+0$" end="$" contains=specOut2
    syn region specOut2 contained start="%if\s\+0" end="^\s*%\(endif\>\|else\>\)" contains=specOutSkip

    syn region specOutSkip contained start="^\s*%if\>" end="^\s*%endif\>" contains=specOutSkip

    syn sync match specIfSync     grouphere  specIf     "%ifarch\|%ifos\|%ifnos"
    syn sync match specIfSync     groupthere specIf     "%endIf"
endif

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_spec_syntax_inits")
  if version < 508
    let did_spec_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  "main types color definitions
  HiLink specSection			Structure
  HiLink specSectionMacro		Macro
  HiLink specWWWlink			PreProc
  HiLink specOpts			Operator

  "yes, it's ugly, but white is sooo cool
  if &background == "dark"
    hi def specGlobalMacro		ctermfg=white
  else
    HiLink specGlobalMacro		Identifier
  endif

  "sh colors
  HiLink shComment			Comment
  HiLink shIf				Statement
  HiLink shOperator			Special
  HiLink shQuote1			String
  HiLink shQuote2			String
  HiLink shQuoteDelim			Statement

  " spec colors
  HiLink specBlock			Function
  HiLink specBcond			Function
  HiLink specConfOpts			specOpts
  HiLink specConfOptsBcond		Function
  HiLink specConfOptsName		specOpts
  HiLink specColon			Special
  HiLink specCommand			Statement
  HiLink specPreambleField		Statement
  HiLink specCommandOpts		specOpts
  HiLink specCommandSpecial		Special
  HiLink specComment			Comment
  HiLink specConfigure			specCommand
  HiLink specDate			String
  HiLink specPreAmbleCharset		String
  HiLink specDescriptionCharset		String
  HiLink specDescriptionLimit		Error
  HiLink specDescriptionOpts		specOpts
  HiLink specEmail			specWWWlink
  HiLink specError			Error
  HiLink specFilesDirective		specSectionMacro
  HiLink specAttr			specSectionMacro
  HiLink specFilesOpts			specOpts
  HiLink specLicense			String
  HiLink specLicenseWarning		specError
  HiLink specMacroNameLocal		specGlobalMacro
  HiLink specMacroNameOther		specGlobalMacro
  HiLink specManpageFile		NONE
  HiLink specMonth			specDate
  HiLink specNoNumberHilite		NONE
  HiLink specNumber			Number
  HiLink specPackageOpts		specOpts
  HiLink specPercent			Special
  HiLink specSpecialChar		Special
  HiLink specSubstChar			Special
  HiLink specSpecialVariables		specGlobalMacro
  HiLink specSpecialVariablesNames	specGlobalMacro
  HiLink specTarCommand			specCommand
  HiLink specTodo			Todo
  HiLink specMacro			Macro
  HiLink specURL			specWWWlink
  HiLink specURLMacro			specWWWlink
  HiLink specVariables			Identifier
  HiLink specWeekday			specDate
  HiLink specListedFilesBin		Statement
  HiLink specListedFilesDoc		Statement
  HiLink specListedFilesEtc		Statement
  HiLink specListedFilesLib		Statement
  HiLink specListedFilesPrefix		Statement
  HiLink specListedFilesShare		Statement

  HiLink specRevision			Number
  HiLink specLogMessage			Identifier
  HiLink specLogError			Error

  HiLink specOutSkip            specOut
  HiLink specOut2            specOut
  HiLink specOut             Comment

  delcommand HiLink
endif

let b:current_syntax = "spec"

" vim: ts=8
