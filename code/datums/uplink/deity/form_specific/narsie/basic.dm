/datum/uplink_item/item/deity/boon/ability_dark
	category = /datum/uplink_category/deity_ability_dark
	required_feats = list("Nar-Sie")

/datum/uplink_item/item/deity/boon/ability_dark/shatter_mind
	name = "Eternal Darkness"
	desc = "Allows a follower to cause insanity in a target."
	item_cost = 40
	path = /spell/targeted/shatter

/datum/uplink_item/item/deity/boon/ability_dark/torment
	name = "Torment"
	desc = "Gives a follower the ability to cause mass hystery and pain."
	item_cost = 30
	path = /spell/targeted/torment

/datum/uplink_item/item/deity/boon/ability_dark/blood_shard
	name = "Bloodshard"
	desc = "Lets a follower cause a target's blood to literally explode out of their skin into dangerous projectiles."
	item_cost = 40
	path = /spell/hand/charges/blood_shard

/datum/uplink_item/item/deity/boon/ability_dark/drain_blood
	name = "Drain Blood"
	desc = "Lets a follower drain blood from all those around them."
	item_cost = 60
	path = /spell/aoe_turf/drain_blood