/obj/item/device/pda/explorer
	icon_state = "pda-explorer"

/obj/item/device/pda/pathfinder
	icon_state = "pda-pathfinder"

/obj/item/weapon/pen/multi/cmd/xo
	name = "executive officer's pen"
	icon_state = "pen_xo"
	desc = "A slightly bulky pen with a silvery case. Twisting the top allows you to switch the nib for different colors."

/obj/item/weapon/pen/multi/cmd/co
	name = "commanding officer's pen"
	icon_state = "pen_co"
	desc = "A slightly bulky pen with a golden case. Twisting the top allows you to switch the nib for different colors."

/obj/item/weapon/pen/multi/cmd/attack_self(mob/user)
	if(++selectedColor > 3)
		selectedColor = 1

	colour = colors[selectedColor]

	to_chat(user, "<span class='notice'>Changed color to '[colour].'</span>")