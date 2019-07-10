/datum/craft_recipe/clothing
	category = "Clothing"
	icon_state = "clothing"
	time = 100

/datum/craft_recipe/clothing/cardborg_suit
	name = "cardborg suit"
	result = /obj/item/clothing/suit/cardborg
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_CARDBOARD, 3)
	)

/datum/craft_recipe/clothing/cardborg_helmet
	name = "cardborg helmet"
	result = /obj/item/clothing/head/cardborg
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_CARDBOARD, 3)
	)

/datum/craft_recipe/clothing/sandals
	name = "wooden sandals"
	result = /obj/item/clothing/shoes/sandal
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_WOOD, 1)
	)

/datum/craft_recipe/clothing/armorvest
	name = "armor vest"
	result = /obj/item/clothing/suit/armor/vest/handmade
	steps = list(
		list(CRAFT_OBJECT, /obj/item/clothing/suit/storage/hazardvest, "time" = 30),
		list(CRAFT_MATERIAL,MATERIAL_STEEL, 4),
		list(CRAFT_STACK, /obj/item/stack/cable_coil, 4)
	)

/datum/craft_recipe/clothing/combat_helmet
	name = "combat helmet"
	result = /obj/item/clothing/head/helmet/handmade
	steps = list(
		list(CRAFT_OBJECT, /obj/item/weapon/reagent_containers/glass/bucket,"time" = 30),
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 4),
		list(CRAFT_STACK, /obj/item/stack/cable_coil, 4)
	)