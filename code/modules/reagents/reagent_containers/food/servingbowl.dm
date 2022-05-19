/obj/item/serving_bowl
	name = "serving bowl"
	desc = "A portion-sized bowl for serving hungry customers."
	icon = 'icons/obj/food_custom.dmi'
	icon_state = "serving_bowl"
	center_of_mass = "x=16;y=10"
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_PLASTIC = 300)


/obj/item/serving_bowl/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/custombowl/S = new(get_turf(src))
		user.put_in_hands(S)
		S.attackby(W,user)
		qdel(src)
		return
	. = ..()

/obj/item/reagent_containers/food/snacks/custombowl
	name = "serving bowl"
	desc = "A delicious bowl of food."
	icon = 'icons/obj/food_custom.dmi'
	icon_state = "serving_bowl"
	filling_color = null
	trash = /obj/item/serving_bowl //reusable
	bitesize = 2
	var/list/ingredients = list()
	var/fullname = ""
	var/renamed = 0

/obj/item/reagent_containers/food/snacks/custombowl/verb/rename_bowl()
	set name = "Rename Bowl"
	set category = "Object"
	var/mob/user = usr
	var/bowl_label = ""

	if(!renamed)
		bowl_label = sanitizeSafe(input(user, "Enter a new name for \the [src].", "Name", label_text), MAX_NAME_LEN)
		if(bowl_label)
			to_chat(user, SPAN_NOTICE("You rename \the [src] to \"[bowl_label] bowl\"."))
			SetName("\improper [bowl_label] bowl")
			renamed = 1

/obj/item/reagent_containers/food/snacks/custombowl/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/reagent_containers/food/snacks))
		if(contents.len >= 4)
			to_chat(user, SPAN_WARNING("There's no room for any more ingredients in \the [src]."))
			return
		else
			if(!user.unEquip(W, src))
				return
			user.visible_message(
				SPAN_NOTICE("\The [user] adds \the [W] to \the [src]."),
				SPAN_NOTICE("You add \the [W] to \the [src].")
			)
			var/obj/item/reagent_containers/F = W
			F.reagents.trans_to_obj(src, F.reagents.total_volume)
			ingredients += W
			update()
			return
	. = ..()

/obj/item/reagent_containers/food/snacks/custombowl/proc/update()
	var/i = 0
	overlays.Cut()

	filling_color = null
	var/list/ingredient_names = list()
	for (var/obj/item/reagent_containers/food/snacks/O as anything in ingredients)
		if (isnull(filling_color))
			filling_color = O.filling_color
		ingredient_names |= O.name // Use |= instead of += in case of duplicates, to avoid i.e. 'Chocolate, chocolate, and vanilla'

		i++
		var/image/I = new(icon, "serving_bowl_[i]")
		I.color = O.filling_color
		overlays += I

	fullname = english_list(ingredient_names)
	SetName(lowertext("[english_list(ingredient_names)] bowl"))
	renamed = 0 //updating removes custom name

/obj/item/reagent_containers/food/snacks/custombowl/Destroy()
	QDEL_NULL_LIST(ingredients)
	. = ..()

/obj/item/reagent_containers/food/snacks/custombowl/examine(mob/user)
	. = ..(user)
	to_chat(user, SPAN_ITALIC("This one contains [fullname]."))