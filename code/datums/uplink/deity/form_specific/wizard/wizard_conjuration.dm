/datum/uplink_item/item/deity/leveled/conjuration
	name = DEITY_LEVELED_CONJURATION
	desc = "Conjuration is the school of creation and teleportation, summoning fireballs or teleporting long distances, this school is extremely powerful."
	category = /datum/uplink_category/deity_wizard_conjuration
	required_feats = list(DEITY_TREE_CONJURATION)
	max_level = 3
	item_cost = 100

/datum/uplink_item/item/deity/boon/single_charge/conjuration
	category = /datum/uplink_category/deity_wizard_conjuration
	required_feats = list(DEITY_LEVELED_CONJURATION = 1)

//Level 1
/datum/uplink_item/item/deity/boon/single_charge/conjuration/acid_spray
	name = "Acid Spray"
	desc = "The simplest form of aggressive conjuration: acid spray is quite effective in melting both man and object."
	item_cost = 50
	path = /spell/acid_spray