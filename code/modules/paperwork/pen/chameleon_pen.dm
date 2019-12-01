/obj/item/weapon/pen/chameleon
	var/signature = ""

/obj/item/weapon/pen/chameleon/attack_self(mob/user as mob)
	/*
	// Limit signatures to official crew members
	var/personnel_list[] = list()
	for(var/datum/data/record/t in data_core.locked) //Look in data core locked.
		personnel_list.Add(t.fields["name"])
	personnel_list.Add("Anonymous")

	var/new_signature = input("Enter new signature pattern.", "New Signature") as null|anything in personnel_list
	if(new_signature)
		signature = new_signature
	*/
	signature = sanitize(input("Enter new signature. Leave blank for 'Anonymous'", "New Signature", signature))

/obj/item/weapon/pen/proc/get_signature(var/mob/user)
	return (user && user.real_name) ? user.real_name : "Anonymous"

/obj/item/weapon/pen/chameleon/get_signature(var/mob/user)
	return signature ? signature : "Anonymous"

/obj/item/weapon/pen/chameleon/verb/set_colour()
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
		to_chat(usr, "<span class='info'>You select the [lowertext(selected_type)] ink container.</span>")