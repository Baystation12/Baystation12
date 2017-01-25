/obj/effect/shield_impact
	name = "shield impact"
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "shield_impact"
	anchored = 1
	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER
	density = 0


/obj/effect/shield_impact/New()
	spawn(2 SECONDS)
		qdel(src)


/obj/effect/shield
	name = "energy shield"
	desc = "An impenetrable field of energy, capable of blocking anything as long as it's active."
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "shield_normal"
	anchored = 1
	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER
	density = 1
	invisibility = 0
	var/obj/machinery/power/shield_generator/gen = null
	var/disabled_for = 0
	var/diffused_for = 0


/obj/effect/shield/update_icon()
	if(gen && gen.check_flag(MODEFLAG_PHOTONIC) && !disabled_for && !diffused_for)
		set_opacity(1)
	else
		set_opacity(0)

	if(gen && gen.check_flag(MODEFLAG_OVERCHARGE))
		icon_state = "shield_overcharged"
	else
		icon_state = "shield_normal"

// Prevents shuttles, singularities and pretty much everything else from moving the field segments away.
// The only thing that is allowed to move us is the Destroy() proc.
/obj/effect/shield/forceMove(var/newloc, var/qdeled = 0)
	if(qdeled)
		return ..()
	return 0


/obj/effect/shield/New()
	..()
	update_nearby_tiles()


/obj/effect/shield/Destroy()
	. = ..()
	if(gen)
		if(src in gen.field_segments)
			gen.field_segments -= src
		if(src in gen.damaged_segments)
			gen.damaged_segments -= src
		gen = null
	update_nearby_tiles()
	forceMove(null, 1)


// Temporarily collapses this shield segment.
/obj/effect/shield/proc/fail(var/duration)
	if(duration <= 0)
		return

	gen.damaged_segments |= src
	disabled_for += duration
	set_density(0)
	invisibility = INVISIBILITY_MAXIMUM
	update_nearby_tiles()
	update_icon()
	update_explosion_resistance()


// Regenerates this shield segment.
/obj/effect/shield/proc/regenerate()
	if(!gen)
		return

	disabled_for = max(0, disabled_for - 1)
	diffused_for = max(0, diffused_for - 1)

	if(!disabled_for && !diffused_for)
		set_density(1)
		invisibility = 0
		update_nearby_tiles()
		update_icon()
		update_explosion_resistance()
		gen.damaged_segments -= src


/obj/effect/shield/proc/diffuse(var/duration)
	// The shield is trying to counter diffusers. Cause lasting stress on the shield.
	if(gen.check_flag(MODEFLAG_BYPASS) && !diffused_for && !disabled_for)
		take_damage(duration * rand(8, 12), SHIELD_DAMTYPE_EM)
		return

	diffused_for = max(duration, 0)
	gen.damaged_segments |= src
	set_density(0)
	invisibility = INVISIBILITY_MAXIMUM
	update_nearby_tiles()
	update_icon()
	update_explosion_resistance()

/obj/effect/shield/attack_generic(var/source, var/damage, var/emote)
	take_damage(damage, SHIELD_DAMTYPE_PHYSICAL)
	if(gen.check_flag(MODEFLAG_OVERCHARGE) && istype(source, /mob/living/))
		overcharge_shock(source)
	..(source, damage, emote)


// Fails shield segments in specific range. Range of 1 affects the shielded turf only.
/obj/effect/shield/proc/fail_adjacent_segments(var/range, var/hitby = null)
	if(hitby)
		visible_message("<span class='danger'>\The [src] flashes a bit as \the [hitby] collides with it, eventually fading out in a rain of sparks!</span>")
	else
		visible_message("<span class='danger'>\The [src] flashes a bit as it eventually fades out in a rain of sparks!</span>")
	fail(range * 2)

	for(var/obj/effect/shield/S in range(range, src))
		// Don't affect shields owned by other shield generators
		if(S.gen != src.gen)
			continue
		// The closer we are to impact site, the longer it takes for shield to come back up.
		S.fail(-(-range + get_dist(src, S)) * 2)

/obj/effect/shield/proc/take_damage(var/damage, var/damtype, var/hitby, var/no_flicker = 0)
	if(!gen)
		qdel(src)
		return

	if(!damage)
		return

	damage = round(damage)

	if(!no_flicker)
		new/obj/effect/shield_impact(get_turf(src))

	switch(gen.take_damage(damage, damtype))
		if(SHIELD_ABSORBED)
			return
		if(SHIELD_BREACHED_MINOR)
			fail_adjacent_segments(rand(1, 3), hitby)
			return
		if(SHIELD_BREACHED_MAJOR)
			fail_adjacent_segments(rand(2, 5), hitby)
			return
		if(SHIELD_BREACHED_CRITICAL)
			fail_adjacent_segments(rand(4, 8), hitby)
			return
		if(SHIELD_BREACHED_FAILURE)
			fail_adjacent_segments(rand(8, 16), hitby)
			for(var/obj/effect/shield/S in gen.field_segments)
				S.fail(1)
			return


// As we have various shield modes, this handles whether specific things can pass or not.
/obj/effect/shield/CanPass(var/atom/movable/mover, var/turf/target, var/height=0, var/air_group=0)
	// Somehow we don't have a generator. This shouldn't happen. Delete the shield.
	if(!gen)
		qdel(src)
		return 1

	if(disabled_for || diffused_for)
		return 1

	// Atmosphere containment.
	if(air_group)
		return !gen.check_flag(MODEFLAG_ATMOSPHERIC)

	if(mover)
		return mover.can_pass_shield(gen)
	return 1


/obj/effect/shield/c_airblock(turf/other)
	return gen.check_flag(MODEFLAG_ATMOSPHERIC)


// EMP
/obj/effect/shield/emp_act(var/severity)
	if(is_disabled())
		return
	take_damage(rand(30,60) / severity, SHIELD_DAMTYPE_EM)


// Explosions
/obj/effect/shield/ex_act(var/severity)
	if(!gen || !gen.check_flag(MODEFLAG_HYPERKINETIC) || is_disabled())
		return
	take_damage(rand(10,15) / severity, SHIELD_DAMTYPE_PHYSICAL)

// Fire
/obj/effect/shield/fire_act()
	if(!gen || !gen.check_flag(MODEFLAG_ATMOSPHERIC) || is_disabled())
		return
	take_damage(rand(5,10), SHIELD_DAMTYPE_HEAT)

// Radiation
/obj/effect/shield/rad_act(var/severity)
	if(!gen || !gen.check_flag(MODEFLAG_ANTIRAD) || is_disabled())
		return
	take_damage(severity/100, SHIELD_DAMTYPE_HEAT, 0, (severity > 100 ? 0 : 1))

// Projectiles
/obj/effect/shield/bullet_act(var/obj/item/projectile/proj)
	if(proj.damage_type == BURN)
		take_damage(proj.get_structure_damage(), SHIELD_DAMTYPE_HEAT)
	else if (proj.damage_type == BRUTE)
		take_damage(proj.get_structure_damage(), SHIELD_DAMTYPE_PHYSICAL)
	else
		take_damage(proj.get_structure_damage(), SHIELD_DAMTYPE_EM)


// Attacks with hand tools. Blocked by Hyperkinetic flag.
/obj/effect/shield/attackby(var/obj/item/weapon/I as obj, var/mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)

	if(gen.check_flag(MODEFLAG_HYPERKINETIC))
		user.visible_message("<span class='danger'>\The [user] hits \the [src] with \the [I]!</span>")
		if(I.damtype == BURN)
			take_damage(I.force, SHIELD_DAMTYPE_HEAT)
		else if (I.damtype == BRUTE)
			take_damage(I.force, SHIELD_DAMTYPE_PHYSICAL)
		else
			take_damage(I.force, SHIELD_DAMTYPE_EM)
	else
		user.visible_message("<span class='danger'>\The [user] tries to attack \the [src] with \the [I], but it passes through!</span>")


// Special treatment for meteors because they would otherwise penetrate right through the shield.
/obj/effect/shield/Bumped(var/atom/movable/mover)
	if(!gen)
		qdel(src)
		return 0
	mover.shield_impact(src)
	return ..()


/obj/effect/shield/proc/overcharge_shock(var/mob/living/M)
	M.adjustFireLoss(rand(20, 40))
	M.Weaken(5)
	to_chat(M, "<span class='danger'>As you come into contact with \the [src] a surge of energy paralyses you!</span>")
	take_damage(10, SHIELD_DAMTYPE_EM)

// Called when a flag is toggled. Can be used to add on-toggle behavior, such as visual changes.
/obj/effect/shield/proc/flags_updated()
	if(!gen)
		qdel(src)
		return

	// Update airflow
	update_nearby_tiles()
	update_icon()
	update_explosion_resistance()

/obj/effect/shield/proc/update_explosion_resistance()
	if(gen && gen.check_flag(MODEFLAG_HYPERKINETIC))
		explosion_resistance = INFINITY
	else
		explosion_resistance = 0

/obj/effect/shield/get_rad_resistance()
	if(gen && gen.check_flag(MODEFLAG_ANTIRAD))
		return SHIELD_RAD_RESISTANCE
	return 0

/obj/effect/shield/proc/is_disabled()
	return (disabled_for || diffused_for)

// Shield collision checks below

/atom/movable/proc/can_pass_shield(var/obj/machinery/power/shield_generator/gen)
	return 1


// Other mobs
/mob/living/can_pass_shield(var/obj/machinery/power/shield_generator/gen)
	return !gen.check_flag(MODEFLAG_NONHUMANS)

// Human mobs
/mob/living/carbon/human/can_pass_shield(var/obj/machinery/power/shield_generator/gen)
	if(isSynthetic())
		return !gen.check_flag(MODEFLAG_ANORGANIC)
	return !gen.check_flag(MODEFLAG_HUMANOIDS)

// Silicon mobs
/mob/living/silicon/can_pass_shield(var/obj/machinery/power/shield_generator/gen)
	return !gen.check_flag(MODEFLAG_ANORGANIC)


// Generic objects. Also applies to bullets and meteors.
/obj/can_pass_shield(var/obj/machinery/power/shield_generator/gen)
	return !gen.check_flag(MODEFLAG_HYPERKINETIC)

// Beams
/obj/item/projectile/beam/can_pass_shield(var/obj/machinery/power/shield_generator/gen)
	return !gen.check_flag(MODEFLAG_PHOTONIC)


// Shield on-impact logic here. This is called only if the object is actually blocked by the field (can_pass_shield applies first)
/atom/movable/proc/shield_impact(var/obj/effect/shield/S)
	return

/mob/living/shield_impact(var/obj/effect/shield/S)
	if(!S.gen.check_flag(MODEFLAG_OVERCHARGE))
		return
	S.overcharge_shock(src)

/obj/effect/meteor/shield_impact(var/obj/effect/shield/S)
	if(!S.gen.check_flag(MODEFLAG_HYPERKINETIC))
		return
	S.take_damage(get_shield_damage(), SHIELD_DAMTYPE_PHYSICAL, src)
	visible_message("<span class='danger'>\The [src] breaks into dust!</span>")
	make_debris()
	qdel(src)