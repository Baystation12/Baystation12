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

/obj/structure/wall_frame/New(new_loc, materialtype)
	..(new_loc)

	if (!materialtype)
		if (istext(material))
			materialtype = material
		else
			materialtype = DEFAULT_WALL_MATERIAL

	material = SSmaterials.get_material_by_name(materialtype)
	set_max_health(material.integrity)
	SetName("[material.use_name] [name]")

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
		to_chat(user, SPAN_NOTICE("It has a smooth coat of paint applied."))


/obj/structure/wall_frame/can_use_item(obj/item/tool, mob/user, click_params)
	. = ..()
	if (!.)
		return

	// Windows
	for (var/obj/structure/window/window in loc)
		if (window.dir == get_dir(src, user))
			USE_FEEDBACK_FAILURE("\The [window] blocks access to \the [src].")
			return FALSE

	// Grilles
	var/obj/structure/grille/grille = locate() in loc
	if (grille?.density)
		USE_FEEDBACK_FAILURE("\The [grille] blocks access to \the [src].")
		return FALSE


/obj/structure/wall_frame/use_tool(obj/item/tool, mob/user, list/click_params)
	// Rods - Place Grille
	if (istype(tool, /obj/item/stack/material/rods))
		place_grille(user, loc, tool)
		return TRUE

	// Material Stack - Place window
	if (istype(tool, /obj/item/stack/material))
		var/obj/item/stack/material/stack = tool
		if (stack.material.opacity > 0.7)
			USE_FEEDBACK_FAILURE("\The [stack] cannot be used to make a window.")
			return TRUE
		place_window(user, loc, tool)
		return TRUE

	// Wrench - Dismantle
	if (isWrench(tool))
		playsound(src, 'sound/items/Ratchet.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts dismantling \the [src] with \a [tool]."),
			SPAN_NOTICE("You start dismantling \the [src] with \the [tool].")
		)
		if (!user.do_skilled((tool.toolspeed * 4) SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		playsound(src, 'sound/items/Ratchet.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] dismantles \the [src] with \a [tool]."),
			SPAN_NOTICE("You dismantle \the [src] with \the [tool].")
		)
		dismantle()
		return TRUE

	// Plasmacutter - Dismantle
	if (istype(tool, /obj/item/gun/energy/plasmacutter))
		var/obj/item/gun/energy/plasmacutter/plasmacutter = tool
		if (!plasmacutter.slice(user))
			return TRUE
		playsound(src, 'sound/items/Welder.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts slicing \the [src] apart with \a [tool]."),
			SPAN_NOTICE("You start slicing \the [src] apart with \the [tool].")
		)
		if (!user.do_skilled((tool.toolspeed * 2) SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		playsound(src, 'sound/items/Welder.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] slices \the [src] apart with \a [tool]."),
			SPAN_NOTICE("You slice \the [src] apart with \the [tool].")
		)
		dismantle()
		return TRUE

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

/obj/structure/wall_frame/on_death()
	dismantle()

/obj/structure/wall_frame/proc/dismantle()
	material.place_sheet(get_turf(src), 3)
	qdel(src)

/obj/structure/wall_frame/get_color()
	return paint_color

/obj/structure/wall_frame/set_color(color)
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
