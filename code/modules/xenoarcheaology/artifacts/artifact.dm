/obj/machinery/artifact
	name = "alien artifact"
	desc = "A large alien device."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "ano00"
	var/icon_num = 0
	density = TRUE
	var/datum/artifact_effect/my_effect
	var/datum/artifact_effect/secondary_effect
	var/being_used = 0
	waterproof = FALSE

	//Stuff for damaging and breaking artifacts.
	var/max_health = 500
	var/health = 500
	///TRUE if artifact can be damaged, FALSE otherwise.
	var/can_damage = FALSE
	///The damage type that can harm the artifact.
	var/damage_type = DAM_SHARP
	///Minimum force needed to cause damage. Only applicable when being melee'd.
	var/min_force = 5
	///Extra descriptor added to artifact analyzer results.
	var/damage_desc = "The physical structure appears indestructable."
	var/destroyed = FALSE

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
	var/turf/T = loc
	if(!istype(T)) 	// We're inside a container or on null turf, either way stop processing effects
		return

	if(pulledby)
		check_triggers(/datum/artifact_trigger/proc/on_touch, pulledby)

	var/datum/gas_mixture/enivonment = T.return_air()
	if(enivonment.return_pressure() >= SOUND_MINIMUM_PRESSURE)
		check_triggers(/datum/artifact_trigger/proc/on_gas_exposure, enivonment)

	for(var/datum/artifact_effect/effect in list(my_effect, secondary_effect))
		effect.process()

/obj/machinery/artifact/attack_robot(mob/living/user)
	if(!CanPhysicallyInteract(user))
		return
	check_triggers(/datum/artifact_trigger/proc/on_touch, user)

/obj/machinery/artifact/attack_hand(mob/living/user)
	. = ..()
	visible_message("[user] touches \the [src].")
	check_triggers(/datum/artifact_trigger/proc/on_touch, user)

/obj/machinery/artifact/attackby(obj/item/W, mob/living/user)
	. = ..()
	check_triggers(/datum/artifact_trigger/proc/on_hit, W, user)

/obj/machinery/artifact/Bumped(M)
	..()
	check_triggers(/datum/artifact_trigger/proc/on_bump, M)

/obj/machinery/artifact/bullet_act(var/obj/item/projectile/P)
	check_triggers(/datum/artifact_trigger/proc/on_hit, P)

/obj/machinery/artifact/ex_act(severity)
	if(check_triggers(/datum/artifact_trigger/proc/on_explosion, severity))
		return
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			if (prob(50))
				qdel(src)

/obj/machinery/artifact/Move()
	..()
	if(my_effect)
		my_effect.UpdateMove()
	if(secondary_effect)
		secondary_effect.UpdateMove()

/obj/machinery/artifact/water_act(depth)
	check_triggers(/datum/artifact_trigger/proc/on_water_act, depth)


//Damage/Destruction procs

/obj/machinery/artifact/examine(mob/user)
	. = ..()

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
	health = rand(100, 200)
	max_health = health

	var/damage_types = list(DAM_SHARP, DAM_BULLET, DAM_EDGE, DAM_LASER)
	for (var/datum/artifact_effect/A in list(my_effect, secondary_effect))
		if (istype(A.trigger, /datum/artifact_trigger/force))
			damage_types -= list(DAM_SHARP, DAM_BULLET, DAM_EDGE)

		if (istype(A.trigger, /datum/artifact_trigger/energy))
			damage_types -= DAM_LASER

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
		if (DAM_SHARP)
			damage_desc += "physical attack from serrated objects."
		if (DAM_BULLET)
			damage_desc += "high speed kinetic impact."
		if (DAM_EDGE)
			damage_desc += "physical strikes from edged objects."
		if (DAM_LASER)
			damage_desc += "concentrated high-energy bursts."

/**
 * Handles damage the artifact receives.
 * Sends a visual message when the aritfacts health value falls below certain points.
 * Once the artifact has 0 or less health:
 *   Calls the effect(s) 'destroyed_effect()' proc.
 *   Sets the artifacts icon state to its 'destroyed' state.
 * If the artifact has > 0 health, calls the effect(s) 'holder_damaged()' proc. This may or may not be removed.
 *
 * @param damage int The damage dealt.
 */
/obj/machinery/artifact/proc/handle_damage(damage)
	if (destroyed)
		return

	var/initialhealth = health
	health = max(0, health - damage)
	if (health < max_health / 4 && initialhealth >= max_health / 4)
		visible_message("\The [src] looks like it's about to break!" )
	else if (health < max_health / 2 && initialhealth >= max_health / 2)
		visible_message("\The [src] looks seriously damaged!" )
	else if (health < max_health * 3/4 && initialhealth >= max_health * 3/4)
		visible_message("\The [src] shows signs of damage!" )
	update_icon()



	playsound(get_turf(src), 'sound/effects/Glasshit.ogg', 75, TRUE)

	for (var/datum/artifact_effect/A in list(my_effect, secondary_effect))
		A.holder_damaged(health, damage)

	if (!health)
		handle_destruction()
/**
 * Handles the 'destruction' of the artifact.
 * Icon state is updated to the corresponding 'destroyed' state.
 * Client mobs are 'flashed' for added effect.
 * Effects are deleted so they can't be triggered again.
 * 'destroyed' is set to TRUE to prevent re-triggering the destroyed event.
 */
/obj/machinery/artifact/proc/handle_destruction()
	visible_message(SPAN_DANGER("\The [src] breaks apart and explodes in a wave of energy!"), SPAN_DANGER("You hear something break apart and feel a wave of energy hit you!"))
	playsound(get_turf(src), 'sound/effects/Glassbr3.ogg', 75, TRUE)
	icon_state = "ano[icon_num]2"

	for (var/mob/living/carbon/M in oview(src))
		if (M.client)
			M.flash_eyes()

	my_effect.destroyed_effect() //only do primary to avoid nuking everything.

	QDEL_NULL(my_effect)
	QDEL_NULL(secondary_effect)

	destroyed = TRUE

/obj/machinery/artifact/attackby(obj/item/W, mob/living/user)
	. = ..()

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if (W.sharp && damage_type == DAM_SHARP || W.edge && damage_type == DAM_EDGE)
		user.do_attack_animation(src)

		if (W.force < min_force)
			visible_message(SPAN_DANGER("\The [user] hits \the [src] with \the [W], but it doesn't even scratch it!"))
			return

		handle_damage(W.force)
	else
		visible_message(SPAN_DANGER("\The [user] hits \the [src] with \the [W], but it bounces off!"))

/obj/machinery/artifact/bullet_act(obj/item/projectile/P)
	. = ..()

	if (P.damage_flags & damage_type)
		handle_damage(P.damage)
