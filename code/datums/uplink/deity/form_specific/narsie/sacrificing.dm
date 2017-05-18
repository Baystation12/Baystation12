/datum/uplink_item/item/deity/boon/narsie_sacrificing
	category = /datum/uplink_category/deity_narsie_sacrifice
	required_feats = list(DEITY_TREE_SACRIFICE)

/datum/uplink_item/item/deity/boon/narsie_sacrificing/sac_dagger
	name = "Sacrificial Dagger"
	desc = "A small dagger embued with your powers. Lets your followers give you power through sacrifices on an altar."
	item_cost = 10
	path = /obj/item/weapon/material/knife/ritual/sacrifice

/datum/uplink_item/item/deity/boon/narsie_sacrificing/sac_spell
	name = "Sacrifice Spell"
	desc = "This spell allows your followers to pay the ultimate price for another."
	item_cost = 10
	path = /spell/targeted/heal_target/sacrifice

/datum/uplink_item/item/deity/boon/narsie_sacrificing/execution_axe
	name = "Greedy Axe"
	desc = "This axe can store the very souls of those it kills to be later transfered to you through an altar."
	item_cost = 50
	path = /obj/item/weapon/material/twohanded/fireaxe/cult

/datum/uplink_item/item/deity/feat/blood_stone
	name = "Bloodied Stone"
	desc = "Unlocks the blood stone building, which allows followers to increase your power through ritual and prayer."
	item_cost = 50
	category = /datum/uplink_category/deity_narsie_sacrifice
	required_feats = list("Nar-Sie", "Sacrificing")

/datum/uplink_item/item/deity/feat/blood_stone/buy(var/obj/item/device/uplink/U, var/mob/living/deity/user)
	. = ..()
	if(.)
		user.form.buildables |= /obj/structure/deity/blood_stone