/datum/deity_item/sacrifice
	name = DEITY_TREE_SACRIFICE
	desc = "Unlocks the tools necessary to allow your followers to sacrifice in your name."
	category = DEITY_TREE_SACRIFICE
	base_cost = 50
	max_level = 1

/datum/deity_item/boon/sac_dagger
	name = "Sacrificial Dagger"
	desc = "A small dagger embued with your powers. Lets your followers give you power through sacrifices on an altar."
	category = DEITY_TREE_SACRIFICE
	requirements = list(DEITY_TREE_SACRIFICE = 1)
	base_cost = 10
	boon_path = /obj/item/weapon/material/knife/ritual/sacrifice

/datum/deity_item/boon/sac_spell
	name = "Sacrifice Spell"
	desc = "This ability makes the user take INCREDIBLE amounts of damage to heal a target for a similar amount of damage."
	category = DEITY_TREE_SACRIFICE
	requirements = list(DEITY_TREE_SACRIFICE = 1)
	base_cost = 10
	boon_path = /spell/targeted/heal_target/sacrifice

/datum/deity_item/boon/execution_axe
	name = "Greedy Axe"
	desc = "This axe can store the very souls of those it kills to be later transfered to you through an altar."
	category = DEITY_TREE_SACRIFICE
	requirements = list(DEITY_TREE_SACRIFICE = 1)
	base_cost = 50
	boon_path = /obj/item/weapon/material/twohanded/fireaxe/cult

/datum/deity_item/blood_stone
	name = "Bloodied Stone"
	desc = "Unlocks the blood stone building, which allows followers to increase your power through ritual and prayer."
	category = DEITY_TREE_SACRIFICE
	requirements = list(DEITY_TREE_SACRIFICE = 1)
	base_cost = 50
	max_level = 1

/datum/deity_item/blood_stone/buy(var/mob/living/deity/user)
	..()
	user.form.buildables |= /obj/structure/deity/blood_stone