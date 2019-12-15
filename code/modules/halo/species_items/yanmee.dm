#define YANMEE_ICON 'code/modules/halo/icons/species/yanmee_gear.dmi'

GLOBAL_LIST_INIT(yanmee_nicknames, world.file2list('code/modules/halo/species_items/yanmee_nicknames.txt'))

/datum/language/yanmee_hivemind
	name = "Yanme e Hivemind"
	desc = "The hivemind language of the Yanme e"
	native = 1
	colour = "vox"
	key = "Y"
	flags = RESTRICTED|NO_TALK_MSG|NO_STUTTER|HIVEMIND

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
	canremove = 0
	unacidable = 1

/obj/item/clothing/gloves/drone_gloves
	name = "Exoskeleton"
	desc = "The natural armor on your arms provides a small amount of protection against the elements. It also stops electrical shocks."
	icon = YANMEE_ICON
	icon_override = YANMEE_ICON
	icon_state = "exoskeleton_hands"
	item_state = "blank"
	species_restricted = list("Yanme e")
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
	armor = list(melee = 65, bullet = 50, laser = 20, energy = 20, bomb = 45, bio = 25, rad = 20)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS|HANDS|FEET|HEAD
	item_flags = AIRTIGHT|FLEXIBLEMATERIAL
	canremove = 0
	unacidable = 1

/obj/item/clothing/suit/armor/special/yanmee/major
	icon_state = "major_harness"
	item_state = "major_harness"

/obj/item/clothing/suit/armor/special/yanmee/ultra
	icon_state = "ultra_harness"
	item_state = "ultra_harness"
	specials = list(/datum/armourspecials/shields)
	totalshields = 30

/obj/item/clothing/suit/armor/special/yanmee/leader
	icon_state = "leader_harness"
	item_state = "leader_harness"
	specials = list(/datum/armourspecials/shields)
	totalshields = 50

#undef YANMEE_ICON