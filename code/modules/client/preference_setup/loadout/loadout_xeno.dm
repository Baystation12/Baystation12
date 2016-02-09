// Alien clothing.
/datum/gear/suit/zhan_furs
	display_name = "Zhan-Khazan furs (Tajara)"
	path = /obj/item/clothing/suit/tajaran/furs
	whitelisted = "Tajara"
	sort_category = "Xenowear"

/datum/gear/suit/unathi_mantle
	display_name = "hide mantle (Unathi)"
	path = /obj/item/clothing/suit/unathi/mantle
	cost = 1
	whitelisted = "Unathi"
	sort_category = "Xenowear"

/datum/gear/ears/skrell
	display_name = "headtail-wear, female, chain (Skrell)"
	path = /obj/item/clothing/ears/skrell/chain
	sort_category = "Xenowear"
	whitelisted = "Skrell"

/datum/gear/ears/skrell/plate
	display_name = "headtail-wear, male, bands (Skrell)"
	path = /obj/item/clothing/ears/skrell/band
/datum/gear/resomi_grey
	display_name = "Resomi uniform, grey"
	path = /obj/item/clothing/under/resomi
	cost = 1
	slot = slot_w_uniform

/datum/gear/resomi_rainbow
	display_name = "Resomi uniform, rainbow"
	path = /obj/item/clothing/under/resomi/rainbow
	cost = 1
	slot = slot_w_uniform

/datum/gear/resomi_white
	display_name = "Resomi uniform, white"
	path = /obj/item/clothing/under/resomi/white
	cost = 1
	slot = slot_w_uniform

/datum/gear/resomi_eng
	display_name = "Resomi uniform, Engineering"
	path = /obj/item/clothing/under/resomi/yellow
	cost = 1
	slot = slot_w_uniform
	allowed_roles = list("Chief Engineer","Station Engineer","Atmospherics Technician")

/datum/gear/resomi_sec
	display_name = "Resomi uniform, Security"
	path = /obj/item/clothing/under/resomi/red
	cost = 1
	slot = slot_w_uniform
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/resomi_med
	display_name = "Resomi uniform, Medical"
	path = /obj/item/clothing/under/resomi/medical
	cost = 1
	slot = slot_w_uniform
