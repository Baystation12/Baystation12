/datum/uplink_item/item/deity/feat/unlocking
	category = /datum/uplink_category/deity_unlocks

/datum/uplink_item/item/deity/feat/unlocking/blood_crafting
	name = "Blood Crafting"
	desc = "Unlocks the blood smithing structure which allows followers to forge unholy tools from blood and flesh."
	item_cost = 100
	required_feats = list("Nar-Sie")
	var/list/recipes = list(/obj/item/weapon/melee/cultblade = 50,
							/obj/item/clothing/head/culthood/alt = 10,
							/obj/item/clothing/suit/cultrobes/alt = 20
							)

/datum/uplink_item/item/deity/feat/unlocking/blood_crafting/buy(var/obj/item/device/uplink/U, var/mob/living/deity/user)
	. = ..()
	if(.)
		user.buildables += /obj/structure/deity/blood_forge //put structure here
		var/list/L = user.feats["Blood Crafting"]
		if(!L)
			L = list()
		for(var/type in recipes)
			L[type] = recipes[type]
		user.feats["Blood Crafting"] = L

/datum/uplink_item/item/deity/feat/unlocking/blood_crafting/armored
	name = "Armor Crafting"
	desc = "Unlock the secrets to tempered blood smithing, allowing your followers to smith more powerful and expensive armaments."
	item_cost = 100
	required_feats = list("Blood Crafting")
	recipes = list(/obj/item/clothing/suit/cultrobes/magusred = 80,
					/obj/item/clothing/head/culthood/magus = 50,
					/obj/structure/constructshell/cult = 70) //also shield?

/datum/uplink_item/item/deity/feat/unlocking/blood_crafting/space
	name = "Void Crafting"
	desc = "Allows your followers to craft space suits, allowing you to finally spread across the cosmos."
	item_cost = 100
	required_feats = list("Armor Crafting")
	recipes = list(/obj/item/clothing/suit/space/cult = 100,
					/obj/item/clothing/head/helmet/space/cult = 70) //Probably more too.

/datum/uplink_item/item/deity/feat/unlocking/sacrifice
	name = "Sacrificing"
	desc = "Unlocks the tools necessary to allow your followers to sacrifice in your name."
	item_cost = 75
	required_feats = list("Nar-Sie")

/datum/uplink_item/item/deity/feat/unlocking/soul_arts
	name = "Soul Arts"
	desc = "Unlock abilities that allow your followers to craft and summon useful creatures."
	item_cost = 100
	required_feats = list("Nar-Sie")