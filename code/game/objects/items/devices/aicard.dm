/obj/item/device/aicard
	name = "inteliCard"
	icon = 'icons/obj/pda.dmi'
	icon_state = "aicard" // aicard-full
	item_state = "electronic"
	w_class = 2.0
	slot_flags = SLOT_BELT
	var/flush = null
	origin_tech = "programming=4;materials=4"

	var/mob/living/silicon/ai/carded_ai

/obj/item/device/aicard/attack(mob/living/silicon/decoy/M as mob, mob/user as mob)
	if (!istype (M, /mob/living/silicon/decoy))
		return ..()
	else
		M.death()
		user << "<b>ERROR ERROR ERROR</b>"

/obj/item/device/aicard/attack_self(mob/user)
	if (!in_range(src, user))
		return
	user.set_machine(src)
	var/dat = "<TT><B>Intelicard</B><BR>"
	var/laws
	for(var/mob/living/silicon/ai/A in src)
		dat += "Stored AI: [A.name]<br>System integrity: [A.system_integrity()]%<br>"

		for (var/datum/ai_law/law in A.laws.all_laws())
			laws += "[law.get_index()]: [law.law]<BR>"

		dat += "Laws:<br>[laws]<br>"

		if (A.stat == 2)
			dat += "<b>AI nonfunctional</b>"
		else
			if (!src.flush)
				dat += {"<A href='byond://?src=\ref[src];choice=Wipe'>Wipe AI</A>"}
			else
				dat += "<b>Wipe in progress</b>"
			dat += "<br>"
			dat += {"<a href='byond://?src=\ref[src];choice=Wireless'>[A.control_disabled ? "Enable" : "Disable"] Wireless Activity</a>"}
			dat += "<br>"
			dat += {"<a href='byond://?src=\ref[src];choice=Radio'>[A.aiRadio.disabledAi ? "Enable" : "Disable"] Subspace Transceiver</a>"}
			dat += "<br>"
			dat += {"<a href='byond://?src=\ref[src];choice=Close'> Close</a>"}
	user << browse(dat, "window=aicard")
	onclose(user, "aicard")
	return

/obj/item/device/aicard/Topic(href, href_list)

	var/mob/U = usr
	if (get_dist(get_turf(U),get_turf(src)) > 1 || U.machine != src)//If they are not in range of 1 or less or their machine is not the card (ie, clicked on something else).
		U << browse(null, "window=aicard")
		U.unset_machine()
		return

	add_fingerprint(U)
	U.set_machine(src)

	switch(href_list["choice"])//Now we switch based on choice.
		if ("Close")
			U << browse(null, "window=aicard")
			U.unset_machine()
			return

		if ("Radio")
			for(var/mob/living/silicon/ai/A in src)
				A.aiRadio.disabledAi = !A.aiRadio.disabledAi
				A << "Your Subspace Transceiver has been: [A.aiRadio.disabledAi ? "disabled" : "enabled"]"
				U << "You [A.aiRadio.disabledAi ? "Disable" : "Enable"] the AI's Subspace Transceiver"

		if ("Wipe")
			var/confirm = alert("Are you sure you want to wipe this card's memory? This cannot be undone once started.", "Confirm Wipe", "Yes", "No")
			if(confirm == "Yes")
				if(isnull(src)||!in_range(src, U)||U.machine!=src)
					U << browse(null, "window=aicard")
					U.unset_machine()
					return
				else
					flush = 1
					for(var/mob/living/silicon/ai/A in src)
						A.suiciding = 1
						A << "Your core files are being wiped!"
						while (A.stat != 2)
							A.adjustOxyLoss(2)
							A.updatehealth()
							sleep(10)
						flush = 0

		if ("Wireless")
			for(var/mob/living/silicon/ai/A in src)
				A.control_disabled = !A.control_disabled
				A << "The intelicard's wireless port has been [A.control_disabled ? "disabled" : "enabled"]!"
				update_icon()
	attack_self(U)

/obj/item/device/aicard/update_icon()
	var/mob/living/silicon/ai/occupant = locate() in src
	overlays.Cut()
	if(occupant)
		if (occupant.control_disabled)
			overlays -= image('icons/obj/pda.dmi', "aicard-on")
		else
			overlays += image('icons/obj/pda.dmi', "aicard-on")
		if(occupant.stat)
			icon_state = "aicard-404"
		else
			icon_state = "aicard-full"
	else
		icon_state = "aicard"

/obj/item/device/aicard/proc/grab_ai(var/mob/living/silicon/ai/ai, var/mob/living/user)

	if(!ai.client)
		user << "\red <b>ERROR</b>: \black [name] data core is offline. Unable to download."
		return 0

	if(locate(/mob/living/silicon/ai) in src)
		user << "\red <b>Transfer failed</b>: \black Existing AI found on remote terminal. Remove existing AI to install a new one."
		return 0

	if(ai.is_malf())
		user << "\red <b>ERROR</b>: \black Remote transfer interface disabled."
		return 0

	if(istype(ai.loc, /turf/))
		new /obj/structure/AIcore/deactivated(get_turf(ai))

	src.name = "inteliCard - [ai.name]"

	ai.loc = src
	ai.cancel_camera()
	ai.control_disabled = 1
	ai.aiRestorePowerRoutine = 0
	ai.aiRadio.disabledAi = 1
	carded_ai = ai


	ai.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been carded with [src.name] by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to card [ai.name] ([ai.ckey])</font>")
	msg_admin_attack("[user.name] ([user.ckey]) used the [src.name] to card [ai.name] ([ai.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	if(ai.client)
		ai << "You have been downloaded to a mobile storage device. Remote access lost."
	if(user.client)
		user << "\blue <b>Transfer successful</b>: \black [ai.name] ([rand(1000,9999)].exe) removed from host terminal and stored within local memory."

	update_icon()
	return 1

/obj/item/device/aicard/proc/clear()
	name = "inteliCard"
	carded_ai = null
	update_icon()

/obj/item/device/aicard/see_emote(mob/living/M, text)
	if(carded_ai && carded_ai.client)
		var/rendered = "<span class='message'>[text]</span>"
		carded_ai.show_message(rendered, 2)
	..()

/obj/item/device/aicard/show_message(msg, type, alt, alt_type)
	if(carded_ai && carded_ai.client)
		var/rendered = "<span class='message'>[msg]</span>"
		carded_ai.show_message(rendered, type)
	..()

/*
/obj/item/device/aicard/relaymove(var/mob/user, var/direction)
	if(src.loc && istype(src.loc.loc, /obj/item/rig_module))
		var/obj/item/rig_module/module = src.loc.loc
		if(!module.holder || !direction)
			return
		module.holder.forced_move(direction)*/
