/datum/deity_item/transmutation
	name = DEITY_TREE_TRANSMUTATION
	desc = "Transmutation is the school of change. It cannot be used to create things, only modify them or even destroy them."
	category = DEITY_TREE_TRANSMUTATION
	max_level = 3
	base_cost = 50

/datum/deity_item/conjuration/get_cost(var/mob/living/deity/D)
	return base_cost * (level + 1)

//Level 1
/datum/deity_item/boon/single_charge/slippery_surface
	name = "Slippery Surface"
	desc = "Allows a follower to slicken a small patch of floor. Anyone without sure-footing will find it hard to stay upright."
	base_cost = 10
	category = DEITY_TREE_TRANSMUTATION
	boon_path = /spell/hand/slippery_surface/tower

/datum/deity_item/boon/single_charge/smoke
	name = "Smoke"
	desc = "Allows a follower to distill the nearby air into smoke."
	base_cost = 10
	category = DEITY_TREE_TRANSMUTATION
	boon_path = /spell/aoe_turf/smoke/tower

//Level 2
/datum/deity_item/boon/single_charge/knock
	name = "Knock"
	desc = "Allows a follower to open nearby doors without the keys."
	base_cost = 25
	category = DEITY_TREE_TRANSMUTATION
	boon_path = /spell/aoe_turf/knock/tower
	requirements = list(DEITY_TREE_TRANSMUTATION = 2)

/datum/deity_item/boon/single_charge/burning_grip
	name = "Burning Grip"
	desc = "Allows a follower cause an object to heat up intensly in someone's hand, making them drop it and whatever skin is attached."
	base_cost = 15
	boon_path = /spell/hand/burning_grip/tower
	category = DEITY_TREE_TRANSMUTATION
	requirements = list(DEITY_TREE_TRANSMUTATION = 2)

/datum/deity_item/phenomena/warp_body
	name = "Phenomena: Warp Body"
	desc = "Gain the ability to warp the very structure of a target's body, wracking pain and weakness."
	base_cost = 75
	category = DEITY_TREE_TRANSMUTATION
	requirements = list(DEITY_TREE_TRANSMUTATION = 2)
	phenomena_path = /datum/phenomena/warp

//Level 3
/datum/deity_item/boon/single_charge/jaunt
	name = "Ethereal Jaunt"
	desc = "Allows a follower to liquify for a short duration, letting them pass through all dense objects."
	base_cost = 25
	category = DEITY_TREE_TRANSMUTATION
	boon_path = /spell/targeted/ethereal_jaunt/tower
	requirements = list(DEITY_TREE_TRANSMUTATION = 3)

/datum/deity_item/healing_spells
	name = DEITY_UNLOCK_HEAL
	desc = "Of transmutation, healing is perhaps the most immediately effective and useful. This unlocks the healing spells for your followers."
	base_cost = 50
	category = DEITY_TREE_TRANSMUTATION
	requirements = list(DEITY_TREE_TRANSMUTATION = 3)
	category = DEITY_TREE_TRANSMUTATION

/datum/deity_item/boon/single_charge/heal
	name = "Minor Heal"
	desc = "Allows your follower to heal themselves, or others, for a slight amount."
	base_cost = 15
	category = DEITY_TREE_TRANSMUTATION
	requirements = list(DEITY_UNLOCK_HEAL = 1)
	category = DEITY_TREE_TRANSMUTATION
	boon_path = /spell/targeted/heal_target/tower

/datum/deity_item/boon/single_charge/heal/major
	name = "Major Heal"
	desc = "Allows your follower to heal others for a great amount."
	base_cost = 25
	category = DEITY_TREE_TRANSMUTATION
	requirements = list(DEITY_UNLOCK_HEAL = 1)
	boon_path = /spell/targeted/heal_target/major/tower

/datum/deity_item/boon/single_charge/heal/area
	name = "Area Heal"
	desc = "Allows your follower to heal everyone in an area for minor damage."
	base_cost = 20
	category = DEITY_TREE_TRANSMUTATION
	requirements = list(DEITY_UNLOCK_HEAL = 1)
	boon_path = /spell/targeted/heal_target/area/tower

/datum/deity_item/phenomena/rock_form
	name = "Phenomena: Rock Form"
	desc = "Gain the ability to transform your followers into beings of rock and stone."
	base_cost = 75
	category = DEITY_TREE_TRANSMUTATION
	requirements = list(DEITY_TREE_TRANSMUTATION = 3)
	phenomena_path = /datum/phenomena/rock_form