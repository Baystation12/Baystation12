/// List of torpedo spawns zones.
GLOBAL_LIST_EMPTY(event_torpedo_spawns)
/// Map of sequence numbers to torpedo target zones.
GLOBAL_LIST_EMPTY(event_torpedo_targets)
GLOBAL_LIST_EMPTY(event_ex_acts)



// Master torpedo logic
/proc/event_torpedo_impacts()
	// Execute
	for (var/obj/effect/event_torpedo_spawn/event_torpedo_spawn as anything in GLOB.event_torpedo_spawns)
		event_torpedo_spawn.spawn_torpedo()



// Torpedo spawners
/obj/effect/event_torpedo_spawn
	name = "torpedo spawner"
	icon = 'packs/event_legion_capaneus/icons/torpedo.dmi'
	icon_state = "spawn"
	invisibility = 70
	/// Integer. Sequence number for the torpedoes. Will send torpedoes to matching target site.
	var/sequence


/obj/effect/event_torpedo_spawn/Initialize()
	. = ..()
	icon_state = ""
	if (!sequence)
		crash_with("Missing sequence at [x] [y] [z].")
		return INITIALIZE_HINT_QDEL
	GLOB.event_torpedo_spawns += src


/obj/effect/event_torpedo_target/Destroy()
	GLOB.event_torpedo_spawns -= src
	return ..()


/obj/effect/event_torpedo_spawn/proc/spawn_torpedo()
	new /obj/event_torpedo(loc, GLOB.event_torpedo_targets["[sequence]"])


// Torpedo targets
/obj/effect/event_torpedo_target
	name = "torpedo target"
	icon = 'packs/event_legion_capaneus/icons/torpedo.dmi'
	icon_state = "target"
	invisibility = 70
	/// Integer. Sequence number for the impact sites. Will send torpedoes from matching spawns here.
	var/sequence


/obj/effect/event_torpedo_target/Initialize()
	. = ..()
	icon_state = ""
	if (!sequence)
		crash_with("Missing sequence at [x] [y] [z].")
		return INITIALIZE_HINT_QDEL
	GLOB.event_torpedo_targets["[sequence]"] = src


/obj/effect/event_torpedo_target/Destroy()
	GLOB.event_torpedo_targets["[sequence]"] = null
	return ..()


/obj/effect/event_torpedo_target/proc/detonate()
	set waitfor = FALSE

	for (var/obj/effect/event_ex_act/event_ex_act as anything in GLOB.event_ex_acts["[sequence]"])
		var/turf/turf = get_turf(event_ex_act)
		for (var/atom/atom as anything in turf)
			atom.ex_act(event_ex_act.strength)
		turf.ex_act(event_ex_act.strength)

	var/src_z = get_z(src)
	var/turf/src_turf = get_turf(src)
	for (var/mob/mob in GLOB.player_list)
		var/living = isliving(mob)
		if (!living && !isobserver(mob))
			continue
		var/mob_z = get_z(mob)
		if (!AreConnectedZLevels(src_z, mob_z))
			continue
		var/turf/mob_turf = get_turf(mob)
		var/dist = get_dist(mob_turf, src_turf)
		var/turf/throw_target = get_edge_target_turf(mob, get_dir(src_turf, mob_turf))
		if (src_z == mob_z && dist <= world.view)
			mob.playsound_local(mob, get_sfx("explosion"), 100)
			mob.ex_act(EX_ACT_HEAVY)
			if (living)
				mob.throw_at(throw_target, 9, 9)
		else
			mob.playsound_local(mob, 'sound/effects/explosionfar.ogg', 15)
			if (!living || !mob.can_be_floored())
				continue
			to_chat(mob, SPAN_DANGER("You stumble onto the floor from the shaking!"))
			mob.AdjustWeakened(2)
			mob.AdjustStunned(2)


/obj/effect/event_ex_act
	icon = 'packs/event_legion_capaneus/icons/torpedo.dmi'
	abstract_type = /obj/effect/event_ex_act
	invisibility = 70
	var/strength
	var/sequence


/obj/effect/event_ex_act/Initialize()
	. = ..()
	icon_state = ""
	if (!sequence)
		crash_with("Missing sequence at [x] [y] [z].")
		return INITIALIZE_HINT_QDEL
	LAZYADD(GLOB.event_ex_acts["[sequence]"], src)


/obj/effect/event_ex_act/Destroy()
	LAZYREMOVE(GLOB.event_ex_acts["[sequence]"], src)
	return ..()


/obj/effect/event_ex_act/light
	name = "light explosion tile"
	icon_state = "light"
	strength = EX_ACT_LIGHT


/obj/effect/event_ex_act/heavy
	name = "heavy explosion tile"
	icon_state = "heavy"
	strength = EX_ACT_HEAVY


/obj/effect/event_ex_act/devastating
	name = "devastating explosion tile"
	icon_state = "devastating"
	strength = EX_ACT_DEVASTATING



// The Torpedo
/obj/event_torpedo
	name = "sabot torpedo"
	desc = "Oh shit."
	icon = 'icons/obj/missile.dmi'
	icon_state = "sabot"
	var/obj/effect/event_torpedo_target/target
	var/detonating = FALSE


/obj/event_torpedo/Destroy()
	target = null
	return ..()


/obj/event_torpedo/Initialize(mapload, obj/effect/event_torpedo_target/_target)
	. = ..()
	target = _target
	walk_towards(src, target.loc, 3)


/obj/event_torpedo/Bump(atom/A, called)
	..()
	if (QDELETED(A) || QDELETED(src) || !A.density)
		return
	if (ismob(A))
		forceMove(get_turf(A))
		A.visible_message(
			SPAN_WARNING("\The [src] narrowly misses \the [A]!"),
			SPAN_DANGER("\The [src] narrowly misses you!")
		)
		return
	if (A.get_current_health())
		A.kill_health()
		visible_message(
			SPAN_DANGER("\The [src] punches through \the [A]!")
		)
		return
	if (isturf(A))
		crash_with("\The [A] is a turf and didn't open up when health was killed.")
		return
	qdel(A)
	visible_message(
		SPAN_DANGER("\The [src] punches through \the [A]!")
	)


/obj/event_torpedo/Move()
	. = ..()
	if (detonating)
		return
	var/y_diff = abs(loc.y - target.y)
	var/x_diff = abs(loc.x - target.x)
	if (y_diff <= 1 && x_diff <= 1)
		walk(src, 0)
		icon_state = ""
		detonating = TRUE
		target.detonate()
		qdel_self()
