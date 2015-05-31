/obj/machinery/computer/aifixer
	name = "\improper AI system integrity restorer"
	icon = 'icons/obj/computer.dmi'
	icon_state = "ai-fixer"
	light_color = "#a97faa"
	circuit = /obj/item/weapon/circuitboard/aifixer
	req_one_access = list(access_robotics, access_heads)
	var/mob/living/silicon/ai/occupant = null
	var/active = 0

/obj/machinery/computer/aifixer/New()
	update_icon()

/obj/machinery/computer/aifixer/proc/load_ai(var/mob/living/silicon/ai/transfer, var/obj/item/device/aicard/card, var/mob/user)

	if(!transfer)
		return

	// Transfer over the AI.
	transfer << "You have been uploaded to a stationary terminal. Sadly, there is no remote access from here."
	user << "\blue <b>Transfer successful</b>: \black [transfer.name] ([rand(1000,9999)].exe) installed and executed successfully. Local copy has been removed."

	transfer.loc = src
	transfer.cancel_camera()
	transfer.control_disabled = 1
	occupant = transfer

	if(card)
		card.clear()

	update_icon()

/obj/machinery/computer/aifixer/attackby(I as obj, user as mob)

	if(istype(I, /obj/item/device/aicard))

		if(stat & (NOPOWER|BROKEN))
			user << "This terminal isn't functioning right now."
			return

		var/obj/item/device/aicard/card = I
		var/mob/living/silicon/ai/comp_ai = locate() in src
		var/mob/living/silicon/ai/card_ai = locate() in card

		if(istype(comp_ai))
			if(active)
				user << "\red <b>ERROR</b>: \black Reconstruction in progress."
				return
			card.grab_ai(comp_ai, user)
			if(!(locate(/mob/living/silicon/ai) in src)) occupant = null
		else if(istype(card_ai))
			load_ai(card_ai,card,user)
			occupant = locate(/mob/living/silicon/ai) in src

		update_icon()
		return
	..()
	return

/obj/machinery/computer/aifixer/attack_ai(var/mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/aifixer/attack_hand(var/mob/user as mob)
	if(..())
		return

	user.set_machine(src)
	var/dat = "<h3>AI System Integrity Restorer</h3><br><br>"

	if (src.occupant)
		var/laws
		dat += "Stored AI: [src.occupant.name]<br>System integrity: [src.occupant.hardware_integrity()]%<br>Backup Capacitor: [src.occupant.backup_capacitor()]%<br>"

		for (var/datum/ai_law/law in occupant.laws.all_laws())
			laws += "[law.get_index()]: [law.law]<BR>"

		dat += "Laws:<br>[laws]<br>"

		if (src.occupant.stat == 2)
			dat += "<b>AI nonfunctional</b>"
		else
			dat += "<b>AI functional</b>"
		if (!src.active)
			dat += {"<br><br><A href='byond://?src=\ref[src];fix=1'>Begin Reconstruction</A>"}
		else
			dat += "<br><br>Reconstruction in process, please wait.<br>"
	dat += {" <A href='?src=\ref[user];mach_close=computer'>Close</A>"}

	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return

/obj/machinery/computer/aifixer/process()
	if(..())
		src.updateDialog()
		return

/obj/machinery/computer/aifixer/Topic(href, href_list)
	if(..())
		return 1
	if (href_list["fix"])
		src.active = 1
		src.overlays += image('icons/obj/computer.dmi', "ai-fixer-on")
		while (src.occupant.health < 100)
			src.occupant.adjustOxyLoss(-1)
			src.occupant.adjustFireLoss(-1)
			src.occupant.adjustToxLoss(-1)
			src.occupant.adjustBruteLoss(-1)
			src.occupant.updatehealth()
			if (src.occupant.health >= 0 && src.occupant.stat == DEAD)
				src.occupant.stat = CONSCIOUS
				src.occupant.lying = 0
				dead_mob_list -= src.occupant
				living_mob_list += src.occupant
				src.overlays -= image('icons/obj/computer.dmi', "ai-fixer-404")
				src.overlays += image('icons/obj/computer.dmi', "ai-fixer-full")
				src.occupant.add_ai_verbs()
			src.updateUsrDialog()
			sleep(10)
		src.active = 0
		src.overlays -= image('icons/obj/computer.dmi', "ai-fixer-on")


		src.add_fingerprint(usr)
	src.updateUsrDialog()
	return


/obj/machinery/computer/aifixer/update_icon()
	..()

	overlays.Cut()

	if((stat & BROKEN) || (stat & NOPOWER))
		return

	if(occupant)
		if(occupant.stat)
			overlays += image('icons/obj/computer.dmi', "ai-fixer-404")
		else
			overlays += image('icons/obj/computer.dmi', "ai-fixer-full")
	else
		overlays += image('icons/obj/computer.dmi', "ai-fixer-empty")
