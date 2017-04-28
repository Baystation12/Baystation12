/client
	control_freak = CONTROL_FREAK_ALL | CONTROL_FREAK_MACROS

var/list/registered_macros_by_ckey_

// Disables click and double-click macros, as per http://www.byond.com/forum/?post=2219001
/mob/verb/DisableClick(argu = null as anything, sec = "" as text,number1 = 0 as num, number2 = 0 as num)
	set name = ".click"
	set category = null
	log_macro(ckey, ".click")

/mob/verb/DisableDblClick(argu = null as anything, sec = "" as text, number1 = 0 as num, number2 = 0 as num)
	set name = ".dblclick"
	set category = null
	log_macro(ckey, ".dblclick")

/proc/log_macro(var/ckey, var/macro)
	to_chat(usr, "The [macro] macro is disabled due to potential exploits.")
	if(is_macro_use_registered(ckey, macro))
		return
	register_macro_use(ckey, macro)
	log_and_message_admins("attempted to use the disabled [macro] macro.")

/proc/get_registered_macros()
	if(!registered_macros_by_ckey_)
		registered_macros_by_ckey_ = list()
	return registered_macros_by_ckey_

/proc/is_macro_use_registered(var/ckey, var/macro)
	var/list/registered_macros = get_registered_macros()[ckey]
	return registered_macros && (macro in registered_macros)

/proc/register_macro_use(var/ckey, var/macro)
	var/list/registered_macros_by_ckey = get_registered_macros()
	var/list/registered_macros = registered_macros_by_ckey[ckey]
	if(!registered_macros)
		registered_macros = list()
		registered_macros_by_ckey[ckey] = registered_macros
	registered_macros |= macro
