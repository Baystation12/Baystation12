/obj/item/auto_cpr
	name = "stabilizer harness"
	desc = "A specialized medical harness that gives regular compressions to the patient's ribcage for cases of urgent heart issues, and functions as an emergency \
	artificial respirator for cases of urgent lung issues."
	icon = 'icons/obj/med_harness.dmi'
	icon_state = "med_harness"
	item_state = "med_harness"
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_MAGNET = 5, TECH_BIO = 3)
	slot_flags = SLOT_OCLOTHING
	var/panel_open = FALSE
	var/last_pump

	var/obj/item/cell/battery = null
	var/battery_level = 0
	var/charge_cost = 7 // 7 for 1 active function. Total of 14 if both CPR and EPP are doing their thing
	var/cpr_mode = TRUE // Auto-Compressor system. Can be toggled on/off

	var/mob/living/carbon/human/breather = null
	var/obj/item/clothing/mask/breath/breath_mask = null
	var/obj/item/tank/tank = null
	var/tank_level = 0
	var/tank_type = null
	var/mask_on = FALSE
	#define EPP "Emergency Positive Pressure system"
	var/epp_mode = FALSE // Emergency Positive Pressure system. Can be toggled on/off
	var/epp_active = FALSE

/obj/item/auto_cpr/Initialize()
	. = ..()
	battery = new /obj/item/cell/high(src)
	breath_mask = new /obj/item/clothing/mask/breath/medical(src)
	tank = new /obj/item/tank/oxygen_emergency_extended(src)
	update_icon()

/obj/item/auto_cpr/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	QDEL_NULL(battery)
	if(breather)
		breath_mask_off()
	QDEL_NULL(breath_mask)
	QDEL_NULL(tank)
	return ..()

/obj/item/auto_cpr/update_icon()
	item_state = "[cpr_mode ? "med_harness_cpr" : "[initial(item_state)]"]"

	if(breath_mask)
		AddOverlays("mask_[mask_on ? "worn" : "idle"]")
	if(battery)
		switch(battery.percent())
			if(90 to INFINITY)	battery_level = 6
			if(80 to 90)		battery_level = 5
			if(60 to 79)		battery_level = 4
			if(40 to 59)		battery_level = 3
			if(20 to 39)		battery_level = 2
			if(05 to 19)		battery_level = 1
			if(-INFINITY to 4)	battery_level = 0
		AddOverlays("battery[battery_level]")
	if(tank)
		switch(tank.percent())
			if(90 to INFINITY)	tank_level = 6
			if(80 to 90)		tank_level = 5
			if(60 to 79)		tank_level = 4
			if(40 to 59)		tank_level = 3
			if(20 to 39)		tank_level = 2
			if(05 to 19)		tank_level = 1
			if(-INFINITY to 4)	tank_level = 0
		AddOverlays("tank_indicator[tank_level]")

		if(istype(tank, /obj/item/tank/oxygen_emergency_extended))
			tank_type = "engi"
		else if(istype(tank, /obj/item/tank/oxygen_emergency))
			tank_type = "oxy"
		else
			tank_type = "other"
		AddOverlays("tank_[tank_type]")
	if(epp_active)
		AddOverlays("epp_active")
	if(panel_open)
		AddOverlays("panel_open[battery ? "_battery" : ""]")

/obj/item/auto_cpr/mob_can_equip(mob/living/carbon/human/H, slot, disable_warning = 0, force = 0)
	. = ..()
	if(slot == slot_wear_suit)
		if(panel_open)
			return FALSE
		return
	if(force || !istype(H) || slot != slot_wear_suit)
		return
	if(H.species.get_bodytype() in list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI))
		return
	else
		return FALSE

/obj/item/auto_cpr/attack(mob/living/carbon/human/H, mob/living/user, target_zone)
	if(istype(H) && user.a_intent == I_HELP)
		if(panel_open)
			to_chat(user, SPAN_WARNING("You must screw \the [src]'s panel closed before fitting it onto anyone!"))
			return 1
		if(H.wear_suit)
			to_chat(user, SPAN_WARNING("Their [H.wear_suit] is in the way, remove it first!"))
			return 1
		user.visible_message(SPAN_NOTICE("[user] starts fitting \the [src] onto [H]'s chest."))

		if(!do_after(user, 2 SECONDS, H))
			to_chat(user, SPAN_DANGER("Failed fitting \the [src] onto [H]! Both you and [H] must remain still for you to do that!"))
			return

		if(user.unEquip(src))
			if(!H.equip_to_slot_if_possible(src, slot_wear_suit))
				user.put_in_active_hand(src)
			return 1
	else
		return ..()

/obj/item/auto_cpr/attackby(obj/item/W, mob/user)
	if(W.IsScrewdriver())
		if(ishuman(loc))
			var/mob/living/carbon/human/H = loc
			if(H.get_inventory_slot(src) == slot_wear_suit)
				to_chat(user, SPAN_WARNING("You must unequip \the [src] before doing that!"))
				return TRUE
		panel_open = !panel_open
		user.visible_message(SPAN_NOTICE("[user] screws \the [src]'s panel [panel_open ? "open" : "closed"]."), SPAN_NOTICE("You screw \the [src]'s panel [panel_open ? "open" : "closed"]."))
		update_icon()
		return TRUE

	if(panel_open)
		if(W.IsWrench())
			if(!tank)
				to_chat(user, "There isn't a tank to remove!")
				return TRUE
			user.visible_message(SPAN_NOTICE("[user] removes \the [tank] from \the [src]."), SPAN_NOTICE("You remove \the [tank] from \the [src]."))
			tank.forceMove(user.loc)
			user.put_in_hands(tank)
			tank = null
			update_icon()
			return TRUE
		if(W.IsCrowbar())
			if(!battery)
				to_chat(user, "There isn't a battery to remove!")
				return TRUE
			user.visible_message(SPAN_NOTICE("[user] removes \the [battery] from \the [src]."), SPAN_NOTICE("You remove \the [battery] from \the [src]."))
			battery.forceMove(user.loc)
			user.put_in_hands(battery)
			battery = null
			update_icon()
			return TRUE
		if(istype(W, /obj/item/cell))
			if(battery)
				to_chat(user, "There is already \a [battery] installed.")
				return TRUE
			user.drop_from_inventory(W, src)
			battery = W
			user.visible_message(SPAN_NOTICE("[user] places \the [W] in \the [src]."), SPAN_NOTICE("You place \the [W] in \the [src]."))
			update_icon()
			return TRUE
		if(istype(W, /obj/item/clothing/mask/breath))
			if(breath_mask)
				to_chat(user, "There is already \a [breath_mask] installed.")
				return TRUE
			user.drop_from_inventory(W, src)
			breath_mask = W
			user.visible_message(SPAN_NOTICE("[user] places \the [W] in \the [src]."), SPAN_NOTICE("You place \the [W] in \the [src]."))
			update_icon()
			return TRUE
		if(istype(W, /obj/item/tank/oxygen_emergency))
			if(tank)
				to_chat(user, "There is already \a [tank] installed!")
				return TRUE
			user.drop_from_inventory(W, src)
			tank = W
			user.visible_message(SPAN_NOTICE("[user] places \the [W] in \the [src]."), SPAN_NOTICE("You place \the [W] in \the [src]."))
			update_icon()
			return TRUE

/obj/item/auto_cpr/attack_self(mob/user)
	if(panel_open)
		if(!breath_mask)
			to_chat(user, "There isn't an installed mask to remove!")
			return
		user.visible_message(SPAN_NOTICE("[user] removes \the [breath_mask] from \the [src]."), SPAN_NOTICE("You remove \the [breath_mask] from \the [src]."))
		breath_mask.forceMove(user.loc)
		user.put_in_hands(breath_mask)
		breath_mask = null
		update_icon()
		return
	var/list/options = list(
		"Toggle CPR" = image('icons/screen/radial.dmi', "cpr_mode"),
		"Toggle EPP" = image('icons/screen/radial.dmi', "iv_epp"))
	var/chosen_action = show_radial_menu(user, src, options, require_near = TRUE, radius = 42, tooltips = TRUE)
	if(!chosen_action)
		return
	switch(chosen_action)
		if("Toggle CPR")
			toggle_cpr()
		if("Toggle EPP")
			toggle_epp()

/obj/item/auto_cpr/attack_hand(mob/user)
	..()

/obj/item/auto_cpr/emp_act(severity)
	epp_off()
	cpr_mode = FALSE
	if(battery)
		battery.emp_act(severity)
	update_icon()

/obj/item/auto_cpr/get_cell()
	return battery

/obj/item/auto_cpr/equipped(mob/user, slot)
	..()
	START_PROCESSING(SSprocessing,src)

/obj/item/auto_cpr/dropped(mob/user)
	STOP_PROCESSING(SSprocessing,src)
	..()

/obj/item/auto_cpr/Process()
	if(!ishuman(loc))
		return PROCESS_KILL

	var/mob/living/carbon/human/H = loc
	if(H.get_inventory_slot(src) != slot_wear_suit)
		if(mask_on)
			breath_mask_off()
		update_icon()
		return PROCESS_KILL
	if(!battery)
		return PROCESS_KILL
	if(battery.charge <= 0)
		if(epp_mode)
			epp_off()
		if(cpr_mode)
			cpr_mode = FALSE
		visible_message(SPAN_WARNING("\The [src] sputters as it runs out of charge!"))
		playsound(src, 'sound/machines/synth_no.ogg', 50)
		update_icon()
		return PROCESS_KILL

	if(cpr_mode)
		cpr_process(H)
	if(epp_mode)
		epp_process(H)
	H.update_inv_wear_suit()
	update_icon()

/obj/item/auto_cpr/proc/cpr_process(mob/living/carbon/human/H)
	if(world.time > last_pump + 10 SECONDS)
		last_pump = world.time
		playsound(src, 'sound/machines/pump.ogg', 25)
		var/obj/item/organ/internal/heart/heart = H.internal_organs_by_name[BP_HEART]
		if(heart)
			heart.external_pump = list(world.time, 0.6)
		battery.use(charge_cost)

	if(H.is_asystole())
		if(H.stat != DEAD && prob(10))
			H.resuscitate()
		if(prob(5 * rand(2, 3)))
			var/obj/item/organ/external/chest = H.get_organ(BP_CHEST)
			if(chest)
				chest.fracture()

/obj/item/auto_cpr/proc/epp_process(mob/living/carbon/human/H)
	if(!tank || !breath_mask)
		src.visible_message(SPAN_WARNING("Error! Vital component for \the [src]'s Emergency Positive Pressure System missing! Turning function off."))
		epp_off()
		return
	if(!mask_on)
		breath_mask_on(H)
		return

	var/obj/item/organ/internal/lungs/lungs = H.internal_organs_by_name[BP_LUNGS]
	var/safe_pressure_min = H.species.breath_pressure + 2
	safe_pressure_min *= 1 + rand(1,4) * lungs.damage/lungs.max_damage
	if(!lungs)
		epp_off()
		return
	if(lungs.is_bruised() == FALSE)
		src.visible_message(SPAN_WARNING("Error! Patient safety check triggered! Turning the Emergency Positive Pressure System off."))
		epp_off()
		return
	if(tank.air_contents.return_pressure() <= 10)
		src.visible_message(SPAN_WARNING("Error! Installed [tank] is low or near empty! Turning the Emergency Positive Pressure System off."))
		epp_off()
		return

	if(lungs.is_bruised())
		if(!epp_active)
			src.visible_message(SPAN_WARNING("\The [src] beeps, activating it's Emergency Positive Pressure System!"))
			tank.forceMove(H)
			H.internal = tank
			if(H.internals)
				H.internals.icon_state = "internal1"
			playsound(H, 'sound/machines/windowdoor.ogg', 50)
			epp_active = TRUE
		tank.distribute_pressure = safe_pressure_min
		H.losebreath = 0
		to_chat(H, SPAN_NOTICE("You feel fresh air being pushed into your lungs."))
		battery.use(charge_cost)

/obj/item/auto_cpr/proc/breath_mask_on(mob/living/carbon/human/H)
	if(!H.organs_by_name[BP_HEAD])
		src.visible_message(SPAN_WARNING("Error! Patient lacks a head!"))[EPP]
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50)
		return
	if(H.wear_mask)
		src.visible_message(SPAN_WARNING("Error! Access to patient's mouth is obstructed!"))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50)
		return
	src.visible_message(SPAN_INFO("\The [src] automatically fastens \the [breath_mask] onto \the [H]."))
	playsound(H, 'sound/effects/buckle.ogg', 50)
	breath_mask.forceMove(H.loc)
	H.equip_to_slot(breath_mask, slot_wear_mask)
	H.update_inv_wear_mask()
	breather = H
	mask_on = TRUE
	update_icon()

/obj/item/auto_cpr/proc/breath_mask_off()
	src.visible_message(SPAN_WARNING("\The [src] automatically retracts \the [breath_mask]!"))
	if(epp_active)
		tank.forceMove(src)
		if(breather.internals)
			breather.internals.icon_state = "internal0"
		breather.internal = null
		epp_active = FALSE
	if(breath_mask.hanging)
		breath_mask.hanging = FALSE
		breath_mask.update_clothing_icon()
	if(breath_mask.loc != breather)
		var/loc_check = breath_mask.loc
		if(ismob(loc_check))
			var/mob/living/carbon/human/holder = loc_check
			holder.remove_from_mob(breath_mask)
			holder.update_inv_wear_mask()
			holder.update_inv_l_hand()
			holder.update_inv_r_hand()
		breath_mask.forceMove(src)
		breather = null
		mask_on = FALSE
		return
	breather.remove_from_mob(breath_mask)
	breather.update_inv_wear_mask()
	breath_mask.forceMove(src)
	breather = null
	mask_on = FALSE

/obj/item/auto_cpr/proc/epp_off()
	if(mask_on)
		breath_mask_off()
	playsound(src, 'sound/machines/buzz-two.ogg', 50)
	epp_mode = FALSE

/obj/item/auto_cpr/proc/toggle_check(mob/user)
	if(!ishuman(user) && !issilicon(user))
		to_chat(user, SPAN_WARNING("This mob cannot use this!"))
		return
	if(user.stat || user.incapacitated())
		to_chat(user, SPAN_WARNING("You are in no shape to do this."))
		return
	return TRUE

/obj/item/auto_cpr/verb/toggle_epp()
	set category = "Object"
	set name = "Toggle EPP"
	set src in usr

	if(!toggle_check(usr))
		return
	if(battery?.charge <= 0)
		to_chat(usr, SPAN_WARNING("\The [src] doesn't have enough power for you to do that!"))
		playsound(src, 'sound/machines/synth_no.ogg', 50)
		return
	if(epp_mode)
		epp_off()
		to_chat(usr, SPAN_NOTICE("You toggle \the [src]'s Emergency Positive Pressure System off."))
		return
	epp_mode = TRUE
	to_chat(usr, SPAN_NOTICE("You toggle \the [src]'s Emergency Positive Pressure System on."))
	playsound(usr, 'sound/machines/click.ogg', 50)
	update_icon()

/obj/item/auto_cpr/verb/toggle_cpr()
	set category = "Object"
	set name = "Toggle CPR"
	set src in usr

	if(!toggle_check(usr))
		return
	if(battery?.charge <= 0)
		to_chat(usr, SPAN_WARNING("\The [src] doesn't have enough power for you to do that!"))
		playsound(src, 'sound/machines/synth_no.ogg', 50)
		return
	cpr_mode = !cpr_mode
	to_chat(usr, SPAN_NOTICE("You toggle \the [src]'s Auto CPR system [cpr_mode ? "on" : "off"]."))
	playsound(usr, 'sound/machines/click.ogg', 50)
	update_icon()

/obj/item/auto_cpr/examine(mob/user)
	..(user)
	if(!user.Adjacent(src))
		return
	to_chat(user, SPAN_NOTICE("\The [src]'s Emergency Positive Pressure System is currently [epp_mode ? "on" : "off"], while the Auto CPR is [cpr_mode ? "on" : "off"]."))
	if(battery)
		to_chat(user, SPAN_NOTICE("It currently has a battery with [battery.percent()]% charge."))
	if(tank)
		to_chat(user, SPAN_NOTICE("It has [icon2html(tank, user)] \the [tank] installed. The meter shows [round(tank.air_contents.return_pressure())]kPa, \
		with the pressure set to [round(tank.distribute_pressure)]kPa.[epp_active ? " The Emergency Positive Pressure System is active." : ""]"))
	if(breath_mask)
		to_chat(user, SPAN_NOTICE("It has [icon2html(breath_mask, user)] \the [breath_mask] installed."))

#undef EPP
