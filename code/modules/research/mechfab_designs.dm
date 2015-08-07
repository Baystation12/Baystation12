/datum/design/item/mechfab
	build_type = MECHFAB
	category = "Misc"

/datum/design/item/mechfab/robot
	category = "Robot"
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/mechfab/robot/exoskeleton
	name = "Robot Exoskeleton"
	id = "robot_exoskeleton"
	build_path = /obj/item/robot_parts/robot_suit
	time = 50
	materials = list(DEFAULT_WALL_MATERIAL = 50000)

/datum/design/item/mechfab/robot/torso
	name = "Robot Torso"
	id = "robot_torso"
	build_path = /obj/item/robot_parts/chest
	time = 35
	materials = list(DEFAULT_WALL_MATERIAL = 40000)

/datum/design/item/mechfab/robot/head
	name = "Robot Head"
	id = "robot_head"
	build_path = /obj/item/robot_parts/head
	time = 35
	materials = list(DEFAULT_WALL_MATERIAL = 25000)

/*
	var/list/part_sets = list( //set names must be unique
	"Robot"=list(
						/obj/item/robot_parts/robot_suit,
						/obj/item/robot_parts/chest,
						/obj/item/robot_parts/head,
						/obj/item/robot_parts/l_arm,
						/obj/item/robot_parts/r_arm,
						/obj/item/robot_parts/l_leg,
						/obj/item/robot_parts/r_leg,
						/obj/item/robot_parts/robot_component/binary_communication_device,
						/obj/item/robot_parts/robot_component/radio,
						/obj/item/robot_parts/robot_component/actuator,
						/obj/item/robot_parts/robot_component/diagnosis_unit,
						/obj/item/robot_parts/robot_component/camera,
						/obj/item/robot_parts/robot_component/armour
					),
	"Ripley"=list(
						/obj/item/mecha_parts/chassis/ripley,
						/obj/item/mecha_parts/part/ripley_torso,
						/obj/item/mecha_parts/part/ripley_left_arm,
						/obj/item/mecha_parts/part/ripley_right_arm,
						/obj/item/mecha_parts/part/ripley_left_leg,
						/obj/item/mecha_parts/part/ripley_right_leg
					),
	"Odysseus"=list(
						/obj/item/mecha_parts/chassis/odysseus,
						/obj/item/mecha_parts/part/odysseus_torso,
						/obj/item/mecha_parts/part/odysseus_head,
						/obj/item/mecha_parts/part/odysseus_left_arm,
						/obj/item/mecha_parts/part/odysseus_right_arm,
						/obj/item/mecha_parts/part/odysseus_left_leg,
						/obj/item/mecha_parts/part/odysseus_right_leg
					),

	"Gygax"=list(
						/obj/item/mecha_parts/chassis/gygax,
						/obj/item/mecha_parts/part/gygax_torso,
						/obj/item/mecha_parts/part/gygax_head,
						/obj/item/mecha_parts/part/gygax_left_arm,
						/obj/item/mecha_parts/part/gygax_right_arm,
						/obj/item/mecha_parts/part/gygax_left_leg,
						/obj/item/mecha_parts/part/gygax_right_leg,
						/obj/item/mecha_parts/part/gygax_armour
					),
	"Durand"=list(
						/obj/item/mecha_parts/chassis/durand,
						/obj/item/mecha_parts/part/durand_torso,
						/obj/item/mecha_parts/part/durand_head,
						/obj/item/mecha_parts/part/durand_left_arm,
						/obj/item/mecha_parts/part/durand_right_arm,
						/obj/item/mecha_parts/part/durand_left_leg,
						/obj/item/mecha_parts/part/durand_right_leg,
						/obj/item/mecha_parts/part/durand_armour
					),
	"Exosuit Equipment"=list(
						/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp,
						/obj/item/mecha_parts/mecha_equipment/tool/drill,
						/obj/item/mecha_parts/mecha_equipment/tool/extinguisher,
						/obj/item/mecha_parts/mecha_equipment/tool/cable_layer,
						/obj/item/mecha_parts/mecha_equipment/tool/sleeper,
						/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun,
						/obj/item/mecha_parts/mecha_equipment/tool/passenger,
						/obj/item/mecha_parts/chassis/firefighter,
						///obj/item/mecha_parts/mecha_equipment/repair_droid,
						/obj/item/mecha_parts/mecha_equipment/generator,
						///obj/item/mecha_parts/mecha_equipment/jetpack, //TODO MECHA JETPACK SPRITE MISSING
						/obj/item/mecha_parts/mecha_equipment/weapon/energy/taser,
						/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg
						),

	"Robotic Upgrade Modules" = list(
						/obj/item/borg/upgrade/reset,
						/obj/item/borg/upgrade/rename,
						/obj/item/borg/upgrade/restart,
						/obj/item/borg/upgrade/vtec,
						/obj/item/borg/upgrade/tasercooler,
						/obj/item/borg/upgrade/jetpack
						),

	"Misc"=list(/obj/item/mecha_parts/mecha_tracking)
	)
	*/


/datum/design/item/mecha
	build_type = MECHFAB
	req_tech = list(TECH_COMBAT = 3)
	category = "Exosuit Equipment"

/datum/design/item/mecha/AssembleDesignName()
	..()
	name = "Exosuit module design ([item_name])"

/datum/design/item/mecha/weapon/AssembleDesignName()
	..()
	name = "Exosuit weapon design ([item_name])"

/datum/design/item/mecha/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a '[item_name]' exosuit module."

// *** Weapon modules
/datum/design/item/mecha/weapon/scattershot
	id = "mech_scattershot"
	req_tech = list(TECH_COMBAT = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot

/datum/design/item/mecha/weapon/laser
	id = "mech_laser"
	req_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser

/datum/design/item/mecha/weapon/laser_rigged
	desc = "Allows for the construction of a welder-laser assembly package for non-combat exosuits."
	id = "mech_laser_rigged"
	req_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/riggedlaser

/datum/design/item/mecha/weapon/laser_heavy
	id = "mech_laser_heavy"
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy

/datum/design/item/mecha/weapon/ion
	id = "mech_ion"
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/ion

/datum/design/item/mecha/weapon/grenade_launcher
	id = "mech_grenade_launcher"
	req_tech = list(TECH_COMBAT = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flashbang

/datum/design/item/mecha/weapon/clusterbang_launcher
	desc = "A weapon that violates the Geneva Convention at 6 rounds per minute."
	id = "clusterbang_launcher"
	req_tech = list(TECH_COMBAT= 5, TECH_MATERIAL = 5, TECH_ILLEGAL = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flashbang/clusterbang/limited

// *** Nonweapon modules
/datum/design/item/mecha/wormhole_gen
	desc = "An exosuit module that can generate small quasi-stable wormholes."
	id = "mech_wormhole_gen"
	req_tech = list(TECH_BLUESPACE = 3, TECH_MAGNET = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/wormhole_generator

/datum/design/item/mecha/teleporter
	desc = "An exosuit module that allows teleportation to any position in view."
	id = "mech_teleporter"
	req_tech = list(TECH_BLUESPACE = 10, TECH_MAGNET = 5)
	build_path = /obj/item/mecha_parts/mecha_equipment/teleporter

/datum/design/item/mecha/rcd
	desc = "An exosuit-mounted rapid construction device."
	id = "mech_rcd"
	req_tech = list(TECH_MATERIAL = 4, TECH_BLUESPACE = 3, TECH_MAGNET = 4, TECH_POWER=4, TECH_ENGINERING = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/rcd

/datum/design/item/mecha/gravcatapult
	desc = "An exosuit-mounted gravitational catapult."
	id = "mech_gravcatapult"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MAGNET = 3, TECH_ENGINERING = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/gravcatapult

/datum/design/item/mecha/repair_droid
	desc = "Automated repair droid, exosuits' best companion. BEEP BOOP"
	id = "mech_repair_droid"
	req_tech = list(TECH_MAGNET = 3, TECH_DATA = 3, TECH_ENGINERING = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/repair_droid

/datum/design/item/mecha/phoron_generator
	desc = "Exosuit-mounted phoron generator."
	id = "mech_phoron_generator"
	req_tech = list(TECH_PHORON = 2, TECH_POWER= 2, TECH_ENGINERING = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/generator

/datum/design/item/mecha/energy_relay
	id = "mech_energy_relay"
	req_tech = list(TECH_MAGNET = 4, TECH_POWER = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/tesla_energy_relay

/datum/design/item/mecha/ccw_armor
	desc = "Exosuit close-combat armor booster."
	id = "mech_ccw_armor"
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/anticcw_armor_booster

/datum/design/item/mecha/proj_armor
	desc = "Exosuit projectile armor booster."
	id = "mech_proj_armor"
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 5, TECH_ENGINERING=3)
	build_path = /obj/item/mecha_parts/mecha_equipment/antiproj_armor_booster

/datum/design/item/mecha/syringe_gun
	desc = "Exosuit-mounted syringe gun and chemical synthesizer."
	id = "mech_syringe_gun"
	req_tech = list(TECH_MATERIAL = 3, TECH_BIO=4, TECH_MAGNET=4, TECH_DATA=3)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/syringe_gun

/datum/design/item/mecha/diamond_drill
	desc = "A diamond version of the exosuit drill. It's harder, better, faster, stronger."
	id = "mech_diamond_drill"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINERING = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/drill/diamonddrill

/datum/design/item/mecha/generator_nuclear
	desc = "Exosuit-held nuclear reactor. Converts uranium and everyone's health to energy."
	id = "mech_generator_nuclear"
	req_tech = list(TECH_POWER= 3, TECH_ENGINERING = 3, TECH_MATERIAL = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/generator/nuclear

/datum/design/item/synthetic_flash
	id = "sflash"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	build_type = MECHFAB
	materials = list("metal" = 750, "glass" = 750)
	build_path = /obj/item/device/flash/synthetic
	category = "Misc"

/datum/design/item/borg_syndicate_module
	name = "Cyborg lethal weapons upgrade"
	desc = "Allows for the construction of lethal upgrades for cyborgs."
	id = "borg_syndicate_module"
	build_type = MECHFAB
	req_tech = list(TECH_COMBAT = 4, TECH_ILLEGAL = 3)
	build_path = /obj/item/borg/upgrade/syndicate
	category = "Cyborg Upgrade Modules"