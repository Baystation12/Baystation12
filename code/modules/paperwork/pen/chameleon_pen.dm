/obj/item/pen/chameleon
	var/signature = ""

/obj/item/pen/chameleon/attack_self(mob/user as mob)
	signature = sanitize(input("Enter new signature. Leave blank for 'Anonymous'", "New Signature", signature))

/obj/item/pen/proc/get_signature(mob/user)
	return (user && user.real_name) ? user.real_name : "Anonymous"

/obj/item/pen/chameleon/get_signature(mob/user)
	return signature ? signature : "Anonymous"

/obj/item/pen/chameleon/verb/set_colour()
	set name = "Change Pen Colour"
	set category = "Object"

	var/list/possible_colours = list ("Yellow", "Green", "Pink", "Blue", "Orange", "Cyan", "Red", "Invisible", "Black")
	var/selected_type = input("Pick new colour.", "Pen Colour", null, null) as null|anything in possible_colours

	if(selected_type)
		switch(selected_type)
			if("Yellow")
				colour = COLOR_YELLOW
				color_description = "yellow ink"
			if("Green")
				colour = COLOR_LIME
				color_description = "green ink"
			if("Pink")
				colour = COLOR_PINK
				color_description = "pink ink"
			if("Blue")
				colour = COLOR_BLUE
				color_description = "blue ink"
			if("Orange")
				colour = COLOR_ORANGE
				color_description = "orange ink"
			if("Cyan")
				colour = COLOR_CYAN
				color_description = "cyan ink"
			if("Red")
				colour = COLOR_RED
				color_description = "red ink"
			if("Invisible")
				colour = COLOR_WHITE
				color_description = "transluscent ink"
			else
				colour = COLOR_BLACK
				color_description = "black ink"
		to_chat(usr, SPAN_INFO("You select the [lowertext(selected_type)] ink container."))
