var/global/list/obj/machinery/message_server/message_servers = list()


/datum/data_rc_msg
	var/rec_dpt = "Unspecified" //name of the person
	var/send_dpt = "Unspecified" //name of the sender
	var/message = "Blank" //transferred message
	var/stamp = "Unstamped"
	var/id_auth = "Unauthenticated"
	var/priority = "Normal"


/datum/data_rc_msg/New(param_rec = "",param_sender = "",param_message = "",param_stamp = "",param_id_auth = "",param_priority)
	if(param_rec)
		rec_dpt = param_rec
	if(param_sender)
		send_dpt = param_sender
	if(param_message)
		message = param_message
	if(param_stamp)
		stamp = param_stamp
	if(param_id_auth)
		id_auth = param_id_auth
	if(param_priority)
		switch(param_priority)
			if(1)
				priority = "Normal"
			if(2)
				priority = "High"
			if(3)
				priority = "Extreme"
			else
				priority = "Undetermined"


/obj/machinery/message_server
	icon = 'icons/obj/machines/research/server.dmi'
	icon_state = "server"
	name = "messaging server"
	density = TRUE
	anchored = TRUE
	idle_power_usage = 10
	active_power_usage = 100

	var/list/datum/data_rc_msg/rc_msgs = list()
	var/active = 1
	var/power_failure = 0 // Reboot timer after power outage
	var/decryptkey = "password"

	//Spam filtering stuff
	var/list/spamfilter = list("You have won", "your prize", "male enhancement", "shitcurity", \
			"are happy to inform you", "account number", "enter your PIN")
			//Messages having theese tokens will be rejected by server. Case sensitive
	var/spamfilter_limit = 10


/obj/machinery/message_server/Destroy()
	message_servers -= src
	return ..()


/obj/machinery/message_server/Initialize()
	. = ..()
	message_servers += src
	decryptkey = GenerateKey()
	update_icon()


/obj/machinery/message_server/Process()
	if (inoperable())
		if (active)
			active = FALSE
			power_failure = 10
	else if (power_failure > 0)
		--power_failure
		if (!power_failure)
			active = TRUE
	update_icon()


/obj/machinery/r_n_d/server/operable()
	return !inoperable(MACHINE_STAT_EMPED)


/obj/machinery/message_server/on_update_icon()
	ClearOverlays()
	if (operable())
		AddOverlays(list(
			"server_on",
			"server_lights_on",
			emissive_appearance(icon, "server_lights_on")
		))
	else
		AddOverlays(list(
			"server_lights_off",
			emissive_appearance(icon, "server_lights_off")
		))
	if (panel_open)
		AddOverlays("server_panel")


/obj/machinery/message_server/interface_interact(mob/user)
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	to_chat(user, "You toggle PDA message passing from [active ? "On" : "Off"] to [active ? "Off" : "On"]")
	active = !active
	power_failure = 0
	update_icon()
	return TRUE


/obj/machinery/message_server/use_tool(obj/item/tool, mob/living/user, list/click_params)
	if (!istype(tool, /obj/item/stock_parts/circuitboard/message_monitor))
		return ..()
	if (spamfilter_limit >= initial(spamfilter_limit) * 2)
		to_chat(user, SPAN_WARNING("\The [src] already has as many boards as it can hold."))
		return TRUE
	spamfilter_limit += round(initial(spamfilter_limit) / 2)
	user.visible_message(
		SPAN_ITALIC("\The [user] installs \a [tool] into \a [src]."),
		SPAN_ITALIC("You install \the [tool] into \the [src], improving its spam filtering capabilities."),
		range = 5
	)
	qdel(tool)
	return TRUE


/obj/machinery/message_server/proc/send_to_department(department, message, tone)
	var/reached = 0
	for(var/mob/living/carbon/human/H in GLOB.human_mobs)
		var/obj/item/modular_computer/device = locate() in H
		if(!device || !(get_z(device) in GLOB.using_map.station_levels))
			continue
		var/rank = H.get_authentification_rank()
		var/datum/job/J = SSjobs.get_by_title(rank)
		if (!J)
			continue
		if(!istype(J))
			log_debug(append_admin_tools("MESSAGE SERVER: Mob has an invalid job, skipping. Mob: '[H]'. Rank: '[rank]'. Job: '[J]'."))
			continue
		if(J.department_flag & department)
			to_chat(H, SPAN_NOTICE("Your [device.name] alerts you to the fact that somebody is requesting your presence at your department."))
			reached++
	return reached


/obj/machinery/message_server/proc/send_rc_message(recipient = "",sender = "",message = "",stamp = "", id_auth = "", priority = 1)
	rc_msgs += new/datum/data_rc_msg(recipient,sender,message,stamp,id_auth)
	var/authmsg = "[message]<br>"
	if (id_auth)
		authmsg += "[id_auth]<br>"
	if (stamp)
		authmsg += "[stamp]<br>"
	. = FALSE
	var/list/good_z = GetConnectedZlevels(z)
	for (var/obj/machinery/requests_console/Console in allConsoles)
		if(!(Console.z in good_z))
			continue
		if (ckey(Console.department) == ckey(recipient))
			if(Console.inoperable())
				Console.message_log += "<B>Message lost due to console failure.</B><BR>Please contact [station_name()] system administrator or AI for technical assistance.<BR>"
				continue
			. = TRUE
			if(Console.newmessagepriority < priority)
				Console.newmessagepriority = priority
				Console.icon_state = "req_comp[priority]"
			if(priority > 1)
				playsound(Console.loc, 'sound/machines/chime.ogg', 80, 1)
				Console.audible_message("[icon2html(Console, viewers(get_turf(Console)))][SPAN_WARNING("\The [Console] announces: 'High priority message received from [sender]!'")]", hearing_distance = 8)
				Console.message_log += "[SPAN_COLOR("red", "High Priority message from <A href='?src=\ref[Console];write=[sender]'>[sender]</A>")]<BR>[authmsg]"
			else
				if(!Console.silent)
					playsound(Console.loc, 'sound/machines/twobeep.ogg', 50, 1)
					Console.audible_message("[icon2html(Console, viewers(get_turf(Console)))][SPAN_NOTICE("\The [Console] announces: 'Message received from [sender].'")]", hearing_distance = 5)
				Console.message_log += "<B>Message from <A href='?src=\ref[Console];write=[sender]'>[sender]</A></B><BR>[authmsg]"
			Console.set_light(2, 0.5)
