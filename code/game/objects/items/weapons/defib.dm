#define DEFIB_TIME_LIMIT (8 MINUTES) //past this many secons, defib is useless. Currently 8 Minutes
#define DEFIB_TIME_LOSS  (2 MINUTES) //past this many seconds, brain damage occurs. Currently 2 minutes

//backpack item
/obj/item/weapon/defibrillator
	name = "defibrillator"
	desc = "A device that delivers powerful shocks to detachable paddles that resuscitate incapacitated patients."
	icon = 'icons/obj/defibrillator.dmi'
	icon_state = "defibunit"
	item_state = "defibunit"
	slot_flags = SLOT_BACK
	force = 5
	throwforce = 6
	w_class = ITEM_SIZE_LARGE
	origin_tech = list(TECH_BIO = 4, TECH_POWER = 2)
	action_button_name = "Remove/Replace Paddles"

	var/obj/item/weapon/shockpaddles/linked/paddles
	var/obj/item/weapon/cell/bcell = null

/obj/item/weapon/defibrillator/New() //starts without a cell for rnd
	..()
	if(ispath(paddles))
		paddles = new paddles(src, src)
	else
		paddles = new(src, src)

	if(ispath(bcell))
		bcell = new bcell(src)
	update_icon()

/obj/item/weapon/defibrillator/Destroy()
	. = ..()
	qdel_null(paddles)
	qdel_null(bcell)

/obj/item/weapon/defibrillator/loaded //starts with highcap cell
	bcell = /obj/item/weapon/cell/high


/obj/item/weapon/defibrillator/update_icon()
	var/list/new_overlays = list()

	if(paddles) //in case paddles got destroyed somehow.
		if(paddles.loc == src)
			new_overlays += "[initial(icon_state)]-paddles"
		if(bcell && !bcell.check_charge(paddles.chargecost))
			new_overlays += "[initial(icon_state)]-powered"
		if(!paddles.safety)
			new_overlays += "[initial(icon_state)]-emagged"

	if(bcell)
		var/ratio = Ceiling(bcell.percent()/25) * 25
		new_overlays += "[initial(icon_state)]-charge[ratio]"
	else
		new_overlays += "[initial(icon_state)]-nocell"

	overlays = new_overlays

/obj/item/weapon/defibrillator/ui_action_click()
	toggle_paddles()

/obj/item/weapon/defibrillator/attack_hand(mob/user)
	if(loc == user)
		toggle_paddles()
	else
		..()

/obj/item/weapon/defibrillator/MouseDrop()
	if(ismob(src.loc))
		if(!CanMouseDrop(src))
			return
		var/mob/M = src.loc
		if(!M.unEquip(src))
			return
		src.add_fingerprint(usr)
		M.put_in_any_hand_if_possible(src)


/obj/item/weapon/defibrillator/attackby(obj/item/weapon/W, mob/user, params)
	if(W == paddles)
		reattach_paddles(user)
	else if(istype(W, /obj/item/weapon/cell))
		if(bcell)
			to_chat(user, "<span class='notice'>\the [src] already has a cell.</span>")
		else
			if(!user.unEquip(W))
				return
			W.forceMove(src)
			bcell = W
			to_chat(user, "<span class='notice'>You install a cell in \the [src].</span>")
			update_icon()

	else if(isscrewdriver(W))
		if(bcell)
			bcell.update_icon()
			bcell.forceMove(get_turf(src.loc))
			bcell = null
			to_chat(user, "<span class='notice'>You remove the cell from \the [src].</span>")
			update_icon()
	else
		return ..()

/obj/item/weapon/defibrillator/emag_act(mob/user)
	if(paddles)
		return paddles.emag_act(user)
	return NO_EMAG_ACT

//Paddle stuff

/obj/item/weapon/defibrillator/verb/toggle_paddles()
	set name = "Toggle Paddles"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(!paddles)
		to_chat(user, "<span class='warning'>The paddles are missing!</span>")
		return

	if(paddles.loc != src)
		reattach_paddles(user) //Remove from their hands and back onto the defib unit
		return

	if(!slot_check())
		to_chat(user, "<span class='warning'>You need to equip [src] before taking out [paddles].</span>")
	else 
		if(!usr.put_in_hands(paddles)) //Detach the paddles into the user's hands
			to_chat(user, "<span class='warning'>You need a free hand to hold the paddles!</span>")
		update_icon() //success

//checks that the base unit is in the correct slot to be used
/obj/item/weapon/defibrillator/proc/slot_check()
	var/mob/M = loc
	if(!istype(M))
		return 0 //not equipped

	if((slot_flags & SLOT_BACK) && M.get_equipped_item(slot_back) == src)
		return 1
	if((slot_flags & SLOT_BELT) && M.get_equipped_item(slot_belt) == src)
		return 1

	return 0

/obj/item/weapon/defibrillator/dropped(mob/user)
	..()
	reattach_paddles(user) //paddles attached to a base unit should never exist outside of their base unit or the mob equipping the base unit

/obj/item/weapon/defibrillator/proc/reattach_paddles(mob/user)
	if(!paddles) return

	if(ismob(paddles.loc))
		var/mob/M = paddles.loc
		if(M.drop_from_inventory(paddles, src))
			to_chat(user, "<span class='notice'>\The [paddles] snap back into the main unit.</span>")
	else
		paddles.forceMove(src)

	update_icon()

/*
	Base Unit Subtypes
*/

/obj/item/weapon/defibrillator/compact
	name = "compact defibrillator"
	desc = "A belt-equipped defibrillator that can be rapidly deployed."
	icon_state = "defibcompact"
	item_state = "defibcompact"
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_BIO = 5, TECH_POWER = 3)

/obj/item/weapon/defibrillator/compact/loaded
	bcell = /obj/item/weapon/cell/high


/obj/item/weapon/defibrillator/compact/combat
	name = "combat defibrillator"
	desc = "A belt-equipped blood-red defibrillator that can be rapidly deployed. Does not have the restrictions or safeties of conventional defibrillators and can revive through space suits."
	paddles = /obj/item/weapon/shockpaddles/linked/combat

/obj/item/weapon/defibrillator/compact/combat/loaded
	bcell = /obj/item/weapon/cell/high

/obj/item/weapon/shockpaddles/linked/combat
	combat = 1
	safety = 0
	chargetime = (1 SECONDS)


//paddles

/obj/item/weapon/shockpaddles
	name = "defibrillator paddles"
	desc = "A pair of plastic-gripped paddles with flat metal surfaces that are used to deliver powerful electric shocks."
	icon = 'icons/obj/defibrillator.dmi'
	icon_state = "defibpaddles"
	item_state = "defibpaddles"
	gender = PLURAL
	force = 2
	throwforce = 6
	w_class = ITEM_SIZE_LARGE

	var/safety = 1 //if you can zap people with the paddles on harm mode
	var/combat = 0 //If it can be used to revive people wearing thick clothing (e.g. spacesuits)
	var/cooldowntime = (6 SECONDS) // How long in deciseconds until the defib is ready again after use.
	var/chargetime = (2 SECONDS)
	var/chargecost = 100 //units of charge
	var/burn_damage_amt = 15

	var/wielded = 0
	var/cooldown = 0
	var/busy = 0

/obj/item/weapon/shockpaddles/proc/set_cooldown(var/delay)
	cooldown = 1
	update_icon()

	spawn(delay)
		if(cooldown)
			cooldown = 0
			update_icon()

			make_announcement("beeps, \"Unit is re-energized.\"", "notice")
			playsound(src, 'sound/machines/defib_ready.ogg', 50, 0)

/obj/item/weapon/shockpaddles/update_twohanding()
	var/mob/living/M = loc
	if(istype(M) && is_held_twohanded(M))
		wielded = 1
		name = "[initial(name)] (wielded)"
	else
		wielded = 0
		name = initial(name)
	update_icon()
	..()

/obj/item/weapon/shockpaddles/update_icon()
	icon_state = "defibpaddles[wielded]"
	item_state = "defibpaddles[wielded]"
	if(cooldown)
		icon_state = "defibpaddles[wielded]_cooldown"

/obj/item/weapon/shockpaddles/proc/can_use(mob/user, mob/M)
	if(busy)
		return 0
	if(!check_charge(chargecost))
		to_chat(user, "<span class='warning'>\The [src] doesn't have enough charge left to do that.</span>")
		return 0
	if(!wielded && !isrobot(user))
		to_chat(user, "<span class='warning'>You need to wield the paddles with both hands before you can use them on someone!</span>")
		return 0
	if(cooldown)
		to_chat(user, "<span class='warning'>\The [src] are re-energizing!</span>")
		return 0
	return 1

//Checks for various conditions to see if the mob is revivable
/obj/item/weapon/shockpaddles/proc/can_defib(mob/living/carbon/human/H) //This is checked before doing the defib operation
	if((H.species.flags & NO_SCAN) || H.isSynthetic())
		return "buzzes, \"Unrecogized physiology. Operation aborted.\""

	if(H.stat != DEAD)
		return "buzzes, \"Patient is not in a valid state. Operation aborted.\""

	if(check_contact(H))
		return "buzzes, \"Patient's chest is obstructed. Operation aborted.\""

	return null

/obj/item/weapon/shockpaddles/proc/can_revive(mob/living/carbon/human/H) //This is checked right before attempting to revive

	var/deadtime = world.time - H.timeofdeath
	if (deadtime > DEFIB_TIME_LIMIT)
		return "buzzes, \"Resuscitation failed - Excessive neural degeneration. Further attempts futile.\""

	if((H.getFireLoss() + H.getBruteLoss() + H.getCloneLoss() + burn_damage_amt) >= (H.maxHealth - config.health_threshold_dead) || HUSK in H.mutations)
		return "buzzes, \"Resuscitation failed - Severe tissue damage makes recovery of patient impossible via defibrillator. Further attempts futile.\""

	var/bad_vital_organ = check_vital_organs(H)
	if(bad_vital_organ)
		return bad_vital_organ

	//this needs to be last since if any of the 'further attempts futile' conditions are met their messages take precedence
	if(H.ssd_check())
		return "buzzes, \"Resuscitation failed - Mental interface error. Further attempts may be successful.\""

	return null

/obj/item/weapon/shockpaddles/proc/check_contact(mob/living/carbon/human/H)
	if(combat) return TRUE //can be used through any clothing

	for(var/obj/item/clothing/cloth in list(H.wear_suit, H.w_uniform))
		if((cloth.body_parts_covered & UPPER_TORSO) && (cloth.item_flags & THICKMATERIAL))
			return TRUE
	return FALSE

/obj/item/weapon/shockpaddles/proc/check_vital_organs(mob/living/carbon/human/H)
	for(var/organ_tag in H.species.has_organ)
		var/obj/item/organ/O = H.species.has_organ[organ_tag]
		var/name = initial(O.name)
		var/vital = initial(O.vital) //check for vital organs
		if(vital) 
			O = H.internal_organs_by_name[organ_tag]
			if(!O)
				return "buzzes, \"Resuscitation failed - Patient is missing vital organ ([name]). Further attempts futile.\""
			if(O.damage > O.max_damage)
				return "buzzes, \"Resuscitation failed - Excessive damage to vital organ ([name]). Further attempts futile.\""
	return null

/obj/item/weapon/shockpaddles/proc/check_charge(var/charge_amt)
	return 0

/obj/item/weapon/shockpaddles/proc/checked_use(var/charge_amt)
	return 0

/obj/item/weapon/shockpaddles/attack(mob/living/M, mob/living/user, var/target_zone)
	var/mob/living/carbon/human/H = M
	if(!istype(H) || user.a_intent == I_HURT)
		return ..() //Do a regular attack. Harm intent shocking happens as a hit effect

	if(can_use(user, H))
		busy = 1
		update_icon()

		do_revive(H, user)

		busy = 0
		update_icon()

	return 1

//Since harm-intent now skips the delay for deliberate placement, you have to be able to hit them in combat in order to shock people.
/obj/item/weapon/shockpaddles/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	if(ishuman(target) && can_use(user, target))
		busy = 1
		update_icon()

		do_electrocute(target, user, hit_zone)

		busy = 0
		update_icon()

		return 1

	return ..()

// This proc is used so that we can return out of the revive process while ensuring that busy and update_icon() are handled
/obj/item/weapon/shockpaddles/proc/do_revive(mob/living/carbon/human/H, mob/user)
	if(H.ssd_check())
		to_chat(find_dead_player(H.ckey, 1), "Someone is attempting to resuscitate you. Re-enter your body if you want to be revived!")

	//beginning to place the paddles on patient's chest to allow some time for people to move away to stop the process
	user.visible_message("<span class='warning'>\The [user] begins to place [src] on [H]'s chest.</span>", "<span class='warning'>You begin to place [src] on [H]'s chest...</span>")
	if(!do_after(user, 30, H))
		return
	user.visible_message("<span class='notice'>\The [user] places [src] on [H]'s chest.</span>", "<span class='warning'>You place [src] on [H]'s chest.</span>")
	playsound(get_turf(src), 'sound/machines/defib_charge.ogg', 50, 0)

	var/error = can_defib(H)
	if(error)
		make_announcement(error, "warning")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		return

	//placed on chest and short delay to shock for dramatic effect, revive time is 5sec total
	if(!do_after(user, chargetime, H))
		return

	//deduct charge here, in case the base unit was EMPed or something during the delay time
	if(!checked_use(chargecost))
		make_announcement("buzzes, \"Insufficient charge.\"", "warning")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		return

	H.visible_message("<span class='warning'>\The [H]'s body convulses a bit.</span>")
	playsound(get_turf(src), "bodyfall", 50, 1)
	playsound(get_turf(src), 'sound/machines/defib_zap.ogg', 50, 1, -1)
	set_cooldown(cooldowntime)

	error = can_revive(H)
	if(error)
		make_announcement(error, "warning")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		return

	H.apply_damage(burn_damage_amt, BURN, BP_CHEST)

	//set oxyloss so that the patient is just barely in crit, if possible
	var/barely_in_crit = round((8*config.health_threshold_crit + config.health_threshold_dead)/9, 1)
	var/adjust_health = barely_in_crit - H.health //need to increase health by this much
	H.adjustOxyLoss(-adjust_health)

	make_announcement("pings, \"Resuscitation successful.\"", "notice")
	playsound(get_turf(src), 'sound/machines/defib_success.ogg', 50, 0)

	make_alive(H)

	log_and_message_admins("used \a [src] to revive [key_name(H)].")


/obj/item/weapon/shockpaddles/proc/do_electrocute(mob/living/carbon/human/H, mob/user, var/target_zone)
	var/obj/item/organ/external/affecting = H.get_organ(target_zone)
	if(!affecting)
		to_chat(user, "<span class='warning'>They are missing that body part!</span>")
		return

	//no need to spend time carefully placing the paddles, we're just trying to shock them
	user.visible_message("<span class='danger'>\The [user] slaps [src] onto [H]'s [affecting.name].</span>", "<span class='danger'>You overcharge [src] and slap them onto [H]'s [affecting.name].</span>")

	//Just stop at awkwardly slapping electrodes on people if the safety is enabled
	if(safety)
		to_chat(user, "<span class='warning'>You can't do that while the safety is enabled.</span>")
		return

	playsound(get_turf(src), 'sound/machines/defib_charge.ogg', 50, 0)
	audible_message("<span class='warning'>\The [src] lets out a steadily rising hum...</span>")

	if(!do_after(user, chargetime, H))
		return

	//deduct charge here, in case the base unit was EMPed or something during the delay time
	if(!checked_use(chargecost))
		make_announcement("buzzes, \"Insufficient charge.\"", "warning")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		return

	user.visible_message("<span class='danger'><i>\The [user] shocks [H] with \the [src]!</i></span>", "<span class='warning'>You shock [H] with \the [src]!</span>")
	playsound(get_turf(src), 'sound/machines/defib_zap.ogg', 100, 1, -1)
	playsound(loc, 'sound/weapons/Egloves.ogg', 100, 1, -1)
	set_cooldown(cooldowntime)

	H.stun_effect_act(2, 120, target_zone)
	var/burn_damage = H.electrocute_act(burn_damage_amt*2, src, def_zone = target_zone)
	if(burn_damage > 15 && H.can_feel_pain())
		H.emote("scream")

	admin_attack_log(user, H, "Electrocuted using \a [src]", "Was electrocuted with \a [src]", "used \a [src] to electrocute")

/obj/item/weapon/shockpaddles/proc/make_alive(mob/living/carbon/human/M) //This revives the mob
	M.switch_from_dead_to_living_mob_list()
	M.timeofdeath = 0
	M.stat = UNCONSCIOUS //Life() can bring them back to consciousness if it needs to.
	M.regenerate_icons()
	M.failed_last_breath = 0 //So mobs that died of oxyloss don't revive and have perpetual out of breath.
	M.reload_fullscreen()

	M.emote("gasp")
	M.Weaken(rand(10,25))

	var/deadtime = world.time - M.timeofdeath
	apply_brain_damage(M, deadtime)

/obj/item/weapon/shockpaddles/proc/apply_brain_damage(mob/living/carbon/human/H, var/deadtime)
	if(deadtime < DEFIB_TIME_LOSS) return

	if(!H.should_have_organ(BP_BRAIN)) return //no brain

	var/obj/item/organ/internal/brain/brain = H.internal_organs_by_name[BP_BRAIN]
	if(!brain) return //no brain

	var/brain_damage = Clamp((deadtime - DEFIB_TIME_LOSS)/(DEFIB_TIME_LIMIT - DEFIB_TIME_LOSS)*brain.max_damage, H.getBrainLoss(), brain.max_damage)
	H.setBrainLoss(brain_damage)

/obj/item/weapon/shockpaddles/proc/make_announcement(var/message, var/msg_class)
	audible_message("<b>\The [src]</b> [message]", "\The [src] vibrates slightly.")

/obj/item/weapon/shockpaddles/emag_act(mob/user)
	if(safety)
		safety = 0
		to_chat(user, "<span class='warning'>You silently disable \the [src]'s safety protocols with the cryptographic sequencer.</span>")
		update_icon()
		return 1
	else
		safety = 1
		to_chat(user, "<span class='notice'>You silently enable \the [src]'s safety protocols with the cryptographic sequencer.</span>")
		update_icon()
		return 1

/obj/item/weapon/shockpaddles/emp_act(severity)
	var/new_safety = rand(0, 1)
	if(safety != new_safety)
		safety = new_safety
		if(safety)
			make_announcement("beeps, \"Safety protocols enabled!\"", "notice")
			playsound(get_turf(src), 'sound/machines/defib_safetyon.ogg', 50, 0)
		else
			make_announcement("beeps, \"Safety protocols disabled!\"", "warning")
			playsound(get_turf(src), 'sound/machines/defib_safetyoff.ogg', 50, 0)
		update_icon()
	..()

/* 
	Shockpaddles that are linked to a base unit
*/
/obj/item/weapon/shockpaddles/linked
	var/obj/item/weapon/defibrillator/base_unit

/obj/item/weapon/shockpaddles/linked/New(newloc, obj/item/weapon/defibrillator/defib)
	base_unit = defib
	..(newloc)

/obj/item/weapon/shockpaddles/linked/Destroy()
	if(base_unit)
		//ensure the base unit's icon updates
		if(base_unit.paddles == src)
			base_unit.paddles = null
			base_unit.update_icon()
		base_unit = null
	return ..()

/obj/item/weapon/shockpaddles/linked/dropped(mob/user)
	..() //update twohanding
	if(base_unit)
		base_unit.reattach_paddles(user) //paddles attached to a base unit should never exist outside of their base unit or the mob equipping the base unit

/obj/item/weapon/shockpaddles/linked/check_charge(var/charge_amt)
	return (base_unit.bcell && base_unit.bcell.check_charge(charge_amt))

/obj/item/weapon/shockpaddles/linked/checked_use(var/charge_amt)
	return (base_unit.bcell && base_unit.bcell.checked_use(charge_amt))

/obj/item/weapon/shockpaddles/linked/make_announcement(var/message, var/msg_class)
	base_unit.audible_message("<b>\The [base_unit]</b> [message]", "\The [base_unit] vibrates slightly.")

/*
	Standalone Shockpaddles
*/

/obj/item/weapon/shockpaddles/standalone
	desc = "A pair of shockpaddles powered by an experimental miniaturized reactor" //Inspired by the advanced e-gun
	var/fail_counter = 0

/obj/item/weapon/shockpaddles/standalone/Destroy()
	. = ..()
	if(fail_counter)
		processing_objects.Remove(src)

/obj/item/weapon/shockpaddles/standalone/check_charge(var/charge_amt)
	return 1

/obj/item/weapon/shockpaddles/standalone/checked_use(var/charge_amt)
	radiation_repository.radiate(src, charge_amt/12) //just a little bit of radiation. It's the price you pay for being powered by magic I guess
	return 1

/obj/item/weapon/shockpaddles/standalone/process()
	if(fail_counter > 0)
		radiation_repository.radiate(src, fail_counter--)
	else
		processing_objects.Remove(src)

/obj/item/weapon/shockpaddles/standalone/emp_act(severity)
	..()
	var/new_fail = 0
	switch(severity)
		if(1)
			new_fail = max(fail_counter, 20)
			visible_message("\The [src]'s reactor overloads!")
		if(2)
			new_fail = max(fail_counter, 8)
			if(ismob(loc))
				to_chat(loc, "<span class='warning'>\The [src] feel pleasantly warm.</span>")

	if(new_fail && !fail_counter)
		processing_objects.Add(src)
	fail_counter = new_fail

/obj/item/weapon/shockpaddles/standalone/traitor
	name = "defibrillator paddles"
	desc = "A pair of unusual looking paddles powered by an experimental miniaturized reactor. It possesses both the ability to penetrate armor and to deliver powerful shocks."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "defibpaddles0"
	item_state = "defibpaddles0"
	combat = 1
	safety = 0
	chargetime = (1 SECONDS)


#undef DEFIB_TIME_LIMIT
#undef DEFIB_TIME_LOSS
