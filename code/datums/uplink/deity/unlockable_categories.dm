/datum/uplink_item/item/deity/feat/unlocking
	category = /datum/uplink_category/deity_unlocks

/datum/uplink_item/item/deity/feat/unlocking/blood_crafting
	name = DEITY_BLOOD_CRAFT
	desc = "Unlocks the blood smithing structure which allows followers to forge unholy tools from blood and flesh."
	item_cost = 100
	required_feats = list(DEITY_FORM_BLOOD_FORGE)
	var/list/recipes = list(/obj/item/weapon/melee/cultblade = 50,
							/obj/item/clothing/head/culthood/alt = 10,
							/obj/item/clothing/suit/cultrobes/alt = 20
							)

/datum/uplink_item/item/deity/feat/unlocking/blood_crafting/buy(var/obj/item/device/uplink/U, var/mob/living/deity/user)
	. = ..()
	if(.)
		user.buildables += /obj/structure/deity/blood_forge //put structure here
		var/list/L = user.feats[DEITY_BLOOD_CRAFT]
		if(!L)
			L = list()
		for(var/type in recipes)
			L[type] = recipes[type]
		user.feats[DEITY_BLOOD_CRAFT] = L

/datum/uplink_item/item/deity/feat/unlocking/blood_crafting/armored
	name = DEITY_ARMOR_CRAFT
	desc = "Unlock the secrets to tempered blood smithing, allowing your followers to smith more powerful and expensive armaments."
	item_cost = 100
	required_feats = list(DEITY_BLOOD_CRAFT)
	recipes = list(/obj/item/clothing/suit/cultrobes/magusred = 80,
					/obj/item/clothing/head/culthood/magus = 50,
					/obj/structure/constructshell/cult = 70) //also shield?

/datum/uplink_item/item/deity/feat/unlocking/blood_crafting/space
	name = DEITY_VOID_CRAFT
	desc = "Allows your followers to craft space suits, allowing you to finally spread across the cosmos."
	item_cost = 100
	required_feats = list(DEITY_ARMOR_CRAFT)
	recipes = list(/obj/item/clothing/suit/space/cult = 100,
					/obj/item/clothing/head/helmet/space/cult = 70) //Probably more too.

/datum/uplink_item/item/deity/feat/unlocking/sacrifice
	name = DEITY_TREE_SACRIFICE
	desc = "Unlocks the tools necessary to allow your followers to sacrifice in your name."
	item_cost = 75
	required_feats = list(DEITY_FORM_BLOOD_SAC)

/datum/uplink_item/item/deity/feat/unlocking/soul_arts
	name = DEITY_TREE_SOUL
	desc = "Unlock abilities that allow your followers to craft and summon useful creatures."
	item_cost = 100
	required_feats = list(DEITY_FORM_DARK_MINION)