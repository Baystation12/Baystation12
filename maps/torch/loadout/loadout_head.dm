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

/datum/gear/head/beret/New()
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

/datum/gear/head/beret/expedition
	display_name = "beret, Expeditionary Corps"
	description = "A beret worn by members of the SCG Expeditionary Corps."
	path = /obj/item/clothing/head/beret/sol/expedition
	allowed_roles = list("Commanding Officer", "Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Senior Enlisted Advisor",
						"Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Senior Physician", "Physician", "Deck Officer",
						"Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/head/beret/expedition/security
	display_name = "beret, Expeditionary Corps security"
	path = /obj/item/clothing/head/beret/sol/expedition/security
	allowed_roles = list("Chief of Security", "Brig Officer", "Forensic Technician", "Master at Arms")

/datum/gear/head/beret/expedition/medical
	display_name = "beret, Expeditionary Corps medical"
	path = /obj/item/clothing/head/beret/sol/expedition/medical
	allowed_roles = list("Chief Medical Officer", "Senior Physician", "Physician")

/datum/gear/head/beret/expedition/engineering
	display_name = "beret, Expeditionary Corps engineering"
	path = /obj/item/clothing/head/beret/sol/expedition/engineering
	allowed_roles = list("Chief Engineer", "Senior Engineer", "Engineer")

/datum/gear/head/beret/expedition/supply
	display_name = "beret, Expeditionary Corps supply"
	path = /obj/item/clothing/head/beret/sol/expedition/supply
	allowed_roles = list("Deck Officer", "Deck Technician")

/datum/gear/head/beret/expedition/command
	display_name = "beret, Expeditionary Corps command"
	path = /obj/item/clothing/head/beret/sol/expedition/command
	allowed_roles = list("Commanding Officer", "Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Senior Enlisted Advisor")

/datum/gear/head/beret/fleet
	display_name = "beret, Expeditionary Corps"
	description = "A beret worn by members of the SCG Fleet."
	path = /obj/item/clothing/head/beret/sol/fleet
	allowed_roles = list("Commanding Officer", "Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Senior Enlisted Advisor",
						"Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Senior Physician", "Physician", "Deck Officer",
						"Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/head/beret/fleet/security
	display_name = "beret, Fleet security"
	path = /obj/item/clothing/head/beret/sol/fleet/security
	allowed_roles = list("Chief of Security", "Brig Officer", "Forensic Technician", "Master at Arms")

/datum/gear/head/beret/fleet/medical
	display_name = "beret, Fleet medical"
	path = /obj/item/clothing/head/beret/sol/fleet/medical
	allowed_roles = list("Chief Medical Officer", "Senior Physician", "Physician")

/datum/gear/head/beret/fleet/engineering
	display_name = "beret, Fleet engineering"
	path = /obj/item/clothing/head/beret/sol/fleet/engineering
	allowed_roles = list("Chief Engineer", "Senior Engineer", "Engineer")

/datum/gear/head/beret/fleet/supply
	display_name = "beret, Fleet supply"
	path = /obj/item/clothing/head/beret/sol/fleet/supply
	allowed_roles = list("Deck Officer", "Deck Technician")

/datum/gear/head/beret/fleet/command
	display_name = "beret, Fleet command"
	path = /obj/item/clothing/head/beret/sol/fleet/command
	allowed_roles = list("Commanding Officer", "Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Senior Enlisted Advisor")


/datum/gear/head/beret/whitentsec
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
	caps["corporate security cap"] = /obj/item/clothing/head/soft/sec/corp
	gear_tweaks += new/datum/gear_tweak/path(caps)


/datum/gear/head/seccap
	display_name = "cap, NanoTrasen security"
	path = /obj/item/clothing/head/soft/sec/corp/guard
	allowed_roles = list("Security Guard")

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

/datum/gear/head/echat
	display_name = "Expeditionary Corps Cap"
	path = /obj/item/clothing/head/soft/sol/expedition
	allowed_roles = list("Commanding Officer", "Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Senior Enlisted Advisor",
						"Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Senior Physician", "Physician", "Deck Officer",
						"Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/head/ecenlisteddress
	display_name = "Expeditionary Corps Enlisted Dress Cover"
	path = /obj/item/clothing/head/dress/expedition
	allowed_roles = list("Senior Enlisted Advisor", "Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Senior Physician",
						"Physician", "Deck Officer", "Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/head/eccommanddress
	display_name = "Expeditionary Corps Officer Dress Cover"
	path = /obj/item/clothing/head/dress/expedition/command
	allowed_roles = list("Commanding Officer", "Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Senior Physician", "Deck Officer")

/datum/gear/head/fleetcap
	display_name = "Fleet Cap"
	path = /obj/item/clothing/head/soft/sol/fleet
	allowed_roles = list("Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Senior Enlisted Advisor",
						"Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Senior Physician", "Physician", "Deck Officer",
						"Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/head/fleetutility
	display_name = "Fleet Utility Cover"
	path = /obj/item/clothing/head/utility/fleet
	allowed_roles = list("Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Senior Enlisted Advisor",
						"Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Senior Physician", "Physician", "Deck Officer",
						"Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/head/fleetenlisteddress
	display_name = "Fleet Enlisted Wheel Cover"
	path = /obj/item/clothing/head/dress/fleet
	allowed_roles = list("Senior Enlisted Advisor", "Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Senior Physician",
						"Physician", "Deck Officer", "Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/head/fleetofficerdress
	display_name = "Fleet Officer Wheel Cover"
	path = /obj/item/clothing/head/dress/fleet/command
	allowed_roles = list("Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Senior Physician", "Deck Officer")

/datum/gear/head/marineutility
	display_name = "Marine Utility Cover"
	path = /obj/item/clothing/head/utility/marine
	allowed_roles = list("Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Senior Enlisted Advisor",
						"Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Deck Officer",
						"Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/head/marineutilitytan
	display_name = "Tan Marine Utility Cover"
	path = /obj/item/clothing/head/utility/marine/tan
	allowed_roles = list("Executive Officer", "Chief Engineer", "Chief of Security", "Senior Enlisted Advisor",
						"Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Deck Officer",
						"Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/head/marineutilitygreen
	display_name = "Green Marine Utility Cover"
	path = /obj/item/clothing/head/utility/marine/green
	allowed_roles = list("Executive Officer", "Chief Engineer", "Chief of Security", "Senior Enlisted Advisor",
						"Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Deck Officer",
						"Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/head/marineenlistedservice
	display_name = "Marine Enlisted Wheel Cover"
	path = /obj/item/clothing/head/service/marine
	allowed_roles = list("Senior Enlisted Advisor", "Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms",
						"Deck Officer", "Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/head/marineofficerservice
	display_name = "Marine Officer Wheel Cover"
	path = /obj/item/clothing/head/service/marine/command
	allowed_roles = list("Executive Officer", "Chief Engineer", "Chief of Security", "Deck Officer")

/datum/gear/head/marineenlistedgarrison
	display_name = "Marine Enlisted Garrison Cap"
	path = /obj/item/clothing/head/service/marine/garrison
	allowed_roles = list("Senior Enlisted Advisor", "Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms",
						"Deck Officer", "Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/head/marineofficergarrison
	display_name = "Marine Officer's Garrison Cap"
	path = /obj/item/clothing/head/service/marine/garrison/command
	allowed_roles = list("Executive Officer", "Chief Engineer", "Chief of Security", "Deck Officer")

/datum/gear/head/marineenlisteddress
	display_name = "Marine Enlisted Dress Cover"
	path = /obj/item/clothing/head/dress/marine
	allowed_roles = list("Senior Enlisted Advisor", "Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms",
						"Deck Officer", "Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/head/marineofficerdress
	display_name = "Marine Officer's Dress Cover"
	path = /obj/item/clothing/head/dress/marine/command
	allowed_roles = list("Executive Officer", "Chief Engineer", "Chief of Security", "Deck Officer")
