/mob/living/bot/secbot
	name = "Securitron"
	desc = "A little security robot.  He looks less than thrilled."
	icon_state = "secbot0"
	var/attack_state = "secbot-c"
	maxHealth = 50
	health = 50
	req_one_access = list(access_security, access_forensics_lockers)
	botcard_access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels)

	var/mob/target

	var/idcheck = 0 // If true, arrests for having weapons without authorization.
	var/check_records = 0 // If true, arrests people without a record.
	var/check_arrest = 1 // If true, arrests people who are set to arrest.
	var/declare_arrests = 0 // If true, announces arrests over sechuds.
	var/auto_patrol = 0 // If true, patrols on its own

	var/mode = 0
#define SECBOT_IDLE 		0		// idle
#define SECBOT_HUNT 		1		// found target, hunting
#define SECBOT_ARREST		2		// arresting target
#define SECBOT_START_PATROL	4		// start patrol
#define SECBOT_WAIT_PATROL	5		// waiting for signals
#define SECBOT_PATROL		6		// patrolling
#define SECBOT_SUMMON		7		// summoned by PDA
	var/is_ranged = 0
	var/awaiting_surrender = 0
#define SECBOT_WAIT_TIME	5		//number of in-game seconds to wait for someone to surrender
#define SECBOT_THREAT_ARREST 4		//threat level at which we decide to arrest someone
#define SECBOT_THREAT_ATTACK 8		//threat level at which was assume immediate danger and attack right away

	var/obj/secbot_listener/listener = null
	var/beacon_freq = 1445			// Navigation beacon frequency
	var/control_freq = BOT_FREQ		// Bot control frequency
	var/list/path = list()
	var/frustration = 0
	var/turf/patrol_target = null	// This is where we are headed
	var/closest_dist				// Used to find the closest beakon
	var/destination = "__nearest__"	// This is the current beacon's ID
	var/next_destination = "__nearest__"	// This is the next beacon's ID
	var/nearest_beacon				// Tag of the beakon that we assume to be the closest one

	var/obj/item/weapon/melee/baton/stun_baton
	var/obj/item/weapon/handcuffs/cyborg/handcuffs

	var/bot_version = 1.4
	var/list/threat_found_sounds = list('sound/voice/bcriminal.ogg', 'sound/voice/bjustice.ogg', 'sound/voice/bfreeze.ogg')
	var/list/preparing_arrest_sounds = list('sound/voice/bfreeze.ogg')
	light_strength = 0 //stunbaton makes it's own light

/mob/living/bot/secbot/beepsky
	name = "Officer Beepsky"
	desc = "It's Officer Beep O'sky! Powered by a potato and a shot of whiskey."
	auto_patrol = 1

/mob/living/bot/secbot/New()
	..()
	listener = new /obj/secbot_listener(src)
	listener.secbot = src

	stun_baton = new(src)
	stun_baton.bcell = new /obj/item/weapon/cell/infinite(stun_baton)
	stun_baton.set_status(1, null)

	handcuffs = new(src)

/mob/living/bot/secbot/Destroy()
	qdel(listener)
	qdel(stun_baton)
	qdel(handcuffs)
	listener = null
	stun_baton = null
	handcuffs = null
	return ..()

/mob/living/bot/secbot/initialize()
	..()
	if(radio_controller)
		radio_controller.add_object(listener, control_freq, filter = RADIO_SECBOT)
		radio_controller.add_object(listener, beacon_freq, filter = RADIO_NAVBEACONS)

/mob/living/bot/secbot/turn_on()
	..()
	stun_baton.set_status(on, null)

/mob/living/bot/secbot/turn_off()
	..()
	reset_arrest()
	stun_baton.set_status(on, null)

/mob/living/bot/secbot/update_icons()
	icon_state = "secbot[on]"

/mob/living/bot/secbot/attack_hand(var/mob/user)
	user.set_machine(src)
	var/list/dat = list()
	dat += "<TT><B>Automatic Security Unit v[bot_version]</B></TT><BR><BR>"
	dat += "Status: <A href='?src=\ref[src];power=1'>[on ? "On" : "Off"]</A><BR>"
	dat += "Behaviour controls are [locked ? "locked" : "unlocked"]<BR>"
	dat += "Maintenance panel is [open ? "opened" : "closed"]"
	if(!locked || issilicon(user))
		dat += "<BR>Check for Weapon Authorization: <A href='?src=\ref[src];operation=idcheck'>[idcheck ? "Yes" : "No"]</A><BR>"
		dat += "Check Security Records: <A href='?src=\ref[src];operation=ignorerec'>[check_records ? "Yes" : "No"]</A><BR>"
		dat += "Check Arrest Status: <A href='?src=\ref[src];operation=ignorearr'>[check_arrest ? "Yes" : "No"]</A><BR>"
		dat += "Report Arrests: <A href='?src=\ref[src];operation=declarearrests'>[declare_arrests ? "Yes" : "No"]</A><BR>"
		dat += "Auto Patrol: <A href='?src=\ref[src];operation=patrol'>[auto_patrol ? "On" : "Off"]</A>"
	var/datum/browser/popup = new(user, "autosec", "Securitron v[bot_version] controls")
	popup.set_content(jointext(dat,null))
	popup.open()

/mob/living/bot/secbot/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)
	add_fingerprint(usr)

	if((href_list["power"]) && (access_scanner.allowed(usr)))
		if(on)
			turn_off()
		else
			turn_on()
		return

	switch(href_list["operation"])
		if("idcheck")
			idcheck = !idcheck
		if("ignorerec")
			check_records = !check_records
		if("ignorearr")
			check_arrest = !check_arrest
		if("patrol")
			auto_patrol = !auto_patrol
			mode = SECBOT_IDLE
		if("declarearrests")
			declare_arrests = !declare_arrests
	attack_hand(usr)

/mob/living/bot/secbot/attackby(var/obj/item/O, var/mob/user)
	var/curhealth = health
	. = ..()
	if(health < curhealth)
		react_to_attack(user)

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
	if(get_dist(get_turf(src), get_turf(target)) >= 3)
		mode = SECBOT_ARREST // I'm done playing nice
		awaiting_surrender = INFINITY
		moved_event.unregister(moving_instance, src)

/mob/living/bot/secbot/proc/react_to_attack(mob/attacker)
	if(!target)
		playsound(src.loc, pick(threat_found_sounds), 50)
		broadcast_security_hud_message("[src] was attacked by a hostile <b>[target_name(attacker)]</b> in <b>[get_area(src)]</b>.", src)
	target = attacker
	mode = SECBOT_ARREST

/mob/living/bot/secbot/proc/reset_arrest()
	moved_event.unregister(target, src)
	target = null
	awaiting_surrender = 0
	frustration = 0
	mode = SECBOT_IDLE
	walk_to(src, 0)

/mob/living/bot/secbot/Life()
	..()
	if(!on)
		return
	if(client)
		return

	if(!target)
		scan_view()

	if(!locked && (mode == SECBOT_START_PATROL || mode == SECBOT_PATROL)) // Stop running away when we set you up
		mode = SECBOT_IDLE

	var/can_see_target
	if(target)
		can_see_target = (target in view(world.view, src))
		if(!can_see_target)
			frustration++
			walk_to(src, 0) //don't know where they are
		else
			walk_to(src, target, 1, 4)

	switch(mode)
		if(SECBOT_IDLE)
			if(auto_patrol && locked)
				mode = SECBOT_START_PATROL
			return

		if(SECBOT_HUNT) // Target is in the view or has been recently - chase it
			var/threat = check_threat(target) // Re-evaluate in case arrest status cleared or something
			if(!target || threat < SECBOT_THREAT_ARREST || frustration > 7)
				reset_arrest()
			else if(can_see_target && Adjacent(target))
				if(!awaiting_surrender)
					begin_arrest(target, threat)
				if(!(threat >= SECBOT_THREAT_ATTACK || awaiting_surrender >= SECBOT_WAIT_TIME) && ishuman(target) && !target.lying)
					++awaiting_surrender
				else
					mode = SECBOT_ARREST
			return

		if(SECBOT_ARREST) // attack
			if(!target)
				reset_arrest()
			else if(can_see_target)
				if(target.lying)
					if(Adjacent(target))
						cuff_target(target)
				else
					if(Adjacent(target))
						UnarmedAttack(target)
					else if(is_ranged)
						RangedAttack(target)
			return

		if(SECBOT_START_PATROL)
			if(path.len && patrol_target)
				mode = SECBOT_PATROL
				return
			else if(patrol_target)
				spawn(0)
					calc_path()
					if(!path.len)
						patrol_target = null
						mode = SECBOT_IDLE
					else
						mode = SECBOT_PATROL
			if(!patrol_target)
				if(next_destination)
					find_next_target()
				else
					find_patrol_target()
					say("Engaging patrol mode.")
				mode = SECBOT_WAIT_PATROL
			return

		if(SECBOT_WAIT_PATROL)
			if(patrol_target)
				mode = SECBOT_START_PATROL
			else
				++frustration
				if(frustration > 120)
					frustration = 0
					mode = SECBOT_IDLE

		if(SECBOT_PATROL)
			patrol_step()
			spawn(10)
				patrol_step()
			return

		if(SECBOT_SUMMON)
			patrol_step()
			spawn(4)
				patrol_step()
			spawn(8)
				patrol_step()
			return

/mob/living/bot/secbot/proc/cuff_target(var/mob/living/carbon/C)
	if(istype(C) && !C.handcuffed)
		handcuffs.place_handcuffs(C, src)
	reset_arrest() //we're done, failed or not. Don't want to get stuck if C is not

/mob/living/bot/secbot/UnarmedAttack(var/mob/M, var/proximity)
	if(!..())
		return

	if(!istype(M))
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

/mob/living/bot/secbot/proc/scan_view()
	for(var/mob/living/M in view(7, src))
		if(M.invisibility >= INVISIBILITY_LEVEL_ONE)
			continue
		if(M.stat)
			continue

		var/threat = check_threat(M) //does this on every living mob in view every tick we aren't targeting anyone :(

		//no prioritization, just goes for the first threat found :(
		if(threat >= 4)
			if(declare_arrests && target != M)
				broadcast_security_hud_message("[src] detected a level [threat] suspect <b>[target_name(target)]</b> in <b>[get_area(src)]</b>.", src)
			target = M
			say("Level [threat] infraction alert!")
			custom_emote(1, "points at [M.name]!")

			playsound(src.loc, pick(threat_found_sounds), 50)

			mode = SECBOT_HUNT
			break
	return

/mob/living/bot/secbot/proc/calc_path(var/turf/avoid = null)
	path = AStar(loc, patrol_target, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 120, id=botcard, exclude=avoid)
	if(!path)
		path = list()

/mob/living/bot/secbot/proc/check_threat(var/mob/living/M)
	if(!M || !istype(M) || M.stat || src == M)
		return 0

	if(emagged && !M.incapacitated()) //check incapacitated so emagged secbots don't keep attacking the same target forever
		return 10

	return M.assess_perp(access_scanner, 0, idcheck, check_records, check_arrest)

/mob/living/bot/secbot/proc/patrol_step()
	if(loc == patrol_target)
		patrol_target = null
		path = list()
		mode = SECBOT_IDLE
		return

	if(path.len && patrol_target)
		var/turf/next = path[1]
		if(loc == next)
			path -= next
			return
		var/moved = step_towards(src, next)
		if(moved)
			path -= next
			frustration = 0
		else
			++frustration
			if(frustration > 5) // Make a new path
				mode = SECBOT_START_PATROL
		return
	else
		mode = SECBOT_START_PATROL

/mob/living/bot/secbot/proc/find_patrol_target()
	send_status()
	nearest_beacon = null
	next_destination = "__nearest__"
	listener.post_signal(beacon_freq, "findbeacon", "patrol")

/mob/living/bot/secbot/proc/find_next_target()
	send_status()
	nearest_beacon = null
	listener.post_signal(beacon_freq, "findbeacon", "patrol")

/mob/living/bot/secbot/proc/send_status()
	var/list/kv = list(
	"type" = "secbot",
	"name" = name,
	"loca" = get_area(loc),
	"mode" = mode
	)
	listener.post_signal_multiple(control_freq, kv)

/obj/secbot_listener
	var/mob/living/bot/secbot/secbot = null

/obj/secbot_listener/proc/post_signal(var/freq, var/key, var/value) // send a radio signal with a single data key/value pair
	post_signal_multiple(freq, list("[key]" = value))

/obj/secbot_listener/proc/post_signal_multiple(var/freq, var/list/keyval) // send a radio signal with multiple data key/values
	var/datum/radio_frequency/frequency = radio_controller.return_frequency(freq)
	if(!frequency)
		return

	var/datum/signal/signal = new()
	signal.source = secbot
	signal.transmission_method = 1
	signal.data = keyval.Copy()

	if(signal.data["findbeacon"])
		frequency.post_signal(secbot, signal, filter = RADIO_NAVBEACONS)
	else if(signal.data["type"] == "secbot")
		frequency.post_signal(secbot, signal, filter = RADIO_SECBOT)
	else
		frequency.post_signal(secbot, signal)

/obj/secbot_listener/receive_signal(datum/signal/signal)
	if(!secbot || !secbot.on)
		return

	var/recv = signal.data["command"]
	if(recv == "bot_status")
		secbot.send_status()
		return

	if(signal.data["active"] == secbot)
		switch(recv)
			if("stop")
				secbot.mode = SECBOT_IDLE
				secbot.auto_patrol = 0
				return

			if("go")
				secbot.mode = SECBOT_IDLE
				secbot.auto_patrol = 1
				return

			if("summon")
				secbot.patrol_target = signal.data["target"]
				secbot.next_destination = secbot.destination
				secbot.destination = null
				//secbot.awaiting_beacon = 0
				secbot.mode = SECBOT_SUMMON
				secbot.calc_path()
				secbot.say("Responding.")
				return

	recv = signal.data["beacon"]
	var/valid = signal.data["patrol"]
	if(!recv || !valid)
		return

	if(recv == secbot.next_destination) // This beacon is our target
		secbot.destination = secbot.next_destination
		secbot.patrol_target = signal.source.loc
		secbot.next_destination = signal.data["next_patrol"]
	else if(secbot.next_destination == "__nearest__")
		var/dist = get_dist(secbot, signal.source.loc)
		if(dist <= 1)
			return

		if(secbot.nearest_beacon)
			if(dist < secbot.closest_dist)
				secbot.nearest_beacon = recv
				secbot.patrol_target = secbot.nearest_beacon
				secbot.next_destination = signal.data["next_patrol"]
				secbot.closest_dist = dist
				return
		else
			secbot.nearest_beacon = recv
			secbot.patrol_target = secbot.nearest_beacon
			secbot.next_destination = signal.data["next_patrol"]
			secbot.closest_dist = dist

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
