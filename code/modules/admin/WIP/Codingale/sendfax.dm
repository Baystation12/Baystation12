/proc/get_fax_machines()
	var/list/faxes = new()
	for(var/obj/machinery/faxmachine/F in machines)
		faxes += F
	return faxes

/obj/machinery/faxmachine/proc/sendFax(var/obj/machinery/faxmachine/fax as obj in get_fax_machines())
	set name = "Send Fax"
	set category = "Admin"


	var/who = input("Who is sending this?") in list("NanoTrasen","Sol Government","Cancel")
	if (who=="Cancel")	 return

	var/inputsubject = input(src, "Please enter a Subject", "Outgoing message from [who]", "") as text|null
	if (!inputsubject)	return

	var/inputmessage = input(src, "Please enter a message to send to [fax] via secure connection. Use <br> for line breaks.", "Outgoing message from [who]", "") as message|null
	if (!inputmessage)	return

	var/inputsigned = input(src, "Please enter Centcom Offical name.", "Outgoing message from Centcomm", "") as text|null
	if (!inputsigned)	return


	var/customname = input(src, "Pick a title for the report", "Title") as text|null
	var/input = "<center><b>[who] Fax Network</b></center><hr><center>[inputsubject]</center><hr>[inputmessage]<hr><b>Signed:</b> <i>[inputsigned]</i>"

	if(! (fax.stat & (BROKEN|NOPOWER) ) )

		// animate! it's alive!
		flick("faxreceive", fax)

		// give the sprite some time to flick
		spawn(20)
			var/obj/item/weapon/paper/P = new /obj/item/weapon/paper( fax.loc )
			P.name = "[who=="NanoTrasen" ? "Central Command":"Sol Government"] - [customname]"
			P.info = input
			P.update_icon()

			playsound(fax.loc, "sound/items/polaroid1.ogg", 50, 1)
			// Stamps
			var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
			stampoverlay.icon_state = "paper_stamp-[who=="NanoTrasen" ? "cent":"cap"]"
			if(!P.stamped)
				P.stamped = new
			P.stamped += /obj/item/weapon/stamp
			P.overlays += stampoverlay
			P.stamps += "<HR><i>This paper has been stamped[who=="NanoTrasen" ? "": " and encrypted"] by the [ who=="NanoTrasen" ? "Central Command":"Sol Government"] Quantum Relay.</i>"

			usr << "Message reply to transmitted successfully."
			log_admin("[key_name(usr)] sent a fax to [fax], as [who].")
			log_admin_single("[key_name(usr)] sent a fax to [fax], as [who].")
			send_investigate_log("[key_name(usr)] sent to a fax to [fax], as [who=="NanoTrasen" ? "Central Command":"the Sol Government"]. : <a href='?_src_=holder;CentcommFaxView=\ref[input]'>view message</a>","fax")
			message_admins("[key_name_admin(usr)] sent a fax to [fax], as [who=="NanoTrasen" ? "Central Command":"the Sol Government"].", 1)
			return
	else
		usr<< "\red The fax is broken or has no power!"
	feedback_add_details("admin_verb","SF") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
