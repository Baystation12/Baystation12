/datum/chorus_form/growth
	name = "Growth"
	desc = "A parasite adapted to life on ships and stations"
	form_state = "growth"
	possession_state = "horror"
	join_message = "Your loyalties and emotions are overridden. What was once a monster is now your child, your "
	leave_message = "You feel in control again. As if your memories and thoughts aren't overriden by "
	implant_state = "implant_growth"
	implant_name = "strange parasite"
	resources = list(
			/datum/chorus_resource/growth_nutrients,
			/datum/chorus_resource/growth_meat,
			/datum/chorus_resource/growth_bones
	)
	buildings = list(
			/datum/chorus_building/set_to_turf/growth/nutrient_syphon,
			/datum/chorus_building/set_to_turf/growth/articulation_organ,
			/datum/chorus_building/set_to_turf/growth/nerve_cluster,
			/datum/chorus_building/set_to_turf/growth/sight_organ,
			/datum/chorus_building/set_to_turf/growth/gastrointestional_tract,
			/datum/chorus_building/set_to_turf/growth/ossifier,
			/datum/chorus_building/set_to_turf/growth/sinoatrial_node,
			/datum/chorus_building/muscular_coat,
			/datum/chorus_building/set_to_turf/growth/maw,
			/datum/chorus_building/set_to_turf/growth/tendril,
			/datum/chorus_building/set_to_turf/growth/bitter,
			/datum/chorus_building/set_to_turf/growth/converter,
			/datum/chorus_building/set_to_turf/growth/tendril_thorned,
			/datum/chorus_building/set_to_turf/growth/bone_shooter,
			/datum/chorus_building/set_to_turf/growth/gastric_emitter,
			/datum/chorus_building/set_to_turf/growth/spinal_column,
			/datum/chorus_building/set_to_turf/growth/womb
	)
	var/released_eggs = 0 //Growth's win condition.

/datum/chorus_form/growth/setup_form(var/mob/living/chorus/c)
	..()
	var/turf/T = get_turf(c)
	T.ChangeTurf(/turf/simulated/floor/scales)

/datum/chorus_form/growth/self_click(var/mob/living/chorus/c)
	c.add_to_resource(/datum/chorus_resource/growth_nutrients, 1)
	sound_to(c, 'sound/effects/blobattack.ogg')
	flick("growth_chug", c)

/datum/chorus_form/growth/proc/egg_released(var/mob/living/chorus/C)
	released_eggs += 1
	to_chat(C, "<span class='notice'>One of your eggs has made it to space!</span>")


/datum/chorus_form/growth/print_end_game_screen(var/mob/living/chorus/C)
	..()
	if(released_eggs)
		to_world("<span class='notice'>Spawned [released_eggs] children!</span>")
	else
		to_world("<span class='danger'>Last of its kind..</span>")