#define NEXT_PAGE_ID "__next__"
#define DEFAULT_CHECK_DELAY 20

var/global/list/radial_menus = list()

/obj/screen/radial/Destroy()
	parent = null
	return ..()

/obj/screen/radial
	icon = 'icons/screen/radial.dmi'
	layer = HUD_ABOVE_ITEM_LAYER
	plane = HUD_PLANE
	var/datum/radial_menu/parent

/obj/screen/radial/slice
	icon_state = "radial_slice"
	var/choice
	var/next_page = FALSE
	var/tooltips = FALSE

/obj/screen/radial/slice/MouseEntered(location, control, params)
	. = ..()
	icon_state = "radial_slice_focus"
	if (tooltips)
		openToolTip(usr, src, params, title = name)

/obj/screen/radial/slice/MouseExited(location, control, params)
	. = ..()
	icon_state = "radial_slice"
	if (tooltips)
		closeToolTip(usr)

/obj/screen/radial/slice/Click(location, control, params)
	if (parent && usr.client == parent.current_user)
		if (next_page)
			parent.next_page()
		else
			parent.element_chosen(choice,usr)

/obj/screen/radial/center
	name = "Close Menu"
	icon_state = "radial_center"

/obj/screen/radial/center/MouseEntered(location, control, params)
	. = ..()
	icon_state = "radial_center_focus"

/obj/screen/radial/center/MouseExited(location, control, params)
	. = ..()
	icon_state = "radial_center"

/obj/screen/radial/center/Click(location, control, params)
	if (usr.client == parent.current_user)
		parent.finished = TRUE

/datum/radial_menu
	var/list/choices = list() //List of choice id's
	var/list/choices_icons = list() //choice_id -> icon
	var/list/choices_values = list() //choice_id -> choice
	var/list/page_data = list() //list of choices per page


	var/selected_choice
	var/list/obj/screen/elements = list()
	var/obj/screen/radial/center/close_button
	var/client/current_user
	var/atom/anchor
	var/image/menu_holder
	var/finished = FALSE
	var/datum/callback/custom_check_callback
	var/next_check = 0
	var/check_delay = DEFAULT_CHECK_DELAY

	var/radius = 32
	var/starting_angle = 0
	var/ending_angle = 360
	var/zone = 360
	var/min_angle = 45 //Defaults are setup for this value, if you want to make the menu more dense these will need changes.
	var/max_elements
	var/pages = 1
	var/current_page = 1

	var/hudfix_method = TRUE //TRUE to change anchor to user, FALSE to shift by py_shift
	var/py_shift = 0
	var/entry_animation = TRUE

//If we swap to vis_contens inventory these will need a redo
/datum/radial_menu/proc/check_screen_border(mob/user)
	var/atom/movable/AM = anchor
	if (!istype(AM) || !AM.screen_loc)
		return
	if (AM in user.client.screen)
		if (hudfix_method)
			anchor = user
		else
			py_shift = 32
			restrict_to_dir(NORTH) //I was going to parse screen loc here but that's more effort than it's worth.

//Sets defaults
//These assume 45 deg min_angle
/datum/radial_menu/proc/restrict_to_dir(dir)
	switch(dir)
		if (NORTH)
			starting_angle = 270
			ending_angle = 135
		if (SOUTH)
			starting_angle = 90
			ending_angle = 315
		if (EAST)
			starting_angle = 0
			ending_angle = 225
		if (WEST)
			starting_angle = 180
			ending_angle = 45

/datum/radial_menu/proc/setup_menu(use_tooltips)
	if (ending_angle > starting_angle)
		zone = ending_angle - starting_angle
	else
		zone = 360 - starting_angle + ending_angle

	max_elements = round(zone / min_angle)
	var/paged = max_elements < length(choices)
	if (length(elements) < max_elements)
		var/elements_to_add = max_elements - length(elements)
		for (var/i in 1 to elements_to_add) //Create all elements
			var/obj/screen/radial/slice/new_element = new /obj/screen/radial/slice
			new_element.tooltips = use_tooltips
			new_element.parent = src
			elements += new_element

	var/page = 1
	page_data = list(null)
	var/list/current = list()
	var/list/choices_left = choices.Copy()
	while (length(choices_left))
		if (length(current) == max_elements)
			page_data[page] = current
			page++
			LIST_INC(page_data)
			current = list()
		if (paged && length(current) == max_elements - 1)
			current += NEXT_PAGE_ID
			continue
		else
			current += popleft(choices_left)
	if (paged && length(current) < max_elements)
		current += NEXT_PAGE_ID

	page_data[page] = current
	pages = page
	current_page = 1
	update_screen_objects(anim = entry_animation)

/datum/radial_menu/proc/update_screen_objects(anim = FALSE)
	var/list/page_choices = page_data[current_page]
	var/angle_per_element = round(zone / length(page_choices))
	for (var/i in 1 to length(elements))
		var/obj/screen/radial/E = elements[i]
		var/angle = Wrap(starting_angle + (i - 1) * angle_per_element,0,360)
		if (i > length(page_choices))
			HideElement(E)
		else
			SetElement(E,page_choices[i],angle,anim = anim,anim_order = i)

/datum/radial_menu/proc/HideElement(obj/screen/radial/slice/E)
	E.overlays.Cut()
	E.alpha = 0
	E.name = "None"
	E.maptext = null
	E.mouse_opacity = 0
	E.choice = null
	E.next_page = FALSE

/datum/radial_menu/proc/SetElement(obj/screen/radial/slice/E,choice_id,angle,anim,anim_order)
	//Position
	var/py = round(cos(angle) * radius) + py_shift
	var/px = round(sin(angle) * radius)
	if (anim)
		var/timing = anim_order * 0.5
		var/matrix/starting = matrix()
		starting.Scale(0.1,0.1)
		E.transform = starting
		var/matrix/TM = matrix()
		animate(E,pixel_x = px,pixel_y = py, transform = TM, time = timing)
	else
		E.pixel_y = py
		E.pixel_x = px

	//Visuals
	E.alpha = 255
	E.mouse_opacity = 1
	E.overlays.Cut()
	if (choice_id == NEXT_PAGE_ID)
		E.name = "Next Page"
		E.next_page = TRUE
		E.overlays.Add("radial_next")
	else
		if (istext(choices_values[choice_id]))
			E.name = choices_values[choice_id]
		else
			var/atom/movable/AM = choices_values[choice_id] //Movables only
			E.name = AM.name
		E.choice = choice_id
		E.maptext = null
		E.next_page = FALSE
		if (choices_icons[choice_id])
			E.overlays.Add(choices_icons[choice_id])

/datum/radial_menu/New()
	close_button = new
	close_button.parent = src

/datum/radial_menu/proc/Reset()
	choices.Cut()
	choices_icons.Cut()
	choices_values.Cut()
	current_page = 1

/datum/radial_menu/proc/element_chosen(choice_id,mob/user)
	selected_choice = choices_values[choice_id]

/datum/radial_menu/proc/get_next_id()
	return "c_[length(choices)]"

/datum/radial_menu/proc/set_choices(list/new_choices, use_tooltips, use_labels)
	if (length(choices))
		Reset()
	for (var/E in new_choices)
		var/id = get_next_id()
		choices += id
		choices_values[id] = E
		if (new_choices[E])
			var/I = extract_image(new_choices[E], use_labels)
			if (I)
				choices_icons[id] = I
	setup_menu(use_tooltips)


/datum/radial_menu/proc/extract_image(image/E, use_labels)
	var/mutable_appearance/MA = new /mutable_appearance(E)
	if (MA)
		MA.layer = HUD_ABOVE_HUD_LAYER
		MA.appearance_flags |= RESET_TRANSFORM
		if (use_labels)
			MA.maptext_width = 64
			MA.maptext_height = 64
			MA.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
			MA.maptext_x = -round(MA.maptext_width/2) + 16
			MA.maptext_x = -round(MA.maptext_height/2) + 16
			MA.maptext = STYLE_SMALLFONTS_OUTLINE("<center>[E.name]</center>", 7, COLOR_WHITE, COLOR_BLACK)

	return MA


/datum/radial_menu/proc/next_page()
	if (pages > 1)
		current_page = Wrap(current_page + 1,1,pages+1)
		update_screen_objects()

/datum/radial_menu/proc/show_to(mob/M)
	if (current_user)
		hide()
	if (!M.client || !anchor)
		return
	current_user = M.client
	//Blank
	menu_holder = image(icon = 'icons/effects/effects.dmi', loc = anchor, icon_state = "nothing", layer = HUD_ABOVE_ITEM_LAYER)
	menu_holder.appearance_flags |= KEEP_APART
	menu_holder.vis_contents |= (elements + close_button)
	current_user.images += menu_holder

/datum/radial_menu/proc/hide()
	if (current_user)
		current_user.images -= menu_holder

/datum/radial_menu/proc/wait(atom/user, atom/anchor, require_near = FALSE, list/check_locs)
	while (current_user && !finished && !selected_choice)
		if (require_near && !in_range(anchor, user))
			return

		for (var/atom/movable/thing in check_locs)
			if (QDELETED(thing) || thing.loc != check_locs[thing])
				return

		if (custom_check_callback && next_check < world.time)
			if (!invoke(custom_check_callback))
				return
			else
				next_check = world.time + check_delay
		stoplag(1)

/datum/radial_menu/Destroy()
	Reset()
	hide()
	QDEL_NULL_LIST(elements)
	QDEL_NULL(close_button)
	QDEL_NULL(custom_check_callback)
	return ..()

/*
	Presents radial menu to user anchored to anchor (or user if the anchor is currently in users screen)
	Choices should be a list where list keys are movables or text used for element names and return value
	and list values are movables/icons/images used for element icons
*/
/proc/show_radial_menu(mob/user, atom/anchor, list/choices, uniqueid, radius, datum/callback/custom_check, require_near = FALSE, tooltips = FALSE, no_repeat_close = FALSE, list/check_locs, use_labels = FALSE)
	if (!user || !anchor || !length(choices))
		return
	if (!uniqueid)
		uniqueid = "defmenu_[any2ref(user)]_[any2ref(anchor)]"

	if (check_locs)
		for (var/atom/thing in check_locs)
			check_locs[thing] = thing.loc

	if (global.radial_menus[uniqueid])
		if (!no_repeat_close)
			var/datum/radial_menu/menu = global.radial_menus[uniqueid]
			menu.finished = TRUE
		return

	var/datum/radial_menu/menu = new
	global.radial_menus[uniqueid] = menu
	if (radius)
		menu.radius = radius
	if (istype(custom_check))
		menu.custom_check_callback = custom_check
	menu.anchor = anchor
	menu.check_screen_border(user) //Do what's needed to make it look good near borders or on hud
	menu.set_choices(choices, tooltips, use_labels)
	menu.show_to(user)
	menu.wait(user, anchor, require_near, check_locs)
	var/answer = menu.selected_choice
	qdel(menu)
	global.radial_menus -= uniqueid
	return answer

#define RADIAL_INPUT(user, choices) show_radial_menu(user, user, choices)

/*
	Helper to make a radial menu button with a name and icon for a given atom.
*/
/proc/make_item_radial_menu_button(atom/movable/AM, name_prefix = "", name_suffix = "")
	var/image/radial_button = new
	radial_button.appearance = AM
	radial_button.plane = FLOAT_PLANE
	radial_button.layer = FLOAT_LAYER
	radial_button.name = "[name_prefix][AM.name][name_suffix]"
	return radial_button

/*
	Helper to make a radial menu button for a set of atoms with their names and icons.
*/
/proc/make_item_radial_menu_choices(list/items, name_prefix = "", name_suffix = "")
	for (var/atom/movable/AM in items)
		LAZYSET(., AM, make_item_radial_menu_button(AM, name_prefix, name_suffix))
