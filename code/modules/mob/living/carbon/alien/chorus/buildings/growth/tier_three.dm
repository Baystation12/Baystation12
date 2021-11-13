/datum/chorus_building/set_to_turf/growth/tendril
	desc = "A fleshy appendage adapt at wacking nearby foreign agents."
	building_type_to_build = /obj/structure/chorus/processor/sentry/tendril
	build_time = 30
	build_level = 3
	range = 0
	resource_cost = list(/datum/chorus_resource/growth_meat = 30)
	building_requirements = list(/obj/structure/chorus/gastrointestional_tract = 2)

/obj/structure/chorus/processor/sentry/tendril
	name = "tendril"
	desc = "A large, mucus-covered tentacle. It occasionally twitches."
	icon_state = "growth_tendril"
	health_max = 100
	activation_cost_resource = /datum/chorus_resource/growth_nutrients
	activation_cost_amount = 2
	click_cooldown = 3 SECONDS
	death_message = "flails aimlessly, then sinks into the ground."
	var/damage = 15
	var/penetration = 10

/obj/structure/chorus/processor/sentry/tendril/trigger_effect(var/list/targets)
	var/mob/living/L = pick(targets)
	flick("[initial(icon_state)]_attack", src)
	L.visible_message(
		SPAN_DANGER("\The [src] whips out at \the [L]!"),
		SPAN_DANGER("\The [src] lunges out and bludgeons you!"),
		SPAN_WARNING("You hear a whoosh, and then a muffled, heavy thump.")
	)
	playsound(src, 'sound/weapons/pierce.ogg', 50, 1)
	if(istype(L, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = L
		H.apply_damage(damage, BRUTE, BP_CHEST, armor_pen = penetration)
	else
		L.adjustBruteLoss(damage)
