/datum/deity_item/blood_crafting
	name = DEITY_BLOOD_CRAFT
	desc = "Unlocks the blood smithing structure which allows followers to forge unholy tools from blood and flesh."
	category = DEITY_BLOOD_CRAFT
	max_level = 1
	base_cost = 75
	var/forge_type = /obj/structure/deity/blood_forge
	var/list/recipes = list(/obj/item/weapon/melee/cultblade = 50,
							/obj/item/clothing/head/culthood/alt = 10,
							/obj/item/clothing/suit/cultrobes/alt = 20
							)

/datum/deity_item/blood_crafting/buy(var/mob/living/deity/user)
	..()
	user.form.buildables |= forge_type //put structure here
	var/list/L = user.feats[name]
	if(!L)
		L = list()
	for(var/type in recipes)
		L[type] = recipes[type]
	user.feats[name] = L

/datum/deity_item/blood_crafting/armored
	name = DEITY_ARMOR_CRAFT
	desc = "Unlock the secrets to tempered blood smithing, allowing your followers to smith more powerful and expensive armaments."
	category = DEITY_BLOOD_CRAFT
	base_cost = 75
	requirements = list(DEITY_BLOOD_CRAFT = 1)
	recipes = list(/obj/item/clothing/suit/cultrobes/magusred = 80,
					/obj/item/clothing/head/culthood/magus = 50,
					/obj/structure/constructshell/cult = 70) //also shield?

/datum/deity_item/blood_crafting/space
	name = DEITY_VOID_CRAFT
	desc = "Allows your followers to craft space suits, allowing you to finally spread across the cosmos."
	category = DEITY_BLOOD_CRAFT
	base_cost = 100
	requirements = list(DEITY_BLOOD_CRAFT = 1, DEITY_ARMOR_CRAFT = 1)
	recipes = list(/obj/item/clothing/suit/space/cult = 100,
					/obj/item/clothing/head/helmet/space/cult = 70) //Probably more too.