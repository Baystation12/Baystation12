/datum/chorus_building/set_to_turf/growth/womb
	desc = "Sends an egg flying out towards space. Extremely distructive but can be guided by building walls around areas you don't want your eggs flung. <b>This is your end game</b>"
	building_type_to_build = /obj/structure/chorus/growth_womb
	build_time = 100
	build_level = 5
	unique = TRUE
	resource_cost = list(
		/datum/chorus_resource/growth_nutrients = 200,
		/datum/chorus_resource/growth_meat = 100,
		/datum/chorus_resource/growth_bones = 60
	)

/obj/structure/chorus/growth_womb
	name = "womb"
	icon_state = "growth_womb"
	desc = "A disgusting accumulation of flesh and bone pulsing with life"
	activation_cost_resource = /datum/chorus_resource/growth_nutrients
	activation_cost_amount = 100
	health = 200
	click_cooldown = 120 SECONDS
	gives_sight = TRUE

/obj/structure/chorus/growth_womb/activate()
	to_chat(owner, "<span class='notice'>You send out another one of your children.</span>")
	var/list/possible_dirs = list(NORTH, EAST, WEST, SOUTH)
	for(var/dir in possible_dirs)
		var/turf/T = get_step(src, dir)
		if(T.density)
			possible_dirs -= dir
	if(!possible_dirs.len)
		to_chat(owner, "<span class='warning'>\The [src] is walled in! It can't fire any eggs</span>")
		return
	var/obj/effect/meteor/egg/egg = new(get_turf(src), owner)
	egg.dest = get_edge_target_turf(get_turf(src), pick(possible_dirs))
	spawn(0)
		walk_towards(egg, egg.dest, 1)

/obj/effect/meteor/egg
	name = "egg"
	desc = "A large... egg?"
	heavy = TRUE
	hits = 10
	hitpwr = 3
	meteordrop = /obj/item/weapon/reagent_containers/food/snacks/meat
	dropamt = 5
	var/mob/living/chorus/owner

/obj/effect/meteor/egg/Initialize(var/maploading, var/o)
	. = ..()
	if(o)
		owner = o
		GLOB.destroyed_event.register(owner, src, .proc/owner_died)

/obj/effect/meteor/egg/proc/owner_died()
	qdel(src)

/obj/effect/meteor/egg/touch_map_edge()
	if(owner && istype(owner.form, /datum/chorus_form/growth))
		var/datum/chorus_form/growth/G = owner.form
		G.egg_released(owner)
	qdel(src)

/obj/effect/meteor/egg/Destroy()
	if(owner)
		GLOB.destroyed_event.unregister(owner, src)
		owner = null
	. = ..()