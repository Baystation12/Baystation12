/turf/simulated/floor
	name = "plating"
	icon = 'icons/turf/flooring/plating.dmi'
	icon_state = "plating"

	// Damage to flooring.
	var/broken
	var/burnt

	// Plating data.
	var/base_name = "plating"
	var/base_desc = "The naked hull."
	var/base_icon = 'icons/turf/flooring/plating.dmi'
	var/base_icon_state = "plating"

	// Flooring data.
	var/flooring_override
	var/initial_flooring
	var/decl/flooring/flooring
	var/mineral = DEFAULT_WALL_MATERIAL

	thermal_conductivity = 0.040
	heat_capacity = 10000
	var/lava = 0

/turf/simulated/floor/is_plating()
	return !flooring

/turf/simulated/floor/New(var/newloc, var/floortype)
	..(newloc)
	if(!floortype && initial_flooring)
		floortype = initial_flooring
	if(floortype)
		set_flooring(get_flooring_data(floortype))

/turf/simulated/floor/proc/set_flooring(var/decl/flooring/newflooring)
	make_plating(defer_icon_update = 1)
	flooring = newflooring
	update_icon(1)
	levelupdate()

//This proc will set floor_type to null and the update_icon() proc will then change the icon_state of the turf
//This proc auto corrects the grass tiles' siding.
/turf/simulated/floor/proc/make_plating(var/place_product, var/defer_icon_update)

	overlays.Cut()
	if(islist(decals))
		decals.Cut()
		decals = null

	name = base_name
	desc = base_desc
	icon = base_icon
	icon_state = base_icon_state

	if(flooring)
		if(flooring.build_type && place_product)
			new flooring.build_type(src)
		flooring = null

	set_light(0)
	broken = null
	burnt = null
	flooring_override = null
	levelupdate()

	if(!defer_icon_update)
		update_icon(1)

/turf/simulated/floor/levelupdate()
	for(var/obj/O in src)
		O.hide(O.hides_under_flooring() && src.flooring)


/*
<<<<<<< HEAD

/turf/simulated/floor/attackby(obj/item/C as obj, mob/user as mob)

	if(!C || !user)
		return 0

	if(istype(C,/obj/item/weapon/light/bulb)) //only for light tiles
		if(is_light_floor())
			if(get_lightfloor_state())
				user.remove_from_mob(C)
				qdel(C)
				set_lightfloor_state(0) //fixing it by bashing it with a light bulb, fun eh?
				update_icon()
				user << "\blue [translation(src, "replace_bulb")]"
			else
				user << "\blue [translation(src, "bulb_fine")]"

	if(istype(C, /obj/item/weapon/crowbar) && (!(is_plating())))
		if(broken || burnt)
			user << "\red [translation(src, "remove_broken")]"
		else
			if(is_wood_floor())
				user << "\red [translation(src, "pry_off")]"
			else
				var/obj/item/I = new floor_type(src)
				if(is_light_floor())
					var/obj/item/stack/tile/light/L = I
					L.on = get_lightfloor_on()
					L.state = get_lightfloor_state()
				user << "\red [translation(src,"remove",I)]"

		make_plating()
		playsound(src, 'sound/items/Crowbar.ogg', 80, 1)

		return

	if(istype(C, /obj/item/weapon/screwdriver) && is_wood_floor())
		if(broken || burnt)
			return
		else
			if(is_wood_floor())
				user << "\red [translation(src, "unscrew")]"
				new floor_type(src)

		make_plating()
		playsound(src, 'sound/items/Screwdriver.ogg', 80, 1)

		return

	if(istype(C, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = C
		if (is_plating())
			if (R.get_amount() < 2)
				user << "<span class='warning'>[translation(src, "more_rods")]</span>"
				return
			user << "\blue [translation(src, "reinforcing")]"
			if(do_after(user, 30) && is_plating())
				if (R.use(2))
					ChangeTurf(/turf/simulated/floor/engine)
					playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
				return
			else
		else
			user << "\red [translation(src, "remove_first")]"
		return

	if(istype(C, /obj/item/stack/tile))
		if(is_plating())
			if(!broken && !burnt)
				var/obj/item/stack/tile/T = C
				if (T.get_amount() < 1)
					return
				if(!T.build_type)
					floor_type = T.type
				else
					floor_type = T.build_type
				intact = 1
				if(istype(T,/obj/item/stack/tile/light))
					var/obj/item/stack/tile/light/L = T
					set_lightfloor_state(L.state)
					set_lightfloor_on(L.on)
				if(istype(T,/obj/item/stack/tile/grass))
					for(var/direction in cardinal)
						if(istype(get_step(src,direction),/turf/simulated/floor))
							var/turf/simulated/floor/FF = get_step(src,direction)
							FF.update_icon() //so siding gets updated properly
				else if(istype(T,/obj/item/stack/tile/carpet))
					for(var/direction in list(1,2,4,8,5,6,9,10))
						if(istype(get_step(src,direction),/turf/simulated/floor))
							var/turf/simulated/floor/FF = get_step(src,direction)
							FF.update_icon() //so siding gets updated properly
				T.use(1)
				update_icon()
				levelupdate()
				playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			else
				user << "\blue [translation(src, "too_damaged")]"


	if(istype(C, /obj/item/stack/cable_coil))
		if(is_plating())
			var/obj/item/stack/cable_coil/coil = C
			coil.turf_place(src, user)
		else
			user << "\red [translation(src, "remove_first")]"

	if(istype(C, /obj/item/weapon/shovel))
		if(is_grass_floor())
			new /obj/item/weapon/ore/glass(src)
			new /obj/item/weapon/ore/glass(src) //Make some sand if you shovel grass
			user << "\blue [translation(src, "shovel_grass")]"
			make_plating()
		else
			user << "\red [translation(src, "cannot_shovel")]"

	if(istype(C, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/welder = C
		if(welder.isOn() && (is_plating()))
			if(broken || burnt)
				if(welder.remove_fuel(0,user))
					user << "\red [translation(src, "fix_dents")]"
					playsound(src, 'sound/items/Welder.ogg', 80, 1)
					icon_state = "plating"
					burnt = 0
					broken = 0
				else
					user << "\blue [translation(src, "more_fuel")]"

*/