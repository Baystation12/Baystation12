/obj/machinery/disposal/interact(mob/user)

	src.add_fingerprint(user)
	if(MACHINE_IS_BROKEN(src))
		user.unset_machine()
		return

	var/ai = isAI(user)
	var/dat = ""

	if(!ai)  // AI can't pull flush handle
		if(flush)
			dat += "Disposal handle: <A href='?src=\ref[src];handle=0'>Disengage</A> <B>Engaged</B>"
		else
			dat += "Disposal handle: <B>Disengaged</B> <A href='?src=\ref[src];handle=1'>Engage</A>"

		dat += "<BR><HR><A href='?src=\ref[src];eject=1'>Eject contents</A><HR>"

	if(mode <= 0)
		dat += "Pump: <B>Off</B> <A href='?src=\ref[src];pump=1'>On</A><BR>"
	else if(mode == 1)
		dat += "Pump: <A href='?src=\ref[src];pump=0'>Off</A> <B>On</B> (pressurizing)<BR>"
	else
		dat += "Pump: <A href='?src=\ref[src];pump=0'>Off</A> <B>On</B> (idle)<BR>"

	var/per = 100* air_contents.return_pressure() / (SEND_PRESSURE)

	dat += "Pressure: [round(per, 1)]%<BR></body>"


	user.set_machine(src)
	var/datum/browser/popup = new(user, "disposal", "Waste Disposal Unit", 360, 170)
	popup.set_content(dat)
	popup.open()
