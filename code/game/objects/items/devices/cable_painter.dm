/obj/item/device/cable_painter
	name = "cable painter"
	desc = "A device for repainting cables."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler0"
	item_state = "flight"
	var/color_selection
	var/list/modes
	w_class = ITEM_SIZE_SMALL

/obj/item/device/cable_painter/New()
	..()
	color_selection = pick(GLOB.possible_cable_colours)

/obj/item/device/cable_painter/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, "The color is currently set to [lowertext(color_selection)].")

/obj/item/device/cable_painter/attack_self(mob/user)
	var/new_color_selection = input("What color would you like to use?", "Choose a Color", color_selection) as null|anything in GLOB.possible_cable_colours
	if(new_color_selection && !user.incapacitated() && (src in user))
		color_selection = new_color_selection
		to_chat(user, "<span class='notice'>You change the paint mode to [lowertext(color_selection)].</span>")

/obj/item/device/cable_painter/afterattack(var/atom/A, var/mob/user, var/proximity)
	if(!proximity)
		return ..()
	if(istype(A, /obj/structure/cable))
		var/picked_color = GLOB.possible_cable_colours[color_selection]
		if(!picked_color || A.color == picked_color)
			return
		A.color = picked_color
		to_chat(user, "<span class='notice'>You set \the [A]'s color to [lowertext(color_selection)].</span>")
	else if(isCoil(A))
		var/obj/item/stack/cable_coil/c = A
		c.set_cable_color(color_selection, user)
	else
		. = ..()
