#define GRUNT_GEAR_ICON 'code/modules/halo/icons/species/grunt_gear.dmi'

/mob/living/carbon/human/covenant/unggoy/New(var/new_loc) //Species definition in code/modules/mob/living/human/species/outsider.
	. = ..(new_loc,"Unggoy")							//Code breaks if not placed in species folder,

/datum/language/balahese
	name = "Balahese"
	desc = "The language of the Unggoy"
	native = 1
	colour = "unggoy"
	syllables = list("nnse","nee","kooree","keeoh","cheenoh","rehmah","nnteh","hahdeh","nnrah","kahwah","ee","hoo","roh","usoh","ahnee","ruh","eerayrah","sohruh","eesah")
	key = "B"
	flags = RESTRICTED

/obj/item/clothing/suit/armor/special/unggoy_combat_harness
	name = "Unggoy Combat Harness (Minor)"
	desc = "A combat harness with an inbuilt gas tank"
	icon = GRUNT_GEAR_ICON
	icon_override = GRUNT_GEAR_ICON
	item_state_slots = list(slot_l_hand_str = "armor", slot_r_hand_str = "armor")
	icon_state = "combatharness_minor"

	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS //Essentially, the entire body besides the head,feet,hands

	flags_inv = HIDESUITSTORAGE|HIDEBACK
	armor = list(melee = 55, bullet = 40, laser = 55, energy = 45, bomb = 40, bio = 25, rad = 25) //worse than marine
	armor_thickness_modifiers = list()
	unacidable = 1

	allowed = list(/obj/item/weapon/tank)
	species_restricted = list("Unggoy")

/obj/item/clothing/mask/rebreather
	name = "Unggoy Rebreather Mask"
	desc = "A breathing device fitted for Unggoy, who breathe a methane atmospheric mix. This one has some protective armour for the head."
	item_state = "blank"
	icon = GRUNT_GEAR_ICON
	icon_override = GRUNT_GEAR_ICON
	icon_state = "rebreather"

	species_restricted = list("Unggoy")
	item_state_slots = list(slot_l_hand_str = "armor", slot_r_hand_str = "armor")

	body_parts_covered = HEAD|FACE
	item_flags = BLOCK_GAS_SMOKE_EFFECT | AIRTIGHT | FLEXIBLEMATERIAL
	armor = list(melee = 40, bullet = 20, laser = 35,energy = 35, bomb = 20, bio = 0, rad = 0)
	armor_thickness = 10
	unacidable = 1

	var/rebreath_efficiency = 50 //Rebreather efficiency: Percentile

/obj/item/clothing/mask/rebreather/small
	name = "Small Unggoy Rebreather Mask"
	desc = "A breathing device fitted for Unggoy, who breathe a methane atmospheric mix."
	icon_state = "rebreather_small"
	body_parts_covered = FACE
	item_flags = AIRTIGHT|FLEXIBLEMATERIAL
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	armor_thickness = 0

/obj/item/clothing/mask/rebreather/post_internals_breathe(var/datum/gas_mixture/removed_gas,var/obj/item/weapon/tank/tank_removed_from)
	var/datum/gas_mixture/gas_rebreathed = new
	gas_rebreathed.copy_from(removed_gas)
	gas_rebreathed.multiply(rebreath_efficiency/100)//A rebreather: Recycle some of the gas used up due to breathing.
	tank_removed_from.air_contents.merge(gas_rebreathed)
	qdel(gas_rebreathed)

/obj/item/clothing/mask/rebreather/equipped(var/mob/user, var/slot)
	. = ..()
	if(slot == slot_wear_mask)
		var/obj/item/weapon/tank/internal = locate() in user
		if(internal)
			internal.toggle_valve(user)

/obj/item/weapon/tank/methane
	name = "gas tank"
	desc = "A green gas tank."
	icon = GRUNT_GEAR_ICON
	icon_override = GRUNT_GEAR_ICON
	icon_state = "methanetank_green"
	item_state_slots = list(slot_back_str = "methanetank_green_back", slot_l_hand_str = "methanetank_green", slot_r_hand_str = "methanetank_green")
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	var/starting_pressure = 1

/obj/item/weapon/tank/methane/empty
	starting_pressure = 0

/obj/item/weapon/tank/methane/red
	desc = "A red gas tank."
	icon_state = "methanetank_red"
	item_state_slots = list(slot_back_str = "methanetank_red_back", slot_l_hand_str = "methanetank_red", slot_r_hand_str = "methanetank_red")

/obj/item/weapon/tank/methane/red/empty
	starting_pressure = 0

/obj/item/weapon/tank/methane/blue
	desc = "A blue gas tank."
	icon_state = "methanetank_blue"
	item_state_slots = list(slot_back_str = "methanetank_blue_back", slot_l_hand_str = "methanetank_blue", slot_r_hand_str = "methanetank_blue")

/obj/item/weapon/tank/methane/blue/empty
	starting_pressure = 0

/obj/item/weapon/tank/methane/New()
	. = ..()
	if(starting_pressure > 0)
		air_contents.adjust_gas("methane", (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/weapon/tank/methane/unggoy_internal
	name = "Unggoy methane tank"
	desc = "A methane tank usually found affixed to a unggoy combat harness."
	gauge_icon = "indicator_emergency"
	icon = GRUNT_GEAR_ICON
	icon_state = "methane_tank_orange"
	item_state_slots = list(slot_back_str = "methanetank_red_back", slot_l_hand_str = "methanetank_red", slot_r_hand_str = "methanetank_red")
	slot_flags = SLOT_BACK

/obj/item/weapon/tank/methane/unggoy_internal/red
	icon_state = "methane_tank_red"
	item_state_slots = list(slot_back_str = "methanetank_red_back", slot_l_hand_str = "methanetank_red", slot_r_hand_str = "methanetank_red")

/obj/item/weapon/tank/methane/unggoy_internal/red/empty
	starting_pressure = 0

/obj/item/weapon/tank/methane/unggoy_internal/blue
	icon_state = "methane_tank_blue"
	item_state_slots = list(slot_back_str = "methanetank_blue_back", slot_l_hand_str = "methanetank_blue", slot_r_hand_str = "methanetank_blue")

/obj/item/weapon/tank/methane/unggoy_internal/blue/empty
	starting_pressure = 0

/obj/item/weapon/tank/methane/unggoy_internal/MouseDrop(var/obj/over_object)
	. = ..()
	if(over_object == src)
		ui_interact(usr)

/obj/item/clothing/under/unggoy_internal
	name = "Unggoy Internal Jumpsuit"
	desc = "A form fitting functional undersuit for Unggoy soldiers. Has a little protective padding."
	icon = GRUNT_GEAR_ICON
	icon_override = GRUNT_GEAR_ICON
	icon_state = "utility_jumpsuit"
	item_state_slots = list(slot_l_hand_str = "armor", slot_r_hand_str = "armor")
	species_restricted = list("Unggoy")
	armor = list(melee = 5, bullet = 5, laser = 5, energy = 5, bomb = 5, bio = 0, rad = 0)

/obj/item/clothing/under/unggoy_thrall
	name = "Unggoy thrall robe"
	desc = "A simple utilitarian garment for a simple, utilitarian people."
	icon = GRUNT_GEAR_ICON
	icon_override = GRUNT_GEAR_ICON
	icon_state = "thrall_robe"
	item_state_slots = list(slot_l_hand_str = "armor", slot_r_hand_str = "armor")
	species_restricted = list("Unggoy")

//Unggoy Harness Sub-Defines//

/obj/item/clothing/suit/armor/special/unggoy_combat_harness/ramclan
	name = "Ram Clan Unggoy Harness"
	icon_state = "combatharness_blue"
	item_state = "combatharness_blue"

/obj/item/clothing/suit/armor/special/unggoy_combat_harness/boulderclan
	name = "Boulder Clan Unggoy Harness"
	icon_state = "combatharness_red"
	item_state = "combatharness_red"

/obj/item/clothing/suit/armor/special/unggoy_combat_harness/major
	name = "Unggoy Combat Harness (Major)"
	desc = "A combat harness with an inbuilt gas tank"
	icon = GRUNT_GEAR_ICON
	icon_override = GRUNT_GEAR_ICON
	icon_state = "combatharness_major"
	item_state = "combatharness_major"

	armor = list(melee = 55, bullet = 45, laser = 55, energy = 50, bomb = 40, bio = 25, rad = 25)


/obj/item/clothing/suit/armor/special/unggoy_combat_harness/ultra
	name = "Unggoy Combat Harness (Ultra)"
	desc = "A combat harness with an inbuilt gas tank"
	icon = GRUNT_GEAR_ICON
	icon_override = GRUNT_GEAR_ICON
	icon_state = "combatharness_ultra"
	item_state = "combatharness_ultra"

	armor = list(melee = 55, bullet = 45, laser = 55, energy = 50, bomb = 40, bio = 25, rad = 25)

	//totalshields = 100
	//specials = list(/datum/armourspecials/shields/unggoy)

/obj/item/clothing/suit/armor/special/unggoy_combat_harness/specops
	name = "Unggoy Combat Harness (Spec-Ops)"
	desc = "A combat harness with an inbuilt gas tank"
	icon = GRUNT_GEAR_ICON
	icon_override = GRUNT_GEAR_ICON
	icon_state = "combatharness_specops"
	item_state = "combatharness_specops"

	action_button_name = "Toggle Active Camouflage"
	specials = list(/datum/armourspecials/cloaking)

	armor = list(melee = 55, bullet = 45, laser = 55, energy = 50, bomb = 40, bio = 25, rad = 25)


/obj/item/clothing/suit/armor/special/unggoy_combat_harness/deacon
	name = "Unggoy Combat Harness (Deacon)"
	desc = "A combat harness with an inbuilt gas tank."
	icon = GRUNT_GEAR_ICON
	icon_override = GRUNT_GEAR_ICON
	icon_state = "combatharness_deacon"
	item_state = "combatharness_deacon"
	totalshields = 60 //Pretty much just a distinguishing feature.

	armor = list(melee = 55, bullet = 45, laser = 55, energy = 50, bomb = 40, bio = 25, rad = 25)

	specials = list(/datum/armourspecials/shields/unggoy)

/obj/item/clothing/suit/armor/special/unggoy_combat_harness/honour_guard
	name = "Unggoy Combat Harness (Honour Guard)"
	desc = "A combat harness with an inbuilt gas tank."
	icon = GRUNT_GEAR_ICON
	icon_override = GRUNT_GEAR_ICON
	icon_state = "combatharness_honour"
	item_state = "combatharness_honour"
	totalshields = 150 //Pretty much just a distinguishing feature.

	specials = list(/datum/armourspecials/shields/unggoy)

/obj/item/clothing/mask/rebreather/unggoy_spec_ops
	name = "Unggoy Rebreather Mask (Spec-Ops)"

	icon_state = "rebreather_specops"

	rebreath_efficiency = 70

/obj/item/clothing/mask/rebreather/unggoy_deacon
	name = "Unggoy Rebreather Mask (Deacon)"

	icon_state = "rebreather_deacon"

	rebreath_efficiency = 65

/obj/item/clothing/shoes/grunt_boots
	name = "Natural Armor"
	desc = "The natural armor on your legs provides a small amount of protection against the elements."
	icon = 'code/modules/halo/icons/species/grunt_gear.dmi'
	icon_state = "naturallegarmor"
	item_state = "blank"
	siemens_coefficient = 0.5
	permeability_coefficient = 0.05
	armor = list(melee = 35, bullet = 35, laser = 5, energy = 25, bomb = 15, bio = 0, rad = 0)

	canremove = 0
	unacidable = 1

/obj/item/clothing/shoes/grunt_gloves
	name = "Natural Armor"
	desc = "The natural armor on your arms provides a small amount of protection against the elements."
	icon = 'code/modules/halo/icons/species/grunt_gear.dmi'
	icon_state = "naturalhandarmor"
	item_state = "blank"
	armor = list(melee = 30, bullet = 40, laser = 10, energy = 25, bomb = 15, bio = 0, rad = 0)

	canremove = 0
	unacidable = 1

//First Contact Variants//

/obj/item/clothing/suit/armor/special/unggoy_combat_harness/first_contact
	name = "Unggoy Combat Harness, Modified"
	desc = "An unggoy combat harness, with plating stripped and assumadly sold off for Gekz."
	armor = list(melee = 30, bullet = 40, laser = 40, energy = 40, bomb = 40, bio = 20, rad = 20)

#undef GRUNT_GEAR_ICON