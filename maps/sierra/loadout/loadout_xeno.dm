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

// Resomi clothing

/datum/gear/uniform/resomi/eng
	allowed_roles = ENGINEERING_ROLES

/datum/gear/uniform/resomi/sec
	allowed_roles = SECURITY_ROLES

/datum/gear/uniform/resomi/med
	allowed_roles = MEDICAL_ROLES

/datum/gear/uniform/resomi/science
	allowed_roles = RESEARCH_ROLES

/datum/gear/uniform/resomi/roboitcs
	allowed_roles = list(/datum/job/roboticist)

/datum/gear/eyes/resomi/lenses_sec
	allowed_roles = SECURITY_ROLES

/datum/gear/eyes/resomi/lenses_med
	allowed_roles = MEDICAL_ROLES

/datum/gear/passport/resomi
	display_name = "(Resomi) registration document"
	path = /obj/item/passport/xeno/resomi
	sort_category = "Xenowear"
	flags = 0
//	whitelisted = list(SPECIES_RESOMI)
	custom_setup_proc = /obj/item/passport/proc/set_info
	cost = 0

// IPC clothing

/datum/gear/suit/lab_xyn_machine
	allowed_branches = list(/datum/mil_branch/contractor)

// Misc clothing

// Tajaran clothing
/datum/gear/passport/tajara
	display_name = "(Tajara) passport"
	path = /obj/item/passport/xeno/tajara
	//whitelisted = list(SPECIES_TAJARA)
	flags = 0
	sort_category = "Xenowear"
	custom_setup_proc = /obj/item/passport/proc/set_info
	cost = 0

// Pre-modified gloves

/datum/gear/gloves/dress/modified
	display_name = "modified gloves, dress"
	path = /obj/item/clothing/gloves/color/white/modified
	sort_category = "Xenowear"
	//whitelisted = list(SPECIES_TAJARA, SPECIES_UNATHI, SPECIES_YEOSA, SPECIES_EROSAN)

// Vox clothing

/datum/gear/mask/gas/vox
	allowed_roles = list(  /*/datum/job/stowaway*/)

/datum/gear/gloves/vox
	allowed_roles = list(  /*/datum/job/stowaway*/)

/datum/gear/uniform/vox_cloth
	allowed_roles = list(  /*/datum/job/stowaway*/)

/datum/gear/uniform/vox_robe
	allowed_roles = list(  /*/datum/job/stowaway*/)
