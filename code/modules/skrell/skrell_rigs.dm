// Rigs and gear themselves.

//Define Rig Clothing
/obj/item/clothing/suit/space/rig/ert/skrell
	name = "skrellian recon hardsuit chestpiece"
	desc = "A powerful recon hardsuit with integrated power supply and atmosphere. It's impressive design perfectly tailors to the user's body."
	species_restricted = list(SPECIES_SKRELL)
	sprite_sheets = list(
		SPECIES_SKRELL = 'icons/mob/species/skrell/onmob_chest_rig_skrell.dmi'
	)
	allowed = list(
		/obj/item/gun,
		/obj/item/ammo_magazine,
		/obj/item/device/flashlight,
		/obj/item/tank,
		/obj/item/device/suit_cooling_unit
	)

/obj/item/clothing/head/helmet/space/rig/ert/skrell
	name = "skrellian recon hardsuit helmet"
	desc = "A powerful recon hardsuit with integrated power supply and atmosphere. It's impressive design perfectly tailors to the user's body."
	light_overlay = "helmet_light_dual"
	species_restricted = list(SPECIES_SKRELL)
	sprite_sheets = list(
		SPECIES_SKRELL = 'icons/mob/species/skrell/onmob_head_rig_skrell.dmi'
	)

/obj/item/clothing/shoes/magboots/rig/ert/skrell
	name = "skrellian recon hardsuit boots"
	desc = "A powerful recon hardsuit with integrated power supply and atmosphere. It's impressive design perfectly tailors to the user's body."
	species_restricted = list(SPECIES_SKRELL)
	sprite_sheets = list(
		SPECIES_SKRELL = 'icons/mob/species/skrell/onmob_feet_rig_skrell.dmi'
	)

/obj/item/clothing/gloves/rig/ert/skrell
	name = "skrellian recon hardsuit gloves"
	desc = "A powerful recon hardsuit with integrated power supply and atmosphere. It's impressive design perfectly tailors to the user's body."
	siemens_coefficient = 0
	species_restricted = list(SPECIES_SKRELL)
	sprite_sheets = list(
		SPECIES_SKRELL = 'icons/mob/species/skrell/onmob_hands_rig_skrell.dmi'
	)



//Skrell Baseline Suit
/obj/item/rig/skrell
	name = "skrellian recon hardsuit"
	desc = "A powerful recon hardsuit with integrated power supply and atmosphere. It's impressive design perfectly tailors to the user's body."
	icon_state = "skrell_standard_rig"
	item_state = null
	suit_type = "recon hardsuit"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)
	online_slowdown = 0.75
	offline_slowdown = 2
	equipment_overlay_icon = null
	air_type = /obj/item/tank/skrell
	cell_type = /obj/item/cell/skrell
	chest_type = /obj/item/clothing/suit/space/rig/ert/skrell
	helm_type = /obj/item/clothing/head/helmet/space/rig/ert/skrell
	boot_type = /obj/item/clothing/shoes/magboots/rig/ert/skrell
	glove_type = /obj/item/clothing/gloves/rig/ert/skrell
	update_visible_name = TRUE
	sprite_sheets = list(
		SPECIES_SKRELL = 'icons/mob/species/skrell/onmob_back_rig_skrell.dmi'
	)
	initial_modules = list(
		/obj/item/rig_module/vision/nvg,
		/obj/item/rig_module/chem_dispenser/skrell,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/clustertool/skrell
	)
	req_access = list("ACCESS_SKRELLSCOUT")

//Skrell Engineering Suit
/obj/item/rig/skrell/eng
	name = "skrellian engineering hardsuit"
	desc = "A powerful engineering hardsuit with integrated power supply and atmosphere. It's impressive design perfectly tailors to the user's body."
	icon_state = "skrell_eng_rig"
	initial_modules = list(
		/obj/item/rig_module/vision/nvg,
		/obj/item/rig_module/chem_dispenser/skrell,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/clustertool/skrell,
		/obj/item/rig_module/device/cable_coil/skrell,
		/obj/item/rig_module/device/multitool/skrell,
		/obj/item/rig_module/device/welder/skrell,
		/obj/item/rig_module/device/rcd
	)

//Skrell Medical Suit
/obj/item/rig/skrell/med
	name = "skrellian medical hardsuit"
	desc = "A powerful medical hardsuit with integrated power supply and atmosphere. It's impressive design perfectly tailors to the user's body."
	icon_state = "skrell_med_rig"
	initial_modules = list(
		/obj/item/rig_module/vision/nvg,
		/obj/item/rig_module/chem_dispenser/skrell,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/clustertool/skrell,
		/obj/item/rig_module/device/healthscanner,
		/obj/item/rig_module/device/defib,
		/obj/item/rig_module/chem_dispenser/injector
	)

//Skrell Combat Suit
/obj/item/rig/skrell/sec
	name = "skrellian combat hardsuit"
	desc = "A powerful combat hardsuit with integrated power supply and atmosphere. It's impressive design perfectly tailors to the user's body."
	icon_state = "skrell_standard_rig"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)
	initial_modules = list(
		/obj/item/rig_module/vision/nvg,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/clustertool/skrell,
		/obj/item/rig_module/chem_dispenser/skrell/combat,
		/obj/item/rig_module/device/flash
	)

//Skrell Command Suit
/obj/item/rig/skrell/cmd
	name = "skrellian command hardsuit"
	desc = "A powerful command hardsuit with integrated power supply and atmosphere. It's impressive design perfectly tailors to the user's body."
	icon_state = "skrell_com_rig"
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)
	initial_modules = list(
		/obj/item/rig_module/vision/nvg,
		/obj/item/rig_module/chem_dispenser/skrell,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/clustertool/skrell,
		/obj/item/rig_module/device/flash/advanced
	)



// Skrell medical dispensers
/obj/item/rig_module/chem_dispenser/skrell
	name = "skrellian medical injector"
	desc = "A sleek medical injector of skrellian design."
	interface_name = "skrellian medical injector"
	interface_desc = "A sleek medical injector of skrellian design."
	charges = list(
		list("tramadol",            "tramadol",            /datum/reagent/tramadol,      20),
		list("dexalinp",            "dexalinp",            /datum/reagent/dexalinp,      20),
		list("inaprovaline",        "inaprovaline",        /datum/reagent/inaprovaline,  20)
	)

// Skrell combat dispenser

/obj/item/rig_module/chem_dispenser/skrell/combat
	name = "skrellian combat injector"
	desc = "A sleek stimulant injector of skrellian design."
	interface_name = "skrellian combat injector"
	interface_desc = "A sleek combat injector of skrellian design."
	charges = list(
		list("tramadol",            "tramadol",            /datum/reagent/tramadol,      20),
		list("dexalinp",            "dexalinp",            /datum/reagent/dexalinp,      20),
		list("inaprovaline",        "inaprovaline",        /datum/reagent/inaprovaline,  20),
		list("synaptizine",         "synaptizine",         /datum/reagent/synaptizine,        20),
		list("hyperzine",           "hyperzine",           /datum/reagent/hyperzine,          20),
		list("oxycodone",           "oxycodone",           /datum/reagent/tramadol/oxycodone, 20),
		list("glucose",             "glucose",             /datum/reagent/nutriment/glucose,  20)
	)

//Skrell Oxygen Generator
/obj/item/tank/skrell
	name = "skrellian gas reactor"
	desc = "A skrellian gas processing plant that continuously synthesises oxygen."
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	var/charge_cost = 0.01
	var/refill_gas_type = GAS_OXYGEN
	var/gas_regen_amount = 1
	var/gas_regen_cap = 75

/obj/item/tank/skrell/Initialize()
	starting_pressure = list("[refill_gas_type]" = 6 * ONE_ATMOSPHERE)
	. = ..()

/obj/item/tank/skrell/Process()
	..()
	var/obj/item/rig/holder = loc
	if(air_contents.total_moles < gas_regen_cap && istype(holder) && holder.cell && holder.cell.use(charge_cost))
		air_contents.adjust_gas(refill_gas_type, gas_regen_amount)

//Skrell Cluster Tool

/obj/item/rig_module/device/clustertool/skrell
	name = "skrellian clustertool"

//More Skrell Modules to replace Mantid
/obj/item/rig_module/device/multitool/skrell
	name = "skrellian integrated multitool"

/obj/item/rig_module/device/cable_coil/skrell
	name = "skrellian cable extruder"

/obj/item/rig_module/device/welder/skrell
	name = "skrellian welding arm"
	desc = "An electrical cutting torch of Skrell design."
	interface_desc = "An electrical cutting torch of Skrell design."

// Self-charging power cell.
/obj/item/cell/skrell
	name = "skrellian microfusion cell"
	desc = "An impossibly tiny fusion power engine of Skrell design."
	maxcharge = 1500
	w_class = ITEM_SIZE_NORMAL
	var/recharge_amount = 12

/obj/item/cell/skrell/Initialize()
	START_PROCESSING(SSobj, src)
	. = ..()

/obj/item/cell/skrell/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/cell/skrell/Process()
	if(charge < maxcharge)
		give(recharge_amount)
