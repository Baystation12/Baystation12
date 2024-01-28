//
//        DOOR CHARGE Uplink part
//

/datum/uplink_item/item/tools/door_charge
	name = "Door Charge"
	desc = "Special explosive, which can be planted on doors and will explode when somebody will open this door."
	item_cost = 14
	path = /obj/item/door_charge

//
//        JAINTER Uplink part
//

/datum/uplink_item/item/tools/jaunter
	name = "Bluespace Jaunter"
	item_cost = 42
	path = /obj/item/storage/box/syndie_kit/jaunter
	desc = "Disposable one way teleportation device. Use with care. Don't forget to link jaunter to the beacon!"

//
//        Psi Amp - Uplink part (Here because turned off by Bay12)
//

/datum/uplink_item/item/visible_weapons/psi_amp
	name = "Cerebroenergetic Psionic Amplifier"
	item_cost = 50
	path = /obj/item/clothing/head/helmet/space/psi_amp/lesser
	desc = "A powerful, illegal psi-amp. Boosts latent psi-faculties to extremely high levels."

//
//        Holobombs - Uplink part
//

/datum/uplink_item/item/tools/holobomb
	name = "Box of holobombs"
	item_cost = 32
	path =/obj/item/storage/box/syndie_kit/holobombs
	desc = "Contains 5 holobomb and instruction. \
			A bomb that changes appearance, and can destroy some hands."

//
//        С-4 pack - Uplink part
//

/datum/uplink_item/item/tools/plastique_bag
	name = "Box of holobombs"
	item_cost = 48
	path =/obj/item/storage/backpack/dufflebag/syndie_kit/plastique
	desc = "Contains 6 C-4 charges at 50% discount."

//
//        Poison - Uplink part
//

/datum/uplink_item/item/tools/bioterror
	name = "Poisons kit"
	desc = "A box, containing 7 vials of random and very deadly poisons."
	item_cost = 48
	path = /obj/item/storage/box/syndie_kit/bioterror

//
//        Encrypt key - Uplink part
//

/datum/uplink_item/item/tools/encryptionkey_full
	name = "Special Encryption Key"
	desc = "This headset encryption key will allow you listen and speak on any channel! Use a screwdriver on your headset to exchange keys."
	item_cost = 24
	path = /obj/item/device/encryptionkey/syndie_full

// Stimpack

/datum/uplink_item/item/tools/stimpack
	name = "Stimpack"
	desc = "Autoinjector, containing 5u of experimental stimulants, that will increase your speed temporarly."
	item_cost = 18
	antag_costs = list(MODE_MERCENARY = 12)
	path = /obj/item/reagent_containers/hypospray/autoinjector/stimpack

// Radlaser

/datum/uplink_item/item/tools/radlaser
	name = "Radioactive Microlaser"
	item_cost = 18
	path = /obj/item/device/scanner/health/syndie
	desc = "A tiny microlaser, hidden in health analyzer, that can irradiate your targets."

/datum/uplink_item/item/tools/blackout
	name = "High Pulse Electricity Outage Tool"
	item_cost = 24
	path = /obj/item/device/blackout
	desc = "A device which can create power surge in terminal, spread it in power network and temporally creating blackout."
