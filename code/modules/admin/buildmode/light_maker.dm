/datum/build_mode/light_maker
	name = "Light Maker"
	icon_state = "buildmode8"

	var/light_range = 3
	var/light_power = 3
	var/light_color = COLOR_WHITE

/datum/build_mode/light_maker/Help()
	to_chat(usr, "<span class='notice'>***********************************************************</span>")
	to_chat(usr, "<span class='notice'>Left Click                       = Make it glow</span>")
	to_chat(usr, "<span class='notice'>Right Click                      = Reset glow</span>")
	to_chat(usr, "<span class='notice'>Right Click on Build Mode Button = Change glow properties</span>")
	to_chat(usr, "<span class='notice'>***********************************************************</span>")

/datum/build_mode/light_maker/Configurate()
	var/choice = alert("Change the new light range, power, or color?", "Light Maker", "Range", "Power", "Color", "Cancel")
	switch(choice)
		if("Range")
			var/input = input("New light range.", name, light_range) as null|num
			if(input)
				light_range = input
		if("Power")
			var/input = input("New light power.", name, light_power) as null|num
			if(input)
				light_power = input
		if("Color")
			var/input = input("New light color.", name, light_color) as null|color
			if(input)
				light_color = input

/datum/build_mode/light_maker/OnClick(var/atom/A, var/list/parameters)
	if(parameters["left"])
		if(A)
			A.set_light(light_range, light_power, light_color)
	if(parameters["right"])
		if(A)
			A.set_light(0, 0, COLOR_WHITE)
