/singleton/shared_list/path/storage
	abstract_type = /singleton/shared_list/path/storage
	var/list/items = null

/// The 'default' list - small oxygen tanks, flashlights, and radios.						Use this category sparingly - nearly anything can hold them.
/singleton/shared_list/path/storage/emergency
	items = list(
		/obj/item/device/flashlight,
		/obj/item/device/radio,
		/obj/item/tank/oxygen_emergency,
		/obj/item/tank/oxygen_emergency_extended,
		/obj/item/tank/oxygen_emergency_double,
		/obj/item/tank/oxygen_scba,
		/obj/item/tank/nitrogen_emergency,
		/obj/item/tank/nitrogen_emergency_double,
		/obj/item/tank/air_sac
		)

/// Paperwork/formal stuff. Pens, papers, stamps, etc. Also includes forensics.				These are usually small. Equipment belt stuff.
/singleton/shared_list/path/storage/bureaucracy
	items = list(
		/obj/item/paper,
		/obj/item/photo,
		/obj/item/stamp,
		/obj/item/pen,
		/obj/item/device/megaphone,
		/obj/item/device/taperecorder,
		/obj/item/flame/lighter,
		/obj/item/taperoll/bureaucracy,
		/obj/item/storage/fancy/smokable,
		/obj/item/clothing/head/beret,
		/obj/item/clothing/head/soft,
		/obj/item/reagent_containers/spray/luminol,
		/obj/item/sample,
		/obj/item/storage/csi_markers,
		/obj/item/csi_marker,
		/obj/item/swabber,
		/obj/item/device/uv_light,
		/obj/item/modular_computer/pda,
		/obj/item/modular_computer/tablet,
		/obj/item/folder
		)

/// Most handheld engineering tools - screwdrivers, geiger counters, t-ray scanners, etc.	These are usually small. Standard toolbelt stuff.
/singleton/shared_list/path/storage/engineering
	items = list(
		/obj/item/device/geiger,
		/obj/item/inducer,
		/obj/item/device/multitool,
		/obj/item/device/t_scanner,
		/obj/item/device/scanner/gas,
		/obj/item/extinguisher,
		/obj/item/taperoll/engineering,
		/obj/item/taperoll/atmos,
		/obj/item/tape_roll,
		/obj/item/crowbar,
		/obj/item/screwdriver,
		/obj/item/swapper/power_drill,
		/obj/item/swapper/jaws_of_life,
		/obj/item/weldingtool,
		/obj/item/welder_tank,
		/obj/item/wirecutters,
		/obj/item/wrench,
		/obj/item/device/robotanalyzer,
		/obj/item/stack/cable_coil
		)

/// Anything handheld and medical - health scanners, syringes, pills, etc.					These are usually small. Medical belt stuff.
/singleton/shared_list/path/storage/medical
	items = list(
		/obj/item/bodybag,
		/obj/item/device/scanner/health,
		/obj/item/stack/medical,
		/obj/item/taperoll/medical,
		/obj/item/storage/med_pouch,
		/obj/item/storage/pill_bottle,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/glass/bottle,
		/obj/item/reagent_containers/hypospray,
		/obj/item/reagent_containers/ivbag,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/syringe
		)

/// Science-related gear. Xenoarch measuring tape, xenobotany scanners, GCSes, etc.			These should be small, or medium at most (plant/fossil bags).
/singleton/shared_list/path/storage/science
	items = list(
		/obj/item/device/gps,
		/obj/item/device/scanner,
		/obj/item/taperoll/research,
		/obj/item/material/minihoe,
		/obj/item/storage/plants,
		/obj/item/device/robotanalyzer,
		/obj/item/device/core_sampler,
		/obj/item/device/measuring_tape,
		/obj/item/storage/bag/fossils,
		/obj/item/device/ano_scanner,
		/obj/item/device/depth_scanner,
		/obj/item/pinpointer/radio,
		/obj/item/pickaxe/xeno,
		/obj/item/storage/excavation
		)

/// Defensive, less-lethal security items - flashes, pepperspray, warrants, etc.				These should be small, or medium at most (batons, helmets).
/singleton/shared_list/path/storage/security
	items = list(
		/obj/item/device/flash,
		/obj/item/device/holowarrant,
		/obj/item/device/hailer,
		/obj/item/handcuffs,
		/obj/item/taperoll/police,
		/obj/item/melee/baton,
		/obj/item/melee/telebaton,
		/obj/item/clothing/head/helmet,
		/obj/item/reagent_containers/spray/pepper
		)

/// Offensive combat items. Guns, grenades, ammo casings, magazines, etc.					These can be large (guns, including long arms).
/singleton/shared_list/path/storage/combat
	items = list(
		/obj/item/handcuffs,
		/obj/item/melee/baton,
		/obj/item/melee/telebaton,
		/obj/item/grenade,
		/obj/item/melee/energy/sword,
		/obj/item/clothing/head/helmet,
		/obj/item/ammo_casing,
		/obj/item/ammo_magazine,
		/obj/item/gun
		)

/// Oxygen tanks (small and large), suit coolers, inflatable briefcases.						These will often be large - they're for EVA suits only.
/singleton/shared_list/path/storage/eva
	items = list(
		/obj/item/tank,
		/obj/item/device/suit_cooling_unit,
		/obj/item/tape_roll,
		/obj/item/storage/briefcase/inflatable
		)