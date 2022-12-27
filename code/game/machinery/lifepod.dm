/*

For too long, the escape pod debate has plagued us all. Shuttle-based pods are stupid but nobody has successfully implemented object pods.

There is a solution in the ancient ways, they just had these really weird looking pods. This is that reinvented, after the lifepod (unintentionally?) reinvented it.

I know no God but camel case.

~10sc

*/

/proc/escapedViaPod(mob/testCase) //FUNNY PROC TIME! (It is for the end-round data collection.)
	var/obj/machinery/lifepod/pod

	if(istype(testCase.loc, /obj/machinery/lifepod)) //Are they in a lifepod?
		pod = testCase.loc

		if(pod.launchStatus == 0 || 3) //Is the lifepod still onboard or did it fail to launch?
			return FALSE //You did not escape because the pod did not launch.
		else
			return TRUE //You did escape because the pod is in space or landed somewhere.

	else
		return FALSE //You did not escape... because you're not in a pod.

/obj/machinery/lifepod
	name = "\improper NT-31B lifepod"
	desc = "A barebones lifepod with subdimensional particle sails. It has shiny NanoTrasen branding, however is probably obselete."
	icon = 'icons/obj/machines/lifepod.dmi'
	icon_state = "lifepod_0"
	density = TRUE
	anchored = FALSE //Lightweight!
	machine_name = "lifepod"
	machine_desc = "An NT-31B model lifepod with licensed Vey-Med stasis technology and a patented oxygen AND nitrogen candle. It utilizes \
	old-school subdimensional particle navigation in combination with a high-velocity launch to violently land at any nearby physical entity. \
	It also has an internal radioisotope thermoelectric generator that produces just enough power to sustain the pod and open its blast door."

	var/const/LIFEPOD_CLOSED = 0 //The lifepod is closed. We count from 1 just to see if DreamChecker stops screaming.
	var/const/LIFEPOD_OPEN = 1 //The lifepod is open.
	var/const/LIFEPOD_LOCKED = 2 //The lifepod has been locked by the passenger.
	var/const/LIFEPOD_BROKEN = 3 //The lifepod was forced open while locked or damaged too much. It is not usable in this state.

	var/hatch = LIFEPOD_CLOSED //Status of the passenger hatch

	var/atom/movable/storedThing //Whatever is occupying the passenger compartment.
	var/timeEntered //The time it entered.
	var/timeRadiated //You think you can just sit next to an RTG and not be mildly green?
	var/maxSize = MOB_MEDIUM //The max size of a mob that can enter.

	var/list/supplies = list(/obj/item/storage/toolbox/emergency, /obj/item/storage/firstaid/stab, /obj/item/pickaxe) //Supplies that can be ejected (spawned).
	var/suppliesEjected = FALSE //Were the supplies already ejected?

	var/obj/machinery/door/blast/launchHatch //The door it gets shot out of.
	var/obj/machinery/mass_driver/launchDriver //The driver it gets shot from.

	var/const/LIFEPOD_READY = 0 //The lifepod is waiting to be launched.
	var/const/LIFEPOD_LAUNCHED = 1 //The lifepod has been launched and is in space.
	var/const/LIFEPOD_LANDED = 2 //The lifepod has landed, somewhere.
	var/const/LIFEPOD_FAILURE = 3 //The lifepod failed to launch due to a mass driver not being present.

	var/launchStatus = LIFEPOD_READY //Did it get launched?

	var/landingAttempts = 0 //How many times has it tried landing already?

	var/obj/effect/overmap/visitable/mothership //If it is in the overmap, it has a mothership.

	var/datum/gas_mixture/airSupply //The air supply for the lifepod.
	var/lastAirWarningTime //When was the last time they got warned about air pressure?

	var/emagBombRig = FALSE //Was it emagged and rigged to explode?
	var/emagEscape //Was it emagged and rigged to automatically go to a designated target?
	var/emagLoop = FALSE //Was it emagged and rigged to return to the original Z?

	var/list/move_sounds = list('sound/effects/metalscrape1.ogg', 'sound/effects/metalscrape2.ogg', 'sound/effects/metalscrape3.ogg') //Funny noises to make when moving.

//This thing talks so much as I might as well give it its own proc to do so efficiently and in a cool way.
/obj/machinery/lifepod/proc/microphone(message, danger = 0, emote)
	if(!emote)
		switch(danger)
			if(0)
				emote = pick("beeps", "buzzes", "blips", "coldly states", "chimes")
			if(1)
				emote = pick("urgently beeps", "loudly buzzes", "violently beeps", "loudly states", "rings")
			if(2)
				emote = pick("blares", "earsplittingly blips", "coldly screams")

	switch(danger)
		if(0)
			return visible_message(SPAN_NOTICE("\The <b>[src]</b> [emote], \"[message]\""))
		if(1)
			return visible_message(SPAN_WARNING("\The <b>[src]</b> [emote], \"[message]\""))
		if(2)
			return visible_message(SPAN_DANGER("\The <b>[src]</b> [emote], \"[message]\""))

/obj/machinery/lifepod/proc/linkLaunchSystems() //This can actually be done with a multitool ingame.
	launchDriver = locate(/obj/machinery/mass_driver) in loc //Get the mass driver
	if(!launchDriver) //If there is no mass driver, don't bother.
		microphone("Unable to connect to external launch systems.", 1)
		return FALSE
	var/turf/hatchTurf = get_step(launchDriver, launchDriver.dir)
	launchHatch = locate(/obj/machinery/door/blast) in hatchTurf
	return TRUE

/obj/machinery/lifepod/proc/processOccupant()
	var/mob/living/carbon/passenger = storedThing
	if(powered())
		var/stasisPower = round((world.time-timeEntered)*0.05) //Slowly increase.

		if(stasisPower)
			passenger.SetStasis(stasisPower)

		if(world.time - timeRadiated >= 10 MINUTES) //Very slow radiation poisoning.
			passenger.apply_radiation(1)
			microphone("Minor generator-sourced radiation emission detected.", 1)
			timeRadiated = world.time //Reset time.

	if(airSupply && airSupply.return_pressure() < ONE_ATMOSPHERE * 0.8 && (world.time - lastAirWarningTime) >= 1 MINUTE) //Scream at them that they have low air.
		microphone("LOW AIR LEVELS DETECTED!", 1)
		lastAirWarningTime = world.time
		if(airSupply.return_pressure() < ONE_ATMOSPHERE * 0.75 && !istype(loc, /turf/space)) //Toggle environmental succ, pray person knows what they're doing.
			microphone("HAZARDOUS AIR LEVELS DETECTED! TOGGLING EXTERNAL VENTS! BRACE FOR ENVIRONMENTAL EXPOSURE!", 2)
			sleep(5)
			airSupply = null
			qdel(airSupply) //We won't be needing this anymore. Single usage because this is an emergency thing.

/obj/machinery/lifepod/proc/enterLifepod(atom/movable/thing)
	if(ismob(thing))
		var/mob/mobThing = thing

		if(mobThing.client)
			mobThing.client.perspective = EYE_PERSPECTIVE
			mobThing.client.eye = src

		add_fingerprint(mobThing)

	thing.forceMove(src)
	storedThing = thing

	visible_message(SPAN_NOTICE("\The <b>[src]</b> starts up and whirrs as it is closed."))
	timeEntered = world.time
	hatch = LIFEPOD_CLOSED
	update_icon()

/obj/machinery/lifepod/proc/exitLifepod()
	if(ismob(storedThing)) 	//Reset their sight and such.
		var/mob/mobThing = storedThing

		if(mobThing.client)
			mobThing.client.perspective = mobThing.client.mob
			mobThing.client.eye = MOB_PERSPECTIVE

	storedThing.dropInto(loc) //Physically throw them back into the world.
	storedThing = null //Now nothing is inside.

/obj/machinery/lifepod/proc/attemptExit(mob/user)
	var/voluntary = FALSE
	if(!user) //Assume people take themselves out of the lifepod if not told otherwise.
		user = storedThing
	if(storedThing == user)
		voluntary = TRUE

	switch(hatch)
		if(LIFEPOD_LOCKED) //Fail if locked.
			storedThing.visible_message(
				SPAN_WARNING("[voluntary ? "Something pushes the bolted hatch from the inside" : "\The [user] pulls on the bolted hatch"] of \the [src] to no avail."),
				SPAN_WARNING("You can't open the hatch of \the [src]. Try unlocking or breaking it.")
			)
			return

		if(LIFEPOD_CLOSED) //Open if closed.
			storedThing.visible_message(
				SPAN_NOTICE("\The [user] opens the hatch of \the [src]."),
				SPAN_NOTICE("You open the hatch of \the [src].")
			)
			hatch = LIFEPOD_OPEN
			update_icon()

	exitLifepod()

/obj/machinery/lifepod/proc/attemptEnter(atom/movable/target, mob/user)
	if(!ismovable(target) || target.anchored) return //No more ladders in lifepods.

	add_fingerprint(user)
	var/voluntary = FALSE
	if(!user) //Assume people put themselves in the lifepod if not told otherwise.
		user = target
	if(target == user)
		voluntary = TRUE

	switch(hatch)
		if(LIFEPOD_LOCKED) //The hatch is locked from the inside.
			to_chat(user, SPAN_WARNING("\The [src]'s hatch is locked and cannot be opened."))
			return

		if(LIFEPOD_BROKEN) //Broken hatches are unusuable.
			to_chat(user, SPAN_WARNING("\The [src]'s hatch is broken, rendering it useless."))
			return

		if(LIFEPOD_CLOSED) //Gotta open the hatch.
			if(user.IsAdvancedToolUser())
				user.visible_message(
					SPAN_NOTICE("\The [user] opens the hatch of \the [src]."),
					SPAN_NOTICE("You open the hatch of \the [src].")
				)
				hatch = LIFEPOD_OPEN //Open the hatch.
				update_icon()
			else
				to_chat(user, SPAN_WARNING("You can't operate the hatch."))
				return

	if(storedThing) //Can't replace something already in there. Eject it instead. Keep the hatch open though, of course.
		to_chat(user, SPAN_WARNING("\The [storedThing] is already occupying \the [src]."))

	if(ismob(target))
		var/mob/mobTarget = target
		if(mobTarget.mob_size > maxSize) //Too big.
			to_chat(user, SPAN_WARNING("[voluntary ? "You are" : "\The [mobTarget] is"] too big to fit in \the [src].")) //I LOVE EMBEDDED EXPRESSIONS
			return

	user.visible_message(
		SPAN_NOTICE("\The [user] attempts to put [voluntary ? "themself" : "\the [target]"] in \the [src]."),
		SPAN_NOTICE("You attempt to put [voluntary ? "yourself" : "\the [target]"] in \the [src].")
	)
	if(do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE))
		enterLifepod(target)

/obj/machinery/lifepod/proc/launch()
	if(!launchDriver) //Fail if there's nothing to throw it.
		launchStatus = LIFEPOD_FAILURE
		microphone("MASS DRIVER NOT DETECTED, ATTEMPTING LAUNCH SYSTEM SEARCH!", 2) //Try one more time

		if(!linkLaunchSystems()) //Try one more time to link launch systems, don't be too cruel.
			microphone("UNABLE TO FIND MASS DRIVER! LAUNCH SYSTEM FAILURE!", 2)
			return

	if(launchHatch && launchHatch.density) //Start by opening the launch hatch.
		microphone("OPENING BLAST DOOR! ANCHORING MAGNETS POWERED!", 1)
		anchored = TRUE //temporarily anchor us to account for atmos
		launchHatch.force_open()
		sleep(5)
		microphone("Anchoring magnets disabled.", 0)
		anchored = FALSE //Get ready to get thrown.
		sleep(5)

	microphone("MASS DRIVER ACTIVE! BRACE FOR LAUNCH!", 1) //IT'S HAPPENING.
	launchStatus = LIFEPOD_LAUNCHED //Even is the mass driver isn't powered, pretend you still launched.
	launchDriver.delayed_drive() //IT HAPPENED.

/obj/machinery/lifepod/proc/escape() //Send them to an escape level if nothing else.
	if(emagEscape) //Teleport them to antag heaven beach area
		var/obj/effect/landmark/escapePlace = pick(endgame_safespawns)
		forceMove(escapePlace.loc)
		//Since they are stuck in the beach, supposedly, tell them they can ghost.
		to_chat(storedThing, FONT_LARGE(SPAN_COLOR("red", "With the addition of programmed bias to the lifepod's particle sails from your hacking, you have escaped to your intended destination. You may ghost and be counted as escaped.")))
	else //Teleport them to space-escape area.
		forceMove(locate(rand(TRANSITIONEDGE, world.maxx-TRANSITIONEDGE), rand(TRANSITIONEDGE, world.maxy-TRANSITIONEDGE),  pick(GLOB.using_map.escape_levels)))
		//Since they are stuck in baby jail, tell them that they can ghost.
		to_chat(storedThing, FONT_LARGE(SPAN_NOTICE("Your lifepod has navigated itself to the designated rescue sector. You may ghost and be counted as escaped.")))

/*.

1. If it is landed, it will not try to land.
2. If it is on the overmap, it will try to land on an away site or exoplanet.
3. If it cannot find a suitable turf on said site, it will continue with regular border-looping travel.

*/

/obj/machinery/lifepod/touch_map_edge() //THERE IS A MAP BORDER PROC HOLY HELL.
	landingAttempts++

	if(landingAttempts >= 4)
		escape() //Escape if you really can't find anywhere and don't end up back home.

	if(emagEscape)
		escape()

	if(launchStatus == LIFEPOD_LANDED) //If you're not in space, don't try to land.
		return ..()

	var/list/possibleSites = list() //All the possible places they could land.

	if(mothership) //I hope this would be used only in overmap-compatible maps, because outside of that there will be limited viablity.
		for(var/obj/effect/overmap/visitable/nearPlace in range(mothership, 5))
			if(nearPlace == mothership)
				continue
			else if(nearPlace.in_space || istype(nearPlace, /obj/effect/overmap/visitable/sector/exoplanet))
				possibleSites += nearPlace
	else
		escape() //Go to escape-z if there is no overmap.

	var/newZ //The Z-level they are getting sent to.

	if(emagLoop)
		newZ = z //RETURN TO SENDER

	if(possibleSites.len) //If there are locations, pick one.
		var/obj/effect/overmap/visitable/targetSite = pick(possibleSites)
		newZ = pick(targetSite.map_z) //Fetch actual Z-level
	else
		..() //Border-roam if there are no nearby Zs.

	var/turf/landingTurf //The target turf that the lifepod will move to.
	var/cycles = 1000

	//Shoutout to Mothblocks for showing me this. It actually seems pretty obvious but over-complication is over-complication.
	for(var/cycle in 1 to cycles)
		var/checkX = rand(TRANSITIONEDGE, world.maxx-TRANSITIONEDGE)
		var/checkY = rand(TRANSITIONEDGE, world.maxy-TRANSITIONEDGE)

		var/checkTurf = locate(checkX, checkY, newZ)

		if(istype(checkTurf, /turf/simulated/floor) || istype(checkTurf, /turf/simulated/wall))
			landingTurf = checkTurf
			break

	if(landingTurf)
		microphone("DIRECT SUBDIMENSIONAL PARTICLE ALIGNMENT CONFIRMED! IMPACT SOON!", 2) //Warn them.

		if(istype(landingTurf, /turf/simulated/wall))
			new /obj/effect/landmark/clear(landingTurf) //Dismantle wall if available.

		new /obj/effect/landmark/scorcher(landingTurf)
		explosion(landingTurf, 6)

		forceMove(landingTurf) //Just get them there.
		playsound(loc,'sound/effects/meteorimpact.ogg', 100)
		launchStatus = LIFEPOD_LANDED
		anchored = TRUE
	else
		..() //Let them continue to float if this somehow occurs.

/obj/machinery/lifepod/verb/ejectSupplies() //Spawn your supplies!
	set name = "Eject emergency supplies"
	set category = "Lifepod"
	set src in oview(1)

	usr.visible_message(
		SPAN_WARNING("\The [usr] pulls \the [src]'s [usr == storedThing ? "internal" : "external"] emergency supply hatch ejection cord."),
		SPAN_NOTICE("You pull \the [src]'s [usr == storedThing ? "internal" : "external"] emergency supply hatch ejection cord.")
	)

	if(do_after(usr, 1 SECONDS, src, DO_PUBLIC_UNIQUE) && usr.IsAdvancedToolUser() && !suppliesEjected)
		visible_message(SPAN_DANGER("The ejection piston fires and shoots the supplies out!"))
		for(var/supply in supplies) //Can be defined up above in the supplies list
			var/obj/item/object = new supply(loc) //Actually spawn the supplies
			object.throw_at(usr, 2, 3) //Throw them at them for comedic purposes.
		suppliesEjected = TRUE
	else
		to_chat(usr, SPAN_WARNING("\The [src]'s ejection cord does nothing.")) //Don't actually tell them it's empty until they pull it.

/obj/machinery/lifepod/verb/lockHatch()
	set name = "Toggle lock"
	set category = "Lifepod"
	set src in range(0)

	switch(hatch)
		if(LIFEPOD_LOCKED)
			hatch = LIFEPOD_CLOSED
			to_chat(storedThing, SPAN_NOTICE("You unlock \the [src]."))
			playsound(loc,'sound/machines/BoltsDown.ogg', 50) //Using old door noises for nostalgia points.
		if(LIFEPOD_CLOSED)
			hatch = LIFEPOD_LOCKED
			to_chat(storedThing, SPAN_NOTICE("You lock \the [src]."))
			playsound(loc,'sound/machines/BoltsUp.ogg', 50) //Using old door noises for nostalgia points.

	update_icon()

/obj/machinery/lifepod/Initialize(populate_parts = TRUE)
	. = ..()

	//Generate the air supply
	airSupply = new()
	airSupply.temperature = T0C
	airSupply.adjust_gas(GAS_OXYGEN, MOLES_O2STANDARD, 0)
	airSupply.adjust_gas(GAS_NITROGEN, MOLES_N2STANDARD)

	linkLaunchSystems() //Remember to put these in a properly mapped area, but there is a contigency (manual multitooling or lenient checking before launch) if they don't.

	if(GLOB.using_map.use_overmap) //I hope this would be used only in overmap-compatible maps, because outside of that there will be limited viablity.
		mothership = map_sectors["[z]"]
/obj/machinery/lifepod/update_icon()
	icon_state = "lifepod_[hatch]" //Open or close the hatch appropiately.

/* The order of the examine() goes:
Hatch appearance.
Launch status.
Supplies ejected.
Launch systems light.
Lock light.
*/

/obj/machinery/lifepod/examine(mob/user)
	. = ..()

	//Hatch status.
	switch(hatch)
		if(LIFEPOD_OPEN)
			if(storedThing && user.Adjacent(src)) //You'd also need to be close to see it.
				to_chat(user, SPAN_NOTICE("\The [storedThing] is inside the passenger compartment."))

		if(LIFEPOD_CLOSED, LIFEPOD_LOCKED)
			if(storedThing && user.Adjacent(src)) //You'd ALSO need to be close to see it.
				to_chat(user, SPAN_WARNING("Something is inside the passenger compartment."))

		if(LIFEPOD_BROKEN) //Tell them it is broken.
			to_chat(user, SPAN_WARNING("The hatch is broken, rendering \the [src] inoperable."))

	//Other things to notice.
	if(landingAttempts > 0) //Show any signs of landing attempts.
		to_chat(user, SPAN_WARNING("There are significant wear marks on the sails.")) //Trying to not be obvious.
	if(suppliesEjected) //Someone already spawned supplies.
		to_chat(user, SPAN_WARNING("The emergency supplies have been ejected.")) //Indicate it's already looted.

	//Lights. Can be visually added later.
	if(launchDriver && user.Adjacent(src)) //You'd need to be close to see it.
		to_chat(user, SPAN_NOTICE("The 'EXT-LAUNCH-SYS CONNECTION' light is flickering.")) //Don't pull the launch lever unless you want to vent something.
	if(hatch == LIFEPOD_LOCKED)
		to_chat(user, SPAN_NOTICE("The 'MANUAL BOLT' light is flickering."))

/obj/machinery/lifepod/Process()
	if(storedThing && iscarbon(storedThing) && launchStatus >= LIFEPOD_LAUNCHED && launchStatus != LIFEPOD_FAILURE)
		processOccupant()

/obj/machinery/lifepod/return_air()
	if(airSupply && (hatch == LIFEPOD_CLOSED || LIFEPOD_LOCKED))
		return airSupply //Return
	else
		return loc.return_air()

/obj/machinery/lifepod/MouseDrop_T(atom/movable/target, mob/user) //Throwing them in.
	attemptEnter(target, user)

/obj/machinery/lifepod/physical_attack_hand(mob/user)
	if(user == storedThing) //If you are inside, get out.
		attemptExit()
		return

	switch(hatch)
		if(LIFEPOD_LOCKED) //The hatch is locked from the inside.
			to_chat(user, SPAN_WARNING("\The [src]'s hatch is locked and cannot be opened."))
			return

		if(LIFEPOD_CLOSED) //Opening the hatch.
			if(user.IsAdvancedToolUser())
				user.visible_message(
					SPAN_NOTICE("\The [user] opens the hatch of \the [src]."),
					SPAN_NOTICE("You open the hatch of \the [src].")
				)
				hatch = LIFEPOD_OPEN //Open the hatch.
				update_icon()
			else
				to_chat(user, SPAN_WARNING("You can't operate the hatch."))
				return

		if(LIFEPOD_OPEN) //Closing the hatch.
			if(user.IsAdvancedToolUser())
				user.visible_message(
					SPAN_NOTICE("\The [user] closes the hatch of \the [src]."),
					SPAN_NOTICE("You closes the hatch of \the [src].")
				)
				hatch = LIFEPOD_CLOSED
				update_icon()
			else
				to_chat(user, SPAN_WARNING("You can't operate the hatch."))
				return

/obj/machinery/lifepod/is_powered()
	return TRUE //No matter what, it's powered. God could smite it, it's still powered.

//Stolen from mass driver slugs.
/obj/machinery/lifepod/Move()
	. = ..()
	if(.)
		var/turf/T = get_turf(src)
		if(!isspace(T) && !istype(T, /turf/simulated/floor/carpet))
			playsound(T, pick(move_sounds), 75, 1)