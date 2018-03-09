/datum/category_item/underwear/top
	underwear_name = "bra"
	underwear_type = /obj/item/underwear/top

/datum/category_item/underwear/top/none
	name = "None"
	always_last = TRUE
	underwear_type = null

/datum/category_item/underwear/top/none/is_default(var/gender)
	return gender != FEMALE

/datum/category_item/underwear/top/bra
	is_default = TRUE
	name = "Bra"
	icon_state = "bra"
	has_color = TRUE

/datum/category_item/underwear/top/bra/is_default(var/gender)
	return gender == FEMALE


/datum/category_item/underwear/top/halterneck_bra
	name = "Halterneck bra"
	icon_state = "halterneck_bra"
	has_color = TRUE

/datum/category_item/underwear/top/tube_top
	name = "Tube Top"
	underwear_name = "tube top"
	icon_state = "tubetop"
	has_color = TRUE
