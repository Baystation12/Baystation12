/datum/chorus_building/set_to_turf/growth/tendril_thorned
	desc = "An upgraded tendril with a large boney spike at the end"
	building_type_to_build = /obj/structure/chorus/processor/sentry/tendril/thorned
	build_time = 45
	build_level = 4
	range = 0
	resource_cost = list(/datum/chorus_resource/growth_meat = 50, /datum/chorus_resource/growth_bones = 10)
	building_requirements = list(/obj/structure/chorus/processor/sentry/tendril = 3,
								/obj/structure/chorus/biter = 4)

/obj/structure/chorus/processor/sentry/tendril/thorned
	name = "thorned tendril"
	desc = "A large mucus covered tentacle. <span class='notice'>This one has a large spike on the end</span>"
	icon_state = "growth_tendril_thorned"
	damage = 14

/datum/chorus_building/set_to_turf/growth/bone_shooter
	desc = "Automatically shoots bone fragments at enemies"
	building_type_to_build = /obj/structure/chorus/processor/sentry/bone_shooter
	build_time = 60
	build_level = 4
	range = 0
	resource_cost = list(/datum/chorus_resource/growth_meat = 15, /datum/chorus_resource/growth_bones = 30)

/obj/structure/chorus/processor/sentry/bone_shooter
	name = "bone spitter"
	desc = "A group of meat fashioned together into a form not unsimilar to a turret"
	icon_state = "growth_bone_shooter"
	health = 20
	range = 3
	gives_sight = FALSE
	activation_cost_resource = /datum/chorus_resource/growth_bones
	activation_cost_amount = 2
	click_cooldown = 8 SECONDS

/obj/structure/chorus/processor/sentry/bone_shooter/trigger_effect(var/list/targets)
	var/mob/living/T = get_atom_closest_to_atom(src, targets)
	var/obj/item/projectile/bone_shard/bs = new(get_turf(src))
	visible_message("<b>\The [src]</b> fires a small dart at \the [T]")
	bs.firer = src
	bs.launch(T, BP_CHEST)

/obj/item/projectile/bone_shard
	name = "bone shard"
	damage = 10
	icon_state = "sliver"
	damage_type = BRUTE
	damage_flags = 0

/datum/chorus_building/set_to_turf/growth/gastric_emitter
	desc = "Activate to spill acid on nearby tiles: watch out for your allies!"
	building_type_to_build = /obj/structure/chorus/gastric_emitter
	build_time = 70
	build_level = 4
	resource_cost = list(/datum/chorus_resource/growth_meat = 75,
						/datum/chorus_resource/growth_nutrients = 10)
	building_requirements = list(/obj/structure/chorus/biter = 3)

/obj/structure/chorus/gastric_emitter
	name = "gastric emitter"
	desc = "You can hear caustic chemicals slosh in this fleshy sack."
	icon_state = "growth_gastric"
	click_cooldown = 30 SECONDS
	gives_sight = FALSE
	activation_cost_resource = /datum/chorus_resource/growth_nutrients
	activation_cost_amount = 15

/obj/structure/chorus/gastric_emitter/activate()
	flick("growth_gastric_emit", src)
	playsound(src, 'sound/machines/pump.ogg', 35, 1)
	var/turf/cur_turf = get_turf(src)
	for(var/t in cur_turf.AdjacentTurfs())
		var/turf/T = t
		if(T.density)
			continue
		spawn(0)
			var/obj/effect/effect/water/chempuff/chem = new(get_turf(src))
			chem.create_reagents(5)
			chem.reagents.add_reagent(/datum/reagent/acid/hydrochloric,5)
			chem.set_color()
			chem.set_up(get_ranged_target_turf(src, get_dir(src, T), 1))