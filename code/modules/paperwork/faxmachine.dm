GLOBAL_LIST_EMPTY(allfaxes)
GLOBAL_LIST_EMPTY(alldepartments)

GLOBAL_LIST_EMPTY(adminfaxes)	//cache for faxes that have been sent to admins
GLOBAL_LIST_EMPTY(admin_departments)

/obj/machinery/photocopier/faxmachine
	name = "fax machine"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "fax"
	insert_anim = "faxsend"
	var/send_access = list()

	idle_power_usage = 30
	active_power_usage = 200

	var/obj/item/card/id/scan = null // identification
	var/authenticated = 0
	var/department = null // our department
	var/destination = null // the department we're sending to

/obj/machinery/photocopier/faxmachine/Initialize()
	. = ..()

	if (!length(GLOB.admin_departments))
		if (length(GLOB.using_map?.map_admin_faxes))
			GLOB.admin_departments = GLOB.using_map.map_admin_faxes.Copy()
		else
			GLOB.admin_departments = list("[station_name()] Head Office", "[station_name()] Supply")

	if (!destination)
		if (length(GLOB.admin_departments))
			destination = GLOB.admin_departments[1]
		else if (length(GLOB.alldepartments))
			destination = pick(GLOB.alldepartments)

	GLOB.allfaxes += src

	if (department && !(("[department]" in GLOB.alldepartments) || ("[department]" in GLOB.admin_departments)))
		GLOB.alldepartments |= department

/obj/machinery/photocopier/faxmachine/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/paper))
		var/obj/item/paper/P = O
		if(!P.readable)
			to_chat(user, SPAN_NOTICE("\The [src] beeps. Error, invalid document detected."))
			return
	if(istype(O, /obj/item/card/id))
		if(!user.unEquip(O, src))
			return
		scan = O
		to_chat(user, "<span class='notice'>You insert \the [O] into \the [src].</span>")
	if (isMultitool(O))
		to_chat(user, SPAN_NOTICE("\The [src]'s department tag is set to [department]."))
		if (!emagged)
			to_chat(user, SPAN_WARNING("\The [src]'s department configuration is vendor locked."))
			return
		var/list/option_list = GLOB.alldepartments.Copy() + GLOB.admin_departments.Copy() + "(Custom)" + "(Cancel)"
		var/new_department = input(user, "Which department do you want to tag this fax machine as? Choose '(Custom)' to enter a custom department or '(Cancel) to cancel.", "Fax Machine Department Tag") as null|anything in option_list
		if (!new_department || new_department == department || new_department == "(Cancel)" || !CanUseTopic(user) || !Adjacent(user))
			return
		if (new_department == "(Custom)")
			new_department = input(user, "Which department do you want to tag this fax machine as?", "Fax Machine Department Tag", department) as text|null
			if (!new_department || new_department == department || !CanUseTopic(user) || !Adjacent(user))
				return
		if (new_department == "Unknown" || new_department == "(Custom)" || new_department == "(Cancel)")
			to_chat(user, SPAN_WARNING("Invalid department tag selected."))
			return
		department = new_department
		to_chat(user, SPAN_NOTICE("You reconfigure \the [src]'s department tag to [department]."))
	else
		..()

/obj/machinery/photocopier/faxmachine/get_mechanics_info()
	. = "<p>The fax machine can be used to transmit paper faxes to other fax machines on the map, or to off-ship organizations handled by server administration. To use the fax machine, you'll need to insert both a paper and your ID card, authenticate, select a destination, the transmit the fax.</p>"
	. += "<p>You can also fax paper bundles, including photos, using this machine.</p>"
	. += "<p>You can check the machine's department origin tag using a multitool.</p>"
	. += ..()

/obj/machinery/photocopier/faxmachine/get_antag_info()
	. = "<p>If emagged with a cryptographic sequencer, the fax machine can then have it's origin department tag changed using a multitool. This allows you to send faxes pretending to be from somewhere else on the ship, or even an off-ship origin like EXCOMM.</p>"
	. += "<p><strong>NOTE</strong>: Any new department tags created in this way that do not already exist in the list of targets cannot receive faxes, as this does not add new departments to the list of valid fax targets.</p>"
	. += ..()

/obj/machinery/photocopier/faxmachine/emag_act(remaining_charges, mob/user, emag_source)
	if (emagged)
		to_chat(user, SPAN_WARNING("\The [src]'s systems have already been hacked."))
		return
	to_chat(user, SPAN_NOTICE("You unlock \the [src]'s department tagger. You can now modify it's department tag to disguise faxes as being from another department or even off-ship using a multitool."))
	emagged = TRUE
	return TRUE

/obj/machinery/photocopier/faxmachine/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/photocopier/faxmachine/interact(mob/user)
	user.set_machine(src)

	var/dat = "Fax Machine ([department])<BR>"

	var/scan_name
	if(scan)
		scan_name = scan.name
	else
		scan_name = "--------"

	dat += "Confirm Identity: <a href='byond://?src=\ref[src];scan=1'>[scan_name]</a><br>"

	if(authenticated)
		dat += "<a href='byond://?src=\ref[src];logout=1'>{Log Out}</a>"
	else
		dat += "<a href='byond://?src=\ref[src];auth=1'>{Log In}</a>"

	dat += "<hr>"

	if(authenticated)
		dat += "<b>Logged in to:</b> [GLOB.using_map.boss_name] Quantum Entanglement Network<br><br>"

		if(copyitem)
			dat += "<a href='byond://?src=\ref[src];remove=1'>Remove Item</a><br><br>"
			dat += "<a href='byond://?src=\ref[src];send=1'>Send</a><br>"
			dat += "<b>Currently sending:</b> [copyitem.name]<br>"
			dat += "<b>Sending to:</b> <a href='byond://?src=\ref[src];dept=1'>[destination ? destination : "Nobody"]</a><br>"

		else
			dat += "Please insert paper to send via secure connection.<br><br>"

	else
		dat += "Proper authentication is required to use this device.<br><br>"

		if(copyitem)
			dat += "<a href ='byond://?src=\ref[src];remove=1'>Remove Item</a><br>"

	show_browser(user, dat, "window=copier")
	onclose(user, "copier")
	return

/obj/machinery/photocopier/faxmachine/OnTopic(mob/user, href_list, state)
	if(href_list["send"])
		if(copyitem)
			if (destination in GLOB.admin_departments)
				send_admin_fax(user, destination)
			else
				sendfax(destination)
		return TOPIC_REFRESH

	if(href_list["remove"])
		OnRemove(user)
		return TOPIC_REFRESH

	if(href_list["scan"])
		if (scan)
			if(ishuman(user))
				user.put_in_hands(scan)
			else
				scan.dropInto(loc)
			scan = null
		else
			var/obj/item/I = user.get_active_hand()
			if (istype(I, /obj/item/card/id) && user.unEquip(I, src))
				scan = I
		authenticated = 0
		return TOPIC_REFRESH

	if(href_list["dept"])
		var/desired_destination = input(user, "Which department?", "Choose a department", "") as null|anything in (GLOB.alldepartments + GLOB.admin_departments)
		if(desired_destination && CanInteract(user, state))
			destination = desired_destination
		return TOPIC_REFRESH

	if(href_list["auth"])
		if ( (!( authenticated ) && (scan)) )
			if (has_access(send_access, scan.GetAccess()))
				authenticated = 1
		return TOPIC_REFRESH

	if(href_list["logout"])
		authenticated = 0
		return TOPIC_REFRESH

/obj/machinery/photocopier/faxmachine/proc/sendfax(var/destination)
	if(stat & (BROKEN|NOPOWER))
		return

	use_power_oneoff(200)

	var/success = send_fax_loop(copyitem, destination, department)

	if (success)
		visible_message("[src] beeps, \"Message transmitted successfully.\"")
	else
		visible_message("[src] beeps, \"Error transmitting message.\"")


/// Whether or not the fax machine is in a state capable of receiving faxes. Returns boolean.
/obj/machinery/photocopier/faxmachine/proc/can_receive_fax()
	if (inoperable())
		return FALSE
	if (!department)
		return FALSE
	return TRUE


/obj/machinery/photocopier/faxmachine/proc/recievefax(obj/item/incoming, origin_department = "Unknown")
	set waitfor = FALSE

	flick("faxreceive", src)
	playsound(loc, "sound/machines/dotprinter.ogg", 50, 1)
	visible_message(SPAN_NOTICE("\The [src] pings, \"New fax received from [origin_department].\""))

	// give the sprite some time to flick
	sleep(20)

	if (istype(incoming, /obj/item/paper))
		var/obj/item/paper/newcopy = copy(incoming, FALSE)
		newcopy.SetName("[origin_department] - [newcopy.name]")
	else if (istype(incoming, /obj/item/paper))
		var/obj/item/paper/newcopy = photocopy(incoming, FALSE)
		newcopy.SetName("[origin_department] - [newcopy.name]")
	else if (istype(incoming, /obj/item/paper_bundle))
		var/obj/item/paper_bundle/newcopy = bundlecopy(incoming, FALSE)
		newcopy.SetName("[origin_department] - [newcopy.name]")
	else
		return

	use_power_oneoff(active_power_usage)
	return

/obj/machinery/photocopier/faxmachine/proc/send_admin_fax(var/mob/sender, var/destination)
	if(stat & (BROKEN|NOPOWER))
		return

	use_power_oneoff(200)

	//recieved copies should not use toner since it's being used by admins only.
	var/obj/item/rcvdcopy
	if (istype(copyitem, /obj/item/paper))
		rcvdcopy = copy(copyitem, FALSE)
	else if (istype(copyitem, /obj/item/photo))
		rcvdcopy = photocopy(copyitem, FALSE)
	else if (istype(copyitem, /obj/item/paper_bundle))
		rcvdcopy = bundlecopy(copyitem, FALSE)
	else
		visible_message("[src] beeps, \"Error transmitting message.\"")
		return

	rcvdcopy.forceMove(null) //hopefully this shouldn't cause trouble
	GLOB.adminfaxes += rcvdcopy

	var/mob/intercepted = check_for_interception()

	fax2TGS(rcvdcopy, department, destination, key_name(sender.client), intercepted)	// Proxima
	message_admins(sender, "[uppertext(destination)] FAX[intercepted ? "(Intercepted by [intercepted])" : null]", rcvdcopy, destination ? destination : "UNKNOWN")
	send_fax_loop(copyitem, destination, department) // Forward to any listening fax machines
	visible_message("[src] beeps, \"Message transmitted successfully.\"")


/obj/machinery/photocopier/faxmachine/proc/message_admins(mob/sender, faxname, obj/item/sent, reply_type)
	var/msg = "<span class='notice'><b><font color='#006100'>[faxname]: </font>[get_options_bar(sender, 2,1,1)]"
	msg += "(<A HREF='?_src_=holder;take_ic=\ref[sender]'>TAKE</a>) (<a href='?_src_=holder;FaxReply=\ref[sender];originfax=\ref[src];replyorigin=[reply_type]'>REPLY</a>)</b>: "
	msg += "Receiving '[sent.name]' via secure connection ... <a href='?_src_=holder;AdminFaxView=\ref[sent]'>view message</a></span>"

	for(var/client/C as anything in GLOB.admins)
		if(check_rights((R_ADMIN|R_MOD),0,C))
			to_chat(C, msg)
			sound_to(C, 'sound/machines/dotprinter.ogg')


/// Retrieves a list of all fax machines matching the given department tag.
/proc/get_fax_machines_by_department(department)
	if (!department)
		department = "Unknown"
	var/list/faxes = list()
	for (var/obj/machinery/photocopier/faxmachine/fax in GLOB.allfaxes)
		if (fax.department == department)
			faxes += fax
	return faxes


/// Handles the loop of sending a fax to all machines matching the department tag. Returns `TRUE` if at least one fax machine successfully received the fax. Does not include sending faxes to admins.
/proc/send_fax_loop(copyitem, department, origin = "Unknown")
	var/success = FALSE
	for (var/obj/machinery/photocopier/faxmachine/fax in get_fax_machines_by_department(department))
		if (fax.department == department && fax.can_receive_fax())
			success = TRUE
			fax.recievefax(copyitem, origin)
	return success
