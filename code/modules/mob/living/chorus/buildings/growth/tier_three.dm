/datum/chorus_building/set_to_turf/growth/tendril
	desc = "A fleshy appendage adapt at wacking nearby foreign agents"
	building_type_to_build = /obj/structure/chorus/processor/sentry/tendril
	build_time = 30
	build_level = 3
	range = 0
	resource_cost = list(/datum/chorus_resource/growth_meat = 30)
	building_requirements = list(/obj/structure/chorus/gastrointestional_tract = 2)

/obj/structure/chorus/processor/sentry/tendril
	name = "tendril"
	desc = "A large mucus covered tentacle"
	icon_state = "growth_tendril"
	health = 100
	gives_sight = FALSE
	activation_cost_resource = /datum/chorus_resource/growth_nutrients
	activation_cost_amount = 2
	click_cooldown = 3 SECONDS
	var/damage = 10
	var/penetration = 8

/obj/structure/chorus/processor/sentry/tendril/trigger_effect(var/list/targets)
	var/mob/living/L = pick(targets)
	flick("[initial(icon_state)]_attack", src)
	visible_message("<span class='danger'>\The [src] whips out at \the [L]!</span>")
	if(istype(L, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = L
		H.apply_damage(damage, BRUTE, BP_CHEST, armor_pen = penetration)
	else
		L.adjustBruteLoss(damage)

/datum/chorus_building/set_to_turf/growth/converter
	desc = "An immunity building organ: turns pesky foreign agents into loyal thralls"
	building_type_to_build = /obj/structure/chorus/converter/growth
	build_time = 25
	build_level = 3
	range = 0
	resource_cost = list(
		/datum/chorus_resource/growth_meat = 30,
		/datum/chorus_resource/growth_bones = 15
	)
	building_requirements = list(/obj/structure/chorus/biter = 1)

/obj/structure/chorus/converter/growth
	name = "parasite adapter"
	desc = "An odd tentacle with a disgusting looking claw at the end"
	icon_state = "growth_converter"
	gives_sight = FALSE