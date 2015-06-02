/obj/machinery/kitchen/oven
	name = "oven"
	desc = "It's a nice, clean electric oven."
	acceptable_containers = list(
		/obj/item/weapon/reagent_containers/kitchen/caketin,
		/obj/item/weapon/reagent_containers/kitchen/bakingtray,
		)

	// All temperatures are in C, note that it does NOT use atmos temp code (yet?)
	var/internal_temp = 20
	var/target_temp = 20
	var/open = 0
	var/obj/item/weapon/reagent_containers/kitchen/food_inside = null

/obj/machinery/kitchen/oven/examine()
	..()
	usr << "It is [open ? "open" : "closed"]."
	if(open)
		if(food_inside)
			usr << "There is \a [food_inside] inside."
		else
			usr << "It is empty."

/obj/machinery/kitchen/oven/update_icon()
	overlays.Cut()

	// Item overlay.
	if(food_inside)
		var/temp_icon = ("oven-[food_inside.name]" in icon_states(icon)) ? "oven-[food_inside.name]" : "oven-cakepan"
		overlays |= retrieve_cached_image(temp_icon,null,food_inside.color)

	// Heat overlay.
	var/new_light = 0
	if(internal_temp > min_temp)
		var/target_alpha = min(255,max(min_temp,internal_temp))
		if(open)
			new_light = max(0,round(target_alpha/120))
		overlays |= retrieve_cached_image("oven-on",target_alpha)
	if(new_light != light_power)
		set_light(light_range,new_light)

	// Door overlay.
	overlays |= retrieve_cached_image("oven_[open ? "open" : "closed"]")

/obj/machinery/kitchen/oven/proc/toggle_open(var/mob/user)
	open = !open
	user << "You [open ? "open" : "close"] the [src]."
	update_icon()

/obj/machinery/kitchen/oven/get_data()
	var/list/data = list()
	data["on"] =              (use_power==2) ? 1 : 0
	data["open"] =            open ? 1 : 0
	data["internalTemp"] =    internal_temp
	data["targetTemp"] =      target_temp
	data["minTemp"] =         min_temp
	data["maxTemp"] =         max_temp
	data["contents"] =        food_inside
	data["tempClass"] =       get_temperature_string(internal_temp)
	data["tempTargetClass"] = get_temperature_string(target_temp)
	return data

/obj/machinery/kitchen/oven/Topic(href, href_list)

	if(..())
		return

	if(href_list["temp"])
		var/amount = text2num(href_list["temp"])
		if(amount > 0)
			src.target_temp = min(src.target_temp+amount, max_temp)
		else
			src.target_temp = max(src.target_temp+amount, 0)
	if(href_list["toggleOpen"])
		toggle_open(usr)

	src.add_fingerprint(usr)
	return 1

// Opens or closes the oven.
/obj/machinery/kitchen/oven/AltClick()
	if(!usr.stat && !usr.lying && Adjacent(usr))
		if(open && food_inside)
			//TODO: burn your hands pulling out a hot tray.
			food_inside.loc = get_turf(src)
			visible_message("\The [usr] pulls \the [food_inside] out of \the [src].")
			if(istype(usr, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = usr
				if(!(H.l_hand && H.r_hand))
					H.put_in_hands(food_inside)
			food_inside = null
			update_icon()
		else
			toggle_open(usr)
		return
	return ..()