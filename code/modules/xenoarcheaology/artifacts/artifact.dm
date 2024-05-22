/obj/machinery/artifact
	name = "alien artifact"
	desc = "A large alien device."
	icon = 'icons/obj/xenoarchaeology_finds.dmi'
	icon_state = "ano00"
	var/icon_num = 0
	density = TRUE
	var/datum/artifact_effect/my_effect
	var/datum/artifact_effect/secondary_effect
	var/being_used = 0
	waterproof = FALSE

	health_max = 500
	health_min_damage = 5
	damage_hitsound = 'sound/effects/Glasshit.ogg'

	///TRUE if artifact can be damaged, FALSE otherwise.
	var/can_damage = FALSE
	///The damage type that can harm the artifact.
	var/damage_type = DAMAGE_FLAG_SHARP
	///Extra descriptor added to artifact analyzer results.
	var/damage_desc = "The physical structure appears indestructable."

/obj/machinery/artifact/New()
	..()

	var/effecttype = pick(typesof(/datum/artifact_effect) - /datum/artifact_effect)
	my_effect = new effecttype(src)

	if(prob(75))
		effecttype = pick(typesof(/datum/artifact_effect) - /datum/artifact_effect)
		secondary_effect = new effecttype(src)
		if(prob(75))
			secondary_effect.ToggleActivate(0)

	icon_num = rand(0, 11)
	icon_state = "ano[icon_num]0"
	if(icon_num == 7 || icon_num == 8)
		name = "large crystal"
		desc = pick("It shines faintly as it catches the light.",
		"It appears to have a faint inner glow.",
		"It seems to draw you inward as you look it at.",
		"Something twinkles faintly as you look at it.",
		"It's mesmerizing to behold.")
	else if(icon_num == 9)
		name = "alien computer"
		desc = "It is covered in strange markings."
	else if(icon_num == 10)
		desc = "A large alien device, there appear to be some kind of vents in the side."
	else if(icon_num == 11)
		name = "sealed alien pod"
		desc = "A strange alien device."

	setup_destructibility()

/obj/machinery/artifact/Destroy()
	QDEL_NULL(my_effect)
	QDEL_NULL(secondary_effect)
	. = ..()

/obj/machinery/artifact/proc/check_triggers(trigger_proc)
	. = FALSE
	for(var/datum/artifact_effect/effect in list(my_effect, secondary_effect))
		if (!effect.trigger)
			return

		var/triggered = call(effect.trigger, trigger_proc)(arglist(args.Copy(2)))
		if(effect.trigger.toggle && triggered)
			effect.ToggleActivate(1)
			. = TRUE
		else if(effect.activated != triggered)
			effect.ToggleActivate(1)
			. = TRUE

		if (. && istype(effect.trigger, /datum/artifact_trigger/touch))
			effect.DoEffectTouch(arglist(args.Copy(2)))

/obj/machinery/artifact/Process()
	if (!isturf(loc)) // We're not on a valid turf, check for the special conditions of an anomaly container
		if (istype(loc, /obj/machinery/anomaly_container))
			var/obj/machinery/anomaly_container/container = loc
			if (container.contained == src && !container.broken)
				// We're inside an anomaly container, we're the contained anomaly, and the container is not broken.
				return
		else
			// We're not inside an anomaly container nor a turf
			return
	// We're on a turf or inside a broken or invalid anomaly container

	if(pulledby)
		check_triggers(TYPE_PROC_REF(/datum/artifact_trigger, on_touch), pulledby)

	var/datum/gas_mixture/enivonment = loc.return_air()
	if(enivonment.return_pressure() >= SOUND_MINIMUM_PRESSURE)
		check_triggers(TYPE_PROC_REF(/datum/artifact_trigger, on_gas_exposure), enivonment)

	for(var/datum/artifact_effect/effect in list(my_effect, secondary_effect))
		effect.process()

/obj/machinery/artifact/attack_robot(mob/living/user)
	if(!CanPhysicallyInteract(user))
		return
	check_triggers(TYPE_PROC_REF(/datum/artifact_trigger, on_touch), user)

/obj/machinery/artifact/attack_hand(mob/living/user)
	. = ..()
	visible_message("[user] touches \the [src].")
	check_triggers(TYPE_PROC_REF(/datum/artifact_trigger, on_touch), user)

/obj/machinery/artifact/use_tool(obj/item/W, mob/living/user, list/click_params)
	. = ..()
	check_triggers(TYPE_PROC_REF(/datum/artifact_trigger, on_hit), W, user)

/obj/machinery/artifact/Bumped(M)
	..()
	check_triggers(TYPE_PROC_REF(/datum/artifact_trigger, on_bump), M)

/obj/machinery/artifact/bullet_act(obj/item/projectile/P)
	check_triggers(TYPE_PROC_REF(/datum/artifact_trigger, on_hit), P)

/obj/machinery/artifact/ex_act(severity)
	if(check_triggers(TYPE_PROC_REF(/datum/artifact_trigger, on_explosion), severity))
		return
	switch(severity)
		if(EX_ACT_DEVASTATING)
			qdel(src)
		if(EX_ACT_HEAVY)
			if (prob(50))
				qdel(src)

/obj/machinery/artifact/Move()
	..()
	if(my_effect)
		my_effect.UpdateMove()
	if(secondary_effect)
		secondary_effect.UpdateMove()

/obj/machinery/artifact/water_act(depth)
	check_triggers(TYPE_PROC_REF(/datum/artifact_trigger, on_water_act), depth)


//Damage/Destruction procs

/obj/machinery/artifact/examine_damage_state(mob/user)
	var/health = get_current_health()
	var/max_health = get_max_health()
	if (health <= 0)
		to_chat(user, SPAN_NOTICE("It is inert, dead and quiet."))
	else if (health < (max_health * 0.25))
		to_chat(user, SPAN_DANGER("It looks like its almost shattered!"))
	else if (health < (max_health * 0.5))
		to_chat(user, SPAN_WARNING("It is badly damaged, and is getting close to breaking apart."))
	else if (health < (max_health * 0.75))
		to_chat(user, SPAN_NOTICE("It is moderately damaged, cracks visible on its surface."))
	else if (health < max_health)
		to_chat(user, SPAN_NOTICE("It has minor damage."))

/**
 * Sets up the artifacts destructibility by doing the following:
 * Gives a randomized health/maxhealth value.
 * Removes damage types based on triggers. Ex. Artifact can't be damaged by hitting/shooting if an effect has the 'force' trigger.
 *    Note: If there are two effects and one has the 'force' trigger, and the other 'energy', the artifact will be invulnerable.
 *    This is to prevent damaging the artifact while trying to turn on its effects.
 * Adds scan data used by the anomaly analyzer that details how to damage the artifact.
 */
/obj/machinery/artifact/proc/setup_destructibility()
	can_damage = TRUE
	set_max_health(rand(100, 200))

	var/damage_types = list(DAMAGE_FLAG_SHARP, DAMAGE_FLAG_BULLET, DAMAGE_FLAG_EDGE, DAMAGE_FLAG_LASER)
	for (var/datum/artifact_effect/A in list(my_effect, secondary_effect))
		if (istype(A.trigger, /datum/artifact_trigger/force))
			damage_types -= list(DAMAGE_FLAG_SHARP, DAMAGE_FLAG_BULLET, DAMAGE_FLAG_EDGE)

		if (istype(A.trigger, /datum/artifact_trigger/energy))
			damage_types -= DAMAGE_FLAG_LASER

		if (!length(damage_types)) //can't trigger effects without damaging us
			can_damage = FALSE
			return

	damage_type = pick(damage_types)
	set_damage_description(damage_type)

/**
 * Adds additional scan data for the anomaly analyzer, detailing how the artifact can be damaged.
 *
 * @param damage_type int Type of damage that the artifact can receive, FALSE or null means it is indestructible.
 */
/obj/machinery/artifact/proc/set_damage_description(damage_type)

	if (!damage_type)
		return

	damage_desc = "The physical structure is vulnerable to "
	switch(damage_type)
		if (DAMAGE_FLAG_SHARP)
			damage_desc += "physical attack from serrated objects."
		if (DAMAGE_FLAG_BULLET)
			damage_desc += "high speed kinetic impact."
		if (DAMAGE_FLAG_EDGE)
			damage_desc += "physical strikes from edged objects."
		if (DAMAGE_FLAG_LASER)
			damage_desc += "concentrated high-energy bursts."


/obj/machinery/artifact/post_health_change(health_mod, prior_health, damage_type)
	..()
	queue_icon_update()
	if (health_mod < 0)
		for (var/datum/artifact_effect/A in list(my_effect, secondary_effect))
			A.holder_damaged(get_current_health(), abs(health_mod))


/obj/machinery/artifact/on_death()
	..()
	visible_message(SPAN_DANGER("\The [src] breaks apart and explodes in a wave of energy!"), SPAN_DANGER("You hear something break apart and feel a wave of energy hit you!"))
	playsound(get_turf(src), 'sound/effects/Glassbr3.ogg', 75, TRUE)
	icon_state = "ano[icon_num]2"

	for (var/mob/living/carbon/M in oview(src))
		if (M.client)
			M.flash_eyes()

	my_effect.destroyed_effect() //only do primary to avoid nuking everything.

	QDEL_NULL(my_effect)
	QDEL_NULL(secondary_effect)


/obj/machinery/artifact/can_damage_health(damage, damage_type, damage_flags)
	if (!can_damage)
		return FALSE
	if (!HAS_FLAGS(damage_flags, src.damage_type))
		return FALSE
	return ..()
