/obj/item/mop/broom
	name = "broom"
	desc = "This one is made of fake leafsand branches."
	icon = 'mods/sauna_props/icons/sauna_props.dmi'
	icon_state = "sauna_broom"
	hitsound = 'mods/sauna_props/sound/broomwhip.ogg'
	hitsound = 'mods/sauna_props/sound/broomwhip.ogg'
	attack_verb = list("whipped")
	throwforce = 0.001
	force = 0.001
	mopspeed = 110

/obj/item/mop/broom/afterattack(atom/A, mob/user, proximity)
	if(!proximity)
		return

	if(is_type_in_list(A,moppable_types))
		var/turf/T = get_turf(A)
		if(!T)
			return

		user.visible_message(SPAN_WARNING("\The [user] begins to clean \the [T]."))

		if(do_after(user, mopspeed, T, do_flags = DO_DEFAULT | DO_PUBLIC_PROGRESS))
			if(T)
				T.clean(src, user)
			to_chat(user, SPAN_NOTICE("You have finished mopping!"))

/obj/structure/bed/sauna_bench
	name = "sauna bench"
	desc = "A wooden sauna bench."
	icon = 'mods/sauna_props/icons/sauna_props.dmi'
	icon_state = "bench"
	base_icon = "bench"
	var/static/list/sauna_bench_buckle_pixel_shift = list(0, 10, 0)

/obj/structure/bed/sauna_bench/New(newloc)
	..(newloc, MATERIAL_WOOD, MATERIAL_LEATHER_GENERIC)

/obj/structure/bed/sauna_bench/Destroy()
	buckle_pixel_shift = null
	..()

/obj/structure/bed/sauna_bench/Initialize()
	buckle_pixel_shift = sauna_bench_buckle_pixel_shift
	. = ..()

/obj/structure/bed/sauna_bench/on_update_icon()
	icon_state = base_icon

/obj/structure/bed/sauna_bench/middle
	icon_state = "bench_middle"
	base_icon = "bench_middle"

/obj/structure/bed/sauna_bench/middle/north
	icon_state = "bench_middlenorth"
	base_icon = "bench_middlenorth"

/obj/structure/bed/sauna_bench/north
	icon_state = "bench_north"
	base_icon = "bench_north"

/obj/structure/bed/sauna_bench/south
	icon_state = "bench_south"
	base_icon = "bench_south"
