/decl/hierarchy/supply_pack/hospitality
	name = "Hospitality"

/decl/hierarchy/supply_pack/hospitality/party
	name = "Party equipment"
	contains = list(
			/obj/item/weapon/storage/box/mixedglasses = 2,
			/obj/item/weapon/storage/box/glasses/square,
			/obj/item/weapon/reagent_containers/food/drinks/shaker,
			/obj/item/weapon/reagent_containers/food/drinks/flask/barflask,
			/obj/item/weapon/reagent_containers/food/drinks/bottle/patron,
			/obj/item/weapon/reagent_containers/food/drinks/bottle/goldschlager,
			/obj/item/weapon/reagent_containers/food/drinks/bottle/specialwhiskey,
			/obj/item/weapon/storage/fancy/cigarettes/dromedaryco,
			/obj/item/weapon/lipstick/random,
			/obj/item/weapon/reagent_containers/food/drinks/bottle/small/ale = 2,
			/obj/item/weapon/reagent_containers/food/drinks/bottle/small/beer = 4,
			/obj/item/weapon/storage/box/glowsticks = 2)
	cost = 20
	containername = "\improper Party equipment"

/decl/hierarchy/supply_pack/hospitality/barsupplies
	name = "Bar supplies"
	contains = list(
			/obj/item/weapon/storage/box/glasses/cocktail,
			/obj/item/weapon/storage/box/glasses/rocks,
			/obj/item/weapon/storage/box/glasses/square,
			/obj/item/weapon/storage/box/glasses/pint,
			/obj/item/weapon/storage/box/glasses/wine,
			/obj/item/weapon/storage/box/glasses/shake,
			/obj/item/weapon/storage/box/glasses/shot,
			/obj/item/weapon/storage/box/glasses/mug,
			/obj/item/weapon/reagent_containers/food/drinks/shaker,
			/obj/item/weapon/storage/box/glass_extras/straws,
			/obj/item/weapon/storage/box/glass_extras/sticks
			)
	cost = 10
	containername = "crate of bar supplies"

/decl/hierarchy/supply_pack/hospitality/lasertag
	name = "Lasertag equipment"
	contains = list(/obj/item/weapon/gun/energy/lasertag/red = 3,
					/obj/item/clothing/suit/redtag = 3,
					/obj/item/weapon/gun/energy/lasertag/blue = 3,
					/obj/item/clothing/suit/bluetag = 3)
	cost = 20
	containertype = /obj/structure/closet
	containername = "\improper Lasertag Closet"

/decl/hierarchy/supply_pack/hospitality/pizza
	num_contained = 5
	name = "Surprise pack of five pizzas"
	contains = list(/obj/item/pizzabox/margherita,
					/obj/item/pizzabox/mushroom,
					/obj/item/pizzabox/meat,
					/obj/item/pizzabox/vegetable)
	cost = 15
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Pizza crate"
	supply_method = /decl/supply_method/randomized
