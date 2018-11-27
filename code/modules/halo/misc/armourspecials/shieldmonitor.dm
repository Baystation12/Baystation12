
/datum/armourspecials/shieldmonitor //This is here to be checked to see if shieldlevels should be displayed in the "Status" panel.
	/*var/hud_elements[0] //Can be used later on to create a hud shieldbar. I'd rather get the basics created and implemented first.
	var/client
	var/datum/armourspecials/shields/shield_datum*/
	var/list/valid_helmets = list(/obj/item/clothing/head/helmet/spartan) //This should work for the slayer helms too. IIRC, Istype also counts subtypes.

/datum/armourspecials/shieldmonitor/sangheili
	valid_helmets = list(/obj/item/clothing/head/helmet/sangheili)
