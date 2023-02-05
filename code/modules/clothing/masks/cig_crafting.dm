/obj/item/clothing/mask/smokable/cigarette/rolled
	name = "rolled cigarette"
	desc = "A hand rolled cigarette using dried plant matter."
	icon_state = "cigroll"
	item_state = "cigoff"
	type_butt = /obj/item/trash/cigbutt
	chem_volume = 50
	brand = "handrolled"
	filling = list()
	var/filter = 0

/obj/item/clothing/mask/smokable/cigarette/rolled/examine(mob/user)
	. = ..()
	if(filter)
		to_chat(user, "Capped off one end with a filter.")

/obj/item/clothing/mask/smokable/cigarette/rolled/on_update_icon()
	. = ..()
	if(!lit)
		icon_state = filter ? "cigoff" : "cigroll"
/////////// //Ported Straight from TG. I am not sorry. - BloodyMan  //YOU SHOULD BE
//ROLLING//
///////////
/obj/item/paper/cig
	name = "rolling paper"
	desc = "A thin piece of paper used to make smokeables."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cig_paper"
	w_class = ITEM_SIZE_TINY
	is_memo = TRUE

/obj/item/paper/cig/fancy
	name = "\improper Trident rolling paper"
	desc = "A thin piece of trident branded paper used to make fine smokeables."
	icon_state = "cig_paperf"

/obj/item/paper/cig/filter
	name = "cigarette filter"
	desc = "A small nub like filter for cigarettes."
	icon_state = "cig_filter"
	w_class = ITEM_SIZE_TINY

//tobacco sold seperately if you're too snobby to grow it yourself.
/obj/item/reagent_containers/food/snacks/grown/dried_tobacco
	plantname = "tobacco"
	w_class = ITEM_SIZE_TINY

/obj/item/reagent_containers/food/snacks/grown/dried_tobacco/Initialize()
	. = ..()
	dry = TRUE
	SetName("dried [name]")
	color = "#a38463"
/obj/item/reagent_containers/food/snacks/grown/dried_tobacco/bad
	plantname = "badtobacco"

/obj/item/reagent_containers/food/snacks/grown/dried_tobacco/fine
	plantname = "finetobacco"


/obj/item/clothing/mask/smokable/cigarette/rolled/get_interactions_info()
	. = ..()
	.["Cigarette Filter"] = "<p>Adds a filter to the cigarette. The cigarette cannot be lit, and only one filter can be installed per cigarette.</p>"


/obj/item/clothing/mask/smokable/cigarette/rolled/use_tool(obj/item/tool, mob/user, list/click_params)
	// Cigarette Filter - Add filter
	if (istype(tool, /obj/item/paper/cig/filter))
		if (filter)
			to_chat(user, SPAN_WARNING("\The [src] already has a filter."))
			return TRUE
		if (lit)
			to_chat(user, SPAN_WARNING("\The [src] is already lit. You cannot install a filter now."))
			return TRUE
		if (!user.unEquip(tool, src))
			to_chat(user, SPAN_WARNING("You can't drop \the [tool]."))
			return TRUE
		filter = TRUE
		SetName("filtered [name]")
		brand = "[brand] with a filter"
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] adds \a [tool] to \the [src]."),
			SPAN_NOTICE("You add \the [tool] to \the [src].")
		)
		qdel(tool)
		return TRUE

	return ..()


/obj/item/reagent_containers/food/snacks/grown/get_interactions_info()
	. = ..()
	.["Paper"] = "<p>If the plant is dried, rolls it up into a cigarette using the paper. This consumes both the paper and plant.</p>"


/obj/item/reagent_containers/food/snacks/grown/use_tool(obj/item/tool, mob/user, list/click_params)
	// Paper - Roll dried plant into a cigarette
	if (istype(tool, /obj/item/paper))
		if (!dry)
			to_chat(user, SPAN_WARNING("\The [src] needs to be dried before you can wrap it into a cigarette with \the [tool]."))
			return TRUE
		if (!user.unEquip(tool))
			to_chat(user, SPAN_WARNING("You can't drop \the [tool]."))
			return TRUE
		if (loc == user && !user.unEquip(src))
			to_chat(user, SPAN_WARNING("You can't drop \the [src]."))
			return TRUE
		var/obj/item/clothing/mask/smokable/cigarette/rolled/rolled_cig = new(get_turf(src))
		rolled_cig.chem_volume = reagents.total_volume
		rolled_cig.brand = "\The [src] handrolled in \the [tool]."
		reagents.trans_to_holder(rolled_cig.reagents, rolled_cig.chem_volume)
		qdel(tool)
		qdel(src)
		user.put_in_active_hand(rolled_cig)
		user.visible_message(
			SPAN_NOTICE("\The [user] rolls \the [src] into \a [tool], making \a [rolled_cig]."),
			SPAN_NOTICE("You roll \the [src] into \the [tool], making \a [rolled_cig].")
		)
		return TRUE

	return ..()
