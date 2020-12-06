/datum/design/item/mechfab
	build_type = MECHFAB
	category = "Misc"
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/mechfab/robot
	category = "Robot"

//if the fabricator is a exosuit fab pass the manufacturer info over to the robot part constructor
/datum/design/item/mechfab/robot/Fabricate(var/newloc, var/fabricator)
	if(istype(fabricator, /obj/machinery/robotics_fabricator))
		var/obj/machinery/robotics_fabricator/mechfab = fabricator
		return new build_path(newloc, mechfab.manufacturer)
	return ..()

/datum/design/item/mechfab/robot/exoskeleton_ground
	name = "Robot frame, standard"
	id = "robot_exoskeleton"
	build_path = /obj/item/robot_parts/robot_suit
	time = 50
	materials = list(MATERIAL_STEEL = 50000)

/datum/design/item/mechfab/robot/exoskeleton_flying
	name = "Robot frame, hover"
	id = "robot_exoskeleton_hover"
	build_path = /obj/item/robot_parts/robot_suit/flyer
	time = 50
	materials = list(MATERIAL_STEEL = 50000)

/datum/design/item/mechfab/robot/torso
	name = "Robot torso"
	id = "robot_torso"
	build_path = /obj/item/robot_parts/chest
	time = 35
	materials = list(MATERIAL_STEEL = 40000)

/datum/design/item/mechfab/robot/head
	name = "Robot head"
	id = "robot_head"
	build_path = /obj/item/robot_parts/head
	time = 35
	materials = list(MATERIAL_STEEL = 25000)

/datum/design/item/mechfab/robot/l_arm
	name = "Robot left arm"
	id = "robot_l_arm"
	build_path = /obj/item/robot_parts/l_arm
	time = 20
	materials = list(MATERIAL_STEEL = 18000)

/datum/design/item/mechfab/robot/r_arm
	name = "Robot right arm"
	id = "robot_r_arm"
	build_path = /obj/item/robot_parts/r_arm
	time = 20
	materials = list(MATERIAL_STEEL = 18000)

/datum/design/item/mechfab/robot/l_leg
	name = "Robot left leg"
	id = "robot_l_leg"
	build_path = /obj/item/robot_parts/l_leg
	time = 20
	materials = list(MATERIAL_STEEL = 15000)

/datum/design/item/mechfab/robot/r_leg
	name = "Robot right leg"
	id = "robot_r_leg"
	build_path = /obj/item/robot_parts/r_leg
	time = 20
	materials = list(MATERIAL_STEEL = 15000)

/datum/design/item/mechfab/robot/component
	time = 20
	materials = list(MATERIAL_STEEL = 5000)

/datum/design/item/mechfab/robot/component/binary_communication_device
	name = "Binary communication device"
	id = "binary_communication_device"
	build_path = /obj/item/robot_parts/robot_component/binary_communication_device

/datum/design/item/mechfab/robot/component/radio
	name = "Radio"
	id = "radio"
	build_path = /obj/item/robot_parts/robot_component/radio

/datum/design/item/mechfab/robot/component/actuator
	name = "Actuator"
	id = "actuator"
	build_path = /obj/item/robot_parts/robot_component/actuator

/datum/design/item/mechfab/robot/component/diagnosis_unit
	name = "Diagnosis unit"
	id = "diagnosis_unit"
	build_path = /obj/item/robot_parts/robot_component/diagnosis_unit

/datum/design/item/mechfab/robot/component/camera
	name = "Camera"
	id = "camera"
	build_path = /obj/item/robot_parts/robot_component/camera

/datum/design/item/mechfab/robot/component/armour
	name = "Armour plating"
	id = "armour"
	build_path = /obj/item/robot_parts/robot_component/armour

/datum/design/item/mechfab/robot/component/armour/light
	name = "Light-weight armour plating"
	id = "light_armour"
	build_path = /obj/item/robot_parts/robot_component/armour/light
	// Half the armor, half the cost
	time = 10
	materials = list(MATERIAL_STEEL = 2500)

/datum/design/item/mechfab/exosuit
	name = "exosuit frame"
	id = "mech_frame"
	build_path = /obj/structure/heavy_vehicle_frame
	time = 70
	materials = list(MATERIAL_STEEL = 20000)
	category = "Exosuits"

/datum/design/item/mechfab/exosuit/basic_armour
	name = "basic exosuit armour"
	id = "mech_armour_basic"
	build_path = /obj/item/robot_parts/robot_component/armour/exosuit
	time = 30
	materials = list(MATERIAL_STEEL = 7500)

/datum/design/item/mechfab/exosuit/radproof_armour
	name = "radiation-proof exosuit armour"
	id = "mech_armour_radproof"
	build_path = /obj/item/robot_parts/robot_component/armour/exosuit/radproof
	time = 50
	req_tech = list(TECH_MATERIAL = 2)
	materials = list(MATERIAL_STEEL = 12500)

/datum/design/item/mechfab/exosuit/em_armour
	name = "EM-shielded exosuit armour"
	id = "mech_armour_em"
	build_path = /obj/item/robot_parts/robot_component/armour/exosuit/em
	time = 50
	req_tech = list(TECH_MATERIAL = 2)
	materials = list(MATERIAL_STEEL = 12500, MATERIAL_SILVER = 1000)

/datum/design/item/mechfab/exosuit/combat_armour
	name = "Combat exosuit armour"
	id = "mech_armour_combat"
	build_path = /obj/item/robot_parts/robot_component/armour/exosuit/combat
	time = 50
	req_tech = list(TECH_MATERIAL = 4)
	materials = list(MATERIAL_STEEL = 20000, MATERIAL_DIAMOND = 5000)

/datum/design/item/mechfab/exosuit/control_module
	name = "exosuit control module"
	id = "mech_control_module"
	build_path = /obj/item/mech_component/control_module
	time = 15
	materials = list(MATERIAL_STEEL = 5000)

/datum/design/item/mechfab/exosuit/combat_head
	name = "combat exosuit sensors"
	id = "combat_head"
	time = 30
	materials = list(MATERIAL_STEEL = 10000)
	build_path = /obj/item/mech_component/sensors/combat
	req_tech = list(TECH_COMBAT = 2)

/datum/design/item/mechfab/exosuit/combat_torso
	name = "combat exosuit chassis"
	id = "combat_body"
	time = 60
	materials = list(MATERIAL_STEEL = 45000)
	build_path = /obj/item/mech_component/chassis/combat
	req_tech = list(TECH_COMBAT = 2)

/datum/design/item/mechfab/exosuit/combat_arms
	name = "combat exosuit manipulators"
	id = "combat_arms"
	time = 30
	materials = list(MATERIAL_STEEL = 15000)
	build_path = /obj/item/mech_component/manipulators/combat
	req_tech = list(TECH_COMBAT = 2)

/datum/design/item/mechfab/exosuit/combat_legs
	name = "combat exosuit motivators"
	id = "combat_legs"
	time = 30
	materials = list(MATERIAL_STEEL = 15000)
	build_path = /obj/item/mech_component/propulsion/combat
	req_tech = list(TECH_COMBAT = 2)

/datum/design/item/mechfab/exosuit/powerloader_head
	name = "power loader sensors"
	id = "powerloader_head"
	build_path = /obj/item/mech_component/sensors/powerloader
	time = 15
	materials = list(MATERIAL_STEEL = 5000)

/datum/design/item/mechfab/exosuit/powerloader_torso
	name = "power loader chassis"
	id = "powerloader_body"
	build_path = /obj/item/mech_component/chassis/powerloader
	time = 50
	materials = list(MATERIAL_STEEL = 20000)

/datum/design/item/mechfab/exosuit/powerloader_arms
	name = "power loader manipulators"
	id = "powerloader_arms"
	build_path = /obj/item/mech_component/manipulators/powerloader
	time = 30
	materials = list(MATERIAL_STEEL = 6000)

/datum/design/item/mechfab/exosuit/powerloader_legs
	name = "power loader motivators"
	id = "powerloader_legs"
	build_path = /obj/item/mech_component/propulsion/powerloader
	time = 30
	materials = list(MATERIAL_STEEL = 6000)

/datum/design/item/mechfab/exosuit/light_head
	name = "light exosuit sensors"
	id = "light_head"
	time = 20
	materials = list(MATERIAL_STEEL = 8000)
	build_path = /obj/item/mech_component/sensors/light
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/mechfab/exosuit/light_torso
	name = "light exosuit chassis"
	id = "light_body"
	time = 40
	materials = list(MATERIAL_STEEL = 30000)
	build_path = /obj/item/mech_component/chassis/light
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/mechfab/exosuit/light_arms
	name = "light exosuit manipulators"
	id = "light_arms"
	time = 20
	materials = list(MATERIAL_STEEL = 10000)
	build_path = /obj/item/mech_component/manipulators/light
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/mechfab/exosuit/light_legs
	name = "light exosuit motivators"
	id = "light_legs"
	time = 25
	materials = list(MATERIAL_STEEL = 10000)
	build_path = /obj/item/mech_component/propulsion/light
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/mechfab/exosuit/heavy_head
	name = "heavy exosuit sensors"
	id = "heavy_head"
	time = 35
	materials = list(MATERIAL_STEEL = 16000)
	build_path = /obj/item/mech_component/sensors/heavy
	req_tech = list(TECH_COMBAT = 2)

/datum/design/item/mechfab/exosuit/heavy_torso
	name = "heavy exosuit chassis"
	id = "heavy_body"
	time = 75
	materials = list(MATERIAL_STEEL = 70000, MATERIAL_URANIUM = 10000)
	build_path = /obj/item/mech_component/chassis/heavy

/datum/design/item/mechfab/exosuit/heavy_arms
	name = "heavy exosuit manipulators"
	id = "heavy_arms"
	time = 35
	materials = list(MATERIAL_STEEL = 20000)
	build_path = /obj/item/mech_component/manipulators/heavy

/datum/design/item/mechfab/exosuit/heavy_legs
	name = "heavy exosuit motivators"
	id = "heavy_legs"
	time = 35
	materials = list(MATERIAL_STEEL = 20000)
	build_path = /obj/item/mech_component/propulsion/heavy

/datum/design/item/mechfab/exosuit/spider
	name = "quadruped motivators"
	id = "quad_legs"
	time = 20
	materials = list(MATERIAL_STEEL = 12000)
	build_path = /obj/item/mech_component/propulsion/spider
	req_tech = list(TECH_ENGINEERING = 2)

/datum/design/item/mechfab/exosuit/track
	name = "armored treads"
	id = "treads"
	time = 35
	materials = list(MATERIAL_STEEL = 25000)
	build_path = /obj/item/mech_component/propulsion/tracks
	req_tech = list(TECH_MATERIAL = 4)

/datum/design/item/mechfab/exosuit/sphere_torso
	name = "spherical chassis"
	id = "sphere_body"
	build_path = /obj/item/mech_component/chassis/pod
	time = 50
	materials = list(MATERIAL_STEEL = 18000)

/datum/design/item/robot_upgrade
	build_type = MECHFAB
	time = 12
	materials = list(MATERIAL_STEEL = 10000)
	category = "Cyborg Upgrade Modules"

/datum/design/item/robot_upgrade/rename
	name = "Rename module"
	desc = "Used to rename a cyborg."
	id = "borg_rename_module"
	build_path = /obj/item/borg/upgrade/rename

/datum/design/item/robot_upgrade/reset
	name = "Reset module"
	desc = "Used to reset a cyborg's module. Destroys any other upgrades applied to the robot."
	id = "borg_reset_module"
	build_path = /obj/item/borg/upgrade/reset

/datum/design/item/robot_upgrade/floodlight
	name = "Floodlight module"
	desc = "Used to boost cyborg's integrated light intensity."
	id = "borg_floodlight_module"
	build_path = /obj/item/borg/upgrade/floodlight

/datum/design/item/robot_upgrade/restart
	name = "Emergency restart module"
	desc = "Used to force a restart of a disabled-but-repaired robot, bringing it back online."
	id = "borg_restart_module"
	materials = list(MATERIAL_STEEL = 60000, MATERIAL_GLASS = 5000)
	build_path = /obj/item/borg/upgrade/restart

/datum/design/item/robot_upgrade/vtec
	name = "VTEC module"
	desc = "Used to kick in a robot's VTEC systems, increasing their speed."
	id = "borg_vtec_module"
	materials = list(MATERIAL_STEEL = 80000, MATERIAL_GLASS = 6000, MATERIAL_GOLD = 5000)
	build_path = /obj/item/borg/upgrade/vtec

/datum/design/item/robot_upgrade/weaponcooler
	name = "Rapid weapon cooling module"
	desc = "Used to cool a mounted energy gun, increasing the potential current in it and thus its recharge rate."
	id = "borg_taser_module"
	materials = list(MATERIAL_STEEL = 80000, MATERIAL_GLASS = 6000, MATERIAL_GOLD = 2000, MATERIAL_DIAMOND = 500)
	build_path = /obj/item/borg/upgrade/weaponcooler

/datum/design/item/robot_upgrade/jetpack
	name = "Jetpack module"
	desc = "A carbon dioxide jetpack suitable for low-gravity mining operations."
	id = "borg_jetpack_module"
	materials = list(MATERIAL_STEEL = 10000, MATERIAL_PHORON = 15000, MATERIAL_URANIUM = 20000)
	build_path = /obj/item/borg/upgrade/jetpack

/datum/design/item/robot_upgrade/rcd
	name = "RCD module"
	desc = "A rapid construction device module for use during construction operations."
	id = "borg_rcd_module"
	materials = list(MATERIAL_STEEL = 25000, MATERIAL_PHORON = 10000, MATERIAL_GOLD = 1000, MATERIAL_SILVER = 1000)
	build_path = /obj/item/borg/upgrade/rcd

/datum/design/item/robot_upgrade/syndicate
	name = "Illegal upgrade"
	desc = "Allows for the construction of lethal upgrades for cyborgs."
	id = "borg_syndicate_module"
	req_tech = list(TECH_COMBAT = 4, TECH_ESOTERIC = 3)
	materials = list(MATERIAL_STEEL = 10000, MATERIAL_GLASS = 15000, MATERIAL_DIAMOND = 10000)
	build_path = /obj/item/borg/upgrade/syndicate

/datum/design/item/exosuit
	build_type = MECHFAB
	category = "Exosuit Equipment"
	time = 10
	materials = list(MATERIAL_STEEL = 10000)

/datum/design/item/exosuit/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a [item_name] for installation in an exosuit hardpoint."

/datum/design/item/exosuit/hydraulic_clamp
	name = "hydraulic clamp"
	id = "hydraulic_clamp"
	build_path = /obj/item/mech_equipment/clamp

/datum/design/item/exosuit/gravity_catapult
	name = "gravity catapult"
	id = "gravity_catapult"
	build_path = /obj/item/mech_equipment/catapult

/datum/design/item/exosuit/drill
	name = "drill"
	id = "mech_drill"
	build_path = /obj/item/mech_equipment/drill

/datum/design/item/exosuit/taser
	name = "mounted electrolaser"
	id = "mech_taser"
	req_tech = list(TECH_COMBAT = 1)
	build_path = /obj/item/mech_equipment/mounted_system/taser

/datum/design/item/exosuit/weapon/plasma
	name = "mounted plasma cutter"
	id = "mech_plasma"
	materials = list(MATERIAL_STEEL = 20000)
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	build_path = /obj/item/mech_equipment/mounted_system/taser/plasma

/datum/design/item/exosuit/weapon/ion
	name = "mounted ion rifle"
	id = "mech_ion"
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mech_equipment/mounted_system/taser/ion

/datum/design/item/exosuit/weapon/laser
	name = "mounted laser gun"
	id = "mech_laser"
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mech_equipment/mounted_system/taser/laser

/datum/design/item/exosuit/rcd
	name = "RCD"
	id = "mech_rcd"
	time = 90
	materials = list(MATERIAL_STEEL = 30000, MATERIAL_PHORON = 25000, MATERIAL_SILVER = 15000, MATERIAL_GOLD = 15000)
	req_tech = list(TECH_MATERIAL = 4, TECH_BLUESPACE = 3, TECH_MAGNET = 4, TECH_POWER = 4, TECH_ENGINEERING = 4)
	build_path = /obj/item/mech_equipment/mounted_system/rcd

/datum/design/item/exosuit/floodlight
	name = "floodlight"
	id = "mech_floodlight"
	req_tech = list(TECH_ENGINEERING = 1)
	build_path = /obj/item/mech_equipment/light

/datum/design/item/exosuit/sleeper
	name = "mounted sleeper"
	id   = "mech_sleeper"
	build_path = /obj/item/mech_equipment/sleeper

/datum/design/item/exosuit/extinguisher
	name = "mounted extinguisher"
	id   = "mech_extinguisher"
	build_path = /obj/item/mech_equipment/mounted_system/extinguisher

/datum/design/item/exosuit/mechshields
	name = "energy shield drone"
	id = "mech_shield"
	time = 90
	materials = list(MATERIAL_STEEL = 20000, MATERIAL_SILVER = 12000, MATERIAL_GOLD = 12000)
	req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 4, TECH_POWER = 4, TECH_COMBAT = 2)
	build_path = /obj/item/mech_equipment/shields
// End mechs.

/datum/design/item/synthetic_flash
	name = "Synthetic flash"
	id = "sflash"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	build_type = MECHFAB
	materials = list(MATERIAL_STEEL = 750, MATERIAL_GLASS = 750)
	build_path = /obj/item/device/flash/synthetic
	category = "Misc"

//Augments, son
/datum/design/item/mechfab/augment
	category = "Augments"

/datum/design/item/mechfab/augment/armblade
	name = "Armblade"
	build_path = /obj/item/organ/internal/augment/active/simple/armblade
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 750)
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2, TECH_MATERIAL = 4, TECH_BIO = 3)
	id = "augment_blade"

/datum/design/item/mechfab/augment/armblade/wolverine
	name = "Cyberclaws"
	build_path = /obj/item/organ/internal/augment/active/simple/wolverine
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "diamond" = 250)
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 4, TECH_MATERIAL = 4, TECH_BIO = 3)
	id = "augment_wolverine"

/datum/design/item/mechfab/augment/engineering
	name = "Engineering toolset"
	build_path = /obj/item/organ/internal/augment/active/polytool/engineer
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "glass" = 1000)
	id = "augment_toolset_engineering"

/datum/design/item/mechfab/augment/surgery
	name = "Surgical toolset"
	build_path = /obj/item/organ/internal/augment/active/polytool/surgical
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 2000)
	id = "augment_toolset_surgery"

/datum/design/item/mechfab/augment/reflex
	name = "Synapse interceptors"
	build_path = /obj/item/organ/internal/augment/boost/reflex
	materials = list(DEFAULT_WALL_MATERIAL = 750, "glass" = 750, "silver" = 100)
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 4, TECH_BIO = 4, TECH_MAGNET = 5)
	id = "augment_booster_reflex"

/datum/design/item/mechfab/augment/shooting
	name = "Gunnery booster"
	build_path = /obj/item/organ/internal/augment/boost/shooting
	materials = list(DEFAULT_WALL_MATERIAL = 750, "glass" = 750, "silver" = 100)
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 5, TECH_BIO = 4)
	id = "augment_booster_gunnery"

/datum/design/item/mechfab/augment/muscle
	name = "Mechanical muscles"
	build_path = /obj/item/organ/internal/augment/boost/muscle
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000)
	id = "augment_booster_muscles"

/datum/design/item/mechfab/augment/armor
	name = "Subdermal armor"
	build_path = /obj/item/organ/internal/augment/armor
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "glass" = 750)
	id = "augment_armor"

/datum/design/item/mechfab/augment/nanounit
	name = "Nanite MCU"
	build_path = /obj/item/organ/internal/augment/active/nanounit
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000, "gold" = 100, "uranium" = 500)
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 5, TECH_BIO = 5, TECH_ENGINEERING = 5)
	id = "augment_nanounit"

/datum/design/item/mechfab/augment/circuit
	name = "Integrated circuit frame"
	build_path = /obj/item/organ/internal/augment/active/simple/circuit
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	id = "augment_circuitry"

/datum/design/item/mechfab/rig/zero
	category = "Hardsuits"
	name = "Null suit control module"
	build_path = /obj/item/weapon/rig/zero
	materials = list(DEFAULT_WALL_MATERIAL = 30000, "glass" = 5000, "silver" = 1000)
	id = "null _suit"
	time = 120