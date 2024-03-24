/obj/item/clothing/mask/smokable/cigarette/rolled
	name = "rolled cigarette"
	desc = "A hand-rolled cigarette filled with dried plant matter."
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
		to_chat(user, "One of the ends is capped off by a filter.")

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
	desc = "A thin piece of Trident-branded paper used to make fine smokeables."
	icon_state = "cig_paperf"

/obj/item/paper/cig/filter
	name = "cigarette filter"
	desc = "A small nub-like filter for cigarettes."
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

/obj/item/clothing/mask/smokable/cigarette/rolled/use_tool(obj/item/I, mob/living/user, list/click_params)
	if(istype(I, /obj/item/paper/cig/filter))
		if(filter)
			to_chat(user, SPAN_WARNING("\The [src] already has a filter!"))
			return TRUE
		if(lit)
			to_chat(user, SPAN_WARNING("\The [src] is already lit!"))
			return TRUE
		if(user.unEquip(I))
			to_chat(user, SPAN_NOTICE("You stick [I] onto \the [src]."))
			filter = 1
			SetName("filtered [name]")
			brand = "[brand] with a filter"
			update_icon()
			qdel(I)
			return TRUE
	return ..()

/obj/item/reagent_containers/food/snacks/grown/use_tool(obj/item/I, mob/living/user, list/click_params)
	if(is_type_in_list(I, list(/obj/item/paper/cig, /obj/item/paper, /obj/item/teleportation_scroll)))
		if(!dry)
			to_chat(user, SPAN_WARNING("You need to dry \the [src] first!"))
			return TRUE
		if(user.unEquip(I))
			var/obj/item/clothing/mask/smokable/cigarette/rolled/R = new(get_turf(src))
			R.chem_volume = reagents.total_volume
			R.brand = "[src] handrolled in \the [I]."
			reagents.trans_to_holder(R.reagents, R.chem_volume)
			to_chat(user, SPAN_NOTICE("You roll \the [src] into \the [I]."))
			user.put_in_active_hand(R)
			qdel(I)
			qdel(src)
			return TRUE
	return ..()
