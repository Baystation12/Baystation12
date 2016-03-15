/datum/gear_tweak/proc/apply_tweak(var/obj/item/I)
	return

/*
* Color adjustment
*/
/datum/gear_tweak/color
	var/item_color

/datum/gear_tweak/color/New(var/item_color)
	src.item_color = item_color
	..()

/datum/gear_tweak/color/apply_tweak(var/obj/item/I)
	I.color = item_color

/*
* Icon state adjustment
*/
/datum/gear_tweak/icon_state
	var/icon_state

/datum/gear_tweak/icon_state/New(var/icon_state)
	src.icon_state = icon_state
	..()

/datum/gear_tweak/icon_state/apply_tweak(var/obj/item/I)
	I.icon_state = icon_state
