/client
	control_freak = CONTROL_FREAK_ALL | CONTROL_FREAK_MACROS | CONTROL_FREAK_SKIN

// Disables click and double-click macros, as per http://www.byond.com/forum/?post=2219001
/mob/verb/DisableClick(argu = null as anything, sec = "" as text,number1 = 0 as num, number2 = 0 as num)
    set name = ".click"
    set category = null
    log_and_message_admins("attempted to use the .click macro.")

/mob/verb/DisableDblClick(argu = null as anything, sec = "" as text, number1 = 0 as num, number2 = 0 as num)
    set name = ".dblclick"
    set category = null
    log_and_message_admins("attempted to use the .dblclick macro.")
