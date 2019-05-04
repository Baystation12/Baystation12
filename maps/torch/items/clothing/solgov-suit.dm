/obj/item/clothing/suit/storage/solgov/
	name = "master solgov jacket"
	icon = 'maps/torch/icons/obj/obj_suit_solgov.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/torch/icons/mob/onmob_suit_solgov.dmi')

//Service

/obj/item/clothing/suit/storage/solgov/service
	name = "service jumper"
	desc = "A uniform service jumper, plain and undecorated."
	icon_state = "blackservice"
	item_state = "blackservice"
	body_parts_covered = UPPER_TORSO|ARMS
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	allowed = list(/obj/item/weapon/tank/emergency,/obj/item/device/flashlight,/obj/item/weapon/pen,/obj/item/clothing/head/soft,/obj/item/clothing/head/beret,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter,/obj/item/device/taperecorder,/obj/item/device/scanner/gas,/obj/item/device/radio,/obj/item/taperoll)
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND,ACCESSORY_SLOT_MEDAL,ACCESSORY_SLOT_INSIGNIA,ACCESSORY_SLOT_RANK,ACCESSORY_SLOT_DEPT)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

/obj/item/clothing/suit/storage/solgov/service/expeditionary
	name = "expeditionary jumper"
	desc = "A uniform service jumper belonging to the SCG Expeditionary Corps."
	icon_state = "ecservice_crew"
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_suit_unathi.dmi'
		)

/obj/item/clothing/suit/storage/solgov/service/expeditionary/medical
	name = "medical expeditionary jumper"
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical/service)

/obj/item/clothing/suit/storage/solgov/service/expeditionary/medical/command
	name = "medical officer's expeditionary jumper"
	icon_state = "ecservice_officer"

/obj/item/clothing/suit/storage/solgov/service/expeditionary/engineering
	name = "engineering expeditionary jumper"
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/engineering/service)

/obj/item/clothing/suit/storage/solgov/service/expeditionary/engineering/command
	name = "engineering officer's expeditionary jumper"
	icon_state = "ecservice_officer"

/obj/item/clothing/suit/storage/solgov/service/expeditionary/supply
	name = "supply expeditionary jumper"
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/supply/service)

/obj/item/clothing/suit/storage/solgov/service/expeditionary/security
	name = "security expeditionary jumper"
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/security/service)

/obj/item/clothing/suit/storage/solgov/service/expeditionary/security/command
	name = "security officer's expeditionary jumper"
	icon_state = "ecservice_officer"

/obj/item/clothing/suit/storage/solgov/service/expeditionary/service
	name = "service expeditionary jumper"
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/service/service)

/obj/item/clothing/suit/storage/solgov/service/expeditionary/service/command
	name = "service officer's expeditionary jumper"
	icon_state = "ecservice_officer"

/obj/item/clothing/suit/storage/solgov/service/expeditionary/exploration
	name = "exploration expeditionary jumper"
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/exploration/service)

/obj/item/clothing/suit/storage/solgov/service/expeditionary/exploration/command
	name = "exploration officer's expeditionary jumper"
	icon_state = "ecservice_officer"

/obj/item/clothing/suit/storage/solgov/service/expeditionary/research
	name = "research expeditionary jumper"
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/research/service)

/obj/item/clothing/suit/storage/solgov/service/expeditionary/research/command
	name = "research officer's expeditionary jumper"
	icon_state = "ecservice_officer"

/obj/item/clothing/suit/storage/solgov/service/expeditionary/command
	name = "officer's expeditionary jumper"
	icon_state = "ecservice_officer"
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/command/service)

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

/obj/item/clothing/suit/storage/solgov/service/army
	name = "army coat"
	desc = "An SCG Army service coat. Green and undecorated."
	icon_state = "greenservice"
	item_state = "greenservice"

/obj/item/clothing/suit/storage/solgov/service/army/medical
	name = "army medical jacket"
	desc = "An SCG Army service coat. This one has blue markings."
	icon_state = "greenservice_med"
	item_state = "greenservice_med"

/obj/item/clothing/suit/storage/solgov/service/army/medical/command
	name = "army medical command jacket"
	desc = "An SCG Army service coat. This one has blue and gold markings."
	icon_state = "greenservice_medcom"
	item_state = "greenservice_medcom"

/obj/item/clothing/suit/storage/solgov/service/army/engineering
	name = "army engineering jacket"
	desc = "An SCG Army service coat. This one has orange markings."
	icon_state = "greenservice_eng"
	item_state = "greenservice_eng"

/obj/item/clothing/suit/storage/solgov/service/army/engineering/command
	name = "army engineering command jacket"
	desc = "An SCG Army service coat. This one has orange and gold markings."
	icon_state = "greenservice_engcom"
	item_state = "greenservice_engcom"

/obj/item/clothing/suit/storage/solgov/service/army/supply
	name = "army supply jacket"
	desc = "An SCG Army service coat. This one has brown markings."
	icon_state = "greenservice_sup"
	item_state = "greenservice_sup"

/obj/item/clothing/suit/storage/solgov/service/army/security
	name = "army security jacket"
	desc = "An SCG Army service coat. This one has red markings."
	icon_state = "greenservice_sec"
	item_state = "greenservice_sec"

/obj/item/clothing/suit/storage/solgov/service/army/security/command
	name = "army security command jacket"
	desc = "An SCG Army service coat. This one has red and gold markings."
	icon_state = "greenservice_seccom"
	item_state = "greenservice_seccom"

/obj/item/clothing/suit/storage/solgov/service/army/service
	name = "army service jacket"
	desc = "An SCG Army service coat. This one has green markings."
	icon_state = "greenservice_srv"
	item_state = "greenservice_srv"

/obj/item/clothing/suit/storage/solgov/service/army/service/command
	name = "army service command jacket"
	desc = "An SCG Army service coat. This one has green and gold markings."
	icon_state = "greenservice_srvcom"
	item_state = "greenservice_srvcom"

/obj/item/clothing/suit/storage/solgov/service/army/exploration
	name = "army exploration jacket"
	desc = "An SCG Army service coat. This one has purple markings."
	icon_state = "greenservice_exp"
	item_state = "greenservice_exp"

/obj/item/clothing/suit/storage/solgov/service/army/exploration/command
	name = "army exploration command jacket"
	desc = "An SCG Army service coat. This one has purple and gold markings."
	icon_state = "greenservice_expcom"
	item_state = "greenservice_expcom"

/obj/item/clothing/suit/storage/solgov/service/army/command
	name = "army command jacket"
	desc = "An SCG Marine Corps service coat. This one has gold markings."
	icon_state = "greenservice_com"
	item_state = "greenservice_com"

//Dress - murder me with a gun why are these 3 different types

/obj/item/clothing/suit/dress/solgov
	name = "dress jacket"
	desc = "A uniform dress jacket, fancy."
	icon_state = "greydress"
	item_state = "greydress"
	icon = 'maps/torch/icons/obj/obj_suit_solgov.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/torch/icons/mob/onmob_suit_solgov.dmi')
	body_parts_covered = UPPER_TORSO|ARMS
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	allowed = list(/obj/item/weapon/tank/emergency,/obj/item/device/flashlight,/obj/item/clothing/head/soft,/obj/item/clothing/head/beret,/obj/item/device/radio,/obj/item/weapon/pen)
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL,ACCESSORY_SLOT_RANK)

/obj/item/clothing/suit/dress/solgov/expedition
	name = "expeditionary dress jacket"
	desc = "A silver and grey dress jacket belonging to the SCG Expeditionary Corps. Fashionable, for the 25th century at least."
	icon_state = "greydress"
	item_state = "greydress"
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_suit_unathi.dmi'
		)

/obj/item/clothing/suit/dress/solgov/expedition/command
	name = "expeditionary officer's dress jacket"
	desc = "A gold and grey dress jacket belonging to the SCG Expeditionary Corps. The height of fashion."
	icon_state = "greydress_com"
	item_state = "greydress_com"

/obj/item/clothing/suit/dress/solgov/fleet/sailor
	name = "fleet dress overwear"
	desc = "A navy blue SCG Fleet dress suit. Almost looks like a school-girl outfit."
	icon_state = "sailordress"
	item_state = "whitedress"

/obj/item/clothing/suit/storage/solgov/dress
	name = "dress jacket"
	desc = "A uniform dress jacket, plain and undecorated."
	icon_state = "whitedress"
	item_state = "whitedress"
	body_parts_covered = UPPER_TORSO|ARMS
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL,ACCESSORY_SLOT_INSIGNIA,ACCESSORY_SLOT_RANK)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

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
	armor = list(melee = 25, bullet = 10, laser = 5, energy = 10, bomb = 20, bio = 0, rad = 10)
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA,ACCESSORY_SLOT_RANK)

/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army
	name = "army winter coat"
	icon_state = "coatar"
	armor = list(melee = 30, bullet = 10, laser = 10, energy = 15, bomb = 20, bio = 0, rad = 0)
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA,ACCESSORY_SLOT_RANK)

/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet
	name = "fleet winter coat"
	icon_state = "coatfl"
	armor = list(melee = 20, bullet = 10, laser = 10, energy = 20, bomb = 20, bio = 0, rad = 10)
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)

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

/obj/item/clothing/head/helmet/space/void/command
	icon = 'maps/torch/icons/obj/obj_head_solgov.dmi'
	item_icons = list(slot_head_str = 'maps/torch/icons/mob/onmob_head_solgov.dmi')
	name = "command voidsuit helmet"
	desc = "A light, radiation resistant voidsuit helmet commonly used among SCG uniformed services."
	icon_state = "void_command"
	item_state = "void_command"
	armor = list(melee = 30, bullet = 5, laser = 10,energy = 5, bomb = 5, bio = 100, rad = 60)
	light_overlay = "helmet_light_dual_green"

/obj/item/clothing/suit/space/void/command
	icon = 'maps/torch/icons/obj/obj_suit_solgov.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/torch/icons/mob/onmob_suit_solgov.dmi')
	icon_state = "void_command"
	name = "command voidsuit"
	desc = "A light, radiation resistant voidsuit commonly used among SCG uniformed services. This one has an EC seal on its chest plate and command department markings."
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/briefcase/inflatable)
	armor = list(melee = 30, bullet = 5, laser = 10,energy = 5, bomb = 5, bio = 100, rad = 60)

/obj/item/clothing/suit/space/void/command/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 0

/obj/item/clothing/suit/space/void/command/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/command
	boots = /obj/item/clothing/shoes/magboots