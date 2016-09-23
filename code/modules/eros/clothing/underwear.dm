//////////////////////////////////
/// Underwear Genitals Details ///
//////////////////////////////////

/datum/category_item/underwear
	var/show_genitals = 1
	var/show_boobs = 1


//bottom

/datum/category_item/underwear/bottom
	show_genitals = 0

/datum/category_item/underwear/bottom/none
	show_genitals = 1


//top

/datum/category_item/underwear/top
	show_boobs = 0

/datum/category_item/underwear/top/none
	show_boobs = 1

//undershirt

/datum/category_item/underwear/undershirt
	show_boobs = 0

/datum/category_item/underwear/undershirt/none
	show_boobs = 1
