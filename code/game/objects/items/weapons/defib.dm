#define DEFIB_TIME_LIMIT 480 //past this many secons, defib is useless. Currently 8 Minutes
#define DEFIB_TIME_LOSS 120 //past this many seconds, brain damage occurs. Currently 2 minutes

//backpack item
/obj/item/weapon/defibrillator
	name = "defibrillator"
	desc = "A device that delivers powerful shocks to detachable paddles that resuscitate incapacitated patients."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "defibunit"
	item_state = "defibunit"
	slot_flags = SLOT_BACK
	force = 5
	throwforce = 6
	w_class = ITEM_SIZE_LARGE
	origin_tech = "biotech=4"

	var/on = 0 //if the paddles are equipped (1) or on the defib (0)
	var/safety = 1 //if you can zap people with the defibs on harm mode
	var/powered = 0 //if there's a cell in the defib with enough power for a revive, blocks paddles from reviving otherwise
	var/obj/item/weapon/twohanded/shockpaddles/paddles
	var/combat = 0 //can we revive through space suits?
	var/grab_ghost = FALSE // Do we pull the ghost back into their body?
	var/obj/item/weapon/cell/bcell = null

/obj/item/weapon/defibrillator/New() //starts without a cell for rnd
	..()
	paddles = make_paddles()
	if(ispath(bcell))
		bcell = new bcell(src)
	update_icon()
	return

/obj/item/weapon/defibrillator/loaded //starts with normal cell
	bcell = /obj/item/weapon/cell


/obj/item/weapon/defibrillator/update_icon()
	if(bcell)  //update power
		if(bcell.charge < paddles.revivecost)
			powered = 0
		else
			powered = 1
	else
		powered = 0
	overlays.Cut()
	if(!on)
		overlays += "[initial(icon_state)]-paddles"
	if(powered)
		overlays += "[initial(icon_state)]-powered"
	if(!bcell)
		overlays += "[initial(icon_state)]-nocell"
	if(!safety)
		overlays += "[initial(icon_state)]-emagged"
	if(powered) //update charge
		if(bcell)
			var/ratio = Ceiling(bcell.percent()/25) * 25
			overlays += "[initial(icon_state)]-charge[ratio]"

/obj/item/weapon/defibrillator/ui_action_click()
	toggle_paddles()

/obj/item/weapon/defibrillator/attack_hand(mob/user)
	if(loc == user)
		if(slot_flags == SLOT_BACK)
			if(user.back == src)
				ui_action_click()
			else
				to_chat(user, "<span class='warning'>Put \the [src] on your back first!</span>")
		return
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
		paddles.unwield()
		toggle_paddles()
	else if(istype(W, /obj/item/weapon/cell))
		var/obj/item/weapon/cell/device/C = W
		if(bcell)
			to_chat(user, "<span class='notice'>\the [src] already has a cell.</span>")
		else
			if(C.maxcharge < paddles.revivecost)
				to_chat(user, "<span class='notice'>\the [src] requires a higher capacity cell.</span>")
				return
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

/obj/item/weapon/defibrillator/emp_act(severity)
	if(safety)
		safety = 0
		src.visible_message("<span class='notice'>\the [src] beeps: Safety protocols disabled!</span>")
		playsound(get_turf(src), 'sound/machines/defib_safetyoff.ogg', 50, 0)
	else
		safety = 1
		src.visible_message("<span class='notice'>\the [src] beeps: Safety protocols enabled!</span>")
		playsound(get_turf(src), 'sound/machines/defib_safetyon.ogg', 50, 0)
	update_icon()
	..()

//Paddle stuff

/obj/item/weapon/twohanded
	var/wielded = 0
	var/force_unwielded = 0
	var/force_wielded = 0
	var/wieldsound = null
	var/unwieldsound = null
	var/linked

/obj/item/weapon/twohanded/offhand
	name = "offhand"
	icon_state = "offhand"
	w_class = ITEM_SIZE_LARGE

/obj/item/weapon/twohanded/offhand/dropped(mob/user)
	..()
	user.drop_from_inventory(linked)

/obj/item/weapon/twohanded/proc/unwield(mob/living/carbon/user)
	if(!wielded || !user)
		return
	wielded = 0
	if(force_unwielded)
		force = force_unwielded
	var/sf = findtext(name," (Wielded)")
	if(sf)
		name = copytext(name,1,sf)
	else //something wrong
		name = "[initial(name)]"
	update_icon()
	if(isrobot(user))
		to_chat(user, "<span class='notice'>You free up your module.</span>")
	if(unwieldsound)
		playsound(loc, unwieldsound, 50, 1)
	var/obj/item/weapon/twohanded/offhand/O = user.get_inactive_hand()
	if(O && istype(O))
		qdel(linked)
	return

/obj/item/weapon/twohanded/proc/wield(mob/living/carbon/user)
	if(wielded)
		return
	if(!user.IsAdvancedToolUser())
		to_chat(user, "<span class='warning'>It's too heavy for you to wield fully.</span>")
		return
	if(user.get_inactive_hand())
		to_chat(user, "<span class='warning'>You need your other hand to be empty!</span>")
		return
	wielded = 1
	if(force_wielded)
		force = force_wielded
	name = "[name] (Wielded)"
	update_icon()

	if(isrobot(user))
		to_chat(user, "<span class='notice'>You dedicate your module to \the [src].</span>")
	else
		to_chat(user, "<span class='notice'>You grab \the [src] with both hands.</span>")
	if (wieldsound)
		playsound(loc, wieldsound, 50, 1)
	var/obj/item/weapon/twohanded/offhand/O = new(user) ////Let's reserve his other hand~
	O.name = "[name] - offhand"
	O.desc = "Your second grip on [src]."
	O.linked = src
	user.put_in_inactive_hand(O)
	linked = O
	return

/obj/item/weapon/twohanded/dropped(mob/user)
	..()
	//handles unwielding a twohanded weapon when dropped as well as clearing up the offhand
	if(user)
		var/obj/item/weapon/twohanded/O = user.get_inactive_hand()
		if(istype(O))
			O.unwield(user)
	return	unwield(user)

/obj/item/weapon/twohanded/update_icon()
	return

/obj/item/weapon/twohanded/equipped(mob/user, slot)
	..()
	if(!user.get_inventory_slot(src) && wielded)
		unwield(user)

/obj/item/weapon/defibrillator/verb/toggle_paddles()
	set name = "Toggle Paddles"
	set category = "Object"
	on = !on

	var/mob/living/carbon/human/user = usr
	if(on)
		//Detach the paddles into the user's hands
		if(!usr.put_in_hands(paddles))
			on = 0
			to_chat(user, "<span class='warning'>You need a free hand to hold the paddles!</span>")
			update_icon()
			return
		paddles.wield(user)
		paddles.forceMove(user)
	else
		//Remove from their hands and back onto the defib unit
		paddles.unwield()
		remove_paddles(user)
	update_icon()

/obj/item/weapon/defibrillator/proc/make_paddles()
	return new /obj/item/weapon/twohanded/shockpaddles(src)

/obj/item/weapon/defibrillator/equipped(mob/user, slot)
	..()
	if((slot_flags == SLOT_BACK && slot != slot_back) || (slot_flags == SLOT_BELT && slot != slot_belt))
		remove_paddles(user)
		update_icon()

/obj/item/weapon/defibrillator/proc/item_action_slot_check(slot, mob/user)
	if(slot == user.back)
		return 1

/obj/item/weapon/defibrillator/proc/remove_paddles(mob/user) //this fox the bug with the paddles when other player stole you the defib when you have the paddles equiped
	if(ismob(paddles.loc))
		var/mob/M = paddles.loc
		M.unEquip(paddles,1)
	return

/obj/item/weapon/defibrillator/Destroy()
	if(on)
		var/M = get(paddles, /mob)
		remove_paddles(M)
	. = ..()
	qdel_null(paddles)
	qdel_null(bcell)

/obj/item/weapon/defibrillator/proc/deductcharge(chrgdeductamt)
	if(bcell)
		if(bcell.charge < (paddles.revivecost+chrgdeductamt))
			powered = 0
			update_icon()
		if(bcell.use(chrgdeductamt*1200*CELLRATE)) //times 1200 so it works out with CELLRATE. Didn't just adjust revivecost, because if you put it over 1000, the defib doesnt work with a standard cell.
			update_icon()
			return 1
		else
			update_icon()
			return 0

/obj/item/weapon/defibrillator/proc/cooldowncheck(mob/user)
	spawn(50)
		if(bcell)
			if(bcell.charge >= paddles.revivecost)
				visible_message("<span class='notice'>\the [src] beeps: Unit ready.</span>")
				playsound(get_turf(src), 'sound/machines/defib_ready.ogg', 50, 0)
			else
				visible_message("<span class='notice'>\the [src] beeps: Charge depleted.</span>")
				playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		paddles.cooldown = 0
		paddles.update_icon()
		update_icon()

/obj/item/weapon/defibrillator/compact
	name = "compact defibrillator"
	desc = "A belt-equipped defibrillator that can be rapidly deployed."
	icon_state = "defibcompact"
	item_state = "defibcompact"
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_BELT
	origin_tech = "biotech=5"


/obj/item/weapon/defibrillator/compact/loaded/New()
	..()
	bcell = new /obj/item/weapon/cell(src)
	update_icon()
	return


/obj/item/weapon/defibrillator/compact/combat
	name = "combat defibrillator"
	desc = "A belt-equipped blood-red defibrillator that can be rapidly deployed. Does not have the restrictions or safeties of conventional defibrillators and can revive through space suits."
	combat = 1
	safety = 0

/obj/item/weapon/defibrillator/compact/combat/loaded/New()
	..()
	bcell = new /obj/item/weapon/cell(src)
	update_icon()
	return


/obj/item/weapon/defibrillator/compact/combat/loaded/attackby(obj/item/weapon/W, mob/user, params)
	if(W == paddles)
		paddles.unwield()
		toggle_paddles()
		update_icon()
		return

//paddles

/obj/item/weapon/twohanded/shockpaddles
	name = "defibrillator paddles"
	desc = "A pair of plastic-gripped paddles with flat metal surfaces that are used to deliver powerful electric shocks."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "defibpaddles"
	item_state = "defibpaddles"
	force = 0
	throwforce = 6
	w_class = ITEM_SIZE_LARGE

	var/revivecost = 500
	var/cooldown = 0
	var/busy = 0
	var/obj/item/weapon/defibrillator/defib
	var/req_defib = 1
	var/combat = 0 //If it penetrates armor and gives additional functionality
	var/grab_ghost = FALSE
	var/cooldowntime = 60 // How long in deciseconds until the defib is ready again after use.

/obj/item/weapon/twohanded/shockpaddles/proc/recharge(var/time)
	if(req_defib || !time)
		return
	cooldown = 1
	update_icon()
	sleep(time)
	audible_message("<span class='notice'>\the [src] beeps: Unit is recharged.</span>")
	playsound(src, 'sound/machines/defib_ready.ogg', 50, 0)
	cooldown = 0
	update_icon()

/obj/item/weapon/twohanded/shockpaddles/New(mainunit)
	..()
	if(check_defib_exists(mainunit, src) && req_defib)
		defib = mainunit
		loc = defib
		busy = 0
		update_icon()
	return

/obj/item/weapon/twohanded/shockpaddles/update_icon()
	icon_state = "defibpaddles[wielded]"
	item_state = "defibpaddles[wielded]"
	if(cooldown)
		icon_state = "defibpaddles[wielded]_cooldown"

/obj/item/weapon/twohanded/shockpaddles/dropped(mob/user)
	if(!req_defib)
		return ..()
	if(user)
		qdel(linked)
		to_chat(user, "<span class='notice'>The paddle snaps back into the main unit.</span>")
		defib.on = 0
		loc = defib
		defib.update_icon()
	return unwield(user)

/obj/item/weapon/twohanded/shockpaddles/proc/check_defib_exists(mainunit, mob/living/carbon/human/M, obj/O)
	if(!req_defib)
		return 1 //If it doesn't need a defib, just say it exists
	if (!mainunit || !istype(mainunit, /obj/item/weapon/defibrillator))	//To avoid weird issues from admin spawns
		M.unEquip(O)
		qdel(O)
		return 0
	else
		return 1

/obj/item/weapon/twohanded/shockpaddles/proc/hurt_people(mob/user, mob/M)
	if(req_defib && defib.safety)
		return
	if(!req_defib && !combat)
		return
	user.visible_message("<span class='warning'>[user] begins to place \the [src] on [M.name]'s chest.</span>",
		"<span class='warning'>You overcharge the paddles and begin to place them onto [M]'s chest...</span>")
	busy = 1
	update_icon()
	if(do_after(user, 30, target = M))
		visible_message("<span class='notice'>[user] places \the [src] on \the [M]'s chest.</span>",
			"<span class='warning'>You place \the [src] on [M.name]'s chest and begin to charge them.</span>")
		playsound(get_turf(src), 'sound/machines/defib_charge.ogg', 50, 0)
		if(req_defib)
			audible_message("<span class='warning'>\The [defib] lets out an urgent beep and lets out a steadily rising hum...</span>")
		else
			audible_message("<span class='warning'>\The [src] let out an urgent beep.</span>")
		if(do_after(user, 30, target = M)) //Takes longer due to overcharging
			if(!M)
				busy = 0
				update_icon()
				return
			if(M && M.stat == DEAD)
				to_chat(user, "<span class='warning'>[M] is dead.</span>")
				playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
				busy = 0
				update_icon()
				return
			visible_message("<span class='boldannounce'><i>[user] shocks [M] with \the [src]!</i></span>", "<span class='warning'>You shock [M] with \the [src]!</span>")
			playsound(get_turf(src), 'sound/machines/defib_zap.ogg', 100, 1, -1)
			playsound(loc, 'sound/weapons/Egloves.ogg', 100, 1, -1)
			var/mob/living/carbon/human/HU = M
			M.emote("scream")
			HU.apply_damage(50, BURN, BP_CHEST)
			log_attack(user, M, "overloaded the heart of", defib)
			M.Weaken(5)
			M.make_jittery(130)
			if(req_defib)
				defib.deductcharge(revivecost)
				cooldown = 1
			busy = 0
			update_icon()
			if(!req_defib)
				recharge(cooldowntime)
			if(req_defib && (defib.cooldowncheck(user)))
				return
	busy = 0
	update_icon()
	return

/obj/item/weapon/twohanded/shockpaddles/proc/shock_people(mob/user, mob/M)
	var/mob/living/carbon/human/H = M
	if(req_defib && defib.safety)
		return
	if(!req_defib && !combat)
		return
	busy = 1
	H.visible_message("<span class='danger'>[user] has touched [H.name] with \the [src]!</span>", \
			"<span class='userdanger'>[user] has touched [H.name] with \the [src]!</span>")
	H.Weaken(5)
	H.updatehealth() //forces health update before next life tick
	playsound(get_turf(src), 'sound/machines/defib_zap.ogg', 50, 1, -1)
	H.emote("gasp")
	log_attack(user, M, "stunned", src)
	if(req_defib)
		defib.deductcharge(revivecost)
		cooldown = 1
	busy = 0
	update_icon()
	if(req_defib)
		defib.cooldowncheck(user)
	else
		recharge(cooldowntime)
	return

/obj/item/weapon/twohanded/shockpaddles/proc/make_alive(mob/living/carbon/human/M) //This revives the mob
	M.switch_from_dead_to_living_mob_list()
	M.tod = null
	M.timeofdeath = 0
	M.stat = CONSCIOUS
	M.regenerate_icons()
	M.failed_last_breath = 0 //So mobs that died of oxyloss don't revive and have perpetual out of breath.
	M.reload_fullscreen()

/obj/item/weapon/twohanded/shockpaddles/proc/can_defib(mob/M, var/tplus, var/tlimit) //Checks various conditions to see if the mob is revivable
	var/mob/living/carbon/human/H = M //Makes M a human, so it has access to human procs.
	var/GhostOfM = 0								//Checks if the player is currently a ghost
	for(var/mob/observer/ghost/G in player_list)
		if(G.mind == M)
			GhostOfM = 1
			break
	var/total_brute	= H.getBruteLoss()
	var/total_burn	= H.getFireLoss()
	var/failed = null
	if (tplus > tlimit)
		failed = "<span class='warning'>[req_defib ? "[defib]" : "\the [src]"] buzzes: Resuscitation failed - Body has decayed for too long. Further attempts futile.</span>"
		return failed
	else if (!H.internal_organs_by_name[BP_HEART])
		failed = "<span class='warning'>[req_defib ? "[defib]" : "\the [src]"] buzzes: Resuscitation failed - Patient's heart is missing.</span>"
		return failed
	else if(total_burn >= 180 || total_brute >= 180 || HUSK in H.mutations)
		failed = "<span class='warning'>[req_defib ? "[defib]" : "\the [src]"] buzzes: Resuscitation failed - Severe tissue damage makes recovery of patient impossible via defibrillator. Further attempts futile.</span>"
		return failed
	else if(GhostOfM)
		failed = "<span class='warning'>[req_defib ? "[defib]" : "\the [src]"] buzzes: Resuscitation failed - No activity in patient's brain. Further attempts may be successful.</span>"
		return failed
	else
		var/obj/item/organ/internal/brain/BR = H.internal_organs_by_name[BP_BRAIN]
		if(!BR || !BR.health)
			failed = "<span class='warning'>[req_defib ? "[defib]" : "\the [src]"] buzzes: Resuscitation failed - Patient's brain is missing or damaged beyond point of no return. Further attempts futile.</span>"
	return failed

/obj/item/weapon/twohanded/shockpaddles/proc/can_use(mob/user, mob/M)
	if(busy)
		return 0
	if(req_defib && !defib.powered)
		visible_message("<span class='notice'>[defib] beeps: Unit is unpowered.</span>")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		return 0
	if(!wielded)
		if(isrobot(user))
			to_chat(user, "<span class='warning'>You must activate the paddles in your active module before you can use them on someone!</span>")
		else
			to_chat(user, "<span class='warning'>You need to wield the paddles in both hands before you can use them on someone!</span>")
		return 0
	if(cooldown)
		if(req_defib)
			to_chat(user, "<span class='warning'>\the [defib] is recharging!</span>")
		else
			to_chat(user, "<span class='warning'>\the [src] are recharging!</span>")
		return 0
	if(!ishuman(M))
		if(req_defib)
			to_chat(user, "<span class='warning'>The instructions on \the [defib] don't mention how to revive that...</span>")
		else
			to_chat(user, "<span class='warning'>You aren't sure how to revive that...</span>")
		return 0
	return 1

/obj/item/weapon/twohanded/shockpaddles/attack(mob/M, mob/user)
	if(!can_use(user, M))
		return
	var/mob/living/carbon/human/H = M
	if(user.a_intent == I_DISARM) //Shock them
		shock_people(user, M)
	if(user.zone_sel.selecting != BP_CHEST) //checked after the shock proc, so you can shock anywhere
		to_chat(user, "<span class='warning'>You need to target your patient's \
			chest with [src]!</span>")
		return
	if(user.a_intent == I_HURT)  //Hurt people with the defib
		hurt_people(user, M)
	to_chat(find_dead_player(H.ckey, 1), "Your heart is being defibrillated. Re-enter your corpse if you want to be revived!")

	user.visible_message("<span class='warning'>[user] begins to place \the [src] on [M.name]'s chest.</span>", "<span class='warning'>You begin to place [src] on [M.name]'s chest...</span>")
	busy = 1
	update_icon()
	if(do_after(user, 30, target = M)) //beginning to place the paddles on patient's chest to allow some time for people to move away to stop the process
		user.visible_message("<span class='notice'>[user] places \the [src] on [M.name]'s chest.</span>", "<span class='warning'>You place [src] on [M.name]'s chest.</span>")
		playsound(get_turf(src), 'sound/machines/defib_charge.ogg', 50, 0)
		var/tplus = world.time - H.timeofdeath
		// past this much time the patient is unrecoverable
		// (in deciseconds)
		var/tlimit = DEFIB_TIME_LIMIT * 10
		// brain damage starts setting in on the patient after
		// some time left rotting
		var/tloss = DEFIB_TIME_LOSS * 10
		if(do_after(user, 20, target = M)) //placed on chest and short delay to shock for dramatic effect, revive time is 5sec total
			for(var/obj/item/clothing/cloth in list(H.wear_suit, H.w_uniform))
				if((cloth.body_parts_covered & UPPER_TORSO) && (cloth.item_flags & THICKMATERIAL))
					if((!src.combat && !req_defib) || (req_defib && !defib.combat))
						audible_message("<span class='warning'>[req_defib ? "[defib]" : "\the [src]"] buzzes: Patient's chest is obscured. Operation aborted.</span>")
						playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
						busy = 0
						update_icon()
						return
			if(H.stat == DEAD)
				M.visible_message("<span class='warning'>[M]'s body convulses a bit.</span>")
				playsound(get_turf(src), "bodyfall", 50, 1)
				playsound(get_turf(src), 'sound/machines/defib_zap.ogg', 50, 1, -1)
				var/failed = null
				failed = can_defib(H, tplus, tlimit)
				if(failed)
					visible_message(failed)
					playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
				else
					var/halfwaycritdeath = (config.health_threshold_crit - config.health_threshold_dead) / 2
					//If the body has been fixed so that they would not be in crit when defibbed, give them oxyloss to put them back into crit
					if (H.health > halfwaycritdeath)
						H.adjustOxyLoss(H.health - halfwaycritdeath, 0)
					else
						var/overall_damage = H.getBruteLoss() + H.getFireLoss() + H.getToxLoss() + H.getOxyLoss()
						H.adjustOxyLoss((H.health - halfwaycritdeath) * (H.getOxyLoss() / overall_damage), 0)
					visible_message("<span class='notice'>[req_defib ? "[defib]" : "\the [src]"] pings: Resuscitation successful.</span>")
					playsound(get_turf(src), 'sound/machines/defib_success.ogg', 50, 0)
					make_alive(H)
					H.emote("gasp")
					if(tplus > tloss)
						H.setBrainLoss( max(0, min(99, (100 -((tlimit - tplus) / (tlimit-1200) * 100)))))
					H.apply_damage(20, BURN, BP_CHEST)
					H.Weaken(rand(10,25))
					log_game(user, M, "revived", defib)
				if(req_defib)
					defib.deductcharge(revivecost)
					cooldown = 1
				update_icon()
				if(req_defib)
					defib.cooldowncheck(user)
				else
					recharge(cooldowntime)
			else if (!H.internal_organs_by_name[BP_HEART])
				visible_message("<span class='warning'>[req_defib ? "[defib]" : "\the [src]"] buzzes: Patient's heart is missing. Operation aborted.</span>")
				playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)

			else
				visible_message("<span class='warning'>[req_defib ? "[defib]" : "\the [src]"] buzzes: Patient is not in a valid state. Operation aborted.</span>")
				playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
	busy = 0
	update_icon()

/obj/item/weapon/twohanded/shockpaddles/traitor
	name = "defibrillator paddles"
	desc = "A pair of unusual looking paddles used to revive deceased crewmembers. It possesses both the ability to penetrate armor and to deliver powerful shocks offensively."
	combat = 1
	icon = 'icons/obj/weapons.dmi'
	icon_state = "defibpaddles0"
	item_state = "defibpaddles0"
	req_defib = 0

#undef DEFIB_TIME_LIMIT
#undef DEFIB_TIME_LOSS
