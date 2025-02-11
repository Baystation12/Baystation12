#define PAINT_REGION_PAINT    "Paint"
#define PAINT_REGION_STRIPE   "Stripe"
#define PAINT_REGION_WINDOW   "Window"

#define PLACEMENT_MODE_QUARTERS  1
#define PLACEMENT_MODE_TRIANGLES 2

#define CATEGORY_NONE   0
#define CATEGORY_TILES  1
#define CATEGORY_HAZARD 2
#define CATEGORY_WARD   3
#define CATEGORY_MISC   4

/obj/item/device/paint_sprayer
	name = "paint sprayer"
	icon = 'icons/obj/tools/paint_sprayer.dmi'
	icon_state = "paint_sprayer"
	item_state = "paint_sprayer"
	desc = "A slender and none-too-sophisticated device capable of applying paint on floors, walls, exosuits and certain airlocks."
	var/decal = "Quarter-Tile"
	var/paint_color
	var/wall_paint_region = PAINT_REGION_PAINT
	var/category

	var/list/decals = list(
		"Quarter-Tile"        = list("path" = /obj/floor_decal/corner, "category" = CATEGORY_TILES, "colored" = TRUE, "placement" = PLACEMENT_MODE_QUARTERS),
		"Half-Tile"           = list("path" = /obj/floor_decal/corner/white/half, "category" = CATEGORY_TILES, "colored" = TRUE, "placement" = PLACEMENT_MODE_TRIANGLES),
		"Full Tile"           = list("path" = /obj/floor_decal/corner/white/mono, "category" = CATEGORY_TILES, "colored" = TRUE),
		"Hatched Marking"     = list("path" = /obj/floor_decal/industrial/hatch, "category" = CATEGORY_TILES, "colored" = TRUE),
		"Dashed Outline"      = list("path" = /obj/floor_decal/industrial/outline, "category" = CATEGORY_TILES, "colored" = TRUE),
		"Hazard Border"       = list("path" = /obj/floor_decal/industrial/warning, "category" = CATEGORY_HAZARD, "placement" = PLACEMENT_MODE_TRIANGLES),
		"Hazard Outer Corner" = list("path" = /obj/floor_decal/industrial/warning/corner, "category" = CATEGORY_HAZARD, "placement" = PLACEMENT_MODE_QUARTERS),
		"Hazard Inner Corner" = list("path" = /obj/floor_decal/industrial/warning/inner, "category" = CATEGORY_HAZARD, "placement" = PLACEMENT_MODE_QUARTERS),
		"Hazard U-Corner"     = list("path" = /obj/floor_decal/industrial/warning/cee, "category" = CATEGORY_HAZARD),
		"Hazard Full Tile"    = list("path" = /obj/floor_decal/industrial/warning/full, "category" = CATEGORY_HAZARD),
		"Hazard Stripes"      = list("path" = /obj/floor_decal/industrial/warning/fulltile, "category" = CATEGORY_HAZARD),
		"1"                   = list("path" = /obj/floor_decal/sign, "category" = CATEGORY_WARD, "use_decal_icon" = TRUE),
		"2"                   = list("path" = /obj/floor_decal/sign/two, "category" = CATEGORY_WARD, "use_decal_icon" = TRUE),
		"A"                   = list("path" = /obj/floor_decal/sign/a, "category" = CATEGORY_WARD, "use_decal_icon" = TRUE),
		"B"                   = list("path" = /obj/floor_decal/sign/b, "category" = CATEGORY_WARD, "use_decal_icon" = TRUE),
		"C"                   = list("path" = /obj/floor_decal/sign/c, "category" = CATEGORY_WARD, "use_decal_icon" = TRUE),
		"D"                   = list("path" = /obj/floor_decal/sign/d, "category" = CATEGORY_WARD, "use_decal_icon" = TRUE),
		"M"                   = list("path" = /obj/floor_decal/sign/m, "category" = CATEGORY_WARD, "use_decal_icon" = TRUE),
		"V"                   = list("path" = /obj/floor_decal/sign/v, "category" = CATEGORY_WARD, "use_decal_icon" = TRUE),
		"CMO"                 = list("path" = /obj/floor_decal/sign/cmo, "category" = CATEGORY_WARD, "use_decal_icon" = TRUE),
		"Ex"                  = list("path" = /obj/floor_decal/sign/ex, "category" = CATEGORY_WARD, "use_decal_icon" = TRUE),
		"Psy"                 = list("path" = /obj/floor_decal/sign/p, "category" = CATEGORY_WARD, "use_decal_icon" = TRUE),
		"Shutoff"             = list("path" = /obj/floor_decal/industrial/shutoff, "category" = CATEGORY_MISC, "placement" = PLACEMENT_MODE_TRIANGLES, "use_decal_icon" = TRUE),
		"Loading Sign"        = list("path" = /obj/floor_decal/industrial/loading, "category" = CATEGORY_MISC, "placement" = PLACEMENT_MODE_TRIANGLES),
		"Mosaic"              = list("path" = /obj/floor_decal/chapel, "category" = CATEGORY_MISC, "placement" = PLACEMENT_MODE_QUARTERS, "inversed" = TRUE),
		"Remove all decals"   = list("path" = /obj/floor_decal/reset),
	)

	var/list/categories = list(
		"Tile Decals"   = list("id" = CATEGORY_TILES,  "icon_state" = "tiles"),
		"Hazard Decals" = list("id" = CATEGORY_HAZARD, "icon_state" = "stripefull"),
		"Ward Decals"   = list("id" = CATEGORY_WARD,   "icon_state" = "ward"),
		"Misc Decals"   = list("id" = CATEGORY_MISC,   "icon_state" = "misc"),
	)

	var/list/preset_colors = list(
		"Beasty brown" =   COLOR_BEASTY_BROWN,
		"Blue" =           COLOR_BLUE_GRAY,
		"Civvie green" =   COLOR_CIVIE_GREEN,
		"Command blue" =   COLOR_COMMAND_BLUE,
		"Cyan" =           COLOR_CYAN,
		"Green" =          COLOR_GREEN,
		"Bottle green" =   COLOR_PALE_BTL_GREEN,
		"Nanotrasen red" = COLOR_NT_RED,
		"Orange" =         COLOR_ORANGE,
		"Pale orange" =    COLOR_PALE_ORANGE,
		"Red" =            COLOR_RED,
		"Sky blue" =       COLOR_DEEP_SKY_BLUE,
		"Titanium" =       COLOR_TITANIUM,
		"Aluminium"=       COLOR_ALUMINIUM,
		"Violet" =         COLOR_VIOLET,
		"White" =          COLOR_WHITE,
		"Yellow" =         COLOR_AMBER,
		"Sol blue" =       COLOR_SOL,
		"Bulkhead black" = COLOR_WALL_GUNMETAL,
	)

/obj/item/device/paint_sprayer/Initialize()
	. = ..()
	var/random_preset = pick(preset_colors)
	change_color(preset_colors[random_preset])

/obj/item/device/paint_sprayer/Destroy()
	if (ismob(loc))
		remove_click_handler(loc)
	. = ..()

/obj/item/device/paint_sprayer/on_update_icon()
	ClearOverlays()
	AddOverlays(overlay_image(icon, "paint_sprayer_color", paint_color))

/obj/item/device/paint_sprayer/get_mob_overlay(mob/user_mob, slot, bodypart)
	var/image/ret = ..()
	var/image/overlay = overlay_image(ret.icon, "paint_sprayer_color", paint_color)
	ret.AddOverlays(overlay)
	return ret

/obj/item/device/paint_sprayer/attack_self(mob/user)
	if (!category)
		show_home(user)
	else
		show_decals_by_category(user)

/obj/item/device/paint_sprayer/proc/show_home(mob/user)
	var/radial = list()
	radial["Remove all decals"] = mutable_appearance("icons/screen/radial.dmi", "cable_invalid")
	radial["Pick color"] = mutable_appearance("icons/screen/radial.dmi", "color_hexagon")
	radial["Switch wall paint region"] = mutable_appearance("icons/screen/radial.dmi", "wall_paint_swap")
	for (var/key in categories)
		radial[key] = mutable_appearance("icons/screen/radial.dmi", categories[key]["icon_state"])
	var/choice = show_radial_menu(user, user, radial, require_near = TRUE, radius = 50, tooltips = TRUE, check_locs = list(src))
	if (!choice || !user.use_sanity_check(src))
		return
	switch (choice)
		if ("Remove all decals")
			decal = choice
			return
		if ("Pick color")
			choose_color(user)
			return
		if ("Switch wall paint region")
			choose_wall_paint_region(user)
			return
	category = categories[choice]["id"]
	show_decals_by_category(user)

/obj/item/device/paint_sprayer/proc/show_decals_by_category(mob/user)
	var/radial = list()
	radial["Home"] = mutable_appearance('icons/screen/radial.dmi', "radial_home")
	for (var/key in decals)
		if (decals[key]["category"] != category)
			continue
		var/obj/type = decals[key]["path"]
		var/mutable_appearance/I = mutable_appearance(decals[key]["use_decal_icon"] ? initial(type.icon) : "icons/screen/radial.dmi", initial(type.icon_state), decals[key]["colored"] ? paint_color : initial(type.color))
		radial[key] = I
	var/choice = show_radial_menu(user, user, radial, require_near = TRUE, radius = 50, tooltips = TRUE, check_locs = list(src))
	if (!choice || !user.use_sanity_check(src))
		return
	if (choice == "Home")
		category = CATEGORY_NONE
		show_home(user)
		return
	decal = choice
	playsound(src, 'sound/weapons/flipblade.ogg', 30, 1)
	to_chat(user, SPAN_NOTICE("You set \the [src] decal to '[decal]'."))

/obj/item/device/paint_sprayer/on_active_hand(mob/user)
	. = ..()
	if (user.PushClickHandler(/datum/click_handler/default/paint_sprayer))
		var/datum/click_handler/default/paint_sprayer/CH = user.click_handlers[1]
		CH.paint_sprayer = src
		if (isrobot(user))
			GLOB.module_deselected_event.register(user, src, PROC_REF(remove_click_handler))
			GLOB.module_deactivated_event.register(user, src, PROC_REF(remove_click_handler))
		else
			GLOB.hands_swapped_event.register(user, src, PROC_REF(remove_click_handler))
			GLOB.mob_equipped_event.register(user, src, PROC_REF(remove_click_handler))
			GLOB.mob_unequipped_event.register(user, src, PROC_REF(remove_click_handler))

/obj/item/device/paint_sprayer/proc/remove_click_handler(mob/user)
	if (user.RemoveClickHandler(/datum/click_handler/default/paint_sprayer))
		GLOB.hands_swapped_event.unregister(user, src, PROC_REF(remove_click_handler))
		GLOB.mob_equipped_event.unregister(user, src, PROC_REF(remove_click_handler))
		GLOB.mob_unequipped_event.unregister(user, src, PROC_REF(remove_click_handler))
		GLOB.module_deselected_event.unregister(user, src, PROC_REF(remove_click_handler))
		GLOB.module_deactivated_event.unregister(user, src, PROC_REF(remove_click_handler))

/obj/item/device/paint_sprayer/use_before(atom/target, mob/living/user, click_parameters)
	if (apply_paint(target, user, click_parameters))
		return TRUE
	return ..()

/obj/item/device/paint_sprayer/proc/pick_color(atom/A, mob/user)
	if (!user.Adjacent(A) || user.incapacitated())
		return FALSE
	var/new_color
	if (istype(A, /turf/simulated/floor))
		new_color = pick_color_from_floor(A, user)
	else if (istype(A, /obj/machinery/door/airlock))
		new_color = pick_color_from_airlock(A, user)
	else if (istype(A, /turf/simulated/wall))
		new_color = pick_color_from_wall(A, user)
	else if (istype(A, /obj/structure/wall_frame))
		var/obj/structure/wall_frame/wall_frame = A
		new_color = wall_frame.stripe_color
	else if (A.atom_flags & ATOM_FLAG_CAN_BE_PAINTED)
		new_color = A.get_color()
	if (!change_color(new_color, user))
		to_chat(user, SPAN_WARNING("\The [A] does not have a color that you could pick from."))
	return TRUE // There was an attempt to pick a color.

/obj/item/device/paint_sprayer/proc/apply_paint(atom/A, mob/user, click_parameters)
	if (istype(A, /turf/simulated/wall))
		. = paint_wall(A, user)
	else if (istype(A, /turf/simulated/floor))
		. = paint_floor(A, user, click_parameters)
	else if (istype(A, /obj/machinery/door/airlock))
		. = paint_airlock(A, user)
	else if (istype(A, /obj/structure/wall_frame))
		. = paint_wall_frame(A, user)
	else if (istype(A, /mob/living/exosuit))
		to_chat(user, SPAN_WARNING("You can't paint an active exosuit. Dismantle it first."))
	else if (A.atom_flags & ATOM_FLAG_CAN_BE_PAINTED)
		A.set_color(paint_color)
		. = TRUE
	if (.)
		playsound(get_turf(src), 'sound/effects/spray3.ogg', 30, 1, -6)
	return .

/obj/item/device/paint_sprayer/proc/remove_paint(atom/A, mob/user)
	if(!user.Adjacent(A) || user.incapacitated())
		return FALSE
	if (istype(A, /turf/simulated/floor))
		var/turf/simulated/floor/F = A
		if (F.decals && length(F.decals) > 0)
			LIST_DEC(F.decals)
			F.update_icon()
			. = TRUE
	else if (istype(A, /turf/simulated/wall))
		var/turf/simulated/wall/wall = A
		wall.paint_wall(null)
		wall.stripe_wall(null)
		. = TRUE
	else if (istype(A, /obj/structure/wall_frame))
		var/obj/structure/wall_frame/wall_frame = A
		. = wall_frame.stripe_wall_frame(null)
	else if (istype(A, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/D = A
		if (D.paintable)
			D.paint_airlock(null)
			D.stripe_airlock(null)
			D.paint_window(null)
			. = TRUE
	else if (A.atom_flags & ATOM_FLAG_CAN_BE_PAINTED)
		A.set_color(null)
		. = TRUE
	if (.)
		add_fingerprint(user)
		playsound(get_turf(src), 'sound/effects/spray3.ogg', 30, 1, -6)
	return .

/obj/item/device/paint_sprayer/proc/pick_color_from_floor(turf/simulated/floor/F, mob/user)
	if (!F.decals || !length(F.decals))
		return FALSE
	var/list/available_colors = list()
	for (var/image/I in F.decals)
		available_colors |= isnull(I.color) ? COLOR_WHITE : I.color
	var/picked_color = available_colors[1]
	if (length(available_colors) > 1)
		picked_color = input(user, "Which color do you wish to pick from?") as null|anything in available_colors
		if (user.incapacitated() || !user.Adjacent(F))
			return FALSE
	return picked_color

/obj/item/device/paint_sprayer/proc/paint_floor(turf/simulated/floor/F, mob/user, click_parameters)
	if(!F.flooring)
		to_chat(user, SPAN_WARNING("You need flooring to paint on."))
		return FALSE

	if(!F.flooring.can_paint || F.broken || F.burnt)
		to_chat(user, SPAN_WARNING("\The [src] cannot paint \the [F.name]."))
		return FALSE

	var/list/decal_data = decals[decal]
	var/config_error
	if(!islist(decal_data))
		config_error = 1
	var/painting_decal
	if(!config_error)
		painting_decal = decal_data["path"]
		if(!ispath(painting_decal))
			config_error = 1

	if(config_error)
		to_chat(user, SPAN_WARNING("\The [src] flashes an error light. You might need to reconfigure it."))
		return FALSE

	if((F.decals && length(F.decals) > 7) && !ispath(painting_decal, /obj/floor_decal/reset))
		to_chat(user, SPAN_WARNING("\The [F] has been painted too much; you need to clear it off."))
		return FALSE

	var/painting_dir = calc_paint_dir(user, decal_data["placement"], click_parameters, decal_data["inversed"])
	var/painting_color
	if(decal_data["colored"] && paint_color)
		painting_color = paint_color

	new painting_decal(F, painting_dir, painting_color)
	return TRUE

/obj/item/device/paint_sprayer/proc/calc_paint_dir(mob/user, placement_mode, click_parameters, inversed)
	if (!placement_mode)
		return user.dir
	if (istext(click_parameters)) // Borgs pass down click parameters in a string format
		click_parameters = params2list(click_parameters)
	var/mouse_x = text2num(click_parameters["icon-x"])
	var/mouse_y = text2num(click_parameters["icon-y"])
	switch (placement_mode)
		if (PLACEMENT_MODE_QUARTERS)
			// One case for each of the four quarters of a turf
			if (mouse_x <= 16)
				if (mouse_y <= 16)
					. = WEST
				else
					. = NORTH
			else
				if (mouse_y <= 16)
					. = SOUTH
				else
					. = EAST
		if (PLACEMENT_MODE_TRIANGLES)
			// One case for each triangle sectioned off by the diagonals of a square
			if (mouse_y > mouse_x)
				if (mouse_y > 32-mouse_x)
					. = NORTH
				else
					. = WEST
			else
				if (mouse_y > 32-mouse_x)
					. = EAST
				else
					. = SOUTH
	return inversed ? reverse_direction(.) : .

/obj/item/device/paint_sprayer/proc/pick_color_from_airlock(obj/machinery/door/airlock/D, mob/user)
	if (!D.paintable)
		return FALSE
	switch (select_airlock_region(D, user, "Where do you wish to pick the color from?"))
		if (PAINT_REGION_PAINT)
			return D.door_color
		if (PAINT_REGION_STRIPE)
			return D.stripe_color
		if (PAINT_REGION_WINDOW)
			return D.window_color
		else
			return FALSE

/obj/item/device/paint_sprayer/proc/paint_airlock(obj/machinery/door/airlock/D, mob/user)
	if (!D.paintable)
		to_chat(user, SPAN_WARNING("You can't paint this airlock type."))
		return FALSE

	switch (select_airlock_region(D, user, "What do you wish to paint?"))
		if (PAINT_REGION_PAINT)
			D.paint_airlock(paint_color)
		if (PAINT_REGION_STRIPE)
			D.stripe_airlock(paint_color)
		if (PAINT_REGION_WINDOW)
			D.paint_window(paint_color)
		else
			return FALSE
	return TRUE

/obj/item/device/paint_sprayer/proc/select_airlock_region(obj/machinery/door/airlock/door, mob/user, input_text)
	var/choice
	var/list/choices = list()
	if (door.paintable & MATERIAL_PAINTABLE_MAIN)
		choices |= PAINT_REGION_PAINT
	if (door.paintable & MATERIAL_PAINTABLE_STRIPE)
		choices |= PAINT_REGION_STRIPE
	if (door.paintable & MATERIAL_PAINTABLE_WINDOW)
		choices |= PAINT_REGION_WINDOW
	choice = input(user, input_text) as null|anything in sortList(choices)
	if (!user.use_sanity_check(door, src))
		return FALSE
	return choice

/obj/item/device/paint_sprayer/proc/paint_wall(turf/simulated/wall/wall, mob/user)
	if(istype(wall) && (!wall.material?.wall_flags))
		to_chat(user, SPAN_WARNING("You can't paint this wall type."))
		return
	if (!user.use_sanity_check(wall, src))
		return FALSE
	if(istype(wall))
		if(wall_paint_region == PAINT_REGION_PAINT)
			if(!(wall.material?.wall_flags & MATERIAL_PAINTABLE_MAIN))
				to_chat(user, SPAN_WARNING("You can't paint this wall type."))
				return FALSE
			wall.paint_wall(paint_color)
			return TRUE
		else if(wall_paint_region == PAINT_REGION_STRIPE)
			if(!(wall.material?.wall_flags & MATERIAL_PAINTABLE_STRIPE))
				to_chat(user, SPAN_WARNING("You can't stripe this wall type."))
				return FALSE
			wall.stripe_wall(paint_color)
			return TRUE


/obj/item/device/paint_sprayer/proc/pick_color_from_wall(turf/simulated/wall/wall, mob/user)
	if (!wall.material || !wall.material.wall_flags)
		return FALSE

	switch (select_wall_region(wall, user, "Where do you wish to select the color from?"))
		if (PAINT_REGION_PAINT)
			return wall.paint_color
		if (PAINT_REGION_STRIPE)
			return wall.stripe_color
		else
			return FALSE

/obj/item/device/paint_sprayer/proc/select_wall_region(turf/simulated/wall/wall, mob/user, input_text)
	var/list/choices = list()
	if (wall.material.wall_flags & MATERIAL_PAINTABLE_MAIN)
		choices |= PAINT_REGION_PAINT
	if (wall.material.wall_flags & MATERIAL_PAINTABLE_STRIPE)
		choices |= PAINT_REGION_STRIPE
	var/choice = input(user, input_text) as null|anything in sortTim(choices, GLOBAL_PROC_REF(cmp_text_asc))
	if (!user.use_sanity_check(wall, src))
		return FALSE
	return choice

/obj/item/device/paint_sprayer/proc/paint_wall_frame(obj/structure/wall_frame/wall_frame, mob/user)
	if (!user.use_sanity_check(wall_frame, src))
		return FALSE
	wall_frame.stripe_wall_frame(paint_color)
	return TRUE

/obj/item/device/paint_sprayer/proc/change_color(new_color, mob/user)
	if (new_color)
		paint_color = new_color
		if (user)
			add_fingerprint(user)
			to_chat(user, SPAN_NOTICE("You set \the [src] to paint with <span style='color:[paint_color]'>a new color</span>."))
		update_icon()
		playsound(src, 'sound/weapons/flipblade.ogg', 30, 1)
		return TRUE
	return FALSE

/obj/item/device/paint_sprayer/examine(mob/user)
	. = ..(user)
	to_chat(user, "It is configured to produce the '[decal]' decal using <span style='color:[paint_color]'>[paint_color]</span> paint.")

/obj/item/device/paint_sprayer/AltClick()
	if (!isturf(loc))
		choose_preset_color()
		return TRUE
	return ..()

/obj/item/device/paint_sprayer/CtrlClick(mob/user)
	if (!isturf(loc))
		choose_color(user)
		return TRUE
	return ..()

/obj/item/device/paint_sprayer/proc/choose_color(mob/user)
	if(user.incapacitated())
		return
	var/new_color = input(user, "Choose a color.", name, paint_color) as color|null
	if (user.incapacitated())
		return
	change_color(new_color, user)

/obj/item/device/paint_sprayer/proc/choose_wall_paint_region(mob/user)
	if(wall_paint_region == PAINT_REGION_STRIPE)
		wall_paint_region = PAINT_REGION_PAINT
		to_chat(user, SPAN_NOTICE("You set \the [src] to paint walls."))
	else
		wall_paint_region = PAINT_REGION_STRIPE
		to_chat(user, SPAN_NOTICE("You set \the [src] to stripe walls."))

/obj/item/device/paint_sprayer/verb/choose_preset_color()
	set name = "Choose Preset Color"
	set desc = "Choose a preset color."
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return
	var/preset = input(usr, "Choose a color.", name, paint_color) as null|anything in preset_colors
	if(usr.incapacitated())
		return
	change_color(preset_colors[preset], usr)

/datum/click_handler/default/paint_sprayer
	var/obj/item/device/paint_sprayer/paint_sprayer

/datum/click_handler/default/paint_sprayer/OnClick(atom/A, params)
	var/list/modifiers = params2list(params)
	if (A != paint_sprayer)
		if(!istype(user.buckled) || user.buckled.buckle_movable)
			user.face_atom(A)
		if(modifiers["ctrl"] && paint_sprayer.pick_color(A, user))
			return
		if(modifiers["shift"] && paint_sprayer.remove_paint(A, user))
			return
	user.ClickOn(A, params)

#undef PAINT_REGION_PAINT
#undef PAINT_REGION_STRIPE
#undef PAINT_REGION_WINDOW

#undef PLACEMENT_MODE_QUARTERS
#undef PLACEMENT_MODE_TRIANGLES

#undef CATEGORY_NONE
#undef CATEGORY_TILES
#undef CATEGORY_HAZARD
#undef CATEGORY_WARD
#undef CATEGORY_MISC
