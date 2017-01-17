/obj/item/clothing/accessory/wcoat
	name = "waistcoat"
	desc = "For some classy, murderous fun."
	icon_state = "vest"
	item_state = "wcoat"

/obj/item/clothing/accessory/suspenders
	name = "suspenders"
	desc = "They suspend the illusion of the mime's play."
	icon_state = "suspenders"

/obj/item/clothing/accessory/toggleable
	var/icon_closed
/obj/item/clothing/accessory/toggleable/New()
	if(!icon_closed)
		icon_closed = icon_state
	..()

/obj/item/clothing/accessory/toggleable/on_attached(obj/item/clothing/under/S, mob/user as mob)
	..()
	has_suit.verbs += /obj/item/clothing/accessory/toggleable/verb/toggle

/obj/item/clothing/accessory/toggleable/on_removed(mob/user as mob)
	if(has_suit)
		has_suit.verbs -= /obj/item/clothing/accessory/toggleable/verb/toggle
	..()

/obj/item/clothing/accessory/toggleable/verb/toggle()
	set name = "Toggle Buttons"
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return 0

	var/obj/item/clothing/accessory/toggleable/H = null
	if (istype(src, /obj/item/clothing/accessory/toggleable))
		H = src
	else
		H = locate() in src

	if(H)
		H.do_toggle(usr)
	update_clothing_icon()	//so our overlays update

/obj/item/clothing/accessory/toggleable/proc/do_toggle(user)
	if(icon_state == icon_closed)
		icon_state = "[icon_closed]_open"
		to_chat(usr, "You unbutton [src].")
	else
		icon_state = icon_closed
		to_chat(usr, "You button up [src].")

	update_clothing_icon()	//so our overlays update

/obj/item/clothing/accessory/toggleable/vest
	name = "black vest"
	desc = "Slick black suit vest."
	icon_state = "det_vest"

/obj/item/clothing/accessory/toggleable/tan_jacket
	name = "tan suit jacket"
	desc = "Cozy suit jacket."
	icon_state = "tan_jacket"

/obj/item/clothing/accessory/toggleable/tan_jacket/New()
	..()
	do_toggle()

/obj/item/clothing/accessory/toggleable/charcoal_jacket
	name = "charcoal suit jacket"
	desc = "Strict suit jacket."
	icon_state = "charcoal_jacket"

/obj/item/clothing/accessory/toggleable/navy_jacket
	name = "navy suit jacket"
	desc = "Official suit jacket."
	icon_state = "navy_jacket"

/obj/item/clothing/accessory/toggleable/burgundy_jacket
	name = "burgundy suit jacket"
	desc = "Expensive suit jacket."
	icon_state = "burgundy_jacket"

/obj/item/clothing/accessory/toggleable/checkered_jacket
	name = "checkered suit jacket"
	desc = "Lucky suit jacket."
	icon_state = "checkered_jacket"

/obj/item/clothing/accessory/toggleable/hawaii
	name = "flower-pattern shirt"
	desc = "You probably need some welder googles to look at this."
	icon_state = "hawaii"
	sprite_sheets = list("Monkey" = 'icons/mob/species/monkey/ties.dmi')

/obj/item/clothing/accessory/toggleable/hawaii/red
	icon_state = "hawaii2"

/obj/item/clothing/accessory/toggleable/hawaii/random
	name = "flower-pattern shirt"

/obj/item/clothing/accessory/toggleable/hawaii/random/New()
	..()
	if(prob(50))
		icon_state = "hawaii2"
		icon_closed = "hawaii2"
	color = color_rotation(rand(-11,12)*15)