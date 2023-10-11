/*
	Moved the non-airlock procs in airlock.dm to here.
*/

//*** Blocking Airlocks

/atom/movable/proc/blocks_airlock()
	return density

/obj/machinery/door/blocks_airlock()
	return 0

/obj/structure/window/blocks_airlock()
	return 0

/obj/machinery/mech_sensor/blocks_airlock()
	return 0

/obj/energy_field/blocks_airlock()
	return 0

/obj/machinery/shield/blocks_airlock()
	return 0

/mob/living/blocks_airlock()
	return 1

/obj/structure/closet/body_bag/blocks_airlock()
	if (locate(/mob) in src)
		return 1
	else
		return 0				//Prevents Airlocks from closing on Bodybags and Cryobags with people inside


//*** Airlock Crushing

#define AIRLOCK_CRUSH_INCREMENT 10 // Damage caused by airlock crushing a mob is split into multiple smaller hits. Makes door crushing behave more like a "slow" crushing effect rather than high-speed impacts.
#define CYBORG_AIRLOCKCRUSH_RESISTANCE 2 // Damage caused to silicon mobs (usually cyborgs) from being crushed by airlocks is divided by this number. Unlike organics cyborgs don't have passive regeneration.

/**
 * Whether or not the atom can be crushed and damaged by a closing airlock.
 */
/atom/movable/proc/airlock_can_crush()
	if (get_max_health())
		return TRUE
	return FALSE

/**
 * Handles being crushed by a closing airlock. Has no return value.
 */
/atom/movable/proc/airlock_crush(crush_damage)
	damage_health(crush_damage, DAMAGE_BRUTE)

/obj/structure/window/airlock_crush(crush_damage)
	shatter(TRUE)

/obj/energy_field/airlock_can_crush()
	return TRUE

/obj/energy_field/airlock_crush(crush_damage)
	Stress(crush_damage)

/obj/structure/closet/airlock_crush(crush_damage)
	for(var/atom/movable/AM in src)
		AM.airlock_crush(crush_damage)
	..()

/mob/living/airlock_can_crush()
	if (status_flags & GODMODE)
		return FALSE
	return TRUE

/mob/living/airlock_crush(crush_damage)
	for (var/i in 1 to round(crush_damage/AIRLOCK_CRUSH_INCREMENT, 1))
		apply_damage(AIRLOCK_CRUSH_INCREMENT, DAMAGE_BRUTE)

	SetStunned(round(crush_damage / 8, 1))
	SetWeakened(round(crush_damage / 8, 1))

	var/turf/T = loc
	if (!istype(T))
		return

	var/list/valid_turfs = list()
	for (var/dir_to_test in GLOB.cardinal)
		var/turf/new_turf = get_step(T, dir_to_test)
		if (!new_turf.contains_dense_objects())
			valid_turfs |= new_turf

	while (length(valid_turfs))
		T = pick(valid_turfs)
		valid_turfs -= T
		// Try to move us to the turf. If all turfs fail for some reason we will stay on this tile.
		if (src.Move(T))
			return

/mob/living/carbon/airlock_crush(crush_damage)
	..()
	if (can_feel_pain())
		emote("scream")

/mob/living/silicon/robot/airlock_crush(crush_damage)
	..(round(crush_damage / CYBORG_AIRLOCKCRUSH_RESISTANCE)) //TODO implement robot melee armour and remove this.

/obj/structure/disposalpipe/airlock_can_crush()
	return FALSE

/obj/machinery/atmospherics/pipe/airlock_can_crush()
	return FALSE

/obj/structure/cable/airlock_can_crush()
	return FALSE

/obj/machinery/door/airlock_can_crush()
	return FALSE // Shutters, firedoors, etc
