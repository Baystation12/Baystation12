/datum/gear/accessory
	display_name = "locket"
	path = /obj/item/clothing/accessory/locket
	slot = slot_tie
	sort_category = "Accessories"

/datum/gear/accessory/vest
	display_name = "black vest"
	path = /obj/item/clothing/accessory/toggleable/vest
	allowed_roles = list("NanoTrasen Liaison", "SolGov Representative", "Passenger", "Bartender", "Merchant")

/datum/gear/accessory/suspenders
	display_name = "suspenders"
	path = /obj/item/clothing/accessory/suspenders
	allowed_roles = list("Research Director", "NanoTrasen Liaison", "Scientist", "Prospector", "Research Assistant",
						"SolGov Representative", "Passenger", "Maintenance Assistant", "Roboticist""Supply Assistant", "Bartender", "Merchant")

/datum/gear/accessory/wcoat
	display_name = "waistcoat"
	path = /obj/item/clothing/accessory/wcoat
	allowed_roles = list("NanoTrasen Liaison", "SolGov Representative", "Passenger", "Bartender", "Merchant")

/datum/gear/accessory/necklace
	display_name = "necklace"
	path = /obj/item/clothing/accessory/necklace
	flags = GEAR_HAS_COLOR_SELECTION

//have to break up armbands to restrict access
/datum/gear/accessory/armband_security
	display_name = "security armband"
	path = /obj/item/clothing/accessory/armband
	allowed_roles = list("Chief of Security", "Brig Officer", "Forensic Technician", "Master at Arms")

/datum/gear/accessory/armband_cargo
	display_name = "cargo armband"
	path = /obj/item/clothing/accessory/armband/cargo
	allowed_roles = list("Deck Officer", "Deck Technician", "Supply Assistant")

/datum/gear/accessory/armband_medical
	display_name = "medical armband"
	path = /obj/item/clothing/accessory/armband/med
	allowed_roles = list("Chief Medical Officer", "Senior Physician", "Physician", "Medical Assistant", "Virologist", "Chemist", "Counselor")

/datum/gear/accessory/armband_emt
	display_name = "EMT armband"
	path = /obj/item/clothing/accessory/armband/medgreen
	allowed_roles = list("Physician", "Medical Assistant")

/datum/gear/accessory/armband_corpsman
	display_name = "medical corps armband"
	path = /obj/item/clothing/accessory/armband/medblue
	allowed_roles = list("Chief Medical Officer", "Senior Physician", "Physician")

/datum/gear/accessory/armband_engineering
	display_name = "engineering armband"
	path = /obj/item/clothing/accessory/armband/engine
	allowed_roles = list("Chief Engineer", "Senior Engineer", "Engineer", "Maintenance Assistant", "Roboticist")

/datum/gear/accessory/armband_hydro
	display_name = "hydroponics armband"
	path = /obj/item/clothing/accessory/armband/hydro
	allowed_roles = list("Research Director", "Scientist", "Research Assistant", "Passenger")

/datum/gear/accessory/armband_science
	display_name = "science armband"
	path = /obj/item/clothing/accessory/armband/science
	allowed_roles = list("Research Director", "NanoTrasen Liaison", "Scientist", "Prospector", "Security Guard", "Research Assistant",
						"Passenger", "Roboticist", "Virologist")

/datum/gear/accessory/armband_nt
	display_name = "NanoTrasen armband"
	path = /obj/item/clothing/accessory/armband/redwhite
	allowed_roles = list("Research Director", "NanoTrasen Liaison", "Scientist", "Prospector", "Security Guard", "Research Assistant")

/datum/gear/accessory/armband_solgov
	display_name = "peacekeeper armband"
	path = /obj/item/clothing/accessory/armband/bluegold
	allowed_roles = list("Commanding Officer", "Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Senior Enlisted Advisor",
						"Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Senior Physician", "Physician", "Deck Officer",
						"Deck Technician", "Sanitation Technician", "Cook", "Crewman", "SolGov Representative")

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
	allowed_roles = list("Commanding Officer", "Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Senior Enlisted Advisor",
						"Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Senior Physician", "Physician", "Deck Officer",
						"Deck Technician", "Sanitation Technician", "Cook", "Crewman", "Security Guard", "Merchant")

/datum/gear/accessory/holster/New()
	..()
	gear_tweaks += new/datum/gear_tweak/path(/obj/item/clothing/accessory/holster)

/datum/gear/accessory/tie
	display_name = "tie selection"
	path = /obj/item/clothing/accessory

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
	allowed_roles = list("Chief Medical Officer", "Senior Physician", "Physician", "Medical Assistant", "Virologist", "Chemist", "Counselor"
						"Research Director", "Scientist", "Research Assistant")

/datum/gear/accessory/brown_vest
	display_name = "webbing, engineering"
	path = /obj/item/clothing/accessory/storage/brown_vest
	cost = 3
	allowed_roles = list("Chief Engineer", "Senior Engineer", "Engineer", "Maintenance Assistant", "Roboticist", "Deck Officer", "Deck Technician",
						"Supply Assistant", "Prospector", "Sanitation Technician", "Research Assistant", "Merchant")

/datum/gear/accessory/black_vest
	display_name = "webbing, security"
	path = /obj/item/clothing/accessory/storage/black_vest
	cost = 3
	allowed_roles = list("Chief of Security", "Brig Officer", "Forensic Technician", "Master at Arms", "Security Guard", "Merchant")

/datum/gear/accessory/white_vest
	display_name = "webbing, medical"
	path = /obj/item/clothing/accessory/storage/white_vest
	cost = 3
	allowed_roles = list("Chief Medical Officer", "Senior Physician", "Physician", "Medical Assistant", "Merchant")

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
	allowed_roles = list("Passenger", "Bartender")

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
	allowed_roles = list("Passenger", "Bartender")

/datum/gear/accessory/solawardmajor
	display_name = "SolGov major award selection"
	description = "A medal or ribbon awarded to SolGov personnel for significant accomplishments."
	path = /obj/item/clothing/medal/iron/star
	cost = 8
	allowed_roles = list("Commanding Officer", "Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Senior Enlisted Advisor",
						"Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Senior Physician", "Physician", "Deck Officer",
						"Deck Technician", "Sanitation Technician", "Cook", "Crewman")

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
	path = /obj/item/clothing/medal/iron/sol
	cost = 5
	allowed_roles = list("Commanding Officer", "Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Senior Enlisted Advisor",
						"Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Senior Physician", "Physician", "Deck Officer",
						"Deck Technician", "Sanitation Technician", "Cook", "Crewman")

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
	path = /obj/item/clothing/medal/bronze/nanotrasen
	cost = 8
	allowed_roles = list("Research Director", "NanoTrasen Liaison")

/datum/gear/accessory/ntaward/New()
	..()
	var/ntawards = list()
	ntawards["sciences medal"] = /obj/item/clothing/accessory/medal/bronze/nanotrasen
	ntawards["nanotrasen service"] = /obj/item/clothing/accessory/medal/silver/nanotrasen
	ntawards["command medal"] = /obj/item/clothing/accessory/medal/gold/nanotrasen
	gear_tweaks += new/datum/gear_tweak/path(ntawards)



/datum/gear/accessory/specialty/janitor
	display_name = "(FLEET)Janitor Speciality Blaze"
	description = "A pair of colored pins denoting a job specialization. For use on the SCG Fleet utility uniform."
	path = /obj/item/clothing/accessory/specialty/janitor
	cost = 0
	allowed_roles = list("Sanitation Technician")

/datum/gear/accessory/specialty/brig
	display_name = "(FLEET)Brig Speciality Blaze"
	description = "A pair of colored pins denoting a job specialization. For use on the SCG Fleet utility uniform."
	path = /obj/item/clothing/accessory/specialty/brig
	cost = 0
	allowed_roles = list("Brig Officer")

/datum/gear/accessory/specialty/forensic
	display_name = "(FLEET)Forensics Speciality Blaze"
	description = "A pair of colored pins denoting a job specialization. For use on the SCG Fleet utility uniform."
	path = /obj/item/clothing/accessory/specialty/forensic
	cost = 0
	allowed_roles = list("Forensic Technician")

/datum/gear/accessory/specialty/atmos
	display_name = "(FLEET)Atmospherics Speciality Blaze"
	description = "A pair of colored pins denoting a job specialization. For use on the SCG Fleet utility uniform."
	path = /obj/item/clothing/accessory/specialty/atmos
	cost = 0
	allowed_roles = list("Engineer")

/datum/gear/accessory/specialty/enlisted
	display_name = "(FLEET)Enlisted Qualification Pin"
	description = "An ornate crest denoting enlisted job specialization. For use on the SCG Fleet utility uniform."
	path = /obj/item/clothing/accessory/specialty/enlisted
	cost = 0
	allowed_roles = list("Senior Enlisted Advisor", "Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Senior Physician",
						"Physician", "Deck Officer", "Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/accessory/specialty/officer
	display_name = "(FLEET)Officer Qualification Pin"
	description = "An ornate crest denoting commissioned job specialization. For use on the SCG Fleet utility uniform."
	path = /obj/item/clothing/accessory/specialty/officer
	cost = 0
	allowed_roles = list("Commanding Officer", "Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Senior Physician", "Deck Officer")

/datum/gear/accessory/rank/shouldere2
	display_name = "(EXPEDITIONARY/FLEET) Crewman Apprentice Ranks"
	description = "A pair of rank shoulderboards for use on SCG Expeditionary Corps or Fleet uniforms."
	path = /obj/item/clothing/accessory/rank/fleet/enlisted/e2
	cost = 0
	allowed_roles = list("Master at Arms", "Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/accessory/rank/shouldere3
	display_name = "(EXPEDITIONARY/FLEET) Crewman Ranks"
	description = "A pair of rank shoulderboards for use on SCG Expeditionary Corps or Fleet uniforms."
	path = /obj/item/clothing/accessory/rank/fleet/enlisted/e3
	cost = 0
	allowed_roles = list("Engineer", "Master at Arms", "Forensic Technician", "Physician", "Deck Technician", "Sanitation Technician", "Cook")

/datum/gear/accessory/rank/shouldere4
	display_name = "(EXPEDITIONARY/FLEET) Petty Officer 3rd Class Ranks"
	description = "A pair of rank shoulderboards for use on SCG Expeditionary Corps or Fleet uniforms."
	path = /obj/item/clothing/accessory/rank/fleet/enlisted/e4
	cost = 0
	allowed_roles = list("Engineer", "Master at Arms", "Forensic Technician", "Physician")

/datum/gear/accessory/rank/shouldere5
	display_name = "(EXPEDITIONARY/FLEET) Petty Officer 2nd Class Ranks"
	description = "A pair of rank shoulderboards for use on SCG Expeditionary Corps or Fleet uniforms."
	path = /obj/item/clothing/accessory/rank/fleet/enlisted/e5
	cost = 0
	allowed_roles = list("Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Physician", "Deck Officer")

/datum/gear/accessory/rank/shouldere6
	display_name = "(EXPEDITIONARY/FLEET) Petty Officer 1st Class Ranks"
	description = "A pair of rank shoulderboards for use on SCG Expeditionary Corps or Fleet uniforms."
	path = /obj/item/clothing/accessory/rank/fleet/enlisted/e6
	cost = 0
	allowed_roles = list("Senior Engineer", "Brig Officer", "Senior Physician", "Deck Officer")

/datum/gear/accessory/rank/shouldere7
	display_name = "(EXPEDITIONARY/FLEET) Chief Petty Officer Ranks"
	description = "A pair of rank shoulderboards for use on SCG Expeditionary Corps or Fleet uniforms."
	path = /obj/item/clothing/accessory/rank/fleet/enlisted/e7
	cost = 0
	allowed_roles = list("Senior Engineer", "Brig Officer", "Senior Physician", "Deck Officer")

/datum/gear/accessory/rank/shouldere8
	display_name = "(EXPEDITIONARY/FLEET) Senior Chief Petty Officer Ranks"
	description = "A pair of rank shoulderboards for use on SCG Expeditionary Corps or Fleet uniforms."
	path = /obj/item/clothing/accessory/rank/fleet/enlisted/e8
	cost = 0
	allowed_roles = list("Senior Enlisted Advisor", "Senior Engineer", "Brig Officer", "Senior Physician")

/datum/gear/accessory/rank/shouldere9
	display_name = "(EXPEDITIONARY/FLEET) Master Chief Petty Officer Ranks"
	description = "A pair of rank shoulderboards for use on SCG Expeditionary Corps or Fleet uniforms."
	path = /obj/item/clothing/accessory/rank/fleet/enlisted/e9
	cost = 0
	allowed_roles = list("Senior Enlisted Advisor")

/datum/gear/accessory/rank/shouldero1
	display_name = "(EXPEDITIONARY/FLEET) Ensign Ranks"
	description = "A pair of rank shoulderboards for use on SCG Expeditionary Corps or Fleet uniforms."
	path = /obj/item/clothing/accessory/rank/fleet/officer
	cost = 0
	allowed_roles = list("Chief Engineer", "Chief of Security", "Senior Physician","Deck Officer")

/datum/gear/accessory/rank/shouldero2
	display_name = "(EXPEDITIONARY/FLEET) Lieutenant (JG) Ranks"
	description = "A pair of rank shoulderboards for use on SCG Expeditionary Corps or Fleet uniforms."
	path = /obj/item/clothing/accessory/rank/fleet/officer/o2
	cost = 0
	allowed_roles = list("Chief Engineer", "Chief of Security", "Senior Physician")

/datum/gear/accessory/rank/shouldero3
	display_name = "(EXPEDITIONARY/FLEET) :Lieutenant Ranks"
	description = "A pair of rank shoulderboards for use on SCG Expeditionary Corps or Fleet uniforms."
	path = /obj/item/clothing/accessory/rank/fleet/officer/o3
	cost = 0
	allowed_roles = list("Chief Medical Officer", "Chief Engineer", "Chief of Security")

/datum/gear/accessory/rank/shouldero4
	display_name = "(EXPEDITIONARY/FLEET) Lieutenant Commander Ranks"
	description = "A pair of rank shoulderboards for use on SCG Expeditionary Corps or Fleet uniforms."
	path = /obj/item/clothing/accessory/rank/fleet/officer/o4
	cost = 0
	allowed_roles = list("Executive Officer", "Chief Medical Officer")

/datum/gear/accessory/rank/shouldero5
	display_name = "(EXPEDITIONARY/FLEET) Commander Ranks"
	description = "A pair of rank shoulderboards for use on SCG Expeditionary Corps or Fleet uniforms."
	path = /obj/item/clothing/accessory/rank/fleet/officer/o5
	cost = 0
	allowed_roles = list("Executive Officer")

/datum/gear/accessory/rank/shouldero6
	display_name = "(EXPEDITIONARY) Captain Ranks"
	description = "A pair of rank shoulderboards for use on SCG Expeditionary Corps or Fleet uniforms."
	path = /obj/item/clothing/accessory/rank/fleet/officer/o6
	cost = 0
	allowed_roles = list("Commanding Officer")

/datum/gear/accessory/rank/mare2
	display_name = "(MARINE) Private First Class Ranks"
	description = "A pair of rank pins for use on SCG Marine Corps uniforms."
	path = /obj/item/clothing/accessory/rank/marine/enlisted/e2
	cost = 0
	allowed_roles = list("Master at Arms", "Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/accessory/rank/mare3
	display_name = "(MARINE) Lance Corporal Ranks"
	description = "A pair of rank pins for use on SCG Marine Corps uniforms."
	path = /obj/item/clothing/accessory/rank/marine/enlisted/e3
	cost = 0
	allowed_roles = list("Engineer", "Master at Arms", "Forensic Technician", "Physician", "Deck Technician", "Sanitation Technician", "Cook")

/datum/gear/accessory/rank/mare4
	display_name = "(MARINE) Corporal Ranks"
	description = "A pair of rank pins for use on SCG Marine Corps uniforms."
	path = /obj/item/clothing/accessory/rank/marine/enlisted/e4
	cost = 0
	allowed_roles = list("Engineer", "Master at Arms", "Forensic Technician")

/datum/gear/accessory/rank/mare5
	display_name = "(MARINE) Sergeant Ranks"
	description = "A pair of rank pins for use on SCG Marine Corps uniforms."
	path = /obj/item/clothing/accessory/rank/marine/enlisted/e5
	cost = 0
	allowed_roles = list("Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Deck Officer")

/datum/gear/accessory/rank/mare6
	display_name = "(MARINE) Staff Sergeant Ranks"
	description = "A pair of rank pins for use on SCG Marine Corps uniforms."
	path = /obj/item/clothing/accessory/rank/marine/enlisted/e6
	cost = 0
	allowed_roles = list("Senior Engineer", "Brig Officer", "Deck Officer")

/datum/gear/accessory/rank/mare7
	display_name = "(MARINE) Gunnery Sergeant Ranks"
	description = "A pair of rank pins for use on SCG Marine Corps uniforms."
	path = /obj/item/clothing/accessory/rank/marine/enlisted/e7
	cost = 0
	allowed_roles = list("Senior Engineer", "Brig Officer", "Deck Officer")

/datum/gear/accessory/rank/mare8
	display_name = "(MARINE) First Sergeant Ranks"
	description = "A pair of rank pins for use on SCG Marine Corps uniforms."
	path = /obj/item/clothing/accessory/rank/marine/enlisted/e8
	cost = 0
	allowed_roles = list("Senior Enlisted Advisor")

/datum/gear/accessory/rank/mare8alt
	display_name = "(MARINE) Master Sergeant Ranks"
	description = "A pair of rank pins for use on SCG Marine Corps uniforms."
	path = /obj/item/clothing/accessory/rank/marine/enlisted/e8alt
	cost = 0
	allowed_roles = list("Senior Enlisted Advisor", "Senior Engineer", "Brig Officer")

/datum/gear/accessory/rank/mare9
	display_name = "(MARINE) Sergeant Major Ranks"
	description = "A pair of rank pins for use on SCG Marine Corps uniforms."
	path = /obj/item/clothing/accessory/rank/marine/enlisted/e9
	cost = 0
	allowed_roles = list("Senior Enlisted Advisor")

/datum/gear/accessory/rank/maro1
	display_name = "(MARINE) 2nd Lieutenant Ranks"
	description = "A pair of rank pins for use on SCG Marine Corps uniforms."
	path = /obj/item/clothing/accessory/rank/marine/officer
	cost = 0
	allowed_roles = list("Chief Engineer", "Chief of Security", "Deck Officer")

/datum/gear/accessory/rank/maro2
	display_name = "(MARINE) 1st Lieutenant Ranks"
	description = "A pair of rank pins for use on SCG Marine Corps uniforms."
	path = /obj/item/clothing/accessory/rank/marine/officer/o2
	cost = 0
	allowed_roles = list("Chief Engineer", "Chief of Security")

/datum/gear/accessory/rank/maro3
	display_name = "(MARINE) Captain Ranks"
	description = "A pair of rank pins for use on SCG Marine Corps uniforms."
	path = /obj/item/clothing/accessory/rank/marine/officer/o3
	cost = 0
	allowed_roles = list("Chief Engineer", "Chief of Security")

/datum/gear/accessory/rank/maro4
	display_name = "(MARINE) Major Ranks"
	description = "A pair of rank pins for use on SCG Marine Corps uniforms."
	path = /obj/item/clothing/accessory/rank/marine/officer/o4
	cost = 0
	allowed_roles = list("Executive Officer")

/datum/gear/accessory/rank/maro5
	display_name = "(MARINE) Lieutenant Colonel Ranks"
	description = "A pair of rank pins for use on SCG Marine Corps uniforms."
	path = /obj/item/clothing/accessory/rank/marine/officer/o5
	cost = 0
	allowed_roles = list("Executive Officer")

/datum/gear/accessory/tags
	display_name = "dog tags"
	path = /obj/item/clothing/accessory/badge/tags
	cost = 0
	allowed_roles = list("Commanding Officer", "Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Senior Enlisted Advisor",
						"Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Senior Physician", "Physician", "Deck Officer",
						"Deck Technician", "Sanitation Technician", "Cook", "Crewman")

/datum/gear/accessory/kneepads
	display_name = "kneepads"
	path = /obj/item/clothing/accessory/kneepads

