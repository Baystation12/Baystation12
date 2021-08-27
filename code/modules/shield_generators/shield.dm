/obj/effect/shield
	name = "energy shield"
	desc = "An impenetrable field of energy, capable of blocking anything as long as it's active."
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "shield_normal"
	anchored = TRUE
	layer = ABOVE_HUMAN_LAYER
	density = TRUE
	invisibility = 0
	var/obj/machinery/power/shield_generator/gen = null
	var/disabled_for = 0
	var/diffused_for = 0
	atmos_canpass = CANPASS_PROC


/obj/effect/shield/on_update_icon()
	if(gen && gen.check_flag(MODEFLAG_PHOTONIC) && !disabled_for && !diffused_for)
		set_opacity(1)
	else
		set_opacity(0)

	if (!gen)
		color = COLOR_RED_LIGHT
	else if (gen.check_flag(MODEFLAG_OVERCHARGE))
		color = COLOR_VIOLET
	else
		color = COLOR_DEEP_SKY_BLUE

// Prevents shuttles, singularities and pretty much everything else from moving the field segments away.
// The only thing that is allowed to move us is the Destroy() proc.
/obj/effect/shield/forceMove()
	if(QDELING(src))
		return ..()
	return 0


/obj/effect/shield/New()
	..()
	update_nearby_tiles()


/obj/effect/shield/Initialize(mapload, obj/machinery/power/shield_generator/new_gen)
	. = ..(mapload)

	if (QDELETED(new_gen))
		log_debug(append_admin_tools("Shield effect ([name]) was created without a valid generator in [get_area(src)].", location = get_turf(src)))
		return INITIALIZE_HINT_QDEL
	gen = new_gen


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

	if(gen)
		gen.damaged_segments |= src
	disabled_for += duration
	set_density(0)
	set_invisibility(INVISIBILITY_MAXIMUM)
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
		set_invisibility(0)
		update_nearby_tiles()
		update_icon()
		update_explosion_resistance()
		gen.damaged_segments -= src


/obj/effect/shield/proc/diffuse(var/duration)
	if (!gen)
		return

	// The shield is trying to counter diffusers. Cause lasting stress on the shield.
	if(gen.check_flag(MODEFLAG_BYPASS) && !disabled_for)
		take_damage(duration * rand(8, 12), SHIELD_DAMTYPE_EM)
		return

	diffused_for = max(duration, 0)
	gen.damaged_segments |= src
	set_density(0)
	set_invisibility(INVISIBILITY_MAXIMUM)
	update_nearby_tiles()
	update_icon()
	update_explosion_resistance()

/obj/effect/shield/attack_generic(var/source, var/damage, var/emote)
	take_damage(damage, SHIELD_DAMTYPE_PHYSICAL)
	if(gen?.check_flag(MODEFLAG_OVERCHARGE) && istype(source, /mob/living/))
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

/obj/effect/shield/proc/take_damage(var/damage, var/damtype, var/hitby)
	if(!gen)
		qdel(src)
		return

	if(!damage)
		return

	damage = round(damage)

	new /obj/effect/temporary(get_turf(src), 2 SECONDS,'icons/obj/machines/shielding.dmi',"shield_impact")
	impact_effect(round(abs(damage * 2)))

	var/list/field_segments = gen.field_segments
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
			for(var/obj/effect/shield/S in field_segments)
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
	return gen?.check_flag(MODEFLAG_ATMOSPHERIC) ? BLOCKED : 0


// EMP. It may seem weak but keep in mind that multiple shield segments are likely to be affected.
/obj/effect/shield/emp_act(var/severity)
	if(!disabled_for)
		take_damage(rand(30,60) / severity, SHIELD_DAMTYPE_EM)


// Explosions
/obj/effect/shield/ex_act(var/severity)
	if(!disabled_for)
		take_damage(rand(10,15) / severity, SHIELD_DAMTYPE_PHYSICAL)


// Fire
/obj/effect/shield/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(!disabled_for)
		take_damage(rand(5,10), SHIELD_DAMTYPE_HEAT)


// Projectiles
/obj/effect/shield/bullet_act(var/obj/item/projectile/proj)
	if(proj.damage_type == BURN)
		take_damage(proj.get_structure_damage(), SHIELD_DAMTYPE_HEAT)
	else if (proj.damage_type == BRUTE)
		take_damage(proj.get_structure_damage(), SHIELD_DAMTYPE_PHYSICAL)
	else
		take_damage(proj.get_structure_damage(), SHIELD_DAMTYPE_EM)


// Attacks with hand tools. Blocked by Hyperkinetic flag.
/obj/effect/shield/attackby(var/obj/item/I as obj, var/mob/user as mob)
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
	impact_effect(2)
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

/obj/effect/shield/get_explosion_resistance()
	return explosion_resistance

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

// Small visual effect, makes the shield tiles brighten up by changing color for a moment, and spreads to nearby shields.
/obj/effect/shield/proc/impact_effect(var/i, var/list/affected_shields = list())
	i = between(1, i, 10)
	var/backcolor = color
	if(gen && gen.check_flag(MODEFLAG_OVERCHARGE))
		color = COLOR_PINK
	else
		color = COLOR_CYAN_BLUE
	animate(src, color = backcolor, time = 1 SECOND)
	affected_shields |= src
	i--
	if(i)
		addtimer(CALLBACK(src, .proc/spread_impact_effect, i, affected_shields), 2)

/obj/effect/shield/proc/spread_impact_effect(var/i, var/list/affected_shields = list())
	for(var/direction in GLOB.cardinal)
		var/turf/T = get_step(src, direction)
		if(T) // Incase we somehow stepped off the map.
			for(var/obj/effect/shield/F in T)
				if(!(F in affected_shields))
					F.impact_effect(i, affected_shields) // Spread the effect to them

/obj/effect/shield/attack_hand(var/mob/living/user)
	impact_effect(3) // Harmless, but still produces the 'impact' effect.
	..()
