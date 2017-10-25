/datum/gear/accessory
	display_name = "locket"
	path = /obj/item/clothing/accessory/locket
	slot = slot_tie
	sort_category = "Accessories"

/datum/gear/accessory/vest
	display_name = "black vest"
	path = /obj/item/clothing/accessory/toggleable/vest
	allowed_roles = FORMAL_ROLES

/datum/gear/accessory/suspenders
	display_name = "suspenders"
	path = /obj/item/clothing/accessory/suspenders
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/accessory/wcoat
	display_name = "waistcoat"
	path = /obj/item/clothing/accessory/wcoat
	allowed_roles = FORMAL_ROLES

/datum/gear/accessory/zhongshan
	display_name = "zhongshan jacket"
	path = /obj/item/clothing/accessory/toggleable/zhongshan
	allowed_roles = FORMAL_ROLES
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/dashiki
	display_name = "dashiki selection"
	path = /obj/item/clothing/accessory/dashiki
	allowed_roles = NON_MILITARY_ROLES
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/accessory/thawb
	display_name = "thawb"
	path = /obj/item/clothing/accessory/thawb
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/accessory/sherwani
	display_name = "sherwani"
	path = /obj/item/clothing/accessory/sherwani
	allowed_roles = FORMAL_ROLES
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/qipao
	display_name = "qipao blouse"
	path = /obj/item/clothing/accessory/qipao
	allowed_roles = NON_MILITARY_ROLES
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/sweater
	display_name = "turtleneck sweater"
	path = /obj/item/clothing/accessory/sweater
	allowed_roles = NON_MILITARY_ROLES
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/tangzhuang
	display_name = "tangzhuang jacket"
	path = /obj/item/clothing/accessory/tangzhuang
	allowed_roles = NON_MILITARY_ROLES
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/necklace
	display_name = "necklace"
	path = /obj/item/clothing/accessory/necklace
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/bowtie
	display_name = "bowtie, horrible"
	path = /obj/item/clothing/accessory/bowtie/ugly
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/accessory/bowtie/color
	display_name = "bowtie, colored"
	path = /obj/item/clothing/accessory/bowtie/color
	flags = GEAR_HAS_COLOR_SELECTION

//have to break up armbands to restrict access
/datum/gear/accessory/armband_security
	display_name = "security armband"
	path = /obj/item/clothing/accessory/armband
	allowed_roles = SECURITY_ROLES

/datum/gear/accessory/armband_mp
	display_name = "military police brassard"
	path = /obj/item/clothing/accessory/armband/solgov/mp
	allowed_roles = SECURITY_ROLES

/datum/gear/accessory/armband_ma
	display_name = "master at arms brassard"
	path = /obj/item/clothing/accessory/armband/solgov/ma
	allowed_roles = SECURITY_ROLES

/datum/gear/accessory/armband_cargo
	display_name = "cargo armband"
	path = /obj/item/clothing/accessory/armband/cargo
	allowed_roles = SUPPLY_ROLES

/datum/gear/accessory/armband_medical
	display_name = "medical armband"
	path = /obj/item/clothing/accessory/armband/med
	allowed_roles = MEDICAL_ROLES

/datum/gear/accessory/armband_emt
	display_name = "EMT armband"
	path = /obj/item/clothing/accessory/armband/medgreen
	allowed_roles = list(/datum/job/doctor, /datum/job/doctor_contractor)

/datum/gear/accessory/armband_corpsman
	display_name = "medical corps armband"
	path = /obj/item/clothing/accessory/armband/medblue
	allowed_roles = list(/datum/job/cmo, /datum/job/senior_doctor, /datum/job/doctor)

/datum/gear/accessory/armband_engineering
	display_name = "engineering armband"
	path = /obj/item/clothing/accessory/armband/engine
	allowed_roles = ENGINEERING_ROLES

/datum/gear/accessory/armband_hydro
	display_name = "hydroponics armband"
	path = /obj/item/clothing/accessory/armband/hydro
	allowed_roles = list(/datum/job/rd, /datum/job/scientist, /datum/job/scientist_assistant, /datum/job/assistant)

/datum/gear/accessory/armband_nt
	display_name = "NanoTrasen armband"
	path = /obj/item/clothing/accessory/armband/whitered
	allowed_roles = list(/datum/job/rd, /datum/job/liaison, /datum/job/senior_scientist, /datum/job/nt_pilot, /datum/job/scientist, /datum/job/mining, /datum/job/guard, /datum/job/scientist_assistant, /datum/job/engineer_contractor, /datum/job/roboticist, /datum/job/psychiatrist, /datum/job/cargo_contractor, /datum/job/janitor, /datum/job/chef, /datum/job/bartender)

/datum/gear/accessory/armband_solgov
	display_name = "peacekeeper armband"
	path = /obj/item/clothing/accessory/armband/bluegold
	allowed_roles = SOLGOV_ROLES

/datum/gear/accessory/wallet
	display_name = "wallet"
	path = /obj/item/weapon/storage/wallet
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/wallet_poly
	display_name = "wallet, polychromic"
	path = /obj/item/weapon/storage/wallet/poly
	cost = 2

/datum/gear/accessory/holster
	display_name = "holster selection"
	path = /obj/item/clothing/accessory/holster
	cost = 3
	allowed_roles = ARMED_ROLES
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/accessory/ubac
	display_name = "ubac selection"
	path = /obj/item/clothing/accessory/ubac
	allowed_roles = MILITARY_ROLES
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/accessory/tie
	display_name = "tie selection"
	path = /obj/item/clothing/accessory
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/accessory/tie/New()
	..()
	var/ties = list()
	ties["blue tie"] = /obj/item/clothing/accessory/blue
	ties["red tie"] = /obj/item/clothing/accessory/red
	ties["blue tie, clip"] = /obj/item/clothing/accessory/blue_clip
	ties["red long tie"] = /obj/item/clothing/accessory/red_long
	ties["black tie"] = /obj/item/clothing/accessory/black
	ties["yellow tie"] = /obj/item/clothing/accessory/yellow
	ties["navy tie"] = /obj/item/clothing/accessory/navy
	ties["horrible tie"] = /obj/item/clothing/accessory/horrible
	ties["brown tie"] = /obj/item/clothing/accessory/brown
	gear_tweaks += new/datum/gear_tweak/path(ties)

/datum/gear/accessory/tie_color
	display_name = "colored tie"
	path = /obj/item/clothing/accessory
	allowed_roles = NON_MILITARY_ROLES
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/tie_color/New()
	..()
	var/ties = list()
	ties["tie"] = /obj/item/clothing/accessory
	ties["striped tie"] = /obj/item/clothing/accessory/long
	gear_tweaks += new/datum/gear_tweak/path(ties)

/datum/gear/accessory/stethoscope
	display_name = "stethoscope (medical)"
	path = /obj/item/clothing/accessory/stethoscope
	cost = 2
	allowed_roles = STERILE_ROLES

/datum/gear/accessory/brown_vest
	display_name = "webbing, engineering"
	path = /obj/item/clothing/accessory/storage/brown_vest
	cost = 3
	allowed_roles = list(/datum/job/chief_engineer, /datum/job/senior_engineer, /datum/job/engineer, /datum/job/engineer_contractor, /datum/job/roboticist, /datum/job/qm, /datum/job/cargo_tech,
						/datum/job/cargo_contractor, /datum/job/mining, /datum/job/janitor, /datum/job/scientist_assistant, /datum/job/merchant, /datum/job/solgov_pilot, /datum/job/nt_pilot)

/datum/gear/accessory/black_vest
	display_name = "webbing, security"
	path = /obj/item/clothing/accessory/storage/black_vest
	cost = 3
	allowed_roles = list(/datum/job/hos, /datum/job/warden, /datum/job/detective, /datum/job/officer, /datum/job/guard, /datum/job/merchant)

/datum/gear/accessory/white_vest
	display_name = "webbing, medical"
	path = /obj/item/clothing/accessory/storage/white_vest
	cost = 3
	allowed_roles = list(/datum/job/cmo, /datum/job/senior_doctor, /datum/job/doctor, /datum/job/doctor_contractor, /datum/job/merchant)

/datum/gear/accessory/brown_drop_pouches
	display_name = "drop pouches, engineering"
	path = /obj/item/clothing/accessory/storage/drop_pouches/brown
	cost = 3
	allowed_roles = list(/datum/job/chief_engineer, /datum/job/senior_engineer, /datum/job/engineer, /datum/job/engineer_contractor, /datum/job/roboticist, /datum/job/qm, /datum/job/cargo_tech,
						/datum/job/cargo_contractor, /datum/job/mining, /datum/job/janitor, /datum/job/scientist_assistant, /datum/job/merchant)

/datum/gear/accessory/black_drop_pouches
	display_name = "drop pouches, security"
	path = /obj/item/clothing/accessory/storage/drop_pouches/black
	cost = 3
	allowed_roles = list(/datum/job/hos, /datum/job/warden, /datum/job/detective, /datum/job/officer, /datum/job/guard, /datum/job/merchant)

/datum/gear/accessory/white_drop_pouches
	display_name = "drop pouches, medical"
	path = /obj/item/clothing/accessory/storage/drop_pouches/white
	cost = 3
	allowed_roles = list(/datum/job/cmo, /datum/job/senior_doctor, /datum/job/doctor, /datum/job/doctor_contractor, /datum/job/merchant)

/datum/gear/accessory/webbing
	display_name = "webbing, simple"
	path = /obj/item/clothing/accessory/storage/webbing
	cost = 2

/datum/gear/accessory/webbing_large
	display_name = "webbing, large"
	path = /obj/item/clothing/accessory/storage/webbing_large
	cost = 3

/datum/gear/accessory/bandolier
	display_name = "bandolier"
	path = /obj/item/clothing/accessory/storage/bandolier
	cost = 3

/datum/gear/accessory/armor_pouches
	display_name = "armor pouches"
	path = /obj/item/clothing/accessory/storage/pouches
	cost = 2
	allowed_roles = ARMORED_ROLES

/datum/gear/accessory/armor_pouches/New()
	..()
	var/pouches = list()
	pouches["black pouches"] = /obj/item/clothing/accessory/storage/pouches
	pouches["blue pouches"] = /obj/item/clothing/accessory/storage/pouches/blue
	pouches["navy blue pouches"] = /obj/item/clothing/accessory/storage/pouches/navy
	pouches["green pouches"] = /obj/item/clothing/accessory/storage/pouches/green
	pouches["tan pouches"] = /obj/item/clothing/accessory/storage/pouches/tan
	gear_tweaks += new/datum/gear_tweak/path(pouches)

/datum/gear/accessory/large_pouches
	display_name = "armor large pouches"
	path = /obj/item/clothing/accessory/storage/pouches/large
	cost = 5
	allowed_roles = ARMORED_ROLES

/datum/gear/accessory/large_pouches/New()
	..()
	var/lpouches = list()
	lpouches["black pouches"] = /obj/item/clothing/accessory/storage/pouches/large
	lpouches["blue pouches"] = /obj/item/clothing/accessory/storage/pouches/large/blue
	lpouches["navy blue pouches"] = /obj/item/clothing/accessory/storage/pouches/large/navy
	lpouches["green pouches"] = /obj/item/clothing/accessory/storage/pouches/large/green
	lpouches["tan pouches"] = /obj/item/clothing/accessory/storage/pouches/large/tan
	gear_tweaks += new/datum/gear_tweak/path(lpouches)

/datum/gear/accessory/armor_deco
	display_name = "armor customization"
	path = /obj/item/clothing/accessory/armor/tag
	allowed_roles = ARMORED_ROLES

/datum/gear/accessory/armor_deco/New()
	..()
	var/tags = list()
	tags["SCG flag"] = /obj/item/clothing/accessory/armor/tag/solgov
	tags["EC crest"] = /obj/item/clothing/accessory/armor/tag/solgov/ec
	tags["PCRC tag"] = /obj/item/clothing/accessory/armor/tag/pcrc
	tags["SAARE tag"] = /obj/item/clothing/accessory/armor/tag/saare
	tags["blood patch, O+"] = /obj/item/clothing/accessory/armor/tag/opos
	tags["blood patch, O-"] = /obj/item/clothing/accessory/armor/tag/oneg
	tags["blood patch, A+"] = /obj/item/clothing/accessory/armor/tag/apos
	tags["blood patch, A-"] = /obj/item/clothing/accessory/armor/tag/aneg
	tags["blood patch, B+"] = /obj/item/clothing/accessory/armor/tag/bpos
	tags["blood patch, B-"] = /obj/item/clothing/accessory/armor/tag/bneg
	tags["blood patch, AB+"] = /obj/item/clothing/accessory/armor/tag/abpos
	tags["blood patch, AB-"] = /obj/item/clothing/accessory/armor/tag/abneg
	gear_tweaks += new/datum/gear_tweak/path(tags)

/datum/gear/accessory/hawaii
	display_name = "hawaii shirt"
	path = /obj/item/clothing/accessory/toggleable/hawaii
	allowed_roles = SEMIFORMAL_ROLES

/datum/gear/accessory/hawaii/New()
	..()
	var/list/shirts = list()
	shirts["blue hawaii shirt"] = /obj/item/clothing/accessory/toggleable/hawaii
	shirts["red hawaii shirt"] = /obj/item/clothing/accessory/toggleable/hawaii/red
	shirts["random colored hawaii shirt"] = /obj/item/clothing/accessory/toggleable/hawaii/random
	gear_tweaks += new/datum/gear_tweak/path(shirts)

/datum/gear/accessory/scarf
	display_name = "scarf"
	path = /obj/item/clothing/accessory/scarf
	flags = GEAR_HAS_COLOR_SELECTION
	allowed_roles = SEMIFORMAL_ROLES

/datum/gear/accessory/solawardmajor
	display_name = "SolGov major award selection"
	description = "A medal or ribbon awarded to SolGov personnel for significant accomplishments."
	path = /obj/item/clothing/accessory
	cost = 8
	allowed_roles = SOLGOV_ROLES

/datum/gear/accessory/solawardmajor/New()
	..()
	var/solmajors = list()
	solmajors["iron star"] = /obj/item/clothing/accessory/medal/solgov/iron/star
	solmajors["bronze heart"] = /obj/item/clothing/accessory/medal/solgov/bronze/heart
	solmajors["silver sword"] = /obj/item/clothing/accessory/medal/solgov/silver/sword
	solmajors["medical heart"] = /obj/item/clothing/accessory/medal/solgov/heart
	solmajors["valor medal"] = /obj/item/clothing/accessory/medal/solgov/silver/sol
	solmajors["sapienterian medal"] = /obj/item/clothing/accessory/medal/solgov/gold/sol
	solmajors["peacekeeper ribbon"] = /obj/item/clothing/accessory/ribbon/solgov/peace
	solmajors["marksman ribbon"] = /obj/item/clothing/accessory/ribbon/solgov/marksman
	gear_tweaks += new/datum/gear_tweak/path(solmajors)

/datum/gear/accessory/solawardminor
	display_name = "SolGov minor award selection"
	description = "A medal or ribbon awarded to SolGov personnel for minor accomplishments."
	path = /obj/item/clothing/accessory
	cost = 5
	allowed_roles = SOLGOV_ROLES

/datum/gear/accessory/solawardminor/New()
	..()
	var/solminors = list()
	solminors["expeditionary medal"] = /obj/item/clothing/accessory/medal/solgov/iron/sol
	solminors["operations medal"] = /obj/item/clothing/accessory/medal/solgov/bronze/sol
	solminors["frontier ribbon"] = /obj/item/clothing/accessory/ribbon/solgov/frontier
	solminors["instructor ribbon"] = /obj/item/clothing/accessory/ribbon/solgov/instructor
	gear_tweaks += new/datum/gear_tweak/path(solminors)

/datum/gear/accessory/ntaward
	display_name = "NanoTrasen award selection"
	description = "A medal or ribbon awarded to NanoTrasen personnel for significant accomplishments."
	path = /obj/item/clothing/accessory/medal
	cost = 8
	allowed_roles = NANOTRASEN_ROLES

/datum/gear/accessory/ntaward/New()
	..()
	var/ntawards = list()
	ntawards["sciences medal"] = /obj/item/clothing/accessory/medal/bronze/nanotrasen
	ntawards["nanotrasen service"] = /obj/item/clothing/accessory/medal/silver/nanotrasen
	ntawards["command medal"] = /obj/item/clothing/accessory/medal/gold/nanotrasen
	gear_tweaks += new/datum/gear_tweak/path(ntawards)

/datum/gear/accessory/tags
	display_name = "dog tags"
	path = /obj/item/clothing/accessory/badge/solgov/tags
	allowed_roles = MILITARY_ROLES

/datum/gear/accessory/kneepads
	display_name = "kneepads"
	path = /obj/item/clothing/accessory/kneepads

/datum/gear/accessory/flannel
	display_name = "flannel (colorable)"
	path = /obj/item/clothing/accessory/toggleable/flannel
	slot = slot_tie
	flags = GEAR_HAS_COLOR_SELECTION
	sort_category = "Accessories"
	allowed_roles = SEMIFORMAL_ROLES
