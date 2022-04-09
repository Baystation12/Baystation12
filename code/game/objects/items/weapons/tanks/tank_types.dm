/obj/item/tank/scrubber
	name = "high capacity gas tank"
	desc = "An unwieldy tank for lots of gas, although not lots of GAS."
	icon_state = "scrubber"
	slot_flags = EMPTY_BITFIELD
	w_class = ITEM_SIZE_HUGE
	tank_size = TANK_SIZE_HUGE
	gauge_icon = null
	volume = 450


/obj/item/tank/oxygen
	name = "oxygen tank"
	desc = "A tank of oxygen."
	icon_state = "oxygen"
	volume = 180
	tank_size = TANK_SIZE_LARGE
	distribute_pressure = ONE_ATMOSPHERE * O2STANDARD
	starting_pressure = list(
		GAS_OXYGEN = 6 * ONE_ATMOSPHERE
	)


/obj/item/tank/oxygen_yellow
	name = "oxygen tank"
	desc = "A tank of oxygen."
	icon_state = "oxygen_yellow"
	volume = 180
	tank_size = TANK_SIZE_LARGE
	distribute_pressure = ONE_ATMOSPHERE * O2STANDARD
	starting_pressure = list(
		GAS_OXYGEN = 6 * ONE_ATMOSPHERE
	)


/obj/item/tank/nitrogen
	name = "nitrogen tank"
	desc = "A tank of nitrogen."
	icon_state = "nitrogen"
	volume = 180
	tank_size = TANK_SIZE_LARGE
	distribute_pressure = ONE_ATMOSPHERE * O2STANDARD
	starting_pressure = list(
		GAS_NITROGEN = 6 * ONE_ATMOSPHERE
	)


/obj/item/tank/air
	name = "air tank"
	desc = "Mixed anyone?"
	icon_state = "oxygen"
	volume = 180
	tank_size = TANK_SIZE_LARGE
	starting_pressure = list(
		GAS_OXYGEN = 6 * ONE_ATMOSPHERE * O2STANDARD,
		GAS_NITROGEN = 6 * ONE_ATMOSPHERE * N2STANDARD
	)


/obj/item/tank/anesthetic
	name = "anesthetic tank"
	desc = "The dentist's friend."
	icon_state = "anesthetic"
	item_state = "an_tank"
	volume = 270
	tank_size = TANK_SIZE_LARGE
	starting_pressure = list(
		GAS_OXYGEN = 6 * ONE_ATMOSPHERE * O2STANDARD,
		GAS_N2O = 6 * ONE_ATMOSPHERE * N2STANDARD
	)


/obj/item/tank/phoron
	name = "phoron tank"
	desc = "Do not inhale."
	icon_state = "phoron"
	w_class = ITEM_SIZE_NORMAL
	slot_flags = null
	gauge_icon = null
	starting_pressure = list(
		GAS_PHORON = 3 * ONE_ATMOSPHERE
	)


/obj/item/tank/hydrogen
	name = "hydrogen tank"
	desc = "Fizzy lifting gas."
	icon_state = "hydrogen"
	w_class = ITEM_SIZE_NORMAL
	slot_flags = null
	gauge_icon = null
	starting_pressure = list(
		GAS_HYDROGEN = 3 * ONE_ATMOSPHERE
	)


/obj/item/tank/oxygen_emergency
	name = "emergency oxygen tank"
	desc = "A tank of emergency oxygen. This one is tiny."
	icon_state = "emergency"
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_BELT
	attack_cooldown = DEFAULT_WEAPON_COOLDOWN
	force = 5
	melee_accuracy_bonus = -10
	gauge_icon = "indicator_emergency"
	gauge_cap = 4
	tank_size = TANK_SIZE_SMALL
	volume = 40
	distribute_pressure = ONE_ATMOSPHERE * O2STANDARD
	starting_pressure = list(
		GAS_OXYGEN = 10 * ONE_ATMOSPHERE
	)


/obj/item/tank/oxygen_emergency_extended
	name = "emergency oxygen tank"
	desc = "A tank of emergency oxygen. This one is small."
	icon_state = "emergency_engi"
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_BELT
	attack_cooldown = DEFAULT_WEAPON_COOLDOWN
	force = 7
	melee_accuracy_bonus = -10
	gauge_icon = "indicator_emergency"
	gauge_cap = 4
	tank_size = TANK_SIZE_SMALL
	volume = 60
	distribute_pressure = ONE_ATMOSPHERE * O2STANDARD
	starting_pressure = list(
		GAS_OXYGEN = 10 * ONE_ATMOSPHERE
	)


/obj/item/tank/oxygen_emergency_double
	name = "emergency oxygen tank"
	desc = "A tank of emergency oxygen. This one is unwieldy."
	icon_state = "emergency_double"
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_BELT
	attack_cooldown = DEFAULT_WEAPON_COOLDOWN
	force = 8
	melee_accuracy_bonus = -10
	gauge_icon = "indicator_emergency_double"
	gauge_cap = 4
	volume = 80
	distribute_pressure = ONE_ATMOSPHERE * O2STANDARD
	starting_pressure = list(
		GAS_OXYGEN = 10 * ONE_ATMOSPHERE
	)


/obj/item/tank/oxygen_scba
	name = "emergency oxygen tank"
	desc = "A tank of emergency oxygen. This one is unwieldy but comes with straps."
	icon_state = "emergency_scuba"
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_BELT | SLOT_BACK
	attack_cooldown = DEFAULT_WEAPON_COOLDOWN
	force = 8
	melee_accuracy_bonus = -10
	gauge_icon = null
	volume = 80
	distribute_pressure = ONE_ATMOSPHERE * O2STANDARD
	starting_pressure = list(
		GAS_OXYGEN = 10 * ONE_ATMOSPHERE
	)


/obj/item/tank/nitrogen_emergency
	name = "emergency nitrogen tank"
	desc = "A tank of emergency nitrogen. This one is tiny."
	icon_state = "emergency_nitro"
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_BELT
	attack_cooldown = DEFAULT_WEAPON_COOLDOWN
	force = 5
	melee_accuracy_bonus = -10
	gauge_icon = "indicator_emergency"
	gauge_cap = 4
	tank_size = TANK_SIZE_SMALL
	volume = 40
	distribute_pressure = ONE_ATMOSPHERE * O2STANDARD
	starting_pressure = list(
		GAS_NITROGEN = 10 * ONE_ATMOSPHERE
	)


/obj/item/tank/nitrogen_emergency_double
	name = "emergency nitrogen tank"
	desc = "A tank of emergency nitrogen. This one is unwieldy."
	icon_state = "emergency_double_nitrogen"
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_BELT
	attack_cooldown = DEFAULT_WEAPON_COOLDOWN
	force = 8
	melee_accuracy_bonus = -10
	gauge_icon = "indicator_emergency_double"
	gauge_cap = 4
	volume = 80
	distribute_pressure = ONE_ATMOSPHERE * O2STANDARD
	starting_pressure = list(
		GAS_NITROGEN = 10 * ONE_ATMOSPHERE
	)


/obj/item/tank/air_sac
	name = "air sac"
	desc = "A small, compressed air sac that fills with breathable air, to be used in emergencies."
	icon_state = "air_sac"
	unacidable = TRUE
	gauge_icon = null
	tank_size = TANK_SIZE_SMALL
	volume = 20
