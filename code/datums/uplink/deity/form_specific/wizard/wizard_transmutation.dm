/datum/uplink_item/item/deity/leveled/transmutation
	name = DEITY_LEVELED_TRANSMUTATION
	desc = "Transmutation is the school of change. It cannot be used to create things, only modify them or even destroy them."
	category = /datum/uplink_category/deity_wizard_transmutation
	required_feats = list(DEITY_TREE_TRANSMUTATION)
	max_level = 3
	item_cost = 100

/datum/uplink_item/item/deity/boon/single_charge/transmutation
	category = /datum/uplink_category/deity_wizard_transmutation
	required_feats = list(DEITY_LEVELED_TRANSMUTATION = 1)

/datum/uplink_item/item/deity/feat/phenomena/transmutation
	category = /datum/uplink_category/deity_wizard_transmutation
	required_feats = list(DEITY_LEVELED_TRANSMUTATION = 1)

//Level 1
/datum/uplink_item/item/deity/boon/single_charge/transmutation/slippery_surface
	name = "Slippery Surface"
	desc = "Allows a follower to slicken a small patch of floor. Anyone without sure-footing will find it hard to stay upright."
	item_cost = 10
	path = /spell/hand/slippery_surface

/datum/uplink_item/item/deity/boon/single_charge/transmutation/smoke
	name = "Smoke"
	desc = "Allows a follower to distill the nearby air into smoke."
	item_cost = 10
	path = /spell/aoe_turf/smoke

/datum/uplink_item/item/deity/feat/phenomena/transmutation/animation
	name = "Animation Phenomena"
	desc = "Gain the ability to transform objects into mimics."
	item_cost = 75
	path = /datum/phenomena/animate

//Level 2
/datum/uplink_item/item/deity/boon/single_charge/transmutation/knock
	name = "Knock"
	desc = "Allows a follower to open nearby doors without the keys."
	item_cost = 25
	path = /spell/aoe_turf/knock
	required_feats = list(DEITY_LEVELED_TRANSMUTATION = 2)

/datum/uplink_item/item/deity/boon/single_charge/transmutation/burning_grip
	name = "Burning Grip"
	desc = "Allows a follower cause an object to heat up intensly in someone's hand, making them drop it and whatever skin is attached."
	item_cost = 15
	path = /spell/hand/burning_grip
	required_feats = list(DEITY_LEVELED_TRANSMUTATION = 2)

/datum/uplink_item/item/deity/feat/phenomena/transmutation/warp_body
	name = "Warp Body"
	desc = "Gain the ability to warp the very structure of a target's body, wracking pain and weakness."
	item_cost = 75
	required_feats = list(DEITY_LEVELED_TRANSMUTATION = 2)
	path = /datum/phenomena/rock_form

//Level 3
/datum/uplink_item/item/deity/boon/single_charge/transmutation/jaunt
	name = "Ethereal Jaunt"
	desc = "Allows a follower to liquify for a short duration, letting them pass through all dense objects."
	item_cost = 25
	path = /spell/targeted/ethereal_jaunt
	required_feats = list(DEITY_LEVELED_TRANSMUTATION = 3)

/datum/uplink_item/item/deity/feat/healing_spells
	name = DEITY_UNLOCK_HEAL
	desc = "Of transmutation, healing is perhaps the most immediately effective and useful. This unlocks the healing spells for your followers."
	item_cost = 50
	required_feats = list(DEITY_LEVELED_TRANSMUTATION = 3)
	category = /datum/uplink_category/deity_wizard_transmutation

/datum/uplink_item/item/deity/boon/single_charge/heal
	name = "Minor Heal"
	desc = "Allows your follower to heal themselves, or others, for a slight amount."
	item_cost = 15
	required_feats = list(DEITY_UNLOCK_HEAL)
	category = /datum/uplink_category/deity_wizard_transmutation
	path = /spell/targeted/heal_target

/datum/uplink_item/item/deity/boon/single_charge/heal/major
	name = "Major Heal"
	desc = "Allows your follower to heal others for a great amount."
	item_cost = 25
	path = /spell/targeted/heal_target/major

/datum/uplink_item/item/deity/boon/single_charge/heal/area
	name = "Area Heal"
	desc = "Allows your follower to heal everyone in an area for minor damage."
	item_cost = 20
	path = /spell/targeted/heal_target/area

/datum/uplink_item/item/deity/feat/phenomena/transmutation/rock_form
	name = "Rock Form"
	desc = "Gain the ability to transform your followers into beings of rock and stone."
	item_cost = 75
	required_feats = list(DEITY_LEVELED_TRANSMUTATION = 3)
	path = /datum/phenomena/rock_form