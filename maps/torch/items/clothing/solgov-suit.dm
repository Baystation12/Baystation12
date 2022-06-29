/obj/item/clothing/suit/storage/solgov
	name = "master solgov jacket"
	icon = 'maps/torch/icons/obj/obj_suit_solgov.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/torch/icons/mob/onmob_suit_solgov.dmi')

//Service

/obj/item/clothing/suit/storage/solgov/service
	name = "service jacket"
	desc = "A uniform service jacket, plain and undecorated."
	icon_state = "blackservice"
	body_parts_covered = UPPER_TORSO|ARMS
	siemens_coefficient = 0.9
	allowed = list(
		/obj/item/tank/oxygen_emergency,
		/obj/item/tank/oxygen_emergency_extended,
		/obj/item/tank/nitrogen_emergency,
		/obj/item/device/flashlight,
		/obj/item/pen,
		/obj/item/clothing/head/soft,
		/obj/item/clothing/head/beret,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/flame/lighter,
		/obj/item/device/taperecorder,
		/obj/item/device/scanner/gas,
		/obj/item/device/radio,
		/obj/item/taperoll
	)
	valid_accessory_slots = list(
		ACCESSORY_SLOT_ARMBAND,
		ACCESSORY_SLOT_MEDAL,
		ACCESSORY_SLOT_INSIGNIA,
		ACCESSORY_SLOT_RANK,
		ACCESSORY_SLOT_DEPT,
		ACCESSORY_SLOT_DECOR
	)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

/obj/item/clothing/suit/storage/solgov/service/expeditionary
	name = "expeditionary jacket"
	desc = "A uniform service jacket belonging to the SCG Expeditionary Corps."
	icon_state = "ecservice_crew"

	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_suit_unathi.dmi'
	)

/obj/item/clothing/suit/storage/solgov/service/expeditionary/medical
	accessories = list(/obj/item/clothing/accessory/solgov/department/medical/service)

/obj/item/clothing/suit/storage/solgov/service/expeditionary/medical/command
	icon_state = "ecservice_officer"
	item_state = "ecservice_officer"

/obj/item/clothing/suit/storage/solgov/service/expeditionary/engineering
	accessories = list(/obj/item/clothing/accessory/solgov/department/engineering/service)

/obj/item/clothing/suit/storage/solgov/service/expeditionary/engineering/command
	icon_state = "ecservice_officer"
	item_state = "ecservice_officer"

/obj/item/clothing/suit/storage/solgov/service/expeditionary/supply
	accessories = list(/obj/item/clothing/accessory/solgov/department/supply/service)

/obj/item/clothing/suit/storage/solgov/service/expeditionary/security
	accessories = list(/obj/item/clothing/accessory/solgov/department/security/service)

/obj/item/clothing/suit/storage/solgov/service/expeditionary/security/command
	icon_state = "ecservice_officer"
	item_state = "ecservice_officer"

/obj/item/clothing/suit/storage/solgov/service/expeditionary/service
	accessories = list(/obj/item/clothing/accessory/solgov/department/service/service)

/obj/item/clothing/suit/storage/solgov/service/expeditionary/service/command
	icon_state = "ecservice_officer"
	item_state = "ecservice_officer"

/obj/item/clothing/suit/storage/solgov/service/expeditionary/exploration
	accessories = list(/obj/item/clothing/accessory/solgov/department/exploration/service)

/obj/item/clothing/suit/storage/solgov/service/expeditionary/exploration/command
	icon_state = "ecservice_officer"
	item_state = "ecservice_officer"

/obj/item/clothing/suit/storage/solgov/service/expeditionary/research
	accessories = list(/obj/item/clothing/accessory/solgov/department/research/service)

/obj/item/clothing/suit/storage/solgov/service/expeditionary/research/command
	icon_state = "ecservice_officer"
	item_state = "ecservice_officer"

/obj/item/clothing/suit/storage/solgov/service/expeditionary/command
	icon_state = "ecservice_officer"
	item_state = "ecservice_officer"
	accessories = list(/obj/item/clothing/accessory/solgov/department/command/service)

/obj/item/clothing/suit/storage/solgov/service/fleet
	name = "fleet service jacket"
	desc = "A navy blue SCG Fleet service jacket."
	icon_state = "blueservice"
	item_state = "blueservice"

/obj/item/clothing/suit/storage/solgov/service/fleet/snco
	name = "fleet SNCO service jacket"
	desc = "A navy blue SCG Fleet service jacket with silver cuffs."
	icon_state = "blueservice_snco"
	item_state = "blueservice_snco"

/obj/item/clothing/suit/storage/solgov/service/fleet/officer
	name = "fleet officer's service jacket"
	desc = "A navy blue SCG Fleet dress jacket with silver accents."
	icon_state = "blueservice_off"
	item_state = "blueservice_off"

/obj/item/clothing/suit/storage/solgov/service/fleet/command
	name = "fleet senior officer's service jacket"
	desc = "A navy blue SCG Fleet dress jacket with gold accents."
	icon_state = "blueservice_comm"
	item_state = "blueservice_comm"

/obj/item/clothing/suit/storage/solgov/service/fleet/flag
	name = "fleet flag officer's service jacket"
	desc = "A navy blue SCG Fleet dress jacket with red accents."
	icon_state = "blueservice_flag"
	item_state = "blueservice_flag"

/obj/item/clothing/suit/storage/solgov/utility/army
	name = "green marine jacket"
	desc = "An SCG Marine green utility jacket. Green and undecorated."
	icon_state = "greenservice"
	item_state = "greenservice"

/obj/item/clothing/suit/storage/solgov/utility/army/navy
	name = "navy marine jacket"
	desc = "An SCG Marine navy utility jacket. Blue and undecorated."
	icon_state = "navyservice"
	item_state = "navyservice"

/obj/item/clothing/suit/storage/solgov/utility/army/medical
	desc = "An SCG Marine green utility jacket. This one has blue markings."
	icon_state = "greenservice_med"
	item_state = "greenservice_med"

/obj/item/clothing/suit/storage/solgov/utility/army/navy/medical
	desc = "An SCG Marine navy utility jacket. This one has blue markings."
	icon_state = "navyservice_med"
	item_state = "navyservice_med"

/obj/item/clothing/suit/storage/solgov/utility/army/medical/command
	desc = "An SCG Marine green utility jacket. This one has blue and gold markings."
	icon_state = "greenservice_medcom"
	item_state = "greenservice_medcom"

/obj/item/clothing/suit/storage/solgov/utility/army/navy/medical/command
	desc = "An SCG Marine navy utility jacket. This one has blue and gold markings."
	icon_state = "navyservice_medcom"
	item_state = "navyservice_medcom"

/obj/item/clothing/suit/storage/solgov/utility/army/engineering
	desc = "An SCG Marine green utility jacket. This one has orange markings."
	icon_state = "greenservice_eng"
	item_state = "greenservice_eng"

/obj/item/clothing/suit/storage/solgov/utility/army/navy/engineering
	desc = "An SCG Marine navy utility jacket. This one has orange markings."
	icon_state = "navyservice_eng"
	item_state = "navyservice_eng"

/obj/item/clothing/suit/storage/solgov/utility/army/engineering/command
	desc = "An SCG Marine green utility jacket. This one has orange and gold markings."
	icon_state = "greenservice_engcom"
	item_state = "greenservice_engcom"

/obj/item/clothing/suit/storage/solgov/utility/army/navy/engineering/command
	desc = "An SCG Marine navy utility jacket. This one has orange and gold markings."
	icon_state = "navyservice_engcom"
	item_state = "navyservice_engcom"

/obj/item/clothing/suit/storage/solgov/utility/army/supply
	desc = "An SCG Marine green utility jacket. This one has brown markings."
	icon_state = "greenservice_sup"
	item_state = "greenservice_sup"

/obj/item/clothing/suit/storage/solgov/utility/army/navy/supply
	desc = "An SCG Marine navy utility jacket. This one has brown markings."
	icon_state = "navyservice_sup"
	item_state = "naveservice_sup"

/obj/item/clothing/suit/storage/solgov/utility/army/security
	desc = "An SCG Marine green utility jacket. This one has red markings."
	icon_state = "greenservice_sec"
	item_state = "greenservice_sec"

/obj/item/clothing/suit/storage/solgov/utility/army/navy/security
	desc = "An SCG Marine navy utility jacket. This one has red markings."
	icon_state = "navyservice_sec"
	item_state = "navyservice_sec"

/obj/item/clothing/suit/storage/solgov/utility/army/security/command
	desc = "An SCG Marine green utility jacket. This one has red and gold markings."
	icon_state = "greenservice_seccom"
	item_state = "greenservice_seccom"

/obj/item/clothing/suit/storage/solgov/utility/army/navy/security/command
	desc = "An SCG Marine navy utility jacket. This one has red and gold markings."
	icon_state = "navyservice_seccom"
	item_state = "navyservice_seccom"

/obj/item/clothing/suit/storage/solgov/utility/army/service
	desc = "An SCG Marine green utility jacket. This one has green markings."
	icon_state = "greenservice_srv"
	item_state = "greenservice_srv"

/obj/item/clothing/suit/storage/solgov/utility/navy/service
	desc = "An SCG Marine navy utility jacket. This one has green markings."
	icon_state = "navyservice_srv"
	item_state = "navyservice_srv"

/obj/item/clothing/suit/storage/solgov/utility/army/service/command
	desc = "An SCG Marine green utility jacket. This one has green and gold markings."
	icon_state = "greenservice_srvcom"
	item_state = "greenservice_srvcom"

/obj/item/clothing/suit/storage/solgov/utility/army/navy/service/command
	desc = "An SCG Marine navy utility jacket. This one has green and gold markings."
	icon_state = "navyservice_srvcom"
	item_state = "navyservice_srvcom"

/obj/item/clothing/suit/storage/solgov/utility/army/exploration
	desc = "An SCG Marine green utility jacket. This one has purple markings."
	icon_state = "greenservice_exp"
	item_state = "greenservice_exp"

/obj/item/clothing/suit/storage/solgov/utility/army/navy/exploration
	desc = "An SCG Marine navy utility jacket. This one has purple markings."
	icon_state = "navyservice_exp"
	item_state = "navyservice_exp"

/obj/item/clothing/suit/storage/solgov/utility/army/exploration/command
	desc = "An SCG Marine green utility jacket. This one has purple and gold markings."
	icon_state = "greenservice_expcom"
	item_state = "greenservice_expcom"

/obj/item/clothing/suit/storage/solgov/utility/army/navy/exploration/command
	desc = "An SCG Marine navy utility jacket. This one has purple and gold markings."
	icon_state = "navyservice_expcom"
	item_state = "navyservice_expcom"

/obj/item/clothing/suit/storage/solgov/utility/army/command
	desc = "An SCG Marine Corps green utility jacket. This one has gold markings."
	icon_state = "greenservice_com"
	item_state = "greenservice_com"

/obj/item/clothing/suit/storage/solgov/utility/army/navy/command
	desc = "An SCG Marine Corps navy utility jacket. This one has gold markings."
	icon_state = "navyservice_com"
	item_state = "navyservice_com"

//Dress - murder me with a gun why are these 3 different types

/obj/item/clothing/suit/storage/solgov/dress
	name = "dress jacket"
	desc = "A uniform dress jacket, plain and undecorated."
	icon_state = "ecdress_xpl"
	item_state = "ecdress_xpl"
	body_parts_covered = UPPER_TORSO|ARMS
	siemens_coefficient = 0.9
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL,ACCESSORY_SLOT_RANK, ACCESSORY_SLOT_INSIGNIA)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

/obj/item/clothing/suit/storage/solgov/dress/expedition
	name = "expeditionary dress coat"
	desc = "A silver and black dress peacoat belonging to the SCG Expeditionary Corps. Fashionable, for the 25th century at least."
	icon_state = "ecdress_xpl"
	item_state = "ecdress_xpl"
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_suit_unathi.dmi'
		)

/obj/item/clothing/suit/storage/solgov/dress/expedition/senior
	name = "expeditionary senior's dress coat"
	icon_state = "ecdress_sxpl"
	item_state = "ecdress_sxpl"

/obj/item/clothing/suit/storage/solgov/dress/expedition/chief
	name = "expeditionary chief's dress coat"
	icon_state = "ecdress_cxpl"
	item_state = "ecdress_cxpl"

/obj/item/clothing/suit/storage/solgov/dress/expedition/command
	name = "expeditionary officer's dress coat"
	desc = "A gold and black dress peacoat belonging to the SCG Expeditionary Corps. The height of fashion."
	icon_state = "ecdress_ofcr"
	item_state = "ecdress_ofcr"

/obj/item/clothing/suit/storage/solgov/dress/expedition/command/cdr
	name = "expeditionary commander's dress coat"
	icon_state = "ecdress_cdr"
	item_state = "ecdress_cdr"

/obj/item/clothing/suit/storage/solgov/dress/expedition/command/capt
	name = "expeditionary captain's dress coat"
	icon_state = "ecdress_capt"
	item_state = "ecdress_capt"

/obj/item/clothing/suit/storage/solgov/dress/expedition/command/adm
	name = "expeditionary admiral's dress coat"
	icon_state = "ecdress_adm"
	item_state = "ecdress_adm"

/obj/item/clothing/suit/storage/solgov/dress/fleet
	name = "fleet dress jacket"
	desc = "A navy blue SCG Fleet dress jacket. Don't get near pasta sauce or vox."
	icon_state = "whitedress"
	item_state = "whitedress"

/obj/item/clothing/suit/storage/solgov/dress/fleet/snco
	name = "fleet dress SNCO jacket"
	desc = "A navy blue SCG Fleet dress jacket with silver cuffs. Don't get near pasta sauce or vox."
	icon_state = "whitedress_snco"
	item_state = "whitedress_snco"

/obj/item/clothing/suit/storage/solgov/dress/fleet/officer
	name = "fleet officer's dress jacket"
	desc = "A navy blue SCG Fleet dress jacket with silver accents. Don't get near pasta sauce or vox."
	icon_state = "whitedress_off"
	item_state = "whitedress_off"

/obj/item/clothing/suit/storage/solgov/dress/fleet/command
	name = "fleet senior officer's dress jacket"
	desc = "A navy blue SCG Fleet dress jacket with gold accents. Don't get near pasta sauce or vox."
	icon_state = "whitedress_comm"
	item_state = "whitedress_comm"

/obj/item/clothing/suit/storage/solgov/dress/fleet/flag
	name = "fleet flag officer's dress jacket"
	desc = "A navy blue SCG Fleet dress jacket with red accents. Don't get near pasta sauce or vox."
	icon_state = "whitedress_flag"
	item_state = "whitedress_flag"

/obj/item/clothing/suit/dress/solgov
	name = "dress jacket"
	desc = "A uniform dress jacket, fancy."
	icon_state = "blackdress"
	item_state = "blackdress"
	icon = 'maps/torch/icons/obj/obj_suit_solgov.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/torch/icons/mob/onmob_suit_solgov.dmi')
	body_parts_covered = UPPER_TORSO|ARMS
	siemens_coefficient = 0.9
	allowed = list(
		/obj/item/tank/oxygen_emergency,
		/obj/item/tank/oxygen_emergency_extended,
		/obj/item/tank/nitrogen_emergency,
		/obj/item/device/flashlight,
		/obj/item/clothing/head/soft,
		/obj/item/clothing/head/beret,
		/obj/item/device/radio,
		/obj/item/pen
	)
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL,ACCESSORY_SLOT_RANK,ACCESSORY_SLOT_INSIGNIA)

/obj/item/clothing/suit/dress/solgov/fleet/sailor
	name = "fleet dress overwear"
	desc = "A navy blue SCG Fleet dress suit. Almost looks like a school-girl outfit."
	icon_state = "sailordress"
	item_state = "sailordress"

/obj/item/clothing/suit/dress/solgov/army
	name = "army dress jacket"
	desc = "A tailored black SCG Army dress jacket with red trim. So sexy it hurts."
	icon_state = "blackdress"
	item_state = "blackdress"

/obj/item/clothing/suit/dress/solgov/army/command
	name = "army officer's dress jacket"
	desc = "A tailored black SCG Army dress jacket with gold trim. Smells like ceremony."
	icon_state = "blackdress_com"
	item_state = "blackdress_com"

//Misc

/obj/item/clothing/suit/storage/hooded/wintercoat/solgov
	name = "expeditionary winter coat"
	icon_state = "coatec"
	icon = 'maps/torch/icons/obj/obj_suit_solgov.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/torch/icons/mob/onmob_suit_solgov.dmi')
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA,ACCESSORY_SLOT_RANK)

/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army
	name = "army winter coat"
	icon_state = "coatar"
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA,ACCESSORY_SLOT_RANK)

/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet
	name = "fleet winter coat"
	icon_state = "coatfl"
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)

/obj/item/clothing/suit/storage/jacket/solgov/fleet
	name = "fleet engineering jacket"
	desc = "A jacket commonly issued by the fleet to its engineers. It sports some yellow reflective stripes, and has elbow pads."
	icon_state = "navyengjacket"
	item_state = "navyengjacket"
	icon = 'maps/torch/icons/obj/obj_suit_solgov.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/torch/icons/mob/onmob_suit_solgov.dmi')
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA,ACCESSORY_SLOT_RANK)
	allowed = list (
		/obj/item/pen,
		/obj/item/clothing/head/soft,
		/obj/item/clothing/head/beret,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/flame/lighter,
		/obj/item/device/taperecorder,
		/obj/item/device/scanner/gas,
		/obj/item/device/radio,
		/obj/item/taperoll,
		/obj/item/device/scanner/gas,
		/obj/item/device/flashlight,
		/obj/item/device/multitool,
		/obj/item/device/radio,
		/obj/item/device/t_scanner,
		/obj/item/crowbar,
		/obj/item/screwdriver,
		/obj/item/weldingtool,
		/obj/item/wirecutters,
		/obj/item/wrench,
		/obj/item/tank/oxygen_emergency,
		/obj/item/tank/oxygen_emergency_extended,
		/obj/item/tank/nitrogen_emergency,
		/obj/item/clothing/mask/gas,
		/obj/item/taperoll/engineering,
		/obj/item/clothing/head/hardhat
	)

/obj/item/clothing/suit/storage/jacket/solgov/fleet/medical
	name = "fleet jacket"
	desc = "A jacket commonly issued by the fleet to its medical staff. It sports some discrete blue markings, and has thin elbow pads."
	icon_state = "navymedjacket"
	item_state = "navymedjacket"
	allowed = list (
		/obj/item/pen,
		/obj/item/clothing/head/soft,
		/obj/item/clothing/head/beret,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/flame/lighter,
		/obj/item/device/taperecorder,
		/obj/item/device/scanner/gas,
		/obj/item/device/radio,
		/obj/item/taperoll,
		/obj/item/stack/medical,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/hypospray,
		/obj/item/reagent_containers/syringe,
		/obj/item/device/scanner/health,
		/obj/item/device/flashlight,
		/obj/item/device/radio,
		/obj/item/clothing/head/hardhat,
		/obj/item/tank/oxygen_emergency,
		/obj/item/tank/oxygen_emergency_extended,
		/obj/item/tank/nitrogen_emergency,
		/obj/item/reagent_containers/ivbag
	)

/obj/item/clothing/suit/storage/jacket/solgov/fleet/security
	name = "fleet jacket"
	desc = "A jacket commonly issued by the fleet to its security staff. It sports some discrete red markings, and has elbow pads."
	icon_state = "navysecjacket"
	item_state = "navysecjacket"
	allowed = list (
		/obj/item/tank/oxygen_emergency,
		/obj/item/tank/oxygen_emergency_extended,
		/obj/item/tank/nitrogen_emergency,
		/obj/item/device/flashlight,
		/obj/item/pen,
		/obj/item/clothing/head/soft,
		/obj/item/clothing/head/beret,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/flame/lighter,
		/obj/item/device/taperecorder,
		/obj/item/device/scanner/gas,
		/obj/item/device/radio,
		/obj/item/taperoll,
		/obj/item/gun/energy,
		/obj/item/device/radio,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/gun/projectile,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/melee/baton,
		/obj/item/handcuffs,
		/obj/item/gun/magnetic,
		/obj/item/clothing/head/helmet
	)

/obj/item/clothing/suit/storage/jacket/solgov/fleet/service
	name = "fleet jacket"
	desc = "A jacket commonly issued by the fleet to its service staff. It sports some discrete green markings."
	icon_state = "navysrvjacket"
	item_state = "navysrvjacket"
	allowed = list (
		/obj/item/tank/oxygen_emergency,
		/obj/item/tank/oxygen_emergency_extended,
		/obj/item/tank/nitrogen_emergency,
		/obj/item/device/flashlight,
		/obj/item/pen,
		/obj/item/clothing/head/soft,
		/obj/item/clothing/head/beret,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/flame/lighter,
		/obj/item/device/taperecorder,
		/obj/item/device/scanner/gas,
		/obj/item/device/radio,
		/obj/item/taperoll
	)

/obj/item/clothing/suit/storage/jacket/solgov/fleet/supply
	name = "fleet jacket"
	desc = "A jacket commonly issued by the fleet to its deck staff. It sports some discrete brown markings, and has elbow pads."
	icon_state = "navysupjacket"
	item_state = "navysupjacket"
	allowed = list (
		/obj/item/tank/oxygen_emergency,
		/obj/item/tank/oxygen_emergency_extended,
		/obj/item/tank/nitrogen_emergency,
		/obj/item/device/flashlight,
		/obj/item/pen,
		/obj/item/clothing/head/soft,
		/obj/item/clothing/head/beret,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/flame/lighter,
		/obj/item/device/taperecorder,
		/obj/item/device/scanner/gas,
		/obj/item/device/radio,
		/obj/item/taperoll
	)

/obj/item/clothing/suit/storage/jacket/solgov/fleet/command
	name = "fleet jacket"
	desc = "A jacket commonly issued by the fleet to its command staff. It sports some gold markings."
	icon_state = "navycomjacket"
	item_state = "navycomjacket"
	allowed = list (
		/obj/item/tank/oxygen_emergency,
		/obj/item/tank/oxygen_emergency_extended,
		/obj/item/tank/nitrogen_emergency,
		/obj/item/device/flashlight,
		/obj/item/pen,
		/obj/item/clothing/head/soft,
		/obj/item/clothing/head/beret,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/flame/lighter,
		/obj/item/device/taperecorder,
		/obj/item/device/scanner/gas,
		/obj/item/device/radio,
		/obj/item/taperoll
	)

//SolGov Hardsuits

/obj/item/clothing/suit/space/void/engineering/alt/sol
	icon = 'maps/torch/icons/obj/obj_suit_solgov.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/torch/icons/mob/onmob_suit_solgov.dmi')
	sprite_sheets = list(
		SPECIES_UNATHI = 'maps/torch/icons/mob/unathi/onmob_suit_solgov_unathi.dmi',
		SPECIES_SKRELL = 'maps/torch/icons/mob/skrell/onmob_suit_solgov_skrell.dmi',
		)
	sprite_sheets_obj = list(
		SPECIES_UNATHI = 'maps/torch/icons/obj/unathi/obj_suit_solgov_unathi.dmi',
		SPECIES_SKRELL = 'maps/torch/icons/obj/skrell/obj_suit_solgov_skrell.dmi',
		)

/obj/item/clothing/suit/space/void/engineering/alt/sol/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/engineering/alt/sol
	boots = /obj/item/clothing/shoes/magboots

/obj/item/clothing/suit/space/void/atmos/alt/sol
	icon = 'maps/torch/icons/obj/obj_suit_solgov.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/torch/icons/mob/onmob_suit_solgov.dmi')
	sprite_sheets = list(
		SPECIES_UNATHI = 'maps/torch/icons/mob/unathi/onmob_suit_solgov_unathi.dmi',
		SPECIES_SKRELL = 'maps/torch/icons/mob/skrell/onmob_suit_solgov_skrell.dmi',
		)
	sprite_sheets_obj = list(
		SPECIES_UNATHI = 'maps/torch/icons/obj/unathi/obj_suit_solgov_unathi.dmi',
		SPECIES_SKRELL = 'maps/torch/icons/obj/skrell/obj_suit_solgov_skrell.dmi',
		)

/obj/item/clothing/suit/space/void/atmos/alt/sol/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/atmos/alt/sol
	boots = /obj/item/clothing/shoes/magboots

/obj/item/clothing/suit/space/void/pilot/sol
	icon = 'maps/torch/icons/obj/obj_suit_solgov.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/torch/icons/mob/onmob_suit_solgov.dmi')
	sprite_sheets = list(
		SPECIES_UNATHI = 'maps/torch/icons/mob/unathi/onmob_suit_solgov_unathi.dmi',
		SPECIES_SKRELL = 'maps/torch/icons/mob/skrell/onmob_suit_solgov_skrell.dmi',
		)
	sprite_sheets_obj = list(
		SPECIES_UNATHI = 'maps/torch/icons/obj/unathi/obj_suit_solgov_unathi.dmi',
		SPECIES_SKRELL = 'maps/torch/icons/obj/skrell/obj_suit_solgov_skrell.dmi',
		)

/obj/item/clothing/suit/space/void/pilot/sol/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/pilot/sol
	boots = /obj/item/clothing/shoes/magboots

/obj/item/clothing/suit/space/void/medical/alt/sol
	icon = 'maps/torch/icons/obj/obj_suit_solgov.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/torch/icons/mob/onmob_suit_solgov.dmi')
	sprite_sheets = list(
		SPECIES_UNATHI = 'maps/torch/icons/mob/unathi/onmob_suit_solgov_unathi.dmi',
		SPECIES_SKRELL = 'maps/torch/icons/mob/skrell/onmob_suit_solgov_skrell.dmi',
		)
	sprite_sheets_obj = list(
		SPECIES_UNATHI = 'maps/torch/icons/obj/unathi/obj_suit_solgov_unathi.dmi',
		SPECIES_SKRELL = 'maps/torch/icons/obj/skrell/obj_suit_solgov_skrell.dmi',
		)

/obj/item/clothing/suit/space/void/medical/alt/sol/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/medical/alt/sol
	boots = /obj/item/clothing/shoes/magboots

/obj/item/clothing/suit/space/void/command
	name = "command voidsuit"
	desc = "A light, radiation resistant voidsuit commonly used among SCG uniformed services. This one has an EC seal on its chest plate and command department markings."
	icon = 'maps/torch/icons/obj/obj_suit_solgov.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/torch/icons/mob/onmob_suit_solgov.dmi')
	icon_state = "rig_command"
	item_state = "rig_command"
	sprite_sheets = list(
		SPECIES_UNATHI = 'maps/torch/icons/mob/unathi/onmob_suit_solgov_unathi.dmi',
		SPECIES_SKRELL = 'maps/torch/icons/mob/skrell/onmob_suit_solgov_skrell.dmi',
		)
	sprite_sheets_obj = list(
		SPECIES_UNATHI = 'maps/torch/icons/obj/unathi/obj_suit_solgov_unathi.dmi',
		SPECIES_SKRELL = 'maps/torch/icons/obj/skrell/obj_suit_solgov_skrell.dmi',
		)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/storage/briefcase/inflatable)

/obj/item/clothing/suit/space/void/command/Initialize()
	. = ..()
	slowdown_per_slot[slot_wear_suit] = 0

/obj/item/clothing/suit/space/void/command/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/command
	boots = /obj/item/clothing/shoes/magboots

/obj/item/clothing/suit/space/void/exploration
	name = "exploration voidsuit"
	icon = 'maps/torch/icons/obj/obj_suit_solgov.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/torch/icons/mob/onmob_suit_solgov.dmi')
	desc = "The bulky Exoplanet Exploration Unit is a standard voidsuit for Expeditionary Corps field operations. It features extra padding and respectable radiation-resistant lining."
	icon_state = "rig_explorer"
	item_state = "rig_explorer"
	sprite_sheets = list(
		SPECIES_UNATHI = 'maps/torch/icons/mob/unathi/onmob_suit_solgov_unathi.dmi',
		SPECIES_SKRELL = 'maps/torch/icons/mob/skrell/onmob_suit_solgov_skrell.dmi',
		)
	sprite_sheets_obj = list(
		SPECIES_UNATHI = 'maps/torch/icons/obj/unathi/obj_suit_solgov_unathi.dmi',
		SPECIES_SKRELL = 'maps/torch/icons/obj/skrell/obj_suit_solgov_skrell.dmi',
		)
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
		)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/stack/flag,/obj/item/device/scanner/health,/obj/item/device/gps,/obj/item/pinpointer/radio,/obj/item/material/hatchet/machete,/obj/item/shovel)

/obj/item/clothing/suit/space/void/exploration/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/exploration
	boots = /obj/item/clothing/shoes/magboots

/obj/item/clothing/suit/space/void/medical/alt/sol/expo
	name = "exploration medical voidsuit"
	desc = "The bulky Exoplanet Exploration Unit is a standard voidsuit for Expeditionary Corps' medical specialists in field operations. It features extra padding and respectable radiation-resistant lining."
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
		)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/stack/flag,/obj/item/device/scanner/health,/obj/item/device/gps,/obj/item/pinpointer/radio,/obj/item/material/hatchet/machete,/obj/item/shovel)

/obj/item/clothing/head/helmet/space/void/medical/alt/sol/expo
	name = "exploration medical voidsuit helmet"
	desc = "The bulky Exoplanet Exploration Unit is a standard voidsuit for Expeditionary Corps' medical specialists in field operations. It features extra padding and respectable radiation-resistant lining."
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
		)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/stack/flag,/obj/item/device/scanner/health,/obj/item/device/gps,/obj/item/pinpointer/radio,/obj/item/material/hatchet/machete,/obj/item/shovel)


/obj/item/clothing/suit/space/void/atmos/alt/sol/expo
	name = "exploration engineering voidsuit"
	desc = "The bulky Exoplanet Exploration Unit is a standard voidsuit for Expeditionary Corps' engineering specialists in field operations. It features extra padding and respectable radiation-resistant lining."
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
		)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/stack/flag,/obj/item/device/scanner/health,/obj/item/device/gps,/obj/item/pinpointer/radio,/obj/item/material/hatchet/machete,/obj/item/shovel)

/obj/item/clothing/head/helmet/space/void/atmos/alt/sol/expo
	name = "exploration engineering voidsuit helmet"
	desc = "The bulky Exoplanet Exploration Unit is a standard voidsuit for Expeditionary Corps' engineering specialists in field operations. It features extra padding and respectable radiation-resistant lining."
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
		)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/stack/flag,/obj/item/device/scanner/health,/obj/item/device/gps,/obj/item/pinpointer/radio,/obj/item/material/hatchet/machete,/obj/item/shovel)

/obj/item/clothing/suit/space/void/security/alt/expo
	name = "marine voidsuit"
	desc = "A light, radiation resistant voidsuit commonly used among SCG uniformed services. This one has an SCG Army seal on its chest plate."

/obj/item/clothing/head/helmet/space/void/security/alt/expo
	name = "marine voidsuit helmet"
	desc = "A light, radiation resistant voidsuit commonly used among SCG uniformed services. This one has an SCG Army seal on its chest plate."
