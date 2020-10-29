/datum/chorus_building/set_to_turf/growth/nutrient_syphon
	desc = "An organ whose purpose is to extract nutrients from the air. Can be placed anywhere with no range restriction."
	building_type_to_build = /obj/structure/chorus/nutrient_syphon
	build_time = 10
	resource_cost = list(/datum/chorus_resource/growth_nutrients = 5)
	build_distance = 0

/obj/structure/chorus/nutrient_syphon
	name = "nutrient syphon"
	desc = "Extracts vitamins and minerals straight from the air."
	icon_state = "growth_syphon"
	click_cooldown = 5 SECONDS

/obj/structure/chorus/nutrient_syphon/activate()
	owner.add_to_resource(/datum/chorus_resource/growth_nutrients, 1)
	playsound(src, 'sound/machines/pump.ogg', 50, 1)
	flick("growth_syphon_exert", src)

/datum/chorus_building/set_to_turf/growth/bitter
	desc = "A small teeth-filled hole, used to injure prey."
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
	health = 1
	density = 0
	var/damage = 45

/obj/structure/chorus/biter/chorus_click(var/mob/living/carbon/alien/chorus/c)
	if(c)
		to_chat(c, SPAN_WARNING("\The [src] automatically bites those who walk on it"))

/obj/structure/chorus/biter/Initialize(var/maploading, var/o)
	. = ..()
	GLOB.entered_event.register(get_turf(src), src, .proc/bite_victim)

/obj/structure/chorus/biter/Destroy()
	GLOB.entered_event.unregister(get_turf(src), src)
	. = ..()

/obj/structure/chorus/biter/proc/bite_victim(var/atom/a, var/mob/living/L)
	if(istype(L))
		if((owner && owner.is_follower(L)) || !can_activate(null, FALSE))
			return
		flick("growth_biter_attack", src)
		visible_message(SPAN_DANGER("\The [src] bites at \the [L]'s feet!"))
		if(istype(L, /mob/living/carbon/human))
			var/target_foot = pick(list(BP_L_FOOT, BP_R_FOOT))
			var/mob/living/carbon/human/H = L
			H.apply_damage(damage, BRUTE, target_foot)
		else
			L.adjustBruteLoss(damage)
