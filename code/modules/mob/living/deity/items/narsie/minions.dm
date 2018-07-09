/datum/deity_item/minions
	name = DEITY_TREE_DARK_MINION
	desc = "Unlock abilities that allow your followers to craft and summon useful creatures."
	category = DEITY_TREE_DARK_MINION
	base_cost = 75

/datum/deity_item/boon/soul_shard
	name = "Soul Stone Shard"
	desc = "Give your follower a sliver of soulstone to capture a life in."
	category = DEITY_TREE_DARK_MINION
	requirements = list(DEITY_TREE_DARK_MINION = 1)
	base_cost = 20
	boon_path = /obj/item/device/soulstone

/datum/deity_item/boon/blood_zombie
	name = "Blood Plague"
	desc = "Give a vessel to a follower filled with infection so vile, it turns all sapient creatures into mindless husks."
	category = DEITY_TREE_DARK_MINION
	requirements = list(DEITY_TREE_DARK_MINION = 1)
	base_cost = 300
	boon_path = /obj/item/weapon/reagent_containers/food/drinks/zombiedrink

/datum/deity_item/boon/tear_veil
	name = "Tear Veil"
	desc = "Grant your follower the ability to literally rip a hole in this reality, allowing things to pass through."
	category = DEITY_TREE_DARK_MINION
	requirements = list(DEITY_TREE_DARK_MINION = 1)
	base_cost = 100
	boon_path = /spell/tear_veil

/datum/deity_item/phenomena/hellscape
	name = "Phenomena: Reveal Hellscape"
	desc = "You show a non-believer what their future will be like."
	category = DEITY_TREE_DARK_MINION
	requirements = list(DEITY_TREE_DARK_MINION = 1)
	base_cost = 110
	phenomena_path = /datum/phenomena/hellscape