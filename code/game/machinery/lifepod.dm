/// This is used for end-round summaries and pseudo-greentext (escaped versus died).
/proc/escapedViaPod(mob/testCase)
	var/obj/machinery/lifepod/pod

	if(istype(testCase.loc, /obj/machinery/lifepod))
		pod = testCase.loc

		if(pod.landed == TRUE) //Is the lifepod still onboard or did it fail to launch?
			return FALSE //You did not escape because the pod did not launch.
		else
			return TRUE //You did escape because the pod is in space or landed somewhere.

	else
		return FALSE //You did not escape... because you're not in a pod.

/// A lifepod that can be used in lieu of shuttle-based escape pods.
/obj/machinery/lifepod
	name = "\improper NT-31B lifepod"
	desc = "A barebones lifepod with subdimensional particle sails. It has shiny NanoTrasen branding, however is probably obselete."
	icon = 'icons/obj/machines/lifepod.dmi'
	icon_state = "lifepod_0"
	density = TRUE
	anchored = FALSE
	machine_name = "lifepod"
	machine_desc = "An NT-31B model lifepod with licensed Vey-Med stasis technology and a patented oxygen AND nitrogen candle. It utilizes \
	old-school subdimensional particle navigation in combination with a high-velocity launch to violently land at any nearby physical entity. \
	It also has an internal radioisotope thermoelectric generator that produces just enough power to sustain the pod and open its blast door."

	/// The lifepod is closed.
	var/const/LIFEPOD_CLOSED = 0
	/// The lifepod is open.
	var/const/LIFEPOD_OPEN = 1
	/// The lifepod is locked by the passenger.
	var/const/LIFEPOD_LOCKED = 2
	/// The lifepod was forced open while locked or damaged too much. It is not usable in this state.
	var/const/LIFEPOD_BROKEN = 3
	/// The status of the lifepod in terms of the above constants.
	var/hatch = LIFEPOD_CLOSED
	/// The thing occupying the lifepod.
	var/atom/movable/storedThing
	/// The time the above thing entered the lifepod.
	var/timeEntered
	/// The last time it was irradiated. Usually, they are irradiated every 10 minutes.
	var/timeRadiated
	/// The maximum size mob that can fit into the lifepod.
	var/maxSize = MOB_MEDIUM
	/// Supplies that can be spawned one time with a verb.
	var/list/supplies = list(
		/obj/item/storage/toolbox/emergency,
		/obj/item/storage/firstaid/stab,
		/obj/item/pickaxe
	)
	/// Whether or not the supplies listed above were ejected.
	var/suppliesEjected = FALSE
	/// The blast door that the lifepod will open if present and not already open.
	var/obj/machinery/door/blast/launchHatch
	/// The mass driver that will throw the lifepod.
	var/obj/machinery/mass_driver/launchDriver
	/// Whether or not the lifepod has landed.
	var/landed = TRUE
	/// How many attempts the lifepod has made to land.
	var/landingAttempts = 0
	/// If an overmap is present, the site it originated from.
	var/obj/effect/overmap/visitable/mothership
	/// The spawned, nonrenewable air that is used by any occupying mob.
	var/datum/gas_mixture/airSupply
	/// The last time they recieved a warning about low air pressure.
	var/lastAirWarningTime
	/// Whether or not it was emagged with the option of exploding upon launch.
	var/emagBombRig = FALSE
	/// Whether or not it was emagged with the option of going to an escape-z upon launch.
	var/emagEscape = FALSE
	/// Whether or not it was emagged with the option of going back to its original Z before launch.
	var/emagLoop = FALSE
	/// Funny noises it makes while moving.
	var/list/move_sounds = list(
		'sound/effects/metalscrape1.ogg',
		'sound/effects/metalscrape2.ogg',
		'sound/effects/metalscrape3.ogg'
	)
	/// It will speak using mundane emotes and blue text.
	var/const/LIFEPOD_SPEECH_NOTICE = 0
	/// It will speak using mildly serious emotes and red text.
	var/const/LIFEPOD_SPEECH_WARNING = 1
	/// It will practically scream.
	var/const/LIFEPOD_SPEECH_DANGER = 2

/obj/machinery/lifepod/Initialize(populate_parts = TRUE)
	. = ..()

	airSupply = new()
	airSupply.temperature = T0C
	airSupply.adjust_gas(GAS_OXYGEN, MOLES_O2STANDARD, 0)
	airSupply.adjust_gas(GAS_NITROGEN, MOLES_N2STANDARD)

	linkLaunchSystems()

	if(GLOB.using_map.use_overmap)
		mothership = map_sectors["[z]"]

/obj/machinery/lifepod/on_update_icon()
	icon_state = "lifepod_[hatch]"

/obj/machinery/lifepod/examine(mob/user)
	. = ..()

	if(user == storedThing)
		return

	switch(hatch)
		if(LIFEPOD_OPEN)
			if(storedThing && user.Adjacent(src)) //You'd also need to be close to see it.
				to_chat(user, SPAN_NOTICE("\The [storedThing] is inside the passenger compartment."))

		if(LIFEPOD_CLOSED, LIFEPOD_LOCKED)
			if(storedThing && user.Adjacent(src)) //You'd ALSO need to be close to see it.
				to_chat(user, SPAN_WARNING("Something is inside the passenger compartment."))

		if(LIFEPOD_BROKEN)
			to_chat(user, SPAN_WARNING("The hatch is broken, rendering \the [src] inoperable."))

	if(landingAttempts > 0)
		to_chat(user, SPAN_WARNING("There are significant wear marks on the sails.")) //Trying to not be obvious.

/obj/machinery/lifepod/Process()
	if(storedThing && iscarbon(storedThing))
		processOccupant()

/obj/machinery/lifepod/return_air()
	if(airSupply && (hatch == LIFEPOD_CLOSED || LIFEPOD_LOCKED))
		return airSupply //Return
	else
		return loc.return_air()

/obj/machinery/lifepod/is_powered()
	return TRUE //No matter what, it's powered. God could smite it, it's still powered.

/obj/machinery/lifepod/Move()
	. = ..()
	if(.)
		var/turf/T = get_turf(src)
		if(!isspace(T) && !istype(T, /turf/simulated/floor/carpet))
			playsound(T, pick(move_sounds), 75, 1)


/obj/machinery/lifepod/physical_attack_hand(mob/user)
	if(user == storedThing) //If you are inside, get out.
		attemptExit()
		return
	switch(user.a_intent)

		if(I_DISARM)
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
		if(I_HELP)
			ejectSupplies()

/obj/machinery/lifepod/attackby(obj/item/object, mob/user)
	if(istype(object, /obj/item/grab))
		var/obj/item/grab/enteringGrab = object

		if(ismob(enteringGrab.affecting))
			attemptEnter(enteringGrab.affecting, user)
	else
		..()

/obj/machinery/lifepod/MouseDrop_T(atom/movable/target, mob/user) //Throwing them in.
	attemptEnter(target, user)

/// A proc that simplifies the repeated usage of the lifepod talking.
/obj/machinery/lifepod/proc/microphone(message, danger = 0, emote)
	if(!emote)
		switch(danger)
			if(LIFEPOD_SPEECH_NOTICE)
				emote = pick("beeps", "buzzes", "blips", "coldly states", "chimes")
			if(LIFEPOD_SPEECH_WARNING)
				emote = pick("urgently beeps", "loudly buzzes", "violently beeps", "loudly states", "rings")
			if(LIFEPOD_SPEECH_DANGER)
				emote = pick("blares", "earsplittingly blips", "coldly screams")

	switch(danger)
		if(LIFEPOD_SPEECH_NOTICE)
			return visible_message(SPAN_NOTICE("\The <b>[src]</b> [emote], \"[message]\""))
		if(LIFEPOD_SPEECH_WARNING)
			return visible_message(SPAN_WARNING("\The <b>[src]</b> [emote], \"[message]\""))
		if(LIFEPOD_SPEECH_DANGER)
			return visible_message(SPAN_DANGER("\The <b>[src]</b> [emote], \"[message]\""))

/// Fetches a mass driver on the same turf as it, and then fetches a blast door in whatever direction the mass driver is facing.
/obj/machinery/lifepod/proc/linkLaunchSystems()
	launchDriver = locate(/obj/machinery/mass_driver) in loc //Get the mass driver
	if(!launchDriver) //If there is no mass driver, don't bother.
		microphone("Unable to connect to external launch systems.", LIFEPOD_SPEECH_WARNING)
		return FALSE
	var/turf/hatchTurf = get_step(launchDriver, launchDriver.dir)
	launchHatch = locate(/obj/machinery/door/blast) in hatchTurf
	return TRUE

/// Ran during process(), slowly applies increasing stasis and occasional radiation to carbon occupant. Also manages air supply.
/obj/machinery/lifepod/proc/processOccupant()
	var/mob/living/carbon/passenger = storedThing
	if(powered())
		/// 5% of the amount of time they have been in the pod.
		var/stasisPower = round((world.time-timeEntered)*0.05) //Slowly increase.

		if(stasisPower)
			passenger.SetStasis(stasisPower)

		if(world.time - timeRadiated >= 10 MINUTES)
			passenger.apply_radiation(1)
			microphone("Minor generator-sourced radiation emission detected.", LIFEPOD_SPEECH_WARNING)
			timeRadiated = world.time //Reset time.

	if(airSupply && airSupply.return_pressure() < ONE_ATMOSPHERE * 0.8 && (world.time - lastAirWarningTime) >= 1 MINUTE) //Scream at them that they have low air.
		microphone("LOW AIR LEVELS DETECTED!", LIFEPOD_SPEECH_WARNING)
		lastAirWarningTime = world.time
		if(airSupply.return_pressure() < ONE_ATMOSPHERE * 0.75 && !istype(loc, /turf/space)) //Toggle environmental succ, pray person knows what they're doing.
			microphone("HAZARDOUS AIR LEVELS DETECTED! TOGGLING EXTERNAL VENTS! BRACE FOR ENVIRONMENTAL EXPOSURE!", LIFEPOD_SPEECH_DANGER)
			sleep(5)
			airSupply = null
			qdel(airSupply) //We won't be needing this anymore. Single usage because this is an emergency thing.

/// The actual transfer of something into it.
/obj/machinery/lifepod/proc/enterLifepod(atom/movable/thing)
	if(ismob(thing))
		var/mob/mobThing = thing

		if(mobThing.client)
			mobThing.client.perspective = EYE_PERSPECTIVE
			mobThing.client.eye = src

		add_fingerprint(mobThing)

	thing.forceMove(src)
	storedThing = thing

	visible_message(SPAN_NOTICE("\The [src] starts up and whirrs as it is closed."))
	timeEntered = world.time
	hatch = LIFEPOD_CLOSED
	update_icon()

/// Called whenever someone tries to enter it.
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

/// The actual exit of something from it.
/obj/machinery/lifepod/proc/exitLifepod()
	if(ismob(storedThing)) 	//Reset their sight and such.
		var/mob/mobThing = storedThing

		if(mobThing.client)
			mobThing.client.perspective = mobThing.client.mob
			mobThing.client.eye = MOB_PERSPECTIVE

	storedThing.dropInto(loc) //Physically throw them back into the world.
	storedThing = null //Now nothing is inside.

/// Called whenever someone tries to leave it.
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

/// The chain of events for the pod to get thrown.
/obj/machinery/lifepod/proc/launch()
	if(!launchDriver) //Fail if there's nothing to throw it.
		microphone("Mass driver not detected, checking local network...", LIFEPOD_SPEECH_WARNING) //Try one more time
		sleep(5)
		if(!linkLaunchSystems()) //Try one more time to link launch systems, don't be too cruel.
			microphone("Unable to find mass driver! Launch aborted!", LIFEPOD_SPEECH_DANGER)
			return

	if(launchHatch && launchHatch.density) //Start by opening the launch hatch.
		microphone("Opening blast door. Anchoring magnets powered.", LIFEPOD_SPEECH_WARNING)
		anchored = TRUE //temporarily anchor us to account for atmos
		launchHatch.force_open()

		sleep(5)

		microphone("Anchoring magnets disabled. Brace for launch!", LIFEPOD_SPEECH_NOTICE)
		anchored = FALSE
		launchDriver.delayed_drive() //IT HAPPENED.

/// This sends them to a place where they cannot return to the regular map.
/obj/machinery/lifepod/proc/escape()
	if(emagEscape) //Teleport them to antag heaven beach area
		var/obj/effect/landmark/escapePlace = pick(endgame_safespawns)
		forceMove(escapePlace.loc)
		//Since they are stuck in the beach, supposedly, tell them they can ghost.
		to_chat(storedThing, FONT_LARGE(SPAN_COLOR("red", "With the addition of programmed bias to the lifepod's particle sails from your hacking, you have escaped to your intended destination. You may ghost and be counted as escaped.")))
	else //Teleport them to space-escape area.
		forceMove(locate(rand(TRANSITIONEDGE, world.maxx-TRANSITIONEDGE), rand(TRANSITIONEDGE, world.maxy-TRANSITIONEDGE),  pick(GLOB.using_map.escape_levels)))
		//Since they are stuck in baby jail, tell them that they can ghost.
		to_chat(storedThing, FONT_LARGE(SPAN_NOTICE("Your lifepod has navigated itself to the designated rescue sector. You may ghost and be counted as escaped.")))
	landed = TRUE

/obj/machinery/lifepod/touch_map_edge()
	landingAttempts++

	if(landingAttempts >= 4)
		escape() //Escape if you really can't find anywhere and don't end up back home.

	if(emagEscape)
		escape()

	if(landed == TRUE) //If you're not in space, don't try to land.
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
		landed = TRUE
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