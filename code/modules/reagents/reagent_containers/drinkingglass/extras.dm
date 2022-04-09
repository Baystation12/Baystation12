/obj/item/reagent_containers/food/drinks/glass2/attackby(obj/item/I as obj, mob/user as mob)
	if(extras.len >= 2) return ..() // max 2 extras, one on each side of the drink

	if(istype(I, /obj/item/glass_extra))
		var/obj/item/glass_extra/GE = I
		if(can_add_extra(GE))
			extras += GE
			if(!user.unEquip(GE, src))
				return
			to_chat(user, "<span class=notice>You add \the [GE] to \the [src].</span>")
			update_icon()
		else
			to_chat(user, "<span class=warning>There's no space to put \the [GE] on \the [src]!</span>")
	else if(istype(I, /obj/item/reagent_containers/food/snacks/fruit_slice))
		if(!rim_pos)
			to_chat(user, "<span class=warning>There's no space to put \the [I] on \the [src]!</span>")
			return
		var/obj/item/reagent_containers/food/snacks/fruit_slice/FS = I
		extras += FS
		if(!user.unEquip(FS, src))
			return
		FS.pixel_x = 0 // Reset its pixel offsets so the icons work!
		FS.pixel_y = 0
		to_chat(user, "<span class=notice>You add \the [FS] to \the [src].</span>")
		update_icon()
	else
		return ..()

/obj/item/reagent_containers/food/drinks/glass2/attack_hand(mob/user as mob)
	if(src != user.get_inactive_hand())
		return ..()

	if(!extras.len)
		to_chat(user, "<span class=warning>There's nothing on the glass to remove!</span>")
		return

	var/choice = input(user, "What would you like to remove from the glass?") as null|anything in extras
	if(!choice || !(choice in extras))
		return

	if(user.put_in_active_hand(choice))
		to_chat(user, "<span class=notice>You remove \the [choice] from \the [src].</span>")
		extras -= choice
	else
		to_chat(user, "<span class=warning>Something went wrong, please try again.</span>")

	update_icon()

/obj/item/glass_extra
	name = "generic glass addition"
	desc = "This goes on a glass."
	var/glass_addition
	var/glass_desc
	w_class = ITEM_SIZE_TINY
	icon = 'icons/obj/drink_glasses/extras.dmi'

/obj/item/glass_extra/stick
	name = "stick"
	desc = "This goes in a glass."
	glass_addition = "stick"
	glass_desc = "There is a stick in the glass."
	icon_state = "stick"
	color = COLOR_BLACK
	
/obj/item/glass_extra/stick/Initialize()
	. = ..()
	if(prob(50))
		color = get_random_colour(0,50,150)

/obj/item/glass_extra/straw
	name = "straw"
	desc = "This goes in a glass."
	glass_addition = "straw"
	glass_desc = "There is a straw in the glass."
	icon_state = "straw"
