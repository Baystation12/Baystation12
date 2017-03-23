/********************
* Devices and Tools *
********************/
/datum/uplink_item/item/tools
	category = /datum/uplink_category/tools

/datum/uplink_item/item/tools/toolbox
	name = "Fully Loaded Toolbox"
	item_cost = 8
	path = /obj/item/weapon/storage/toolbox/syndicate

/datum/uplink_item/item/tools/money
	name = "Operations Funding"
	item_cost = 8
	path = /obj/item/weapon/storage/secure/briefcase/money
	desc = "A briefcase with 10,000 untraceable thalers for funding your sneaky activities."

/datum/uplink_item/item/tools/clerical
	name = "Morphic Clerical Kit"
	item_cost = 16
	path = /obj/item/weapon/storage/backpack/satchel/syndie_kit/clerical

/datum/uplink_item/item/tools/plastique
	name = "C-4 (Destroys walls)"
	item_cost = 16
	path = /obj/item/weapon/plastique

/datum/uplink_item/item/tools/heavy_armor
	name = "Heavy Armor Vest and Helmet"
	item_cost = 16
	path = /obj/item/weapon/storage/backpack/satchel/syndie_kit/armor

/datum/uplink_item/item/tools/encryptionkey_radio
	name = "Encrypted Radio Channel Key"
	item_cost = 16
	path = /obj/item/device/encryptionkey/syndicate

/datum/uplink_item/item/tools/shield_diffuser
	name = "Handheld Shield Diffuser"
	item_cost = 16
	path = /obj/item/weapon/shield_diffuser

/datum/uplink_item/item/tools/flashdark
	name = "Flashdark"
	item_cost = 16
	path = /obj/item/device/flashlight/flashdark

/datum/uplink_item/item/tools/suit_sensor_mobile
	name = "Suit Sensor Jamming Device"
	desc = "This device will affect suit sensor data using method and radius defined by the user."
	item_cost = 20
	path = /obj/item/device/suit_sensor_jammer

/datum/uplink_item/item/tools/encryptionkey_binary
	name = "Binary Translator Key"
	item_cost = 20
	path = /obj/item/device/encryptionkey/binary

/datum/uplink_item/item/tools/emag
	name = "Cryptographic Sequencer"
	item_cost = 24
	path = /obj/item/weapon/card/emag

/datum/uplink_item/item/tools/hacking_tool
	name = "Door Hacking Tool"
	item_cost = 24
	path = /obj/item/device/multitool/hacktool
	desc = "Appears and functions as a standard multitool until the mode is toggled by applying a screwdriver appropriately. \
			When in hacking mode this device will grant full access to any standard airlock within 20 to 40 seconds. \
			This device will also be able to immediately access the last 6 to 8 hacked airlocks."

/datum/uplink_item/item/tools/space_suit
	name = "Space Suit"
	item_cost = 28
	path = /obj/item/weapon/storage/backpack/satchel/syndie_kit/space

/datum/uplink_item/item/tools/thermal
	name = "Thermal Imaging Glasses"
	item_cost = 24
	path = /obj/item/clothing/glasses/thermal/syndi

/datum/uplink_item/item/tools/powersink
	name = "Powersink (DANGER!)"
	item_cost = 40
	path = /obj/item/device/powersink

/datum/uplink_item/item/tools/teleporter
	name = "Teleporter Circuit Board"
	item_cost = 40
	path = /obj/item/weapon/circuitboard/teleporter

/datum/uplink_item/item/tools/teleporter/New()
	..()
	antag_roles = list(MODE_MERCENARY)

/datum/uplink_item/item/tools/ai_module
	name = "Hacked AI Upload Module"
	item_cost = 52
	path = /obj/item/weapon/aiModule/syndicate

/datum/uplink_item/item/tools/supply_beacon
	name = "Hacked Supply Beacon (DANGER!)"
	item_cost = 52
	path = /obj/item/supply_beacon

/datum/uplink_item/item/tools/camera_mask
	name = "Camera MIU"
	item_cost = 60
	antag_costs = list(MODE_MERCENARY = 30)
	path = /obj/item/clothing/mask/ai
