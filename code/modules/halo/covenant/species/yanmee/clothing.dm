#define YANMEE_ICON 'code/modules/halo/covenant/species/yanmee/yanmee_gear.dmi'

/obj/item/clothing/under/yanmee_internal
	name = "Yanme\'e Exoskeletion"
	desc = "The exoskeleton of a Yanme\'e."
	icon = YANMEE_ICON
	icon_override = YANMEE_ICON
	icon_state = "exoskeleton"
	item_state = "blank"
	species_restricted = list("Yanme e")
	canremove = 0
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	unacidable = 1

/obj/item/clothing/shoes/drone_boots
	name = "Exoskeleton"
	desc = "The natural armor on your legs provides a small amount of protection against the elements."
	icon = YANMEE_ICON
	icon_override = YANMEE_ICON
	icon_state = "exoskeleton_leg"
	item_state = "blank"
	species_restricted = list("Yanme e")
	armor = list(melee = 35, bullet = 35, laser = 5, energy = 25, bomb = 15, bio = 0, rad = 0)
	canremove = 0
	unacidable = 1
	stepsound = 'code/modules/halo/sounds/walk_sounds/marine_boots.ogg'

/obj/item/clothing/gloves/drone_gloves
	name = "Exoskeleton"
	desc = "The natural armor on your arms provides a small amount of protection against the elements. It also stops electrical shocks."
	icon = YANMEE_ICON
	icon_override = YANMEE_ICON
	icon_state = "exoskeleton_hands"
	item_state = "blank"
	species_restricted = list("Yanme e")
	armor = list(melee = 30, bullet = 40, laser = 10, energy = 25, bomb = 15, bio = 0, rad = 0)
	siemens_coefficient = 0
	canremove = 0
	unacidable = 1

/obj/item/clothing/suit/armor/special/yanmee
	name = "Yanme\'e Carapace"
	desc = "A painted carapace with integrated armour and micro antigravity units to assist in flight"
	icon = YANMEE_ICON
	icon_override = YANMEE_ICON
	icon_state = "minor_harness"
	item_state = "minor_harness"
	species_restricted = list("Yanme e")
	armor = list(melee = 52, bullet = 47, laser = 52, energy = 42, bomb = 37, bio = 25, rad = 25)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS|HEAD
	item_flags = AIRTIGHT|FLEXIBLEMATERIAL
	canremove = 0
	unacidable = 1

/obj/item/clothing/suit/armor/special/yanmee/major
	icon_state = "major_harness"
	item_state = "major_harness"

/obj/item/clothing/suit/armor/special/yanmee/ultra
	icon_state = "ultra_harness"
	item_state = "ultra_harness"
	specials = list(/datum/armourspecials/shields/unggoy)
	totalshields = 20

/obj/item/clothing/suit/armor/special/yanmee/leader
	icon_state = "leader_harness"
	item_state = "leader_harness"
	specials = list(/datum/armourspecials/shields/unggoy)
	totalshields = 40

#undef YANMEE_ICON