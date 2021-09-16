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

/datum/design/item/robot_upgrade/flash_protection
	name = "Optical Matrix Shielding"
	desc = "Provides shielding for the optical matrix, rendering the robot immune to flashes."
	id = "borg_flash_protection_module"
	materials = list(MATERIAL_STEEL = 80000, MATERIAL_GLASS = 6000, MATERIAL_GOLD = 5000)
	build_path = /obj/item/borg/upgrade/flash_protection

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

/datum/design/item/exosuit/weapon/plasma/auto
	name = "mounted rotatory plasma cutter"
	id = "mech_plasma_auto"
	materials = list(MATERIAL_STEEL = 20000, MATERIAL_SILVER = 2000, MATERIAL_GOLD = 2000)
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_ENGINEERING = 3)
	build_path = /obj/item/mech_equipment/mounted_system/taser/autoplasma

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

/datum/design/item/exosuit/weapon/machete
	name = "Mechete"
	id = "mech_machete"
	req_tech = list(TECH_COMBAT = 2)
	build_path = /obj/item/mech_equipment/mounted_system/melee/mechete
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

/datum/design/item/exosuit/camera
	name = "exosuit camera"
	id = "mech_camera"
	req_tech = list(TECH_ENGINEERING = 1)
	build_path = /obj/item/mech_equipment/camera

/datum/design/item/exosuit/flash
	name = "exosuit flash"
	id = "mech_flash"
	req_tech = list(TECH_COMBAT = 1)
	build_path = /obj/item/mech_equipment/flash

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

/datum/design/item/exosuit/mechshields/ballistic
	name = "plasteel mech shield"
	id = "mech_shield_ballistic"
	time = 45
	materials = list(MATERIAL_STEEL = 40000, MATERIAL_ALUMINIUM = 5000)
	req_tech = list(TECH_MATERIAL = 3)
	build_path = /obj/item/mech_equipment/ballistic_shield

/datum/design/item/exosuit/ionjets
	name = "exosuit manouvering unit"
	id = "mech_ionjets"
	time = 30
	materials = list(MATERIAL_STEEL = 20000, MATERIAL_ALUMINIUM = 10000, MATERIAL_PHORON = 2500)
	req_tech = list(TECH_ENGINEERING = 2, TECH_MAGNET = 2)
	build_path = /obj/item/mech_equipment/ionjets
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
	build_path = /obj/item/organ/internal/augment/active/item/armblade
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 750)
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2, TECH_MATERIAL = 4, TECH_BIO = 3)
	id = "augment_blade"

/datum/design/item/mechfab/augment/armblade/wolverine
	name = "Cyberclaws"
	build_path = /obj/item/organ/internal/augment/active/item/wolverine
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "diamond" = 250)
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 4, TECH_MATERIAL = 4, TECH_BIO = 3)
	id = "augment_wolverine"

/datum/design/item/mechfab/augment/armblade/wrist_blade
	name = "Wrist blade"
	build_path = /obj/item/organ/internal/augment/active/item/wrist_blade
	materials = list(MATERIAL_TITANIUM = 4000, MATERIAL_DIAMOND = 250)
	req_tech = list(TECH_ESOTERIC = 4, TECH_COMBAT = 5, TECH_BIO = 3)
	id = "augment_wristblade"

/datum/design/item/mechfab/augment/armblade/popout_shotgun
	name = "Pop-out shotgun"
	build_path = /obj/item/organ/internal/augment/active/item/popout_shotgun
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_SILVER = 500)
	req_tech = list(TECH_ESOTERIC = 5, TECH_COMBAT = 6, TECH_BIO = 4)
	id = "augment_popout_shotgun"

/datum/design/item/mechfab/augment/corrective_lenses
	name = "Corrective lenses"
	build_path = /obj/item/organ/internal/augment/active/item/corrective_lenses
	materials = list(DEFAULT_WALL_MATERIAL = 500, MATERIAL_GLASS = 1000)
	req_tech = list(TECH_MATERIAL = 2)
	id = "augment_corrective_lenses"

/datum/design/item/mechfab/augment/glare_dampeners
	name = "Glare dampeners"
	build_path = /obj/item/organ/internal/augment/active/item/glare_dampeners
	materials = list(DEFAULT_WALL_MATERIAL = 100, MATERIAL_GLASS = 2000)
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3)
	id = "augment_glare_dampeners"

/datum/design/item/mechfab/augment/adaptive_binoculars
	name = "Adaptive binoculars"
	build_path = /obj/item/organ/internal/augment/active/item/adaptive_binoculars
	materials = list(MATERIAL_DIAMOND = 100, MATERIAL_GOLD = 100, MATERIAL_GLASS = 2000)
	// We use decent requirements for this, because it allows someone to zoom in and grab ammo from an open container at the same time
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 4, TECH_COMBAT = 4)
	id = "augment_adaptive_binoculars"

/datum/design/item/mechfab/augment/iatric_monitor
	name = "Iatric monitor"
	build_path = /obj/item/organ/internal/augment/active/iatric_monitor
	materials = list(DEFAULT_WALL_MATERIAL = 100, MATERIAL_GLASS = 2000)
	req_tech = list(TECH_BIO = 3)
	id = "augment_iatric_monitor"

/datum/design/item/mechfab/augment/internal_air_system
	name = "Internal air system"
	build_path = /obj/item/organ/internal/augment/active/internal_air_system
	materials = list(DEFAULT_WALL_MATERIAL = 500, MATERIAL_GLASS = 2000, MATERIAL_DIAMOND = 100)
	req_tech = list(TECH_MATERIAL = 5, TECH_BIO = 5)
	id = "augment_internal_air_system"

/datum/design/item/mechfab/augment/leukocyte_breeder
	name = "Leukocyte breeder"
	build_path = /obj/item/organ/internal/augment/active/leukocyte_breeder
	materials = list(DEFAULT_WALL_MATERIAL = 2000, MATERIAL_GLASS = 1000)
	req_tech = list(TECH_MAGNET = 4, TECH_DATA = 4, TECH_BIO = 6)
	id = "augment_leukocyte_breeder"

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

/datum/design/item/mechfab/augment/hud/health
	name = "Implantable health HUD"
	build_path = /obj/item/organ/internal/augment/active/hud/health
	materials = list(DEFAULT_WALL_MATERIAL = 250, "glass" = 250)
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 3)
	id = "augment_med_hud"

/datum/design/item/mechfab/augment/hud/security
	name = "Implantable security HUD"
	build_path = /obj/item/organ/internal/augment/active/hud/security
	materials = list(DEFAULT_WALL_MATERIAL = 250, "glass" = 250)
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	id = "augment_sec_hud"

/datum/design/item/mechfab/augment/hud/janitor
	name = "Implantable filth HUD"
	build_path = /obj/item/organ/internal/augment/active/hud/janitor
	materials = list(DEFAULT_WALL_MATERIAL = 250, "glass" = 250)
	req_tech = list(TECH_BIO = 1, TECH_MAGNET = 3)
	id= "augment_jani_hud"

/datum/design/item/mechfab/augment/hud/science
	name = "Implantable science HUD"
	build_path = /obj/item/organ/internal/augment/active/hud/science
	materials = list(DEFAULT_WALL_MATERIAL = 250, "glass" = 250)
	req_tech = list(TECH_BIO = 1, TECH_MAGNET = 3)
	id= "augment_sci_hud"

/datum/design/item/mechfab/augment/nanounit
	name = "Nanite MCU"
	build_path = /obj/item/organ/internal/augment/active/nanounit
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000, "gold" = 100, "uranium" = 500)
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 5, TECH_BIO = 5, TECH_ENGINEERING = 5)
	id = "augment_nanounit"

/datum/design/item/mechfab/augment/circuit
	name = "Integrated circuit frame"
	build_path = /obj/item/organ/internal/augment/active/item/circuit
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	id = "augment_circuitry"

//BigRigs
/datum/design/item/mechfab/rig/zero
	category = "Hardsuits"
	name = "Null suit control module"
	build_path = /obj/item/rig/zero
	materials = list(DEFAULT_WALL_MATERIAL = 30000, "glass" = 5000, "silver" = 1000)
	id = "null _suit"
	time = 120

/datum/design/item/mechfab/rig/meson
	category = "Hardsuits"
	name = "Meson Scanner"
	build_path = /obj/item/rig_module/vision/meson
	materials = list(MATERIAL_STEEL = 100, MATERIAL_GLASS = 200, MATERIAL_PLASTIC = 300)
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 5)
	id = "rig_meson"
	sort_string = "WCAAA"

/datum/design/item/mechfab/rig/medhud
	category = "Hardsuits"
	name = "Medical HUD"
	build_path = /obj/item/rig_module/vision/medhud
	materials = list(MATERIAL_STEEL = 100, MATERIAL_GLASS = 200,  MATERIAL_PLASTIC = 300)
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 2, TECH_ENGINEERING = 5)
	id = "rig_medhud"
	sort_string = "WCAAB"

/datum/design/item/mechfab/rig/sechud
	category = "Hardsuits"
	name = "Security HUD"
	build_path = /obj/item/rig_module/vision/sechud
	materials = list(MATERIAL_STEEL = 100, MATERIAL_GLASS = 200,  MATERIAL_PLASTIC = 300)
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 2, TECH_ENGINEERING = 5)
	id = "rig_sechud"
	sort_string = "WCAAC"

/datum/design/item/mechfab/rig/nvg
	category = "Hardsuits"
	name = "Night Vision"
	build_path = /obj/item/rig_module/vision/nvg
	materials = list(MATERIAL_PLASTIC = 500, MATERIAL_STEEL = 300, MATERIAL_GLASS = 200, MATERIAL_URANIUM = 200)
	req_tech = list(TECH_MAGNET = 6, TECH_ENGINEERING = 6)
	id = "rig_nvg"
	sort_string = "WCAAD"

/datum/design/item/mechfab/rig/healthscanner
	category = "Hardsuits"
	name = "Medical Scanner"
	build_path = /obj/item/rig_module/device/healthscanner
	materials = list(MATERIAL_PLASTIC = 1000, MATERIAL_STEEL = 700, MATERIAL_GLASS = 500)
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 3, TECH_ENGINEERING = 5)
	id = "rig_healthscanner"
	sort_string = "WCBAA"

/datum/design/item/mechfab/rig/drill
	category = "Hardsuits"
	name = "Mining Drill"
	build_path = /obj/item/rig_module/device/drill
	materials = list(MATERIAL_STEEL = 3500, MATERIAL_GLASS = 1500, MATERIAL_DIAMOND = 2000, MATERIAL_PLASTIC = 1000)
	req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 6)
	id = "rig_drill"
	sort_string = "WCCAA"

/datum/design/item/mechfab/rig/plasmacutter
	category = "Hardsuits"
	name = "Plasma Cutter"
	build_path = /obj/item/rig_module/mounted/plasmacutter
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_GLASS = 1000, MATERIAL_PLASTIC = 1000, MATERIAL_GOLD = 700, MATERIAL_PHORON = 500)
	req_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 3, TECH_ENGINEERING = 6, TECH_COMBAT = 4)
	id = "rig_plasmacutter"
	sort_string = "VCCAB"

/datum/design/item/mechfab/rig/orescanner
	category = "Hardsuits"
	name = "Ore Scanner"
	build_path = /obj/item/rig_module/device/orescanner
	materials = list(MATERIAL_PLASTIC = 1000, MATERIAL_STEEL = 800, MATERIAL_GLASS = 500)
	req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 4, TECH_ENGINEERING = 6)
	id = "rig_orescanner"
	sort_string = "WCDAA"

/datum/design/item/mechfab/rig/anomaly_scanner
	category = "Hardsuits"
	name = "Anomaly Scanner"
	build_path = /obj/item/rig_module/device/anomaly_scanner
	materials = list(MATERIAL_PLASTIC = 1000, MATERIAL_STEEL = 800, MATERIAL_GLASS = 500)
	req_tech = list(TECH_BLUESPACE = 4, TECH_MAGNET = 4, TECH_ENGINEERING = 6)
	id = "rig_anomaly_scanner"
	sort_string = "WCDAB"

/datum/design/item/mechfab/rig/rcd
	category = "Hardsuits"
	name = "RCD Module"
	build_path = /obj/item/rig_module/device/rcd
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_GLASS = 1000, MATERIAL_PLASTIC = 1000, MATERIAL_GOLD = 700, MATERIAL_SILVER = 700)
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 5, TECH_ENGINEERING = 7)
	id = "rig_rcd"
	sort_string = "WCEAA"

/datum/design/item/mechfab/rig/jets
	category = "Hardsuits"
	name = "Maneuvering Jets"
	build_path = /obj/item/rig_module/maneuvering_jets
	materials = list(MATERIAL_STEEL = 3000, MATERIAL_PLASTIC = 2000, MATERIAL_GLASS = 1000)
	req_tech = list(TECH_MATERIAL = 6,  TECH_ENGINEERING = 7)
	id = "rig_jets"
	sort_string = "WCFAA"

/datum/design/item/mechfab/rig/decompiler
	category = "Hardsuits"
	name = "Matter Decompiler"
	build_path = /obj/item/rig_module/device/decompiler
	materials = list(MATERIAL_STEEL = 3000, MATERIAL_PLASTIC = 2000, MATERIAL_GLASS = 1000)
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 5)
	id = "rig_decompiler"
	sort_string = "WCGAA"

/datum/design/item/mechfab/rig/powersink
	category = "Hardsuits"
	name = "Power Sink"
	build_path = /obj/item/rig_module/power_sink
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_GLASS = 2000, MATERIAL_GOLD = 1000, MATERIAL_PLASTIC = 1000)
	req_tech = list(TECH_POWER = 6, TECH_ENGINEERING = 6)
	id = "rig_powersink"
	sort_string = "WCHAA"

/datum/design/item/mechfab/rig/ai_container
	category = "Hardsuits"
	name = "AI Core Container"
	build_path = /obj/item/rig_module/ai_container
	materials = list(MATERIAL_STEEL = 1000, MATERIAL_GLASS = 1000, MATERIAL_PLASTIC = 1000, MATERIAL_GOLD = 500)
	req_tech = list(TECH_DATA = 6, TECH_MATERIAL = 5, TECH_ENGINEERING = 6)
	id = "rig_ai_container"
	sort_string = "WCIAA"

/datum/design/item/mechfab/rig/flash
	category = "Hardsuits"
	name = "Flash"
	build_path = /obj/item/rig_module/device/flash
	materials = list(MATERIAL_PLASTIC = 1500, MATERIAL_STEEL = 1000, MATERIAL_GLASS = 500)
	req_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 3, TECH_ENGINEERING = 5)
	id = "rig_flash"
	sort_string = "WCJAA"

/datum/design/item/mechfab/rig/taser
	category = "Hardsuits"
	name = "Electrolaser"
	build_path = /obj/item/rig_module/mounted/taser
	materials = list(MATERIAL_STEEL = 4000, MATERIAL_PLASTIC = 2500, MATERIAL_GLASS = 2000, MATERIAL_GOLD = 1000)
	req_tech = list(TECH_POWER = 5, TECH_COMBAT = 5, TECH_ENGINEERING = 6)
	id = "rig_taser"
	sort_string = "WCKAA"

/datum/design/item/mechfab/rig/egun
	category = "Hardsuits"
	name = "Energy Gun"
	build_path = /obj/item/rig_module/mounted/egun
	materials = list(MATERIAL_STEEL = 6000, MATERIAL_GLASS = 3000, MATERIAL_PLASTIC = 2500, MATERIAL_GOLD = 2000, MATERIAL_SILVER = 1000)
	req_tech = list(TECH_POWER = 6, TECH_COMBAT = 6, TECH_ENGINEERING = 6)
	id = "rig_egun"
	sort_string = "WCKAB"
/datum/design/item/mechfab/rig/enet
	category = "Hardsuits"
	name = "Energy Net"
	build_path = /obj/item/rig_module/fabricator/energy_net
	materials = list(MATERIAL_STEEL = 6000, MATERIAL_GLASS = 3000, MATERIAL_DIAMOND = 2000, MATERIAL_PLASTIC = 2000)
	req_tech = list(TECH_MATERIAL = 5, TECH_POWER = 6, TECH_MAGNET = 5, TECH_ESOTERIC = 4, TECH_ENGINEERING = 6)
	id = "rig_enet"
	sort_string = "WCKAC"

/datum/design/item/mechfab/rig/stealth
	category = "Hardsuits"
	name = "Active Camouflage"
	build_path = /obj/item/rig_module/stealth_field
	materials = list(MATERIAL_STEEL = 6000, MATERIAL_GLASS = 3000, MATERIAL_DIAMOND = 2000, MATERIAL_SILVER = 2000, MATERIAL_URANIUM = 2000, MATERIAL_GOLD = 2000, MATERIAL_PLASTIC = 2000)
	req_tech = list(TECH_MATERIAL = 5, TECH_POWER = 6, TECH_MAGNET = 6, TECH_ESOTERIC = 6, TECH_ENGINEERING = 7)
	id = "rig_stealth"
	sort_string = "WCLAA"

/datum/design/item/mechfab/rig/cooling_unit
	category = "Hardsuits"
	name = "Cooling Unit"
	build_path = /obj/item/rig_module/cooling_unit
	materials = list(MATERIAL_STEEL = 3000, MATERIAL_GLASS = 3500, MATERIAL_PLASTIC = 2000)
	req_tech = list(TECH_MATERIAL = 2, TECH_MAGNET = 2, TECH_ENGINEERING = 5)
	id = "rig_cooler"
	sort_string = "WCLAB"
