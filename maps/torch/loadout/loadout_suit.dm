/datum/gear/suit/blueapron
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/suit/overalls
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/suit/medcoat
	allowed_roles = MEDICAL_ROLES

/datum/gear/suit/trenchcoat
	allowed_roles = list(
		/datum/job/assistant,
		/datum/job/detective,
		/datum/job/merchant,
		/datum/job/submap/bearcat_captain,
		/datum/job/submap/bearcat_crewman,
		/datum/job/submap/colonist,
		/datum/job/submap/pod
	)
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/suit/poncho
	allowed_roles = CASUAL_ROLES
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/suit/security_poncho
	allowed_roles = list(
		/datum/job/merchant,
		/datum/job/detective
	)
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/suit/medical_poncho
	allowed_roles = list(
		/datum/job/senior_doctor,
		/datum/job/junior_doctor,
		/datum/job/doctor,
		/datum/job/psychiatrist,
		/datum/job/merchant,
		/datum/job/chemist
	)
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/suit/engineering_poncho
	allowed_roles = list(
		/datum/job/engineer,
		/datum/job/roboticist,
		/datum/job/merchant
	)
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/suit/science_poncho
	allowed_roles = list(
		/datum/job/scientist,
		/datum/job/senior_scientist,
		/datum/job/scientist_assistant
	)
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/suit/nanotrasen_poncho
	allowed_roles = list(
		/datum/job/scientist,
		/datum/job/scientist_assistant,
		/datum/job/senior_scientist,
		/datum/job/merchant
	)
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/suit/cargo_poncho
	allowed_roles = list(
		/datum/job/cargo_tech,
		/datum/job/merchant
	)
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/suit/suit_jacket
	allowed_roles = FORMAL_ROLES
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/suit/custom_suit_jacket
	allowed_roles = FORMAL_ROLES
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/suit/hoodie
	allowed_roles = CASUAL_ROLES
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/suit/hoodie_sel
	allowed_roles = CASUAL_ROLES
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/suit/labcoat
	allowed_roles = DOCTOR_ROLES

/datum/gear/suit/labcoat_corp
	allowed_roles = DOCTOR_ROLES
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/suit/labcoat_blue
	allowed_roles = DOCTOR_ROLES

/datum/gear/suit/labcoat_ec
	display_name = "labcoat, Expeditionary Corps"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/science/ec
	allowed_roles = DOCTOR_ROLES
	allowed_branches = list(
		/datum/mil_branch/expeditionary_corps
	)
	flags = GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/suit/labcoat_cmo
	display_name = "labcoat, chief medical officer"
	allowed_roles = list(
		/datum/job/cmo
	)
	path = /obj/item/clothing/suit/storage/toggle/labcoat
	flags = GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/suit/labcoat_cmo/New()
	..()
	var/list/options = list()
	options["chief medical officer's labcoat"] = /obj/item/clothing/suit/storage/toggle/labcoat/cmo
	options["chief medical officer's command labcoat"] = /obj/item/clothing/suit/storage/toggle/labcoat/cmoalt
	gear_tweaks += new/datum/gear_tweak/path(options)

/datum/gear/suit/labcoat_ec_cso
	display_name = "labcoat, chief science officer, Expeditionary Corps"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/rd/ec
	allowed_roles = list(
		/datum/job/rd
	)
	flags = GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/suit/wintercoat_dais
	display_name = "winter coat, DAIS"
	allowed_roles = list(
		/datum/job/engineer,
		/datum/job/roboticist,
		/datum/job/scientist_assistant,
		/datum/job/scientist,
		/datum/job/senior_scientist,
		/datum/job/rd
	)
	allowed_branches = CIVILIAN_BRANCHES
	flags = GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/suit/coat
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/suit/leather
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/suit/wintercoat
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/suit/track
	allowed_roles = CASUAL_ROLES
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/tactical/pcarrier
	display_name = "black plate carrier"
	path = /obj/item/clothing/suit/armor/pcarrier
	cost = 1
	slot = slot_wear_suit
	allowed_roles = ARMORED_ROLES

/datum/gear/tactical/pcarrier/navy
	display_name = "navy blue plate carrier"
	path = /obj/item/clothing/suit/armor/pcarrier/navy
	allowed_branches = list(/datum/mil_branch/fleet, /datum/mil_branch/civilian)

/datum/gear/tactical/pcarrier/misc
	display_name = "miscellaneous plate carrier selection"
	allowed_roles = ARMORED_ROLES
	allowed_branches = CIVILIAN_BRANCHES

/datum/gear/tactical/pcarrier/misc/New()
	..()
	var/armors = list()
	armors["green plate carrier"] = /obj/item/clothing/suit/armor/pcarrier/green
	armors["tan plate carrier"] = /obj/item/clothing/suit/armor/pcarrier/tan
	gear_tweaks += new/datum/gear_tweak/path(armors)

/datum/gear/suit/sfp
	display_name = "Agent's jacket"
	path = /obj/item/clothing/suit/storage/toggle/agent_jacket
	allowed_roles = list(
		/datum/job/detective
	)
	allowed_branches = list(
		/datum/mil_branch/solgov
	)
	flags = GEAR_HAS_NO_CUSTOMIZATION
