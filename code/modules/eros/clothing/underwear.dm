//////////////////////////////////
/// Underwear Genitals Details ///
//////////////////////////////////

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

//Eros underwear initializer

/datum/category_item/underwear/bottom/eros
	icon = 'icons/eros/mob/underwear.dmi'

/datum/category_item/underwear/top/eros
	icon = 'icons/eros/mob/underwear.dmi'

/datum/category_item/underwear/undershirt/eros
	icon = 'icons/eros/mob/underwear.dmi'

/datum/category_item/underwear/socks/eros
	icon = 'icons/eros/mob/underwear.dmi'

//Example

/*
/datum/category_item/underwear/socks/eros/thin_thigh
	name = "Thigh, thin" //name on the list
	icon_state = "thin_thigh" //name of the icon in the eros folder
	has_color = TRUE //if color can be changed, if not, just remove this line
*/