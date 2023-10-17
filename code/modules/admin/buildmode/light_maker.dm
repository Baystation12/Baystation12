/datum/build_mode/light_maker
	name = "Light Maker"
	icon_state = "buildmode8"

	var/light_range = 3
	var/light_power = 1
	var/light_color = COLOR_WHITE

/datum/build_mode/light_maker/Help()
	to_chat(usr, SPAN_NOTICE("***********************************************************"))
	to_chat(usr, SPAN_NOTICE("Left Click                       = Make it glow"))
	to_chat(usr, SPAN_NOTICE("Right Click                      = Reset glow"))
	to_chat(usr, SPAN_NOTICE("Right Click on Build Mode Button = Change glow properties"))
	to_chat(usr, SPAN_NOTICE("***********************************************************"))

/datum/build_mode/light_maker/Configurate()
	var/choice = alert("Change the new light range, power, or color?", "Light Maker", "Range", "Power", "Color", "Cancel")
	switch(choice)
		if("Range")
			var/input = input("New light range.", name, light_range) as null|num
			if(input)
				light_range = input
		if("Power")
			var/input = input("New light power, from 0.1 to 1 in decimal increments.", name, light_power) as null|num
			if(input)
				input = clamp(input, 0.1, 1)
				light_power = input
		if("Color")
			var/input = input("New light color.", name, light_color) as null|color
			if(input)
				light_color = input

/datum/build_mode/light_maker/OnClick(atom/A, list/parameters)
	if(parameters["left"])
		if(A)
			A.set_light(light_range, light_power, l_color = light_color)
	if(parameters["right"])
		if(A)
			A.set_light(0, 0, 0, l_color = COLOR_WHITE)
