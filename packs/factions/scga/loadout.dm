/datum/gear/shoes/boots/scga/New()
	..()
	var/boots = list()
	boots += /obj/item/clothing/shoes/scga/utility
	boots += /obj/item/clothing/shoes/scga/utility/tan
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(boots)
