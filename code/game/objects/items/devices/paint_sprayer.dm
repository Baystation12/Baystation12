#define AIRLOCK_REGION_PAINT    "Paint"
#define AIRLOCK_REGION_STRIPE   "Stripe"
#define AIRLOCK_REGION_WINDOW   "Window"

/obj/item/device/paint_sprayer
	name = "paint sprayer"
	icon = 'icons/obj/device.dmi'
	icon_state = "paint_sprayer"
	item_state = "paint_sprayer"
	desc = "A slender and none-too-sophisticated device capable of applying paint on floors, walls, exosuits and certain airlocks."
	var/decal = "Quarter-turf"
	var/paint_color

	var/list/decals = list(
		"Quarter-turf" =      list("path" = /obj/effect/floor_decal/corner, "precise" = 1, "colored" = 1),
		"Monotile full" =     list("path" = /obj/effect/floor_decal/corner/white/mono, "colored" = 1),
		"Monotile halved" =   list("path" = /obj/effect/floor_decal/corner/white/half, "colored" = 1),
		"Hazard stripes" =    list("path" = /obj/effect/floor_decal/industrial/warning/fulltile),
		"Border, hazard" =    list("path" = /obj/effect/floor_decal/industrial/warning),
		"Corner, hazard" =    list("path" = /obj/effect/floor_decal/industrial/warning/corner),
		"Hatched marking" =   list("path" = /obj/effect/floor_decal/industrial/hatch, "colored" = 1),
		"Dashed outline" =    list("path" = /obj/effect/floor_decal/industrial/outline, "colored" = 1),
		"Loading sign" =      list("path" = /obj/effect/floor_decal/industrial/loading),
		"Mosaic, large" =     list("path" = /obj/effect/floor_decal/chapel),
		"1" =                 list("path" = /obj/effect/floor_decal/sign),
		"2" =                 list("path" = /obj/effect/floor_decal/sign/two),
		"A" =                 list("path" = /obj/effect/floor_decal/sign/a),
		"B" =                 list("path" = /obj/effect/floor_decal/sign/b),
		"C" =                 list("path" = /obj/effect/floor_decal/sign/c),
		"D" =                 list("path" = /obj/effect/floor_decal/sign/d),
		"M" =                 list("path" = /obj/effect/floor_decal/sign/m),
		"V" =                 list("path" = /obj/effect/floor_decal/sign/v),
		"CMO" =               list("path" = /obj/effect/floor_decal/sign/cmo),
		"Ex" =                list("path" = /obj/effect/floor_decal/sign/ex),
		"Psy" =               list("path" = /obj/effect/floor_decal/sign/p),
		"Remove all decals" = list("path" = /obj/effect/floor_decal/reset),
		)

	var/list/paint_dirs = list(
		"North" =       NORTH,
		"Northwest" =   NORTHWEST,
		"West" =        WEST,
		"Southwest" =   SOUTHWEST,
		"South" =       SOUTH,
		"Southeast" =   SOUTHEAST,
		"East" =        EAST,
		"Northeast" =   NORTHEAST,
		"Precise" = 0,
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
	overlays.Cut()
	overlays += overlay_image(icon, "paint_sprayer_color", paint_color)
	update_held_icon()

/obj/item/device/paint_sprayer/get_mob_overlay(mob/user_mob, slot, bodypart)
	var/image/ret = ..()
	var/image/overlay = overlay_image(ret.icon, "paint_sprayer_color", paint_color)
	ret.overlays += overlay
	return ret

/obj/item/device/paint_sprayer/on_active_hand(mob/user)
	. = ..()
	if (user.PushClickHandler(/datum/click_handler/default/paint_sprayer))
		var/datum/click_handler/default/paint_sprayer/CH = user.click_handlers[1]
		CH.paint_sprayer = src
		if (isrobot(user))
			GLOB.module_deselected_event.register(user, src, /obj/item/device/paint_sprayer/proc/remove_click_handler)
			GLOB.module_deactivated_event.register(user, src, /obj/item/device/paint_sprayer/proc/remove_click_handler)
		else
			GLOB.hands_swapped_event.register(user, src, /obj/item/device/paint_sprayer/proc/remove_click_handler)
			GLOB.mob_equipped_event.register(user, src, /obj/item/device/paint_sprayer/proc/remove_click_handler)
			GLOB.mob_unequipped_event.register(user, src, /obj/item/device/paint_sprayer/proc/remove_click_handler)

/obj/item/device/paint_sprayer/proc/remove_click_handler(mob/user)
	if (user.RemoveClickHandler(/datum/click_handler/default/paint_sprayer))
		GLOB.hands_swapped_event.unregister(user, src, /obj/item/device/paint_sprayer/proc/remove_click_handler)
		GLOB.mob_equipped_event.unregister(user, src, /obj/item/device/paint_sprayer/proc/remove_click_handler)
		GLOB.mob_unequipped_event.unregister(user, src, /obj/item/device/paint_sprayer/proc/remove_click_handler)
		GLOB.module_deselected_event.unregister(user, src, /obj/item/device/paint_sprayer/proc/remove_click_handler)
		GLOB.module_deactivated_event.unregister(user, src, /obj/item/device/paint_sprayer/proc/remove_click_handler)

/obj/item/device/paint_sprayer/afterattack(atom/A, mob/user, proximity, params)
	if (!proximity)
		return
	apply_paint(A, user, params)

/obj/item/device/paint_sprayer/proc/pick_color(atom/A, mob/user)
	if (!user.Adjacent(A) || user.incapacitated())
		return FALSE
	var/new_color
	if (istype(A, /turf/simulated/floor))
		new_color = pick_color_from_floor(A, user)
	else if (istype(A, /obj/machinery/door/airlock))
		new_color = pick_color_from_airlock(A, user)
	else if (A.atom_flags & ATOM_FLAG_CAN_BE_PAINTED)
		new_color = A.get_color()
	if (!change_color(new_color, user))
		to_chat(user, SPAN_WARNING("\The [A] does not have a color that you could pick from."))
	return TRUE // There was an attempt to pick a color.

/obj/item/device/paint_sprayer/proc/apply_paint(atom/A, mob/user, params)
	if (A.atom_flags & ATOM_FLAG_CAN_BE_PAINTED)
		A.set_color(paint_color)
		. = TRUE
	else if (istype(A, /turf/simulated/floor))
		. = paint_floor(A, user, params)
	else if (istype(A, /obj/machinery/door/airlock))
		. = paint_airlock(A, user)
	else if (istype(A, /mob/living/exosuit))
		to_chat(user, SPAN_WARNING("You can't paint an active exosuit. Dismantle it first."))
		. = FALSE
	else
		to_chat(user, SPAN_WARNING("\The [src] can only be used on floors, windows, walls, exosuits or certain airlocks."))
		. = FALSE
	if (.)
		add_fingerprint(user)
		playsound(get_turf(src), 'sound/effects/spray3.ogg', 30, 1, -6)
	return .

/obj/item/device/paint_sprayer/proc/remove_paint(atom/A, mob/user)
	if(!user.Adjacent(A) || user.incapacitated())
		return FALSE
	if (istype(A, /turf/simulated/floor))
		var/turf/simulated/floor/F = A
		if (F.decals && F.decals.len > 0)
			F.decals.len--
			F.update_icon()
			. = TRUE
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
	if (!F.decals || !F.decals.len)
		return FALSE
	var/list/available_colors = list()
	for (var/image/I in F.decals)
		available_colors |= isnull(I.color) ? COLOR_WHITE : I.color
	var/picked_color = available_colors[1]
	if (available_colors.len > 1)
		picked_color = input(user, "Which color do you wish to pick from?") as null|anything in available_colors
		if (user.incapacitated() || !user.Adjacent(F))
			return FALSE
	return picked_color

/obj/item/device/paint_sprayer/proc/paint_floor(turf/simulated/floor/F, mob/user, params)
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

	if((F.decals && F.decals.len > 5) && !ispath(painting_decal, /obj/effect/floor_decal/reset))
		to_chat(user, SPAN_WARNING("\The [F] has been painted too much; you need to clear it off."))
		return FALSE

	var/painting_dir = 0
	if(!decal_data["precise"])
		painting_dir = user.dir
	else
		var/list/mouse_control = params2list(params)
		var/mouse_x = text2num(mouse_control["icon-x"])
		var/mouse_y = text2num(mouse_control["icon-y"])
		if(isnum(mouse_x) && isnum(mouse_y))
			if(mouse_x <= 16)
				if(mouse_y <= 16)
					painting_dir = WEST
				else
					painting_dir = NORTH
			else
				if(mouse_y <= 16)
					painting_dir = SOUTH
				else
					painting_dir = EAST
		else
			painting_dir = user.dir

	var/painting_color
	if(decal_data["colored"] && paint_color)
		painting_color = paint_color

	new painting_decal(F, painting_dir, painting_color)
	return TRUE

/obj/item/device/paint_sprayer/proc/pick_color_from_airlock(obj/machinery/door/airlock/D, mob/user)
	if (!D.paintable)
		return FALSE
	switch (select_airlock_region(D, user, "Where do you wish to pick the color from?"))
		if (AIRLOCK_REGION_PAINT)
			return D.door_color
		if (AIRLOCK_REGION_STRIPE)
			return D.stripe_color
		if (AIRLOCK_REGION_WINDOW)
			return D.window_color
		else
			return FALSE

/obj/item/device/paint_sprayer/proc/paint_airlock(obj/machinery/door/airlock/D, mob/user)
	if (!D.paintable)
		to_chat(user, SPAN_WARNING("You can't paint this airlock type."))
		return FALSE

	switch (select_airlock_region(D, user, "What do you wish to paint?"))
		if (AIRLOCK_REGION_PAINT)
			D.paint_airlock(paint_color)
		if (AIRLOCK_REGION_STRIPE)
			D.stripe_airlock(paint_color)
		if (AIRLOCK_REGION_WINDOW)
			D.paint_window(paint_color)
		else
			return FALSE
	return TRUE

/obj/item/device/paint_sprayer/proc/select_airlock_region(obj/machinery/door/airlock/D, mob/user, input_text)
	var/choice
	var/list/choices = list()
	if (D.paintable & AIRLOCK_PAINTABLE)
		choices |= AIRLOCK_REGION_PAINT
	if (D.paintable & AIRLOCK_STRIPABLE)
		choices |= AIRLOCK_REGION_STRIPE
	if (D.paintable & AIRLOCK_WINDOW_PAINTABLE)
		choices |= AIRLOCK_REGION_WINDOW
	choice = input(user, input_text) as null|anything in sortList(choices)
	if (user.incapacitated() || !D || !user.Adjacent(D))
		return FALSE
	return choice

/obj/item/device/paint_sprayer/attack_self(mob/user)
	choose_decal()

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
	else
		. = ..()

/obj/item/device/paint_sprayer/CtrlClick()
	if (!isturf(loc))
		choose_color()
	else
		. = ..()

/obj/item/device/paint_sprayer/verb/choose_color()
	set name = "Choose color"
	set desc = "Choose a color."
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return
	var/new_color = input(usr, "Choose a color.", name, paint_color) as color|null
	if (usr.incapacitated())
		return
	change_color(new_color, usr)

/obj/item/device/paint_sprayer/verb/choose_preset_color()
	set name = "Choose Preset color"
	set desc = "Choose a preset color."
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return
	var/preset = input(usr, "Choose a color.", name, paint_color) as null|anything in preset_colors
	if(usr.incapacitated())
		return
	change_color(preset_colors[preset], usr)

/obj/item/device/paint_sprayer/verb/choose_decal()
	set name = "Choose Decal"
	set desc = "Choose a flooring decal."
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return
	var/new_decal = input("Select a decal.") as null|anything in decals
	if(usr.incapacitated())
		return
	if(new_decal && !isnull(decals[new_decal]))
		decal = new_decal
		to_chat(usr, SPAN_NOTICE("You set \the [src] decal to '[decal]'."))

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

#undef AIRLOCK_REGION_PAINT
#undef AIRLOCK_REGION_STRIPE
