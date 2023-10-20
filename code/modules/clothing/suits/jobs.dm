/*
 * Job related
 */

//Botanist
/obj/item/clothing/suit/apron
	name = "apron"
	desc = "A basic blue apron."
	icon_state = "apron"
	item_state = "apron"
	blood_overlay_type = "armor"
	body_parts_covered = 0
	species_restricted = null
	allowed = list (
		/obj/item/reagent_containers/spray/plantbgone,
		/obj/item/device/scanner/plant,
		/obj/item/seeds,
		/obj/item/reagent_containers/glass/bottle,
		/obj/item/material/minihoe
		)

//Captain
/obj/item/clothing/suit/captunic
	name = "captain's parade tunic"
	desc = "Worn by a Captain to show their class."
	icon_state = "captunic"
	body_parts_covered = UPPER_TORSO|ARMS
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/captunic/capjacket
	name = "captain's uniform jacket"
	desc = "A less formal jacket for everyday captain use."
	icon_state = "capjacket"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv = 0

//Chaplain
/obj/item/clothing/suit/chaplain_hoodie
	name = "chaplain hoodie"
	desc = "This suit says to you 'hush'!"
	icon_state = "chaplain_hoodie"
	body_parts_covered = UPPER_TORSO|ARMS

//Chaplain
/obj/item/clothing/suit/nun
	name = "nun robe"
	desc = "Maximum piety in this star system."
	icon_state = "nun"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv = HIDESHOES|HIDEJUMPSUIT

//Chef
/obj/item/clothing/suit/chef
	name = "chef's apron"
	desc = "An apron used by a high class chef."
	icon_state = "chef"
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	allowed = list (
		/obj/item/material/knife
		)

//Chef
/obj/item/clothing/suit/chef/classic
	name = "classic chef's apron"
	desc = "A basic, dull, white chef's apron."
	icon_state = "apronchef"
	species_restricted = null
	blood_overlay_type = "armor"
	body_parts_covered = 0

//Security
/obj/item/clothing/suit/security/navyofficer
	name = "security officer's jacket"
	desc = "This jacket is for those special occasions when a security officer actually feels safe."
	icon_state = "officerbluejacket"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/suit/security/navywarden
	name = "warden's jacket"
	desc = "Perfectly suited for the warden that wants to leave an impression of style on those who visit the brig."
	icon_state = "wardenbluejacket"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/suit/security/navyhos
	name = "head of security's jacket"
	desc = "This piece of clothing was specifically designed for asserting superior authority."
	icon_state = "hosbluejacket"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

//Detective
/obj/item/clothing/suit/storage/det_trench
	name = "brown trenchcoat"
	desc = "A rugged canvas trenchcoat, designed and created by TX Fabrication Corp. The coat is externally impact resistant - perfect for your next act of autodefenestration!"
	icon_state = "detective"
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS
	allowed = list(
		/obj/item/storage/fancy/smokable,
		/obj/item/flame/lighter
	)
	singleton/shared_list/path/storage = list(/singleton/shared_list/path/storage/emergency, /singleton/shared_list/path/storage/bureaucracy,  /singleton/shared_list/path/storage/security, /singleton/shared_list/path/storage/combat)
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR
		)

/obj/item/clothing/suit/storage/det_trench/ft
	desc = "A rugged canvas trenchcoat, designed and created by TX Fabrication Corp. This one wouldn't block much of anything."
	armor = null

/obj/item/clothing/suit/storage/det_trench/grey
	name = "grey trenchcoat"
	icon_state = "detective2"

//Forensics
/obj/item/clothing/suit/storage/forensics
	name = "jacket"
	desc = "A forensics technician jacket."
	body_parts_covered = UPPER_TORSO|ARMS
	singleton/shared_list/path/storage = list(/singleton/shared_list/path/storage/emergency, /singleton/shared_list/path/storage/bureaucracy,  /singleton/shared_list/path/storage/security, /singleton/shared_list/path/storage/combat)
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR
		)

/obj/item/clothing/suit/storage/forensics/red
	name = "red jacket"
	desc = "A red forensics technician jacket."
	icon_state = "forensics_red"

/obj/item/clothing/suit/storage/forensics/blue
	name = "blue jacket"
	desc = "A blue forensics technician jacket."
	icon_state = "forensics_blue"

//Engineering
/obj/item/clothing/suit/storage/hazardvest
	name = "hazard vest"
	desc = "A high-visibility vest used in work zones."
	icon_state = "hazard"
	blood_overlay_type = "armor"
	species_restricted = null
	allowed = list (
		/obj/item/clothing/mask/gas
		)
	singleton/shared_list/path/storage = list(/singleton/shared_list/path/storage/emergency, /singleton/shared_list/path/storage/engineering)
	body_parts_covered = UPPER_TORSO
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)

/obj/item/clothing/suit/storage/hazardvest/blue
	name = "blue hazard vest"
	desc = "A high-visibility vest used in work zones. This one is blue!"
	icon_state = "hazard_b"

/obj/item/clothing/suit/storage/hazardvest/white
	name = "white hazard vest"
	desc = "A high-visibility vest used in work zones. This one is white!"
	icon_state = "hazard_w"

/obj/item/clothing/suit/storage/hazardvest/green
	name = "green hazard vest"
	desc = "A high-visibility vest used in work zones. This one is green!"
	icon_state = "hazard_g"

/obj/item/clothing/suit/storage/hazardvest/yellow
	name = "yellow hazard vest"
	desc = "A high-visibility vest used in work zones. This one is yellow!"
	icon_state = "hazard_y"

/obj/item/clothing/suit/storage/hazardvest/red
	name = "red hazard vest"
	desc = "A high-visibility vest used in work zones. This one is red!"
	icon_state = "hazard_r"

/obj/item/clothing/suit/storage/hazardvest/purple
	name = "purple hazard vest"
	desc = "A high-visibility vest used in work zones. This one is purple!"
	icon_state = "hazard_p"

/obj/item/clothing/suit/storage/hazardvest/med
	name = "medical hazard vest"
	desc = "A high-visibility vest used in work zones. This one is has a blue cross!"
	icon_state = "hazard_med"
	singleton/shared_list/path/storage = list(/singleton/shared_list/path/storage/emergency, /singleton/shared_list/path/storage/medical)

/obj/item/clothing/suit/storage/toggle/highvis
	name = "high visibility jacket"
	desc = "A loose-fitting, high visibility jacket to help crew be recognizable in high traffic areas with large industrial equipment. Don't catch the Charon's landing gear with your teeth!"
	icon_state = "highvis"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)

//Lawyer
/obj/item/clothing/suit/storage/toggle/suit
	name = "suit jacket"
	desc = "A snappy dress jacket."
	icon_state = "suitjacket"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)
	singleton/shared_list/path/storage = list(/singleton/shared_list/path/storage/emergency, /singleton/shared_list/path/storage/bureaucracy)

/obj/item/clothing/suit/storage/toggle/suit_double
	name = "double-breasted suit jacket"
	desc = "A snappy, double-breasted dress jacket."
	icon_state = "suitjacket_double"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)
	singleton/shared_list/path/storage = list(/singleton/shared_list/path/storage/emergency, /singleton/shared_list/path/storage/bureaucracy)

/obj/item/clothing/suit/storage/toggle/suit/blue
	name = "blue suit jacket"
	color = "#00326e"

/obj/item/clothing/suit/storage/toggle/suit/purple
	name = "purple suit jacket"
	color = "#6c316c"

/obj/item/clothing/suit/storage/toggle/suit/black
	name = "black suit jacket"
	color = "#1f1f1f"

//Medical
/obj/item/clothing/suit/storage/toggle/fr_jacket
	name = "first responder jacket"
	desc = "A high-visibility jacket worn by medical first responders."
	icon_state = "fr_jacket"
	blood_overlay_type = "armor"
	singleton/shared_list/path/storage = list(/singleton/shared_list/path/storage/emergency, /singleton/shared_list/path/storage/medical)
	body_parts_covered = UPPER_TORSO|ARMS
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)

/obj/item/clothing/suit/storage/toggle/fr_jacket/ems
	name = "\improper EMS jacket"
	desc = "A dark blue, martian-pattern, EMS jacket. It sports high-visibility reflective stripes and a star of life on the back."
	icon_state = "ems_jacket"

/obj/item/clothing/suit/storage/toggle/fr_jacket/emrs
	name = "medical jacket"
	desc = "A white jacket often worn in emergency medical and reanimation services across human space."
	icon_state = "medical_jacket"

/obj/item/clothing/suit/storage/security_chest_rig
	name = "chest-rig"
	desc = "A grey chest-rig with black pouches. For when you wish you had more hands."
	icon_state = "chest-rig"
	blood_overlay_type = "armor"
	allowed = list(
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/head/hardhat
	)
	singleton/shared_list/path/storage = list(/singleton/shared_list/path/storage/emergency, /singleton/shared_list/path/storage/security)

	body_parts_covered = UPPER_TORSO

/obj/item/clothing/suit/storage/engineering_chest_rig
	name = "hazard chest-rig"
	desc = "A grey chest-rig with black pouches and orange markings worn by engineers. It has an 'Engineer' tag on its chest."
	icon_state = "engi-chest-rig"
	blood_overlay_type = "armor"
	allowed = list (
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/head/hardhat
	)
	singleton/shared_list/path/storage = list(/singleton/shared_list/path/storage/emergency, /singleton/shared_list/path/storage/engineering)

/obj/item/clothing/suit/storage/medical_chest_rig
	name = "\improper MT chest-rig"
	desc = "A white chest-rig with black pouches worn by medical first responders. It has a 'Medic' tag on its chest."
	icon_state = "med-chest-rig"
	blood_overlay_type = "armor"
	allowed = list(
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/head/hardhat,
	)
	singleton/shared_list/path/storage = list(/singleton/shared_list/path/storage/emergency, /singleton/shared_list/path/storage/medical)

/obj/item/clothing/suit/surgicalapron
	name = "surgical apron"
	desc = "A sterile blue apron for performing surgery."
	icon_state = "surgical"
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	allowed = list(
		/obj/item/storage/firstaid/surgery,
		/obj/item/bonesetter,
		/obj/item/cautery,
		/obj/item/circular_saw,
		/obj/item/hemostat,
		/obj/item/retractor,
		/obj/item/scalpel,
		/obj/item/surgicaldrill,
		/obj/item/bonegel,
		/obj/item/FixOVein,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/nanopaste,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/head/surgery,
		/obj/item/clothing/gloves/latex,
		/obj/item/reagent_containers/dropper
	)
	singleton/shared_list/path/storage = list(/singleton/shared_list/path/storage/emergency, /singleton/shared_list/path/storage/medical)
