/obj/item/clothing/accessory/toggleable/hawaii
	name = "flower-pattern shirt"
	desc = "You probably need some welder googles to look at this."
	icon_state = "hawaii"
	sprite_sheets = list(
		"Monkey" = 'icons/mob/species/monkey/onmob_accessories_monkey.dmi'
	)


/obj/item/clothing/accessory/toggleable/hawaii/red
	icon_state = "hawaii2"


/obj/item/clothing/accessory/toggleable/hawaii/random
	name = "flower-pattern shirt"


/obj/item/clothing/accessory/toggleable/hawaii/random/Initialize()
	. = ..()
	if (prob(50))
		icon_state = "hawaii2"
		icon_closed = "hawaii2"
	color = color_rotation(rand(-11, 12) * 15)
