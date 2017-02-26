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

/datum/gear/accessory/necklace
	display_name = "necklace"
	path = /obj/item/clothing/accessory/necklace
	flags = GEAR_HAS_COLOR_SELECTION

//have to break up armbands to restrict access
/datum/gear/accessory/armband_security
	display_name = "security armband"
	path = /obj/item/clothing/accessory/armband
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
	allowed_roles = list("Corpsman", "Medical Contractor")

/datum/gear/accessory/armband_corpsman
	display_name = "medical corps armband"
	path = /obj/item/clothing/accessory/armband/medblue
	allowed_roles = list("Chief Medical Officer", "Physician", "Corpsman")

/datum/gear/accessory/armband_engineering
	display_name = "engineering armband"
	path = /obj/item/clothing/accessory/armband/engine
	allowed_roles = ENGINEERING_ROLES

/datum/gear/accessory/armband_hydro
	display_name = "hydroponics armband"
	path = /obj/item/clothing/accessory/armband/hydro
	allowed_roles = list("Research Director", "Scientist", "Research Assistant", "Passenger")

/datum/gear/accessory/armband_science
	display_name = "science armband"
	path = /obj/item/clothing/accessory/armband/science
	allowed_roles = RESEARCH_ROLES

/datum/gear/accessory/armband_nt
	display_name = "NanoTrasen armband"
	path = /obj/item/clothing/accessory/armband/whitered
	allowed_roles = list("Research Director", "NanoTrasen Liaison", "Senior Researcher", "NanoTrasen Pilot", "Scientist", "Prospector", "Security Guard", "Research Assistant", "Maintenance Assistant", "Roboticist", "Medical Assistant", "Virologist", "Chemist", "Counselor", "Supply Assistant", "Sanitation Technician", "Cook", "Bartender")

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
	allowed_roles = MILITARY_ROLES

/datum/gear/accessory/holster/New()
	..()
	gear_tweaks += new/datum/gear_tweak/path(/obj/item/clothing/accessory/holster)

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

/datum/gear/accessory/stethoscope
	display_name = "stethoscope (medical)"
	path = /obj/item/clothing/accessory/stethoscope
	cost = 2
	allowed_roles = STERILE_ROLES

/datum/gear/accessory/brown_vest
	display_name = "webbing, engineering"
	path = /obj/item/clothing/accessory/storage/brown_vest
	cost = 3
	allowed_roles = list("Chief Engineer", "Senior Engineer", "Engineer", "Maintenance Assistant", "Roboticist", "Deck Officer", "Deck Technician",
						"Supply Assistant", "Prospector", "Sanitation Technician", "Research Assistant", "Merchant", "SolGov Pilot", "NanoTrasen Pilot")

/datum/gear/accessory/black_vest
	display_name = "webbing, security"
	path = /obj/item/clothing/accessory/storage/black_vest
	cost = 3
	allowed_roles = list("Chief of Security", "Brig Officer", "Forensic Technician", "Master at Arms", "Security Guard", "Merchant")

/datum/gear/accessory/white_vest
	display_name = "webbing, medical"
	path = /obj/item/clothing/accessory/storage/white_vest
	cost = 3
	allowed_roles = list("Chief Medical Officer", "Physician", "Corpsman", "Medical Contractor", "Merchant")

/datum/gear/accessory/brown_drop_pouches
	display_name = "drop pouches, engineering"
	path = /obj/item/clothing/accessory/storage/drop_pouches/brown
	cost = 3
	allowed_roles = list("Chief Engineer", "Senior Engineer", "Engineer", "Maintenance Assistant", "Roboticist", "Deck Officer", "Deck Technician",
						"Supply Assistant", "Prospector", "Sanitation Technician", "Research Assistant", "Merchant")

/datum/gear/accessory/black_drop_pouches
	display_name = "drop pouches, security"
	path = /obj/item/clothing/accessory/storage/drop_pouches/black
	cost = 3
	allowed_roles = list("Chief of Security", "Brig Officer", "Forensic Technician", "Master at Arms", "Security Guard", "Merchant")

/datum/gear/accessory/white_drop_pouches
	display_name = "drop pouches, medical"
	path = /obj/item/clothing/accessory/storage/drop_pouches/white
	cost = 3
	allowed_roles = list("Chief Medical Officer", "Physician", "Corpsman", "Medical Contractor", "Merchant")

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
	path = /obj/item/clothing/accessory/medal/iron/star
	cost = 8
	allowed_roles = SOLGOV_ROLES

/datum/gear/accessory/solawardmajor/New()
	..()
	var/solmajors = list()
	solmajors["iron star"] = /obj/item/clothing/accessory/medal/iron/star
	solmajors["bronze heart"] = /obj/item/clothing/accessory/medal/bronze/heart
	solmajors["silver sword"] = /obj/item/clothing/accessory/medal/silver/sword
	solmajors["medical heart"] = /obj/item/clothing/accessory/medal/heart
	solmajors["valor medal"] = /obj/item/clothing/accessory/medal/silver/sol
	solmajors["sapienterian medal"] = /obj/item/clothing/accessory/medal/gold/sol
	solmajors["peacekeeper ribbon"] = /obj/item/clothing/accessory/ribbon/peace
	solmajors["marksman ribbon"] = /obj/item/clothing/accessory/ribbon/marksman
	gear_tweaks += new/datum/gear_tweak/path(solmajors)

/datum/gear/accessory/solawardminor
	display_name = "SolGov minor award selection"
	description = "A medal or ribbon awarded to SolGov personnel for minor accomplishments."
	path = /obj/item/clothing/accessory/medal/iron/sol
	cost = 5
	allowed_roles = SOLGOV_ROLES

/datum/gear/accessory/solawardminor/New()
	..()
	var/solminors = list()
	solminors["expeditionary medal"] = /obj/item/clothing/accessory/medal/iron/sol
	solminors["operations medal"] = /obj/item/clothing/accessory/medal/bronze/sol
	solminors["frontier ribbon"] = /obj/item/clothing/accessory/ribbon/frontier
	solminors["instructor ribbon"] = /obj/item/clothing/accessory/ribbon/instructor
	gear_tweaks += new/datum/gear_tweak/path(solminors)

/datum/gear/accessory/ntaward
	display_name = "NanoTrasen award selection"
	description = "A medal or ribbon awarded to NanoTrasen personnel for significant accomplishments."
	path = /obj/item/clothing/accessory/medal/bronze/nanotrasen
	cost = 8
	allowed_roles = list("Research Director", "NanoTrasen Liaison")

/datum/gear/accessory/ntaward/New()
	..()
	var/ntawards = list()
	ntawards["sciences medal"] = /obj/item/clothing/accessory/medal/bronze/nanotrasen
	ntawards["nanotrasen service"] = /obj/item/clothing/accessory/medal/silver/nanotrasen
	ntawards["command medal"] = /obj/item/clothing/accessory/medal/gold/nanotrasen
	gear_tweaks += new/datum/gear_tweak/path(ntawards)

/datum/gear/accessory/tags
	display_name = "dog tags"
	path = /obj/item/clothing/accessory/badge/tags
	allowed_roles = MILITARY_ROLES

/datum/gear/accessory/kneepads
	display_name = "kneepads"
	path = /obj/item/clothing/accessory/kneepads

/datum/gear/accessory/flannel
	allowed_roles = SEMIFORMAL_ROLES
