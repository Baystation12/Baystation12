var/list/obj/machinery/photocopier/faxmachine/allfaxes = list()
var/list/alldepartments = list("Central Command", "Sol Government")

/obj/machinery/photocopier/faxmachine
	name = "fax machine"
	icon = 'icons/obj/library.dmi'
	icon_state = "fax"
	insert_anim = "faxsend"
	req_one_access = list(access_lawyer, access_heads, access_armory) //Warden needs to be able to Fax solgov too.

	use_power = 1
	idle_power_usage = 30
	active_power_usage = 200

	var/obj/item/weapon/card/id/scan = null // identification
	var/authenticated = 0
	var/sendcooldown = 0 // to avoid spamming fax messages

	var/department = "Unknown" // our department

	var/destination = "Central Command" // the department we're sending to

/obj/machinery/photocopier/faxmachine/New()
	..()
	allfaxes += src

	if( !("[department]" in alldepartments) )
		alldepartments |= department

/obj/machinery/photocopier/faxmachine/attack_hand(mob/user as mob)
	user.set_machine(src)

	var/dat = "Fax Machine<BR>"

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
		dat += "<b>Logged in to:</b> Central Command Quantum Entanglement Network<br><br>"

		if(copyitem)
			dat += "<a href='byond://?src=\ref[src];remove=1'>Remove Item</a><br><br>"

			if(sendcooldown)
				dat += "<b>Transmitter arrays realigning. Please stand by.</b><br>"

			else
				
				dat += "<a href='byond://?src=\ref[src];send=1'>Send</a><br>"
				dat += "<b>Currently sending:</b> [copyitem.name]<br>"
				dat += "<b>Sending to:</b> <a href='byond://?src=\ref[src];dept=1'>[destination]</a><br>"

		else
			if(sendcooldown)
				dat += "Please insert paper to send via secure connection.<br><br>"
				dat += "<b>Transmitter arrays realigning. Please stand by.</b><br>"
			else
				dat += "Please insert paper to send via secure connection.<br><br>"

	else
		dat += "Proper authentication is required to use this device.<br><br>"

		if(copyitem)
			dat += "<a href ='byond://?src=\ref[src];remove=1'>Remove Item</a><br>"

	user << browse(dat, "window=copier")
	onclose(user, "copier")
	return

/obj/machinery/photocopier/faxmachine/Topic(href, href_list)
	if(href_list["send"])
		if(copyitem)

			if(destination == "Central Command")
				//Centcomm_fax(src, tofax.info, tofax.name, usr)
				sendcooldown = 1800

			else if(destination == "Sol Government")
				//Solgov_fax(src, tofax.info, tofax.name, usr)
				sendcooldown = 1800
			else
				sendfax(destination)

			if (sendcooldown)
				spawn(sendcooldown) // cooldown time
					sendcooldown = 0

	else if(href_list["remove"])
		if(copyitem)
			copyitem.loc = usr.loc
			usr.put_in_hands(copyitem)
			usr << "<span class='notice'>You take \the [copyitem] out of \the [src].</span>"
			copyitem = null
			updateUsrDialog()

	if(href_list["scan"])
		if (scan)
			if(ishuman(usr))
				scan.loc = usr.loc
				if(!usr.get_active_hand())
					usr.put_in_hands(scan)
				scan = null
			else
				scan.loc = src.loc
				scan = null
		else
			var/obj/item/I = usr.get_active_hand()
			if (istype(I, /obj/item/weapon/card/id))
				usr.drop_item()
				I.loc = src
				scan = I
		authenticated = 0

	if(href_list["dept"])
		var/lastdestination = destination
		destination = input(usr, "Which department?", "Choose a department", "") as null|anything in alldepartments
		if(!destination) destination = lastdestination

	if(href_list["auth"])
		if ( (!( authenticated ) && (scan)) )
			if (check_access(scan))
				authenticated = 1

	if(href_list["logout"])
		authenticated = 0

	updateUsrDialog()

/obj/machinery/photocopier/faxmachine/proc/admin_fax()
	//TODO

/obj/machinery/photocopier/faxmachine/proc/sendfax(var/destination)
	if(stat & (BROKEN|NOPOWER))
		return
	
	var/sent = 0
	
	use_power(200)
	for(var/obj/machinery/photocopier/faxmachine/F in allfaxes)
		if( F.department == destination )
			sent = F.recievefax(copyitem)
	
	if (sent)
		visible_message("[src] beeps, \"Message transmitted successfully.\"")
		sendcooldown = 600
	else
		visible_message("[src] beeps, \"Error transmitting message.\"")

/obj/machinery/photocopier/faxmachine/proc/recievefax(var/obj/item/incoming)
	if(stat & (BROKEN|NOPOWER))
		return 0

	flick("faxreceive", src)
	playsound(loc, "sound/items/polaroid1.ogg", 50, 1)
	
	// give the sprite some time to flick
	sleep(20)
	
	if (istype(incoming, /obj/item/weapon/paper))
		copy(incoming)
	else if (istype(incoming, /obj/item/weapon/photo))
		photocopy(incoming)
	else if (istype(incoming, /obj/item/weapon/paper_bundle))
		bundlecopy(incoming)
	else
		return 0

	use_power(active_power_usage)
	return 1

/proc/Centcomm_fax(var/originfax, var/sent, var/sentname, var/mob/Sender)

	var/msg = "\blue <b><font color='#006100'>CENTCOMM FAX: </font>[key_name(Sender, 1)] (<A HREF='?_src_=holder;adminplayeropts=\ref[Sender]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[Sender]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=\ref[Sender]'>SM</A>) (<A HREF='?_src_=holder;adminplayerobservejump=\ref[Sender]'>JMP</A>) (<A HREF='?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<a href='?_src_=holder;CentcommFaxReply=\ref[Sender];originfax=\ref[originfax]'>REPLY</a>)</b>: Receiving '[sentname]' via secure connection ... <a href='?_src_=holder;CentcommFaxView=\ref[sent]'>view message</a>"

	admins << msg

/proc/Solgov_fax(var/originfax, var/sent, var/sentname, var/mob/Sender)
	var/msg = "\blue <b><font color='#1F66A0'>SOL GOVERNMENT FAX: </font>[key_name(Sender, 1)] (<A HREF='?_src_=holder;adminplayeropts=\ref[Sender]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[Sender]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=\ref[Sender]'>SM</A>) (<A HREF='?_src_=holder;adminplayerobservejump=\ref[Sender]'>JMP</A>) (<A HREF='?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<a href='?_src_=holder;SolGovFaxReply=\ref[Sender];originfax=\ref[originfax]'>REPLY</a>)</b>: Receiving '[sentname]' via secure connection ... <a href='?_src_=holder;CentcommFaxView=\ref[sent]'>view message</a>"

	admins << msg