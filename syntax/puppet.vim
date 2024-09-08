" Language:     Puppet
" Maintainer:   Voxpupuli
" URL:          https://github.com/voxpupuli/vim-puppet
"
" Thanks to Doug Kearns who maintains the vim syntax file for Ruby. Many constructs, including interpolation
" and heredoc was copied from ruby and then modified to comply with Puppet syntax.

" Prelude {{{1
if exists('b:current_syntax')
  finish
endif

" this file uses line continuations
let s:cpo_sav = &cpo
set cpo&vim

syn cluster puppetNotTop contains=@puppetExtendedStringSpecial,@puppetRegexpSpecial,puppetConditional,puppetTodo

syn match puppetSpaceError display excludenl "\s\+$"
syn match puppetSpaceError display " \+\t\+\%( \|\t\)*\|\t\+ \+\%( \|\t\)*"

" one character operators
syn match  puppetOperator "[=><+/*%!.|@:,;?~-]"

" two character operators
syn match  puppetOperator "+=\|-=\|==\|!=\|=\~\|!\~\|>=\|<=\|<-\|<\~\|=>\|+>\|->\|\~>\|<<\||>\|@@"

" three character operators
syn match  puppetOperator "<<|\||>>"

syn region puppetBracketBlock transparent matchgroup=puppetBracket start="\[" end="]" fold contains=ALLBUT,@puppetNotTop
syn region puppetBraceBlock transparent matchgroup=puppetBrace start="{" end="}" fold contains=ALLBUT,@puppetNotTop
syn region puppetParenBlock transparent matchgroup=puppetParen start="(" end=")" fold contains=ALLBUT,@puppetNotTop

" Expression Substitution and Backslash Notation {{{1
syn match puppetStringEscape "\\\\\|\\[abefnrstv]\|\\\o\{1,3}\|\\x\x\{1,2}" contained display
syn match puppetStringEscape "\%(\\M-\\C-\|\\C-\\M-\|\\M-\\c\|\\c\\M-\|\\c\|\\C-\|\\M-\)\%(\\\o\{1,3}\|\\x\x\{1,2}\|\\\=\S\)" contained display
syn match puppetQuoteEscape  "\\[\\']" contained display

syn region puppetNoInterpolation contained transparent start="\\${" end="}"
syn match  puppetNoInterpolation display contained "\\${"
syn match  puppetNoInterpolation display contained "\\$\w\+"
syn region puppetInterpolation transparent matchgroup=puppetInterpolationDelimiter start="${" end="}" contained contains=ALLBUT,@puppetNotTop
syn match  puppetInterpolation "$\%(::\)\?\w\+"                        display contained contains=puppetInterpolationDelimiter,puppetVariable
syn match  puppetInterpolation "$\$\%(-\w\|\W\)"              display contained contains=puppetInterpolationDelimiter,puppetVariable
syn match  puppetInterpolationDelimiter "$\ze\$\w\+"            display contained
syn match  puppetInterpolationDelimiter "$\ze\$\%(-\w\|\W\)"    display contained

syn match puppetDelimiterEscape	"\\[(<{\[)>}\]]" transparent display contained contains=NONE

syn region puppetNestedParentheses    start="("  skip="\\\\\|\\)"  matchgroup=puppetString end=")"	transparent contained
syn region puppetNestedCurlyBraces    start="{"  skip="\\\\\|\\}"  matchgroup=puppetString end="}"	transparent contained
syn region puppetNestedAngleBrackets  start="<"  skip="\\\\\|\\>"  matchgroup=puppetString end=">"	transparent contained
syn region puppetNestedSquareBrackets start="\[" skip="\\\\\|\\\]" matchgroup=puppetString end="\]"	transparent contained

" Regular Expression Metacharacters {{{1
" These are mostly Oniguruma ready
syn region puppetRegexpComment	matchgroup=puppetRegexpSpecial   start="(?#"	skip="\\)"  end=")"  contained
syn region puppetRegexpParens	matchgroup=puppetRegexpSpecial   start="(\(?:\|?<\=[=!]\|?>\|?<[a-z_]\w*>\|?[imx]*-[imx]*:\=\|\%(?#\)\@!\)" skip="\\)"  end=")"  contained transparent contains=@puppetRegexpSpecial
syn region puppetRegexpBrackets	matchgroup=puppetRegexpCharClass start="\[\^\=" skip="\\\]" end="\]" contained transparent contains=puppetStringEscape,puppetRegexpEscape,puppetRegexpCharClass oneline
syn match  puppetRegexpCharClass	"\\[DdHhSsWw]"	       contained display
syn match  puppetRegexpCharClass	"\[:\^\=\%(alnum\|alpha\|ascii\|blank\|cntrl\|digit\|graph\|lower\|print\|punct\|space\|upper\|xdigit\):\]" contained
syn match  puppetRegexpEscape	"\\[].*?+^$|\\/(){}[]" contained
syn match  puppetRegexpQuantifier	"[*?+][?+]\="	       contained display
syn match  puppetRegexpQuantifier	"{\d\+\%(,\d*\)\=}?\=" contained display
syn match  puppetRegexpAnchor	"[$^]\|\\[ABbGZz]"     contained display
syn match  puppetRegexpDot	"\."		       contained display
syn match  puppetRegexpSpecial	"|"		       contained display
syn match  puppetRegexpSpecial	"\\[1-9]\d\=\d\@!"     contained display
syn match  puppetRegexpSpecial	"\\k<\%([a-z_]\w*\|-\=\d\+\)\%([+-]\d\+\)\=>" contained display
syn match  puppetRegexpSpecial	"\\k'\%([a-z_]\w*\|-\=\d\+\)\%([+-]\d\+\)\='" contained display
syn match  puppetRegexpSpecial	"\\g<\%([a-z_]\w*\|-\=\d\+\)>" contained display
syn match  puppetRegexpSpecial	"\\g'\%([a-z_]\w*\|-\=\d\+\)'" contained display

syn cluster puppetStringSpecial	      contains=puppetInterpolation,puppetNoInterpolation,puppetStringEscape
syn cluster puppetExtendedStringSpecial contains=@puppetStringSpecial,puppetNestedParentheses,puppetNestedCurlyBraces,puppetNestedAngleBrackets,puppetNestedSquareBrackets
syn cluster puppetRegexpSpecial	      contains=puppetRegexpSpecial,puppetRegexpEscape,puppetRegexpBrackets,puppetRegexpCharClass,puppetRegexpDot,puppetRegexpQuantifier,puppetRegexpAnchor,puppetRegexpParens,puppetRegexpComment

syn match puppetInteger	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<0[xX]\x\+r\=i\=\>" display
syn match puppetInteger	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<\%(0\|[1-9]\d*\)r\=i\=\>" display
syn match puppetInteger	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<0\o\+r\=i\=\>" display
syn match puppetFloat	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<\%(0\|[1-9]\d*\)\.\d\+r\=i\=\>" display
syn match puppetFloat	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<\%(0\|[1-9]\d*\)\%(\.\d\+\)\=[eE][-+]\=\d\+r\=i\=\>" display
" order of matches is important. The following need to be placed after the ones above
syn match puppetInvalidNumber	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\%(\|\<0\d\+\)\.\d\+\>" display
syn match puppetInvalidNumber	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<0[xX]\x\+\.\x\+\>" display
syn match puppetInvalidNumber	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<0\o*[89]\d*\>" display

syn match puppetVariable "$\%(::\)\=\w\+\%(::\w\+\)*" display
syn match puppetName "\%(::\)\=[a-z]\w*\%(::[a-z]\w*\)*" display
syn match puppetType "\%(::\)\=[A-Z]\w*\%(::[A-Z]\w*\)*" display
syn match puppetWord "\%(\%(::\)\=\%(_[\w-]*\w\+\)\|\%([a-z]\%(\w*-\)\+\w\+\)\)\+" display

" bad name containing combinations of segment starting with lower case and segement starting with upper case (or vice versa)
syn match puppetNameBad "\%(::\)\=\%(\w\+::\)*\%(\%([a-z]\w*::[A-Z]\w*\)\|\%([A-Z]\w*::[a-z]\w*\)\)\%(::\w\+\)*" display
syn cluster puppetNameOrType contains=puppetVariable,puppetName,puppetType,puppetWord,puppetNameBad

syn keyword puppetControl  case and or in
syn keyword puppetStructure node class define plan
syn keyword puppetKeyword  inherits function type attr private
syn keyword puppetKeyword  application consumes produces site component environment unit
syn keyword puppetKeyword  present absent purged latest installed running stopped mounted unmounted role configured
syn keyword puppetKeyword  file directory link on_failure regexp
syn keyword puppetConstant default undef
syn keyword puppetConditional if else elsif unless
syn keyword puppetBoolean  true false

" Core functions that include more code
syn match puppetIncludeFunction "\<contain\>"
syn match puppetIncludeFunction "\<create_resources\>"
syn match puppetIncludeFunction "\<include\>"
syn match puppetIncludeFunction "\<hiera_include\>"

" Core functions
syn match puppetFunction "\<alert\>"
syn match puppetFunction "\<assert_type\>"
syn match puppetFunction "\<binary_file\>"
syn match puppetFunction "\<break\>"
syn match puppetFunction "\<crit\>"
syn match puppetFunction "\<debug\>"
syn match puppetFunction "\<defined\>"
syn match puppetFunction "\<dig\>"
syn match puppetFunction "\<each\>"
syn match puppetFunction "\<emerg\>"
syn match puppetFunction "\<epp\>"
syn match puppetFunction "\<err\>"
syn match puppetFunction "\<fail\>"
syn match puppetFunction "\<file\>"
syn match puppetFunction "\<filter\>"
syn match puppetFunction "\<find_file\>"
syn match puppetFunction "\<fqdn_rand\>"
syn match puppetFunction "\<hiera\>"
syn match puppetFunction "\<hiera_array\>"
syn match puppetFunction "\<hiera_hash\>"
syn match puppetFunction "\<info\>"
syn match puppetFunction "\<inline_epp\>"
syn match puppetFunction "\<lest\>"
syn match puppetFunction "\<lookup\>"
syn match puppetFunction "\<map\>"
syn match puppetFunction "\<match\>"
syn match puppetFunction "\<new\>"
syn match puppetFunction "\<next\>"
syn match puppetFunction "\<notice\>"
syn match puppetFunction "\<realize\>"
syn match puppetFunction "\<reduce\>"
syn match puppetFunction "\<regsubst\>"
syn match puppetFunction "\<require\>"
syn match puppetFunction "\<return\>"
syn match puppetFunction "\<reverse_each\>"
syn match puppetFunction "\<scanf\>"
syn match puppetFunction "\<sha1\>"
syn match puppetFunction "\<shellquote\>"
syn match puppetFunction "\<slice\>"
syn match puppetFunction "\<split\>"
syn match puppetFunction "\<sprintf\>"
syn match puppetFunction "\<step\>"
syn match puppetFunction "\<strftime\>"
syn match puppetFunction "\<tag\>"
syn match puppetFunction "\<tagged\>"
syn match puppetFunction "\<template\>"
syn match puppetFunction "\<then\>"
syn match puppetFunction "\<type\>"
syn match puppetFunction "\<unwrap\>"
syn match puppetFunction "\<versioncmp\>"
syn match puppetFunction "\<warning\>"
syn match puppetFunction "\<with\>"

" deprecated Core functions
syn match puppetDeprecated "\<import\>"

" puppet bolt functions
syn match puppetFunction "\<add_facts\>"
syn match puppetFunction "\<add_to_group\>"
syn match puppetFunction "\<apply\>"
syn match puppetFunction "\<apply_prep\>"
syn match puppetFunction "\<background\>"
syn match puppetFunction "\<catch_errors\>"
syn match puppetFunction "\<ctrl::do_until\>"
syn match puppetFunction "\<ctrl::sleep\>"
syn match puppetFunction "\<dir::children\>"
syn match puppetFunction "\<download_file\>"
syn match puppetFunction "\<fail_plan\>"
syn match puppetFunction "\<file::delete\>"
syn match puppetFunction "\<file::exists\>"
syn match puppetFunction "\<file::join\>"
syn match puppetFunction "\<file::read\>"
syn match puppetFunction "\<file::readable\>"
syn match puppetFunction "\<file::write\>"
syn match puppetFunction "\<get_resources\>"
syn match puppetFunction "\<get_target\>"
syn match puppetFunction "\<get_targets\>"
syn match puppetFunction "\<log::debug\>"
syn match puppetFunction "\<log::error\>"
syn match puppetFunction "\<log::fatal\>"
syn match puppetFunction "\<log::info\>"
syn match puppetFunction "\<log::trace\>"
syn match puppetFunction "\<log::warn\>"
syn match puppetFunction "\<out::message\>"
syn match puppetFunction "\<out::verbose\>"
syn match puppetFunction "\<parallelize\>"
syn match puppetFunction "\<prompt\>"
syn match puppetFunction "\<prompt::menu\>"
syn match puppetFunction "\<puppetdb_command\>"
syn match puppetFunction "\<puppetdb_fact\>"
syn match puppetFunction "\<puppetdb_query\>"
syn match puppetFunction "\<remove_from_group\>"
syn match puppetFunction "\<resolve_references\>"
syn match puppetFunction "\<resource\>"
syn match puppetFunction "\<run_command\>"
syn match puppetFunction "\<run_container\>"
syn match puppetFunction "\<run_plan\>"
syn match puppetFunction "\<run_script\>"
syn match puppetFunction "\<run_task\>"
syn match puppetFunction "\<run_task_with\>"
syn match puppetFunction "\<set_config\>"
syn match puppetFunction "\<set_feature\>"
syn match puppetFunction "\<set_resources\>"
syn match puppetFunction "\<set_var\>"
syn match puppetFunction "\<system::env\>"
syn match puppetFunction "\<upload_file\>"
syn match puppetFunction "\<vars\>"
syn match puppetFunction "\<wait\>"
syn match puppetFunction "\<wait_until_available\>"
syn match puppetFunction "\<without_default_logging\>"
syn match puppetFunction "\<write_file\>"

" Stdlib functions
syn match puppetStdLibFunction "\<any2array\>"
syn match puppetStdLibFunction "\<any2bool\>"
syn match puppetStdLibFunction "\<assert_private\>"
syn match puppetStdLibFunction "\<base64\>"
syn match puppetStdLibFunction "\<basename\>"
syn match puppetStdLibFunction "\<bool2num\>"
syn match puppetStdLibFunction "\<bool2str\>"
syn match puppetStdLibFunction "\<clamp\>"
syn match puppetStdLibFunction "\<concat\>"
syn match puppetStdLibFunction "\<convert_base\>"
syn match puppetStdLibFunction "\<count\>"
syn match puppetStdLibFunction "\<deep_merge\>"
syn match puppetStdLibFunction "\<defined_with_params\>"
syn match puppetStdLibFunction "\<delete\>"
syn match puppetStdLibFunction "\<delete_at\>"
syn match puppetStdLibFunction "\<delete_regex\>"
syn match puppetStdLibFunction "\<delete_undef_values\>"
syn match puppetStdLibFunction "\<delete_values\>"
syn match puppetStdLibFunction "\<deprecation\>"
syn match puppetStdLibFunction "\<difference\>"
syn match puppetStdLibFunction "\<dirname\>"
syn match puppetStdLibFunction "\<dos2unix\>"
syn match puppetStdLibFunction "\<enclose_ipv6\>"
syn match puppetStdLibFunction "\<ensure_resource\>"
syn match puppetStdLibFunction "\<ensure_resources\>"
syn match puppetStdLibFunction "\<fact\>"
syn match puppetStdLibFunction "\<fqdn_uuid\>"
syn match puppetStdLibFunction "\<get_module_path\>"
syn match puppetStdLibFunction "\<getparam\>"
syn match puppetStdLibFunction "\<glob\>"
syn match puppetStdLibFunction "\<grep\>"
syn match puppetStdLibFunction "\<has_ip_address\>"
syn match puppetStdLibFunction "\<has_ip_network\>"
syn match puppetStdLibFunction "\<intersection\>"
syn match puppetStdLibFunction "\<is_a\>"
syn match puppetStdLibFunction "\<join_keys_to_values\>"
syn match puppetStdLibFunction "\<load_module_metadata\>"
syn match puppetStdLibFunction "\<loadjson\>"
syn match puppetStdLibFunction "\<loadyaml\>"
syn match puppetStdLibFunction "\<member\>"
syn match puppetStdLibFunction "\<min\>"
syn match puppetStdLibFunction "\<num2bool\>"
syn match puppetStdLibFunction "\<parsejson\>"
syn match puppetStdLibFunction "\<parseyaml\>"
syn match puppetStdLibFunction "\<pick\>"
syn match puppetStdLibFunction "\<pick_default\>"
syn match puppetStdLibFunction "\<prefix\>"
syn match puppetStdLibFunction "\<pry\>"
syn match puppetStdLibFunction "\<range\>"
syn match puppetStdLibFunction "\<regexpescape\>"
syn match puppetStdLibFunction "\<reject\>"
syn match puppetStdLibFunction "\<reverse\>"
syn match puppetStdLibFunction "\<shell_join\>"
syn match puppetStdLibFunction "\<shell_split\>"
syn match puppetStdLibFunction "\<shuffle\>"
syn match puppetStdLibFunction "\<squeeze\>"
syn match puppetStdLibFunction "\<stdlib::batch_escape\>"
syn match puppetStdLibFunction "\<stdlib::crc32\>"
syn match puppetStdLibFunction "\<stdlib::deferrable_epp\>"
syn match puppetStdLibFunction "\<stdlib::end_with\>"
syn match puppetStdLibFunction "\<stdlib::ensure\>"
syn match puppetStdLibFunction "\<stdlib::ensure_packages\>"
syn match puppetStdLibFunction "\<stdlib::extname\>"
syn match puppetStdLibFunction "\<stdlib::fqdn_rand_string\>"
syn match puppetStdLibFunction "\<stdlib::fqdn_rotate\>"
syn match puppetStdLibFunction "\<stdlib::has_function\>"
syn match puppetStdLibFunction "\<stdlib::has_interface_with\>"
syn match puppetStdLibFunction "\<stdlib::ip_in_range\>"
syn match puppetStdLibFunction "\<stdlib::merge\>"
syn match puppetStdLibFunction "\<stdlib::nested_values\>"
syn match puppetStdLibFunction "\<stdlib::os_version_gte\>"
syn match puppetStdLibFunction "\<stdlib::parsehocon\>"
syn match puppetStdLibFunction "\<stdlib::powershell_escape\>"
syn match puppetStdLibFunction "\<stdlib::seeded_rand\>"
syn match puppetStdLibFunction "\<stdlib::seeded_rand_string\>"
syn match puppetStdLibFunction "\<stdlib::sha256\>"
syn match puppetStdLibFunction "\<stdlib::shell_escape\>"
syn match puppetStdLibFunction "\<stdlib::sort_by\>"
syn match puppetStdLibFunction "\<stdlib::start_with\>"
syn match puppetStdLibFunction "\<stdlib::str2resource\>"
syn match puppetStdLibFunction "\<stdlib::time\>"
syn match puppetStdLibFunction "\<stdlib::to_json\>"
syn match puppetStdLibFunction "\<stdlib::to_json_pretty\>"
syn match puppetStdLibFunction "\<stdlib::to_python\>"
syn match puppetStdLibFunction "\<stdlib::to_ruby\>"
syn match puppetStdLibFunction "\<stdlib::to_toml\>"
syn match puppetStdLibFunction "\<stdlib::to_yaml\>"
syn match puppetStdLibFunction "\<stdlib::type_of\>"
syn match puppetStdLibFunction "\<stdlib::validate_domain_name\>"
syn match puppetStdLibFunction "\<stdlib::validate_email_address\>"
syn match puppetStdLibFunction "\<stdlib::xml_encode\>"
syn match puppetStdLibFunction "\<str2bool\>"
syn match puppetStdLibFunction "\<str2saltedpbkdf2\>"
syn match puppetStdLibFunction "\<str2saltedsha512\>"
syn match puppetStdLibFunction "\<suffix\>"
syn match puppetStdLibFunction "\<swapcase\>"
syn match puppetStdLibFunction "\<to_bytes\>"
syn match puppetStdLibFunction "\<union\>"
syn match puppetStdLibFunction "\<unix2dos\>"
syn match puppetStdLibFunction "\<uriescape\>"
syn match puppetStdLibFunction "\<validate_augeas\>"
syn match puppetStdLibFunction "\<validate_cmd\>"
syn match puppetStdLibFunction "\<validate_x509_rsa_key_pair\>"
syn match puppetStdLibFunction "\<values_at\>"
syn match puppetStdLibFunction "\<zip\>"

" Stdlib deprecated functions, as of 9.6.0
syn match puppetDeprecated "\<batch_escape\>"
syn match puppetDeprecated "\<ensure_packages\>"
syn match puppetDeprecated "\<fqdn_rand_string\>"
syn match puppetDeprecated "\<fqdn_rotate\>"
syn match puppetDeprecated "\<has_interface_with\>"
syn match puppetDeprecated "\<merge\>"
syn match puppetDeprecated "\<os_version_gte\>"
syn match puppetDeprecated "\<parsehocon\>"
syn match puppetDeprecated "\<parsepson\>"
syn match puppetDeprecated "\<powershell_escape\>"
syn match puppetDeprecated "\<seeded_rand\>"
syn match puppetDeprecated "\<seeded_rand_string\>"
syn match puppetDeprecated "\<shell_escape\>"
syn match puppetDeprecated "\<stdlib::time\>"
syn match puppetDeprecated "\<time\>"
syn match puppetDeprecated "\<to_json\>"
syn match puppetDeprecated "\<to_json_pretty\>"
syn match puppetDeprecated "\<to_python\>"
syn match puppetDeprecated "\<to_ruby\>"
syn match puppetDeprecated "\<to_toml\>"
syn match puppetDeprecated "\<to_yaml\>"
syn match puppetDeprecated "\<type_of\>"
syn match puppetDeprecated "\<validate_domain_name\>"
syn match puppetDeprecated "\<validate_email_address\>"
syn match puppetDeprecated "\<validate_legacy\>"

syn match puppetType "\<Any\>"
syn match puppetType "\<Array\>"
syn match puppetType "\<Binary\>"
syn match puppetType "\<Boolean\>"
syn match puppetType "\<Callable\>"
syn match puppetType "\<CatalogEntry\>"
syn match puppetType "\<Class\>"
syn match puppetType "\<Collection\>"
syn match puppetType "\<Data\>"
syn match puppetType "\<Default\>"
syn match puppetType "\<Deferred\>"
syn match puppetType "\<Enum\>"
syn match puppetType "<\Error\>"
syn match puppetType "\<Float\>"
syn match puppetType "\<Hash\>"
syn match puppetType "\<Init\>"
syn match puppetType "\<Integer\>"
syn match puppetType "\<Iterable\>"
syn match puppetType "\<Iterator\>"
syn match puppetType "\<NotUndef\>"
syn match puppetType "\<Numeric\>"
syn match puppetType "\<Object\>"
syn match puppetType "\<Optional\>"
syn match puppetType "\<Pattern\>"
syn match puppetType "\<Regexp\>"
syn match puppetType "\<Resource\>"
syn match puppetType "\<RichData\>"
syn match puppetType "\<Runtime\>"
syn match puppetType "\<Scalar\>"
syn match puppetType "\<ScalarData\>"
syn match puppetType "\<SemVer\>"
syn match puppetType "\<SemVerRange\>"
syn match puppetType "\<Sensitive\>"
syn match puppetType "\<String\>"
syn match puppetType "\<Struct\>"
syn match puppetType "\<TimeSpan\>"
syn match puppetType "\<Timestamp\>"
syn match puppetType "\<Tuple\>"
syn match puppetType "\<Type\>"
syn match puppetType "\<TypeSet\>"
syn match puppetType "\<Undef\>"
syn match puppetType "\<URI\>"
syn match puppetType "\<Variant\>"

" Bolt
syn match puppetType "\<ApplyResult>"
syn match puppetType "\<ContainerResult>"
syn match puppetType "\<Future>"
syn match puppetType "\<ResourceInstance>"
syn match puppetType "\<Result>"
syn match puppetType "\<ResultSet>"
syn match puppetType "\<Target>"
syn match puppetType "\<TargetSpec>"
syn match puppetType "\<PlanResult>"

" Core types
syn match puppetType "\<exec\>"
syn match puppetType "\<file\>"
syn match puppetType "\<filebucket\>"
syn match puppetType "\<group\>"
syn match puppetType "\<notify\>"
syn match puppetType "\<package\>"
syn match puppetType "\<resources\>"
syn match puppetType "\<schedule\>"
syn match puppetType "\<service\>"
syn match puppetType "\<stage\>"
syn match puppetType "\<tidy\>"
syn match puppetType "\<user\>"

" supported types
syn match puppetType "\<augeas\>"
syn match puppetType "\<cron\>"
syn match puppetType "\<host\>"
syn match puppetType "\<mount\>"
syn match puppetType "\<scheduled_task\>"
syn match puppetType "\<selboolean\>"
syn match puppetType "\<selmodule\>"
syn match puppetType "\<ssh_authorized_key\>"
syn match puppetType "\<sshkey\>"
syn match puppetType "\<yumrepo\>"
syn match puppetType "\<zfs\>"
syn match puppetType "\<zone\>"
syn match puppetType "\<zpool\>"

" by Puppet, inc but available on forge
syn match puppetType "\<k5login\>"
syn match puppetType "\<mailalias\>"
syn match puppetType "\<maillist\>"

" deprecated resource types
syn match puppetDeprecated "\<computer\>"
syn match puppetDeprecated "\<interface\>"
syn match puppetDeprecated "\<macauthorization\>"
syn match puppetDeprecated "\<mcx\>"
syn match puppetDeprecated "\<nagios_command\>"
syn match puppetDeprecated "\<nagios_contact\>"
syn match puppetDeprecated "\<nagios_contactgroup\>"
syn match puppetDeprecated "\<nagios_host\>"
syn match puppetDeprecated "\<nagios_hostdependency\>"
syn match puppetDeprecated "\<nagios_hostescalation\>"
syn match puppetDeprecated "\<nagios_hostextinfo\>"
syn match puppetDeprecated "\<nagios_hostgroup\>"
syn match puppetDeprecated "\<nagios_service\>"
syn match puppetDeprecated "\<nagios_servicedependency\>"
syn match puppetDeprecated "\<nagios_serviceescalation\>"
syn match puppetDeprecated "\<nagios_serviceextinfo\>"
syn match puppetDeprecated "\<nagios_servicegroup\>"
syn match puppetDeprecated "\<nagios_timeperiod\>"
syn match puppetDeprecated "\<router\>"
syn match puppetDeprecated "\<vlan\>"

" Normal String {{{1
syn region puppetString matchgroup=puppetStringDelimiter start="\"" end="\"" skip="\\\\\|\\\"" contains=@puppetStringSpecial
syn region puppetString matchgroup=puppetStringDelimiter start="'" end="'" skip="\\\\\|\\'" contains=puppetQuoteEscape

" Normal Regular Expression {{{1
syn region puppetRegexp matchgroup=puppetRegexpDelimiter start="\%(\%(^\|\<\%(and\|or\|while\|until\|unless\|if\|elsif\|when\|not\|then\|else\)\|[;\~=!|&(,{[<>?:*+-]\)\s*\)\@<=/" end="/" skip="\\\\\|\\/" contains=@puppetRegexpSpecial
syn region puppetRegexp matchgroup=puppetRegexpDelimiter start="\%(\h\k*\s\+\)\@<=/[ \t=]\@!" end="/" skip="\\\\\|\\/" contains=@puppetRegexpSpecial

" Here Document {{{1
syn region puppetHeredocStart matchgroup=puppetStringDelimiter start=+@(\s*\%("[^"]\+"\|\w\+\)\%(/[nrtsuL$\\]*\)\=)+ end=+$+ oneline contains=ALLBUT,@puppetNotTop

syn region puppetString start=+@(\s*"\z([^"]\+\)"\%(/[nrtsuL$\\]*\)\=+hs=s+2  matchgroup=puppetStringDelimiter end=+^\s*|\=\s*-\=\s*\zs\z1$+ contains=puppetHeredocStart,@puppetStringSpecial keepend
syn region puppetString start=+@(\s*\z(\w\+\)\%(/[nrtsuL$\\]*\)\=+hs=s+2  matchgroup=puppetStringDelimiter end=+^\s*|\=\s*-\=\s*\zs\z1$+ contains=puppetHeredocStart		    keepend

" comments last overriding everything else
syn match   puppetComment       "\s*#.*$" contains=puppetTodo,puppetSpaceError,@Spell
syn region  puppetComment       start="/\*" end="\*/" contains=puppetTodo,puppetSpaceError,@Spell extend
syn keyword puppetTodo          TODO NOTE FIXME XXX BUG HACK contained

hi def link puppetStringDelimiter Delimiter
hi def link puppetBracket         Delimiter
hi def link puppetBrace           Delimiter
hi def link puppetParen           Delimiter
hi def link puppetRegexp          puppetConstant
hi def link puppetConstant        Constant
hi def link puppetNoInterpolation puppetString
hi def link puppetString          String
hi def link puppetWord            String
hi def link puppetFloat           Float
hi def link puppetInteger         Number
hi def link puppetBoolean         Boolean
hi def link puppetType            Type
hi def link puppetOperator        Operator
hi def link puppetStructure       Structure
hi def link puppetName            puppetIdentifier
hi def link puppetVariable        puppetIdentifier
hi def link puppetIdentifier      Identifier
hi def link puppetInterpolationDelimiter Identifier
hi def link puppetConditional     Conditional
hi def link puppetControl         Statement
hi def link puppetKeyword         Keyword
hi def link puppetTodo            Todo
hi def link puppetComment         Comment
hi def link puppetIncludeFunction Include
hi def link puppetStdLibFunction  puppetFunction
hi def link puppetFunction        Function
hi def link puppetDeprecated      Ignore

if g:puppet_display_errors ==# v:true
  hi def link puppetInvalidNumber   Error
  hi def link puppetNameBad         Error
  hi def link puppetSpaceError      Error
endif

let b:current_syntax = 'puppet'
