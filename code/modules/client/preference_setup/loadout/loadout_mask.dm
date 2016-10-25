// Mask
/datum/gear/mask
	display_name = "balaclava"
	path = /obj/item/clothing/mask/balaclava
	slot = slot_wear_mask
	sort_category = "Masks and Facewear"

/datum/gear/mask/surgical
	display_name = "sterile mask"
	path = /obj/item/clothing/mask/surgical
	cost = 2

//EROS START

/datum/gear/mask/bandana
	display_name = "bandana selection"
	path = /obj/item/clothing/mask/bandana
	description = "For style or for anarchy?"

/datum/gear/mask/bandana/New()
	..()
	var/list/bandanas = list()
	for(var/bandana in typesof(/obj/item/clothing/mask/bandana))
		var/obj/item/clothing/mask/bandana/bandana_type = bandana
		bandanas[initial(bandana_type.name)] = bandana_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(bandanas))

//EROS FINISH