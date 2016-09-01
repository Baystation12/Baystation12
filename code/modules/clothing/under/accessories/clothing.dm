/obj/item/clothing/accessory/vest
	name = "black vest"
	desc = "Slick black suit vest."
	icon_state = "det_vest"

/obj/item/clothing/accessory/tan_jacket
	name = "tan suit jacket"
	desc = "Cozy suit jacket."
	icon_state = "tan_jacket"

/obj/item/clothing/accessory/charcoal_jacket
	name = "charcoal suit jacket"
	desc = "Strict suit jacket."
	icon_state = "charcoal_jacket"

/obj/item/clothing/accessory/navy_jacket
	name = "navy suit jacket"
	desc = "Official suit jacket."
	icon_state = "navy_jacket"

/obj/item/clothing/accessory/burgundy_jacket
	name = "burgundy suit jacket"
	desc = "Expensive suit jacket."
	icon_state = "burgundy_jacket"

/obj/item/clothing/accessory/checkered_jacket
	name = "checkered suit jacket"
	desc = "Lucky suit jacket."
	icon_state = "checkered_jacket"

/obj/item/clothing/accessory/hawaii
	name = "flower-pattern shirt"
	desc = "You probably need some welder googles to look at this."
	icon_state = "hawaii"

/obj/item/clothing/accessory/hawaii/red
	icon_state = "hawaii2"

/obj/item/clothing/accessory/hawaii/random
	name = "flower-pattern shirt"

/obj/item/clothing/accessory/hawaii/random/New()
	if(prob(50))
		icon_state = "hawaii2"
	var/angle = rand(-11,12)*15
	color = color_rotation(angle)
	desc += "Turned by [angle]."