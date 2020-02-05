/obj/item/weapon/pen/retractable
	desc = "It's a retractable pen."
	icon_state = "pen" //for map visibility
	active = FALSE
	var/base_state = "ret_black"

/obj/item/weapon/pen/retractable/blue
	icon_state = "pen_blue"
	colour = "blue"
	color_description = "blue ink"
	base_state = "ret_blue"

/obj/item/weapon/pen/retractable/red
	icon_state = "pen_red"
	colour = "red"
	color_description = "red ink"
	base_state = "ret_blue"

/obj/item/weapon/pen/retractable/green
	icon_state = "pen_green"
	colour = "green"
	color_description = "green ink"
	base_state = "ret_green"

/obj/item/weapon/pen/retractable/Initialize()
	. = ..()
	desc = "It's a retractable [color_description] pen."

/obj/item/weapon/pen/retractable/on_update_icon()
	if(active)
		icon_state = "[base_state]-a"
	else
		icon_state = "[base_state]"

/obj/item/weapon/pen/retractable/attack(atom/A, mob/user, target_zone)
	if(!active)
		toggle()
	..()

/obj/item/weapon/pen/retractable/attack_self(mob/user)
	toggle()

/obj/item/weapon/pen/retractable/toggle()
	active = !active
	playsound(src, 'sound/items/penclick.ogg', 5, 0, -4)
	update_icon()