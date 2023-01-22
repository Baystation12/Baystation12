/********************
* Devices and Tools *
********************/
/datum/uplink_item/item/tools
	category = /datum/uplink_category/tools

/datum/uplink_item/item/tools/personal_shield
	name = "Personal Shield"
	desc = "A very expensive device that uses energy to block bullets and lasers from tearing you a new hole."
	item_cost = 55
	path = /obj/item/device/personal_shield

/datum/uplink_item/item/tools/toolbox
	name = "Fully Loaded Toolbox"
	desc = "A hefty toolbox filled with all the equipment you need to get past any construction or electrical issues. \
	Instructions and materials not included."
	item_cost = 8
	path = /obj/item/storage/toolbox/syndicate

/datum/uplink_item/item/tools/ductape
	name = "Duct Tape"
	desc = "A roll of duct tape."
	item_cost = 1
	path = /obj/item/tape_roll

/datum/uplink_item/item/tools/money
	name = "Operations Funding"
	item_cost = 8
	path = /obj/item/storage/secure/briefcase/money
/datum/uplink_item/item/tools/money/New()
	. = ..()
	desc = "A briefcase with 10,000 untraceable [GLOB.using_map.local_currency_name]. Makes a great bribe if they're willing to take you up on your offer."

/datum/uplink_item/item/tools/clerical
	name = "Morphic Clerical Kit"
	desc = "Comes with everything you need to fake paperwork, assuming you know how to forge the required documents."
	item_cost = 16
	path = /obj/item/storage/backpack/satchel/syndie_kit/clerical

/datum/uplink_item/item/tools/plastique
	name = "C-4"
	desc = "Set this on a wall to put a hole exactly where you need it."
	item_cost = 14
	path = /obj/item/plastique

/* //proxima //commented for now
/datum/uplink_item/item/tools/heavy_armor
	name = "Heavy Armor Vest and Helmet"
	desc = "This satchel holds a combat helmet and fully equipped plate carrier. \
	Suit up, and strap in, things are about to get hectic."
	item_cost = 16
	path = /obj/item/storage/backpack/satchel/syndie_kit/armor
*/
/datum/uplink_item/item/tools/encryptionkey_radio
	name = "Encrypted Radio Channel Key"
	desc = "This headset encryption key will allow you to speak on a hidden, encrypted radio channel. Use a screwdriver on your headset to exchange keys."
	item_cost = 1
	path = /obj/item/device/encryptionkey/syndicate

/datum/uplink_item/item/tools/shield_diffuser
	name = "Handheld Shield Diffuser"
	desc = "A small device used to disrupt energy barriers, and allow passage through them."
	item_cost = 16
	path = /obj/item/shield_diffuser

/datum/uplink_item/item/tools/suit_sensor_mobile
	name = "Suit Sensor Jamming Device"
	desc = "This tiny device can temporarily change sensor levels, report random readings, or false readings on any \
	suit sensors in your vicinity. The range at which this device operates can be toggled as well. All of these \
	options drain the internal battery."
	item_cost = 20
	path = /obj/item/device/suit_sensor_jammer

/datum/uplink_item/item/tools/encryptionkey_binary
	name = "Binary Translator Key"
	desc = "This headset encryption key will allow you to both listen and speak on the binary channel that \
	synthetics and AI have access to. Remember, non-synths don't normally have access to this channel, so talking in it will raise suspicion. \
	Use a screwdriver on your headset to exchange keys."
	item_cost = 22
	path = /obj/item/device/encryptionkey/binary

/datum/uplink_item/item/tools/emag
	name = "Cryptographic Sequencer"
	desc = "An electromagnetic card capable of scrambling electronics to either subvert them into serving you, \
			or giving you access to things you normally can't. Doors can be opened with this card \
			even if you aren't normally able to, but will destroy them in the proccess. This card can have its appearance changed \
			to look less conspicuous."
	item_cost = 24
	path = /obj/item/card/emag

/datum/uplink_item/item/tools/hacking_tool
	name = "Door Hacking Tool"
	item_cost = 22
	path = /obj/item/device/multitool/hacktool
	desc = "Appears and functions as a standard multitool until a screwdriver is used to toggle it. \
			While in hacking mode, this device will grant full access to any airlock in 20 to 40 seconds. \
			This device will be able to continuously reaccess the last 6 to 8  airlocks it was used on."

/* //proxima //commented for now
/datum/uplink_item/item/tools/space_suit
	name = "Voidsuit and Tactical Mask"
	desc = "A satchel containing a non-regulation voidsuit, voidsuit helmet, tactical mask, and oxygen tank. \
	Conceal your identity, while also not dying in space."
	item_cost = 28
	path = /obj/item/storage/backpack/satchel/syndie_kit/space
*/
/datum/uplink_item/item/tools/thermal
	name = "Thermal Imaging Glasses"
	desc = "A pair of meson goggles that have been modified to instead show synthetics or living creatures, through thermal imaging."
	item_cost = 24
	path = /obj/item/clothing/glasses/thermal/syndi
	antag_roles = list(MODE_TRAITOR)

/datum/uplink_item/item/tools/flashdark
	name = "Flashdark"
	desc = "A device similar to a flash light that absorbs the surrounding light, casting a shadowy, black mass."
	item_cost = 32
	path = /obj/item/device/flashlight/flashdark

/datum/uplink_item/item/tools/powersink
	name = "Powersink (DANGER!)"
	desc = "A device, that when bolted down to an exposed wire, spikes the surrounding electrical systems, \
	draining power at an alarming rate. Use with caution, as this will be extremely noticable to anyone \
	monitoring the power systems."
	item_cost = 35
	path = /obj/item/device/powersink

/datum/uplink_item/item/tools/ai_module
	name = "Hacked AI Upload Module"
	desc = "A module that can be used anonymously add a singular, top level law to an active AI. \
	All you need to do is write in the law and insert it into any available AI Upload Console."
	item_cost = 55
	path = /obj/item/aiModule/syndicate

/datum/uplink_item/item/tools/supply_beacon
	name = "Hacked Supply Beacon (DANGER!)"
	desc = "Wrench this large beacon onto an exposed power cable, in order to activate it. This will call in a \
	drop pod to the target location, containing a random assortment of (possibly useful) items. \
	The ship's computer system will announce when this pod is enroute."
	item_cost = 45
	path = /obj/item/supply_beacon

/datum/uplink_item/item/tools/camera_mask
	name = "Camera MIU"
	desc = "Wearing this mask allows you to remotely view any cameras you currently have access to. Take the mask off to stop viewing."
	item_cost = 40
	antag_costs = list(MODE_MERCENARY = 30)
	path = /obj/item/clothing/mask/ai

/datum/uplink_item/item/tools/interceptor
	name = "Radio Interceptor"
	item_cost = 30
	path = /obj/item/device/radio/intercept
	desc = "A receiver-like device that can intercept secure radio channels. This item is too big to fit into your pockets."

/datum/uplink_item/item/tools/ttv
	name = "Binary Gas Bomb"
	item_cost = 40
	path = /obj/effect/spawner/newbomb/traitor
	desc = "A remote-activated phoron-oxygen bomb assembly with an included signaler. \
			A flashing disclaimer begins with the warning 'SOME DISASSEMBLY/REASSEMBLY REQUIRED.'"

/datum/uplink_item/item/tools/polychromic_dye_bottle
	name = "Extra-Strength Polychromic Dye"
	item_cost = 10
	path = /obj/item/reagent_containers/glass/bottle/dye/polychromic/strong
	desc = "15 units of a tasteless dye that causes chemical mixtures to take on the color of the dye itself. \
			Very useful for disguising poisons to the untrained eye; even large amounts of reagents can be fully recolored with only a few drops of dye. \
			Like the mundane variety of polychromic dye, you can use the bottle in your hand to change the dye's color to suit your needs."
