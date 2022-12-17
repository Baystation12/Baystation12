#define HATCH_CLOSED		0 //The hatch to the passenger compartment is closed.
#define HATCH_OPEN			1 //The hatch is opened.
#define HATCH_LOCKED		2 //The hatch has been locked by the passenger.
#define HATCH_BROKEN		3 //The hatch was forced open while locked and has been broken, or has been damaged too much.

#define READY 		0 //Lifepod onboard.
#define LAUNCHED	1 //Lifepod in space.
#define LANDED		2 //Lifepod landed. Can only occur after LAUNCHED.
#define FAILURE		3 //Occurs if the lifepod has no mass driver.

#define PODEDGE	TRANSITIONEDGE + 20 //Leave before the border.

/*

For too long, the escape pod debate has plagued us all. Shuttle-based pods are stupid but nobody has successfully implemented object pods.

There is a solution in the ancient ways, they just had these really weird looking pods. This is that reinvented, after the lifepod (unintentionally?) reinvented it.

I know no God but camel case.

~10sc

*/

/obj/machinery/lifepod
	name = "\improper NT-31B lifepod"
	desc = "A barebones lifepod with subdimensional particle sails. It has shiny NanoTrasen branding, however is probably obselete."
	icon = 'icons/obj/machines/lifepod.dmi'
	icon_state = "lifepod_0"
	density = TRUE
	anchored = FALSE //Lightweight!
	machine_name = "lifepod"
	machine_desc = "An NT-31B model lifepod with licensed Vey-Med stasis technology and a patented oxygen AND nitrogen candle. It utilizes \
	old-school subdimensional particle navigation in combination with high-velocity launch to violently land at any nearby physical entity. \
	It also has an internal radioisotope thermoelectric generator that produces just enough power to sustain the pod and open its blast door."
	construct_state = /singleton/machine_construction/default/panel_closed
	uncreated_component_parts = null
	power_channel = EQUIP
	active_power_usage = 100 //Power keeps stasis on, nothing else.


	var/atom/movable/storedThing //Whatever is occupying the passenger compartment.
	var/timeEntered //The time it entered.
	var/maxSize = MOB_MEDIUM //The max size of a mob that can enter.
	var/hatch = HATCH_CLOSED //Status of the passenger hatch

	var/list/supplies = list(/obj/item/storage/toolbox/emergency, /obj/item/storage/firstaid/stab) //Supplies that can be ejected (spawned).
	var/suppliesEjected = FALSE //Were the supplies already ejected?

	var/obj/machinery/door/blast/launchHatch //The door it gets shot out of.
	var/obj/machinery/mass_driver/launchDriver //The driver it gets shot from.
	var/launched = READY //Did it get launched?

	var/datum/gas_mixture/airSupply //The air supply for the lifepod.
	var/lowAirWarning = FALSE //Have they been warned?

/obj/machinery/lifepod/proc/linkLaunchSystems() //This can actually be done with a multitool ingame.
	launchDriver = locate(/obj/machinery/mass_driver) in loc //Get the mass driver
	if(!launchDriver) //If there is no mass driver, don't bother.
		visible_message(SPAN_WARNING("\The <b>[src]</b> beeps, \"Unable to connect to external launch systems.\""))
		return
	var/turf/hatchTurf = get_step(launchDriver, launchDriver.dir)
	launchHatch = locate(/obj/machinery/door/blast) in hatchTurf

/obj/machinery/lifepod/proc/processOccupant()
	var/mob/living/carbon/passenger = storedThing
	if(powered())
		var/stasisPower = min((world.time - timeEntered) * 0.01, 2) //Slowly increasing stasis
		passenger.SetStasis(stasisPower)

	if(airSupply && !lowAirWarning && airSupply.return_pressure() < ONE_ATMOSPHERE * 0.8) //Scream at them that they have low air.
		visible_message(SPAN_NOTICE("\The <b>[src]</b> blares, \"LOW AIR LEVELS DETECTED!\""))
		lowAirWarning = TRUE
		if(airSupply.return_pressure() < ONE_ATMOSPHERE * 0.75) //Toggle environmental succ, pray person knows what they're doing.
			visible_message(SPAN_NOTICE("\The <b>[src]</b> blares, \"HAZARDOUS AIR LEVELS DETECTED! TOGGLING EXTERNAL VENTS! BRACE FOR ENVIRONMENTAL EXPOSURE!\""))
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

	visible_message(SPAN_NOTICE("\The <b>[src]</b> starts up and whirrs as its passenger hatch is closed."))
	update_use_power(POWER_USE_ACTIVE)
	timeEntered = world.time
	hatch = HATCH_CLOSED
	update_icon()

/obj/machinery/lifepod/proc/exitLifepod()
	//Open the hatch if closed.
	switch(hatch)
		if(HATCH_LOCKED)
			storedThing.visible_message(
				SPAN_NOTICE("\The [storedThing] pushes the bolted hatch of \the [src] to no avail."),
				SPAN_NOTICE("You can't open the hatch of \the [src]. Try unlocking or breaking it.")
			)
			return

		if(HATCH_CLOSED)
			storedThing.visible_message(
				SPAN_NOTICE("\The [storedThing] opens the hatch of \the [src]."),
				SPAN_NOTICE("You open the hatch of \the [src].")
			)
			hatch = HATCH_OPEN
			update_icon()

	//Reset their sight and such.
	if(ismob(storedThing))
		var/mob/mobThing = storedThing

		if(mobThing.client)
			mobThing.client.perspective = mobThing.client.mob
			mobThing.client.eye = EYE_PERSPECTIVE

	storedThing.dropInto(loc) //Physically throw them back into the world.
	storedThing = null //Now nothing is inside.

/obj/machinery/lifepod/proc/attemptEnter(atom/movable/target, mob/user)
	if(target.anchored) return //No more ladders in lifepods.

	add_fingerprint(user)
	var/voluntary = FALSE
	if(!user) //Assume people put themselves in the lifepod if not told otherwise
		user = target
	if(target == user)
		voluntary = TRUE

	switch(hatch)
		if(HATCH_LOCKED) //The hatch is locked from the inside.
			to_chat(user, SPAN_WARNING("\The [src]'s hatch is locked and cannot be opened."))
			return

		if(HATCH_BROKEN) //Broken hatches are unusuable.
			to_chat(user, SPAN_WARNING("\The [src]'s hatch is broken, rendering the lifepod useless."))
			return

		if(HATCH_CLOSED) //Gotta open the hatch.
			if(user.IsAdvancedToolUser())
				user.visible_message(
					SPAN_NOTICE("\The [user] opens the hatch of \the [src]."),
					SPAN_NOTICE("You open the hatch of \the [src].")
				)
				hatch = HATCH_OPEN //Open the hatch.
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
		launched = FAILURE
		visible_message(SPAN_WARNING("\The <b>[src]</b> blares, \"MASS DRIVER NOT DETECTED, LAUNCH FAILURE!\""))
		return

	if(launchHatch && launchHatch.density) //Start by opening the launch hatch.
		visible_message(SPAN_NOTICE("\The <b>[src]</b> blares, \"OPENING BLAST DOOR!\""))
		sleep(5)
		launchHatch.force_open()

	visible_message(SPAN_NOTICE("\The <b>[src]</b> blares, \"MASS DRIVER ACTIVE! BRACE FOR LAUNCH!\"")) //IT'S HAPPENING.
	launched = LAUNCHED
	launchDriver.delayed_drive() //IT HAPPENED.


/obj/machinery/lifepod/proc/launchProcess() //For checking the turf and landing
	if(!istype(loc, /turf/space)) //If you're not in space, stop running.
		return

	if(y <= PODEDGE || y >= world.maxy-PODEDGE || x <= PODEDGE || x <= world.maxx-PODEDGE) //... manually of course.

		var/list/possibleSites = list()
		if(GLOB.using_map.use_overmap)
			var/obj/effect/overmap/visitable/mothership = map_sectors["[z]"]
			for(var/obj/effect/overmap/visitable/nearPlace in range(mothership, 2))
				if(nearPlace.in_space || istype(nearPlace, /obj/effect/overmap/visitable/sector/exoplanet) && nearPlace != mothership)
					possibleSites += nearPlace

		var/newZ = null //Set as null because we will sacrifice them to the border if there are no available Zs.

		if(possibleSites.len) //If there are no locations
			var/obj/effect/overmap/visitable/targetSite = pick(possibleSites)
			newZ = pick(targetSite.map_z && prob(40))
		else
			return

		visible_message(SPAN_WARNING("\The <b>[src]</b> blares, \"SUBDIMENSIONAL PARTICLE ALIGNMENT CONFIRMED! IMPACT SOON!\"")) //Warn them.

		var/turf/landingTurf = locate(/turf/simulated/floor) in newZ

		if(!landingTurf)
			var/turf/emergencyTurf = locate(/turf) in newZ
			forceMove(emergencyTurf) //Actually get them to their original destination.
			throw_at(get_step(src, 1), 50, 1) //Sploink them into the target turf.
		else
			explosion(landingTurf, 6)
			forceMove(landingTurf) //Just get them there.
			playsound(loc,'sound/effects/meteorimpact.ogg', 100)
			launched = LANDED

	else
		return

/obj/machinery/lifepod/verb/ejectSupplies() //Spawn your supplies!
	set name = "Open lifepod supply hatch"
	set category = "Object"
	set src in oview(1)

	usr.visible_message(
		SPAN_WARNING("\The [usr] pulls \the [src]'s [usr == storedThing ? "internal" : "external"] emergency supply hatch ejection cord."),
		SPAN_NOTICE("You pull \the [src]'s [usr == storedThing ? "internal" : "external"] emergency supply hatch ejection cord.")
	)

	if(do_after(usr, 1 SECONDS, src, DO_PUBLIC_UNIQUE) && usr.IsAdvancedToolUser() && !suppliesEjected)
		visible_message(SPAN_DANGER("The ejection piston fires and shoots the supplies out!"))
		for(var/supply in supplies) //This feels very hacky.
			var/obj/item/object = new supply(loc)
			object.throw_at(usr, 2, 3)
		suppliesEjected = TRUE
	else
		to_chat(usr, SPAN_WARNING("\The [src]'s ejection cord does nothing."))

/obj/machinery/lifepod/Initialize(populate_parts = TRUE)
	. = ..()

	//Generate the air supply
	airSupply = new()
	airSupply.temperature = T0C
	airSupply.adjust_gas(GAS_OXYGEN, MOLES_O2STANDARD, 0)
	airSupply.adjust_gas(GAS_NITROGEN, MOLES_N2STANDARD)

	linkLaunchSystems() //Remember to put these in a properly mapped area, but there is a contigency (manual multitooling) if they don't.

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
		if(HATCH_OPEN)
			if(storedThing && user.Adjacent(src)) //You'd also need to be close to see it.
				to_chat(user, SPAN_NOTICE("\The [storedThing] is inside the passenger compartment."))

		if(HATCH_CLOSED || HATCH_LOCKED)
			if(storedThing && user.Adjacent(src)) //You'd ALSO need to be close to see it.
				to_chat(user, SPAN_WARNING("Something is inside the passenger compartment."))

		if(HATCH_BROKEN)
			to_chat(user, SPAN_WARNING("The hatch is broken, rendering \the [src] inoperable."))

	//Other things to notice.
	if(launched >= LAUNCHED && launched != FAILURE) //It realistically should be impossible should encounter a lifepod while it is LIFEPOD_LAUNCHED, but just in case.
		to_chat(user, SPAN_WARNING("There are significant wear marks on the sails.")) //Trying to not be obvious.
	if(suppliesEjected)
		to_chat(user, SPAN_WARNING("The emergency supplies have been ejected.")) //Indicate it's already looted.

	//Lights. Can be visually added later.
	if((launchHatch || launchDriver) && user.Adjacent(src)) //You'd need to be close to see it.
		to_chat(user, SPAN_NOTICE("The 'EXT-LAUNCH-SYS CONNECTION' light is flickering.")) //Don't pull the launch lever unless you want to vent something.
	if(hatch == HATCH_LOCKED)
		to_chat(user, SPAN_NOTICE("The 'MANUAL BOLT' light is flickering."))

/obj/machinery/lifepod/Process()
	if(launched == LAUNCHED)
		launchProcess()
	if(storedThing && iscarbon(storedThing))
		processOccupant()

/obj/machinery/lifepod/return_air()
	if(airSupply && (hatch == HATCH_CLOSED || HATCH_LOCKED))
		return airSupply //Return
	else
		return loc.return_air()

/obj/machinery/lifepod/MouseDrop_T(atom/movable/target, mob/user)
	attemptEnter(target, user)

/obj/machinery/lifepod/physical_attack_hand(mob/user)
	if(user == storedThing) //If you are inside, get out.
		exitLifepod()
		return

	switch(hatch)
		if(HATCH_LOCKED) //The hatch is locked from the inside.
			to_chat(user, SPAN_WARNING("\The [src]'s hatch is locked and cannot be opened."))
			return

		if(HATCH_CLOSED) //Opening the hatch.
			if(user.IsAdvancedToolUser())
				user.visible_message(
					SPAN_NOTICE("\The [user] opens the hatch of \the [src]."),
					SPAN_NOTICE("You open the hatch of \the [src].")
				)
				hatch = HATCH_OPEN //Open the hatch.
				update_icon()
			else
				to_chat(user, SPAN_WARNING("You can't operate the hatch."))
				return

		if(HATCH_OPEN) //Closing the hatch.
			if(user.IsAdvancedToolUser())
				user.visible_message(
					SPAN_NOTICE("\The [user] closes the hatch of \the [src]."),
					SPAN_NOTICE("You closes the hatch of \the [src].")
				)
				hatch = HATCH_CLOSED
				update_icon()
			else
				to_chat(user, SPAN_WARNING("You can't operate the hatch."))
				return

/obj/machinery/lifepod/is_powered()
	return TRUE //No matter what, it's powered. God could smite it, it's still powered.
