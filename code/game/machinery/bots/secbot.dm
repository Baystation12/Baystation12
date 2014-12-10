/obj/machinery/bot/secbot
	name = "Securitron"
	desc = "A little security robot.  He looks less than thrilled."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "secbot0"
	layer = 5.0
	density = 0
	anchored = 0
	health = 25
	maxhealth = 25
	fire_dam_coeff = 0.7
	brute_dam_coeff = 0.5
	req_one_access = list(access_security, access_forensics_lockers)

	var/mob/target
	var/oldtarget_name
	var/threatlevel = 0
	var/target_lastloc //Loc of target when arrested.
	var/last_found //There's a delay
	var/frustration = 0

	var/idcheck = 0 //If false, all station IDs are authorized for weapons.
	var/check_records = 0	//Does it check security records?
	var/check_arrest = 1	//Does it check arrest status?
	var/arrest_type = 0 //If true, don't handcuff
	var/declare_arrests = 0 //When making an arrest, should it notify everyone wearing sechuds?

	var/has_laser = 0
	var/next_harm_time = 0
	var/lastfired = 0
	var/shot_delay = 3 //.3 seconds between shots
	var/lasercolor = ""
	var/projectile = null//Holder for projectile type, to avoid so many else if chains
	var/disabled = 0//A holder for if it needs to be disabled, if true it will not seach for targets, shoot at targets, or move, currently only used for lasertag

	var/mode = 0
#define SECBOT_IDLE 		0		// idle
#define SECBOT_HUNT 		1		// found target, hunting
#define SECBOT_PREP_ARREST 	2		// at target, preparing to arrest
#define SECBOT_ARREST		3		// arresting target
#define SECBOT_START_PATROL	4		// start patrol
#define SECBOT_PATROL		5		// patrolling
#define SECBOT_SUMMON		6		// summoned by PDA

	var/auto_patrol = 0		// set to make bot automatically patrol

	var/beacon_freq = 1445		// navigation beacon frequency
	var/control_freq = AI_FREQ		// bot control frequency


	var/turf/patrol_target	// this is turf to navigate to (location of beacon)
	var/new_destination		// pending new destination (waiting for beacon response)
	var/destination			// destination description tag
	var/next_destination	// the next destination in the patrol route
	var/list/path = new				// list of path turfs

	var/blockcount = 0		//number of times retried a blocked path
	var/awaiting_beacon	= 0	// count of pticks awaiting a beacon response

	var/nearest_beacon			// the nearest beacon's tag
	var/turf/nearest_beacon_loc	// the nearest beacon's location

	var/bot_version = "1.3"
	var/search_range = 7
	var/is_attacking = 0

	var/obj/item/weapon/secbot_assembly = /obj/item/weapon/secbot_assembly

	var/list/threat_found_sounds = new('sound/voice/bcriminal.ogg', 'sound/voice/bjustice.ogg', 'sound/voice/bfreeze.ogg')
	var/list/preparing_arrest_sounds = new('sound/voice/bgod.ogg', 'sound/voice/biamthelaw.ogg', 'sound/voice/bsecureday.ogg', 'sound/voice/bradio.ogg', 'sound/voice/binsult.ogg', 'sound/voice/bcreep.ogg')

/obj/machinery/bot/secbot/beepsky
	name = "Officer Beep O'sky"
	desc = "It's Officer Beep O'sky! Powered by a potato and a shot of whiskey."
	idcheck = 0
	auto_patrol = 1

/obj/item/weapon/secbot_assembly
	name = "helmet/signaler assembly"
	desc = "Some sort of bizarre assembly."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "helmet_signaler"
	item_state = "helmet"
	var/build_step = 0
	var/created_name = "Securitron" //To preserve the name if it's a unique securitron I guess

/obj/machinery/bot/secbot/New(loc, created_name, created_lasercolor)
	..()
	if(created_name)		name = created_name
	if(created_lasercolor)	lasercolor = created_lasercolor
	update_icon()
	spawn(3)
		src.botcard = new /obj/item/weapon/card/id(src)
		var/datum/job/detective/J = new/datum/job/detective
		src.botcard.access = J.get_access()
		if(radio_controller)
			radio_controller.add_object(src, control_freq, filter = RADIO_SECBOT)
			radio_controller.add_object(src, beacon_freq, filter = RADIO_NAVBEACONS)
		if(lasercolor)
			shot_delay = 6		//Longer shot delay because JESUS CHRIST
			check_arrest = 0
			check_records = 0	//Don't actively target people set to arrest
			arrest_type = 1		//Don't even try to cuff
			req_access = list(access_maint_tunnels)
			arrest_type = 1
			if((lasercolor == "b") && (name == created_name))//Picks a name if there isn't already a custome one
				name = pick("BLUE BALLER","SANIC","BLUE KILLDEATH MURDERBOT")
			if((lasercolor == "r") && (name == created_name))
				name = pick("RED RAMPAGE","RED ROVER","RED KILLDEATH MURDERBOT")


/obj/machinery/bot/secbot/update_icon()
	if(on && is_attacking)
		src.icon_state = "secbot-c"
	else
		src.icon_state = "secbot[src.on]"

/obj/machinery/bot/secbot/turn_on()
	..()
	update_icon()
	src.updateUsrDialog()

/obj/machinery/bot/secbot/turn_off()
	..()
	src.target = null
	src.oldtarget_name = null
	src.anchored = 0
	src.mode = SECBOT_IDLE
	walk_to(src,0)
	update_icon()
	src.updateUsrDialog()

/obj/machinery/bot/secbot/attack_hand(mob/user as mob)
	. = ..()
	if(.)
		return
	usr.set_machine(src)
	interact(user)

/obj/machinery/bot/secbot/interact(mob/user as mob)
	var/dat

	dat += text({"
<TT><B>Automatic Security Unit v[bot_version]</B></TT><BR><BR>
Status: []<BR>
Behaviour controls are [src.locked ? "locked" : "unlocked"]<BR>
Maintenance panel is [src.open ? "opened" : "closed"]"},

"<A href='?src=\ref[src];power=1'>[src.on ? "On" : "Off"]</A>" )

	if(!src.locked || issilicon(user))
		dat += text({"<BR>
Check for Weapon Authorization: []<BR>
Check Security Records: []<BR>
Check Arrest Status: []<BR>
Operating Mode: []<BR>
Report Arrests: []<BR>
Auto Patrol: []"},

"<A href='?src=\ref[src];operation=idcheck'>[src.idcheck ? "Yes" : "No"]</A>",
"<A href='?src=\ref[src];operation=ignorerec'>[src.check_records ? "Yes" : "No"]</A>",
"<A href='?src=\ref[src];operation=ignorearr'>[src.check_arrest ? "Yes" : "No"]</A>",
"<A href='?src=\ref[src];operation=switchmode'>[src.arrest_type ? "Detain" : "Arrest"]</A>",
"<A href='?src=\ref[src];operation=declarearrests'>[src.declare_arrests ? "Yes" : "No"]</A>",
"<A href='?src=\ref[src];operation=patrol'>[auto_patrol ? "On" : "Off"]</A>" )


	user << browse("<HEAD><TITLE>Securitron v[bot_version] controls</TITLE></HEAD>[dat]", "window=autosec")
	onclose(user, "autosec")
	return

/obj/machinery/bot/secbot/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(lasercolor && (istype(usr,/mob/living/carbon/human)))
		var/mob/living/carbon/human/H = usr
		if((lasercolor == "b") && (istype(H.wear_suit, /obj/item/clothing/suit/redtag)))//Opposing team cannot operate it
			return
		else if((lasercolor == "r") && (istype(H.wear_suit, /obj/item/clothing/suit/bluetag)))
			return
	if((href_list["power"]) && (src.allowed(usr)))
		if(src.on)
			turn_off()
		else
			turn_on()
		src.updateUsrDialog()
		return

	switch(href_list["operation"])
		if("idcheck")
			src.idcheck = !src.idcheck
		if("ignorerec")
			src.check_records = !src.check_records
		if("ignorearr")
			src.check_arrest = !src.check_arrest
		if("switchmode")
			src.arrest_type = !src.arrest_type
		if("patrol")
			auto_patrol = !auto_patrol
			mode = SECBOT_IDLE
		if("declarearrests")
			src.declare_arrests = !src.declare_arrests
	src.updateUsrDialog()

/obj/machinery/bot/secbot/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/device/pda))
		if(src.allowed(user) && !open && !emagged)
			src.locked = !src.locked
			user << "<span class='notice'>Controls are now [src.locked ? "locked" : "unlocked"].</span>"
		else
			if(emagged)
				user << "<span class='warning'>ERROR</span>"
			if(open)
				user << "<span class='warning'>Please close the access panel before locking it.</span>"
			else
				user << "<span class='notice'>Access denied.</span>"
	else
		..()
		if(!istype(W, /obj/item/weapon/screwdriver) && W.force && !src.target)
			src.target = user
			if(lasercolor)//To make up for the fact that lasertag bots don't hunt
				src.shootAt(user)
			src.mode = SECBOT_HUNT

/obj/machinery/bot/secbot/Emag(mob/user as mob)
	..()
	if(open && !locked)
		if(user) user << "<span class='warning'>You short out [src]'s target assessment circuits.</span>"
		spawn(0)
			for(var/mob/O in hearers(src, null))
				O.show_message("\red <B>[src] buzzes oddly!</B>", 1)
		src.target = null
		if(user) src.oldtarget_name = user.name
		src.last_found = world.time
		src.anchored = 0
		src.emagged = 2
		src.on = 1
		update_icon()
		src.projectile = null
		mode = SECBOT_IDLE

/obj/machinery/bot/secbot/process()
	set background = 1

	if(!src.on)
		return

	switch(mode)

		if(SECBOT_IDLE)		// idle
			walk_to(src,0)
			look_for_perp()	// see if any criminals are in range
			if(!mode && auto_patrol)	// still idle, and set to patrol
				mode = SECBOT_START_PATROL	// switch to patrol mode

		if(SECBOT_HUNT)		// hunting for perp
			// if can't reach perp for long enough, go idle
			if(src.frustration >= 8)
		//		for(var/mob/O in hearers(src, null))
		//			O << "<span class='game say'><span class='name'>[src]</span> beeps, \"Backup requested! Suspect has evaded arrest.\""
				src.target = null
				src.last_found = world.time
				src.frustration = 0
				src.mode = 0
				walk_to(src,0)

			// We re-assess human targets, before bashing their head in, in case their credentials change
			if(target && istype(target, /mob/living/carbon/human))
				var/threat = src.assess_perp(target, idcheck, check_records, check_arrest)
				if(threat < 4)
					target = null

			if(target)		// make sure target exists
				if(!lasercolor && Adjacent(target))	// If right next to perp. Lasertag bots do not arrest anyone, just patrol and shoot and whatnot
					if(istype(src.target,/mob/living/carbon))
						playsound(src.loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)
						is_attacking = 1
						update_icon()
						spawn(2)
							is_attacking = 0
							update_icon()
						var/mob/living/carbon/M = src.target
						var/maxstuns = 4
						if(istype(M, /mob/living/carbon/human))
							if(M.stuttering < 10 && (!(HULK in M.mutations)))
								M.stuttering = 10
							M.Stun(10)
							M.Weaken(10)
						else
							M.Weaken(10)
							M.stuttering = 10
							M.Stun(10)
						maxstuns--
						if(maxstuns <= 0)
							target = null

						if(declare_arrests)
							var/area/location = get_area(src)
							broadcast_security_hud_message("[src.name] is [arrest_type ? "detaining" : "arresting"] level [threatlevel] suspect <b>[target]</b> in <b>[location]</b>", src)
						visible_message("\red <B>[src.target] has been stunned by [src]!</B>")

						mode = SECBOT_PREP_ARREST
						src.anchored = 1
						src.target_lastloc = M.loc
						return
					else if(istype(src.target,/mob/living/simple_animal))
						//just harmbaton them until dead
						if(world.time > next_harm_time)
							next_harm_time = world.time + 15
							playsound(src.loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)
							visible_message("\red <B>[src] beats [src.target] with the stun baton!</B>")
							update_icon()
							spawn(2)
								is_attacking = 0
								update_icon()

							var/mob/living/simple_animal/S = src.target
							S.AdjustStunned(10)
							S.adjustBruteLoss(15)
							if(S.stat)
								src.frustration = 8
								if(preparing_arrest_sounds.len > 0)
									playsound(src.loc, pick(preparing_arrest_sounds), 50, 0)
				else								// not next to perp
					var/turf/olddist = get_dist(src, src.target)
					walk_to(src, target,1,4)
					shootAt(target)
					if((get_dist(src, src.target)) >= (olddist))
						src.frustration++
					else
						src.frustration = 0
			else
				src.frustration = 8

		if(SECBOT_PREP_ARREST)		// preparing to arrest target
			if(src.lasercolor)
				mode = SECBOT_IDLE
				return
			if(!target)
				mode = SECBOT_IDLE
				src.anchored = 0
				return
			// see if he got away
			if((get_dist(src, src.target) > 1) || ((src.target.loc != src.target_lastloc) && src.target.weakened < 2))
				src.anchored = 0
				mode = SECBOT_HUNT
				return

			if(istype(src.target,/mob/living/carbon))
				var/mob/living/carbon/C = target
				if(!C.handcuffed && !src.arrest_type)
					playsound(src.loc, 'sound/weapons/handcuffs.ogg', 30, 1, -2)
					mode = SECBOT_ARREST
					visible_message("\red <B>[src] is trying to put handcuffs on [src.target]!</B>")

					spawn(60)
						if(get_dist(src, src.target) <= 1)
							/*if(src.target.handcuffed)
								return*/

							if(istype(src.target,/mob/living/carbon))
								C = target
								if(!C.handcuffed)
									C.handcuffed = new /obj/item/weapon/handcuffs(target)
									C.update_inv_handcuffed()	//update the handcuffs overlay

							mode = SECBOT_IDLE
							src.target = null
							src.anchored = 0
							src.last_found = world.time
							src.frustration = 0

							if(preparing_arrest_sounds.len > 0)
								playsound(src.loc, pick(preparing_arrest_sounds), 50, 0)
		//					var/arrest_message = pick("Have a secure day!","I AM THE LAW.", "God made tomorrow for the crooks we don't catch today.","You can't outrun a radio.")
		//					src.speak(arrest_message)
			else
				mode = SECBOT_IDLE
				src.target = null
				src.anchored = 0
				src.last_found = world.time
				src.frustration = 0

		if(SECBOT_ARREST)		// arresting
			if(src.lasercolor)
				mode = SECBOT_IDLE
				return
			if(!target || !istype(target, /mob/living/carbon))
				src.anchored = 0
				mode = SECBOT_IDLE
				return
			else
				var/mob/living/carbon/C = target
				if(!C.handcuffed)
					src.anchored = 0
					mode = SECBOT_IDLE
					return


		if(SECBOT_START_PATROL)	// start a patrol

			if(path.len > 0 && patrol_target)	// have a valid path, so just resume
				mode = SECBOT_PATROL
				return

			else if(patrol_target)		// has patrol target already
				spawn(0)
					calc_path()		// so just find a route to it
					if(path.len == 0)
						patrol_target = 0
						return
					mode = SECBOT_PATROL


			else					// no patrol target, so need a new one
				find_patrol_target()
				speak("Engaging patrol mode.")


		if(SECBOT_PATROL)		// patrol mode
			patrol_step()
			spawn(5)
				if(mode == SECBOT_PATROL)
					patrol_step()

		if(SECBOT_SUMMON)		// summoned to PDA
			patrol_step()
			spawn(4)
				if(mode == SECBOT_SUMMON)
					patrol_step()
					sleep(4)
					patrol_step()

	return


// perform a single patrol step
/obj/machinery/bot/secbot/proc/patrol_step()
	if(loc == patrol_target)		// reached target
		at_patrol_target()
		return
	else if(path.len > 0 && patrol_target)		// valid path
		var/turf/next = path[1]
		if(next == loc)
			path -= next
			return

		if(istype( next, /turf/simulated))
			var/moved = step_towards(src, next)	// attempt to move
			if(moved)	// successful move
				blockcount = 0
				path -= loc

				look_for_perp()
				if(lasercolor)
					sleep(20)
			else		// failed to move
				blockcount++
				if(blockcount > 5)	// attempt 5 times before recomputing
					// find new path excluding blocked turf

					spawn(2)
						calc_path(next)
						if(path.len == 0)
							find_patrol_target()
						else
							blockcount = 0
					return
				return
		else	// not a valid turf
			mode = SECBOT_IDLE
			return
	else	// no path, so calculate new one
		mode = SECBOT_START_PATROL

// finds a new patrol target
/obj/machinery/bot/secbot/proc/find_patrol_target()
	send_status()
	if(awaiting_beacon)			// awaiting beacon response
		awaiting_beacon++
		if(awaiting_beacon > 5)	// wait 5 secs for beacon response
			find_nearest_beacon()	// then go to nearest instead
		return

	if(next_destination)
		set_destination(next_destination)
	else
		find_nearest_beacon()
	return

// finds the nearest beacon to self
// signals all beacons matching the patrol code
/obj/machinery/bot/secbot/proc/find_nearest_beacon()
	nearest_beacon = null
	new_destination = "__nearest__"
	post_signal(beacon_freq, "findbeacon", "patrol")
	awaiting_beacon = 1
	spawn(10)
		awaiting_beacon = 0
		if(nearest_beacon)
			set_destination(nearest_beacon)
		else
			auto_patrol = 0
			mode = SECBOT_IDLE
			speak("Disengaging patrol mode.")
			send_status()

/obj/machinery/bot/secbot/proc/at_patrol_target()
	find_patrol_target()
	return

// sets the current destination
// signals all beacons matching the patrol code
// beacons will return a signal giving their locations
/obj/machinery/bot/secbot/proc/set_destination(var/new_dest)
	new_destination = new_dest
	post_signal(beacon_freq, "findbeacon", "patrol")
	awaiting_beacon = 1


// receive a radio signal
// used for beacon reception
/obj/machinery/bot/secbot/receive_signal(datum/signal/signal)
	//log_admin("DEBUG \[[world.timeofday]\]: /obj/machinery/bot/secbot/receive_signal([signal.debug_print()])")
	if(!on)
		return

	/*
	world << "rec signal: [signal.source]"
	for(var/x in signal.data)
		world << "* [x] = [signal.data[x]]"
	*/

	var/recv = signal.data["command"]
	// process all-bot input
	if(recv=="bot_status")
		send_status()

	// check to see if we are the commanded bot
	if(signal.data["active"] == src)
	// process control input
		switch(recv)
			if("stop")
				mode = SECBOT_IDLE
				auto_patrol = 0
				return

			if("go")
				mode = SECBOT_IDLE
				auto_patrol = 1
				return

			if("summon")
				patrol_target = signal.data["target"]
				next_destination = destination
				destination = null
				awaiting_beacon = 0
				mode = SECBOT_SUMMON
				calc_path()
				speak("Responding.")

				return



	// receive response from beacon
	recv = signal.data["beacon"]
	var/valid = signal.data["patrol"]
	if(!recv || !valid)
		return

	if(recv == new_destination)	// if the recvd beacon location matches the set destination
								// the we will navigate there
		destination = new_destination
		patrol_target = signal.source.loc
		next_destination = signal.data["next_patrol"]
		awaiting_beacon = 0

	// if looking for nearest beacon
	else if(new_destination == "__nearest__")
		var/dist = get_dist(src,signal.source.loc)
		if(nearest_beacon)

			// note we ignore the beacon we are located at
			if(dist>1 && dist<get_dist(src,nearest_beacon_loc))
				nearest_beacon = recv
				nearest_beacon_loc = signal.source.loc
				return
			else
				return
		else if(dist > 1)
			nearest_beacon = recv
			nearest_beacon_loc = signal.source.loc
	return


// send a radio signal with a single data key/value pair
/obj/machinery/bot/secbot/proc/post_signal(var/freq, var/key, var/value)
	post_signal_multiple(freq, list("[key]" = value) )

// send a radio signal with multiple data key/values
/obj/machinery/bot/secbot/proc/post_signal_multiple(var/freq, var/list/keyval)

	var/datum/radio_frequency/frequency = radio_controller.return_frequency(freq)

	if(!frequency) return

	var/datum/signal/signal = new()
	signal.source = src
	signal.transmission_method = 1
	//for(var/key in keyval)
	//	signal.data[key] = keyval[key]
	signal.data = keyval
		//world << "sent [key],[keyval[key]] on [freq]"
	if(signal.data["findbeacon"])
		frequency.post_signal(src, signal, filter = RADIO_NAVBEACONS)
	else if(signal.data["type"] == "secbot")
		frequency.post_signal(src, signal, filter = RADIO_SECBOT)
	else
		frequency.post_signal(src, signal)

// signals bot status etc. to controller
/obj/machinery/bot/secbot/proc/send_status()
	var/list/kv = list(
	"type" = "secbot",
	"name" = name,
	"loca" = loc.loc,	// area
	"mode" = mode
	)
	post_signal_multiple(control_freq, kv)

// calculates a path to the current destination
// given an optional turf to avoid
/obj/machinery/bot/secbot/proc/calc_path(var/turf/avoid = null)
	src.path = AStar(src.loc, patrol_target, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 120, id=botcard, exclude=avoid)
	if(!path) path = list()

// look for a criminal in view of the bot
/obj/machinery/bot/secbot/proc/look_for_perp()
	if(src.disabled)
		return
	src.anchored = 0
	for(var/mob/living/M in view(search_range,src)) //Let's find us a criminal
		if(istype(M, /mob/living/carbon))
			var/mob/living/carbon/C = M
			if(C.stat || C.handcuffed)
				continue

			if(src.lasercolor && C.lying)
				continue//Does not shoot at people lying down when in lasertag mode, because it's just annoying, and they can fire once they get up.

			if(C.name == src.oldtarget_name && world.time < src.last_found + 100)
				continue

			if(istype(C, /mob/living/carbon/human))
				src.threatlevel = src.assess_perp(C, idcheck, check_records, check_arrest)

		else if(istype(M, /mob/living/simple_animal/hostile))
			if(M.stat == DEAD)
				continue
			else
				src.threatlevel = 4

		if(!src.threatlevel)
			continue

		else if(M.stat != DEAD && src.threatlevel >= 4)
			src.target = M
			src.oldtarget_name = M.name
			src.speak("Level [src.threatlevel] infraction alert!")
			if(!src.lasercolor && threat_found_sounds.len > 0)
				playsound(src.loc, pick(threat_found_sounds), 50, 0)
			src.visible_message("<b>[src]</b> points at [M.name]!")

			mode = SECBOT_HUNT
			spawn(0)
				process()	// ensure bot quickly responds to a perp
			break
		else
			continue

/obj/machinery/bot/secbot/on_assess_perp(mob/living/carbon/human/perp)
	if(lasercolor)
		return laser_check(perp, lasercolor)

	var/threat = 0
	threat -= laser_check(perp, "b")
	threat -= laser_check(perp, "r")

	return threat

/obj/machinery/bot/secbot/proc/laser_check(mob/living/carbon/human/perp, var/lasercolor)
	var/target_suit
	var/target_weapon
	var/threat = 0
	//Lasertag turrets target the opposing team, how great is that? -Sieve
	switch(lasercolor)
		if("b")
			target_suit = /obj/item/clothing/suit/redtag
			target_weapon = /obj/item/weapon/gun/energy/laser/redtag
		if("r")
			target_suit = /obj/item/clothing/suit/bluetag
			target_weapon = /obj/item/weapon/gun/energy/laser/bluetag

	if((istype(perp.r_hand, target_weapon)) || (istype(perp.l_hand, target_weapon)))
		threat += 4

	if(istype(perp, /mob/living/carbon/human))
		if(istype(perp.wear_suit, target_suit))
			threat += 4
		if(istype(perp.belt, target_weapon))
			threat += 2

	return threat

/obj/machinery/bot/secbot/is_assess_emagged()
	return emagged == 2

/obj/machinery/bot/secbot/Bump(M as mob|obj) //Leave no door unopened!
	if((istype(M, /obj/machinery/door)) && !isnull(src.botcard))
		var/obj/machinery/door/D = M
		if(!istype(D, /obj/machinery/door/firedoor) && D.check_access(src.botcard) && !istype(D,/obj/machinery/door/poddoor))
			D.open()
			src.frustration = 0
	else if(!src.anchored)
		if((istype(M, /mob/living/)))
			var/mob/living/O = M
			src.loc = O.loc
			src.frustration = 0
		else if(istype(M, /obj/machinery/bot))
			var/obj/machinery/bot/B = M
			if(B.dir != src.dir) // Avoids issues if two bots are currently patrolling in the same direction
				src.loc = B.loc
				src.frustration = 0
	return

/obj/machinery/bot/secbot/proc/speak(var/message)
	for(var/mob/O in hearers(src, null))
		O.show_message("<span class='game say'><span class='name'>[src]</span> beeps, \"[message]\"",2)
	return

/obj/machinery/bot/secbot/explode()
	walk_to(src,0)
	src.visible_message("\red <B>[src] blows apart!</B>", 1)
	var/turf/Tsec = get_turf(src)

	var/obj/item/weapon/secbot_assembly/Sa = new secbot_assembly(Tsec)
	Sa.build_step = 1
	Sa.overlays += image('icons/obj/aibots.dmi', "hs_hole")
	Sa.created_name = src.name
	new /obj/item/device/assembly/prox_sensor(Tsec)
	new /obj/item/weapon/melee/baton(Tsec)

	on_explosion()

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()

	new /obj/effect/decal/cleanable/blood/oil(src.loc)
	del(src)


/obj/machinery/bot/secbot/proc/on_explosion(var/turf/Tsec)
	new /obj/item/weapon/melee/baton(Tsec)
	if(prob(50))
		new /obj/item/robot_parts/l_arm(Tsec)

//Secbot Construction

/obj/item/clothing/head/helmet/attackby(var/obj/item/device/assembly/signaler/S, mob/user as mob)
	..()
	if(!issignaler(S))
		..()
		return

	if(src.type != /obj/item/clothing/head/helmet) //Eh, but we don't want people making secbots out of space helmets.
		return

	if(S.secured)
		del(S)
		var/obj/item/weapon/secbot_assembly/A = new /obj/item/weapon/secbot_assembly
		user.put_in_hands(A)
		user << "You add the signaler to the helmet."
		user.drop_from_inventory(src)
		del(src)
	else
		return

/obj/item/weapon/secbot_assembly/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if((istype(W, /obj/item/weapon/weldingtool)) && (!src.build_step))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.remove_fuel(0,user))
			src.build_step++
			src.overlays += image('icons/obj/aibots.dmi', "hs_hole")
			user << "You weld a hole in [src]!"

	else if(isprox(W) && (src.build_step == 1))
		user.drop_item()
		src.build_step++
		user << "You add the prox sensor to [src]!"
		src.overlays += image('icons/obj/aibots.dmi', "hs_eye")
		src.name = "helmet/signaler/prox sensor assembly"
		del(W)

	else if(((istype(W, /obj/item/robot_parts/l_arm)) || (istype(W, /obj/item/robot_parts/r_arm))) && (src.build_step == 2))
		user.drop_item()
		src.build_step++
		user << "You add the robot arm to [src]!"
		src.name = "helmet/signaler/prox sensor/robot arm assembly"
		src.overlays += image('icons/obj/aibots.dmi', "hs_arm")
		del(W)

	else if((istype(W, /obj/item/weapon/melee/baton)) && (src.build_step >= 3))
		user.drop_item()
		src.build_step++
		user << "You complete the Securitron! Beep boop."
		var/obj/machinery/bot/secbot/S = new /obj/machinery/bot/secbot
		S.loc = get_turf(src)
		S.name = src.created_name
		del(W)
		del(src)

	else if(istype(W, /obj/item/weapon/pen))
		var/t = copytext(stripped_input(user, "Enter new robot name", src.name, src.created_name),1,MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, usr) && src.loc != usr)
			return
		src.created_name = t

/obj/machinery/bot/secbot/proc/shootAt(var/mob/target)
	if(!has_laser || (lastfired && world.time - lastfired < shot_delay))
		return
	lastfired = world.time
	var/turf/T = loc
	var/atom/U = (istype(target, /atom/movable) ? target.loc : target)
	if((!( U ) || !( T )))
		return
	while(!( istype(U, /turf) ))
		U = U.loc
	if(!( istype(T, /turf) ))
		return

	if(!projectile)
		if(!lasercolor)
			if(src.emagged == 2)
				projectile = /obj/item/projectile/beam
			else
				projectile = /obj/item/projectile/beam/stun
		else if(lasercolor == "b")
			if(src.emagged == 2)
				projectile = /obj/item/projectile/beam/lastertag/omni
			else
				projectile = /obj/item/projectile/beam/lastertag/blue
		else if(lasercolor == "r")
			if(src.emagged == 2)
				projectile = /obj/item/projectile/beam/lastertag/omni
			else
				projectile = /obj/item/projectile/beam/lastertag/red

	if(!( istype(U, /turf) ))
		return

	playsound(src.loc, src.emagged == 2 ? 'sound/weapons/Laser.ogg' : 'sound/weapons/Taser.ogg', 50, 1)
	var/obj/item/projectile/A = new projectile (loc)
	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x
	spawn( 0 )
		A.process()
		return
	return

/obj/machinery/bot/secbot/emp_act(severity)
	if(severity==2 && prob(70))
		..(severity-1)
	else
		var/obj/effect/overlay/pulse2 = new/obj/effect/overlay ( src.loc )
		pulse2.icon = 'icons/effects/effects.dmi'
		pulse2.icon_state = "empdisable"
		pulse2.name = "emp sparks"
		pulse2.anchored = 1
		pulse2.set_dir(pick(cardinal))
		spawn(10)
			pulse2.delete()
		var/list/mob/living/carbon/targets = new
		for(var/mob/living/carbon/C in view(12,src))
			if(C.stat==2)
				continue
			targets += C
		if(targets.len)
			if(prob(50))
				var/mob/toshoot = pick(targets)
				if(toshoot)
					targets-=toshoot
					if(prob(50) && emagged < 2)
						emagged = 2
						shootAt(toshoot)
						emagged = 0
					else
						shootAt(toshoot)
			else if(prob(50))
				if(targets.len)
					var/mob/toarrest = pick(targets)
					if(toarrest)
						src.target = toarrest
						src.mode = SECBOT_HUNT
