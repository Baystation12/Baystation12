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

/datum/gear/ears/skrell/chains	//Chains
	display_name = "headtail chain selection (Skrell)"
	path = /obj/item/clothing/ears/skrell/chain
	sort_category = "Xenowear"
	whitelisted = "Skrell"

/datum/gear/ears/skrell/chains/New()
	..()
	var/list/chaintypes = list()
	for(var/chain_style in typesof(/obj/item/clothing/ears/skrell/chain))
		var/obj/item/clothing/ears/skrell/chain/chain = chain_style
		chaintypes[initial(chain.name)] = chain
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(chaintypes))
	
/datum/gear/ears/skrell/bands
	display_name = "headtail band selection (Skrell)"
	path = /obj/item/clothing/ears/skrell/band
	sort_category = "Xenowear"
	whitelisted = "Skrell"

/datum/gear/ears/skrell/bands/New()
	..()
	var/list/bandtypes = list()
	for(var/band_style in typesof(/obj/item/clothing/ears/skrell/band))
		var/obj/item/clothing/ears/skrell/band/band = band_style
		bandtypes[initial(band.name)] = band
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(bandtypes))
	
/datum/gear/ears/skrell/cloth/male
	display_name = "male headtail cloth selection (Skrell)"
	path = /obj/item/clothing/ears/skrell/cloth_male
	sort_category = "Xenowear"
	whitelisted = "Skrell"

/datum/gear/ears/skrell/cloth/male/New()
	..()
	var/list/clothtypes = list()
	for(var/cloth_style in typesof(/obj/item/clothing/ears/skrell/cloth_male))
		var/obj/item/clothing/ears/skrell/cloth_male/cloth = cloth_style
		clothtypes[initial(cloth.name)] = cloth
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(clothtypes))

/datum/gear/ears/skrell/cloth/female
	display_name = "female headtail cloth selection (Skrell)"
	path = /obj/item/clothing/ears/skrell/cloth_female
	sort_category = "Xenowear"
	whitelisted = "Skrell"

/datum/gear/ears/skrell/cloth/female/New()
	..()
	var/list/clothtypes = list()
	for(var/cloth_style in typesof(/obj/item/clothing/ears/skrell/cloth_female))
		var/obj/item/clothing/ears/skrell/cloth_female/cloth = cloth_style
		clothtypes[initial(cloth.name)] = cloth
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(clothtypes))

/datum/gear/uniform/resomi
	display_name = "smock, grey (Resomi)"
	path = /obj/item/clothing/under/resomi
	sort_category = "Xenowear"
	whitelisted = "Resomi"

/datum/gear/uniform/resomi/rainbow
	display_name = "smock, rainbow (Resomi)"
	path = /obj/item/clothing/under/resomi/rainbow

/datum/gear/uniform/resomi/white
	display_name = "smock, white (Resomi)"
	path = /obj/item/clothing/under/resomi/white

/datum/gear/uniform/resomi/eng
	display_name = "uniform, Engineering (Resomi)"
	path = /obj/item/clothing/under/resomi/yellow
	allowed_roles = list("Chief Engineer","Station Engineer","Atmospherics Technician")

/datum/gear/uniform/resomi/sec
	display_name = "uniform, Security (Resomi)"
	path = /obj/item/clothing/under/resomi/red
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/uniform/resomi/med
	display_name = "uniform, Medical (Resomi)"
	path = /obj/item/clothing/under/resomi/medical
