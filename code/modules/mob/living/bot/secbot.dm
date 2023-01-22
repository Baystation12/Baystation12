#define SECBOT_WAIT_TIME	5		//number of in-game seconds to wait for someone to surrender
#define SECBOT_THREAT_ARREST 4		//threat level at which we decide to arrest someone
#define SECBOT_THREAT_ATTACK 8		//threat level at which was assume immediate danger and attack right away

/mob/living/bot/secbot
	name = "Securitron"
	desc = "A little security robot.  He looks less than thrilled."
	icon = 'icons/mob/bot/secbot.dmi'
	icon_state = "secbot0"
	var/attack_state = "secbot-c"
	layer = MOB_LAYER
	maxHealth = 50
	health = 50
	req_access = list(list(access_security, access_forensics_lockers))
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

	var/obj/item/melee/baton/stun_baton
	var/obj/item/handcuffs/cyborg/handcuffs

	var/list/threat_found_sounds = list('sound/voice/bcriminal.ogg', 'sound/voice/bjustice.ogg', 'sound/voice/bfreeze.ogg')
	var/list/preparing_arrest_sounds = list('sound/voice/bfreeze.ogg')

/mob/living/bot/secbot/beepsky
	name = "Officer Beepsky"
	desc = "It's Officer Beep O'sky! Powered by a potato and a shot of whiskey."
	will_patrol = 1

/mob/living/bot/secbot/Initialize()
	stun_baton = new(src)
	stun_baton.bcell = new /obj/item/cell/infinite(stun_baton)
	stun_baton.set_status(1, null)
	. = ..()

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
		emagged = TRUE
		return 1

/mob/living/bot/secbot/bullet_act(var/obj/item/projectile/P)
	if (status_flags & GODMODE)
		return PROJECTILE_FORCE_MISS
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
	if (preparing_arrest_sounds.len)
		playsound(src.loc, pick(preparing_arrest_sounds), 50)
	GLOB.moved_event.register(target, src, /mob/living/bot/secbot/proc/target_moved)

/mob/living/bot/secbot/proc/target_moved(atom/movable/moving_instance, atom/old_loc, atom/new_loc)
	if(get_dist(get_turf(src), get_turf(target)) >= 1)
		awaiting_surrender = INFINITY
		GLOB.moved_event.unregister(moving_instance, src)

/mob/living/bot/secbot/proc/react_to_attack(mob/attacker)
	if(!target)
		playsound(src.loc, pick(threat_found_sounds), 50)
		broadcast_security_hud_message("[src] was attacked by a hostile <b>[target_name(attacker)]</b> in <b>[get_area(src)]</b>.", src)
	target = attacker
	awaiting_surrender = INFINITY

/mob/living/bot/secbot/resetTarget()
	..()
	GLOB.moved_event.unregister(target, src)
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
	new /obj/item/device/assembly/prox_sensor(Tsec)
	new /obj/item/melee/baton(Tsec)
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
