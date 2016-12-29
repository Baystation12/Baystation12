/datum/gear/head
	path = /obj/item/clothing/head
	slot = slot_head
	sort_category = "Hats and Headwear"
	category = /datum/gear/head

/datum/gear/head/bandana
	display_name = "bandana selection"
	path = /obj/item/clothing/head/bandana
	allowed_roles = list("Research Director", "NanoTrasen Liaison", "Scientist", "Prospector", "Security Guard", "Research Assistant",
						"SolGov Representative", "Passenger", "Maintenance Assistant", "Roboticist", "Medical Assistant",
						"Virologist", "Chemist", "Counselor", "Supply Assistant", "Bartender", "Merchant")

/datum/gear/head/bandana/New()
	..()
	var/bandanas = list()
	bandanas["green bandana"] = /obj/item/clothing/head/greenbandana
	bandanas["orange bandana"] = /obj/item/clothing/head/orangebandana
	bandanas["pirate bandana"] = /obj/item/clothing/head/bandana
	gear_tweaks += new/datum/gear_tweak/path(bandanas)

/datum/gear/head/solberet
	display_name = "SolGov beret selection"
	description = "A beret denoting service in an organization within SolGov."
	path = /obj/item/clothing/head/beret/sol
	allowed_roles = list("Commanding Officer", "Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Senior Enlisted Advisor",
						"Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Senior Physician", "Physician", "Deck Officer",
						"Deck Technician", "Sanitation Technician", "Cook", "Crewman", "SolGov Representative")

/datum/gear/head/solberet/New()
	..()
	var/berets = list()
	berets["peacekeeper beret"] = /obj/item/clothing/head/beret/sol
	berets["home guard beret"] = /obj/item/clothing/head/beret/sol/homeguard
	berets["gateway administration beret"] = /obj/item/clothing/head/beret/sol/gateway
	berets["customs and trade beret"] = /obj/item/clothing/head/beret/sol/customs
	berets["orbital assault beret"] = /obj/item/clothing/head/beret/sol/orbital
	berets["government research beret"] = /obj/item/clothing/head/beret/sol/research
	berets["health service beret"] = /obj/item/clothing/head/beret/sol/gateway
	gear_tweaks += new/datum/gear_tweak/path(berets)

/datum/gear/head/whitentberet
	display_name = "beret, NanoTrasen security"
	path = /obj/item/clothing/head/beret/guard
	allowed_roles = list("Security Guard")

/datum/gear/head/cap
	display_name = "cap selection"
	path = /obj/item/clothing/head/soft
	allowed_roles = list("Research Director", "NanoTrasen Liaison", "Scientist", "Prospector", "Security Guard", "Research Assistant",
						"SolGov Representative", "Passenger", "Maintenance Assistant", "Roboticist", "Medical Assistant",
						"Virologist", "Chemist", "Counselor", "Supply Assistant", "Bartender", "Merchant")

/datum/gear/head/cap/New()
	..()
	var/caps = list()
	caps["black cap"] = /obj/item/clothing/head/soft/black
	caps["blue cap"] = /obj/item/clothing/head/soft/blue
	caps["flat cap"] = /obj/item/clothing/head/flatcap
	caps["green cap"] = /obj/item/clothing/head/soft/green
	caps["grey cap"] = /obj/item/clothing/head/soft/grey
	caps["mailman cap"] = /obj/item/clothing/head/mailman
	caps["orange cap"] = /obj/item/clothing/head/soft/orange
	caps["purple cap"] = /obj/item/clothing/head/soft/purple
	caps["rainbow cap"] = /obj/item/clothing/head/soft/rainbow
	caps["red cap"] = /obj/item/clothing/head/soft/red
	caps["white cap"] = /obj/item/clothing/head/soft/mime
	caps["yellow cap"] = /obj/item/clothing/head/soft/yellow
	caps["major bill's shipping cap"] = /obj/item/clothing/head/soft/mbill
	gear_tweaks += new/datum/gear_tweak/path(caps)


/datum/gear/head/hairflower
	display_name = "hair flower pin"
	path = /obj/item/clothing/head/hairflower
	allowed_roles = list("NanoTrasen Liaison", "SolGov Representative", "Passenger", "Bartender")

/datum/gear/head/hairflower/New()
	..()
	var/pins = list()
	pins["blue pin"] = /obj/item/clothing/head/hairflower/blue
	pins["pink pin"] = /obj/item/clothing/head/hairflower/pink
	pins["red pin"] = /obj/item/clothing/head/hairflower
	pins["yellow pin"] = /obj/item/clothing/head/hairflower/yellow
	gear_tweaks += new/datum/gear_tweak/path(pins)

/datum/gear/head/hardhat
	display_name = "hardhat selection"
	path = /obj/item/clothing/head/hardhat
	cost = 2
	allowed_roles = list("Chief Engineer", "Senior Engineer", "Engineer", "Maintenance Assistant", "Roboticist", "Deck Officer", "Deck Technician",
						"Supply Assistant", "Prospector", "Sanitation Technician", "Research Assistant", "Merchant")

/datum/gear/head/hardhat/New()
	..()
	var/hardhats = list()
	hardhats["blue hardhat"] = /obj/item/clothing/head/hardhat/dblue
	hardhats["orange hardhat"] = /obj/item/clothing/head/hardhat/orange
	hardhats["red hardhat"] = /obj/item/clothing/head/hardhat/red
	hardhats["yellow hardhat"] = /obj/item/clothing/head/hardhat
	gear_tweaks += new/datum/gear_tweak/path(hardhats)

/datum/gear/head/hat
	display_name = "hat selection"
	path = /obj/item/clothing/head/hasturhood
	allowed_roles = list("NanoTrasen Liaison", "SolGov Representative", "Passenger", "Bartender", "Merchant")

/datum/gear/head/hat/New()
	..()
	var/hats = list()
	hats["boatsman hat"] = /obj/item/clothing/head/boaterhat
	hats["bowler hat"] = /obj/item/clothing/head/bowler
	hats["cowboy hat"] = /obj/item/clothing/head/cowboy_hat
	hats["fedora"] = /obj/item/clothing/head/fedora //m'lady
	hats["feather thrilby"] = /obj/item/clothing/head/feathertrilby
	hats["fez"] = /obj/item/clothing/head/fez
	hats["top hat"] = /obj/item/clothing/head/that
	hats["ushanka"] = /obj/item/clothing/head/ushanka
	hats["fedora, brown"] = /obj/item/clothing/head/det
	hats["fedora, grey"] = /obj/item/clothing/head/det/grey
	gear_tweaks += new/datum/gear_tweak/path(hats)

/datum/gear/head/hijab
	display_name = "hijab"
	path = /obj/item/clothing/head/hijab
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/kippa
	display_name = "kippa"
	path = /obj/item/clothing/head/kippa
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/turban
	display_name = "turban"
	path = /obj/item/clothing/head/turban
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/welding
	display_name = "welding mask selection"
	path = /obj/item/clothing/head/welding
	allowed_roles = list("Senior Engineer", "Engineer", "Maintenance Assistant", "Roboticist", "Deck Officer", "Deck Technician",
						"Supply Assistant", "Prospector", "Research Assistant", "Merchant")

/datum/gear/head/welding/New()
	..()
	var/welding_masks = list()
	welding_masks += /obj/item/clothing/head/welding/demon
	welding_masks += /obj/item/clothing/head/welding/engie
	welding_masks += /obj/item/clothing/head/welding/fancy
	welding_masks += /obj/item/clothing/head/welding/knight
	gear_tweaks += new/datum/gear_tweak/path(assoc_by_proc(welding_masks, /proc/get_initial_name))

/datum/gear/head/solhat
	display_name = "Sol Central Government Cap"
	path = /obj/item/clothing/head/soft/sol
	allowed_roles = list("Commanding Officer", "Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Senior Enlisted Advisor",
						"Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Senior Physician", "Physician", "Deck Officer",
						"Deck Technician", "Sanitation Technician", "Cook", "Crewman", "SolGov Representative")
