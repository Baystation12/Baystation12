/* Types of tanks!
 * Contains:
 *		Oxygen
 *		Anesthetic
 *		Air
 *		Phoron
 *		Hydrogen
 *		Emergency Oxygen
 */

/*
 * Oxygen
 */
/obj/item/weapon/tank/oxygen
	name = "oxygen tank"
	desc = "A tank of oxygen."
	icon_state = GAS_OXYGEN
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	starting_pressure = list(GAS_OXYGEN = 6*ONE_ATMOSPHERE)
	volume = 180

/obj/item/weapon/tank/oxygen/yellow
	desc = "A tank of oxygen. This one is yellow."
	icon_state = "oxygen_f"

/*
 * Anesthetic
 */
/obj/item/weapon/tank/anesthetic
	name = "anesthetic tank"
	desc = "A tank with an N2O/O2 gas mix."
	icon_state = "anesthetic"
	item_state = "an_tank"
	starting_pressure = list(GAS_OXYGEN = 6*ONE_ATMOSPHERE*O2STANDARD, GAS_N2O = 6*ONE_ATMOSPHERE*N2STANDARD)
	volume = 270

/*
 * Air
 */
/obj/item/weapon/tank/air
	name = "air tank"
	desc = "Mixed anyone?"
	icon_state = GAS_OXYGEN
	starting_pressure = list(GAS_OXYGEN = 6*ONE_ATMOSPHERE*O2STANDARD, GAS_NITROGEN = 6*ONE_ATMOSPHERE*N2STANDARD)
	volume = 180

/*
 * Phoron
 */
/obj/item/weapon/tank/phoron
	name = "phoron tank"
	desc = "Contains dangerous phoron. Do not inhale. Warning: extremely flammable."
	icon_state = "phoron"
	gauge_icon = null
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = null	//they have no straps!
	starting_pressure = list(GAS_PHORON = 3*ONE_ATMOSPHERE)

/*
 * Hydrogen
 */
/obj/item/weapon/tank/hydrogen
	name = "hydrogen tank"
	desc = "Contains hydrogen. Warning: flammable."
	icon_state = "hydrogen"
	gauge_icon = null
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = null
	starting_pressure = list(GAS_HYDROGEN = 3*ONE_ATMOSPHERE)

/*
 * Emergency Oxygen
 */
/obj/item/weapon/tank/emergency
	name = "emergency tank"
	icon_state = "emergency"
	gauge_icon = "indicator_emergency"
	gauge_cap = 4
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_SMALL
	force = 5
	attack_cooldown = DEFAULT_WEAPON_COOLDOWN
	melee_accuracy_bonus = -10
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	volume = 40 //Tiny. Real life equivalents only have 21 breaths of oxygen in them. They're EMERGENCY tanks anyway -errorage (dangercon 2011)

/obj/item/weapon/tank/emergency/oxygen
	name = "emergency oxygen tank"
	desc = "Used for emergencies. Contains very little oxygen, so try to conserve it until you actually need it."
	icon_state = "emergency"
	gauge_icon = "indicator_emergency"
	starting_pressure = list(GAS_OXYGEN = 10*ONE_ATMOSPHERE)

/obj/item/weapon/tank/emergency/oxygen/engi
	name = "extended-capacity emergency oxygen tank"
	icon_state = "emergency_engi"
	volume = 60

/obj/item/weapon/tank/emergency/oxygen/double
	name = "double emergency oxygen tank"
	icon_state = "emergency_double"
	gauge_icon = "indicator_emergency_double"
	volume = 90
	w_class = ITEM_SIZE_NORMAL

/obj/item/weapon/tank/emergency/oxygen/double/red	//firefighting tank, fits on belt, back or suitslot
	name = "self contained breathing apparatus"
	desc = "A self contained breathing apparatus, well known as SCBA. Generally filled with oxygen."
	icon_state = "oxygen_fr"
	slot_flags = SLOT_BELT | SLOT_BACK

/obj/item/weapon/tank/emergency/nitrogen
	name = "emergency nitrogen tank"
	desc = "An emergency air tank hastily painted red and issued to Vox crewmembers."
	icon_state = "emergency_nitro"
	gauge_icon = "indicator_emergency"
	starting_pressure = list(GAS_NITROGEN = 10*ONE_ATMOSPHERE)

/obj/item/weapon/tank/emergency/nitrogen/double
	name = "double emergency nitrogen tank"
	icon_state = "emergency_double_nitrogen"
	gauge_icon = "indicator_emergency_double"
	volume = 60

/*
 * Nitrogen
 */
/obj/item/weapon/tank/nitrogen
	name = "nitrogen tank"
	desc = "A tank of nitrogen."
	icon_state = "nitrogen"
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	starting_pressure = list(GAS_NITROGEN = 10*ONE_ATMOSPHERE)
	volume = 180
