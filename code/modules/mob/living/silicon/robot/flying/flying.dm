/mob/living/silicon/robot/flying
	desc = "A utility robot with an anti-gravity hover unit and a lightweight frame."
	icon = 'icons/mob/robots_flying.dmi'
	icon_state = "drone-standard"
	module_category = ROBOT_MODULE_TYPE_FLYING
	dismantle_type = /obj/item/robot_parts/robot_suit/flyer
	power_efficiency = 0.75

	// They are not very heavy or strong.
	mob_size =       MOB_SMALL
	mob_bump_flag =  SIMPLE_ANIMAL
	mob_swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	mob_push_flags = MONKEY|SLIME|SIMPLE_ANIMAL

	//[inf]
	speech_sounds = list(
		'sound/voice/emotes/robot_talk_heavy_1.ogg',
		'sound/voice/emotes/robot_talk_heavy_2.ogg',
		'sound/voice/emotes/robot_talk_heavy_3.ogg',
		'sound/voice/emotes/robot_talk_heavy_4.ogg'
	)
	//[/inf]

/mob/living/silicon/robot/flying/initialize_components()
	components["actuator"] =       new/datum/robot_component/actuator(src)
	components["radio"] =          new/datum/robot_component/radio(src)
	components["power cell"] =     new/datum/robot_component/cell(src)
	components["diagnosis unit"] = new/datum/robot_component/diagnosis_unit(src)
	components["camera"] =         new/datum/robot_component/camera(src)
	components["comms"] =          new/datum/robot_component/binary_communication(src)
	components["armour"] =         new/datum/robot_component/armour/light(src)

/mob/living/silicon/robot/flying/Life()
	. = ..()
	if(incapacitated() || !is_component_functioning("actuator"))
		stop_flying()
	else
		start_flying()

/mob/living/silicon/robot/flying/proc/start_flying()
	pass_flags |= PASS_FLAG_TABLE
	default_pixel_y = 0
	make_floating(10)

/mob/living/silicon/robot/flying/proc/stop_flying()
	pass_flags &= ~PASS_FLAG_TABLE
	default_pixel_y = -8
	stop_floating()

/mob/living/silicon/robot/flying/death()
	. = ..()
	if(!QDELETED(src) && stat == DEAD)
		stop_flying()

/mob/living/silicon/robot/flying/Allow_Spacemove()
	return (pass_flags & PASS_FLAG_TABLE) || ..()

/mob/living/silicon/robot/flying/can_fall(var/anchor_bypass = FALSE, var/turf/location_override = loc)
	return !Allow_Spacemove()

/mob/living/silicon/robot/flying/can_overcome_gravity()
	return Allow_Spacemove()
