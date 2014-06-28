/datum/gear
	display_name
	display_icon      //Icon for preview.
	display_icon_name //Icon state for preview.
	path              //Path to item.
	cost              //Number of points used.

//Standard gear datums.
/datum/gear/tie_horrible
	display_name = "Horrible tie"
	display_icon = 'icons/obj/clothing/ties.dmi'
	display_icon_name = "horribletie"
	path = /obj/item/clothing/tie/horrible
	cost = 2

//Species-specific gear datums.
/datum/gear/zhan_furs
	display_name = "Zhan-Khazan furs"
	display_icon = ''
	display_icon_name = "zhan_furs"
	path = /obj/item/clothing/suit/tajaran/furs
	cost = 3

/datum/gear/zhan_scarf
	display_name = "Zhan-Khazan headscarf"
	display_icon = ''
	display_icon_name = "zhan_scarf"
	path = /obj/item/clothing/head/tajaran/scarf
	cost = 2

/datum/gear/unathi_robe
	display_name = "Roughspun robe"
	display_icon = ''
	display_icon_name = ""
	path =
	cost = 3

/datum/gear/unathi_mantle
	display_name = "Hide mantle"
	display_icon = ''
	display_icon_name = ""
	path =
	cost = 2