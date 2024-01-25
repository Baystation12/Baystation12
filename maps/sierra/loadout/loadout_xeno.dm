// Unathi clothing

/datum/gear/passport/unathi
	display_name = "(Unathi) registration document"
	path = /obj/item/passport/xeno/unathi
	sort_category = "Xenowear"
	flags = 0
	whitelisted = list(SPECIES_UNATHI)
	custom_setup_proc = /obj/item/passport/proc/set_info
	cost = 0

// Skrell clothing

/datum/gear/head/skrell_helmet
	allowed_roles = ARMORED_ROLES

/datum/gear/head/skrell_helmet/New()
	..()
	var/list/helmets = list()
	helmets["black skrellian helmet"] = /obj/item/clothing/head/helmet/skrell
	helmets["navy skrellian helmet"] = /obj/item/clothing/head/helmet/skrell/navy
	helmets["green skrellian helmet"] = /obj/item/clothing/head/helmet/skrell/green
	helmets["tan skrellian helmet"] = /obj/item/clothing/head/helmet/skrell/tan
	gear_tweaks += new/datum/gear_tweak/path(helmets)

// IPC clothing

/datum/gear/suit/lab_xyn_machine
	allowed_branches = list(/datum/mil_branch/contractor)

/datum/gear/gloves/nabber
	display_name = "(GAS) Three-fingered insulated gloves"
	path = /obj/item/clothing/gloves/nabber
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_NABBER)
	cost = 3
