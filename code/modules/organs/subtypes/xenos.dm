//XENOMORPH ORGANS
/obj/item/organ/xenos
	name = "xeno organ"
	icon = 'icons/effects/blood.dmi'
	desc = "It smells like an accident in a chemical factory."

/obj/item/organ/xenos/eggsac
	name = "egg sac"
	parent_organ = "groin"
	icon_state = "xgibmid1"
	organ_tag = "egg sac"

/obj/item/organ/xenos/plasmavessel
	name = "plasma vessel"
	parent_organ = "chest"
	icon_state = "xgibdown1"
	organ_tag = "plasma vessel"
	var/stored_plasma = 0
	var/max_plasma = 500

/obj/item/organ/xenos/plasmavessel/queen
	name = "bloated plasma vessel"
	stored_plasma = 200
	max_plasma = 500

/obj/item/organ/xenos/plasmavessel/sentinel
	stored_plasma = 100
	max_plasma = 250

/obj/item/organ/xenos/plasmavessel/hunter
	name = "tiny plasma vessel"
	stored_plasma = 100
	max_plasma = 150

/obj/item/organ/xenos/acidgland
	name = "acid gland"
	parent_organ = "head"
	icon_state = "xgibtorso"
	organ_tag = "acid gland"

/obj/item/organ/xenos/hivenode
	name = "hive node"
	parent_organ = "chest"
	icon_state = "xgibmid2"
	organ_tag = "hive node"

/obj/item/organ/xenos/resinspinner
	name = "resin spinner"
	parent_organ = "head"
	icon_state = "xgibmid2"
	organ_tag = "resin spinner"

// Xenophage limbs.
// This is getting very Dwarf Fortress.
/obj/item/organ/external/arm/unbreakable/insectoid
	name = "front left legs"
	gender = PLURAL
	joint = "front left leg junction"
	amputation_point = "front left leg plate"

/obj/item/organ/external/arm/right/unbreakable/insectoid
	name = "front right legs"
	gender = PLURAL
	joint = "front right leg junction"
	amputation_point = "front right leg plate"

/obj/item/organ/external/leg/unbreakable/insectoid
	name = "rear left legs"
	gender = PLURAL
	joint = "rear left leg junction"
	amputation_point = "rear left leg plate"

/obj/item/organ/external/leg/right/unbreakable/insectoid
	name = "rear right legs"
	gender = PLURAL
	joint = "rear right leg junction"
	amputation_point = "rear right leg plate"

/obj/item/organ/external/foot/unbreakable/insectoid
	name = "rear left claws"
	gender = PLURAL
	joint = "rear left ankles"
	amputation_point = "rear left legs"

/obj/item/organ/external/foot/right/unbreakable/insectoid
	name = "rear right claws"
	gender = PLURAL
	joint = "rear right ankles"
	amputation_point = "rear right legs"

/obj/item/organ/external/hand/unbreakable/insectoid
	name = "front left claws"
	gender = PLURAL
	joint = "front left ankles"
	amputation_point = "front left legs"

/obj/item/organ/external/hand/right/unbreakable/insectoid
	name = "front right claws"
	gender = PLURAL
	joint = "front right ankles"
	amputation_point = "front right legs"
