/////////////////////////////////////////////
//Guest pass ////////////////////////////////
/////////////////////////////////////////////
/obj/item/weapon/card/id/guest
	name = "guest pass"
	desc = "Allows temporary access to restricted areas."
	icon_state = "guest"
	light_color = "#0099ff"

	var/temp_access = list() //to prevent agent cards stealing access as permanent
	var/expiration_time = 0
	var/reason = "NOT SPECIFIED"

/obj/item/weapon/card/id/guest/GetAccess()
	if (world.time > expiration_time)
		return access
	else
		return temp_access

/obj/item/weapon/card/id/guest/examine(mob/user)
	. = ..()
	if (world.time < expiration_time)
		to_chat(user, "<span class='notice'>This pass expires at [worldtime2stationtime(expiration_time)].</span>")
	else
		to_chat(user, "<span class='warning'>It expired at [worldtime2stationtime(expiration_time)].</span>")

/obj/item/weapon/card/id/guest/read()
	if (world.time > expiration_time)
		to_chat(usr, "<span class='notice'>This pass expired at [worldtime2stationtime(expiration_time)].</span>")
	else
		to_chat(usr, "<span class='notice'>This pass expires at [worldtime2stationtime(expiration_time)].</span>")

	to_chat(usr, "<span class='notice'>It grants access to following areas:</span>")
	for (var/A in temp_access)
		to_chat(usr, "<span class='notice'>[get_access_desc(A)].</span>")
	to_chat(usr, "<span class='notice'>Issuing reason: [reason].</span>")
	return

/////////////////////////////////////////////
//Guest pass terminal////////////////////////
/////////////////////////////////////////////

/obj/machinery/computer/guestpass
	name = "guest pass terminal"
	icon_state = "guest"
	icon_keyboard = null
	icon_screen = "pass"
	density = 0

	var/obj/item/weapon/card/id/giver
	var/list/accesses = list()
	var/giv_name = "NOT SPECIFIED"
	var/reason = "NOT SPECIFIED"
	var/duration = 5

	var/list/internal_log = list()
	var/mode = 0  // 0 - making pass, 1 - viewing logs

/obj/machinery/computer/guestpass/New()
	..()
	uid = "[random_id("guestpass_serial_number",100,999)]-G[rand(10,99)]"

/obj/machinery/computer/guestpass/attackby(obj/O, mob/user)
	if(istype(O, /obj/item/weapon/card/id))
		if(!giver && user.unEquip(O))
			O.forceMove(src)
			giver = O
			updateUsrDialog()
		else if(giver)
			to_chat(user, "<span class='warning'>There is already ID card inside.</span>")
		return
	..()

/obj/machinery/computer/guestpass/attack_ai(var/mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/guestpass/attack_hand(var/mob/user as mob)
	if(..())
		return

	user.set_machine(src)
	var/dat

	if (mode == 1) //Logs
		dat += "<h3>Activity log</h3><br>"
		for (var/entry in internal_log)
			dat += "[entry]<br><hr>"
		dat += "<a href='?src=\ref[src];action=print'>Print</a><br>"
		dat += "<a href='?src=\ref[src];mode=0'>Back</a><br>"
	else
		dat += "<h3>Guest pass terminal #[uid]</h3><br>"
		dat += "<a href='?src=\ref[src];mode=1'>View activity log</a><br><br>"
		dat += "Issuing ID: <a href='?src=\ref[src];action=id'>[giver]</a><br>"
		dat += "Issued to: <a href='?src=\ref[src];choice=giv_name'>[giv_name]</a><br>"
		dat += "Reason:  <a href='?src=\ref[src];choice=reason'>[reason]</a><br>"
		dat += "Duration (minutes):  <a href='?src=\ref[src];choice=duration'>[duration] m</a><br>"
		dat += "Access to areas:<br>"
		if (giver && giver.access)
			for (var/A in giver.access)
				var/area = get_access_desc(A)
				if (A in accesses)
					area = "<b>[area]</b>"
				dat += "<a href='?src=\ref[src];choice=access;access=[A]'>[area]</a><br>"
		dat += "<br><a href='?src=\ref[src];action=issue'>Issue pass</a><br>"

	user << browse(dat, "window=guestpass;size=400x520")
	onclose(user, "guestpass")


/obj/machinery/computer/guestpass/OnTopic(var/mob/user, href_list, state)
	if (href_list["mode"])
		mode = text2num(href_list["mode"])
		. = TOPIC_REFRESH

	else if (href_list["choice"])
		switch(href_list["choice"])
			if ("giv_name")
				var/nam = sanitize(input(user, "Person pass is issued to", "Name", giv_name) as text|null)
				if (nam && CanUseTopic(user, state))
					giv_name = nam
			if ("reason")
				var/reas = sanitize(input(user, "Reason why pass is issued", "Reason", reason) as text|null)
				if(reas && CanUseTopic(user, state))
					reason = reas
			if ("duration")
				var/dur = input(user, "Duration (in minutes) during which pass is valid (up to 30 minutes).", "Duration") as num|null
				if (dur && CanUseTopic(user, state))
					if (dur > 0 && dur <= 30)
						duration = dur
					else
						to_chat(user, "<span class='warning'>Invalid duration.</span>")
			if ("access")
				var/A = text2num(href_list["access"])
				if (A in accesses)
					accesses.Remove(A)
				else if(giver && (A in giver.access))
					accesses.Add(A)
		. = TOPIC_REFRESH
	else if (href_list["action"])
		switch(href_list["action"])
			if ("id")
				if (giver)
					giver.dropInto(user.loc)
					if(ishuman(user))
						user.put_in_hands(giver)
					giver = null
					accesses.Cut()
				else
					var/obj/item/I = user.get_active_hand()
					if (istype(I, /obj/item/weapon/card/id) && user.unEquip(I))
						I.forceMove(src)
						giver = I
				. = TOPIC_REFRESH
			if ("print")
				var/dat = "<h3>Activity log of guest pass terminal #[uid]</h3><br>"
				for (var/entry in internal_log)
					dat += "[entry]<br><hr>"
//				to_chat(user, "Printing the log, standby...")
				//sleep(50)
				var/obj/item/weapon/paper/P = new/obj/item/weapon/paper( loc )
				P.SetName("activity log")
				P.info = dat
				. = TOPIC_REFRESH

			if ("issue")
				if (giver && accesses.len)
					var/number = add_zero(random_id("guestpass_id_number",1000,9999), 4)
					var/entry = "\[[stationtime2text()]\] Pass #[number] issued by [giver.registered_name] ([giver.assignment]) to [giv_name]. Reason: [reason]. Granted access to following areas: "
					var/list/access_descriptors = list()
					for (var/A in accesses)
						if (A in giver.access)
							access_descriptors += get_access_desc(A)
					entry += english_list(access_descriptors, and_text = ", ")
					entry += ". Expires at [worldtime2stationtime(world.time + duration MINUTES)]."
					internal_log.Add(entry)

					var/obj/item/weapon/card/id/guest/pass = new(src.loc)
					pass.temp_access = accesses.Copy()
					pass.registered_name = giv_name
					pass.expiration_time = world.time + duration MINUTES
					pass.reason = reason
					pass.SetName("guest pass #[number]")
					pass.assignment = "Guest"
					playsound(src.loc, 'sound/machines/ping.ogg', 25, 0)
					. = TOPIC_REFRESH
				else if(!giver)
					to_chat(user, "<span class='warning'>Cannot issue pass without issuing ID.</span>")
				else if(!accesses.len)
					to_chat(user, "<span class='warning'>Cannot issue pass without at least one granted access permission.</span>")
	if(.)
		attack_hand(user)
