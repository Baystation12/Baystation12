/* Clown Items
 * Contains:
 * 		Banana Peels
 *		Bike Horns
 */

/*
 * Banana Peals
 */
/obj/item/bananapeel/Crossed(AM as mob|obj)
	if (istype(AM, /mob/living))
		var/mob/living/M = AM
		M.slip("the [src.name]",4)
/*
 * Bike Horns
 */
/obj/item/bikehorn
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
	var/spam_flag = 0
	var/audio_files = list("sound/items/bikehorn.ogg")

/obj/item/bikehorn/attack_self(mob/user as mob)
	if (spam_flag == 0)
		spam_flag = 1
		playsound(src.loc, pick(src.audio_files), 50, 1)
		src.add_fingerprint(user)
		spawn(20)
			spam_flag = 0
	return

/obj/item/bikehorn/airhorn
	name = "air horn"
	desc = "A can of compressed air hooked up to an obnoxiously loud horn. SPRING BREAK!"
	icon_state = "air_horn"
	item_state = "air_horn"
	audio_files = list("sound/items/air_horn_1.ogg", "sound/items/air_horn_2.ogg")