#define MESSAGE_SERVER_SPAM_REJECT 1
#define MESSAGE_SERVER_DEFAULT_SPAM_LIMIT 10

var/global/list/obj/machinery/message_server/message_servers = list()

/datum/data_rc_msg
	var/rec_dpt = "Unspecified" //name of the person
	var/send_dpt = "Unspecified" //name of the sender
	var/message = "Blank" //transferred message
	var/stamp = "Unstamped"
	var/id_auth = "Unauthenticated"
	var/priority = "Normal"

/datum/data_rc_msg/New(var/param_rec = "",var/param_sender = "",var/param_message = "",var/param_stamp = "",var/param_id_auth = "",var/param_priority)
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
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "server"
	name = "Messaging Server"
	density = 1
	anchored = 1.0
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
	var/spamfilter_limit = MESSAGE_SERVER_DEFAULT_SPAM_LIMIT	//Maximal amount of tokens

/obj/machinery/message_server/New()
	message_servers += src
	decryptkey = GenerateKey()
	..()

/obj/machinery/message_server/Destroy()
	message_servers -= src
	return ..()

/obj/machinery/message_server/Process()
	..()
	if(active && (stat & (BROKEN|NOPOWER)))
		active = 0
		power_failure = 10
		update_icon()
		return
	else if(stat & (BROKEN|NOPOWER))
		return
	else if(power_failure > 0)
		if(!(--power_failure))
			active = 1
			update_icon()

/obj/machinery/message_server/proc/send_rc_message(var/recipient = "",var/sender = "",var/message = "",var/stamp = "", var/id_auth = "", var/priority = 1)
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
				Console.audible_message("\icon[Console]<span class='warning'>\The [Console] announces: 'High priority message received from [sender]!'</span>", hearing_distance = 8)
				Console.message_log += "<FONT color='red'>High Priority message from <A href='?src=\ref[Console];write=[sender]'>[sender]</A></FONT><BR>[authmsg]"
			else
				if(!Console.silent)
					playsound(Console.loc, 'sound/machines/twobeep.ogg', 50, 1)
					Console.audible_message("\icon[Console]<span class='notice'>\The [Console] announces: 'Message received from [sender].'</span>", hearing_distance = 5)
				Console.message_log += "<B>Message from <A href='?src=\ref[Console];write=[sender]'>[sender]</A></B><BR>[authmsg]"
			Console.set_light(0.3, 0.1, 2)


/obj/machinery/message_server/interface_interact(mob/user)
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	to_chat(user, "You toggle PDA message passing from [active ? "On" : "Off"] to [active ? "Off" : "On"]")
	active = !active
	power_failure = 0
	update_icon()
	return TRUE

/obj/machinery/message_server/attackby(obj/item/weapon/O as obj, mob/living/user as mob)
	if (active && !(stat & (BROKEN|NOPOWER)) && (spamfilter_limit < MESSAGE_SERVER_DEFAULT_SPAM_LIMIT*2) && \
		istype(O,/obj/item/weapon/stock_parts/circuitboard/message_monitor))
		spamfilter_limit += round(MESSAGE_SERVER_DEFAULT_SPAM_LIMIT / 2)
		qdel(O)
		to_chat(user, "You install additional memory and processors into message server. Its filtering capabilities been enhanced.")
	else
		..(O, user)

/obj/machinery/message_server/on_update_icon()
	if((stat & (BROKEN|NOPOWER)))
		icon_state = "server-nopower"
	else if (!active)
		icon_state = "server-off"
	else
		icon_state = "server-on"

	return

/obj/machinery/message_server/proc/send_to_department(var/department, var/message, var/tone)
	var/reached = 0

	for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
		var/obj/item/modular_computer/pda/pda = locate() in H
		if(!pda)
			continue

		var/datum/job/J = SSjobs.get_by_title(H.get_authentification_rank())
		if(!J)
			continue

		if(J.department_flag & department)
			to_chat(H, "<span class='notice'>Your [pda.name] alerts you to the fact that somebody is requesting your presence at your department.</span>")
			reached++

	return reached
