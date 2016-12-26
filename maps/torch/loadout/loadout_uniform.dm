// Uniform slot
/datum/gear/uniform
	display_name = "black shorts" //kept separate because there aren't any other uniforms that every role could have
	path = /obj/item/clothing/under/shorts/black
	slot = slot_w_uniform
	sort_category = "Uniforms and Casual Dress"

/datum/gear/uniform/shortjumpskirt
	display_name = "short jumpskirt"
	path = /obj/item/clothing/under/shortjumpskirt
	flags = GEAR_HAS_COLOR_SELECTION
	allowed_roles = list("NanoTrasen Liaison", "SolGov Representative", "Passenger", "Bartender", "Merchant")

/datum/gear/uniform/jumpsuit
	display_name = "generic jumpsuits"
	path = /obj/item/clothing/under/color/grey
	allowed_roles = list("NanoTrasen Liaison", "SolGov Representative", "Passenger", "Bartender", "Merchant")

/datum/gear/uniform/jumpsuit/New()
	..()
	gear_tweaks += new/datum/gear_tweak/path(/obj/item/clothing/under/color)

/datum/gear/uniform/roboticist_skirt
	display_name = "skirt, roboticist"
	path = /obj/item/clothing/under/rank/roboticist/skirt
	allowed_roles = list("Roboticist")

/datum/gear/uniform/suit
	display_name = "clothes selection"
	path = /obj/item/clothing/under/sl_suit
	allowed_roles = list("NanoTrasen Liaison", "SolGov Representative", "Passenger", "Bartender", "Merchant")

/datum/gear/uniform/suit/New()
	..()
	var/suits = list()
	suits["amish suit"] = /obj/item/clothing/under/sl_suit
	suits["black suit"] = /obj/item/clothing/under/suit_jacket
	suits["blue suit"] = /obj/item/clothing/under/lawyer/blue
	suits["burgundy suit"] = /obj/item/clothing/under/suit_jacket/burgundy
	suits["charcoal suit"] = /obj/item/clothing/under/suit_jacket/charcoal
	suits["checkered suit"] = /obj/item/clothing/under/suit_jacket/checkered
	suits["executive suit"] = /obj/item/clothing/under/suit_jacket/really_black
	suits["female executive suit"] = /obj/item/clothing/under/suit_jacket/female
	suits["gentleman suit"] = /obj/item/clothing/under/gentlesuit
	suits["navy suit"] = /obj/item/clothing/under/suit_jacket/navy
	suits["old man suit"] = /obj/item/clothing/under/lawyer/oldman
	suits["purple suit"] = /obj/item/clothing/under/lawyer/purpsuit
	suits["red suit"] = /obj/item/clothing/under/suit_jacket/red
	suits["red lawyer suit"] = /obj/item/clothing/under/lawyer/red
	suits["shiny black suit"] = /obj/item/clothing/under/lawyer/black
	suits["tan suit"] = /obj/item/clothing/under/suit_jacket/tan
	suits["white suit"] = /obj/item/clothing/under/scratch
	suits["white-blue suit"] = /obj/item/clothing/under/lawyer/bluesuit
	suits["formal outfit"] = /obj/item/clothing/under/rank/internalaffairs/plain
	suits["blue blazer"] = /obj/item/clothing/under/blazer
	suits["black jumpskirt"] = /obj/item/clothing/under/blackjumpskirt
	suits["kilt"] = /datum/gear/uniform/kilt
	suits["human resources dress"] = /obj/item/clothing/under/dress/dress_hr
	suits["frontier overalls"] = /obj/item/clothing/under/frontier
	gear_tweaks += new/datum/gear_tweak/path(suits)

/datum/gear/uniform/scrubs
	display_name = "medical scrubs"
	path = /obj/item/clothing/under/rank/medical/black
	allowed_roles = list("Chief Medical Officer", "Senior Physician", "Physician", "Medical Assistant", "Virologist", "Chemist", "Counselor")

/datum/gear/uniform/scrubs/New()
	..()
	var/scrubcolor = list()
	scrubcolor["black scrubs"] = /obj/item/clothing/under/rank/medical/black
	scrubcolor["blue scrubs"] = /obj/item/clothing/under/rank/medical/blue
	scrubcolor["green scrubs"] = /obj/item/clothing/under/rank/medical/green
	scrubcolor["navy blue scrubs"] = /obj/item/clothing/under/rank/medical/navyblue
	scrubcolor["purple scrubs"] = /obj/item/clothing/under/rank/medical/purple
	gear_tweaks += new/datum/gear_tweak/path(scrubcolor)

/datum/gear/uniform/dress
	display_name = "dress selection"
	path = /obj/item/clothing/under/sundress_white
	allowed_roles = list("NanoTrasen Liaison", "SolGov Representative", "Passenger", "Bartender", "Merchant")

/datum/gear/uniform/dress/New()
	..()
	var/dresses = list()
	dresses["white sundress"] = /obj/item/clothing/under/sundress_white
	dresses["flame dress"] = /obj/item/clothing/under/dress/dress_fire
	dresses["green dress"] = /obj/item/clothing/under/dress/dress_green
	dresses["orange dress"] = /obj/item/clothing/under/dress/dress_orange
	dresses["pink dress"] = /obj/item/clothing/under/dress/dress_pink
	dresses["purple dress"] = /obj/item/clothing/under/dress/dress_purple
	dresses["sundress"] = /obj/item/clothing/under/sundress
	dresses["white cheongsam"] = /datum/gear/uniform/cheongsam
	gear_tweaks += new/datum/gear_tweak/path(dresses)

/datum/gear/uniform/skirt
	display_name = "skirt selection"
	path = /obj/item/clothing/under/skirt
	allowed_roles = list("NanoTrasen Liaison", "SolGov Representative", "Passenger", "Bartender", "Merchant")

/datum/gear/uniform/skirt/New()
	..()
	var/list/skirts = list()
	for(var/skirt in (typesof(/obj/item/clothing/under/skirt)))
		var/obj/item/clothing/under/skirt/skirt_type = skirt
		skirts[initial(skirt_type.name)] = skirt_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(skirts))

/datum/gear/uniform/pants
	display_name = "pants selection"
	path = /obj/item/clothing/under/pants/white
	allowed_roles = list("Research Director", "NanoTrasen Liaison", "Scientist", "Prospector", "Security Guard", "Research Assistant",
						"SolGov Representative", "Passenger", "Maintenance Assistant", "Roboticist", "Medical Assistant",
						"Virologist", "Chemist", "Counselor", "Supply Assistant", "Bartender", "Merchant")

/datum/gear/uniform/pants/New()
	..()
	var/list/pants = list()
	for(var/pant in typesof(/obj/item/clothing/under/pants))
		var/obj/item/clothing/under/pants/pant_type = pant
		pants[initial(pant_type.name)] = pant_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(pants))

/datum/gear/uniform/shorts
	display_name = "shorts selection"
	path = /obj/item/clothing/under/shorts/jeans
	allowed_roles = list("Passenger", "Bartender", "Supply Assistant", "Merchant")

/datum/gear/uniform/shorts/New()
	..()
	var/list/shorts = list()
	for(var/short in typesof(/obj/item/clothing/under/shorts))
		var/obj/item/clothing/under/pants/short_type = short
		shorts[initial(short_type.name)] = short_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(shorts))

/datum/gear/uniform/tacticool
	display_name = "tacticool turtleneck"
	path = /obj/item/clothing/under/syndicate/tacticool
	allowed_roles = list("Passenger", "Bartender", "Merchant")

/datum/gear/uniform/turtleneck
	display_name = "sweater"
	path = /obj/item/clothing/under/rank/psych/turtleneck/sweater
	flags = GEAR_HAS_COLOR_SELECTION
	allowed_roles = list("NanoTrasen Liaison", "SolGov Representative", "Passenger", "Bartender", "Merchant")

/datum/gear/uniform/tacticool
	display_name = "tacticool turtleneck"
	path = /obj/item/clothing/under/syndicate/tacticool
	allowed_roles = list("Passenger", "Bartender", "Merchant")

/datum/gear/uniform/corporate
	display_name = "corporate uniform selection"
	path = /obj/item/clothing/under/mbill
	allowed_roles = list("Scientist", "Prospector", "Security Guard", "Research Assistant",
						"Passenger", "Maintenance Assistant", "Roboticist", "Medical Assistant",
						"Virologist", "Chemist", "Counselor", "Supply Assistant", "Bartender", "Merchant")

/datum/gear/uniform/corporate/New()
	..()
	var/corps = list()
	corps["major bill's shipping uniform"] = /obj/item/clothing/under/mbill
	corps["SAARE uniform"] = /obj/item/clothing/under/saare
	corps["aether atmospherics uniform"] = /obj/item/clothing/under/aether
	corps["hephaestus uniform"] = /obj/item/clothing/under/hephaestus
	corps["PCRC uniform"] = /obj/item/clothing/under/pcrc
	corps["ward-takahashi uniform"] = /obj/item/clothing/under/wardt
	corps["grayson uniform"] = /obj/item/clothing/under/grayson
	corps["focal point uniform"] = /obj/item/clothing/under/focal
	gear_tweaks += new/datum/gear_tweak/path(corps)

/datum/gear/uniform/sterile
	display_name = "sterile jumpsuit"
	path = /obj/item/clothing/under/sterile
	allowed_roles = list("Chief Medical Officer", "Senior Physician", "Physician", "Medical Assistant", "Virologist", "Chemist", "Counselor")

/datum/gear/uniform/hazard
	display_name = "hazard jumpsuit"
	path = /obj/item/clothing/under/hazard
	allowed_roles = list("Chief Engineer", "Senior Engineer", "Engineer", "Maintenance Assistant", "Roboticist")

/datum/gear/uniform/utility
	display_name = "Contractor Utility Uniform"
	path = /obj/item/clothing/under/utility
	allowed_roles = list("Maintenance Assistant", "Roboticist", "Medical Assistant", "Virologist", "Chemist", "Counselor", "Supply Assistant", "Bartender")

/datum/gear/uniform/ecpt
	display_name = "Expeditionary Corps PT Uniform"
	path = /obj/item/clothing/under/pt/expeditionary
	allowed_roles = list("Commanding Officer", "Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Senior Enlisted Advisor",
						"Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Senior Physician", "Physician", "Deck Officer",
						"Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/uniform/fleetpt
	display_name = "Fleet PT Uniform"
	path = /obj/item/clothing/under/pt/fleet
	allowed_roles = list("Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Senior Enlisted Advisor",
						"Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Senior Physician", "Physician", "Deck Officer",
						"Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/uniform/marinept
	display_name = "Marine PT Uniform"
	path = /obj/item/clothing/under/pt/marine
	allowed_roles = list("Executive Officer", "Chief Engineer", "Chief of Security", "Senior Enlisted Advisor",
						"Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Deck Officer",
						"Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/uniform/ecutility
	display_name = "(EC) Utility Uniform"
	description = "Utility Uniform of the SCG Expeditionary Corps"
	path = /obj/item/clothing/under/utility/expeditionary
	allowed_roles = list("Commanding Officer", "Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Senior Enlisted Advisor",
						"Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Senior Physician", "Physician", "Deck Officer",
						"Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/uniform/ecmedutility
	display_name = "(EC) Medical Utility Uniform"
	description = "Utility Uniform of the SCG Expeditionary Corps"
	path = /obj/item/clothing/under/utility/expeditionary/medical
	allowed_roles = list("Senior Physician", "Physician")

/datum/gear/uniform/ecmedcomutility
	display_name = "(EC) Medical Command Utility Uniform"
	description = "Utility Uniform of the SCG Expeditionary Corps"
	path = /obj/item/clothing/under/utility/expeditionary/medical/command
	allowed_roles = list("Chief Medical Officer")

/datum/gear/uniform/ecengutility
	display_name = "(EC) Engineering Utility Uniform"
	description = "Utility Uniform of the SCG Expeditionary Corps"
	path = /obj/item/clothing/under/utility/expeditionary/engineering
	allowed_roles = list("Senior Engineer", "Engineer")

/datum/gear/uniform/ecengutility
	display_name = "(EC) Engineering Command Utility Uniform"
	description = "Utility Uniform of the SCG Expeditionary Corps"
	path = /obj/item/clothing/under/utility/expeditionary/engineering/command
	allowed_roles = list("Chief Engineer")

/datum/gear/uniform/ecsuputility
	display_name = "(EC) Supply Utility Uniform"
	description = "Utility Uniform of the SCG Expeditionary Corps"
	path = /obj/item/clothing/under/utility/expeditionary/supply
	allowed_roles = list("Deck Officer", "Deck Technician")

/datum/gear/uniform/ecsecutility
	display_name = "(EC) Security Utility Uniform"
	description = "Utility Uniform of the SCG Expeditionary Corps"
	path = /obj/item/clothing/under/utility/expeditionary/security
	allowed_roles = list("Brig Officer", "Forensic Technician", "Master at Arms")

/datum/gear/uniform/ecseccomutility
	display_name = "(EC) Security Command Utility Uniform"
	description = "Utility Uniform of the SCG Expeditionary Corps"
	path = /obj/item/clothing/under/utility/expeditionary/security/command
	allowed_roles = list("Chief of Security")

/datum/gear/uniform/eccomutility
	display_name = "(EC) Command Utility Uniform"
	description = "Utility Uniform of the SCG Expeditionary Corps"
	path = /obj/item/clothing/under/utility/expeditionary/command
	allowed_roles = list("Commanding Officer", "Executive Officer", "Senior Enlisted Advisor")

/datum/gear/uniform/ecenlisteddress
	display_name = "(EC) Enlisted Dress Uniform"
	description = "Dress Uniform of the SCG Expeditionary Corps"
	path = /obj/item/clothing/under/mildress/expeditionary
	allowed_roles = list("Senior Enlisted Advisor", "Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Senior Physician",
						"Physician", "Deck Officer", "Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/uniform/ecofficerdress
	display_name = "(EC) Officer's Dress Uniform"
	description = "Dress Uniform of the SCG Expeditionary Corps"
	path = /obj/item/clothing/under/mildress/expeditionary/command
	allowed_roles = list("Commanding Officer", "Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Senior Physician", "Deck Officer")

/datum/gear/uniform/fleetutility
	display_name = "(FLEET) Coveralls"
	description = "Utility Uniform of the SCG Fleet"
	path = /obj/item/clothing/under/utility/fleet
	allowed_roles = list("Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Senior Enlisted Advisor",
						"Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Senior Physician", "Physician", "Deck Officer",
						"Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/uniform/fleetmedutility
	display_name = "(FLEET) Medical Coveralls"
	description = "Utility Uniform of the SCG Fleet"
	path = /obj/item/clothing/under/utility/fleet/medical
	allowed_roles = list("Chief Medical Officer", "Senior Physician", "Physician")

/datum/gear/uniform/fleetendutility
	display_name = "(FLEET) Engineering Coveralls"
	description = "Utility Uniform of the SCG Fleet"
	path = /obj/item/clothing/under/utility/fleet/engineering
	allowed_roles = list("Chief Engineer", "Senior Engineer", "Engineer")

/datum/gear/uniform/fleetsuputility
	display_name = "(FLEET) Supply Coveralls"
	description = "Utility Uniform of the SCG Fleet"
	path = /obj/item/clothing/under/utility/fleet/supply
	allowed_roles = list("Deck Officer", "Deck Technician")

/datum/gear/uniform/fleetsecutility
	display_name = "(FLEET) Security Coveralls"
	description = "Utility Uniform of the SCG Fleet"
	path = /obj/item/clothing/under/utility/fleet/security
	allowed_roles = list("Chief of Security", "Brig Officer", "Forensic Technician")

/datum/gear/uniform/fleetcomutility
	display_name = "(FLEET) Command Coveralls"
	description = "Utility Uniform of the SCG Fleet"
	path = /obj/item/clothing/under/utility/fleet/command
	allowed_roles = list("Executive Officer", "Senior Enlisted Advisor")

/datum/gear/uniform/fleetservice
	display_name = "(FLEET) Service Uniform"
	description = "Service Uniform of the SCG Fleet"
	path = /obj/item/clothing/under/service/fleet
	allowed_roles = list("Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Senior Enlisted Advisor",
						"Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Senior Physician", "Physician", "Deck Officer",
						"Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/uniform/marineutility
	display_name = "(MARINE) Fatigues"
	description = "Utility Uniform of the SCG Marine Corps"
	path = /obj/item/clothing/under/utility/marine
	allowed_roles = list("Executive Officer", "Chief Engineer", "Chief of Security", "Senior Enlisted Advisor",
						"Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Deck Officer",
						"Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/uniform/marinegreenutility
	display_name = "(MARINE) Green Fatigues"
	description = "Utility Uniform of the SCG Marine Corps"
	path = /obj/item/clothing/under/utility/marine/green
	allowed_roles = list("Executive Officer", "Chief Engineer", "Chief of Security", "Senior Enlisted Advisor",
						"Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Deck Officer",
						"Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/uniform/marinetanutility
	display_name = "(MARINE) Tan Fatigues"
	description = "Utility Uniform of the SCG Marine Corps"
	path = /obj/item/clothing/under/utility/marine/tan
	allowed_roles = list("Executive Officer", "Chief Engineer", "Chief of Security", "Senior Enlisted Advisor",
						"Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Deck Officer",
						"Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/uniform/marineengutility
	display_name = "(MARINE) Engineering Fatigues"
	description = "Utility Uniform of the SCG Marine Corps"
	path = /obj/item/clothing/under/utility/marine/engineering
	allowed_roles = list("Chief Engineer", "Senior Engineer", "Engineer")

/datum/gear/uniform/marinesuputility
	display_name = "(MARINE) Supply Fatigues"
	description = "Utility Uniform of the SCG Marine Corps"
	path = /obj/item/clothing/under/utility/marine/supply
	allowed_roles = list("Deck Officer", "Deck Technician")

/datum/gear/uniform/marinesecutility
	display_name = "(MARINE) Security Fatigues"
	description = "Utility Uniform of the SCG Marine Corps"
	path = /obj/item/clothing/under/utility/marine/security
	allowed_roles = list("Chief of Security", "Brig Officer", "Forensic Technician")

/datum/gear/uniform/marinecomutility
	display_name = "(MARINE) Command Fatigues"
	description = "Utility Uniform of the SCG Marine Corps"
	path = /obj/item/clothing/under/utility/marine/command
	allowed_roles = list("Executive Officer", "Senior Enlisted Advisor")

/datum/gear/uniform/marineenlistedservice
	display_name = "(MARINE) Enlisted Service Uniform"
	description = "Service Uniform of the SCG Marine Corps"
	path = /obj/item/clothing/under/service/marine
	allowed_roles = list("Senior Enlisted Advisor", "Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms",
						"Deck Officer", "Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/uniform/marineofficerservice
	display_name = "(MARINE) Officer's Service Uniform"
	description = "Service Uniform of the SCG Marine Corps"
	path = /obj/item/clothing/under/service/marine/command
	allowed_roles = list("Executive Officer", "Chief Engineer", "Chief of Security", "Deck Officer")

/datum/gear/uniform/marineenlisteddress
	display_name = "(MARINE) Enlisted Dress Uniform"
	description = "Dress Uniform of the SCG Marine Corps"
	path = /obj/item/clothing/under/mildress/marine
	allowed_roles = list("Senior Enlisted Advisor", "Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms",
						"Deck Officer", "Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/uniform/marineofficerdress
	display_name = "(MARINE) Officer's Dress Uniform"
	description = "Dress Uniform of the SCG Marine Corps"
	path = /obj/item/clothing/under/mildress/marine/command
	allowed_roles = list("Executive Officer", "Chief Engineer", "Chief of Security", "Deck Officer")