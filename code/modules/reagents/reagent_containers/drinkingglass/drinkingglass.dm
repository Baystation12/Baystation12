var/global/const/DRINK_FIZZ = "fizz"
var/global/const/DRINK_ICE = "ice"
var/global/const/DRINK_VAPOR = "vapor"
var/global/const/DRINK_ICON_DEFAULT = ""
var/global/const/DRINK_ICON_NOISY = "noise"

/obj/item/reagent_containers/food/drinks/glass2
	name = "glass" // Name when empty
	base_name = "glass"
	desc = "A generic drinking glass." // Description when empty
	icon = 'icons/obj/drink_glasses/square.dmi'
	icon_state = null
	base_icon = "square" // Base icon name
	filling_states = "20;40;60;80;100"
	volume = 30
	matter = list(MATERIAL_GLASS = 65)

	var/list/extras = list() // List of extras. Two extras maximum

	var/rim_pos // Position of the rim for fruit slices. list(y, x_left, x_right)
	var/filling_overlayed //if filling should go on top of the icon (e.g. opaque cups)
	var/static/list/filling_icons_cache = list()

	center_of_mass ="x=16;y=9"

	amount_per_transfer_from_this = 5
	possible_transfer_amounts = "5;10;15;30"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	temperature_coefficient = 4

	var/custom_name
	var/custom_desc

/obj/item/reagent_containers/food/drinks/glass2/examine(mob/M)
	. = ..()

	for(var/I in extras)
		if(istype(I, /obj/item/glass_extra))
			to_chat(M, "There is \a [I] in \the [src].")
		else if(istype(I, /obj/item/reagent_containers/food/snacks/fruit_slice))
			to_chat(M, "There is \a [I] on the rim.")
		else
			to_chat(M, "There is \a [I] somewhere on the glass. Somehow.")

	if(has_ice())
		to_chat(M, "There is some ice floating in the drink.")

	if(has_fizz())
		to_chat(M, "It is fizzing slightly.")

/obj/item/reagent_containers/food/drinks/glass2/proc/has_ice()
	if(length(reagents?.reagent_list))
		var/datum/reagent/R = reagents.get_master_reagent()
		if(!((R.type == /datum/reagent/drink/ice) || ("ice" in R.glass_special))) // if it's not a cup of ice, and it's not already supposed to have ice in, see if the bartender's put ice in it
			if(reagents.has_reagent(/datum/reagent/drink/ice, reagents.total_volume / 10)) // 10% ice by volume
				return 1

	return 0

/obj/item/reagent_containers/food/drinks/glass2/proc/has_fizz()
	if(length(reagents?.reagent_list))
		var/datum/reagent/R = reagents.get_master_reagent()
		if(("fizz" in R.glass_special))
			return 1
		var/totalfizzy = 0
		for(var/datum/reagent/re in reagents.reagent_list)
			if("fizz" in re.glass_special)
				totalfizzy += re.volume
		if(totalfizzy >= reagents.total_volume / 5) // 20% fizzy by volume
			return 1
	return 0

/obj/item/reagent_containers/food/drinks/glass2/proc/has_vapor()
	if(length(reagents?.reagent_list))
		if(temperature > T0C + 40)
			return 1
		var/datum/reagent/R = reagents.get_master_reagent()
		if(!("vapor" in R.glass_special))
			var/totalvape = 0
			for(var/datum/reagent/re in reagents.reagent_list)
				if("vapor" in re.glass_special)
					totalvape += re.volume
			if(totalvape >= volume * 0.6) // 60% vapor by container volume
				return 1
	return 0

/obj/item/reagent_containers/food/drinks/glass2/Initialize()
	. = ..()
	if(!icon_state)
		icon_state = base_icon

/obj/item/reagent_containers/food/drinks/glass2/on_reagent_change()
	temperature_coefficient = 4 / max(1, reagents.total_volume)
	update_icon()

/obj/item/reagent_containers/food/drinks/glass2/throw_impact(atom/hit_atom)
	if(QDELETED(src))
		return
	if(prob(80))
		if(length(reagents?.reagent_list))
			visible_message(
				SPAN_DANGER("\The [src] shatters from the impact and spills all its contents!"),
				SPAN_DANGER("You hear the sound of glass shattering!")
			)
			reagents.splash(hit_atom, reagents.total_volume)
		else
			visible_message(
				SPAN_DANGER("\The [src] shatters from the impact!"),
				SPAN_DANGER("You hear the sound of glass shattering!")
			)
		playsound(src.loc, pick(GLOB.shatter_sound), 100)
		new /obj/item/material/shard(src.loc)
		qdel(src)
	else
		if (length(reagents?.reagent_list))
			visible_message(
				SPAN_DANGER("\The [src] bounces and spills all its contents!"),
				SPAN_WARNING("You hear the sound of glass hitting something.")
			)
			reagents.splash(hit_atom, reagents.total_volume)
		else
			visible_message(
				SPAN_WARNING("\The [src] bounces dangerously. Luckily it didn't break."),
				SPAN_WARNING("You hear the sound of glass hitting something.")
			)
		playsound(src.loc, "sound/effects/Glasshit.ogg", 50)

/obj/item/reagent_containers/food/drinks/glass2/proc/can_add_extra(obj/item/glass_extra/GE)
	if(!("[base_icon]_[GE.glass_addition]left" in icon_states(icon)))
		return 0
	if(!("[base_icon]_[GE.glass_addition]right" in icon_states(icon)))
		return 0

	return 1

/obj/item/reagent_containers/food/drinks/glass2/proc/get_filling_overlay(amount, overlay)
	var/image/I = new()
	if(!filling_icons_cache["[base_icon][amount][overlay]"])
		var/icon/base = new/icon(icon, "[base_icon][amount]")
		if(overlay)
			var/icon/extra = new/icon('icons/obj/drink_glasses/extras.dmi', overlay)
			base.Blend(extra, ICON_MULTIPLY)
		filling_icons_cache["[base_icon][amount][overlay]"] = image(base)
	I.appearance = filling_icons_cache["[base_icon][amount][overlay]"]
	return I

/obj/item/reagent_containers/food/drinks/glass2/on_update_icon()
	underlays.Cut()
	overlays.Cut()

	if (length(reagents?.reagent_list))
		var/datum/reagent/R = reagents.get_master_reagent()
		SetName("[base_name] of [R.glass_name ? R.glass_name : "something"]")
		desc = R.glass_desc || custom_desc || initial(desc)

		var/list/under_liquid = list()
		var/list/over_liquid = list()

		var/amnt = get_filling_state()

		if(has_ice())
			over_liquid |= image(icon, src, "[base_icon][amnt]_ice")

		if(has_fizz())
			over_liquid |= get_filling_overlay(amnt, "fizz")

		if(has_vapor())
			over_liquid |= image(icon, src, "[base_icon]_vapor")

		for(var/S in R.glass_special)
			if("[base_icon]_[S]" in icon_states(icon))
				under_liquid |= image(icon, src, "[base_icon]_[S]")
			else if("[base_icon][amnt]_[S]" in icon_states(icon))
				over_liquid |= image(icon, src, "[base_icon][amnt]_[S]")

		underlays += under_liquid

		var/image/filling = get_filling_overlay(amnt, R.glass_icon)
		filling.color = reagents.get_color()
		if(filling_overlayed)
			overlays += filling
		else
			underlays += filling

		overlays += over_liquid

	else
		SetName(custom_name || initial(name))
		desc = custom_desc || initial(desc)

	var/side = "left"
	for(var/item in extras)
		if(istype(item, /obj/item/glass_extra))
			var/obj/item/glass_extra/GE = item
			var/image/I = image(icon, src, "[base_icon]_[GE.glass_addition][side]")
			I.color = GE.color
			underlays += I
		else if(rim_pos && istype(item, /obj/item/reagent_containers/food/snacks/fruit_slice))
			var/obj/FS = item
			var/image/I = image(FS)

			var/list/rim_pos_data = cached_key_number_decode(rim_pos)
			var/fsy = rim_pos_data["y"] - 20
			var/fsx = rim_pos_data[side == "left" ? "x_left" : "x_right"] - 16
			I.SetTransform(scale = 0.5, offset_x = fsx, offset_y = fsy)
			underlays += I
		else continue
		side = "right"

/obj/item/reagent_containers/food/drinks/glass2/afterattack(obj/target, mob/user, proximity)
	if (!proximity || standard_dispenser_refill(user, target) || standard_pour_into(user, target))
		return TRUE
	splashtarget(target, user)

/obj/item/reagent_containers/food/drinks/glass2/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/material/kitchen/utensil/spoon))
		if(user.a_intent == I_HURT)
			user.visible_message("<span class='warning'>[user] bashes \the [src] with a spoon, shattering it to pieces! What a rube.</span>")
			playsound(src, "shatter", 30, 1)
			if(reagents)
				user.visible_message("<span class='notice'>The contents of \the [src] splash all over [user]!</span>")
				reagents.splash(user, reagents.total_volume)
			qdel(src)
			return
		user.visible_message("<span class='notice'>[user] gently strikes \the [src] with a spoon, calling the room to attention.</span>")
		playsound(src, "sound/items/wineglass.ogg", 65, 1)
	else return ..()

/obj/item/reagent_containers/food/drinks/glass2/ProcessAtomTemperature()
	var/old_temp = temperature
	. = ..()
	if(old_temp != temperature)
		update_icon()