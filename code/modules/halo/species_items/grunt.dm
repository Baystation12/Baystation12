#define GRUNT_GEAR_ICON 'code/modules/halo/icons/species/grunt_gear.dmi'

/mob/living/carbon/human/covenant/unggoy/New(var/new_loc) //Species definition in code/modules/mob/living/human/species/outsider.
	..(new_loc,"Unggoy")							//Code breaks if not placed in species folder,
	name = species.get_random_name()
	real_name = name
	faction = "Covenant"

/datum/language/balahese
	name = "Balahese"
	desc = "The language of the Unggoy"
	native = 1
	colour = "vox"
	syllables = list("nnse","nee","kooree","keeoh","cheenoh","rehmah","nnteh","hahdeh","nnrah","kahwah","ee","hoo","roh","usoh","ahnee","ruh","eerayrah","sohruh","eesah")
	key = "B"
	flags = RESTRICTED

/obj/item/clothing/suit/armor/special/unggoy_combat_harness
	name = "Unggoy Combat Harness (Minor)"
	desc = "A combat harness with an inbuilt gas tank"
	icon = GRUNT_GEAR_ICON
	icon_override = GRUNT_GEAR_ICON
	icon_state = "combatharness_minor"
	item_state = "combatharness_minor"

	armor = list(melee = 45, bullet = 40, laser = 10, energy = 10, bomb = 30, bio = 0, rad = 0)
	armor_thickness_modifiers = list()

	species_restricted = list("Unggoy")

	specials = list(/datum/armourspecials/gear/unggoy_jumpsuit,/datum/armourspecials/gear/unggoy_tank)

/obj/item/clothing/mask/rebreather
	name = "Unggoy Rebreather Mask"

	icon = GRUNT_GEAR_ICON
	icon_override = GRUNT_GEAR_ICON
	icon_state = "rebreather"
	item_state = "rebreather"

	species_restricted = list("Unggoy")

	body_parts_covered = HEAD|FACE
	item_flags = BLOCK_GAS_SMOKE_EFFECT | AIRTIGHT
	armor = list(melee = 40, bullet = 20, laser = 35,energy = 35, bomb = 15, bio = 0, rad = 0)
	armor_thickness = 10

	var/rebreath_efficiency = 50 //Rebreather efficiency: Percentile

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
	name = "methane tank"
	desc = "A tank of methane."
	icon_state = "oxygen_fr"
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD


/obj/item/weapon/tank/methane/New()
	..()
	air_contents.adjust_gas("methane", (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/weapon/tank/methane/unggoy_internal
	name = "Unggoy methane tank"
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
/obj/item/clothing/suit/armor/special/unggoy_combat_harness

	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS //Essentially, the entire body besides the head

	species_restricted = list("Unggoy")

	specials = list(/datum/armourspecials/gear/unggoy_jumpsuit,/datum/armourspecials/gear/unggoy_tank)

/obj/item/clothing/suit/armor/special/unggoy_combat_harness/major
	name = "Unggoy Combat Harness (Major)"
	desc = "A combat harness with an inbuilt gas tank"
	icon = GRUNT_GEAR_ICON
	icon_override = GRUNT_GEAR_ICON
	icon_state = "combatharness_major"
	item_state = "combatharness_major"

	armor = list(melee = 50, bullet = 45, laser = 20, energy = 20, bomb = 60, bio = 0, rad = 0) //As good as armor

/obj/item/clothing/suit/armor/special/unggoy_combat_harness/ultra
	name = "Unggoy Combat Harness (Ultra)"
	desc = "A combat harness with an inbuilt gas tank"
	icon = GRUNT_GEAR_ICON
	icon_override = GRUNT_GEAR_ICON
	icon_state = "combatharness_ultra"
	item_state = "combatharness_ultra"

	armor = list(melee = 45, bullet = 40, laser = 15, energy = 15, bomb = 50, bio = 0, rad = 0)

	totalshields = 100
	specials = list(/datum/armourspecials/gear/unggoy_jumpsuit,/datum/armourspecials/gear/unggoy_tank,/datum/armourspecials/shields/unggoy)

/obj/item/clothing/suit/armor/special/unggoy_combat_harness/specops
	name = "Unggoy Combat Harness (Spec-Ops)"
	desc = "A combat harness with an inbuilt gas tank"
	icon = GRUNT_GEAR_ICON
	icon_override = GRUNT_GEAR_ICON
	icon_state = "combatharness_specops"
	item_state = "combatharness_specops"

	action_button_name = "Toggle Active Camouflage"
	specials = list(/datum/armourspecials/gear/unggoy_jumpsuit,/datum/armourspecials/gear/unggoy_tank,/datum/armourspecials/cloaking)

/obj/item/clothing/suit/armor/special/unggoy_combat_harness/deacon
	name = "Unggoy Combat Harness (Deacon)"
	desc = "A combat harness with an inbuilt gas tank."
	icon = GRUNT_GEAR_ICON
	icon_override = GRUNT_GEAR_ICON
	icon_state = "combatharness_deacon"
	item_state = "combatharness_deacon"
	totalshields = 50 //Pretty much just a distinguishing feature.

	specials = list(/datum/armourspecials/gear/unggoy_jumpsuit,/datum/armourspecials/gear/unggoy_tank,/datum/armourspecials/shields/unggoy)

/obj/item/clothing/mask/rebreather/unggoy_spec_ops
	name = "Unggoy Rebreather Mask (Spec-Ops)"

	icon_state = "rebreather_specops"
	item_state = "rebreather_specops"

	rebreath_efficiency = 70

/obj/item/clothing/mask/rebreather/unggoy_deacon
	name = "Unggoy Rebreather Mask (Deacon)"

	icon_state = "rebreather_deacon"
	item_state = "rebreather_deacon"

	rebreath_efficiency = 65

/obj/item/clothing/shoes/grunt_boots
	name = "Natural Armor"
	desc = "The natural armor on your legs provides a small amount of protection against the elements."
	icon = 'code/modules/halo/icons/species/grunt_gear.dmi'
	icon_state = "naturallegarmor"
	item_state = " "

	canremove = 0

/obj/item/clothing/shoes/grunt_gloves
	name = "Natural Armor"
	desc = "The natural armor on your arms provides a small amount of protection against the elements."
	icon = 'code/modules/halo/icons/species/grunt_gear.dmi'
	icon_state = "naturalhandarmor"
	item_state = " "

	canremove = 0


#undef GRUNT_GEAR_ICON