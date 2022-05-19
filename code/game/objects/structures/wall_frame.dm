// Basically see-through walls. Used for windows
// If nothing has been built on the low wall, you can climb on it

/obj/structure/wall_frame
	name = "low wall"
	desc = "A low wall section which serves as the base of windows, amongst other things."
	icon = 'icons/obj/wall_frame.dmi'
	icon_state = "frame"

	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE | ATOM_FLAG_CAN_BE_PAINTED | ATOM_FLAG_ADJACENT_EXCEPTION
	anchored = TRUE
	density = TRUE
	throwpass = 1
	layer = TABLE_LAYER
	health_max = 100

	var/paint_color
	var/stripe_color
	rad_resistance_modifier = 0.5

	blend_objects = list(/obj/machinery/door, /turf/simulated/wall) // Objects which to blend with
	noblend_objects = list(/obj/machinery/door/window)
	material = DEFAULT_WALL_MATERIAL

/obj/structure/wall_frame/New(var/new_loc, var/materialtype)
	..(new_loc)

	if (!materialtype)
		if (istext(material))
			materialtype = material
		else
			materialtype = DEFAULT_WALL_MATERIAL

	material = SSmaterials.get_material_by_name(materialtype)
	set_max_health(material.integrity)

	update_connections(1)
	update_icon()

/obj/structure/wall_frame/Destroy()
	var/turf/location = loc
	. = ..()
	for(var/obj/structure/wall_frame/W in orange(1, location))
		W.update_connections()
		W.queue_icon_update()


/obj/structure/wall_frame/examine(mob/user)
	. = ..()

	if(paint_color)
		to_chat(user, "<span class='notice'>It has a smooth coat of paint applied.</span>")

/obj/structure/wall_frame/attackby(var/obj/item/W, var/mob/user)
	src.add_fingerprint(user)

	if (user.a_intent == I_HURT)
		..()
		return

	//grille placing
	if(istype(W, /obj/item/stack/material/rods))
		for(var/obj/structure/window/WINDOW in loc)
			if(WINDOW.dir == get_dir(src, user))
				to_chat(user, "<span class='notice'>There is a window in the way.</span>")
				return
		place_grille(user, loc, W)
		return

	//window placing
	if(istype(W,/obj/item/stack/material))
		var/obj/item/stack/material/ST = W
		if(ST.material.opacity > 0.7)
			return 0
		place_window(user, loc, SOUTHWEST, ST)
		return

	if(isWrench(W))
		for(var/obj/structure/S in loc)
			if(istype(S, /obj/structure/window))
				to_chat(user, "<span class='notice'>There is still a window on the low wall!</span>")
				return
			else if(istype(S, /obj/structure/grille))
				to_chat(user, "<span class='notice'>There is still a grille on the low wall!</span>")
				return
		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
		to_chat(user, "<span class='notice'>Now disassembling the low wall...</span>")
		if(do_after(user, 4 SECONDS, src, DO_PUBLIC_UNIQUE))
			to_chat(user, "<span class='notice'>You dissasembled the low wall!</span>")
			dismantle()
		return

	if(istype(W, /obj/item/gun/energy/plasmacutter))
		var/obj/item/gun/energy/plasmacutter/cutter = W
		if(!cutter.slice(user))
			return
		playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)
		to_chat(user, "<span class='notice'>Now slicing through the low wall...</span>")
		if(do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE))
			to_chat(user, "<span class='warning'>You have sliced through the low wall!</span>")
			dismantle()
		return

	..()

/obj/structure/wall_frame/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(istype(mover,/obj/item/projectile))
		return 1
	if(istype(mover) && mover.checkpass(PASS_FLAG_TABLE))
		return 1

// icon related

/obj/structure/wall_frame/on_update_icon()
	overlays.Cut()
	var/image/I

	var/new_color = (paint_color ? paint_color : material.icon_colour)
	color = new_color

	for(var/i = 1 to 4)
		if(other_connections[i] != "0")
			I = image('icons/obj/wall_frame.dmi', "frame_other[connections[i]]", dir = SHIFTL(1, i - 1))
		else
			I = image('icons/obj/wall_frame.dmi', "frame[connections[i]]", dir = SHIFTL(1, i - 1))
		overlays += I

	if(stripe_color)
		for(var/i = 1 to 4)
			if(other_connections[i] != "0")
				I = image('icons/obj/wall_frame.dmi', "stripe_other[connections[i]]", dir = SHIFTL(1, i - 1))
			else
				I = image('icons/obj/wall_frame.dmi', "stripe[connections[i]]", dir = SHIFTL(1, i - 1))
			I.color = stripe_color
			overlays += I

/obj/structure/wall_frame/hull/Initialize()
	. = ..()
	if(prob(40))
		var/spacefacing = FALSE
		for(var/direction in GLOB.cardinal)
			var/turf/T = get_step(src, direction)
			var/area/A = get_area(T)
			if(A && (A.area_flags & AREA_FLAG_EXTERNAL))
				spacefacing = TRUE
				break
		if(spacefacing)
			var/bleach_factor = rand(10,50)
			paint_color = adjust_brightness(paint_color, bleach_factor)
		update_icon()

/obj/structure/wall_frame/hitby(AM as mob|obj, var/datum/thrownthing/TT)
	..()
	var/tforce = 0
	if(ismob(AM)) // All mobs have a multiplier and a size according to mob_defines.dm
		var/mob/I = AM
		tforce = I.mob_size * (TT.speed/THROWFORCE_SPEED_DIVISOR)
	else
		var/obj/O = AM
		tforce = O.throwforce * (TT.speed/THROWFORCE_SPEED_DIVISOR)
	if (tforce < 15)
		return
	damage_health(tforce, DAMAGE_BRUTE)

/obj/structure/wall_frame/on_death()
	dismantle()

/obj/structure/wall_frame/proc/dismantle()
	new /obj/item/stack/material/steel(get_turf(src), 3)
	qdel(src)

/obj/structure/wall_frame/get_color()
	return paint_color

/obj/structure/wall_frame/set_color(var/color)
	paint_color = color
	update_icon()

//Subtypes
/obj/structure/wall_frame/standard
	paint_color = COLOR_WALL_GUNMETAL

/obj/structure/wall_frame/titanium
	material = MATERIAL_TITANIUM

/obj/structure/wall_frame/hull
	paint_color = COLOR_SOL

/obj/structure/wall_frame/hull/vox
	paint_color = COLOR_GREEN_GRAY

/obj/structure/wall_frame/hull/verne
	paint_color = COLOR_GUNMETAL
