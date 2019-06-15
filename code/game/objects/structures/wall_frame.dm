// Basically see-through walls. Used for windows
// If nothing has been built on the low wall, you can climb on it

/obj/structure/wall_frame
	name = "low wall"
	desc = "A low wall section which serves as the base of windows, amongst other things."
	icon = 'icons/obj/wall_frame.dmi'
	icon_state = "frame"

	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	anchored = 1
	density = 1
	throwpass = 1
	layer = TABLE_LAYER

	var/health = 100
	var/paint_color

	blend_atoms = list(/obj/machinery/door, /turf/simulated/wall) // Objects which to blend with
	noblend_atoms = list(/obj/machinery/door/window)
	material = DEFAULT_WALL_MATERIAL

/obj/structure/wall_frame/New(var/new_loc, var/materialtype)
	..(new_loc)

	if(!materialtype)
		materialtype = DEFAULT_WALL_MATERIAL
	material = SSmaterials.get_material_by_name(materialtype)
	health = material.integrity

	update_connections(1)
	update_icon()

/obj/structure/wall_frame/examine(mob/user)
	. = ..(user)

	if(!.)
		return

	if(health == material.integrity)
		to_chat(user, SPAN_NOTICE("It seems to be in fine condition."))
	else
		var/dam = health / material.integrity
		if(dam <= 0.3)
			to_chat(user, SPAN_NOTICE("It's got a few dents and scratches."))
		else if(dam <= 0.7)
			to_chat(user, SPAN_WARNING("A few pieces of panelling have fallen off."))
		else
			to_chat(user, SPAN_DANGER("It's nearly falling to pieces."))
	if(paint_color)
		to_chat(user, SPAN_NOTICE("It has a smooth coat of paint applied."))

/obj/structure/wall_frame/attackby(var/obj/item/weapon/W, var/mob/user)
	src.add_fingerprint(user)

	//grille placing
	if(istype(W, /obj/item/stack/material/rods))
		for(var/obj/structure/window/WINDOW in loc)
			if(WINDOW.dir == get_dir(src, user))
				to_chat(user, SPAN_NOTICE("There is a window in the way."))
				return
		place_grille(user, loc, W)
		return

	//window placing
	else if(istype(W,/obj/item/stack/material))
		var/obj/item/stack/material/ST = W
		if(ST.material.opacity > 0.7)
			return 0
		place_window(user, loc, SOUTHWEST, ST)

	if(isWrench(W))
		for(var/obj/structure/S in loc)
			if(istype(S, /obj/structure/window))
				to_chat(user, SPAN_NOTICE("There is still a window on the low wall!"))
				return
			else if(istype(S, /obj/structure/grille))
				to_chat(user, SPAN_NOTICE("There is still a grille on the low wall!"))
				return
		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
		to_chat(user, SPAN_NOTICE("Now disassembling the low wall..."))
		if(do_after(user, 40,src))
			to_chat(user, SPAN_NOTICE("You dissasembled the low wall!"))
			dismantle()

	else if(istype(W, /obj/item/weapon/gun/energy/plasmacutter))
		var/obj/item/weapon/gun/energy/plasmacutter/cutter = W
		cutter.slice(user)
		playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)
		to_chat(user, SPAN_NOTICE("Now slicing through the low wall..."))
		if(do_after(user, 20,src))
			to_chat(user, SPAN_WARNING("You have sliced through the low wall!"))
			dismantle()
	return ..()

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

	for(var/i = 1 to 4)
		//if(other_connections[i] != "0")
		//	I = image('icons/obj/wall_frame.dmi', "frame_other[connections[i]]", dir = 1<<(i-1))
		//else
		I = image('icons/obj/wall_frame.dmi', "frame[connections[i]]", dir = 1<<(i-1))
		I.color = new_color
		overlays += I
	for(var/i in edge_connections)
		// outer edge
		I = image('icons/obj/wall_frame.dmi', "frame_edge", dir = i)
		I.pixel_z = 32
		//I.plane = ABOVE_HUMAN_PLANE
		I.color = new_color
		overlays += I

		// inner edge
		I = image('icons/obj/wall_frame.dmi', "frame_inner", dir = i)
		I.layer = ABOVE_WINDOW_LAYER
		I.color = new_color
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

/obj/structure/wall_frame/bullet_act(var/obj/item/projectile/Proj)
	var/proj_damage = Proj.get_structure_damage()
	var/damage = min(proj_damage, 100)
	take_damage(damage)
	return

/obj/structure/wall_frame/hitby(AM as mob|obj, var/speed=THROWFORCE_SPEED_DIVISOR)
	..()
	if(ismob(AM))
		return
	var/obj/O = AM
	var/tforce = O.throwforce * (speed/THROWFORCE_SPEED_DIVISOR)
	if (tforce < 15)
		return
	take_damage(tforce)

/obj/structure/wall_frame/take_damage(damage)
	health -= damage
	if(health <= 0)
		dismantle()

/obj/structure/wall_frame/proc/dismantle()
	new /obj/item/stack/material/steel(get_turf(src))
	qdel(src)

//Subtypes
/obj/structure/wall_frame/standard
	paint_color = COLOR_GUNMETAL

/obj/structure/wall_frame/titanium
	material = MATERIAL_TITANIUM

/obj/structure/wall_frame/hull
	paint_color = COLOR_HULL