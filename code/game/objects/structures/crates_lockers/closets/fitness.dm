/obj/structure/closet/athletic_mixed
	name = "athletic wardrobe"
	desc = "It's a storage unit for athletic wear."
	closet_appearance = /singleton/closet_appearance/wardrobe/mixed

/obj/structure/closet/athletic_mixed/WillContain()
	return list(
		/obj/item/clothing/under/shorts/grey,
		/obj/item/clothing/under/shorts/black,
		/obj/item/clothing/under/shorts/red,
		/obj/item/clothing/under/shorts/blue,
		/obj/item/clothing/under/shorts/green,
		/obj/item/clothing/under/swimsuit/red,
		/obj/item/clothing/under/swimsuit/black,
		/obj/item/clothing/under/swimsuit/blue,
		/obj/item/clothing/under/swimsuit/green,
		/obj/item/clothing/under/swimsuit/purple,
		/obj/item/clothing/mask/snorkel = 2,
		/obj/item/clothing/shoes/swimmingfins = 2,
		/obj/item/towel = 2)

/obj/structure/closet/boxinggloves
	name = "boxing gloves"
	desc = "It's a storage unit for gloves for use in the boxing ring."

/obj/structure/closet/boxinggloves/WillContain()
	return list(
		/obj/item/clothing/gloves/boxing/blue,
		/obj/item/clothing/gloves/boxing/green,
		/obj/item/clothing/gloves/boxing/yellow,
		/obj/item/clothing/gloves/boxing)

/obj/structure/closet/masks
	name = "mask closet"
	desc = "IT'S A STORAGE UNIT FOR FIGHTER MASKS OLE!"

/obj/structure/closet/masks/WillContain()
	return list(
		/obj/item/clothing/mask/luchador,
		/obj/item/clothing/mask/luchador/rudos,
		/obj/item/clothing/mask/luchador/tecnicos)
