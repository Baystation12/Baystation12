/obj/item/pen/multi
	name = "multicoloured pen"
	desc = "It's a pen with multiple colors of ink!"
	var/selectedColor = 1
	var/colors = list("black","blue","red","green")
	var/color_descriptions = list("black ink", "blue ink", "red ink", "green ink")

/obj/item/pen/multi/attack_self(mob/user)
	if(++selectedColor > length(colors))
		selectedColor = 1

	colour = colors[selectedColor]
	color_description = color_descriptions[selectedColor]

	if(colour == "black")
		icon_state = "pen"
	else
		icon_state = "pen_[colour]"

	to_chat(user, "<span class='notice'>Changed color to '[colour].'</span>")