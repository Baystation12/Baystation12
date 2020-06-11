/* Clown Items
 * Contains:
 * 		Banana Peels
 *		Bike Horns
 */

/*
 * Banana Peels
 */
/obj/item/weapon/bananapeel/Crossed(AM as mob|obj)
	if (istype(AM, /mob/living))
		var/mob/living/M = AM
		M.slip("the [src.name]",4)
/*
 * Bike Horns
 */
/obj/item/weapon/bikehorn
	name = "bike horn"
	desc = "A horn off of a bicycle."
	icon = 'icons/obj/items.dmi'
	icon_state = "bike_horn"
	item_state = "bike_horn"
	throwforce = 3
	w_class = ITEM_SIZE_SMALL
	throw_speed = 3
	throw_range = 15
	attack_verb = list("HONKED")
	var/audio_files = list("sound/items/bikehorn.ogg")

/obj/item/weapon/bikehorn/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak, audio_files, 50)

/obj/item/weapon/bikehorn/airhorn
	name = "air horn"
	desc = "A can of compressed air hooked up to an obnoxiously loud horn. SPRING BREAK!"
	icon_state = "air_horn"
	item_state = "air_horn"
	audio_files = list("sound/items/air_horn_1.ogg", "sound/items/air_horn_2.ogg")
