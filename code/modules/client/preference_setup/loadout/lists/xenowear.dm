// Alien clothing.

// Unathi clothing
/datum/gear/suit/unathi
	sort_category = "Xenowear"
	category = /datum/gear/suit/unathi
	whitelisted = list(SPECIES_UNATHI, SPECIES_YEOSA)

/datum/gear/suit/unathi/mantle
	display_name = "hide mantle (Unathi)"
	path = /obj/item/clothing/suit/unathi/mantle
	cost = 1

/datum/gear/suit/unathi/robe
	display_name = "roughspun robe (Unathi)"
	path = /obj/item/clothing/suit/unathi/robe
	cost = 1

/datum/gear/suit/unathi/knifeharness
	display_name = "decorated harness"
	path = /obj/item/clothing/accessory/storage/knifeharness
	cost = 5

/datum/gear/suit/unathi/savage_hunter
	display_name = "savage hunter hides (Male, Unathi)"
	path = /obj/item/clothing/under/savage_hunter
	slot = slot_w_uniform
	cost = 2

/datum/gear/suit/unathi/savage_hunter/female
	display_name = "savage hunter hides (Female, Unathi)"
	path = /obj/item/clothing/under/savage_hunter/female
	slot = slot_w_uniform
	cost = 2

//Skrell Chains
/datum/gear/ears/skrell
	sort_category = "Xenowear"
	category = /datum/gear/ears/skrell
	whitelisted = list(SPECIES_SKRELL)
	path = /obj/item/clothing/ears/skrell

/datum/gear/ears/skrell/chains
	display_name = "Skrell female headtail chain selection"

/datum/gear/ears/skrell/chains/New()
	..()
	var/list/options = list(
		/obj/item/clothing/ears/skrell/chain_gold,
		/obj/item/clothing/ears/skrell/chain_silver,
		/obj/item/clothing/ears/skrell/chain_bluejewels,
		/obj/item/clothing/ears/skrell/chain_redjewels,
		/obj/item/clothing/ears/skrell/chain_ebony
	)
	gear_tweaks += new /datum/gear_tweak/path/specified_types_list (options)

/datum/gear/ears/skrell/chains_colorable
	display_name = "Skrell female headtail chain, colorable"
	path = /obj/item/clothing/ears/skrell/chain
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/ears/skrell/cloth_female
	display_name = "Skrell female headtail cloth, colorable"
	path = /obj/item/clothing/ears/skrell/cloth/female
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/ears/skrell/bands
	display_name = "Skrell male headtail band selection"

/datum/gear/ears/skrell/bands/New()
	..()
	var/list/options = list(
		/obj/item/clothing/ears/skrell/band_gold,
		/obj/item/clothing/ears/skrell/band_silver,
		/obj/item/clothing/ears/skrell/band_bluejewels,
		/obj/item/clothing/ears/skrell/band_redjewels,
		/obj/item/clothing/ears/skrell/band_ebony
	)
	gear_tweaks += new /datum/gear_tweak/path/specified_types_list (options)

/datum/gear/ears/skrell/bands_colorable
	display_name = "Skrell male headtail band, colorable"
	path = /obj/item/clothing/ears/skrell/band
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/ears/skrell/cloth_male
	display_name = "Skrell male headtail cloth, colorable"
	path = /obj/item/clothing/ears/skrell/cloth/male
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/skrell_helmet
	display_name = "Skrellian helmet"
	path = /obj/item/clothing/head/helmet/skrell
	whitelisted = list(SPECIES_SKRELL)
	sort_category = "Xenowear"
	allowed_roles = list(/datum/job/hos, /datum/job/warden, /datum/job/officer, /datum/job/detective)

/datum/gear/accessory/skrell_badge
	display_name = "skrellian SDTF badge"
	path = /obj/item/clothing/accessory/badge/tags/skrell
	whitelisted = list(SPECIES_SKRELL)
	sort_category = "Xenowear"

// IPC clothing
/datum/gear/suit/lab_xyn_machine
	display_name = "Xynergy labcoat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/xyn_machine
	slot = slot_wear_suit
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_IPC)

// Misc clothing
/datum/gear/uniform/harness
	display_name = "gear harness (Full Body Prosthetic, Diona, Giant Armoured Serpentid)"
	path = /obj/item/clothing/under/harness
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_IPC,SPECIES_DIONA, SPECIES_NABBER)

/datum/gear/shoes/toeless
	display_name = "toeless jackboots"
	path = /obj/item/clothing/shoes/jackboots/unathi
	sort_category = "Xenowear"

/datum/gear/shoes/wrk_toeless
	display_name = "toeless workboots"
	path = /obj/item/clothing/shoes/workboots/toeless
	sort_category = "Xenowear"

/datum/gear/shoes/clogs_toeless
	display_name = "toeless foam clogs"
	path = /obj/item/clothing/shoes/foamclog/toeless
	flags = GEAR_HAS_COLOR_SELECTION
	sort_category = "Xenowear"

/datum/gear/shoes/flipflobsters_toeless
	display_name = "toeless flip flobsters"
	path = /obj/item/clothing/shoes/foamclog/flipflobster/toeless
	sort_category = "Xenowear"

// Pre-modified gloves

/datum/gear/gloves/colored/modified
	display_name = "modified gloves, colored"
	path = /obj/item/clothing/gloves/color/modified
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_UNATHI, SPECIES_YEOSA)

/datum/gear/gloves/latex/modified
	display_name = "modified gloves, latex"
	path = /obj/item/clothing/gloves/latex/modified
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_UNATHI, SPECIES_YEOSA)

/datum/gear/gloves/nitrile/modified
	display_name = "modified gloves, nitrile"
	path = /obj/item/clothing/gloves/latex/nitrile/modified
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_UNATHI, SPECIES_YEOSA)

/datum/gear/gloves/rainbow/modified
	display_name = "modified gloves, rainbow"
	path = /obj/item/clothing/gloves/rainbow/modified
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_UNATHI, SPECIES_YEOSA)

/datum/gear/gloves/evening/modified
	display_name = "modified gloves, evening"
	path = /obj/item/clothing/gloves/color/evening/modified
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_UNATHI, SPECIES_YEOSA)

/datum/gear/gloves/botany/modified
	display_name = "modified gloves, botany"
	path = /obj/item/clothing/gloves/thick/botany/modified
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_UNATHI, SPECIES_YEOSA)

/datum/gear/gloves/work/modified
	display_name = "modified gloves, work"
	path = /obj/item/clothing/gloves/thick/modified
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_UNATHI, SPECIES_YEOSA)

// Unathi Rings

/datum/gear/unathi_ring
	display_name = "unathi ring selection"
	path = /obj/item/clothing/ring/seal/lhossekskull
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_UNATHI, SPECIES_YEOSA)
	cost = 2

/datum/gear/unathi_ring/New()
	..()
	var/ringtype = list()
	ringtype["grand stratagem ring"] = /obj/item/clothing/ring/seal/lhossekskull
	ringtype["fruitful lights ring"] = /obj/item/clothing/ring/seal/lhossekskull/fruitfullights
	gear_tweaks += new/datum/gear_tweak/path(ringtype)


// Vox clothing
/datum/gear/vox_mask
	display_name = "vox breathing mask"
	path = /obj/item/clothing/mask/gas/vox
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_VOX)
