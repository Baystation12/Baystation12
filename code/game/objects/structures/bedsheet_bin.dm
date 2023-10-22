/*
CONTAINS:
BEDSHEETS
LINEN BINS
*/

/obj/item/bedsheet
	name = "bedsheet"
	desc = "A surprisingly soft linen bedsheet."
	icon = 'icons/obj/bedsheet.dmi'
	icon_state = "sheet"
	item_state = "bedsheet"
	randpixel = 0
	slot_flags = SLOT_BACK
	item_flags = ITEM_FLAG_WASHER_ALLOWED
	layer = BASE_ABOVE_OBJ_LAYER
	throwforce = 1
	throw_speed = 1
	throw_range = 2
	w_class = ITEM_SIZE_SMALL

/obj/item/bedsheet/use_tool(obj/item/tool, mob/living/user, list/click_params)
	if (is_sharp(tool))
		user.visible_message(SPAN_NOTICE("\The [user] begins cutting up \the [src] with \a [tool]."), SPAN_NOTICE("You begin cutting up \the [src] with \the [tool]."))
		if (do_after(user, 5 SECONDS, src, DO_REPAIR_CONSTRUCT))
			to_chat(user, SPAN_NOTICE("You cut \the [src] into pieces!"))
			for(var/i in 1 to rand(2,5))
				new /obj/item/reagent_containers/glass/rag(get_turf(src))
			qdel(src)
		return TRUE
	return ..()

/obj/item/bedsheet/blue
	icon_state = "sheetblue"
	item_state = "sheetblue"

/obj/item/bedsheet/green
	icon_state = "sheetgreen"
	item_state = "sheetgreen"

/obj/item/bedsheet/orange
	icon_state = "sheetorange"
	item_state = "sheetorange"

/obj/item/bedsheet/purple
	icon_state = "sheetpurple"
	item_state = "sheetpurple"

/obj/item/bedsheet/rainbow
	icon_state = "sheetrainbow"
	item_state = "sheetrainbow"

/obj/item/bedsheet/red
	icon_state = "sheetred"
	item_state = "sheetred"

/obj/item/bedsheet/yellow
	icon_state = "sheetyellow"
	item_state = "sheetyellow"

/obj/item/bedsheet/mime
	icon_state = "sheetmime"
	item_state = "sheetmime"

/obj/item/bedsheet/clown
	icon_state = "sheetclown"
	item_state = "sheetclown"

/obj/item/bedsheet/captain
	icon_state = "sheetcaptain"
	item_state = "sheetcaptain"

/obj/item/bedsheet/rd
	icon_state = "sheetrd"
	item_state = "sheetrd"

/obj/item/bedsheet/medical
	icon_state = "sheetmedical"
	item_state = "sheetmedical"

/obj/item/bedsheet/hos
	icon_state = "sheethos"
	item_state = "sheethos"

/obj/item/bedsheet/hop
	icon_state = "sheethop"
	item_state = "sheethop"

/obj/item/bedsheet/ce
	icon_state = "sheetce"
	item_state = "sheetce"

/obj/item/bedsheet/brown
	icon_state = "sheetbrown"
	item_state = "sheetbrown"


/obj/structure/bedsheetbin
	name = "linen bin"
	desc = "A linen bin. It looks rather cosy."
	icon = 'icons/obj/structures/structures.dmi'
	icon_state = "linenbin-full"
	anchored = TRUE
	var/amount = 20
	var/list/sheets = list()
	var/obj/item/hidden = null


/obj/structure/bedsheetbin/examine(mob/user)
	. = ..()

	if(amount < 1)
		to_chat(user, "There are no bed sheets in the bin.")
		return
	if(amount == 1)
		to_chat(user, "There is one bed sheet in the bin.")
		return
	to_chat(user, "There are [amount] bed sheets in the bin.")


/obj/structure/bedsheetbin/on_update_icon()
	var/fullness = amount / initial(amount)
	if (!fullness)
		icon_state = "linenbin-empty"
	else if (fullness < 0.5)
		icon_state = "linenbin-half"
	else
		icon_state = "linenbin-full"


/obj/structure/bedsheetbin/use_tool(obj/item/tool, mob/user, list/click_params)
	SHOULD_CALL_PARENT(FALSE)

	// Bed sheet - Add to bin
	if (istype(tool, /obj/item/bedsheet))
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		sheets += tool
		amount++
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] adds \a [tool] to \the [src]."),
			SPAN_NOTICE("You add \the [tool] to \the [src].")
		)
		return TRUE

	// Anything else - Attempt to hide
	if (!amount)
		USE_FEEDBACK_FAILURE("\The [src] has no bedsheets to hide \the [tool] in.")
		return TRUE
	if (tool.w_class >= ITEM_SIZE_HUGE)
		USE_FEEDBACK_FAILURE("\The [tool] is too large to hide in \the [src].")
		return TRUE
	if (hidden)
		USE_FEEDBACK_FAILURE("There's already something hidden in \the [src].")
		return TRUE
	if (!user.unEquip(tool, src))
		FEEDBACK_UNEQUIP_FAILURE(user, tool)
		return TRUE
	hidden = tool
	user.visible_message(
		SPAN_NOTICE("\The [user] stuffs \a [tool] into \the [src]'s sheets."),
		SPAN_NOTICE("You hide \the [tool] among \the [src]'s sheets."),
		3
	)
	return TRUE


/obj/structure/bedsheetbin/attack_hand(mob/user)
	var/obj/item/bedsheet/B = remove_sheet()
	if(B)
		user.put_in_hands(B)
		to_chat(user, SPAN_NOTICE("You take \a [B] out of \the [src]."))
		add_fingerprint(user)

/obj/structure/bedsheetbin/do_simple_ranged_interaction(mob/user)
	remove_sheet()
	return TRUE

/obj/structure/bedsheetbin/proc/remove_sheet()
	set waitfor = 0
	if(amount <= 0)
		return
	amount--
	var/obj/item/bedsheet/B
	if(length(sheets) > 0)
		B = sheets[length(sheets)]
		sheets.Remove(B)
	else
		B = new /obj/item/bedsheet(loc)
	B.dropInto(loc)
	update_icon()
	. = B
	sleep(-1)
	if(hidden)
		hidden.dropInto(loc)
		visible_message(SPAN_NOTICE("\The [hidden] falls out!"))
		hidden = null
