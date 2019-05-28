/*		Portable Turrets:
		Constructed from metal, a gun of choice, and a prox sensor.
		This code is slightly more documented than normal, as requested by XSI on IRC.
*/

#define TURRET_PRIORITY_TARGET 2
#define TURRET_SECONDARY_TARGET 1
#define TURRET_NOT_TARGET 0

#define TURRET_MODE_LASER           list("mode_name" = "laser",         "projectile" = /obj/item/projectile/beam,                   "iconholder" = "red")
#define TURRET_MODE_FAKE            list("mode_name" = "practice",      "projectile" = /obj/item/projectile/beam/practice,          "iconholder" = "red")
#define TURRET_MODE_LASER_SMALL     list("mode_name" = "small_laser",   "projectile" = /obj/item/projectile/beam/smalllaser,        "iconholder" = "red")
#define TURRET_MODE_LASER_MID       list("mode_name" = "medium_laser",  "projectile" = /obj/item/projectile/beam/midlaser,          "iconholder" = "red")
#define TURRET_MODE_LASER_HEAVY     list("mode_name" = "heavy_laser",   "projectile" = /obj/item/projectile/beam/heavylaser,        "iconholder" = "red")
#define TURRET_MODE_XRAY_SMALL      list("mode_name" = "small_xray",    "projectile" = /obj/item/projectile/beam/xray,              "iconholder" = "green")
#define TURRET_MODE_XRAY_MID        list("mode_name" = "medium_xray",   "projectile" = /obj/item/projectile/beam/xray/midlaser,     "iconholder" = "green")
#define TURRET_MODE_LASERTAG(COLOR) list("mode_name" = "lasertag",      "projectile" = /obj/item/projectile/beam/lastertag/##COLOR, "iconholder" = "blue")
#define TURRET_MODE_STUN            list("mode_name" = "stun",          "projectile" = /obj/item/projectile/beam/stun,              "iconholder" = "blue")
#define TURRET_MODE_STUN_HEAVY      list("mode_name" = "heavy_stun",    "projectile" = /obj/item/projectile/beam/stun/heavy,        "iconholder" = "blue")
#define TURRET_MODE_SHOCK           list("mode_name" = "shock",         "projectile" = /obj/item/projectile/beam/stun/shock,        "iconholder" = "yellow")
#define TURRET_MODE_SHOCK_HEAVY     list("mode_name" = "heavy_shock",   "projectile" = /obj/item/projectile/beam/stun/shock/heavy,  "iconholder" = "yellow")

#define TURRET_DELAY_MODIFIER 1.5 // Shot delay multiplier for balance and to make room for emag/malf upgrade speed changes. Value of 1.5 brings eguns used as the default installation to the old default of 15

// The following apply to target checks for if the turret should shoot someone
#define TURRET_CHECK_ARREST 1 //checks if the target is set to arrest
#define TURRET_CHECK_RECORDS 2 //checks if a security record exists at all
#define TURRET_CHECK_WEAPONS 4 //checks if it can shoot people that have a weapon they aren't authorized to have
#define TURRET_CHECK_ACCESS 8 //if this is active, the turret shoots everything that does not meet the access requirements
#define TURRET_CHECK_ANOMALIES 16 //checks if it can shoot at unidentified lifeforms (ie xenos)
#define TURRET_CHECK_SYNTH 32 //if active, will shoot at anything not an AI or cyborg

// The following modifiers apply to both malf upgraded and emagged turrets
#define TURRET_EMAG_HEALTH_MOD 1.5
#define TURRET_EMAG_SHOT_DELAY_MOD 2
#define TURRET_EMAG_POWER_MOD 5

/obj/machinery/porta_turret
	name = "turret"
	icon = 'icons/obj/turrets.dmi'
	icon_state = "turretCover"
	anchored = TRUE

	density = 0
	idle_power_usage = 50		//when inactive, this turret takes up constant 50 Equipment power
	active_power_usage = 300	//when active, this turret takes up constant 300 Equipment power
	power_channel = EQUIP	//drains power from the EQUIPMENT channel

	var/raised = FALSE		//if the turret cover is "open" and the turret is raised
	var/raising = FALSE		//if the turret is currently opening or closing its cover
	var/health = 80			//the turret's health
	var/maxhealth = 80		//turrets maximal health.
	var/auto_repair = FALSE	//if 1 the turret slowly repairs itself.
	var/locked = TRUE		//if the turret's behaviour control access is locked
	var/controllock = FALSE	//if the turret responds to control panels

	var/installation = /obj/item/weapon/gun/energy/gun		//the type of weapon installed
	var/gun_charge = 0		//the charge of the gun inserted
	var/projectile = null	//holder for bullettype
	var/reqpower = 500		//holder for power needed
	var/iconholder = "blue"	//holder for the icon_state.

	var/last_fired = FALSE	//1: if the turret is cooling down from a shot, 0: turret is ready to fire
	var/shot_delay = TURRET_DELAY_MODIFIER * 10	//1.5 seconds between each shot

	var/turret_checks = TURRET_CHECK_ARREST | TURRET_CHECK_RECORDS | TURRET_CHECK_ACCESS | TURRET_CHECK_ANOMALIES // Flags for various targeting checks
	var/ailock = FALSE			// AI cannot use this

	var/attacked = FALSE	//if set to 1, the turret gets pissed off and shoots at people nearby (unless they have sec access!)

	var/enabled = TRUE		//determines if the turret is on
	var/lethal = FALSE		//whether in lethal or stun mode
	var/disabled = FALSE

	var/list/firemodes
	var/sel_mode // Index of the currently selected firemode

	var/shot_sound 			//what sound should play when the turret fires
	var/eshot_sound			//what sound should play when the emagged turret fires

	var/datum/effect/effect/system/spark_spread/spark_system	//the spark system, used for generating... sparks?

	var/wrenching = FALSE
	var/last_target			//last target fired at, prevents turrets from erratically firing at all valid targets in range

/obj/machinery/porta_turret/crescent
	enabled = FALSE
	ailock = TRUE
	turret_checks = TURRET_CHECK_ACCESS | TURRET_CHECK_ARREST | TURRET_CHECK_RECORDS | TURRET_CHECK_WEAPONS | TURRET_CHECK_ANOMALIES

/obj/machinery/porta_turret/crescent/secure
	enabled = TRUE
	turret_checks = TURRET_CHECK_ACCESS | TURRET_CHECK_ARREST | TURRET_CHECK_RECORDS | TURRET_CHECK_WEAPONS | TURRET_CHECK_ANOMALIES | TURRET_CHECK_SYNTH

/obj/machinery/porta_turret/stationary
	ailock = TRUE
	lethal = TRUE
	installation = /obj/item/weapon/gun/energy/laser

/obj/machinery/porta_turret/off
	enabled = FALSE

/obj/machinery/porta_turret/malf_upgrade(var/mob/living/silicon/ai/user)
	..()
	if (malf_upgraded)
		to_chat(user, SPAN_WARNING("[src] has already been upgraded."))
		return FALSE

	if (emagged)
		to_chat(user, SPAN_WARNING("[src] has already been hacked by an outside source."))
		return FALSE

	if (emag_malf_act())
		ailock = FALSE
		malf_upgraded = TRUE
		to_chat(user, SPAN_WARNING("[src] has been upgraded. It's durability and rate of fire has been increased. Auto-regeneration system has been enabled. Power usage has increased. Turret controls have been unlocked for AI use."))
		return TRUE
	else
		to_chat(user, SPAN_WARNING("[src] hack failed. This is probably a bug. Report it to a dev."))
		return FALSE

/obj/machinery/porta_turret/emag_act(var/remaining_charges, var/mob/user)
	if (emagged)
		to_chat(user, SPAN_WARNING("[src] has already been hacked."))
		return FALSE

	if (malf_upgraded)
		to_chat(user, SPAN_WARNING("[src] has some kind of protection system preventing you from hacking it."))
		return FALSE

	to_chat(user, SPAN_WARNING("You short out [src]'s threat assessment and safety circuits, and it shuts down for a short period. You should probably run while you can."))
	emag_malf_act()
	controllock = TRUE
	emagged = TRUE
	enabled = FALSE //turns off the turret temporarily
	sleep(60) //6 seconds for the traitor to gtfo of the area before the turret decides to ruin his shit
	enabled = TRUE //turns it back on. The cover popUp() popDown() are automatically called in process(), no need to define it here

	return TRUE

/obj/machinery/porta_turret/proc/emag_malf_act()
	visible_message("[src] hums oddly...")
	emagged = TRUE
	maxhealth = round(maxhealth * TURRET_EMAG_HEALTH_MOD)
	shot_delay = round(shot_delay / TURRET_EMAG_SHOT_DELAY_MOD)
	auto_repair = TRUE
	change_power_consumption(round(active_power_usage * TURRET_EMAG_POWER_MOD), POWER_USE_ACTIVE)

/obj/machinery/porta_turret/New()
	..()
	req_access = list(list(access_security, access_bridge))

	//Sets up a spark system
	spark_system = new /datum/effect/effect/system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

	setup()

/obj/machinery/porta_turret/crescent/New()
	..()
	req_access = list(access_cent_specops)

/obj/machinery/porta_turret/Destroy()
	qdel(spark_system)
	spark_system = null

	for (var/I in 1 to LAZYLEN(firemodes))
		qdel(firemodes[I])

	. = ..()

/obj/machinery/porta_turret/examine(mob/user)
	. = ..()
	if(. && user.skill_check(SKILL_WEAPONS, SKILL_BASIC))
		if(LAZYLEN(firemodes) && sel_mode != null)
			var/datum/firemode/current_mode = get_firemode()
			to_chat(user, "The turret's fire mode is set to [current_mode.name].")
		else
			to_chat(user, "The turret's fire mode is set to [lethal ? "lethal" : "stun"].")

/obj/machinery/porta_turret/proc/set_firemode(new_firemode = null)
	ASSERT(new_firemode >= 0) // Negative numbers break things.

	if (new_firemode == null)
		new_firemode = get_next_firemode()
	if (!new_firemode || new_firemode > LAZYLEN(firemodes))
		return null

	sel_mode = new_firemode
	var/datum/firemode/new_mode = firemodes[sel_mode]
	new_mode.apply_to(src)
	return new_mode

/obj/machinery/porta_turret/proc/get_next_firemode()
	if (!LAZYLEN(firemodes))
		return null

	var/new_firemode = sel_mode + 1
	if(new_firemode > LAZYLEN(firemodes))
		new_firemode = 1

	return new_firemode

/obj/machinery/porta_turret/proc/get_firemode()
	return LAZYACCESS(firemodes, sel_mode)

/obj/machinery/porta_turret/proc/setup()
	var/obj/item/weapon/gun/energy/E = new installation
	ASSERT(E.can_make_turret == TRUE)

	shot_delay = E.fire_delay * TURRET_DELAY_MODIFIER
	firemodes = E.turret_firemodes
	if (E.turret_name)
		name = "[E.turret_name] [name]"

	if (LAZYLEN(firemodes))
		for(var/i in 1 to firemodes.len)
			var/list/firemode_data = firemodes[i]
			var/obj/item/projectile/beam/P = firemode_data["projectile"]
			firemode_data["shot_sound"] = initial(P.fire_sound)
			firemodes[i] = new /datum/firemode(src, firemode_data)

		if (!set_firemode(sel_mode))
			set_firemode(1)
	else
		projectile = initial(E.projectile_type)
		shot_sound = initial(E.fire_sound)

var/list/turret_icons

/obj/machinery/porta_turret/on_update_icon()
	if(!turret_icons)
		turret_icons = list()
		turret_icons["open"] = image(icon, "openTurretCover")

	underlays.Cut()
	underlays += turret_icons["open"]

	if(stat & BROKEN)
		icon_state = "destroyed_target_prism"
	else if(raised || raising)
		if(powered() && enabled)
			icon_state = "[iconholder]_target_prism"
		else
			icon_state = "grey_target_prism"
	else
		icon_state = "turretCover"

/obj/machinery/porta_turret/proc/isLocked(mob/user)
	if(ailock && issilicon(user))
		to_chat(user, "<span class='notice'>There seems to be a firewall preventing you from accessing this device.</span>")
		return TRUE

	if(locked && !issilicon(user))
		to_chat(user, "<span class='notice'>Access denied.</span>")
		return TRUE

	return FALSE

/obj/machinery/porta_turret/attack_ai(mob/user)
	if(isLocked(user))
		return

	ui_interact(user)

/obj/machinery/porta_turret/attack_hand(mob/user)
	if(isLocked(user))
		return

	ui_interact(user)

/obj/machinery/porta_turret/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	data["access"] = !isLocked(user)
	data["locked"] = locked
	data["enabled"] = enabled
	data["is_lethal"] = 1
	data["lethal"] = lethal

	if(data["access"])
		var/settings[0]
		settings[++settings.len] = list("category" = "Neutralize All Non-Synthetics", "setting" = "check_synth", "value" = !!(turret_checks & TURRET_CHECK_SYNTH))
		settings[++settings.len] = list("category" = "Check Weapon Authorization", "setting" = "check_weapons", "value" = !!(turret_checks & TURRET_CHECK_WEAPONS))
		settings[++settings.len] = list("category" = "Check Security Records", "setting" = "check_records", "value" = !!(turret_checks & TURRET_CHECK_RECORDS))
		settings[++settings.len] = list("category" = "Check Arrest Status", "setting" = "check_arrest", "value" = !!(turret_checks & TURRET_CHECK_ARREST))
		settings[++settings.len] = list("category" = "Check Access Authorization", "setting" = "check_access", "value" = !!(turret_checks & TURRET_CHECK_ACCESS))
		settings[++settings.len] = list("category" = "Check misc. Lifeforms", "setting" = "check_anomalies", "value" = !!(turret_checks & TURRET_CHECK_ANOMALIES))
		data["settings"] = settings

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "turret_control.tmpl", "Turret Controls", 500, 300)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/porta_turret/proc/HasController()
	var/area/A = get_area(src)
	return A && A.turret_controls.len > 0

/obj/machinery/porta_turret/CanUseTopic(var/mob/user)
	if(HasController())
		to_chat(user, "<span class='notice'>Turrets can only be controlled using the assigned turret controller.</span>")
		return STATUS_CLOSE

	if(isLocked(user))
		return STATUS_CLOSE

	if(!anchored)
		to_chat(usr, "<span class='notice'>\The [src] has to be secured first!</span>")
		return STATUS_CLOSE

	return ..()


/obj/machinery/porta_turret/Topic(href, href_list)
	if(..())
		return TRUE

	if(href_list["command"] && href_list["value"])
		var/value = text2num(href_list["value"])
		if(href_list["command"] == "enable")
			enabled = value

		else if(href_list["command"] == "lethal")
			lethal = value

		else if(href_list["command"] == "check_synth")
			if (value)
				turret_checks |= TURRET_CHECK_SYNTH
			else
				turret_checks &= ~TURRET_CHECK_SYNTH

		else if(href_list["command"] == "check_weapons")
			if (value)
				turret_checks |= TURRET_CHECK_WEAPONS
			else
				turret_checks &= ~TURRET_CHECK_WEAPONS

		else if(href_list["command"] == "check_records")
			if (value)
				turret_checks |= TURRET_CHECK_RECORDS
			else
				turret_checks &= ~TURRET_CHECK_RECORDS

		else if(href_list["command"] == "check_arrest")
			if (value)
				turret_checks |= TURRET_CHECK_ARREST
			else
				turret_checks &= ~TURRET_CHECK_ARREST

		else if(href_list["command"] == "check_access")
			if (value)
				turret_checks |= TURRET_CHECK_ACCESS
			else
				turret_checks &= ~TURRET_CHECK_ACCESS

		else if(href_list["command"] == "check_anomalies")
			if (value)
				turret_checks |= TURRET_CHECK_ANOMALIES
			else
				turret_checks &= ~TURRET_CHECK_ANOMALIES

		return TRUE

/obj/machinery/porta_turret/power_change()
	if(powered())
		stat &= ~NOPOWER
		queue_icon_update()
	else
		spawn(rand(0, 15))
			stat |= NOPOWER
			queue_icon_update()


/obj/machinery/porta_turret/attackby(obj/item/I, mob/user)
	if(stat & BROKEN)
		if(isCrowbar(I))
			//If the turret is destroyed, you can remove it with a crowbar to
			//try and salvage its components
			to_chat(user, "<span class='notice'>You begin prying the metal coverings off.</span>")
			if(do_after(user, 20, src))
				if(prob(70))
					to_chat(user, "<span class='notice'>You remove the turret and salvage some components.</span>")
					if(installation)
						var/obj/item/weapon/gun/energy/Gun = new installation(loc)
						Gun.power_supply.charge = gun_charge
						Gun.update_icon()
					if(prob(50))
						new /obj/item/stack/material/steel(loc, rand(1,4))
					if(prob(50))
						new /obj/item/device/assembly/prox_sensor(loc)
				else
					to_chat(user, "<span class='notice'>You remove the turret but did not manage to salvage anything.</span>")
				qdel(src) // qdel

	else if(isWrench(I))
		if(enabled || raised)
			to_chat(user, "<span class='warning'>You cannot unsecure an active turret!</span>")
			return
		if(wrenching)
			to_chat(user, "<span class='warning'>Someone is already [anchored ? "un" : ""]securing the turret!</span>")
			return
		if(!anchored && isinspace())
			to_chat(user, "<span class='warning'>Cannot secure turrets in space!</span>")
			return

		user.visible_message( \
				"<span class='warning'>[user] begins [anchored ? "un" : ""]securing the turret.</span>", \
				"<span class='notice'>You begin [anchored ? "un" : ""]securing the turret.</span>" \
			)

		wrenching = TRUE
		if(do_after(user, 50, src))
			//This code handles moving the turret around. After all, it's a portable turret!
			if(!anchored)
				playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
				anchored = 1
				update_icon()
				to_chat(user, "<span class='notice'>You secure the exterior bolts on the turret.</span>")
			else if(anchored)
				playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
				anchored = 0
				to_chat(user, "<span class='notice'>You unsecure the exterior bolts on the turret.</span>")
				update_icon()
		wrenching = FALSE

	else if(istype(I, /obj/item/weapon/card/id)||istype(I, /obj/item/modular_computer))
		//Behavior lock/unlock mangement
		if(allowed(user))
			locked = !locked
			to_chat(user, "<span class='notice'>Controls are now [locked ? "locked" : "unlocked"].</span>")
			updateUsrDialog()
		else
			to_chat(user, "<span class='notice'>Access denied.</span>")

	else
		//if the turret was attacked with the intention of harming it:
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		take_damage(I.force * 0.5)
		if(I.force * 0.5 > 1) //if the force of impact dealt at least 1 damage, the turret gets pissed off
			if(!attacked && !emagged)
				attacked = TRUE
				spawn()
					sleep(60)
					attacked = FALSE
		..()

/obj/machinery/porta_turret/proc/take_damage(var/force)
	if(!raised && !raising)
		force = force / 8
		if(force < 5)
			return

	health -= force
	if (force > 5 && prob(45))
		spark_system.start()
	if(health <= 0)
		die()	//the death process :(

/obj/machinery/porta_turret/bullet_act(obj/item/projectile/Proj)
	var/damage = Proj.get_structure_damage()

	if(!damage)
		return

	if(enabled)
		if(!attacked && !emagged)
			attacked = TRUE
			spawn()
				sleep(60)
				attacked = FALSE

	..()

	take_damage(damage)

/obj/machinery/porta_turret/emp_act(severity)
	if(enabled)
		//if the turret is on, the EMP no matter how severe disables the turret for a while
		//and scrambles its settings, with a slight chance of having an emag effect
		if (prob(50))
			turret_checks |= TURRET_CHECK_ARREST
		else
			turret_checks &= ~TURRET_CHECK_ARREST

		if (prob(50))
			turret_checks |= TURRET_CHECK_RECORDS
		else
			turret_checks &= ~TURRET_CHECK_RECORDS

		if (prob(50))
			turret_checks |= TURRET_CHECK_WEAPONS
		else
			turret_checks &= ~TURRET_CHECK_WEAPONS

		// check_access is a pretty big deal, so it's least likely to get turned on
		if (prob(20))
			turret_checks |= TURRET_CHECK_ACCESS
		else
			turret_checks &= ~TURRET_CHECK_ACCESS

		if (prob(50))
			turret_checks |= TURRET_CHECK_ANOMALIES
		else
			turret_checks &= ~TURRET_CHECK_ANOMALIES

		if(prob(5))
			emag_malf_act()

		enabled = FALSE
		spawn(rand(60,600))
			if(!enabled)
				enabled = TRUE

	..()

/obj/machinery/porta_turret/ex_act(severity)
	switch (severity)
		if (1)
			qdel(src)
		if (2)
			if (prob(25))
				qdel(src)
			else
				take_damage(initial(health) * 8) //should instakill most turrets
		if (3)
			take_damage(initial(health) * 8 / 3)

/obj/machinery/porta_turret/proc/die()	//called when the turret dies, ie, health <= 0
	health = 0
	set_broken(TRUE)
	spark_system.start()	//creates some sparks because they look cool
	atom_flags |= ATOM_FLAG_CLIMBABLE // they're now climbable

/obj/machinery/porta_turret/Process()
	if(stat & (NOPOWER|BROKEN))
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

	if(auto_repair && (health < maxhealth))
		use_power_oneoff(20000)
		health = min(health+1, maxhealth) // 1HP for 20kJ

/obj/machinery/porta_turret/proc/assess_and_assign(var/mob/living/L, var/list/targets, var/list/secondarytargets)
	switch(assess_living(L))
		if(TURRET_PRIORITY_TARGET)
			targets += L
		if(TURRET_SECONDARY_TARGET)
			secondarytargets += L

/obj/machinery/porta_turret/proc/assess_living(var/mob/living/L)
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

	if(!check_trajectory(L, src))	//check if we have true line of sight
		return TURRET_NOT_TARGET

	if(emagged)		// If emagged not even the dead get a rest
		return L.stat ? TURRET_SECONDARY_TARGET : TURRET_PRIORITY_TARGET

	if(lethal && locate(/mob/living/silicon/ai) in get_turf(L))		//don't accidentally kill the AI!
		return TURRET_NOT_TARGET

	if(turret_checks & TURRET_CHECK_SYNTH)	//If it's set to attack all non-silicons, target them!
		if(L.lying)
			return lethal ? TURRET_SECONDARY_TARGET : TURRET_NOT_TARGET
		return TURRET_PRIORITY_TARGET

	if(iscuffed(L)) // If the target is handcuffed, leave it alone
		return TURRET_NOT_TARGET

	if(isanimal(L) || issmall(L)) // Animals are not so dangerous
		return !!(turret_checks & TURRET_CHECK_ANOMALIES) ? TURRET_SECONDARY_TARGET : TURRET_NOT_TARGET

	if(isxenomorph(L) || isalien(L)) // Xenos are dangerous
		return !!(turret_checks & TURRET_CHECK_ANOMALIES) ? TURRET_PRIORITY_TARGET	: TURRET_NOT_TARGET

	if(ishuman(L))	//if the target is a human, analyze threat level
		if(assess_perp(L) < 4)
			return TURRET_NOT_TARGET	//if threat level < 4, keep going

	if(L.lying)		//if the perp is lying down, it's still a target but a less-important target
		return lethal ? TURRET_SECONDARY_TARGET : TURRET_NOT_TARGET

	return TURRET_PRIORITY_TARGET	//if the perp has passed all previous tests, congrats, it is now a "shoot-me!" nominee

/obj/machinery/porta_turret/proc/assess_perp(var/mob/living/carbon/human/H)
	if(!H || !istype(H))
		return 0

	if(emagged)
		return 10

	var/check_access = !!(turret_checks & TURRET_CHECK_ACCESS)
	var/check_weapons = !!(turret_checks & TURRET_CHECK_WEAPONS)
	var/check_records = !!(turret_checks & TURRET_CHECK_RECORDS)
	var/check_arrest = !!(turret_checks & TURRET_CHECK_ARREST)
	return H.assess_perp(src, check_access, check_weapons, check_records, check_arrest)

/obj/machinery/porta_turret/proc/tryToShootAt(var/list/mob/living/targets)
	if(targets.len && last_target && (last_target in targets) && target(last_target))
		return TRUE

	while(targets.len > 0)
		var/mob/living/M = pick(targets)
		targets -= M
		if(target(M))
			return TRUE


/obj/machinery/porta_turret/proc/popUp()	//pops the turret up
	if(disabled)
		return
	if(raising || raised)
		return
	if(stat & BROKEN)
		return
	set_raised_raising(raised, TRUE)
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
	if(stat & BROKEN)
		return
	set_raised_raising(raised, TRUE)
	update_icon()

	var/atom/flick_holder = new /atom/movable/porta_turret_cover(loc)
	flick_holder.layer = layer + 0.1
	flick("popdown", flick_holder)
	sleep(10)
	qdel(flick_holder)

	set_raised_raising(0, 0)
	update_icon()

/obj/machinery/porta_turret/proc/set_raised_raising(var/raised, var/raising)
	src.raised = raised
	src.raising = raising
	set_density(raised || raising)

/obj/machinery/porta_turret/proc/target(var/mob/living/target)
	if(disabled)
		return
	if(target)
		last_target = target
		spawn()
			popUp()				//pop the turret up if it's not already up.
		set_dir(get_dir(src, target))	//even if you can't shoot, follow the target
		spawn()
			shootAt(target)
		return TRUE
	return

/obj/machinery/porta_turret/proc/shootAt(var/mob/living/target)
	//any emagged turrets will shoot extremely fast! This not only is deadly, but drains a lot power!
	if(!(emagged || attacked))		//if it hasn't been emagged or attacked, it has to obey a cooldown rate
		if(last_fired || !raised)	//prevents rapid-fire shooting, unless it's been emagged
			return
		last_fired = TRUE
		spawn()
			sleep(shot_delay)
			last_fired = FALSE

	var/turf/T = get_turf(src)
	var/turf/U = get_turf(target)
	if(!istype(T) || !istype(U))
		return

	if(!raised) //the turret has to be raised in order to fire - makes sense, right?
		return

	update_icon()
	var/obj/item/projectile/A
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

/obj/machinery/porta_turret/proc/setState(var/datum/turret_checks/TC)
	if(controllock)
		return
	src.enabled = TC.enabled
	src.lethal = TC.lethal
	src.iconholder = TC.lethal ? "red" : "blue"

	if (TC.check_synth)
		turret_checks |= TURRET_CHECK_SYNTH
	else
		turret_checks &= ~TURRET_CHECK_SYNTH

	if (TC.check_access)
		turret_checks |= TURRET_CHECK_ACCESS
	else
		turret_checks &= ~TURRET_CHECK_ACCESS

	if (TC.check_records)
		turret_checks |= TURRET_CHECK_RECORDS
	else
		turret_checks &= ~TURRET_CHECK_RECORDS

	if (TC.check_arrest)
		turret_checks |= TURRET_CHECK_ARREST
	else
		turret_checks &= ~TURRET_CHECK_ARREST

	if (TC.check_weapons)
		turret_checks |= TURRET_CHECK_WEAPONS
	else
		turret_checks &= ~TURRET_CHECK_WEAPONS

	if (TC.check_anomalies)
		turret_checks |= TURRET_CHECK_ANOMALIES
	else
		turret_checks &= ~TURRET_CHECK_ANOMALIES

	ailock = TC.ailock

	src.power_change()

/*
		Portable turret constructions
		Known as "turret frame"s
*/

/obj/machinery/porta_turret_construct
	name = "turret frame"
	icon = 'icons/obj/turrets.dmi'
	icon_state = "turret_frame"
	density=1
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

			else if(istype(I, /obj/item/weapon/wrench))
				playsound(loc, 'sound/items/Ratchet.ogg', 75, 1)
				to_chat(user, SPAN_NOTICE("You unfasten the external bolts."))
				anchored = FALSE
				build_step = 0
				return


		if(2)
			if(istype(I, /obj/item/weapon/wrench))
				playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
				to_chat(user, SPAN_NOTICE("You bolt the metal armor into place."))
				build_step = 3
				return

			else if(isWelder(I))
				var/obj/item/weapon/weldingtool/WT = I
				if(!WT.isOn())
					return
				if(WT.get_fuel() < 5) //uses up 5 fuel.
					to_chat(user, SPAN_WARNING("You need more fuel to complete this task."))
					return

				playsound(loc, pick('sound/items/Welder.ogg', 'sound/items/Welder2.ogg'), 50, 1)
				if(do_after(user, 20, src))
					if(!src || !WT.remove_fuel(5, user)) return
					build_step = 1
					to_chat(user, SPAN_NOTICE("You remove the turret's interior metal armor."))
					new /obj/item/stack/material/steel( loc, 2)
					return


		if(3)
			if(istype(I, /obj/item/weapon/gun/energy)) //the gun installation part

				if(isrobot(user))
					return
				var/obj/item/weapon/gun/energy/E = I //typecasts the item to an energy gun
				if (!E.can_make_turret)
					to_chat(user, SPAN_WARNING("\the [I] cannot be used to make a turret."))
					return
				if(!user.unEquip(I))
					to_chat(user, SPAN_WARNING("\the [I] is stuck to your hand, you cannot put it in \the [src]"))
					return
				installation = I.type //installation becomes I.type
				gun_charge = E.power_supply.charge //the gun's charge is stored in gun_charge
				to_chat(user, SPAN_NOTICE("You add [I] to the turret."))
				target_type = /obj/machinery/porta_turret

				build_step = 4
				qdel(I) //delete the gun :(
				return

			else if(istype(I, /obj/item/weapon/wrench))
				playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
				to_chat(user, SPAN_NOTICE("You remove the turret's metal armor bolts."))
				build_step = 2
				return

		if(4)
			if(isprox(I))
				build_step = 5
				if(!user.unEquip(I))
					to_chat(user, SPAN_NOTICE("\the [I] is stuck to your hand, you cannot put it in \the [src]."))
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

			else if(istype(I, /obj/item/weapon/screwdriver))
				playsound(loc, 'sound/items/Screwdriver.ogg', 100, 1)
				build_step = 5
				to_chat(user, SPAN_NOTICE("You open the internal access hatch."))
				return

		if(7)
			if(isWelder(I))
				var/obj/item/weapon/weldingtool/WT = I
				if(!WT.isOn()) return
				if(WT.get_fuel() < 5)
					to_chat(user, SPAN_NOTICE("You need more fuel to complete this task."))

				playsound(loc, pick('sound/items/Welder.ogg', 'sound/items/Welder2.ogg'), 50, 1)
				if(do_after(user, 30, src))
					if(!src || !WT.remove_fuel(5, user))
						return
					build_step = 8
					to_chat(user, SPAN_NOTICE("You weld the turret's armor down."))

					//The final step: create a full turret
					var/obj/machinery/porta_turret/Turret = new target_type(loc)
					Turret.SetName(finish_name)
					Turret.installation = installation
					Turret.gun_charge = gun_charge
					Turret.enabled = FALSE
					Turret.setup()

					qdel(src) // qdel

			else if(isCrowbar(I))
				playsound(loc, 'sound/items/Crowbar.ogg', 75, 1)
				to_chat(user, SPAN_NOTICE("You pry off the turret's exterior armor."))
				new /obj/item/stack/material/steel(loc, 2)
				build_step = 6
				return

	if(istype(I, /obj/item/weapon/pen))	//you can rename turrets like bots!
		if(!in_range(src, usr) && loc != usr)
			return

		var/t = sanitizeSafe(input(user, "Enter new turret name", name, finish_name) as text, MAX_NAME_LEN)
		if(!t)
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

			var/obj/item/weapon/gun/energy/Gun = new installation(loc)
			Gun.power_supply.charge = gun_charge
			Gun.update_icon()
			installation = null
			gun_charge = 0
			to_chat(user, "<span class='notice'>You remove [Gun] from the turret frame.</span>")

		if(5)
			to_chat(user, "<span class='notice'>You remove the prox sensor from the turret frame.</span>")
			new /obj/item/device/assembly/prox_sensor(loc)
			build_step = 4

/obj/machinery/porta_turret_construct/attack_ai()
	return

/atom/movable/porta_turret_cover
	icon = 'icons/obj/turrets.dmi'




#undef TURRET_PRIORITY_TARGET
#undef TURRET_SECONDARY_TARGET
#undef TURRET_NOT_TARGET

#undef TURRET_DELAY_MODIFIER

#undef TURRET_CHECK_ARREST
#undef TURRET_CHECK_RECORDS
#undef TURRET_CHECK_WEAPONS
#undef TURRET_CHECK_ACCESS
#undef TURRET_CHECK_ANOMALIES
#undef TURRET_CHECK_SYNTH

#undef TURRET_EMAG_HEALTH_MOD
#undef TURRET_EMAG_SHOT_DELAY_MOD
#undef TURRET_EMAG_POWER_MOD
