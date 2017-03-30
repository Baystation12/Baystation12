/obj/item/weapon/aicard
	name = "inteliCard"
	icon = 'icons/obj/pda.dmi'
	icon_state = "aicard" // aicard-full
	item_state = "electronic"
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_BELT
	var/flush = null
	origin_tech = list(TECH_DATA = 4, TECH_MATERIAL = 4)

	var/mob/living/silicon/ai/carded_ai

/obj/item/weapon/aicard/attack(mob/living/silicon/decoy/M as mob, mob/user as mob)
	if (!istype (M, /mob/living/silicon/decoy))
		return ..()
	else
		M.death()
		to_chat(user, "<b>ERROR ERROR ERROR</b>")

/obj/item/weapon/aicard/attack_self(mob/user)

	ui_interact(user)

/obj/item/weapon/aicard/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = inventory_state)
	var/data[0]
	data["has_ai"] = carded_ai != null
	if(carded_ai)
		data["name"] = carded_ai.name
		data["hardware_integrity"] = carded_ai.hardware_integrity()
		data["backup_capacitor"] = carded_ai.backup_capacitor()
		data["radio"] = !carded_ai.aiRadio.disabledAi
		data["wireless"] = !carded_ai.control_disabled
		data["operational"] = carded_ai.stat != DEAD
		data["flushing"] = flush

		var/laws[0]
		for(var/datum/ai_law/AL in carded_ai.laws.all_laws())
			laws[++laws.len] = list("index" = AL.get_index(), "law" = sanitize(AL.law))
		data["laws"] = laws
		data["has_laws"] = laws.len

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "aicard.tmpl", "[name]", 600, 400, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/item/weapon/aicard/Topic(href, href_list, state)
	if(..())
		return 1

	if(!carded_ai)
		return 1

	var/user = usr
	if (href_list["wipe"])
		var/confirm = alert("Are you sure you want to wipe this card's memory? This cannot be undone once started.", "Confirm Wipe", "Yes", "No")
		if(confirm == "Yes" && (CanUseTopic(user, state) == STATUS_INTERACTIVE))
			admin_attack_log(user, carded_ai, "Wiped using \the [src.name]", "Was wiped with \the [src.name]", "used \the [src.name] to wipe")
			flush = 1
			to_chat(carded_ai, "Your core files are being wiped!")
			while (carded_ai && carded_ai.stat != DEAD)
				carded_ai.adjustOxyLoss(2)
				carded_ai.updatehealth()
				sleep(10)
			flush = 0
	if (href_list["radio"])
		carded_ai.aiRadio.disabledAi = text2num(href_list["radio"])
		to_chat(carded_ai, "<span class='warning'>Your Subspace Transceiver has been [carded_ai.aiRadio.disabledAi ? "disabled" : "enabled"]!</span>")
		to_chat(user, "<span class='notice'>You [carded_ai.aiRadio.disabledAi ? "disable" : "enable"] the AI's Subspace Transceiver.</span>")
	if (href_list["wireless"])
		carded_ai.control_disabled = text2num(href_list["wireless"])
		to_chat(carded_ai, "<span class='warning'>Your wireless interface has been [carded_ai.control_disabled ? "disabled" : "enabled"]!</span>")
		to_chat(user, "<span class='notice'>You [carded_ai.control_disabled ? "disable" : "enable"] the AI's wireless interface.</span>")
		update_icon()
	return 1

/obj/item/weapon/aicard/update_icon()
	overlays.Cut()
	if(carded_ai)
		if (!carded_ai.control_disabled)
			overlays += image('icons/obj/pda.dmi', "aicard-on")
		if(carded_ai.stat)
			icon_state = "aicard-404"
		else
			icon_state = "aicard-full"
	else
		icon_state = "aicard"

/obj/item/weapon/aicard/proc/grab_ai(var/mob/living/silicon/ai/ai, var/mob/living/user)
	if(!ai.client)
		to_chat(user, "<span class='danger'>ERROR:</span> AI [ai.name] is offline. Unable to download.")
		return 0

	if(carded_ai)
		to_chat(user, "<span class='danger'>Transfer failed:</span> Existing AI found on remote terminal. Remove existing AI to install a new one.")
		return 0

	if(ai.malfunctioning && ai.uncardable)
		to_chat(user, "<span class='danger'>ERROR:</span> Remote transfer interface disabled.")
		return 0

	if(istype(ai.loc, /turf/))
		new /obj/structure/AIcore/deactivated(get_turf(ai))

	ai.carded = 1
	admin_attack_log(user, ai, "Carded with [src.name]", "Was carded with [src.name]", "used the [src.name] to card")
	src.name = "[initial(name)] - [ai.name]"

	ai.forceMove(src)
	ai.destroy_eyeobj(src)
	ai.cancel_camera()
	ai.control_disabled = 1
	ai.aiRestorePowerRoutine = 0
	ai.calculate_power_usage()
	carded_ai = ai

	if(ai.client)
		to_chat(ai, "You have been downloaded to a mobile storage device. Remote access lost.")
	if(user.client)
		to_chat(user, "<span class='notice'><b>Transfer successful:</b></span> [ai.name] ([rand(1000,9999)].exe) removed from host terminal and stored within local memory.")

	ai.canmove = 1
	update_icon()
	return 1

/obj/item/weapon/aicard/proc/clear()
	if(carded_ai && istype(carded_ai.loc, /turf))
		carded_ai.canmove = 0
		carded_ai.carded = 0
	name = initial(name)
	carded_ai.calculate_power_usage()
	carded_ai = null
	update_icon()

/obj/item/weapon/aicard/see_emote(mob/living/M, text)
	if(carded_ai && carded_ai.client)
		var/rendered = "<span class='message'>[text]</span>"
		carded_ai.show_message(rendered, 2)
	..()

/obj/item/weapon/aicard/show_message(msg, type, alt, alt_type)
	if(carded_ai && carded_ai.client)
		var/rendered = "<span class='message'>[msg]</span>"
		carded_ai.show_message(rendered, type)
	..()

/obj/item/weapon/aicard/relaymove(var/mob/user, var/direction)
	if(user.stat || user.stunned)
		return
	var/obj/item/weapon/rig/rig = src.get_rig()
	if(istype(rig))
		rig.forced_move(direction, user)
