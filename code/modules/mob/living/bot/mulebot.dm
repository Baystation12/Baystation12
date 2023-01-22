#define MULE_IDLE 0
#define MULE_MOVING 1
#define MULE_UNLOAD 2
#define MULE_LOST 3
#define MULE_CALC_MIN 4
#define MULE_CALC_MAX 10
#define MULE_PATH_DONE 11
// IF YOU CHANGE THOSE, UPDATE THEM IN pda.tmpl TOO

/mob/living/bot/mulebot
	name = "Mulebot"
	desc = "A Multiple Utility Load Effector bot."
	icon = 'icons/mob/bot/mulebot.dmi'
	icon_state = "mulebot0"
	layer = MOB_LAYER
	anchored = TRUE
	density = TRUE
	health = 150
	maxHealth = 150
	mob_bump_flag = HEAVY

	min_target_dist = 0
	max_target_dist = 250
	target_speed = 3
	max_frustration = 5
	botcard_access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station)

	var/atom/movable/load

	var/paused = 1
	var/crates_only = 1
	var/auto_return = 1
	var/safety = 1

	var/targetName
	var/turf/home
	var/homeName

	var/static/amount = 0

/mob/living/bot/mulebot/New()
	..()

	var/turf/T = get_turf(loc)
	var/obj/machinery/navbeacon/N = locate() in T
	if(N)
		home = T
		homeName = N.location
	else
		homeName = "Unset"

	suffix = num2text(++amount)
	name = "Mulebot #[suffix]"

/mob/living/bot/mulebot/MouseDrop_T(var/atom/movable/C, var/mob/user)
	if(user.stat)
		return

	if(!istype(C) || C.anchored || get_dist(user, src) > 1 || get_dist(src, C) > 1 )
		return

	load(C)

/mob/living/bot/mulebot/GetInteractTitle()
	. = "<head><title>Mulebot [suffix ? "([suffix])" : ""]</title></head>"
	. += "<b>Multiple Utility Load Effector Mk. III</b>"
	. += "<br>ID: [suffix]"

/mob/living/bot/mulebot/GetInteractStatus()
	. = ..()
	. += "<br>Current Load: [load ? load.name : "<i>none</i>"]"

/mob/living/bot/mulebot/GetInteractPanel()
	. += "<a href='?src=\ref[src];command=stop'>Stop</a>"
	. += "<br><a href='?src=\ref[src];command=go'>Proceed</a>"
	. += "<br><a href='?src=\ref[src];command=home'>Return to home</a>"
	. += "<br><a href='?src=\ref[src];command=destination'>Set destination</a>"
	. += "<br><a href='?src=\ref[src];command=sethome'>Set home</a>"
	. += "<br><a href='?src=\ref[src];command=autoret'>Toggle auto return home</a> ([auto_return ? "On" : "Off"])"
	. += "<br><a href='?src=\ref[src];command=cargotypes'>Toggle non-standard cargo</a> ([crates_only ? "Off" : "On"])"

	if(load)
		. += "<br><a href='?src=\ref[src];command=unload'>Unload now</a>"

/mob/living/bot/mulebot/GetInteractMaintenance()
	. = "<a href='?src=\ref[src];command=safety'>Toggle safety</a> ([safety ? "On" : "Off - DANGER"])"

/mob/living/bot/mulebot/ProcessCommand(var/mob/user, var/command, var/href_list)
	..()
	if(CanAccessPanel(user))
		switch(command)
			if("stop")
				obeyCommand("Stop")
			if("go")
				obeyCommand("GoTD")
			if("home")
				obeyCommand("Home")
			if("destination")
				obeyCommand("SetD")
			if("sethome")
				var/new_dest
				var/list/beaconlist = GetBeaconList()
				if(beaconlist.len)
					new_dest = input("Select new home tag", "Mulebot [suffix ? "([suffix])" : ""]", null) in null|beaconlist
				else
					alert("No destination beacons available.")
				if(new_dest)
					home = get_turf(beaconlist[new_dest])
					homeName = new_dest
			if("unload")
				unload()
			if("autoret")
				auto_return = !auto_return
			if("cargotypes")
				crates_only = !crates_only

	if(CanAccessMaintenance(user))
		switch(command)
			if("safety")
				safety = !safety

/mob/living/bot/mulebot/attackby(var/obj/item/O, var/mob/user)
	..()
	update_icons()

/mob/living/bot/mulebot/proc/obeyCommand(var/command)
	switch(command)
		if("Home")
			resetTarget()
			target = home
			targetName = "Home"
		if("SetD")
			var/new_dest
			var/list/beaconlist = GetBeaconList()
			if(beaconlist.len)
				new_dest = input("Select new destination tag", "Mulebot [suffix ? "([suffix])" : ""]") in null|beaconlist
			else
				alert("No destination beacons available.")
			if(new_dest)
				resetTarget()
				target = get_turf(beaconlist[new_dest])
				targetName = new_dest
		if("GoTD")
			paused = 0
		if("Stop")
			paused = 1

/mob/living/bot/mulebot/emag_act(var/remaining_charges, var/user)
	locked = !locked
	to_chat(user, "<span class='notice'>You [locked ? "lock" : "unlock"] the mulebot's controls.</span>")
	flick("mulebot-emagged", src)
	playsound(loc, 'sound/effects/sparks1.ogg', 100, 0)
	return 1

/mob/living/bot/mulebot/update_icons()
	if(open)
		icon_state = "mulebot-hatch"
		return
	if(target_path.len && !paused)
		icon_state = "mulebot1"
		return
	icon_state = "mulebot0"

/mob/living/bot/mulebot/handleRegular()
	if(!safety && prob(1))
		flick("mulebot-emagged", src)
	update_icons()

/mob/living/bot/mulebot/handleFrustrated()
	custom_emote(2, "makes a sighing buzz.")
	playsound(loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
	..()

/mob/living/bot/mulebot/handleAdjacentTarget()
	if(target == src.loc)
		custom_emote(2, "makes a chiming sound.")
		playsound(loc, 'sound/machines/chime.ogg', 50, 0)
		UnarmedAttack(target)
		resetTarget()
		if(auto_return && home && (loc != home))
			target = home
			targetName = "Home"

/mob/living/bot/mulebot/confirmTarget()
	return 1

/mob/living/bot/mulebot/calcTargetPath()
	..()
	if(!target_path.len && target != home) // I presume that target is not null
		resetTarget()
		target = home
		targetName = "Home"

/mob/living/bot/mulebot/stepToTarget()
	if(paused)
		return
	..()

/mob/living/bot/mulebot/UnarmedAttack(var/turf/T)
	if(T == src.loc)
		unload(dir)

/mob/living/bot/mulebot/Bump(var/mob/living/carbon/human/M)
	if(!safety && istype(M))
		visible_message("<span class='warning'>[src] knocks over [M]!</span>")
		M.Stun(8)
		M.Weaken(5)
	..()

/mob/living/bot/mulebot/proc/runOver(var/mob/living/carbon/human/H)
	if(istype(H)) // No safety checks - WILL run over lying humans. Stop ERPing in the maint!
		visible_message("<span class='warning'>[src] drives over [H]!</span>")
		playsound(loc, 'sound/effects/splat.ogg', 50, 1)

		var/damage = rand(5, 7)
		H.apply_damage(2 * damage, DAMAGE_BRUTE, BP_HEAD)
		H.apply_damage(2 * damage, DAMAGE_BRUTE, BP_CHEST)
		H.apply_damage(0.5 * damage, DAMAGE_BRUTE, BP_L_LEG)
		H.apply_damage(0.5 * damage, DAMAGE_BRUTE, BP_R_LEG)
		H.apply_damage(0.5 * damage, DAMAGE_BRUTE, BP_L_ARM)
		H.apply_damage(0.5 * damage, DAMAGE_BRUTE, BP_R_ARM)

		blood_splatter(src, H, 1)

/mob/living/bot/mulebot/relaymove(var/mob/user, var/direction)
	if(load == user)
		unload(direction)

/mob/living/bot/mulebot/explode()
	unload(pick(0, 1, 2, 4, 8))

	visible_message("<span class='danger'>[src] blows apart!</span>")

	var/turf/Tsec = get_turf(src)
	new /obj/item/device/assembly/prox_sensor(Tsec)
	new /obj/item/stack/material/rods(Tsec)
	new /obj/item/stack/material/rods(Tsec)
	new /obj/item/stack/cable_coil/cut(Tsec)

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()

	new /obj/effect/decal/cleanable/blood/oil(Tsec)
	..()

/mob/living/bot/mulebot/proc/GetBeaconList()
	var/list/beaconlist = list()
	for(var/obj/machinery/navbeacon/N in navbeacons)
		if(!N.codes["delivery"])
			continue
		beaconlist.Add(N.location)
		beaconlist[N.location] = N
	return beaconlist

/mob/living/bot/mulebot/proc/load(var/atom/movable/C)
	if(busy || load || get_dist(C, src) > 1 || !isturf(C.loc))
		return

	for(var/obj/structure/plasticflaps/P in src.loc)//Takes flaps into account
		if(!CanPass(C,P))
			return

	if(crates_only && !istype(C,/obj/structure/closet/crate))
		custom_emote(2, "makes a sighing buzz.")
		playsound(loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
		return

	var/obj/structure/closet/crate/crate = C
	if(istype(crate))
		crate.close()

	busy = 1

	C.forceMove(loc)
	sleep(2)
	if(C.loc != loc) //To prevent you from going onto more than one bot.
		return
	C.forceMove(src)
	load = C

	C.pixel_y += 9
	if(C.layer < layer)
		C.layer = layer + 0.1
	C.plane = plane
	overlays += C

	if(ismob(C))
		var/mob/M = C
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src

	busy = 0

/mob/living/bot/mulebot/proc/unload(var/dirn = 0)
	if(!load || busy)
		return

	busy = 1
	overlays.Cut()

	load.forceMove(loc)
	load.pixel_y -= 9
	load.reset_plane_and_layer()
	if(ismob(load))
		var/mob/M = load
		if(M.client)
			M.client.perspective = MOB_PERSPECTIVE
			M.client.eye = src

	if(dirn)
		step(load, dirn)

	load = null

	for(var/atom/movable/AM in src)
		if(AM == botcard || AM == access_scanner) continue

		AM.forceMove(loc)
		AM.reset_plane_and_layer()
		AM.pixel_y = initial(AM.pixel_y)
		if(ismob(AM))
			var/mob/M = AM
			if(M.client)
				M.client.perspective = MOB_PERSPECTIVE
				M.client.eye = src
	busy = 0
