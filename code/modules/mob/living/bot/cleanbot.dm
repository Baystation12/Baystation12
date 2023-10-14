/mob/living/bot/cleanbot
	name = "Cleanbot"
	desc = "A little cleaning robot, he looks so excited!"
	icon = 'icons/mob/bot/cleanbot.dmi'
	icon_state = "cleanbot0"
	req_access = list(list(access_janitor, access_robotics))
	botcard_access = list(access_janitor, access_maint_tunnels)

	wait_if_pulled = 1
	min_target_dist = 0

	var/cleaning = 0
	var/screwloose = 0
	var/oddbutton = 0
	var/blood = 1
	var/list/target_types = list()


/mob/living/bot/cleanbot/Initialize(mapload)
	. = ..()
	get_targets()


/mob/living/bot/cleanbot/handleIdle()
	if(!screwloose && !oddbutton && prob(5))
		visible_message("\The [src] makes an excited beeping booping sound!")

	if(screwloose && prob(5)) // Make a mess
		if(istype(loc, /turf/simulated))
			var/turf/simulated/T = loc
			T.wet_floor()

	if(oddbutton && prob(5)) // Make a big mess
		visible_message("Something flies out of [src]. He seems to be acting oddly.")
		var/obj/decal/cleanable/blood/gibs/gib = new /obj/decal/cleanable/blood/gibs(loc)
		var/weakref/g = weakref(gib)
		ignore_list += g
		spawn(600)
			ignore_list -= g

/mob/living/bot/cleanbot/lookForTargets()
	for(var/obj/decal/cleanable/D in view(world.view + 1, src))
		if(confirmTarget(D))
			target = D
			playsound(src, 'sound/machines/boop1.ogg', 30)
			return

/mob/living/bot/cleanbot/confirmTarget(obj/decal/cleanable/D)
	if(!..())
		return 0
	for(var/T in target_types)
		if(istype(D, T))
			return 1
	return 0

/mob/living/bot/cleanbot/handleAdjacentTarget()
	if(get_turf(target) == src.loc)
		UnarmedAttack(target)

/mob/living/bot/cleanbot/UnarmedAttack(obj/decal/cleanable/D, proximity)
	if(!..())
		return

	if(!istype(D))
		return

	if(D.loc != loc)
		return

	busy = 1
	visible_message("\The [src] begins to clean up \the [D]")
	update_icons()
	var/cleantime = (istype(D, /obj/decal/cleanable/dirt) ? 1 : 5) SECONDS
	if(do_after(src, cleantime, D, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
		if(istype(loc, /turf/simulated))
			var/turf/simulated/f = loc
			f.dirt = 0
		if(!D)
			return
		qdel(D)
		if(D == target)
			target = null
	playsound(src, 'sound/machines/boop2.ogg', 30)
	busy = 0
	update_icons()

/mob/living/bot/cleanbot/explode()
	on = 0
	visible_message(SPAN_DANGER("[src] blows apart!"))
	var/turf/Tsec = get_turf(src)

	new /obj/item/reagent_containers/glass/bucket(Tsec)
	new /obj/item/device/assembly/prox_sensor(Tsec)
	if(prob(50))
		new /obj/item/robot_parts/l_arm(Tsec)

	var/datum/effect/spark_spread/s = new /datum/effect/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)
	return

/mob/living/bot/cleanbot/update_icons()
	if(busy)
		icon_state = "cleanbot-c"
	else
		icon_state = "cleanbot[on]"

/mob/living/bot/cleanbot/GetInteractTitle()
	. = "<head><title>Cleanbot controls</title></head>"
	. += "<b>Automatic Cleaner v1.0</b>"

/mob/living/bot/cleanbot/GetInteractPanel()
	. = "Cleans blood: <a href='?src=\ref[src];command=blood'>[blood ? "Yes" : "No"]</a>"
	. += "<br>Patrol station: <a href='?src=\ref[src];command=patrol'>[will_patrol ? "Yes" : "No"]</a>"

/mob/living/bot/cleanbot/GetInteractMaintenance()
	. = "Odd looking screw twiddled: <a href='?src=\ref[src];command=screw'>[screwloose ? "Yes" : "No"]</a>"
	. += "<br>Weird button pressed: <a href='?src=\ref[src];command=oddbutton'>[oddbutton ? "Yes" : "No"]</a>"

/mob/living/bot/cleanbot/ProcessCommand(mob/user, command, href_list)
	..()
	if(CanAccessPanel(user))
		switch(command)
			if("blood")
				blood = !blood
				get_targets()
			if("patrol")
				will_patrol = !will_patrol
				patrol_path = null

	if(CanAccessMaintenance(user))
		switch(command)
			if("screw")
				screwloose = !screwloose
			if("oddbutton")
				oddbutton = !oddbutton

/mob/living/bot/cleanbot/emag_act(remaining_uses, mob/user)
	. = ..()
	if(!screwloose || !oddbutton)
		if(user)
			to_chat(user, SPAN_NOTICE("The [src] buzzes and beeps."))
		oddbutton = 1
		screwloose = 1
		return 1


/mob/living/bot/cleanbot/get_construction_info()
	return list(
		"Attach a <b>Proximity Sensor</b> to a <b>Bucket</b>.",
		"Add a <b>Robot Arm</b> to complete the cleanbot."
	)


/mob/living/bot/cleanbot/get_antag_interactions_info()
	. = ..()
	.[CODEX_INTERACTION_EMAG] += "<p>Turns on malfunctions that causes \the [initial(name)] to spew out gibs and water.</p>"


/mob/living/bot/cleanbot/proc/get_targets()
	target_types = list()

	target_types += /obj/decal/cleanable/blood/oil
	target_types += /obj/decal/cleanable/vomit
	target_types += /obj/decal/cleanable/crayon
	target_types += /obj/decal/cleanable/liquid_fuel
	target_types += /obj/decal/cleanable/mucus
	target_types += /obj/decal/cleanable/dirt
	target_types += /obj/decal/cleanable/filth
	target_types += /obj/decal/cleanable/spiderling_remains

	if(blood)
		target_types += /obj/decal/cleanable/blood
