GLOBAL_LIST_INIT(terminal_fails, init_subtypes(/datum/terminal_skill_fail))

/datum/terminal_skill_fail/
	var/require_ntnet = FALSE
	var/weight = 10
	var/message

/// Returns TRUE if this skill failure can run, otherwise FALSE.
/datum/terminal_skill_fail/proc/can_run(mob/user, datum/terminal/terminal)
	if (require_ntnet)
		return !!terminal.computer.get_ntnet_status()
	return TRUE

/datum/terminal_skill_fail/proc/execute(datum/terminal/terminal)
	return message

/// General failure with no consequences.
/datum/terminal_skill_fail/error
	weight = 50

/datum/terminal_skill_fail/error/execute(datum/terminal/terminal)
	return pick(list(
		"Invalid input.",
		"Wrong command syntax.",
		"Incomplete argument(s).",
		"No file found by that name.",
		"Non-existant storage device specified.",
		"License key expired.",
		"Running script... infinite loop detected; aborting.",
		"ACCESS DENIED"
	))

/// General fail with a chance of embarrasment.
/datum/terminal_skill_fail/sysnotify
	weight = 20

/datum/terminal_skill_fail/sysnotify/execute(datum/terminal/terminal)
	var/message = pick(list(
		"Feline-like typing detected. Input ignored.",
		"Search for 'how to computer' yielded 0 result(s).",
		"!!!YOU ARE A WINNER!!! - Type your login on RealPrizeNet to claim reward!",
		"All scheduled events have been purged from personal calendar.",
		"Voice Recognition Interface unavailable to process commands. Please enter input instead of speaking to device.",
		"Cannot access personal folder 'XXXAdult' in NTNet Nebula Storage; service unreachable.",
		"Unable to send new friend request to user 'SsswoleUnathi99' while a request is already pending.",
		"Hi! It looks like you are attempting to activate a \<STRING_MK87_NUCLEARSELFDESTRUCT_SYSTEM_DESCRIPTION_INFORMAL\>. Would you like help?"
	))
	terminal.computer.audible_notification("sound/machines/ping.ogg")
	terminal.computer.visible_notification(message)
	return list()

/datum/terminal_skill_fail/operator
	require_ntnet = TRUE
	message = "Accessing network operator resources!"

/datum/terminal_skill_fail/operator/can_run(mob/user, datum/terminal/terminal)
	if(!has_access(list(list(access_network, access_network_admin)), user.GetAccess()))
		return
	return ..()

/datum/terminal_skill_fail/operator/access
	message = "Attempting to brute force network admin credentials... unsuccesful. Attempt logged."

/datum/terminal_skill_fail/operator/access/execute(datum/terminal/terminal)
	ntnet_global.add_log_with_ids_check("Unauthorised access attempt to primary keycode database.", terminal.computer.get_component(PART_NETWORK))
	return ..()

/datum/terminal_skill_fail/operator/dos
	message = "Sending content of dev/random to relay... Connection denied due to excess traffic."

/datum/terminal_skill_fail/operator/dos/execute(datum/terminal/terminal)
	var/obj/machinery/ntnet_relay/R = pick(ntnet_global.relays)
	if (!istype(R))
		return "Unable to locate Quantum Relay to attack."
	ntnet_global.add_log_with_ids_check("Excess traffic flood targeting Quantum Relay ([R.uid]) detected from 1 device\s: [terminal.computer.get_network_tag()]")
	return ..()

/datum/terminal_skill_fail/operator/camera
	message = "Accessing raw camera feed... unsuccesful. Attempt logged."

/datum/terminal_skill_fail/operator/camera/execute(datum/terminal/terminal)
	var/network = pick(GLOB.using_map.station_networks)
	if (!network)
		return "Unable to locate camera network to access."
	ntnet_global.add_log_with_ids_check("Unauthorised access detected to camera network [network].", terminal.computer.get_component(PART_NETWORK))
	return ..()

/datum/terminal_skill_fail/operator/email_logs
	weight = 2
	message = "System log backup successful. Chosen method: email attachment. Recipients: all."

/datum/terminal_skill_fail/operator/email_logs/execute(datum/terminal/terminal)
	var/datum/computer_file/data/email_account/S = ntnet_global.find_email_by_name(EMAIL_SYSADMIN)
	if(!istype(S))
		return list()
	var/datum/computer_file/data/email_message/M = new()
	M.title = "!SENSITIVE! - NTNet System log backup"
	M.stored_data = jointext(ntnet_global.logs, "<br>")
	M.source = S.login
	if(!S.send_mail(EMAIL_BROADCAST, M))
		return list()
	terminal.computer.add_log("Network log sent to: all")
	return ..()

/datum/terminal_skill_fail/admin
	require_ntnet = TRUE
	weight = 5
	message = "Updating admin privileges!"

/datum/terminal_skill_fail/admin/can_run(mob/user, datum/terminal/terminal)
	if(!has_access(list(access_network_admin), user.GetAccess()))
		return
	return ..()

/datum/terminal_skill_fail/admin/random_ban
	message = "Entered id successfully banned!"

/datum/terminal_skill_fail/admin/random_ban/execute(datum/terminal/terminal)
	var/id = pick(ntnet_global.registered_nids)
	if (!id || (id in ntnet_global.banned_nids))
		return "Unable to locate network id to ban."
	LAZYADD(ntnet_global.banned_nids, id)
	return ..()

/datum/terminal_skill_fail/admin/random_unban
	message = "Entered id successfully unbanned!"

/datum/terminal_skill_fail/admin/random_unban/execute(datum/terminal/terminal)
	var/id = pick_n_take(ntnet_global.banned_nids)
	if(!id)
		return "Unable to locate network id to unban."
	return ..()

/datum/terminal_skill_fail/admin/purge
	message = "Memory reclamation successful! Logs fully purged!"

/datum/terminal_skill_fail/admin/purge/execute(datum/terminal/terminal)
	terminal.computer.add_log("Network packet sent to NTNet Statistics & Configuration")
	ntnet_global.purge_logs()
	return ..()

/datum/terminal_skill_fail/admin/alarm_reset
	message = "Intrusion Detecton System state reset!"

/datum/terminal_skill_fail/admin/alarm_reset/execute(datum/terminal/terminal)
	terminal.computer.add_log("Network packet sent to NTNet Statistics & Configuration")
	ntnet_global.resetIDS()
	return ..()