/datum/uplink_item/item/deity/boon/soul_arts
	category = /datum/uplink_category/deity_narsie_minions
	required_feats = list("Nar-Sie", "Soul Arts")

/datum/uplink_item/item/deity/boon/soul_arts/soul_shard
	name = "Soul Stone Shard"
	desc = "Give your follower a sliver of soulstone to capture a life in."
	item_cost = 10
	path = /obj/item/device/soulstone

/datum/uplink_item/item/deity/boon/soul_arts/blood_zombie
	name = "Blood Plague"
	desc = "Give a vessel to a follower filled with infection so vile, it turns all sapient creatures into mindless husks."
	item_cost = 400 //End game shit.
	path = /obj/item/weapon/reagent_containers/food/drinks/zombiedrink

/datum/uplink_item/item/deity/boon/soul_arts/tear_veil
	name = "Tear Veil"
	desc = "Grant your follower the ability to literally rip a hole in this reality, allowing things to pass through."
	item_cost = 50
	path = /spell/tear_veil