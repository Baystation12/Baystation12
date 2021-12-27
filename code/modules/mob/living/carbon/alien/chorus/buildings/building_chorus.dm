/obj/structure/chorus
	health_max = 10
	var/datum/chorus/owner
	icon = 'icons/obj/cult.dmi'
	var/last_click = 0
	var/click_cooldown = 10
	var/activation_cost_resource
	var/activation_cost_amount
	density = TRUE
	anchored = TRUE
	var/death_message = "crumbles!"
	var/death_sound = 'sound/effects/splat.ogg'

/obj/structure/chorus/Initialize(var/maploading, var/o)
	. = ..()
	if(o)
		owner = o
		owner.add_building(src)

/obj/structure/chorus/Destroy()
	if(owner)
		owner.remove_building(src)
	. = ..()

/obj/structure/chorus/proc/chorus_click(var/mob/living/carbon/alien/chorus/C)
	if(can_activate(C))
		activate(C)
		last_click = world.time

/obj/structure/chorus/proc/has_resources(mob/living/carbon/alien/chorus/C, warning = TRUE)
	if(!owner)
		return FALSE
	if(activation_cost_resource && !owner.has_enough_resource(activation_cost_resource, activation_cost_amount))
		if(warning && C)
			var/datum/chorus_resource/cr = activation_cost_resource
			to_chat(C, SPAN_WARNING("You need more [initial(cr.name)] to activate \the [src]."))
		return FALSE
	return TRUE

/obj/structure/chorus/proc/can_activate(var/mob/living/carbon/alien/chorus/C, var/warning = TRUE)
	if(!owner)
		return FALSE
	if(last_click + click_cooldown < world.time && (!C || C.chorus_type == owner && get_dist(C, src) <= 1))
		if(activation_cost_resource && !owner.use_resource(activation_cost_resource, activation_cost_amount))
			if(warning && C)
				var/datum/chorus_resource/cr = activation_cost_resource
				to_chat(C, SPAN_WARNING("You need more [initial(cr.name)] to activate \the [src]."))
			return FALSE
		return TRUE
	return FALSE

/obj/structure/chorus/proc/activate(mob/living/carbon/alien/chorus/C)
	return

/obj/structure/chorus/handle_death_change(new_death_state)
	..()
	if (new_death_state)
		visible_message(SPAN_WARNING("\The [src] [death_message]"))
		playsound(loc, death_sound, 50, TRUE)
		qdel(src)
