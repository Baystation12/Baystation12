
/datum/gear/clothing
	sort_category = "Piezas de ropa"
	category = /datum/gear/clothing
	slot = slot_tie

/datum/gear/clothing/flannel
	display_name = "franela (coloreable)"
	path = /obj/item/clothing/accessory/flannel
	slot = slot_tie
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/clothing/scarf
	display_name = "bufanda"
	path = /obj/item/clothing/accessory/scarf
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/clothing/hawaii
	display_name = "camisa hawaiana"
	path = /obj/item/clothing/accessory/toggleable/hawaii

/datum/gear/clothing/hawaii/New()
	..()
	var/list/shirts = list()
	shirts["camisa hawaiana azul"] = /obj/item/clothing/accessory/toggleable/hawaii
	shirts["camisa hawaiana roja"] = /obj/item/clothing/accessory/toggleable/hawaii/red
	shirts["camisa hawaii de color al azar"] = /obj/item/clothing/accessory/toggleable/hawaii/random
	gear_tweaks += new/datum/gear_tweak/path(shirts)

/datum/gear/clothing/vest
	display_name = "chaleco de traje, seleccione color"
	path = /obj/item/clothing/accessory/toggleable/suit_vest
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/clothing/suspenders
	display_name = "tirantes"
	path = /obj/item/clothing/accessory/suspenders

/datum/gear/clothing/suspenders/colorable
	display_name = "tirantes, seleccione color"
	path = /obj/item/clothing/accessory/suspenders/colorable
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/clothing/wcoat
	display_name = "chaleco, seleccione color"
	path = /obj/item/clothing/accessory/waistcoat
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/clothing/zhongshan
	display_name = "chaqueta zhongshan, seleccione color"
	path = /obj/item/clothing/accessory/toggleable/zhongshan
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/clothing/dashiki
	display_name = "seleccion dashiki"
	path = /obj/item/clothing/accessory/dashiki
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/clothing/thawb
	display_name = "thawb"
	path = /obj/item/clothing/accessory/thawb

/datum/gear/clothing/sherwani
	display_name = "sherwani, seleccione color"
	path = /obj/item/clothing/accessory/sherwani
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/clothing/qipao
	display_name = "qipao blouse, seleccione color"
	path = /obj/item/clothing/accessory/qipao
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/clothing/sweater
	display_name = "abrigo de cuello alto, seleccione color"
	path = /obj/item/clothing/accessory/sweater
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/clothing/tangzhuang
	display_name = "chaqueta tanzhuang, seleccione color"
	path = /obj/item/clothing/accessory/tangzhuang
	flags = GEAR_HAS_COLOR_SELECTION
