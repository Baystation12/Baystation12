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

//More Skrell Modules to replace Mantid

/obj/item/rig_module/device/multitool/skrell
	name = "skrellian integrated multitool"
	desc = "A limited-sentience integrated multitool capable of interfacing with any number of systems."
	interface_name = "multitool"
	interface_desc = "A limited-sentience integrated multitool capable of interfacing with any number of systems."
	device = /obj/item/device/multitool/skrell
	icon = 'icons/obj/tools/multitool.dmi'
	icon_state = "skrell_multitool"
	usable = FALSE
	selectable = TRUE

/obj/item/rig_module/device/multitool/skrell/IsMultitool()
	if(holder)
		return TRUE
	else
		return FALSE

/obj/item/rig_module/device/cable_coil/skrell
	name = "skrellian cable extruder"
	desc = "A cable nanofabricator of Skrellian design."
	interface_name = "cable fabricator"
	interface_desc = "A cable nanofabricator of Skrellian design."
	device = /obj/item/stack/cable_coil/fabricator
	icon = 'icons/obj/machines/power/power_cond_white.dmi'
	icon_state = "coil"
	usable = FALSE
	selectable = TRUE

/obj/item/rig_module/device/welder/skrell
	name = "skrellian welding arm"
	desc = "An electrical cutting torch of Skrellian design."
	interface_name = "welding arm"
	interface_desc = "An electrical cutting torch of Skrellian design."
	icon = 'icons/obj/tools/welder.dmi'
	icon_state = "skrell_welder1"
	engage_string = "Toggle Welder"
	device = /obj/item/weldingtool/electric
	usable = TRUE
	selectable = TRUE

/obj/item/rig_module/device/clustertool/skrell
	name = "skrellian clustertool"
	desc = "A complex assembly of self-guiding, modular heads capable of performing most manual tasks."
	interface_name = "modular clustertool"
	interface_desc = "A complex assembly of self-guiding, modular heads capable of performing most manual tasks."
	icon = 'icons/obj/tools/swapper.dmi'
	icon_state = "clustertool"
	engage_string = "Select Mode"
	device = /obj/item/clustertool
	usable = TRUE
	selectable = TRUE

/obj/item/rig_module/device/clustertool/IsWrench()
	return isWrench(device)

/obj/item/rig_module/device/clustertool/IsWirecutter()
	return isWirecutter(device)

/obj/item/rig_module/device/clustertool/IsScrewdriver()
	return isScrewdriver(device)

/obj/item/rig_module/device/clustertool/IsCrowbar()
	return isCrowbar(device)

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

/obj/item/clustertool
	name = "alien clustertool"
	desc = "A bewilderingly complex knot of tool heads."
	icon = 'icons/obj/tools/swapper.dmi'
	icon_state = "clustertool"
	w_class = ITEM_SIZE_SMALL

	var/tool_mode
	var/list/tool_modes = list("wrench", "wirecutters", "crowbar", "screwdriver")

/obj/item/clustertool/attack_self(mob/user)
	var/new_index = _list_find(tool_modes, tool_mode) + 1
	if(new_index > length(tool_modes))
		new_index = 1
	tool_mode = tool_modes[new_index]
	name = "[initial(name)] ([tool_mode])"
	playsound(user, 'sound/machines/bolts_down.ogg', 10)
	to_chat(user, SPAN_NOTICE("You select the [tool_mode] attachment."))
	update_icon()

/obj/item/clustertool/on_update_icon()
	icon_state = "[initial(icon_state)]-[tool_mode]"

/obj/item/clustertool/Initialize()
	. = ..()
	tool_mode = tool_modes[1]
	name = "[initial(name)] ([tool_mode])"
	update_icon()

/obj/item/clustertool/IsWrench()
	return tool_mode == "wrench"

/obj/item/clustertool/IsWirecutter()
	return tool_mode == "wirecutters"

/obj/item/clustertool/IsScrewdriver()
	return tool_mode == "screwdriver"

/obj/item/clustertool/IsCrowbar()
	return tool_mode == "crowbar"

/obj/item/device/multitool/skrell
	name = "skrellian multitool"
	desc = "An extreme sophisticated microcomputer capable of interfacing with practically any system."
	icon = 'icons/obj/tools/multitool.dmi'
	icon_state = "skrell_multitool"
