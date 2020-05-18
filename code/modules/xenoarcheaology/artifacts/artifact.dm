/obj/machinery/artifact
	name = "alien artifact"
	desc = "A large alien device."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "ano00"
	var/icon_num = 0
	density = 1
	var/datum/artifact_effect/my_effect
	var/datum/artifact_effect/secondary_effect
	var/being_used = 0

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

/obj/machinery/artifact/Destroy()
	QDEL_NULL(my_effect)
	QDEL_NULL(secondary_effect)
	. = ..()

/obj/machinery/artifact/proc/check_triggers(trigger_proc)
	. = FALSE
	for(var/datum/artifact_effect/effect in list(my_effect, secondary_effect))
		var/triggered = call(effect.trigger, trigger_proc)(arglist(args.Copy(2)))
		if(effect.trigger.toggle && triggered)
			effect.ToggleActivate(1)
			. = TRUE
		else if(effect.activated != triggered)
			effect.ToggleActivate(1)
			. = TRUE

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

/obj/machinery/artifact/attackby(obj/item/weapon/W, mob/living/user)
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
