//Eros suits and exosuits

/obj/item/clothing/suit/storage/noirdetective
	name = "noir detective jacket"
	desc = "For a working man."
	icon_state = "eros_noir_detective"
	item_state = "eros_noir_detective"

/obj/item/clothing/suit/storage/colonel
	name = "colonels jacket"
	desc = "An authentic jacket worn by an infamous colonel."
	icon_state = "eros_colonel"
	item_state = "eros_colonel"

/obj/item/clothing/suit/storage/cowboy
	name = "brown cowboy vest"
	desc = ""
	icon_state = "eros_cowboyvest"
	item_state = "eros_cowboyvest"

/obj/item/clothing/suit/storage/cowboydark
	name = "black cowboy vest"
	desc = ""
	icon_state = "eros_cowboyvest_dark"
	item_state = "eros_cowboyvest_dark"

/obj/item/clothing/suit/bow
	name = "red gift bow"
	desc = "Looks like someone's all wrapped up and ready to open..."
	icon_state = "eros_bow"
	item_state = "eros_bow"
	show_genitals = 1
	show_boobs = 1

/obj/item/clothing/suit/maidapron
	name = "maid apron"
	desc = "Some unusual stains..."
	icon_state = "eros_maidapron"
	item_state = "eros_maidapron"

/obj/item/clothing/suit/kigu
	name = "kigurumi"
	desc = "Cute and warm, good for naps and lazing around."
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS|HIDEEARS|HEAD
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|BLOCKHEADHAIR

/obj/item/clothing/suit/kigu/bear
	name = "bear kigurumi"
	icon_state = "eros_kigubear"
	item_state = "eros_kigubear"

/obj/item/clothing/suit/kigu/corgi
	name = "corgi kigurumi"
	icon_state = "eros_kigucorgi"
	item_state = "eros_kigucorgi"

/obj/item/clothing/suit/kigu/cat
	name = "cat kigurumi"
	icon_state = "eros_kigucat"
	item_state = "eros_kigucat"

/obj/item/clothing/suit/lolitadress
	name = "lolita dress"
	icon_state = "eros_lolitadress"
	item_state = "eros_lolitadress"

/obj/item/clothing/suit/storage/hooded/wintercoat
	name = "winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs."
	icon_state = "coatwinter"
	item_state_slots = list(slot_r_hand_str = "coatwinter", slot_l_hand_str = "coatwinter")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	action_button_name = "Toggle Winter Hood"
	hoodtype = /obj/item/clothing/head/winterhood

/obj/item/clothing/head/winterhood
	name = "winter hood"
	desc = "A hood attached to a heavy winter jacket."
	icon_state = "generic_hood"
	body_parts_covered = HEAD
	cold_protection = HEAD
	flags_inv = HIDEEARS | BLOCKHAIR
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/storage/hooded/wintercoat/captain
	name = "captain's winter coat"
	icon_state = "coatcaptain"
	item_state_slots = list(slot_r_hand_str = "coatcaptain", slot_l_hand_str = "coatcaptain")
	armor = list(melee = 20, bullet = 15, laser = 20, energy = 10, bomb = 15, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/hooded/wintercoat/security
	name = "security winter coat"
	icon_state = "coatsecurity"
	item_state_slots = list(slot_r_hand_str = "coatsecurity", slot_l_hand_str = "coatsecurity")
	armor = list(melee = 25, bullet = 20, laser = 20, energy = 15, bomb = 20, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/hooded/wintercoat/medical
	name = "medical winter coat"
	icon_state = "coatmedical"
	item_state_slots = list(slot_r_hand_str = "coatmedical", slot_l_hand_str = "coatmedical")
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)

/obj/item/clothing/suit/storage/hooded/wintercoat/science
	name = "science winter coat"
	icon_state = "coatscience"
	item_state_slots = list(slot_r_hand_str = "coatscience", slot_l_hand_str = "coatscience")
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/hooded/wintercoat/engineering
	name = "engineering winter coat"
	icon_state = "coatengineer"
	item_state_slots = list(slot_r_hand_str = "coatengineer", slot_l_hand_str = "coatengineer")
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 20)

/obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos
	name = "atmospherics winter coat"
	icon_state = "coatatmos"
	item_state_slots = list(slot_r_hand_str = "coatatmos", slot_l_hand_str = "coatatmos")

/obj/item/clothing/suit/storage/hooded/wintercoat/hydro
	name = "hydroponics winter coat"
	icon_state = "coathydro"
	item_state_slots = list(slot_r_hand_str = "coathydro", slot_l_hand_str = "coathydro")

/obj/item/clothing/suit/storage/hooded/wintercoat/cargo
	name = "cargo winter coat"
	icon_state = "coatcargo"
	item_state_slots = list(slot_r_hand_str = "coatcargo", slot_l_hand_str = "coatcargo")

/obj/item/clothing/suit/storage/hooded/wintercoat/miner
	name = "mining winter coat"
	icon_state = "coatminer"
	item_state_slots = list(slot_r_hand_str = "coatminer", slot_l_hand_str = "coatminer")
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/toggle/track
	name = "track jacket"
	desc = "a track jacket, for the athletic."
	icon_state = "eros_trackjacket"
	item_state_slots = list(slot_r_hand_str = "black_labcoat", slot_l_hand_str = "black_labcoat")
	icon_open = "eros_trackjacket_open"
	icon_closed = "eros_trackjacket"

/obj/item/clothing/suit/storage/toggle/track/blue
	name = "blue track jacket"
	icon_state = "eros_trackjacketblue"
	item_state_slots = list(slot_r_hand_str = "blue_labcoat", slot_l_hand_str = "blue_labcoat")
	icon_open = "eros_trackjacketblue_open"
	icon_closed = "eros_trackjacketblue"

/obj/item/clothing/suit/storage/toggle/track/green
	name = "green track jacket"
	icon_state = "eros_trackjacketgreen"
	item_state_slots = list(slot_r_hand_str = "green_labcoat", slot_l_hand_str = "green_labcoat")
	icon_open = "eros_trackjacketgreen_open"
	icon_closed = "eros_trackjacketgreen"

/obj/item/clothing/suit/storage/toggle/track/red
	name = "red track jacket"
	icon_state = "eros_trackjacketred"
	item_state_slots = list(slot_r_hand_str = "red_labcoat", slot_l_hand_str = "red_labcoat")
	icon_open = "eros_trackjacketred_open"
	icon_closed = "eros_trackjacketred"

/obj/item/clothing/suit/storage/toggle/track/white
	name = "white track jacket"
	icon_state = "eros_trackjacketwhite"
	item_state_slots = list(slot_r_hand_str = "labcoat", slot_l_hand_str = "labcoat")
	icon_open = "eros_trackjacketwhite_open"
	icon_closed = "eros_trackjacketwhite"

/obj/item/clothing/suit/storage/leather_jacket/alt
	icon_state = "eros_leather_jacket_alt"
	item_state_slots = list(slot_r_hand_str = "leather_jacket", slot_l_hand_str = "leather_jacket")

/obj/item/clothing/suit/wcoat/red
	name = "red waistcoat"
	icon_state = "eros_wcoat_red"

/obj/item/clothing/suit/wcoat/gray
	name = "gray waistcoat"
	icon_state = "eros_wcoat_gray"

/obj/item/clothing/suit/wcoat/brown
	name = "brown waistcoat"
	icon_state = "eros_wcoat_brown"

/obj/item/clothing/suit/storage/toggle/labcoat/red
	name = "red labcoat"
	desc = "A suit that protects against minor chemical spills. This one is red."
	icon_state = "eros_red_labcoat_open"
	icon_open = "eros_red_labcoat_open"
	icon_closed = "eros_red_labcoat"
	item_state_slots = list(slot_r_hand_str = "eros_red_labcoat", slot_l_hand_str = "eros_red_labcoat")

/obj/item/clothing/suit/storage/toggle/labcoat/blue
	name = "blue labcoat"
	desc = "A suit that protects against minor chemical spills. This one is blue."
	icon_state = "eros_blue_labcoat_open"
	icon_open = "eros_blue_labcoat_open"
	icon_closed = "eros_blue_labcoat"
	item_state_slots = list(slot_r_hand_str = "eros_blue_labcoat", slot_l_hand_str = "eros_blue_labcoat")

/obj/item/clothing/suit/storage/toggle/labcoat/purple
	name = "purple labcoat"
	desc = "A suit that protects against minor chemical spills. This one is purple."
	icon_state = "eros_purple_labcoat_open"
	icon_open = "eros_purple_labcoat_open"
	icon_closed = "eros_purple_labcoat"
	item_state_slots = list(slot_r_hand_str = "eros_purple_labcoat", slot_l_hand_str = "eros_purple_labcoat")

/obj/item/clothing/suit/storage/toggle/labcoat/orange
	name = "orange labcoat"
	desc = "A suit that protects against minor chemical spills. This one is orange."
	icon_state = "eros_orange_labcoat_open"
	icon_open = "eros_orange_labcoat_open"
	icon_closed = "eros_orange_labcoat"
	item_state_slots = list(slot_r_hand_str = "eros_orange_labcoat", slot_l_hand_str = "eros_orange_labcoat")

/obj/item/clothing/suit/storage/toggle/labcoat/green
	name = "green labcoat"
	desc = "A suit that protects against minor chemical spills. This one is green."
	icon_state = "eros_green_labcoat_open"
	icon_open = "eros_green_labcoat_open"
	icon_closed = "eros_green_labcoat"
	item_state_slots = list(slot_r_hand_str = "eros_green_labcoat", slot_l_hand_str = "eros_green_labcoat")

/obj/item/clothing/suit/storage/toggle/labcoat/yellow
	name = "yellow labcoat"
	desc = "A suit that protects against minor chemical spills. This one is yellow."
	icon_state = "eros_yellow_labcoat_open"
	icon_open = "eros_yellow_labcoat_open"
	icon_closed = "eros_yellow_labcoat"
	item_state_slots = list(slot_r_hand_str = "eros_yellow_labcoat", slot_l_hand_str = "eros_yellow_labcoat")

/obj/item/clothing/suit/storage/toggle/labcoat/pink
	name = "pink labcoat"
	desc = "A suit that protects against minor chemical spills. This one is pink."
	icon_state = "eros_pink_labcoat_open"
	icon_open = "eros_pink_labcoat_open"
	icon_closed = "eros_pink_labcoat"
	item_state_slots = list(slot_r_hand_str = "eros_pink_labcoat", slot_l_hand_str = "eros_pink_labcoat")

/obj/item/clothing/suit/jacket/puffer
	name = "puffer jacket"
	desc = "A thick jacket with a rubbery, water-resistant shell."
	icon_state = "eros_pufferjacket"
	item_state_slots = list(slot_r_hand_str = "chainmail", slot_l_hand_str = "chainmail")

/obj/item/clothing/suit/jacket/puffer/vest
	name = "puffer vest"
	desc = "A thick vest with a rubbery, water-resistant shell."
	icon_state = "eros_puffervest"
	item_state_slots = list(slot_r_hand_str = "chainmail", slot_l_hand_str = "chainmail")

/obj/item/clothing/suit/storage/miljacket
	name = "military jacket"
	desc = "A canvas jacket styled after classical American military garb. Feels sturdy, yet comfortable."
	icon_state = "eros_militaryjacket_nobadge"
	item_state_slots = list(slot_r_hand_str = "suit_olive", slot_l_hand_str = "suit_olive")

/obj/item/clothing/suit/storage/miljacket/alt
	name = "military jacket"
	desc = "A canvas jacket styled after classical American military garb. Feels sturdy, yet comfortable."
	icon_state = "eros_militaryjacket_badge"
	item_state_slots = list(slot_r_hand_str = "suit_olive", slot_l_hand_str = "suit_olive")

/obj/item/clothing/suit/storage/miljacket/green
	name = "military jacket"
	desc = "A dark green canvas jacket. Feels sturdy, yet comfortable."
	icon_state = "eros_militaryjacket_green"
	item_state_slots = list(slot_r_hand_str = "suit_olive", slot_l_hand_str = "suit_olive")


// Overalls

/obj/item/clothing/suit/apron/overalls	// Bay overalls, redefined here for convenience
	name = "coveralls"
	desc = "A set of denim overalls."
	icon_state = "overalls"
	item_state = "overalls"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/clothing/suit/apron/overalls/brown
	name = "brown overalls"
	desc = "A plain set of overalls. For the hard working individual"
	icon_state = "overalls_acc"
	item_state = "overalls_acc"
	allowed = list (/obj/item/device/analyzer, /obj/item/device/flashlight, /obj/item/device/multitool, /obj/item/device/pipe_painter, /obj/item/device/radio, /obj/item/device/t_scanner, \
	/obj/item/weapon/crowbar, /obj/item/weapon/screwdriver, /obj/item/weapon/weldingtool, /obj/item/weapon/wirecutters, /obj/item/weapon/wrench, /obj/item/weapon/tank/emergency, \
	/obj/item/clothing/mask/gas, /obj/item/taperoll/engineering) // is this list just good enough?

/obj/item/clothing/suit/apron/overalls/electrician
	name = "electrician overalls"
	desc = "A pair of insulated leather overalls. Used for wiring and electronic maintenance."
	icon_state = "electrician-overalls"
	item_state = "electrician-overalls"
	allowed = list (/obj/item/device/analyzer, /obj/item/device/flashlight, /obj/item/device/multitool, /obj/item/device/pipe_painter, /obj/item/device/radio, /obj/item/device/t_scanner, \
	/obj/item/weapon/crowbar, /obj/item/weapon/screwdriver, /obj/item/weapon/weldingtool, /obj/item/weapon/wirecutters, /obj/item/weapon/wrench, /obj/item/weapon/tank/emergency, \
	/obj/item/clothing/mask/gas, /obj/item/taperoll/engineering)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/apron/overalls/emergency
	name = "emergency overalls"
	desc = "A pair of insulated leather overalls. Used for wiring and electronic maintenance."
	icon_state = "emergency-overalls"
	item_state = "emergency-overalls"
	allowed = list (/obj/item/device/analyzer, /obj/item/device/flashlight, /obj/item/device/multitool, /obj/item/device/pipe_painter, /obj/item/device/radio, /obj/item/device/t_scanner, \
	/obj/item/weapon/crowbar, /obj/item/weapon/screwdriver, /obj/item/weapon/weldingtool, /obj/item/weapon/wirecutters, /obj/item/weapon/wrench, /obj/item/weapon/tank/emergency, \
	/obj/item/clothing/mask/gas, /obj/item/taperoll/engineering)   // todo - define a list more appropriate here
	gas_transfer_coefficient = 0.7
	permeability_coefficient = 0.7
	heat_protection = UPPER_TORSO|LOWER_TORSO
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/storage/factoryvest
	name = "factory worker's vest"
	desc = "A rough leather vest used by factory workers. For holding a few small personal items."
	icon_state = "factoryworker-vest"
	item_state = "factoryworker-vest"

/obj/item/clothing/suit/storage/factoryapron
	name = "factory worker's apron"
	desc = "A long leather apron used by factory workers. Keeps the dust and dirt off and holds a few small items."
	icon_state = "factoryworker-apron"
	item_state = "factoryworker-apron"

/obj/item/clothing/suit/storage/shipping
	name = "shipping jacket"
	desc = "A green jacket bearing the logo of an obsolete shipping company."
	icon_state = "mbill"
	item_state = "mbill"

/obj/item/clothing/suit/storage/blackjacket
	name = "black jacket"
	desc = "A finely made jacket, in black leather."
	icon_state = "jacket_black"
	item_state = "jacket_black"

/obj/item/clothing/suit/storage/brownjacket
	name = "brown jacket"
	desc = "A finely made jacket, in brown leather."
	icon_state = "jacket_black"
	item_state = "jacket_black"

/obj/item/clothing/suit/armor/riot/knight
	name = "plate armor"
	desc = "A classic suit of plate armour, highly effective at stopping melee attacks."
	icon_state = "eros_knight_grey"
	item_state = "eros_knight_grey"

/obj/item/clothing/suit/armor/riot/knight/green
	name = "green plate armor"
	desc = "A classic suit of plate armour, highly effective at stopping melee attacks. It has green decor."
	icon_state = "eros_knight_green"
	item_state = "eros_knight_green"

/obj/item/clothing/suit/armor/riot/knight/yellow
	name = "yellow plate armor"
	desc = "A classic suit of plate armour, highly effective at stopping melee attacks. It has yellow decor."
	icon_state = "eros_knight_yellow"
	item_state = "eros_knight_yellow"

/obj/item/clothing/suit/armor/riot/knight/blue
	name = "blue plate armor"
	desc = "A classic suit of plate armour, highly effective at stopping melee attacks. It has blue decor."
	icon_state = "eros_knight_blue"
	item_state = "eros_knight_blue"

/obj/item/clothing/suit/armor/riot/knight/red
	name = "red plate armor"
	desc = "A classic suit of plate armour, highly effective at stopping melee attacks. It has red decor."
	icon_state = "eros_knight_red"
	item_state = "eros_knight_red"

/obj/item/clothing/suit/armor/riot/knight/templar
	name = "crusader armor"
	desc = "God wills it!"
	icon_state = "eros_knight_templar"
	item_state = "eros_knight_templar"