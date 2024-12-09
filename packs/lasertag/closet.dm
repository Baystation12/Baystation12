/obj/structure/closet/lasertag/red
	name = "red laser tag equipment"
	desc = "It's a storage unit for laser tag equipment."
	closet_appearance = /singleton/closet_appearance/wardrobe/red


/obj/structure/closet/lasertag/red/WillContain()
	return list(
		/obj/item/gun/energy/lasertag/red = 3,
		/obj/item/clothing/suit/redtag = 3)


/obj/structure/closet/lasertag/blue
	name = "blue laser tag equipment"
	desc = "It's a storage unit for laser tag equipment."
	closet_appearance = /singleton/closet_appearance/wardrobe


/obj/structure/closet/lasertag/blue/WillContain()
	return list(
		/obj/item/gun/energy/lasertag/blue = 3,
		/obj/item/clothing/suit/bluetag = 3)
