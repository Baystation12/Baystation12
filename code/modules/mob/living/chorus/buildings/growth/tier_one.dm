/datum/chorus_building/set_to_turf/growth/nutrient_syphon
	desc = "An organ whose purpose is to extract nutrients from the air."
	building_type_to_build = /obj/structure/chorus/nutrient_syphon
	build_time = 10
	resource_cost = list(/datum/chorus_resource/growth_nutrients = 5)

/obj/structure/chorus/nutrient_syphon
	name = "nutrient syphon"
	desc = "Extracts vitamins and minerals straight from the air"
	icon_state = "growth_syphon"
	click_cooldown = 5 SECONDS
	gives_sight = FALSE

/obj/structure/chorus/nutrient_syphon/activate()
	owner.add_to_resource(/datum/chorus_resource/growth_nutrients, 2)
	playsound(src, 'sound/machines/pump.ogg', 50, 1)
	flick("growth_syphon_exert", src)

/datum/chorus_building/set_to_turf/growth/articulation_organ
	desc = "A small mouth used to talk to lesser beings."
	building_type_to_build = /obj/structure/chorus/pylon/articulation_organ
	build_time = 30
	resource_cost = list(/datum/chorus_resource/growth_nutrients = 10)

/obj/structure/chorus/pylon/articulation_organ
	name = "articulation organ"
	desc = "A organic facsimile to a mouth without teeth."
	icon_state = "growth_articulation"
	speaking_verb = "wails"
	density = FALSE
	click_cooldown = 5 SECONDS
	gives_sight = FALSE

/obj/structure/chorus/pylon/articulation_organ/speak(var/message)
	..()
	playsound(src, 'sound/voice/hiss5.ogg', 25, 1)
	flick("growth_articulation_exert", src)

/datum/chorus_building/set_to_turf/growth/nerve_cluster
	desc = "A mass of twitching nerves used to grow your organs faster"
	building_type_to_build = /obj/structure/chorus/construct_bonus/nerve_cluster
	build_time = 30
	resource_cost = list(/datum/chorus_resource/growth_nutrients = 20)

/obj/structure/chorus/construct_bonus/nerve_cluster
	name = "nerve cluster"
	desc = "A cluster of nerve endings sprouting from the floor"
	icon_state = "growth_nerves"
	gives_sight = FALSE
	density = FALSE

/datum/chorus_building/set_to_turf/growth/sight_organ
	desc = "An eye to see the world, inside and out."
	building_type_to_build = /obj/structure/chorus/sight_organ
	build_time = 10
	resource_cost = list(/datum/chorus_resource/growth_nutrients = 5)

/obj/structure/chorus/sight_organ
	name = "sight organ"
	desc = "An eye on a stalk... it seems to look about the room."
	icon_state = "growth_eye"
	density = FALSE

/datum/chorus_building/set_to_turf/growth/bitter
	desc = "A small teeth-filled hole, used to injure prey"
	building_type_to_build = /obj/structure/chorus/biter
	build_time = 20
	build_level = 1
	range = 0
	resource_cost = list(
		/datum/chorus_resource/growth_nutrients = 30
	)

/obj/structure/chorus/biter
	name = "biter"
	desc = "a pit filled with teeth, capable of biting at those who step on it."
	icon_state = "growth_biter"
	activation_cost_resource = /datum/chorus_resource/growth_nutrients
	activation_cost_amount = 5
	gives_sight = FALSE
	health = 1
	density = 0
	var/damage = 45

/obj/structure/chorus/biter/chorus_click(var/mob/living/chorus/c)
	to_chat(c, "<span class='warning'>\The [src] automatically bites those who walk on it</span>")

/obj/structure/chorus/biter/Initialize(var/maploading, var/o)
	. = ..()
	GLOB.entered_event.register(get_turf(src), src, .proc/bite_victim)

/obj/structure/chorus/biter/Destroy()
	GLOB.entered_event.unregister(get_turf(src), src)
	. = ..()

/obj/structure/chorus/biter/proc/bite_victim(var/atom/a, var/mob/living/L)
	if(istype(L))
		if((owner && owner.get_implant(L)) || !can_activate(owner))
			return
		flick("growth_biter_attack", src)
		visible_message("<span class='danger'>\The [src] bites at \the [L]'s feet!</span>")
		if(istype(L, /mob/living/carbon/human))
			var/target_foot = pick(list(BP_L_FOOT, BP_R_FOOT))
			var/mob/living/carbon/human/H = L
			H.apply_damage(damage, BRUTE, target_foot)
		else
			L.adjustBruteLoss(damage)
