#define GRUNT_GEAR_ICON 'code/modules/halo/icons/species/grunt_gear.dmi'

/mob/living/carbon/human/covenant/unggoy/New(var/new_loc) //Species definition in code/modules/mob/living/human/species/outsider.
	..(new_loc,"unggoy")							//Code breaks if not placed in species folder,
	name = pick(GLOB.first_names_kig_yar);name += " ";name += pick(GLOB.first_names_kig_yar)
	real_name = name
	faction = "Covenant"

/obj/item/clothing/suit/armor/special/unggoy_combat_harness
	name = "Unggoy Combat Harness (Minor)"
	desc = "A combat harness with an inbuilt gas tank"
	icon = GRUNT_GEAR_ICON
	icon_override = GRUNT_GEAR_ICON
	icon_state = "combatharness_minor"
	item_state = "combatharness_minor"

	armor = list(melee = 40, bullet = 55, laser = 30, energy = 30, bomb = 60, bio = 0, rad = 0)
	armor_thickness_modifiers = list()

	species_restricted = list("unggoy")

	specials = list(/datum/armourspecials/internal_jumpsuit/unggoy,/datum/armourspecials/internal_air_tank/unggoy)

/obj/item/clothing/mask/rebreather
	name = "Unggoy Rebreather Mask"

	icon = GRUNT_GEAR_ICON
	icon_override = GRUNT_GEAR_ICON
	icon_state = "rebreather"
	item_state = "rebreather"

	species_restricted = list("unggoy")

	item_flags = BLOCK_GAS_SMOKE_EFFECT | AIRTIGHT
	armor = list(melee = 10,bullet = 15,laser = 10,energy = 10,bomb = 5,bio = 0,rad = 0)
	armor_thickness = 10

	var/rebreath_efficiency = 50 //Rebreather efficiency: Percentile

/obj/item/clothing/mask/rebreather/post_internals_breathe(var/datum/gas_mixture/removed_gas,var/obj/item/weapon/tank/tank_removed_from)
	var/datum/gas_mixture/gas_rebreathed = new
	gas_rebreathed.copy_from(removed_gas)
	gas_rebreathed.multiply(rebreath_efficiency/100)//A rebreather: Recycle some of the gas used up due to breathing.
	tank_removed_from.air_contents.merge(gas_rebreathed)
	qdel(gas_rebreathed)

/obj/item/weapon/tank/methane
	name = "methane tank"
	desc = "A tank of methane."
	icon_state = "oxygen_fr"
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD


/obj/item/weapon/tank/methane/New()
	..()
	air_contents.adjust_gas("methane", (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/weapon/tank/methane/unggoy_internal
	name = "unggoy methane tank"
	desc = "A methane tank usually found affixed to a unggoy combat harness."

	canremove = 0

	icon = GRUNT_GEAR_ICON
	icon_state = "methane_tank"
	item_state = null

/obj/item/weapon/tank/methane/unggoy_internal/MouseDrop(var/obj/over_object)
	. = ..()
	if(over_object == src)
		ui_interact(usr)

/obj/item/clothing/under/unggoy_internal
	name = "Unggoy Internal Jumpsuit"
	desc = ""

	icon_state = "blackutility"
	item_state = "blank"
	worn_state = "blank"
	canremove = 0

//Unggoy Harness Sub-Defines//
/obj/item/clothing/suit/armor/special/unggoy_combat_harness/major
	name = "Unggoy Combat Harness (Major)"
	desc = "A combat harness with an inbuilt gas tank"
	icon = GRUNT_GEAR_ICON
	icon_override = GRUNT_GEAR_ICON
	icon_state = "combatharness_major"
	item_state = "combatharness_major"

	species_restricted = list("unggoy")

	specials = list(/datum/armourspecials/internal_jumpsuit/unggoy,/datum/armourspecials/internal_air_tank/unggoy)

/obj/item/clothing/suit/armor/special/unggoy_combat_harness/ultra
	name = "Unggoy Combat Harness (Ultra)"
	desc = "A combat harness with an inbuilt gas tank"
	icon = GRUNT_GEAR_ICON
	icon_override = GRUNT_GEAR_ICON
	icon_state = "combatharness_ultra"
	item_state = "combatharness_ultra"

	species_restricted = list("unggoy")

	totalshields = 100
	specials = list(/datum/armourspecials/internal_jumpsuit/unggoy,/datum/armourspecials/internal_air_tank/unggoy,/datum/armourspecials/shields/unggoy)

/obj/item/clothing/suit/armor/special/unggoy_combat_harness/specops
	name = "Unggoy Combat Harness (Spec-Ops)"
	desc = "A combat harness with an inbuilt gas tank"
	icon = GRUNT_GEAR_ICON
	icon_override = GRUNT_GEAR_ICON
	icon_state = "combatharness_specops"
	item_state = "combatharness_specops"

	species_restricted = list("unggoy")

	action_button_name = "Toggle Active Camoflage"
	specials = list(/datum/armourspecials/internal_jumpsuit/unggoy,/datum/armourspecials/internal_air_tank/unggoy,/datum/armourspecials/cloaking)

/obj/item/clothing/mask/rebreather/unggoy_spec_ops
	name = "Unggoy Rebreather Mask (Spec-Ops)"

	icon_state = "rebreather_specops"
	item_state = "rebreather_specops"

	rebreath_efficiency = 70


#undef GRUNT_GEAR_ICON