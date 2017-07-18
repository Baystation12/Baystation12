#define DRINK_ICON_FILE 'icons/pdrink.dmi'

/var/const/DRINK_FIZZ = "fizz"
/var/const/DRINK_ICE = "ice"
/var/const/DRINK_VAPOR = "vapor"
/var/const/DRINK_ICON_DEFAULT = ""
/var/const/DRINK_ICON_NOISY = "_noise"

/obj/item/weapon/reagent_containers/food/drinks/glass2
	name = "glass" // Name when empty
	base_name = "glass"
	desc = "A generic drinking glass." // Description when empty
	icon = DRINK_ICON_FILE
	base_icon = "square" // Base icon name
	volume = 30

	var/list/extras = list() // List of extras. Two extras maximum

	var/rim_pos // Position of the rim for fruit slices. list(y, x_left, x_right)

	center_of_mass ="x=16;y=9"

	amount_per_transfer_from_this = 5
	possible_transfer_amounts = "5;10;15;30"
	flags = OPENCONTAINER

/obj/item/weapon/reagent_containers/food/drinks/glass2/examine(mob/M as mob)
	. = ..()

	for(var/I in extras)
		if(istype(I, /obj/item/weapon/glass_extra))
			to_chat(M, "There is \a [I] in \the [src].")
		else if(istype(I, /obj/item/weapon/reagent_containers/food/snacks/fruit_slice))
			to_chat(M, "There is \a [I] on the rim.")
		else
			to_chat(M, "There is \a [I] somewhere on the glass. Somehow.")

	if(has_ice())
		to_chat(M, "There is some ice floating in the drink.")

	if(has_fizz())
		to_chat(M, "It is fizzing slightly.")

/obj/item/weapon/reagent_containers/food/drinks/glass2/proc/has_ice()
	if(reagents.reagent_list.len > 0)
		var/datum/reagent/R = reagents.get_master_reagent()
		if(!((R.id == "ice") || ("ice" in R.glass_special))) // if it's not a cup of ice, and it's not already supposed to have ice in, see if the bartender's put ice in it
			if(reagents.has_reagent("ice", reagents.total_volume / 10)) // 10% ice by volume
				return 1

	return 0

/obj/item/weapon/reagent_containers/food/drinks/glass2/proc/has_fizz()
	if(reagents.reagent_list.len > 0)
		var/datum/reagent/R = reagents.get_master_reagent()
		if(!("fizz" in R.glass_special))
			var/totalfizzy = 0
			for(var/datum/reagent/re in reagents.reagent_list)
				if("fizz" in re.glass_special)
					totalfizzy += re.volume
			if(totalfizzy >= reagents.total_volume / 5) // 20% fizzy by volume
				return 1
	return 0

/obj/item/weapon/reagent_containers/food/drinks/glass2/proc/has_vapor()
	if(reagents.reagent_list.len > 0)
		var/datum/reagent/R = reagents.get_master_reagent()
		if(!("vapor" in R.glass_special))
			var/totalvape = 0
			for(var/datum/reagent/re in reagents.reagent_list)
				if("vapor" in re.glass_special)
					totalvape += re.volume
			if(totalvape >= volume * 0.6) // 60% vapor by container volume
				return 1
	return 0

/obj/item/weapon/reagent_containers/food/drinks/glass2/New()
	..()
	icon_state = base_icon

/obj/item/weapon/reagent_containers/food/drinks/glass2/on_reagent_change()
	update_icon()

/obj/item/weapon/reagent_containers/food/drinks/glass2/proc/can_add_extra(obj/item/weapon/glass_extra/GE)
	if(!("[base_icon]_[GE.glass_addition]left" in icon_states(DRINK_ICON_FILE)))
		return 0
	if(!("[base_icon]_[GE.glass_addition]right" in icon_states(DRINK_ICON_FILE)))
		return 0

	return 1

/obj/item/weapon/reagent_containers/food/drinks/glass2/update_icon()
	underlays.Cut()

	if (reagents.reagent_list.len > 0)
		var/datum/reagent/R = reagents.get_master_reagent()
		name = "[base_name] of [R.glass_name ? R.glass_name : "something"]"
		desc = R.glass_desc ? R.glass_desc : initial(desc)

		var/list/under_liquid = list()
		var/list/over_liquid = list()

		var/amnt = get_filling_state()

		if(has_ice())
			over_liquid |= "[base_icon][amnt]_ice"

		if(has_fizz())
			over_liquid |= "[base_icon][amnt]_fizz"

		if(has_vapor())
			over_liquid |= "[base_icon]_vapor"

		for(var/S in R.glass_special)
			if("[base_icon]_[S]" in icon_states(DRINK_ICON_FILE))
				under_liquid |= "[base_icon]_[S]"
			else if("[base_icon][amnt]_[S]" in icon_states(DRINK_ICON_FILE))
				over_liquid |= "[base_icon][amnt]_[S]"

		for(var/k in under_liquid)
			underlays += image(DRINK_ICON_FILE, src, k, -3)

		var/image/filling = image(DRINK_ICON_FILE, src, "[base_icon][amnt][R.glass_icon]", -2)
		filling.color = reagents.get_color()
		underlays += filling

		for(var/k in over_liquid)
			underlays += image(DRINK_ICON_FILE, src, k, -1)
	else
		name = initial(name)
		desc = initial(desc)

	var/side = "left"
	for(var/item in extras)
		if(istype(item, /obj/item/weapon/glass_extra))
			var/obj/item/weapon/glass_extra/GE = item
			var/image/I = image(DRINK_ICON_FILE, src, "[base_icon]_[GE.glass_addition][side]")
			if(GE.glass_color)
				I.color = GE.glass_color
			underlays += I
		else if(rim_pos && istype(item, /obj/item/weapon/reagent_containers/food/snacks/fruit_slice))
			var/obj/FS = item
			var/image/I = image(FS)

			var/list/rim_pos_data = cached_key_number_decode(rim_pos)
			var/fsy = rim_pos_data["y"] - 20
			var/fsx = rim_pos_data[side == "left" ? "x_left" : "x_right"] - 16

			var/matrix/M = matrix()
			M.Scale(0.5)
			M.Translate(fsx, fsy)
			I.transform = M
			underlays += I
		else continue
		side = "right"
