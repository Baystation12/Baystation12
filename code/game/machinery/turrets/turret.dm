// TODO Add handling of gun component
// TODO Add wire datum
// TODO Add UI
// TODO Add area turrent controller
// TODO Finish random fire proc
// TODO Add frame types (Constructable from different materials to affect health)
// TODO Add component parts list
// TODO Add construction steps
// TODO Add turret frame object
// TODO Add spark system
// TODO Add repair steps
// TODO Add malf upgrade
// TODO Add sprites
// TODO Add warrant status checking


/**
 * Turret modes as defined by users in-game. These represents the turrets on/off setting, or malfunctioning state.
 */
#define TURRET_MODE_OFF 0 // Turret is turned off
#define TURRET_MODE_ON 1 // Turret is turned on
#define TURRET_MODE_HAYWIRE 2 // Turret is malfunctioning/going haywire (EMP effect). Fires on everything regardless of settings.


/**
 * Turret state defines. These control the icon state as well as what functionality is enabled/disabled for the turret.
 */
#define TURRET_STATE_OFF 0 // Turret is off but otherwise functional
#define TURRET_STATE_IDLE 1 // Turret is on but idle
#define TURRET_STATE_ENGAGED 2 // Turret is on and actively engaging someone
#define TURRET_STATE_DISABLED 3 // Turret is disabled
#define TURRET_STATE_BROKEN 4 // Turret is broken
#define TURRET_STATE_UNARMED 5 // Turret has no gun installed


/**
 * Turret targeting parameter bitflags. Represents different categories of targets a turret can be configured to shoot.
 */
#define TURRET_TARGETS_PEOPLE 0x1 // Turret will target people with IDs (With respect to the access list)
#define TURRET_TARGETS_UNKNOWNS 0x2 // Turret will target people without IDs
#define TURRET_TARGETS_CREATURES 0x3 // Turret will target creatures. Includes mice, carp, spiders, etc
#define TURRET_TARGETS_SYNTHS 0x4 // Turret will target law-bound synthetics
#define TURRET_TARGETS_DOWNED 0x5 // Turret will continuing firing even if the target is 'downed'


/obj/machinery/turret
	name = "turret"
	desc = "A standard automated turret system."
	icon = 'icons/obj/turret.dmi' // TODO Get sprites
	icon_state = "turret_off" // TODO Get sprites

	anchored = 1
	density = 1
	idle_power_usage = 50
	active_power_usage = 300
	power_channel = EQUIP
	req_access = list(list(access_security, access_bridge)) // List of access flags permitted to unlock/lock the panel
	stat_immune = 0
	waterproof = TRUE
	// TODO Update frame_type to turret frame
	// TODO Update component_parts list
	// TODO Update wires datum

	var/turret_mode = TURRET_MODE_OFF // User-defined mode of the turret. On, Off, or 'Haywire' (EMP effect)
	var/turret_state = TURRET_STATE_OFF // Current state of the turret. Off, Idle, Engaged, or Disabled
	var/turret_targets = TURRET_TARGETS_PEOPLE | TURRET_TARGETS_UNKNOWNS // Bitflag. What the turret will and will not target
	var/health = 80 // Current health of the turret
	var/max_health = 80 // Maximum health of the turret
	var/panel_locked = TRUE // If the turret control panel is locked
	var/ai_locked = FALSE // If the turret control panel is locked from AI access
	var/list/turret_whitelist =  list(list(access_security, access_bridge)) // List of access flags that will NOT be fired on
	var/obj/item/weapon/gun/installed_gun // Object holder for the installed gun
	var/cooldown = FALSE // True = Turret has recently fired and is on cooldown. False = Turret is ready to fire.
	var/cooldown_delay = 15 // Delay timer for cooldown
	var/turret_controller = FALSE // TRUE = Connected to area turret controller, if present. FALSE = Not connected/Independent
	var/last_target // Tracker for the last person the turret fired on, to keep firing at the same target.
	var/shoot_power_usage = 500 // Power used to fire


/obj/machinery/turret/New()
	. = ..()
	if (installed_gun)
		setup_gun()

	update_state()

	// TODO Spark system?


/obj/machinery/turret/on_update_icon()
	switch (turret_state)
		if (TURRET_STATE_OFF)
			icon_state = "turret_off"
		else if (TURRET_STATE_IDLE)
			icon_state = "turret_idle"
		else if (TURRET_STATE_ENGAGED)
			icon_state = "turret_active"
		else if (TURRET_STATE_DISABLED)
			icon_state = "turret_disabled"
		else if (TURRET_STATE_BROKEN)
			icon_state = "turret_broken"
		else if (TURRET_STATE_UNARMED)
			icon_state = "turret_unarmed"
		else
			icon_state = "turret_disabled"


/obj/machinery/turret/interface_interact(user)
	ui_interact(user)
	return TRUE


/obj/machinery/turret/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	. = ..()
	// TODO


/obj/machinery/turret/CanUseTopic(mob/user)
	if (!anchored)
		to_chat(user, SPAN_NOTICE("\The [src] must be secured first!"))
		return STATUS_CLOSE

	if (turret_state == TURRET_STATE_BROKEN)
		to_chat(user, SPAN_NOTICE("\The [src] is broken and the control panel is unresponsive."))
		return STATUS_CLOSE

	if (turret_state == TURRET_STATE_DISABLED)
		to_chat(user, SPAN_NOTICE("\The [src] is disabled and it's control panel is unresponsive."))
		return STATUS_CLOSE

	if (controller_enabled())
		to_chat(user, SPAN_NOTICE("\The [src]'s remote controller sync is enabled. Local control panel islocked."))
		return STATUS_CLOSE

	if (issilicon(user) && (ai_locked || emagged))
		to_chat(user, SPAN_NOTICE("\The [src] rejects your input."))
		return STATUS_CLOSE

	if (!issilicon(user))
		if (emagged)
			to_chat(user, SPAN_WARNING("\The [src]'s panel displays an error. You can't see any way to access it."))
			return STATUS_CLOSE
		if (panel_locked)
			to_chat(user, SPAN_NOTICE("\The [src]'s panel is currently locked."))
			return STATUS_CLOSE

	return ..()


/obj/machinery/turret/Topic(href, href_list, datum/topic_state/state)
	if(..())
		return TRUE
	// TODO


/obj/machinery/turret/attackby(obj/item/I, mob/user)
	. = ..()
	// TODO


/obj/machinery/turret/emp_act(severity)
	var/damage = max_health / (severity + rand(4, 6)) // TODO Experiment with different numbers to find a good balance for EMP damage
	if (damage)
		adjust_health(-1 * damage)
		if (is_broken())
			return

	if (prob(60 / severity)) // 60% / 30% / 20% chance of temporary EMP effect
		stat |= EMPED
		update_state()
		spawn()
			sleep(rand(100 / severity, 200 / severity)) // 10-20 / 5-10 / 3-7 seconds of downtime
			stat &= ~EMPED
			update_state()

	if (prob(45 / severity)) // 45% / 23% / 15% chance of going haywire
		set_mode(TURRET_MODE_HAYWIRE)
	else if (!controller_enabled())
		set_mode(rand(0, 1)) // 50% chance of on/off status

	..()


/obj/machinery/turret/emag_act(remaining_charges, mob/user, emag_source)
	. = ..()
	if (emagged)
		to_chat(user, SPAN_NOTICE("\The [src]'s control panel has already been shorted and is unresponsive to further hacking attempts."))
		return NO_EMAG_ACT

	stat |= EMPED
	set_mode(TURRET_MODE_HAYWIRE)
	turret_controller = FALSE
	to_chat(user, SPAN_NOTICE("You swipe \the [emag_source] through \the [src]'s panel lock, shorting out the systems. You might want to get out of range before it reboots..."))
	visible_message(SPAN_NOTICE("\The [src] sparks ominously as it powers down..."), SPAN_NOTICE("You hear an ominous sparking..."))

	spawn()
		sleep(rand(60, 120)) // 6 to 12 seconds for the user to run
		stat &= ~EMPED
		update_state()


/obj/machinery/turret/bullet_act(obj/item/projectile/P, def_zone)
	var/damage = P.get_structure_damage()
	if (damage)
		adjust_health(-1 * damage)


/obj/machinery/turret/ex_act(severity)
	..()
	var/damage = max_health / severity * -1 // 100% / 50% / 33% max health damage to turret
	adjust_health(damage)


/obj/machinery/turret/Process()
	var/list/targets = list()
	for (var/mob/M in mobs_in_view(world.view, src))
		if (target_validation(M))
			targets += M

	if (!cooldown && istype(get_turf(src), /turf))
		if (turret_mode == TURRET_MODE_HAYWIRE && prob(50))
			random_fire()
		else if (targets.len)
			if (last_target && last_target in targets && istype(get_turf(last_target), /turf))
				engage_target(last_target)
			else
				while (targets.len > 0)
					var/mob/target = pick(targets)
					if (!istype(get_turf(target), /turf))
						targets -= target
					else
						engage_target(target)

	update_state()


/**
 * Fires at a given target
 */
/obj/machinery/turret/proc/engage_target(mob/target)
	var/obj/item/projectile/P // TODO Fetch projectile from gun
	use_power_oneoff(shoot_power_usage)
	var/def_zone = get_exposed_defense_zone(target) // Ensure the turret targets extremities if firing at someone that's got a grab
	P.launch(target, def_zone)
	visible_message(SPAN_WARNING("\The [src] fires at [target]!"))
	cooldown()


/**
 * Fires in a random direction instead of at a specific target. Used when turrets are 'haywire'
 */
/obj/machinery/turret/proc/random_fire()
	var/obj/item/projectile/P // TODO Fetch projectile from gun
	use_power_oneoff(shoot_power_usage)
	// TODO
	visible_message(SPAN_WARNING("\The [src] fires into the room!"))
	cooldown()


/**
 * Handles cooldown processing
 */
/obj/machinery/turret/proc/cooldown()
	cooldown = TRUE
	spawn()
		sleep(cooldown_delay)
		cooldown = FALSE


/**
 * Handles validation of a mob as a potential target based on various conditions
 */
/obj/machinery/turret/proc/target_validation(mob/M)
	// Initial checks - Things that should always cause the target to not be valid
	if (!istype(M) || !M)
		return FALSE
	if (M.invisibility >= INVISIBILITY_LEVEL_ONE)
		return FALSE
	if (get_dist(src, M) > 7)
		return FALSE
	if (!check_trajectory(M, src))
		return FALSE
	if (isAI(M))
		return FALSE // Failsafe to prevent AI killing/suicide shennanigans

	// If the turret is going haywire, any checks past this point should be ignored and the turret should always target the mod
	if (turret_mode == TURRET_MODE_HAYWIRE)
		return TRUE

	// Remaining checks are based on turret targeting configuration
	if ((isanimal(M) || issmall(M)) && !(turret_targets & TURRET_TARGETS_CREATURES))
		return FALSE

	if (M.stat && !(turret_targets & TURRET_TARGETS_DOWNED))
		return FALSE

	if (iscuffed(M) && !(turret_targets & TURRET_TARGETS_DOWNED))
		return FALSE

	if (issilicon(M) && !(turret_targets & TURRET_TARGETS_SYNTHS))
		return FALSE

	// Additional checks for mob/living
	var/mob/living/L = M
	if (istype(L))
		if (L.lying && !(turret_targets & TURRET_TARGETS_DOWNED))
			return FALSE

	// If no other checks failed, then final checks for ID/access
	var/mob/living/carbon/human/H = M
	if (istype(H))
		var/target_name = H.name
		if (H.id)
			target_name = H.id.registered_name
		var/datum/computer_file/report/crew_record/CR = get_crewmember_record(target_name)

		if (!allowed(H) && turret_targets & TURRET_TARGETS_PEOPLE)
			return TRUE
		else if (!CR && turret_targets & TURRET_TARGETS_UNKNOWNS)
			return TRUE
		else
			return FALSE

	// All else fails, the target's valid
	return TRUE


/**
 * Handles damage and repair processing for the turret
 */
/obj/machinery/turret/proc/adjust_health(health_mod)
	health += health_mod
	if (health <= 0)
		die()
	else if (health >= max_health)
		health = max_health


/**
 * Handles the process of 'killing' the turret
 */
/obj/machinery/turret/proc/die()
	health = 0
	set_broken(TRUE)
	update_state()


/**
 * Updates turret's state var based on mode and other conditions
 */
/obj/machinery/turret/proc/update_state(engaged = FALSE)
	var/old_state = turret_state
	if (is_broken())
		turret_state = TURRET_STATE_BROKEN
	else if (stat & (NOPOWER | EMPED))
		turret_state = TURRET_STATE_DISABLED
	else if (!installed_gun)
		turret_state = TURRET_STATE_UNARMED
	else if (engaged && turret_mode != TURRET_MODE_OFF)
		turret_state = TURRET_STATE_ENGAGED
	else
		switch (turret_mode)
			if (TURRET_MODE_ON || TURRET_MODE_HAYWIRE)
				turret_state = TURRET_STATE_IDLE
			else if (TURRET_MODE_OFF)
				turret_state = TURRET_STATE_OFF
			else
				turret_state = TURRET_STATE_OFF

	if (old_state != turret_state)
		if (turret_state == TURRET_STATE_OFF || turret_state == TURRET_STATE_DISABLED)
			if (old_state != TURRET_STATE_BROKEN && old_state != TURRET_STATE_DISABLED && old_state != TURRET_STATE_OFF)
				visible_message("\The [src] slowly grows dark and quiet as it powers down.", "The soft whirring and beeping of a nearby machine slowly grows quiet...")
		else if (turret_state == TURRET_STATE_IDLE)
			if (old_state == TURRET_STATE_OFF || old_state == TURRET_STATE_BROKEN || old_state == TURRET_STATE_DISABLED)
				visible_message(SPAN_NOTICE("\The [src] whirrs and beeps as it comes online and begins scanning the room."), SPAN_NOTICE("You hear an ominous beeping and whirring sound..."))
			else if (old_state == TURRET_STATE_ENGAGED)
				visible_message(SPAN_NOTICE("\The [src] whirrs and beeps as it disengages and returns to an idle state."), SPAN_NOTICE("You hear an ominous beeping and whirring sound..."))
		else if (turret_state == TURRET_STATE_ENGAGED)
			visible_message(SPAN_WARNING("\The [src] emits a loud warning buzz as it locks onto a target and prepares to fire!"), SPAN_NOTICE("You hear a loud buzz and an ominous clicking..."))
		else if (turret_state == TURRET_STATE_BROKEN)
			visible_message(SPAN_WARNING("\The [src] sparks and breaks apart!"), SPAN_NOTICE("You hear the sound of sparking and breaking..."))

		update_icon()


/**
 * Does initialization work for prepping the installed gun to be used with the turret
 */
/obj/machinery/turret/proc/setup_gun()
	// TODO


/**
 * Checks if a valid turret controller exists in the turret's area. Does not take into account turret configuration - Use `controller_enabled()` for that.
 * Returns TRUE or FALSE
 */
/obj/machinery/turret/proc/has_controller()
	var/area/A = get_area(src)
	return A && A.turret_controls.len > 0 // TODO Update with new turret controller


/**
 * Toggles the state of `turret_controller` if there is a controller active in the area.
 * Returns TRUE if successful, otherwise FALSE
 */
/obj/machinery/turret/proc/toggle_controller()
	if (has_controller() && !emagged)
		turret_controller = !turret_controller
		return TRUE
	return FALSE


/**
 * Checks various conditions to determine if the turret controller is enabled.
 * Returns TRUE or FALSE
 */
/obj/machinery/turret/proc/controller_enabled()
	if (!turret_controller)
		return FALSE

	if (!has_controller())
		turret_controller = FALSE // Failsafe to allow this proc to fix a broken state if there is no controller but the var is enabled
		return FALSE

	// TODO Add check for controller wire being disabled


/**
 * Sets the turrets mode and updates state
 */
/obj/machinery/turret/proc/set_mode(mode)
	if (emagged)
		turret_mode = TURRET_MODE_HAYWIRE
	else
		turret_mode = mode
	update_state()


/obj/machinery/turret/proc/operating()
	return (turret_state == TURRET_STATE_IDLE || turret_state == TURRET_STATE_ENGAGED || turret_state == TURRET_STATE_UNARMED)
