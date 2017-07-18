#define SECBOT_WAIT_TIME	5		//number of in-game seconds to wait for someone to surrender
#define SECBOT_THREAT_ARREST 4		//threat level at which we decide to arrest someone
#define SECBOT_THREAT_ATTACK 8		//threat level at which was assume immediate danger and attack right away

/mob/living/bot/secbot
	name = "Securitron"
	desc = "A little security robot.  He looks less than thrilled."
	icon_state = "secbot0"
	var/attack_state = "secbot-c"
	maxHealth = 50
	health = 50
	req_one_access = list(access_security, access_forensics_lockers)
	botcard_access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels)

	patrol_speed = 2
	target_speed = 3
	light_strength = 0 //stunbaton makes it's own light

	RequiresAccessToToggle = 1 // Haha no

	var/idcheck = 0 // If true, arrests for having weapons without authorization.
	var/check_records = 0 // If true, arrests people without a record.
	var/check_arrest = 1 // If true, arrests people who are set to arrest.
	var/declare_arrests = 0 // If true, announces arrests over sechuds.

	var/is_ranged = 0
	var/awaiting_surrender = 0

	var/obj/item/weapon/melee/baton/stun_baton
	var/obj/item/weapon/handcuffs/cyborg/handcuffs

	var/list/threat_found_sounds = list('sound/voice/bcriminal.ogg', 'sound/voice/bjustice.ogg', 'sound/voice/bfreeze.ogg')
	var/list/preparing_arrest_sounds = list('sound/voice/bfreeze.ogg')

/mob/living/bot/secbot/beepsky
	name = "Officer Beepsky"
	desc = "It's Officer Beep O'sky! Powered by a potato and a shot of whiskey."
	will_patrol = 1

/mob/living/bot/secbot/New()
	..()
	stun_baton = new(src)
	stun_baton.bcell = new /obj/item/weapon/cell/infinite(stun_baton)
	stun_baton.set_status(1, null)

	handcuffs = new(src)

/mob/living/bot/secbot/Destroy()
	qdel(stun_baton)
	qdel(handcuffs)
	stun_baton = null
	handcuffs = null
	return ..()

/mob/living/bot/secbot/turn_on()
	..()
	stun_baton.set_status(on, null)

/mob/living/bot/secbot/turn_off()
	..()
	stun_baton.set_status(on, null)

/mob/living/bot/secbot/update_icons()
	icon_state = "secbot[on]"

/mob/living/bot/secbot/GetInteractTitle()
	. = "<head><title>Securitron controls</title></head>"
	. += "<b>Automatic Security Unit</b>"

/mob/living/bot/secbot/GetInteractPanel()
	. = "Check for weapon authorization: <a href='?src=\ref[src];command=idcheck'>[idcheck ? "Yes" : "No"]</a>"
	. += "<br>Check security records: <a href='?src=\ref[src];command=ignorerec'>[check_records ? "Yes" : "No"]</a>"
	. += "<br>Check arrest status: <a href='?src=\ref[src];command=ignorearr'>[check_arrest ? "Yes" : "No"]</a>"
	. += "<br>Report arrests: <a href='?src=\ref[src];command=declarearrests'>[declare_arrests ? "Yes" : "No"]</a>"
	. += "<br>Auto patrol: <a href='?src=\ref[src];command=patrol'>[will_patrol ? "On" : "Off"]</a>"

/mob/living/bot/secbot/GetInteractMaintenance()
	. = "Threat identifier status: "
	switch(emagged)
		if(0)
			. += "<a href='?src=\ref[src];command=emag'>Normal</a>"
		if(1)
			. += "<a href='?src=\ref[src];command=emag'>Scrambled (DANGER)</a>"
		if(2)
			. += "ERROROROROROR-----"

/mob/living/bot/secbot/ProcessCommand(var/mob/user, var/command, var/href_list)
	..()
	if(CanAccessPanel(user))
		switch(command)
			if("idcheck")
				idcheck = !idcheck
			if("ignorerec")
				check_records = !check_records
			if("ignorearr")
				check_arrest = !check_arrest
			if("patrol")
				will_patrol = !will_patrol
			if("declarearrests")
				declare_arrests = !declare_arrests

	if(CanAccessMaintenance(user))
		switch(command)
			if("emag")
				if(emagged < 2)
					emagged = !emagged

/mob/living/bot/secbot/attackby(var/obj/item/O, var/mob/user)
	var/curhealth = health
	. = ..()
	if(health < curhealth)
		react_to_attack(user)

/mob/living/bot/secbot/emag_act(var/remaining_charges, var/mob/user)
	. = ..()
	if(!emagged)
		if(user)
			to_chat(user, "<span class='notice'>You short out [src]'s threat identificator.</span>")
			ignore_list |= user
		emagged = 2
		return 1

/mob/living/bot/secbot/bullet_act(var/obj/item/projectile/P)
	var/curhealth = health
	var/mob/shooter = P.firer
	. = ..()
	//if we already have a target just ignore to avoid lots of checking
	if(!target && health < curhealth && shooter && (shooter in view(world.view, src)))
		react_to_attack(shooter)

/mob/living/bot/secbot/proc/begin_arrest(mob/target, var/threat)
	var/suspect_name = target_name(target)
	if(declare_arrests)
		broadcast_security_hud_message("[src] is arresting a level [threat] suspect <b>[suspect_name]</b> in <b>[get_area(src)]</b>.", src)
	say("Down on the floor, [suspect_name]! You have [SECBOT_WAIT_TIME] seconds to comply.")
	playsound(src.loc, pick(preparing_arrest_sounds), 50)
	moved_event.register(target, src, /mob/living/bot/secbot/proc/target_moved)

/mob/living/bot/secbot/proc/target_moved(atom/movable/moving_instance, atom/old_loc, atom/new_loc)
	if(get_dist(get_turf(src), get_turf(target)) >= 1)
		awaiting_surrender = INFINITY
		moved_event.unregister(moving_instance, src)

/mob/living/bot/secbot/proc/react_to_attack(mob/attacker)
	if(!target)
		playsound(src.loc, pick(threat_found_sounds), 50)
		broadcast_security_hud_message("[src] was attacked by a hostile <b>[target_name(attacker)]</b> in <b>[get_area(src)]</b>.", src)
	target = attacker
	awaiting_surrender = INFINITY

/mob/living/bot/secbot/resetTarget()
	..()
	moved_event.unregister(target, src)
	awaiting_surrender = -1
	walk_to(src, 0)

/mob/living/bot/secbot/startPatrol()
	if(!locked) // Stop running away when we set you up
		return
	..()

/mob/living/bot/secbot/confirmTarget(var/atom/A)
	if(!..())
		return 0
	return (check_threat(A) >= SECBOT_THREAT_ARREST)

/mob/living/bot/secbot/lookForTargets()
	for(var/mob/living/M in view(src))
		if(M.stat == DEAD)
			continue
		if(confirmTarget(M))
			var/threat = check_threat(M)
			target = M
			awaiting_surrender = -1
			say("Level [threat] infraction alert!")
			custom_emote(1, "points at [M.name]!")
			return

/mob/living/bot/secbot/handleAdjacentTarget()
	var/mob/living/carbon/human/H = target
	var/threat = check_threat(target)
	if(awaiting_surrender < SECBOT_WAIT_TIME && istype(H) && !H.lying && threat < SECBOT_THREAT_ATTACK)
		if(awaiting_surrender == -1)
			begin_arrest(target, threat)
		++awaiting_surrender
	else
		UnarmedAttack(target)

/mob/living/bot/secbot/proc/cuff_target(var/mob/living/carbon/C)
	if(istype(C) && !C.handcuffed)
		handcuffs.place_handcuffs(C, src)
	resetTarget() //we're done, failed or not. Don't want to get stuck if C is not

/mob/living/bot/secbot/UnarmedAttack(var/mob/M, var/proximity)
	if(!..())
		return

	if(!istype(M))
		return

	var/mob/living/carbon/human/H = M
	if(istype(H) && H.lying)
		cuff_target(H)
		return

	if(istype(M, /mob/living/simple_animal))
		a_intent = I_HURT
	else
		a_intent = I_GRAB

	stun_baton.attack(M, src, BP_CHEST) //robots and turrets aim for center of mass
	flick(attack_state, src)

/mob/living/bot/secbot/explode()
	visible_message("<span class='warning'>[src] blows apart!</span>")
	var/turf/Tsec = get_turf(src)

	var/obj/item/weapon/secbot_assembly/Sa = new /obj/item/weapon/secbot_assembly(Tsec)
	Sa.build_step = 1
	Sa.overlays += image('icons/obj/aibots.dmi', "hs_hole")
	Sa.created_name = name
	new /obj/item/device/assembly/prox_sensor(Tsec)
	new /obj/item/weapon/melee/baton(Tsec)
	if(prob(50))
		new /obj/item/robot_parts/l_arm(Tsec)

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()

	new /obj/effect/decal/cleanable/blood/oil(Tsec)
	qdel(src)

/mob/living/bot/secbot/proc/target_name(mob/living/T)
	if(ishuman(T))
		var/mob/living/carbon/human/H = T
		return H.get_id_name("unidentified person")
	return "unidentified lifeform"

/mob/living/bot/secbot/proc/check_threat(var/mob/living/M)
	if(!M || !istype(M) || M.stat == DEAD || src == M)
		return 0

	if(emagged && !M.incapacitated()) //check incapacitated so emagged secbots don't keep attacking the same target forever
		return 10

	return M.assess_perp(access_scanner, 0, idcheck, check_records, check_arrest)

//Secbot Construction

/obj/item/clothing/head/helmet/attackby(var/obj/item/device/assembly/signaler/S, mob/user as mob)
	..()
	if(!issignaler(S))
		..()
		return

	if(type != /obj/item/clothing/head/helmet) //Eh, but we don't want people making secbots out of space helmets.
		return

	if(S.secured)
		qdel(S)
		var/obj/item/weapon/secbot_assembly/A = new /obj/item/weapon/secbot_assembly
		user.put_in_hands(A)
		to_chat(user, "You add the signaler to the helmet.")
		user.drop_from_inventory(src)
		qdel(src)
	else
		return

/obj/item/weapon/secbot_assembly
	name = "helmet/signaler assembly"
	desc = "Some sort of bizarre assembly."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "helmet_signaler"
	item_state = "helmet"
	var/build_step = 0
	var/created_name = "Securitron"

/obj/item/weapon/secbot_assembly/attackby(var/obj/item/O, var/mob/user)
	..()
	if(istype(O, /obj/item/weapon/weldingtool) && !build_step)
		var/obj/item/weapon/weldingtool/WT = O
		if(WT.remove_fuel(0, user))
			build_step = 1
			overlays += image('icons/obj/aibots.dmi', "hs_hole")
			to_chat(user, "You weld a hole in \the [src].")

	else if(isprox(O) && (build_step == 1))
		user.drop_item()
		build_step = 2
		to_chat(user, "You add \the [O] to [src].")
		overlays += image('icons/obj/aibots.dmi', "hs_eye")
		name = "helmet/signaler/prox sensor assembly"
		qdel(O)

	else if((istype(O, /obj/item/robot_parts/l_arm) || istype(O, /obj/item/robot_parts/r_arm)) && build_step == 2)
		user.drop_item()
		build_step = 3
		to_chat(user, "You add \the [O] to [src].")
		name = "helmet/signaler/prox sensor/robot arm assembly"
		overlays += image('icons/obj/aibots.dmi', "hs_arm")
		qdel(O)

	else if(istype(O, /obj/item/weapon/melee/baton) && build_step == 3)
		user.drop_item()
		to_chat(user, "You complete the Securitron! Beep boop.")
		var/mob/living/bot/secbot/S = new /mob/living/bot/secbot(get_turf(src))
		S.name = created_name
		qdel(O)
		qdel(src)

	else if(istype(O, /obj/item/weapon/pen))
		var/t = sanitizeSafe(input(user, "Enter new robot name", name, created_name), MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, usr) && loc != usr)
			return
		created_name = t
