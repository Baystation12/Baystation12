/obj/structure/boulder
	name = "rocky debris"
	desc = "Leftover rock from an excavation, it's been partially dug out already but there's still a lot to go."
	icon = 'icons/obj/boulder.dmi'
	icon_state = "boulder1"
	density = TRUE
	opacity = 1
	anchored = TRUE
	var/excavation_level = 0
	var/datum/geosample/geological_data
	var/datum/artifact_find/artifact_find
	var/last_act = 0

/obj/structure/boulder/New()
	..()
	icon_state = "boulder[rand(1,4)]"
	excavation_level = rand(5, 50)

/obj/structure/boulder/Destroy()
	qdel(geological_data)
	qdel(artifact_find)
	..()


/obj/structure/boulder/use_tool(obj/item/tool, mob/user, list/click_params)
	// Core Sampler
	if (istype(tool, /obj/item/device/core_sampler))
		geological_data.artifact_distance = rand(-100, 100) / 100
		geological_data.artifact_id = artifact_find.artifact_id
		var/obj/item/device/core_sampler/core_sampler = tool
		core_sampler.sample_item(src, user)
		return TRUE

	// Depth Scanner
	if (istype(tool, /obj/item/device/depth_scanner))
		var/obj/item/device/depth_scanner/depth_scanner = tool
		depth_scanner.scan_atom(user, src)
		return TRUE

	// Measuring Tape
	if (istype(tool, /obj/item/device/measuring_tape))
		user.visible_message(
			SPAN_NOTICE("\The [user] extends \a [tool] towards \the [src]."),
			SPAN_NOTICE("You extend \the [tool] towards \the [src].")
		)
		if (!user.do_skilled(1.5 SECONDS, SKILL_SCIENCE, src) || !user.use_sanity_check(src, tool))
			return TRUE
		to_chat(user, SPAN_INFO("\The [src] has been excavated to a depth of [excavation_level]cm."))
		return TRUE

	// Pickaxe - Excavate
	if (istype(tool, /obj/item/pickaxe))
		var/obj/item/pickaxe/pickaxe = tool
		user.visible_message(
			SPAN_NOTICE("\The [user] starts [pickaxe.drill_verb] \the [src] with \a [pickaxe]."),
			SPAN_NOTICE("You start [pickaxe.drill_verb] \the [src] with \the [pickaxe].")
		)
		if (!do_after(user, pickaxe.digspeed, src, DO_PUBLIC_UNIQUE) || !user.use_sanity_check(src, tool))
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] finished [pickaxe.drill_verb] \the [src] with \a [pickaxe]."),
			SPAN_NOTICE("You finish [pickaxe.drill_verb] \the [src] with \the [pickaxe].")
		)
		excavation_level += pickaxe.excavation_amount
		if (excavation_level > 200)
			visible_message(
				SPAN_WARNING("\The [src] suddenly crumbles away. Any secrets it was holding are long gone.")
			)
			qdel_self()
			return TRUE
		if (prob(excavation_level))
			if (artifact_find)
				var/spawn_type = artifact_find.artifact_find_type
				var/obj/artifact = new spawn_type(get_turf(src))
				if (istype(artifact, /obj/machinery/artifact))
					var/obj/machinery/artifact/machine = artifact
					if (machine.my_effect)
						machine.my_effect.artifact_id = artifact_find.artifact_id
				visible_message(
					SPAN_WARNING("\The [src] suddenly crumbles away, revealing \a [artifact].")
				)
			else
				visible_message(
					SPAN_WARNING("\The [src] suddenly crumbles away, but there was nothing of interest inside.")
				)
			qdel_self()
		return TRUE

	return ..()


/obj/structure/boulder/Bumped(AM)
	. = ..()
	if(istype(AM,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = AM
		var/obj/item/pickaxe/P = H.get_inactive_hand()
		if(istype(P))
			use_tool(P, H)

	else if(istype(AM,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = AM
		if(istype(R.module_active,/obj/item/pickaxe))
			use_tool(R.module_active,R)
