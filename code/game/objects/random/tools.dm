/obj/random/tool
	name = "random tool"
	icon_state = "tool-grey"
	spawn_nothing_percentage = 15
	has_postspawn = TRUE

/obj/random/tool/item_to_spawn()
	return pickweight(list(///obj/random/rare = 1,
				/obj/item/weapon/tool/screwdriver = 8,
				/obj/item/weapon/tool/screwdriver/electric = 2,
				/obj/item/weapon/tool/screwdriver/combi_driver = 1,
				/obj/item/weapon/tool/wirecutters = 8,
				/obj/item/weapon/tool/wirecutters/armature = 2,
				/obj/item/weapon/tool/weldingtool = 8,
				/obj/item/weapon/tool/weldingtool/advanced = 2,
				/obj/item/weapon/tool/omnitool = 0.5,
				/obj/item/weapon/tool/crowbar = 12,
				/obj/item/weapon/tool/crowbar/prybar  = 3,//Pretty uncommon
				/obj/item/weapon/tool/crowbar/red = 1,
				/obj/item/weapon/tool/crowbar/pneumatic = 2,
				/obj/item/weapon/tool/wrench = 8,
				/obj/item/weapon/tool/wrench/big_wrench = 2,
				/obj/item/weapon/tool/saw = 8,
				/obj/item/weapon/tool/saw/circular = 2,
				/obj/item/weapon/tool/saw/advanced_circular = 1,
				/obj/item/weapon/tool/saw/chain = 0.5,
				/obj/item/weapon/tool/shovel = 5,
				/obj/item/weapon/tool/shovel/spade = 2.5,
				/obj/item/weapon/tool/pickaxe = 2,
				/obj/item/weapon/tool/pickaxe/jackhammer = 1,
				/obj/item/weapon/tool/pickaxe/drill = 1,
				/obj/item/weapon/tool/pickaxe/diamonddrill = 0.5,
				/obj/item/weapon/tool/pickaxe/excavation = 1,
				/obj/item/weapon/tool/tape_roll = 12,
				/obj/item/weapon/tool/tape_roll/fiber = 2,
				/obj/item/weapon/storage/belt/utility = 5,
				/obj/item/weapon/storage/belt/utility/full = 1,
				/obj/item/clothing/gloves/insulated/cheap = 5,
				/obj/item/clothing/head/welding = 5,
				/obj/item/weapon/extinguisher = 5,
				/obj/item/device/t_scanner = 2,
				///obj/item/device/export_scanner = 2,
				/obj/item/device/antibody_scanner = 1,
				/obj/item/device/destTagger = 1,
				///obj/item/device/scanner/analyzer/plant_analyzer = 1,
				/obj/item/weapon/autopsy_scanner = 1,
				///obj/item/device/scanner/healthanalyzer = 3,
				///obj/item/device/scanner/mass_spectrometer = 1,
				/obj/item/device/robotanalyzer = 1,
				/obj/item/device/gps = 3,
				///obj/item/device/scanner/analyzer = 2,
				/obj/item/stack/cable_coil = 5,
				///obj/item/weapon/weldpack/canister = 2,
				///obj/item/weapon/packageWrap = 1,
				/obj/item/device/flash = 2,
				/obj/item/weapon/mop = 5,
				/obj/item/weapon/inflatable_dispenser = 3,
				/obj/item/weapon/grenade/chem_grenade/cleaner = 2,
				/obj/item/device/flashlight = 10,
				/obj/item/weapon/tank/jetpack/carbondioxide = 1.5,
				/obj/item/weapon/tank/jetpack/oxygen = 1,
				///obj/item/robot_parts/robot_component/jetpack = 0.75,
				///obj/random/voidsuit/damaged = 1.5,
				///obj/random/voidsuit = 0.5,
				///obj/random/pouch = 5,
				/obj/random/tool_upgrade = 25,
				/obj/random/lathe_disk = 10,
				///obj/random/rig_module = 5,
				///obj/random/mecha_equipment = 5
				/obj/item/stack/power_node = 5
				))


//Randomly spawned tools will often be in imperfect condition if they've been left lying out
/obj/random/tool/post_spawn(var/list/spawns)
	if (isturf(loc))
		for (var/obj/O in spawns)
			if (!istype(O, /obj/random) && prob(20))
				O.make_old()


/obj/random/tool/low_chance
	name = "low chance random tool"
	icon_state = "tool-grey-low"
	spawn_nothing_percentage = 60


/obj/random/tool/advanced
	name = "random advanced tool"

/obj/random/tool/advanced/item_to_spawn()
	return pickweight(list(
				/obj/item/weapon/tool/screwdriver/combi_driver = 3,
				/obj/item/weapon/tool/wirecutters/armature = 3,
				/obj/item/weapon/tool/omnitool = 2,
				/obj/item/weapon/tool/crowbar/pneumatic = 3,
				/obj/item/weapon/tool/wrench/big_wrench = 3,
				/obj/item/weapon/tool/weldingtool/advanced = 3,
				/obj/item/weapon/tool/saw/advanced_circular = 2,
				/obj/item/weapon/tool/saw/chain = 1,
				/obj/item/weapon/tool/pickaxe/diamonddrill = 2,
				/obj/item/weapon/tool/tape_roll/fiber = 2,
				/obj/item/stack/power_node = 2))

/obj/random/toolbox
	name = "random toolbox"
	icon_state = "box-green"

/obj/random/toolbox/item_to_spawn()
	return pickweight(list(/obj/item/weapon/storage/toolbox/mechanical = 3,
				/obj/item/weapon/storage/toolbox/electrical = 2,
				/obj/item/weapon/storage/toolbox/emergency = 1))

/obj/random/toolbox/low_chance
	name = "low chance random toolbox"
	icon_state = "box-green-low"
	spawn_nothing_percentage = 60



//Random tool upgrades
/obj/random/tool_upgrade
	name = "random tool upgrade"
/obj/random/tool_upgrade/item_to_spawn()
	return pickweight(list(
	/obj/item/weapon/tool_upgrade/reinforcement/stick = 1,
	/obj/item/weapon/tool_upgrade/reinforcement/heatsink = 1,
	/obj/item/weapon/tool_upgrade/reinforcement/plating = 1.5,
	/obj/item/weapon/tool_upgrade/reinforcement/guard = 0.75,
	/obj/item/weapon/tool_upgrade/productivity/ergonomic_grip = 1,
	/obj/item/weapon/tool_upgrade/productivity/ratchet = 1,
	/obj/item/weapon/tool_upgrade/productivity/red_paint = 0.75,
	/obj/item/weapon/tool_upgrade/productivity/whetstone = 0.5,
	/obj/item/weapon/tool_upgrade/productivity/diamond_blade = 0.25,
	/obj/item/weapon/tool_upgrade/productivity/oxyjet = 0.75,
	/obj/item/weapon/tool_upgrade/productivity/motor = 0.75,
	/obj/item/weapon/tool_upgrade/refinement/laserguide = 1,
	/obj/item/weapon/tool_upgrade/refinement/stabilized_grip = 1,
	/obj/item/weapon/tool_upgrade/refinement/magbit = 0.75,
	/obj/item/weapon/tool_upgrade/refinement/ported_barrel = 0.5,
	///obj/item/weapon/tool_upgrade/augment/cell_mount = 0.75,//Removed because this codebase only has one cell size
	/obj/item/weapon/tool_upgrade/augment/fuel_tank = 1,
	/obj/item/weapon/tool_upgrade/augment/expansion = 0.25,
	/obj/item/weapon/tool_upgrade/augment/spikes = 1,
	/obj/item/weapon/tool_upgrade/augment/dampener = 0.5,
	/obj/item/stack/power_node = 1))


//A fancier subset of the most desireable upgrades
/obj/random/tool_upgrade/rare/item_to_spawn()
	return pickweight(list(
	/obj/item/weapon/tool_upgrade/reinforcement/guard = 1,
	/obj/item/weapon/tool_upgrade/productivity/ergonomic_grip = 1,
	/obj/item/weapon/tool_upgrade/productivity/red_paint = 1,
	/obj/item/weapon/tool_upgrade/productivity/diamond_blade = 1,
	/obj/item/weapon/tool_upgrade/productivity/motor = 1,
	/obj/item/weapon/tool_upgrade/refinement/laserguide = 1,
	/obj/item/weapon/tool_upgrade/refinement/stabilized_grip = 1,
	/obj/item/weapon/tool_upgrade/augment/expansion = 1,
	/obj/item/weapon/tool_upgrade/augment/dampener = 0.5,
	/obj/item/stack/power_node = 1))