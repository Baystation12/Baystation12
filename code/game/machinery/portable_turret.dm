/*		Portable Turrets:
		Constructed from metal, a gun of choice, and a prox sensor.
		This code is slightly more documented than normal, as requested by XSI on IRC.
*/

#define TURRET_PRIORITY_TARGET 2
#define TURRET_SECONDARY_TARGET 1
#define TURRET_NOT_TARGET 0

/obj/machinery/porta_turret
	name = "turret"
	icon = 'icons/obj/machines/turrets.dmi'
	icon_state = "turretCover"
	anchored = TRUE

	density = FALSE
	idle_power_usage = 50		//when inactive, this turret takes up constant 50 Equipment power
	active_power_usage = 300	//when active, this turret takes up constant 300 Equipment power
	power_channel = EQUIP	//drains power from the EQUIPMENT channel

	health_max = 80
	health_min_damage = 5

	var/raised = 0			//if the turret cover is "open" and the turret is raised
	var/raising= 0			//if the turret is currently opening or closing its cover
	var/auto_repair = 0		//if 1 the turret slowly repairs itself.
	var/locked = 1			//if the turret's behaviour control access is locked
	var/controllock = 0		//if the turret responds to control panels

	var/installation = /obj/item/gun/energy/gun		//the type of weapon installed
	var/gun_charge = 0		//the charge of the gun inserted
	var/projectile = null	//holder for bullettype
	var/eprojectile = null	//holder for the shot when emagged
	var/reqpower = 500		//holder for power needed
	var/iconholder = null	//holder for the icon_state. 1 for orange sprite, null for blue.
	var/egun = null			//holder to handle certain guns switching bullettypes

	var/last_fired = 0		//1: if the turret is cooling down from a shot, 0: turret is ready to fire
	var/shot_delay = 15		//1.5 seconds between each shot

	var/check_arrest = 1	//checks if the perp is set to arrest
	var/check_records = 1	//checks if a security record exists at all
	var/check_weapons = 0	//checks if it can shoot people that have a weapon they aren't authorized to have
	var/check_access = 1	//if this is active, the turret shoots everything that does not meet the access requirements
	var/check_anomalies = 1	//checks if it can shoot at unidentified lifeforms
	var/check_synth	 = 0 	//if active, will shoot at anything not an AI or cyborg
	var/ailock = 0 			// AI cannot use this

	var/attacked = 0		//if set to 1, the turret gets pissed off and shoots at people nearby (unless they have sec access!)

	var/enabled = 1				//determines if the turret is on
	var/lethal = 0			//whether in lethal or stun mode
	var/disabled = 0

	var/shot_sound 			//what sound should play when the turret fires
	var/eshot_sound			//what sound should play when the emagged turret fires

	var/datum/effect/spark_spread/spark_system	//the spark system, used for generating... sparks?

	var/wrenching = 0
	var/last_target			//last target fired at, prevents turrets from erratically firing at all valid targets in range

	req_access = list(list(access_security, access_bridge))

/obj/machinery/porta_turret/crescent
	enabled = 0
	ailock = 1
	check_synth	 = 0
	check_access = 1
	check_arrest = 1
	check_records = 1
	check_weapons = 1
	check_anomalies = 1
	req_access = list(access_cent_specops)

/obj/machinery/porta_turret/stationary
	ailock = 1
	lethal = 1
	installation = /obj/item/gun/energy/laser

/obj/machinery/porta_turret/malf_upgrade(mob/living/silicon/ai/user)
	..()
	ailock = 0
	malf_upgraded = 1
	to_chat(user, "\The [src] has been upgraded. It's damage and rate of fire has been increased. Auto-regeneration system has been enabled. Power usage has increased.")
	set_max_health(round(initial(health_max) * 1.5), FALSE)
	shot_delay = round(initial(shot_delay) / 2)
	auto_repair = 1
	change_power_consumption(round(initial(active_power_usage) * 5), POWER_USE_ACTIVE)
	return 1

/obj/machinery/porta_turret/New()
	..()

	//Sets up a spark system
	spark_system = new /datum/effect/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

	setup()

/obj/machinery/porta_turret/Destroy()
	qdel(spark_system)
	spark_system = null
	. = ..()

/obj/machinery/porta_turret/proc/setup()
	var/obj/item/gun/energy/E = installation	//All energy-based weapons are applicable
	//var/obj/item/ammo_casing/shottype = E.projectile_type

	projectile = initial(E.projectile_type)
	eprojectile = projectile
	shot_sound = initial(E.fire_sound)
	eshot_sound = shot_sound

	weapon_setup(installation)

/obj/machinery/porta_turret/proc/weapon_setup(guntype)
	switch(guntype)
		if(/obj/item/gun/energy/laser/practice)
			iconholder = 1
			eprojectile = /obj/item/projectile/beam

//			if(/obj/item/gun/energy/laser/practice/sc_laser)
//				iconholder = 1
//				eprojectile = /obj/item/projectile/beam

		if(/obj/item/gun/energy/retro)
			iconholder = 1

//			if(/obj/item/gun/energy/retro/sc_retro)
//				iconholder = 1

		if(/obj/item/gun/energy/captain)
			iconholder = 1

		if(/obj/item/gun/energy/lasercannon)
			iconholder = 1

		if(/obj/item/gun/energy/taser)
			eprojectile = /obj/item/projectile/beam
			eshot_sound = 'sound/weapons/Laser.ogg'

		if(/obj/item/gun/energy/stunrevolver)
			eprojectile = /obj/item/projectile/beam
			eshot_sound = 'sound/weapons/Laser.ogg'

		if(/obj/item/gun/energy/gun)
			eprojectile = /obj/item/projectile/beam	//If it has, going to kill mode
			eshot_sound = 'sound/weapons/Laser.ogg'
			egun = 1

		if(/obj/item/gun/energy/gun/nuclear)
			eprojectile = /obj/item/projectile/beam	//If it has, going to kill mode
			eshot_sound = 'sound/weapons/Laser.ogg'
			egun = 1

var/global/list/turret_icons

/obj/machinery/porta_turret/on_update_icon()
	if(!turret_icons)
		turret_icons = list()
		turret_icons["open"] = image(icon, "openTurretCover")

	underlays.Cut()
	underlays += turret_icons["open"]

	if(MACHINE_IS_BROKEN(src))
		icon_state = "destroyed_target_prism"
	else if(raised || raising)
		if(powered() && enabled)
			if(iconholder)
				//lasers have a orange icon
				icon_state = "orange_target_prism"
			else
				//almost everything has a blue icon
				icon_state = "target_prism"
		else
			icon_state = "grey_target_prism"
	else
		icon_state = "turretCover"

/obj/machinery/porta_turret/proc/isLocked(mob/user)
	if(ailock && issilicon(user))
		to_chat(user, SPAN_NOTICE("There seems to be a firewall preventing you from accessing this device."))
		return 1

	if(locked && !issilicon(user))
		to_chat(user, SPAN_NOTICE("Access denied."))
		return 1

	return 0

/obj/machinery/porta_turret/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/porta_turret/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1)
	var/data[0]
	data["access"] = !isLocked(user)
	data["locked"] = locked
	data["enabled"] = enabled
	data["is_lethal"] = 1
	data["lethal"] = lethal

	if(data["access"])
		var/settings[0]
		settings[LIST_PRE_INC(settings)] = list("category" = "Neutralize All Non-Synthetics", "setting" = "check_synth", "value" = check_synth)
		settings[LIST_PRE_INC(settings)] = list("category" = "Check Weapon Authorization", "setting" = "check_weapons", "value" = check_weapons)
		settings[LIST_PRE_INC(settings)] = list("category" = "Check Security Records", "setting" = "check_records", "value" = check_records)
		settings[LIST_PRE_INC(settings)] = list("category" = "Check Arrest Status", "setting" = "check_arrest", "value" = check_arrest)
		settings[LIST_PRE_INC(settings)] = list("category" = "Check Access Authorization", "setting" = "check_access", "value" = check_access)
		settings[LIST_PRE_INC(settings)] = list("category" = "Check misc. Lifeforms", "setting" = "check_anomalies", "value" = check_anomalies)
		data["settings"] = settings

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "turret_control.tmpl", "Turret Controls", 500, 300)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/porta_turret/proc/HasController()
	var/area/A = get_area(src)
	return A && length(A.turret_controls) > 0

/obj/machinery/porta_turret/CanUseTopic(mob/user)
	if(HasController())
		to_chat(user, SPAN_NOTICE("Turrets can only be controlled using the assigned turret controller."))
		return STATUS_CLOSE

	if(isLocked(user))
		return STATUS_CLOSE

	if(!anchored)
		to_chat(usr, SPAN_NOTICE("\The [src] has to be secured first!"))
		return STATUS_CLOSE

	return ..()


/obj/machinery/porta_turret/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["command"] && href_list["value"])
		var/value = text2num(href_list["value"])
		if(href_list["command"] == "enable")
			enabled = value
		else if(href_list["command"] == "lethal")
			lethal = value
		else if(href_list["command"] == "check_synth")
			check_synth = value
		else if(href_list["command"] == "check_weapons")
			check_weapons = value
		else if(href_list["command"] == "check_records")
			check_records = value
		else if(href_list["command"] == "check_arrest")
			check_arrest = value
		else if(href_list["command"] == "check_access")
			check_access = value
		else if(href_list["command"] == "check_anomalies")
			check_anomalies = value

		return 1

/obj/machinery/porta_turret/power_change()
	if(powered())
		set_stat(MACHINE_STAT_NOPOWER, FALSE)
		queue_icon_update()
	else
		spawn(rand(0, 15))
			set_stat(MACHINE_STAT_NOPOWER, TRUE)
			queue_icon_update()


/obj/machinery/porta_turret/attackby(obj/item/I, mob/user)
	if(MACHINE_IS_BROKEN(src))
		if(isCrowbar(I))
			//If the turret is destroyed, you can remove it with a crowbar to
			//try and salvage its components
			to_chat(user, SPAN_NOTICE("You begin prying the metal coverings off."))
			if(do_after(user, (I.toolspeed * 2) SECONDS, src, DO_REPAIR_CONSTRUCT))
				if(prob(70))
					to_chat(user, SPAN_NOTICE("You remove the turret and salvage some components."))
					if(installation)
						var/obj/item/gun/energy/Gun = new installation(loc)
						Gun.power_supply.charge = gun_charge
						Gun.update_icon()
					if(prob(50))
						new /obj/item/stack/material/steel(loc, rand(1,4))
					if(prob(50))
						new /obj/item/device/assembly/prox_sensor(loc)
				else
					to_chat(user, SPAN_NOTICE("You remove the turret but did not manage to salvage anything."))
				qdel(src) // qdel
			return TRUE

	else if(isWrench(I))
		if(enabled || raised)
			to_chat(user, SPAN_WARNING("You cannot unsecure an active turret!"))
			return TRUE
		if(wrenching)
			to_chat(user, SPAN_WARNING("Someone is already [anchored ? "un" : ""]securing the turret!"))
			return TRUE
		if(!anchored && isinspace())
			to_chat(user, SPAN_WARNING("Cannot secure turrets in space!"))
			return TRUE

		user.visible_message(
			SPAN_WARNING("\The [user] begins [anchored ? "un" : ""]securing the turret."),
			SPAN_NOTICE("You begin [anchored ? "un" : ""]securing the turret.")
		)

		wrenching = 1
		if(do_after(user, (I.toolspeed * 5) SECONDS, src, DO_REPAIR_CONSTRUCT))
			//This code handles moving the turret around. After all, it's a portable turret!
			if(!anchored)
				playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
				anchored = TRUE
				update_icon()
				to_chat(user, SPAN_NOTICE("You secure the exterior bolts on the turret."))
			else if(anchored)
				playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
				anchored = FALSE
				to_chat(user, SPAN_NOTICE("You unsecure the exterior bolts on the turret."))
				update_icon()
		wrenching = 0
		return TRUE

	else if(istype(I, /obj/item/card/id)||istype(I, /obj/item/modular_computer))
		//Behavior lock/unlock mangement
		if(allowed(user))
			locked = !locked
			to_chat(user, SPAN_NOTICE("Controls are now [locked ? "locked" : "unlocked"]."))
			updateUsrDialog()
		else
			to_chat(user, SPAN_NOTICE("Access denied."))
		return TRUE

	return ..()

/obj/machinery/porta_turret/emag_act(remaining_charges, mob/user)
	if(!emagged)
		//Emagging the turret makes it go bonkers and stun everyone. It also makes
		//the turret shoot much, much faster.
		to_chat(user, SPAN_WARNING("You short out [src]'s threat assessment circuits."))
		visible_message("[src] hums oddly...")
		emagged = TRUE
		iconholder = 1
		controllock = 1
		enabled = 0 //turns off the turret temporarily
		sleep(60) //6 seconds for the traitor to gtfo of the area before the turret decides to ruin his shit
		enabled = 1 //turns it back on. The cover popUp() popDown() are automatically called in process(), no need to define it here
		return 1

/obj/machinery/porta_turret/damage_health(damage, damage_type, damage_flags, severity, skip_can_damage_check)
	if (!raised && !raising)
		damage = damage / 8
	. = ..()

/obj/machinery/porta_turret/post_health_change(health_mod, prior_health, damage_type)
	. = ..()
	if (health_mod < 0)
		if (!emagged && enabled)
			attacked = TRUE
			addtimer(new Callback(src, .proc/timer_attacked), 6 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		if (prob(45))
			spark_system.start()

/obj/machinery/porta_turret/proc/timer_attacked()
	attacked = FALSE

/obj/machinery/porta_turret/bullet_act(obj/item/projectile/Proj)
	var/damage = Proj.get_structure_damage()

	if(!damage)
		return

	. = ..()

/obj/machinery/porta_turret/emp_act(severity)
	if(enabled)
		//if the turret is on, the EMP no matter how severe disables the turret for a while
		//and scrambles its settings, with a slight chance of having an emag effect
		check_arrest = prob(50)
		check_records = prob(50)
		check_weapons = prob(50)
		check_access = prob(20)	// check_access is a pretty big deal, so it's least likely to get turned on
		check_anomalies = prob(50)
		if(prob(5))
			emagged = TRUE

	disabled = 1
	var/power = 4 - severity
	addtimer(new Callback(src,/obj/machinery/porta_turret/proc/enable), rand(60*power,600*power))

	..()

/obj/machinery/porta_turret/proc/enable()
	if(disabled)
		disabled = 0

/obj/machinery/porta_turret/on_death()
	spark_system.start()	//creates some sparks because they look cool
	atom_flags |= ATOM_FLAG_CLIMBABLE // they're now climbable
	..()

/obj/machinery/porta_turret/Process()
	if(inoperable())
		//if the turret has no power or is broken, make the turret pop down if it hasn't already
		popDown()
		return

	if(!enabled)
		//if the turret is off, make it pop down
		popDown()
		return

	var/list/targets = list()			//list of primary targets
	var/list/secondarytargets = list()	//targets that are least important

	for(var/mob/M in mobs_in_view(world.view, src))
		assess_and_assign(M, targets, secondarytargets)

	if(!tryToShootAt(targets))
		if(!tryToShootAt(secondarytargets)) // if no valid targets, go for secondary targets
			popDown() // no valid targets, close the cover

	if(auto_repair && health_damaged())
		use_power_oneoff(20000)
		restore_health(1)

/obj/machinery/porta_turret/proc/assess_and_assign(mob/living/L, list/targets, list/secondarytargets)
	switch(assess_living(L))
		if(TURRET_PRIORITY_TARGET)
			targets += L
		if(TURRET_SECONDARY_TARGET)
			secondarytargets += L

/obj/machinery/porta_turret/proc/assess_living(mob/living/L)
	if(!istype(L))
		return TURRET_NOT_TARGET

	if(L.invisibility >= INVISIBILITY_LEVEL_ONE) // Cannot see him. see_invisible is a mob-var
		return TURRET_NOT_TARGET

	if(!L)
		return TURRET_NOT_TARGET

	if(!emagged && issilicon(L))	// Don't target silica
		return TURRET_NOT_TARGET

	if(L.stat && !emagged)		//if the perp is dead/dying, no need to bother really
		return TURRET_NOT_TARGET	//move onto next potential victim!

	if(get_dist(src, L) > 7)	//if it's too far away, why bother?
		return TURRET_NOT_TARGET

	if(check_trajectory(L, src) != L)	//check if we have true line of sight
		return TURRET_NOT_TARGET

	if(emagged)		// If emagged not even the dead get a rest
		return L.stat ? TURRET_SECONDARY_TARGET : TURRET_PRIORITY_TARGET

	if(lethal && locate(/mob/living/silicon/ai) in get_turf(L))		//don't accidentally kill the AI!
		return TURRET_NOT_TARGET

	if(check_synth)	//If it's set to attack all non-silicons, target them!
		if(L.lying)
			return lethal ? TURRET_SECONDARY_TARGET : TURRET_NOT_TARGET
		return TURRET_PRIORITY_TARGET

	if(iscuffed(L)) // If the target is handcuffed, leave it alone
		return TURRET_NOT_TARGET

	if(isanimal(L) || issmall(L)) // Animals are not so dangerous
		return check_anomalies ? TURRET_SECONDARY_TARGET : TURRET_NOT_TARGET

	if(ishuman(L))	//if the target is a human, analyze threat level
		if(assess_perp(L) < 4)
			return TURRET_NOT_TARGET	//if threat level < 4, keep going

	if(L.lying)		//if the perp is lying down, it's still a target but a less-important target
		return lethal ? TURRET_SECONDARY_TARGET : TURRET_NOT_TARGET

	return TURRET_PRIORITY_TARGET	//if the perp has passed all previous tests, congrats, it is now a "shoot-me!" nominee

/obj/machinery/porta_turret/proc/assess_perp(mob/living/carbon/human/H)
	if(!H || !istype(H))
		return 0

	if(emagged)
		return 10

	return H.assess_perp(src, check_access, check_weapons, check_records, check_arrest)

/obj/machinery/porta_turret/proc/tryToShootAt(list/mob/living/targets)
	if(length(targets) && last_target && (last_target in targets) && target(last_target))
		return 1

	while(length(targets) > 0)
		var/mob/living/M = pick(targets)
		targets -= M
		if(target(M))
			return 1


/obj/machinery/porta_turret/proc/popUp()	//pops the turret up
	if(disabled)
		return
	if(raising || raised)
		return
	if(MACHINE_IS_BROKEN(src))
		return
	set_raised_raising(raised, 1)
	update_icon()

	var/atom/flick_holder = new /atom/movable/porta_turret_cover(loc)
	flick_holder.layer = layer + 0.1
	flick("popup", flick_holder)
	sleep(10)
	qdel(flick_holder)

	set_raised_raising(1, 0)
	update_icon()

/obj/machinery/porta_turret/proc/popDown()	//pops the turret down
	set waitfor = FALSE
	last_target = null
	if(disabled)
		return
	if(raising || !raised)
		return
	if(MACHINE_IS_BROKEN(src))
		return
	set_raised_raising(raised, 1)
	update_icon()

	var/atom/flick_holder = new /atom/movable/porta_turret_cover(loc)
	flick_holder.layer = layer + 0.1
	flick("popdown", flick_holder)
	sleep(10)
	qdel(flick_holder)

	set_raised_raising(0, 0)
	update_icon()

/obj/machinery/porta_turret/proc/set_raised_raising(raised, raising)
	src.raised = raised
	src.raising = raising
	set_density(raised || raising)

/obj/machinery/porta_turret/proc/target(mob/living/target)
	if(disabled)
		return
	if(target)
		last_target = target
		spawn()
			popUp()				//pop the turret up if it's not already up.
		set_dir(get_dir(src, target))	//even if you can't shoot, follow the target
		spawn()
			shootAt(target)
		return 1
	return

/obj/machinery/porta_turret/proc/shootAt(mob/living/target)
	//any emagged turrets will shoot extremely fast! This not only is deadly, but drains a lot power!
	if(!(emagged || attacked))		//if it hasn't been emagged or attacked, it has to obey a cooldown rate
		if(last_fired || !raised)	//prevents rapid-fire shooting, unless it's been emagged
			return
		last_fired = 1
		spawn()
			sleep(shot_delay)
			last_fired = 0

	var/turf/T = get_turf(src)
	var/turf/U = get_turf(target)
	if(!istype(T) || !istype(U))
		return

	if(!raised) //the turret has to be raised in order to fire - makes sense, right?
		return

	update_icon()
	var/obj/item/projectile/A
	if(emagged || lethal)
		A = new eprojectile(loc)
		playsound(loc, eshot_sound, 75, 1)
	else
		A = new projectile(loc)
		playsound(loc, shot_sound, 75, 1)

	// Lethal/emagged turrets use twice the power due to higher energy beams
	// Emagged turrets again use twice as much power due to higher firing rates
	use_power_oneoff(reqpower * (2 * (emagged || lethal)) * (2 * emagged))

	//Turrets aim for the center of mass by default.
	//If the target is grabbing someone then the turret smartly aims for extremities
	var/def_zone = get_exposed_defense_zone(target)
	//Shooting Code:
	A.launch(target, def_zone)

/datum/turret_checks
	var/enabled
	var/lethal
	var/check_synth
	var/check_access
	var/check_records
	var/check_arrest
	var/check_weapons
	var/check_anomalies
	var/ailock

/obj/machinery/porta_turret/proc/setState(datum/turret_checks/TC)
	if(controllock)
		return
	src.enabled = TC.enabled
	src.lethal = TC.lethal
	src.iconholder = TC.lethal

	check_synth = TC.check_synth
	check_access = TC.check_access
	check_records = TC.check_records
	check_arrest = TC.check_arrest
	check_weapons = TC.check_weapons
	check_anomalies = TC.check_anomalies
	ailock = TC.ailock

	src.power_change()

/*
		Portable turret constructions
		Known as "turret frame"s
*/

/obj/machinery/porta_turret_construct
	name = "turret frame"
	icon = 'icons/obj/machines/turrets.dmi'
	icon_state = "turret_frame"
	density = TRUE
	var/target_type = /obj/machinery/porta_turret	// The type we intend to build
	var/build_step = 0			//the current step in the building process
	var/finish_name="turret"	//the name applied to the product turret
	var/installation = null		//the gun type installed
	var/gun_charge = 0			//the gun charge of the gun type installed


/obj/machinery/porta_turret_construct/attackby(obj/item/I, mob/user)
	//this is a bit unwieldy but self-explanatory
	switch(build_step)
		if(0)	//first step
			if(isWrench(I) && !anchored)
				playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
				to_chat(user, SPAN_NOTICE("You secure the external bolts."))
				anchored = TRUE
				build_step = 1
				return

			else if(isCrowbar(I) && !anchored)
				playsound(loc, 'sound/items/Crowbar.ogg', 75, 1)
				to_chat(user, SPAN_NOTICE("You dismantle the turret construction."))
				new /obj/item/stack/material/steel( loc, 5)
				qdel(src)
				return

		if(1)
			if(istype(I, /obj/item/stack/material) && I.get_material_name() == MATERIAL_STEEL)
				var/obj/item/stack/M = I
				if(M.use(2))
					to_chat(user, SPAN_NOTICE("You add some metal armor to the interior frame."))
					build_step = 2
					icon_state = "turret_frame2"
				else
					to_chat(user, SPAN_WARNING("You need two sheets of metal to continue construction."))
				return

			else if (isWrench(I))
				playsound(loc, 'sound/items/Ratchet.ogg', 75, 1)
				to_chat(user, SPAN_NOTICE("You unfasten the external bolts."))
				anchored = FALSE
				build_step = 0
				return


		if(2)
			if (isWrench(I))
				playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
				to_chat(user, SPAN_NOTICE("You bolt the metal armor into place."))
				build_step = 3
				return

			else if(isWelder(I))
				var/obj/item/weldingtool/WT = I
				if(!WT.can_use(5, user))
					return

				playsound(loc, pick('sound/items/Welder.ogg', 'sound/items/Welder2.ogg'), 50, 1)
				if(do_after(user, (I.toolspeed * 2) SECONDS, src, DO_REPAIR_CONSTRUCT))
					if(!src || !WT.remove_fuel(5, user)) return
					build_step = 1
					to_chat(user, "You remove the turret's interior metal armor.")
					new /obj/item/stack/material/steel( loc, 2)
					return


		if(3)
			if(istype(I, /obj/item/gun/energy)) //the gun installation part

				if(isrobot(user))
					return
				var/obj/item/gun/energy/E = I //typecasts the item to an energy gun
				if(!user.unEquip(I))
					to_chat(user, SPAN_NOTICE("\the [I] is stuck to your hand, you cannot put it in \the [src]"))
					return
				installation = I.type //installation becomes I.type
				gun_charge = E.power_supply.charge //the gun's charge is stored in gun_charge
				to_chat(user, SPAN_NOTICE("You add [I] to the turret."))
				target_type = /obj/machinery/porta_turret

				build_step = 4
				qdel(I) //delete the gun :(
				return

			else if (isWrench(I))
				playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
				to_chat(user, SPAN_NOTICE("You remove the turret's metal armor bolts."))
				build_step = 2
				return

		if(4)
			if(isprox(I))
				build_step = 5
				if(!user.unEquip(I))
					to_chat(user, SPAN_NOTICE("\the [I] is stuck to your hand, you cannot put it in \the [src]"))
					return
				to_chat(user, SPAN_NOTICE("You add the prox sensor to the turret."))
				qdel(I)
				return

			//attack_hand() removes the gun

		if(5)
			if(isScrewdriver(I))
				playsound(loc, 'sound/items/Screwdriver.ogg', 100, 1)
				build_step = 6
				to_chat(user, SPAN_NOTICE("You close the internal access hatch."))
				return

			//attack_hand() removes the prox sensor

		if(6)
			if(istype(I, /obj/item/stack/material) && I.get_material_name() == MATERIAL_STEEL)
				var/obj/item/stack/M = I
				if(M.use(2))
					to_chat(user, SPAN_NOTICE("You add some metal armor to the exterior frame."))
					build_step = 7
				else
					to_chat(user, SPAN_WARNING("You need two sheets of metal to continue construction."))
				return

			else if (isScrewdriver(I))
				playsound(loc, 'sound/items/Screwdriver.ogg', 100, 1)
				build_step = 5
				to_chat(user, SPAN_NOTICE("You open the internal access hatch."))
				return

		if(7)
			if(isWelder(I))
				var/obj/item/weldingtool/WT = I
				if(!WT.can_use(5, user))
					return

				playsound(loc, pick('sound/items/Welder.ogg', 'sound/items/Welder2.ogg'), 50, 1)
				if(do_after(user, (I.toolspeed * 3) SECONDS, src, DO_REPAIR_CONSTRUCT))
					if(!src || !WT.remove_fuel(5, user))
						return
					build_step = 8
					to_chat(user, SPAN_NOTICE("You weld the turret's armor down."))

					//The final step: create a full turret
					var/obj/machinery/porta_turret/Turret = new target_type(loc)
					Turret.SetName(finish_name)
					Turret.installation = installation
					Turret.gun_charge = gun_charge
					Turret.enabled = 0
					Turret.setup()

					qdel(src) // qdel

			else if(isCrowbar(I))
				playsound(loc, 'sound/items/Crowbar.ogg', 75, 1)
				to_chat(user, SPAN_NOTICE("You pry off the turret's exterior armor."))
				new /obj/item/stack/material/steel(loc, 2)
				build_step = 6
				return

	if(istype(I, /obj/item/pen))	//you can rename turrets like bots!
		var/t = sanitizeSafe(input(user, "Enter new turret name", name, finish_name) as text, MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, usr) && loc != usr)
			return

		finish_name = t
		return

	..()


/obj/machinery/porta_turret_construct/attack_hand(mob/user)
	switch(build_step)
		if(4)
			if(!installation)
				return
			build_step = 3

			var/obj/item/gun/energy/Gun = new installation(loc)
			Gun.power_supply.charge = gun_charge
			Gun.update_icon()
			installation = null
			gun_charge = 0
			to_chat(user, SPAN_NOTICE("You remove [Gun] from the turret frame."))

		if(5)
			to_chat(user, SPAN_NOTICE("You remove the prox sensor from the turret frame."))
			new /obj/item/device/assembly/prox_sensor(loc)
			build_step = 4

/obj/machinery/porta_turret_construct/attack_ai()
	return

/atom/movable/porta_turret_cover
	icon = 'icons/obj/machines/turrets.dmi'




#undef TURRET_PRIORITY_TARGET
#undef TURRET_SECONDARY_TARGET
#undef TURRET_NOT_TARGET
