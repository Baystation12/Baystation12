#define TOPLEFT "top left"
#define TOPRIGHT "top right"
#define BOTTOMLEFT "bottom left"
#define BOTTOMRIGHT "bottom right"

/obj/machinery/kitchen/stove
	name = "stove"
	desc = "It's a compact stove, able to cook four things at once!"
	icon_state = "stove"
	nano_template = "stove.tmpl"
	acceptable_containers = list(
		/obj/item/weapon/reagent_containers/kitchen/fryingpan,
		/obj/item/weapon/reagent_containers/kitchen/pot
		)

	// BURNER DATA.
	var/list/burner_contents = list(
		TOPLEFT =     0,
		TOPRIGHT =    0,
		BOTTOMLEFT =  0,
		BOTTOMRIGHT = 0
		)

	var/list/burners_temperature = list(
		TOPLEFT =     0,
		TOPRIGHT =    0,
		BOTTOMLEFT =  0,
		BOTTOMRIGHT = 0
		)

	var/list/burners_target_temp = list(
		TOPLEFT =     0,
		TOPRIGHT =    0,
		BOTTOMLEFT =  0,
		BOTTOMRIGHT = 0
		)

	// Global helpers.
	var/global/list/possible_temperatures = list(20,40,60,120,200)
	var/global/list/burner_offsets = list(TOPLEFT = list(-6,7),TOPRIGHT = list(6,7),BOTTOMLEFT = list(-6,-1),BOTTOMRIGHT = list(6,-1))

/obj/machinery/kitchen/stove/New()
	..()
	for(var/burner in burner_contents)
		burners_temperature[burner] = min_temp
		burners_target_temp[burner] = min_temp

/obj/machinery/kitchen/stove/examine()
	..()
	for(var/burner in burner_contents)
		var/obj/item/I = burner_contents[burner]
		if(istype(I)) usr << "There is \a [I] on the [burner] burner."

/obj/machinery/kitchen/stove/get_data()
	var/list/data = ..()
	var/list/burner_state_data = list()
	for(var/burner in burners_temperature)
		var/list/burner_data = list()
		var/obj/item/I = burner_contents[burner]
		burner_data["name"] = burner
		if(istype(I))
			burner_data["burnerContents"] = I.name
		burner_data["actualTemp"] = burners_temperature[burner]
		burner_data["targetTemp"] = burners_target_temp[burner]
		burner_data["tempClass"] = get_temperature_string(burners_temperature[burner])
		burner_data["tempTargetClass"] = get_temperature_string(burners_target_temp[burner])
		burner_state_data[++burner_state_data.len] = burner_data
	data["contents"] = burner_state_data
	return data

/obj/machinery/kitchen/stove/update_icon()
	overlays.Cut()
	var/new_light = 0
	for(var/burner in burners_temperature)
		// Update the glowing icons for the lit stovetops.
		var/list/offset = burner_offsets[burner]
		if(burners_temperature[burner] > min_temp)
			var/target_alpha = min(255,max(min_temp,burners_temperature[burner]*2))
			if(round(target_alpha/180) > new_light) new_light = max(0,round(target_alpha/180))
			overlays |= retrieve_cached_image("stove-on",target_alpha,null,offset[1],offset[2])

		// Update the overlays for the food items on the stovetop.
		var/obj/item/I = burner_contents[burner]
		if(!istype(I))
			continue
		var/temp_icon = ("stove-[I.icon_state]" in icon_states(icon)) ? "stove-[I.icon_state]" : "stove-fryingpan"
		overlays |= retrieve_cached_image(temp_icon,null,I.color,offset[1],offset[2])

	if(new_light != light_power)
		set_light(light_range,new_light)

/obj/machinery/kitchen/stove/Topic(href, href_list)

	if(..())
		return

	var/target_burner = href_list["burnerName"]
	if(target_burner)
		if(href_list["removeItem"])
			remove_burner(target_burner,usr)
			update_icon()
		if(href_list["temp"])
			var/amount = text2num(href_list["temp"])
			burners_target_temp[target_burner] = max(min_temp,min(burners_target_temp[target_burner]+amount, max_temp))
	src.add_fingerprint(usr)
	return 1


/obj/machinery/kitchen/stove/AltClick()
	if(!usr.stat && !usr.lying && Adjacent(usr))
		remove_burner(null,usr)
		return
	return ..()

// Remove a random item from the stove. You're in a hurry!
/obj/machinery/kitchen/stove/proc/remove_burner(var/burner, var/mob/living/user)
	if(user.stat || user.lying || !Adjacent(user))
		return

	if(!burner)
		var/list/occupied_burners = list()
		for(var/check_burner in burner_contents)
			var/obj/item/I = burner_contents[check_burner]
			if(istype(I))
				occupied_burners |= check_burner
		if(occupied_burners.len)
			burner = pick(occupied_burners)

	if(!burner)
		return

	var/obj/item/I = burner_contents[burner]
	if(istype(I))
		I.loc = get_turf(user)
		var/mob/living/carbon/human/H = user
		if(istype(H) && !(H.l_hand && H.r_hand))
			H.put_in_hands(I)
		visible_message("\The [user] takes \the [I] from \the [src]'s [burner] burner.")
		burner_contents[burner] = 0
		update_icon()

#undef TOPLEFT
#undef TOPRIGHT
#undef BOTTOMLEFT
#undef BOTTOMRIGHT