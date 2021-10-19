/datum/chorus_building/set_to_turf/growth/tendril_thorned
	desc = "An upgraded tendril with a large boney spike at the end."
	building_type_to_build = /obj/structure/chorus/processor/sentry/tendril/thorned
	build_time = 45
	build_level = 4
	range = 0
	resource_cost = list(
		/datum/chorus_resource/growth_meat = 50,
		/datum/chorus_resource/growth_bones = 10
	)
	building_requirements = list(
		/obj/structure/chorus/processor/sentry/tendril = 3,
		/obj/structure/chorus/biter = 4
	)

/obj/structure/chorus/processor/sentry/tendril/thorned
	name = "thorned tendril"
	desc = "A large mucus covered tentacle."
	icon_state = "growth_tendril_thorned"
	damage = 30
	penetration = 30
	health_max = 300

/obj/structure/chorus/processor/sentry/tendrdil/thorned/Initialize()
	. = ..()
	desc += SPAN_NOTICE("This one has a large spike on the end.")

/datum/chorus_building/set_to_turf/growth/gastric_emitter
	desc = "Activate to spill acid on nearby tiles: watch out for your allies!"
	building_type_to_build = /obj/structure/chorus/gastric_emitter
	build_time = 70
	build_level = 4
	resource_cost = list(
		/datum/chorus_resource/growth_meat = 75,
		/datum/chorus_resource/growth_nutrients = 10
	)
	building_requirements = list(/obj/structure/chorus/biter = 3)

/obj/structure/chorus/gastric_emitter
	name = "gastric emitter"
	desc = "You can hear chemicals slosh in this fleshy sack."
	icon_state = "growth_gastric"
	click_cooldown = 30 SECONDS
	activation_cost_resource = /datum/chorus_resource/growth_nutrients
	activation_cost_amount = 15
	death_message = "ruptures, spilling its corrosive contents around itself."

/obj/structure/chorus/gastric_emitter/activate()
	flick("growth_gastric_emit", src)
	playsound(src, 'sound/machines/pump.ogg', 35, 1)
	visible_message(SPAN_DANGER("\The [src] exudes a nasty chemical!"))
	var/turf/cur_turf = get_turf(src)
	for(var/t in cur_turf.AdjacentTurfs())
		var/turf/T = t
		if(T.density)
			continue
		addtimer(CALLBACK(src, .proc/emit_acid, T), 0)

/obj/structure/chorus/gastric_emitter/proc/emit_acid(var/turf/T)
	var/obj/effect/effect/water/chempuff/chem = new(get_turf(src))
	chem.create_reagents(5)
	chem.reagents.add_reagent(/datum/reagent/acid/hydrochloric,5)
	chem.set_color()
	chem.set_up(get_ranged_target_turf(src, get_dir(src, T), 1))
