// Alien clothing.
/datum/gear/suit/zhan_furs
	display_name = "Zhan-Khazan furs (Tajara)"
	path = /obj/item/clothing/suit/tajaran/furs
	whitelisted = list(SPECIES_TAJARA)
	sort_category = "Xenowear"

/datum/gear/head/zhan_scarf
	display_name = "Zhan headscarf (Tajara)"
	path = /obj/item/clothing/head/tajaran/scarf
	whitelisted = list(SPECIES_TAJARA)
	sort_category = "Xenowear"

/datum/gear/suit/unathi_mantle
	display_name = "hide mantle (Unathi)"
	path = /obj/item/clothing/suit/unathi/mantle
	cost = 1
	whitelisted = list(SPECIES_UNATHI)
	sort_category = "Xenowear"

/datum/gear/suit/unathi_robe
	display_name = "roughspun robe (Unathi)"
	path = /obj/item/clothing/suit/unathi/robe
	cost = 1
	whitelisted = list(SPECIES_UNATHI)
	sort_category = "Xenowear"

//Skrell Chains
/datum/gear/ears/skrell/chains
	display_name = "headtail chain selection (Skrell)"
	path = /obj/item/clothing/ears/skrell/chain
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_SKRELL)

/datum/gear/ears/skrell/chains/New()
	..()
	var/list/chaintypes = list()
	for(var/chain_style in typesof(/obj/item/clothing/ears/skrell/chain) - /obj/item/clothing/ears/skrell/colored/chain)
		var/obj/item/clothing/ears/skrell/chain/chain = chain_style
		chaintypes[initial(chain.name)] = chain
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(chaintypes))

/datum/gear/ears/skrell/colored/chain
	display_name = "colored headtail chain (Skrell)"
	path = /obj/item/clothing/ears/skrell/colored/chain
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_SKRELL)
	flags = GEAR_HAS_COLOR_SELECTION

//Skrell Bands
/datum/gear/ears/skrell/bands
	display_name = "headtail band selection (Skrell)"
	path = /obj/item/clothing/ears/skrell/band
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_SKRELL)

/datum/gear/ears/skrell/bands/New()
	..()
	var/list/bandtypes = list()
	for(var/band_style in typesof(/obj/item/clothing/ears/skrell/band) - /obj/item/clothing/ears/skrell/colored/band)
		var/obj/item/clothing/ears/skrell/band/band = band_style
		bandtypes[initial(band.name)] = band
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(bandtypes))

/datum/gear/ears/skrell/colored/band
	display_name = "colored headtail bands (Skrell)"
	path = /obj/item/clothing/ears/skrell/colored/band
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_SKRELL)
	flags = GEAR_HAS_COLOR_SELECTION

//Skrell Cloth
/datum/gear/ears/skrell/cloth/male
	display_name = "male colored headtail cloth (Skrell)"
	path = /obj/item/clothing/ears/skrell/cloth_male
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_SKRELL)

/datum/gear/ears/skrell/cloth/male/New()
	..()
	var/list/valid_colors = list("#c20c00", "#0227f7", "#6262ff", "#454545", "#009900", "#e17291")
	gear_tweaks = list(new/datum/gear_tweak/color(valid_colors))

/datum/gear/ears/skrell/cloth/female
	display_name = "female colored headtail cloth (Skrell)"
	path = /obj/item/clothing/ears/skrell/cloth_female
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_SKRELL)

/datum/gear/ears/skrell/cloth/female/New()
	..()
	var/list/valid_colors = list("#c20c00", "#0227f7", "#6262ff", "#454545", "#009900", "#e17291")
	gear_tweaks = list(new/datum/gear_tweak/color(valid_colors))

/datum/gear/uniform/resomi
	display_name = "smock, grey (Resomi)"
	path = /obj/item/clothing/under/resomi
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_RESOMI)

/datum/gear/uniform/resomi/rainbow
	display_name = "smock, rainbow (Resomi)"
	path = /obj/item/clothing/under/resomi/rainbow
	allowed_roles = RESTRICTED_ROLES

/datum/gear/uniform/resomi/white
	display_name = "smock, colored (Resomi)"
	path = /obj/item/clothing/under/resomi/white
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/resomi/eng
	display_name = "uniform, Engineering (Resomi)"
	path = /obj/item/clothing/under/resomi/yellow
	allowed_roles = list("Maintenance Assistant", "Roboticist", "Passenger", "Research Assistant", "Merchant")

/datum/gear/uniform/resomi/sec
	display_name = "uniform, Security (Resomi)"
	path = /obj/item/clothing/under/resomi/red
	allowed_roles = list("Security Guard", "Passenger", "Research Assistant", "Merchant")

/datum/gear/uniform/resomi/med
	display_name = "uniform, Medical (Resomi)"
	path = /obj/item/clothing/under/resomi/medical
	allowed_roles = list("Medical Contractor", "Chemist", "Counselor", "Passenger", "Research Assistant", "Merchant")

/datum/gear/uniform/resomi/science
	display_name = "uniform, Science (Resomi)"
	path = /obj/item/clothing/under/resomi/science

/datum/gear/uniform/harness
	display_name = "gear harness (Full Body Prosthetic, IPC, Diona)"
	path = /obj/item/clothing/under/harness
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_IPC,SPECIES_DIONA)

/datum/gear/mask/ipc_monitor
	display_name = "display monitor (IPC)"
	path = /obj/item/clothing/mask/monitor
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_IPC)
	cost = 1

/datum/gear/shoes/toeless
	display_name = "toeless jackboots"
	path = /obj/item/clothing/shoes/jackboots/unathi
	sort_category = "Xenowear"

/datum/gear/shoes/wrk_toeless
	display_name = "toeless workboots"
	path = /obj/item/clothing/shoes/workboots/toeless
	sort_category = "Xenowear"

/datum/gear/uniform/resomi/dress
	display_name = "small dress (Resomi)"
	path = /obj/item/clothing/under/resomi/dress

/datum/gear/uniform/resomi/uniform
	display_name = "small uniform (Resomi)"
	path = /obj/item/clothing/under/resomi/uniform

/datum/gear/uniform/resomi/formal
	display_name = "small formal uniform (Resomi)"
	path = /obj/item/clothing/under/resomi/formal

/datum/gear/eyes/tajblind/med
	display_name = "medical veil (Tajara)"
	path = /obj/item/clothing/glasses/tajblind/med
	whitelisted = list(SPECIES_TAJARA)
	sort_category = "Xenowear"
	cost = 1
	allowed_roles = MEDICAL_ROLES

/datum/gear/eyes/tajblind/meson
	display_name = "industrial veil (Tajara)"
	path = /obj/item/clothing/glasses/meson/prescription/tajblind
	whitelisted = list(SPECIES_TAJARA)
	sort_category = "Xenowear"
	cost = 1
	allowed_roles = list("Maintenance Assistant", "Prospector", "Research Assistant")

