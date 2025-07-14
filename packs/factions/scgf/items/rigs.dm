// 5th Fleet ERT

/obj/item/rig/ert/fleet
	name = "emergency response hardsuit control module"
	desc = "A hardsuit utilised  by Fleet combat teams. Has navy blue highlights and Sol-patterned crests on the shoulders."
	suit_type = "emergency response fleet"
	icon_state = "ert_fleet_rig"

	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
		)

	online_slowdown = 0.4
	offline_slowdown = 1

	chest_type = /obj/item/clothing/suit/space/rig/ert/fleet
	helm_type = /obj/item/clothing/head/helmet/space/rig/ert/fleet
	boot_type = /obj/item/clothing/shoes/magboots/rig/ert/fleet
	glove_type = /obj/item/clothing/gloves/rig/ert/fleet

	initial_modules = list(
		/obj/item/rig_module/chem_dispenser/combat/ert,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/mounted/energy/egun,
		/obj/item/rig_module/vision,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/datajack
		)
	banned_modules = list(
		/obj/item/rig_module/chem_dispenser/skrell,
		/obj/item/rig_module/device/clustertool/skrell,
		/obj/item/rig_module/device/multitool/skrell,
		/obj/item/rig_module/device/welder/skrell,
		/obj/item/rig_module/device/cable_coil/skrell,
		/obj/item/rig_module/device/orescanner
		)

/obj/item/clothing/head/helmet/space/rig/ert/fleet
	head_light_range = 8
	brightness_on = 0.8
	light_overlay = "helmet_light_dual"
	species_restricted = list(SPECIES_HUMAN,SPECIES_IPC)

/obj/item/clothing/suit/space/rig/ert/fleet
	species_restricted = list(SPECIES_HUMAN,SPECIES_IPC)

/obj/item/clothing/shoes/magboots/rig/ert/fleet
	species_restricted = list(SPECIES_HUMAN,SPECIES_IPC)
	force = 5

/obj/item/clothing/gloves/rig/ert/fleet
	species_restricted = list(SPECIES_HUMAN,SPECIES_IPC)
	siemens_coefficient = 0
	force = 5

/obj/item/rig/ert/fleet/leader
	name = "\improper SCGF-ERT command hardsuit control module"
	desc = "A hardsuit utilized by Fleet combat teams. This one has blue highlights with SOL CENTRAL GOVERNMENT FLEET printed in gold lettering on the chest and displaying a SCG crest on the back."
	suit_type = "\improper SCGF-ERT command hardsuit"
	icon_state = "ert_commander_rig"

	req_access = list(access_ert_leader)

	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	max_pressure_protection = FIRESUIT_MAX_PRESSURE

	initial_modules = list(
		/obj/item/rig_module/chem_dispenser/combat/ert,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/chem_dispenser/injector/ert,
		/obj/item/rig_module/device/healthscanner,
		/obj/item/rig_module/vision/multi,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/kinetic_module,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/datajack
		)

/obj/item/rig/ert/fleet/combat
	name = "\improper SCGF-ERT combat hardsuit control module"
	desc = "A hardsuit utilized by Fleet combat teams. This one has red highlights with SOL CENTRAL GOVERNMENT FLEET written in silver lettering on the chest and a SCG crest displaying on the back."
	suit_type = "\improper SCGF emergency response combat hardsuit"
	icon_state = "ert_security_rig"

	initial_modules = list(
		/obj/item/rig_module/chem_dispenser/combat/ert,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/mounted/energy/egun,
		/obj/item/rig_module/device/flash,
		/obj/item/rig_module/vision/multi,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/kinetic_module,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/ai_container
		)
	banned_modules = list(
		/obj/item/rig_module/chem_dispenser/skrell,
		/obj/item/rig_module/device/clustertool/skrell,
		/obj/item/rig_module/device/multitool/skrell,
		/obj/item/rig_module/device/welder/skrell,
		/obj/item/rig_module/device/cable_coil/skrell,
		/obj/item/rig_module/device/orescanner,
		/obj/item/rig_module/device/welder,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/grenade_launcher/mfoam,
		/obj/item/rig_module/device/defib,
		/obj/item/rig_module/actuators
		)

/obj/item/rig/ert/fleet/engineer
	name = "emergency response technical hardsuit control module"
	desc = "A hardsuit utilized by Fleet combat teams. This one has orange hightlights with SOL CENTRAL GOVERNMENT FLEET written in silver lettering on the chest and a SCG crest displaying on the back."
	suit_type = "\improper SCGF emergency response engineering hardsuit"
	icon_state = "ert_engineer_rig"

	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	max_pressure_protection = FIRESUIT_MAX_PRESSURE

	initial_modules = list(
		/obj/item/rig_module/chem_dispenser/combat/ert,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/mounted/energy/plasmacutter,
		/obj/item/rig_module/grenade_launcher/mfoam,
		/obj/item/rig_module/vision/multi,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/kinetic_module,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/datajack
		)
	banned_modules = list(
		/obj/item/rig_module/chem_dispenser/skrell,
		/obj/item/rig_module/device/clustertool/skrell,
		/obj/item/rig_module/device/multitool/skrell,
		/obj/item/rig_module/device/welder/skrell,
		/obj/item/rig_module/device/cable_coil/skrell,
		/obj/item/rig_module/device/orescanner,
		/obj/item/rig_module/mounted/ballistic/minigun,
		/obj/item/rig_module/chem_dispenser/injector
		)

/obj/item/rig/ert/fleet/medical
	name = "\improper SCGF-ERT rescue hardsuit control module"
	desc = "A hardsuit utilized by Fleet combat teams. This one has white highlights with SOL CENTRAL GOVERNMENT FLEET written in silver lettering on the chest and a SCG crest displaying on the back."
	suit_type = "\improper SCGF rescue hardsuit"
	icon_state = "ert_medical_rig"

	initial_modules = list(
		/obj/item/rig_module/chem_dispenser/combat/ert,
		/obj/item/rig_module/chem_dispenser/injector/ert,
		/obj/item/rig_module/device/healthscanner,
		/obj/item/rig_module/device/defib,
		/obj/item/rig_module/device/flash,
		/obj/item/rig_module/vision/multi,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/kinetic_module,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/ai_container
		)
	banned_modules = list(
		/obj/item/rig_module/chem_dispenser/skrell,
		/obj/item/rig_module/device/clustertool/skrell,
		/obj/item/rig_module/device/multitool/skrell,
		/obj/item/rig_module/device/welder/skrell,
		/obj/item/rig_module/device/cable_coil/skrell,
		/obj/item/rig_module/device/orescanner,
		/obj/item/rig_module/device/welder,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/grenade_launcher/mfoam,
		/obj/item/rig_module/mounted/ballistic,
		/obj/item/rig_module/mounted/energy,
		/obj/item/rig_module/grenade_launcher
		)

// Non-standard issue FERT suits for admemery and extraordinary missions (like silently killing the Deck Chief who keeps sending butt faxes to the SCGR)
/obj/item/rig/ert/fleet/combat/stealth
	name = "experimental SCGF combat hardsuit control module"
	desc = "A hardsuit utilized by Fleet combat teams."
	suit_type = "\improper SCGF stealth hardsuit prototype"
	icon_state = "solop_rig"

	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	max_pressure_protection = RIG_MAX_PRESSURE

	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
		)

	initial_modules = list(
		/obj/item/rig_module/chem_dispenser/combat/ert,
		/obj/item/rig_module/vision/multi,
		/obj/item/rig_module/stealth_field,
		/obj/item/rig_module/teleporter,
		/obj/item/rig_module/device/flash,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/kinetic_module,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/self_destruct/small,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/datajack
		)
	banned_modules = list(
		/obj/item/rig_module/chem_dispenser/skrell,
		/obj/item/rig_module/device/clustertool/skrell,
		/obj/item/rig_module/device/multitool/skrell,
		/obj/item/rig_module/device/welder/skrell,
		/obj/item/rig_module/device/cable_coil/skrell,
		/obj/item/rig_module/device/orescanner,
		/obj/item/rig_module/actuators,
		/obj/item/rig_module/mounted/energy
		)
