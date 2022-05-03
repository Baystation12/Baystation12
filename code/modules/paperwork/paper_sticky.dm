/obj/item/sticky_pad
	name = "sticky note pad"
	desc = "A pad of densely packed sticky notes."
	color = COLOR_YELLOW
	icon = 'icons/obj/stickynotes.dmi'
	icon_state = "pad_full"
	item_state = "paper"
	w_class = ITEM_SIZE_SMALL

	var/papers = 50
	var/written_text
	var/written_by
	var/paper_type = /obj/item/paper/sticky

/obj/item/sticky_pad/on_update_icon()
	if(papers <= 15)
		icon_state = "pad_empty"
	else if(papers <= 50)
		icon_state = "pad_used"
	else
		icon_state = "pad_full"
	if(written_text)
		icon_state = "[icon_state]_writing"

/obj/item/sticky_pad/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing, /obj/item/pen))

		if(jobban_isbanned(user, "Graffiti"))
			to_chat(user, SPAN_WARNING("You are banned from leaving persistent information across rounds."))
			return

		var/writing_space = MAX_MESSAGE_LEN - length(written_text)
		if(writing_space <= 0)
			to_chat(user, SPAN_WARNING("There is no room left on \the [src]."))
			return
		var/text = sanitizeSafe(input("What would you like to write?") as text, writing_space)
		if(!text || thing.loc != user || (!Adjacent(user) && loc != user) || user.incapacitated())
			return
		user.visible_message(SPAN_NOTICE("\The [user] jots a note down on \the [src]."))
		written_by = user.ckey
		if(written_text)
			written_text = "[written_text] [text]"
		else
			written_text = text
		update_icon()
		return
	..()

/obj/item/sticky_pad/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("It has [papers] sticky note\s left."))
	to_chat(user, SPAN_NOTICE("You can click it on grab intent to pick it up."))

/obj/item/sticky_pad/attack_hand(var/mob/user)
	if(user.a_intent == I_GRAB)
		..()
	else
		var/obj/item/paper/paper = new paper_type(get_turf(src))
		paper.set_content(written_text, "sticky note")
		paper.last_modified_ckey = written_by
		paper.color = color
		written_text = null
		user.put_in_hands(paper)
		to_chat(user, SPAN_NOTICE("You pull \the [paper] off \the [src]."))
		papers--
		if(papers <= 0)
			qdel(src)
		else
			update_icon()

/obj/item/sticky_pad/random/Initialize()
	. = ..()
	color = pick(COLOR_YELLOW, COLOR_LIME, COLOR_CYAN, COLOR_ORANGE, COLOR_PINK)

/obj/item/paper/sticky
	name = "sticky note"
	desc = "Note to self: buy more sticky notes."
	icon = 'icons/obj/stickynotes.dmi'
	color = COLOR_YELLOW
	slot_flags = 0

/obj/item/paper/sticky/Initialize()
	. = ..()
	GLOB.moved_event.register(src, src, /obj/item/paper/sticky/proc/reset_persistence_tracking)

/obj/item/paper/sticky/proc/reset_persistence_tracking()
	SSpersistence.forget_value(src, /datum/persistent/paper/sticky)
	pixel_x = 0
	pixel_y = 0

/obj/item/paper/sticky/Destroy()
	reset_persistence_tracking()
	GLOB.moved_event.unregister(src, src)
	. = ..()

/obj/item/paper/sticky/on_update_icon()
	if(icon_state != "scrap")
		icon_state = info ? "paper_words" : "paper"

// Copied from duct tape.
/obj/item/paper/sticky/attack_hand()
	. = ..()
	if(!istype(loc, /turf))
		reset_persistence_tracking()

/obj/item/paper/sticky/can_bundle()
	return FALSE // Would otherwise lead to buggy interaction

/obj/item/paper/sticky/afterattack(var/A, var/mob/user, var/flag, var/params)

	if(!in_range(user, A) || istype(A, /obj/machinery/door) || istype(A, /obj/item/storage) || icon_state == "scrap")
		return

	var/turf/target_turf = get_turf(A)
	var/turf/source_turf = get_turf(user)

	var/dir_offset = 0
	if(target_turf != source_turf)
		dir_offset = get_dir(source_turf, target_turf)
		if(!(dir_offset in GLOB.cardinal))
			to_chat(user, SPAN_WARNING("You cannot reach that from here."))
			return

	if(user.unEquip(src, source_turf))
		SSpersistence.track_value(src, /datum/persistent/paper/sticky)
		if(params)
			var/list/mouse_control = params2list(params)
			if(mouse_control["icon-x"])
				pixel_x = text2num(mouse_control["icon-x"]) - 16
				if(dir_offset & EAST)
					pixel_x += 32
				else if(dir_offset & WEST)
					pixel_x -= 32
			if(mouse_control["icon-y"])
				pixel_y = text2num(mouse_control["icon-y"]) - 16
				if(dir_offset & NORTH)
					pixel_y += 32
				else if(dir_offset & SOUTH)
					pixel_y -= 32
