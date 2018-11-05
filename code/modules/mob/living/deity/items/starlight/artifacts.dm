/datum/deity_item/boon/blazing_blade
	name = "Blazing Blade"
	desc = "A divine blade of burning fury. If it stays too far away from an altar of some sort, it disappears."
	base_cost = 250
	category = DEITY_TREE_ARTIFACT
	boon_path = /obj/item/weapon/material/sword/blazing

/datum/deity_item/boon/holy_beacon
	name = "Holy Beacon"
	desc = "A staff capable of producing an almost harmless bolt of sunlight, capable of blinding anyone in the room, at least for a while."
	base_cost = 200
	category = DEITY_TREE_ARTIFACT
	boon_path = /obj/item/weapon/gun/energy/staff/beacon

/datum/deity_item/boon/black_death
	name = "Black Death"
	desc = "A small dagger capable of poisoning those it bites. Careful, if it loses all its charges, it will burn the user. It can be recharged at a radiant statue."
	base_cost = 150
	category = DEITY_TREE_ARTIFACT
	boon_path = /obj/item/weapon/material/knife/ritual/shadow

/datum/deity_item/blood_crafting/firecrafting
	name = "Fire Crafting"
	desc = "Gain the ability for your minions to build smithing stations that can make many rings of power."
	base_cost = 300
	category = DEITY_TREE_ARTIFACT
	max_level = 1
	forge_type = /obj/structure/deity/blood_forge/starlight
	recipes = list(/obj/item/clothing/ring/aura_ring/talisman_of_starborn = 70,
							/obj/item/clothing/ring/aura_ring/talisman_of_blueforged = 70,
							/obj/item/clothing/ring/aura_ring/talisman_of_shadowling = 70
							)