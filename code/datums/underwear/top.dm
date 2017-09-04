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

/datum/category_item/underwear/top/sports_bra
	name = "Sports bra"
	icon_state = "sports_bra"
	has_color = TRUE

/datum/category_item/underwear/top/sports_bra_alt
	name = "Sports bra, alt"
	icon_state = "sports_bra_alt"
	has_color = TRUE

/datum/category_item/underwear/top/lacy_bra
	name = "Lacy bra"
	icon_state = "lacy_bra"

/datum/category_item/underwear/top/lacy_bra_alt
	name = "Lacy bra, alt"
	icon_state = "lacy_bra_alt"

/datum/category_item/underwear/top/halterneck_bra
	name = "Halterneck bra"
	icon_state = "halterneck_bra"
	has_color = TRUE

/datum/category_item/underwear/top/tube_top
	name = "Tube Top"
	underwear_name = "tube top"
	icon_state = "tubetop"
	has_color = TRUE
