// Suit slot
/datum/gear/suit
	display_name = "labcoat, plain"
	path = /obj/item/clothing/suit/storage/toggle/labcoat
	slot = slot_wear_suit
	sort_category = "Suits and Overwear"
	cost = 2

/datum/gear/suit/blueapron
	display_name = "apron, blue"
	path = /obj/item/clothing/suit/apron
	cost = 1
	allowed_roles = list("Research Director", "NanoTrasen Liaison", "Scientist", "Prospector", "Security Guard", "Research Assistant",
						"SolGov Representative", "Passenger", "Maintenance Assistant", "Roboticist", "Medical Assistant",
						"Virologist", "Chemist", "Counselor", "Supply Assistant", "Bartender", "Merchant")

/datum/gear/suit/overalls
	display_name = "apron, overalls"
	path = /obj/item/clothing/suit/apron/overalls
	cost = 1
	allowed_roles = list("Research Director", "NanoTrasen Liaison", "Scientist", "Prospector", "Security Guard", "Research Assistant",
						"SolGov Representative", "Passenger", "Maintenance Assistant", "Roboticist", "Medical Assistant",
						"Virologist", "Chemist", "Counselor", "Supply Assistant", "Bartender", "Merchant")

/datum/gear/suit/leather
	display_name = "jacket selection"
	path = /obj/item/clothing/suit/storage/leather_jacket
	allowed_roles = list("Research Director", "NanoTrasen Liaison", "Scientist", "Prospector", "Security Guard", "Research Assistant",
						"SolGov Representative", "Passenger", "Maintenance Assistant", "Roboticist", "Medical Assistant",
						"Virologist", "Chemist", "Counselor", "Supply Assistant", "Bartender", "Merchant")

/datum/gear/suit/leather/New()
	..()
	var/jackets = list()
	jackets["bomber jacket"] = /obj/item/clothing/suit/storage/toggle/bomber
	jackets["corporate black jacket"] = /obj/item/clothing/suit/storage/leather_jacket/nanotrasen
	jackets["corporate brown jacket"] = /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen
	jackets["black jacket"] = /obj/item/clothing/suit/storage/leather_jacket
	jackets["brown jacket"] = /obj/item/clothing/suit/storage/toggle/brown_jacket
	jackets["major bill's shipping jacket"] = /obj/item/clothing/suit/storage/mbill
	gear_tweaks += new/datum/gear_tweak/path(jackets)

/datum/gear/suit/hazard
	display_name = "hazard vests"
	path = /obj/item/clothing/suit/storage/hazardvest

/datum/gear/suit/hazard/New()
	..()
	gear_tweaks += new/datum/gear_tweak/path(/obj/item/clothing/suit/storage/hazardvest)

/datum/gear/suit/hoodie
	display_name = "hoodie"
	path = /obj/item/clothing/suit/storage/toggle/hoodie
	flags = GEAR_HAS_COLOR_SELECTION
	allowed_roles = list("Passenger", "Bartender")

/datum/gear/suit/labcoat
	display_name = "labcoat, colored"
	path = /obj/item/clothing/suit/storage/toggle/labcoat
	flags = GEAR_HAS_COLOR_SELECTION
	allowed_roles = list("Research Director", "NanoTrasen Liaison", "Scientist", "Prospector", "Security Guard", "Research Assistant",
						"SolGov Representative", "Passenger", "Maintenance Assistant", "Roboticist", "Medical Assistant",
						"Virologist", "Chemist", "Counselor", "Supply Assistant", "Bartender", "Merchant")

/datum/gear/suit/medcoat
	display_name = "medical suit selection"
	path = /obj/item/clothing/suit/storage/toggle/fr_jacket
	allowed_roles = list("Chief Medical Officer", "Senior Physician", "Physician", "Medical Assistant", "Virologist", "Chemist", "Counselor")

/datum/gear/suit/medcoat/New()
	..()
	var/medcoats = list()
	medcoats["jacket, first responder"] = /obj/item/clothing/suit/storage/toggle/fr_jacket
	medcoats["labcoat, medical"] = /obj/item/clothing/suit/storage/toggle/labcoat/blue
	medcoats["apron, surgical"] = /obj/item/clothing/suit/surgicalapron
	gear_tweaks += new/datum/gear_tweak/path(medcoats)

/datum/gear/suit/trenchcoat
	display_name = "trenchcoat selection"
	path = /obj/item/clothing/suit/storage/det_trench
	cost = 3
	allowed_roles = list("Passenger", "Bartender")

/datum/gear/suit/trenchcoat/New()
	..()
	var/trenchcoats = list()
	trenchcoats["trenchcoat, brown"] = /obj/item/clothing/suit/storage/det_trench
	trenchcoats["trenchcoat, grey"] = /obj/item/clothing/suit/storage/det_trench/grey
	trenchcoats["coat, duster"] = /obj/item/clothing/suit/leathercoat
	gear_tweaks += new/datum/gear_tweak/path(trenchcoats)


/datum/gear/suit/poncho
	display_name = "poncho selection"
	path = /obj/item/clothing/suit/poncho/colored
	cost = 1
	allowed_roles = list("Passenger", "Bartender", "Merchant")

/datum/gear/suit/poncho/New()
	..()
	gear_tweaks += new/datum/gear_tweak/path(/obj/item/clothing/suit/poncho/colored)

/datum/gear/suit/roles/poncho/security
	display_name = "poncho, security"
	path = /obj/item/clothing/suit/poncho/roles/security
	allowed_roles = list("Security Guard")

/datum/gear/suit/roles/poncho/medical
	display_name = "poncho, medical"
	path = /obj/item/clothing/suit/poncho/roles/medical
	allowed_roles = list("Medical Assistant", "Virologist", "Chemist", "Counselor")

/datum/gear/suit/roles/poncho/engineering
	display_name = "poncho, engineering"
	path = /obj/item/clothing/suit/poncho/roles/engineering
	allowed_roles = list("Maintenance Assistant", "Roboticist")

/datum/gear/suit/roles/poncho/science
	display_name = "poncho, science"
	path = /obj/item/clothing/suit/poncho/roles/science
	allowed_roles = list("Scientist", "Research Assistant")

/datum/gear/suit/roles/poncho/cargo
	display_name = "poncho, supply"
	path = /obj/item/clothing/suit/poncho/roles/cargo
	allowed_roles = list("Supply Assistant", "Merchant")

/datum/gear/suit/suit_jacket
	display_name = "suit jackets"
	path = /obj/item/clothing/suit/storage/toggle/lawyer/bluejacket
	allowed_roles = list("NanoTrasen Liaison", "SolGov Representative", "Passenger", "Bartender", "Merchant")

/datum/gear/suit/suit_jacket/New()
	..()
	var/suitjackets = list()
	suitjackets["black suit jacket"] = /obj/item/clothing/suit/storage/toggle/internalaffairs/plain
	suitjackets["blue suit jacket"] = /obj/item/clothing/suit/storage/toggle/lawyer/bluejacket
	suitjackets["purple suit jacket"] = /obj/item/clothing/suit/storage/lawyer/purpjacket
	gear_tweaks += new/datum/gear_tweak/path(suitjackets)

/datum/gear/suit/wintercoat
	display_name = "winter coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat
	allowed_roles = list("Passenger", "Bartender", "Merchant")

/datum/gear/suit/ecservice
	display_name = "(EC) Service Jacket"
	description = "Service jacket of the SCG Expeditionary Corps"
	path = /obj/item/clothing/suit/storage/service/expeditionary
	cost = 0
	allowed_roles = list("Commanding Officer", "Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Senior Enlisted Advisor",
						"Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Senior Physician", "Physician", "Deck Officer",
						"Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/suit/ecmedservice
	display_name = "(EC) Medical Service Jacket"
	description = "Service jacket of the SCG Expeditionary Corps"
	path = /obj/item/clothing/suit/storage/service/expeditionary/medical
	cost = 0
	allowed_roles = list("Senior Physician", "Physician")

/datum/gear/suit/ecmedcomservice
	display_name = "(EC) Medical Command Service Jacket"
	description = "Service jacket of the SCG Expeditionary Corps"
	path = /obj/item/clothing/suit/storage/service/expeditionary/medical/command
	cost = 0
	allowed_roles = list("Chief Medical Officer")

/datum/gear/suit/ecengservice
	display_name = "(EC) Engineering Service Jacket"
	description = "Service jacket of the SCG Expeditionary Corps"
	path = /obj/item/clothing/suit/storage/service/expeditionary/engineering
	cost = 0
	allowed_roles = list("Senior Engineer", "Engineer")

/datum/gear/suit/ecengcomservice
	display_name = "(EC) Engineering Command Service Jacket"
	description = "Service jacket of the SCG Expeditionary Corps"
	path = /obj/item/clothing/suit/storage/service/expeditionary/engineering/command
	cost = 0
	allowed_roles = list("Chief Engineer")

/datum/gear/suit/ecsupservice
	display_name = "(EC) Supply Service Jacket"
	description = "Service jacket of the SCG Expeditionary Corps"
	path = /obj/item/clothing/suit/storage/service/expeditionary/supply
	cost = 0
	allowed_roles = list("Deck Officer", "Deck Technician")

/datum/gear/suit/ecsecservice
	display_name = "(EC) Security Service Jacket"
	description = "Service jacket of the SCG Expeditionary Corps"
	path = /obj/item/clothing/suit/storage/service/expeditionary/security
	cost = 0
	allowed_roles = list("Brig Officer", "Forensic Technician", "Master at Arms")

/datum/gear/suit/ecseccomservice
	display_name = "(EC) Security Command Service Jacket"
	description = "Service jacket of the SCG Expeditionary Corps"
	path = /obj/item/clothing/suit/storage/service/expeditionary/security/command
	cost = 0
	allowed_roles = list("Chief of Security")

/datum/gear/suit/eccomservice
	display_name = "(EC) Command Service Jacket"
	description = "Service jacket of the SCG Expeditionary Corps"
	path = /obj/item/clothing/suit/storage/service/expeditionary/command
	cost = 0
	allowed_roles = list("Commanding Officer", "Executive Officer", "Senior Enlisted Advisor")

/datum/gear/suit/ecenlisteddress
	display_name = "(EC) Enlisted Dress Jacket"
	description = "Dress jacket of the SCG Expeditionary Corps"
	path = /obj/item/clothing/suit/dress/expedition
	cost = 0
	allowed_roles = list("Senior Enlisted Advisor", "Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Senior Physician",
						"Physician", "Deck Officer", "Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/suit/ecofficerdress
	display_name = "(EC) Officer's Dress Jacket"
	description = "Dress jacket of the SCG Expeditionary Corps"
	path = /obj/item/clothing/suit/dress/expedition/command
	cost = 0
	allowed_roles = list("Commanding Officer", "Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Senior Physician", "Deck Officer")

/datum/gear/suit/fleetenlisteddress
	display_name = "(FLEET) Enlisted Dress Jacket"
	description = "Dress jacket of the SCG Fleet"
	path = /obj/item/clothing/suit/storage/toggle/dress/fleet
	cost = 0
	allowed_roles = list("Senior Enlisted Advisor", "Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Senior Physician",
						"Physician", "Deck Officer", "Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/suit/fleetofficerdress
	display_name = "(FLEET) Officer's Dress Jacket"
	description = "Dress jacket of the SCG Fleet"
	path = /obj/item/clothing/suit/storage/toggle/dress/fleet/command
	cost = 0
	allowed_roles = list("Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Senior Physician", "Deck Officer")

/datum/gear/suit/marineservice
	display_name = "(MARINE) Service Jacket"
	description = "Service coat of the SCG Marine Corps"
	path = /obj/item/clothing/suit/storage/service/marine
	cost = 0
	allowed_roles = list("Executive Officer", "Chief Engineer", "Chief of Security", "Senior Enlisted Advisor",
						"Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Deck Officer",
						"Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/suit/marineengservice
	display_name = "(MARINE) Engineering Service Jacket"
	description = "Service coat of the SCG Marine Corps"
	path = /obj/item/clothing/suit/storage/service/marine/engineering
	cost = 0
	allowed_roles = list("Senior Engineer", "Engineer")

/datum/gear/suit/marineengcomservice
	display_name = "(MARINE) Engineering Command Service Jacket"
	description = "Service coat of the SCG Marine Corps"
	path = /obj/item/clothing/suit/storage/service/marine/engineering/command
	cost = 0
	allowed_roles = list("Chief Engineer")

/datum/gear/suit/marinesupservice
	display_name = "(MARINE) Supply Service Jacket"
	description = "Service coat of the SCG Marine Corps"
	path = /obj/item/clothing/suit/storage/service/marine/supply
	cost = 0
	allowed_roles = list("Deck Officer", "Deck Technician")

/datum/gear/suit/marinesecservice
	display_name = "(MARINE) Security Service Jacket"
	description = "Service coat of the SCG Marine Corps"
	path = /obj/item/clothing/suit/storage/service/marine/security
	cost = 0
	allowed_roles = list("Brig Officer", "Forensic Technician", "Master at Arms")

/datum/gear/suit/marineseccomservice
	display_name = "(MARINE) Security Command Service Jacket"
	description = "Service coat of the SCG Marine Corps"
	path = /obj/item/clothing/suit/storage/service/marine/security/command
	cost = 0
	allowed_roles = list("Chief of Security")

/datum/gear/suit/marinecomservice
	display_name = "(MARINE) Command Service Jacket"
	description = "Service coat of the SCG Marine Corps"
	path = /obj/item/clothing/suit/storage/service/marine/command
	cost = 0
	allowed_roles = list("Executive Officer", "Senior Enlisted Advisor")

/datum/gear/suit/marineenlisteddress
	display_name = "(MARINE) Enlisted Dress Jacket"
	description = "Dress Jacket of the SCG Marine Corps"
	path = /obj/item/clothing/suit/dress/marine
	cost = 0
	allowed_roles = list("Senior Enlisted Advisor", "Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms",
						"Deck Officer", "Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/suit/marineofficerdress
	display_name = "(MARINE) Officer's Dress Jacket"
	description = "Dress Jacket of the SCG Marine Corps"
	path = /obj/item/clothing/suit/dress/marine/command
	cost = 0
	allowed_roles = list("Executive Officer","Chief Engineer", "Chief of Security", "Deck Officer")

