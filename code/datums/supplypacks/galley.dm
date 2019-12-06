/decl/hierarchy/supply_pack/galley
	name = "Galley"

/decl/hierarchy/supply_pack/galley/food
	name = "General - Kitchen supplies"
	contains = list(/obj/item/weapon/reagent_containers/food/condiment/flour = 6,
					/obj/item/weapon/reagent_containers/food/drinks/milk = 4,
					/obj/item/weapon/reagent_containers/food/drinks/soymilk = 2,
					/obj/item/weapon/storage/fancy/egg_box = 2,
					/obj/item/weapon/reagent_containers/food/snacks/tofu = 4,
					/obj/item/weapon/reagent_containers/food/snacks/meat = 4,
					/obj/item/weapon/reagent_containers/food/condiment/enzyme = 1
					)
	cost = 10
	containertype = /obj/structure/closet/crate/freezer
	containername = "kitchen supplies crate"

/decl/hierarchy/supply_pack/galley/beef
	name = "Perishables - Beef"
	contains = list(/obj/item/weapon/reagent_containers/food/snacks/meat/beef = 6)
	containertype = /obj/structure/closet/crate/freezer
	containername = "cow meat crate"
	cost = 20

/decl/hierarchy/supply_pack/galley/goat
	name = "Perishables - Goat meat"
	contains = list(/obj/item/weapon/reagent_containers/food/snacks/meat/goat = 6)
	containertype = /obj/structure/closet/crate/freezer
	containername = "goat meat crate"
	cost = 20

/decl/hierarchy/supply_pack/galley/chicken
	name = "Perishables - Poultry"
	contains = list(/obj/item/weapon/reagent_containers/food/snacks/meat/chicken = 6)
	containertype = /obj/structure/closet/crate/freezer
	containername = "chicken meat crate"
	cost = 20

/decl/hierarchy/supply_pack/galley/seafood
	name = "Perishables - Seafood"
	contains = list(
		/obj/item/weapon/reagent_containers/food/snacks/fish = 2,
		/obj/item/weapon/reagent_containers/food/snacks/fish/shark = 2,
		/obj/item/weapon/reagent_containers/food/snacks/fish/octopus = 2
		)
	containertype = /obj/structure/closet/crate/freezer
	containername = "seafood crate"
	cost = 20

/decl/hierarchy/supply_pack/galley/eggs
	name = "Perishables - Eggs"
	contains = list(/obj/item/weapon/storage/fancy/egg_box = 2)
	containertype = /obj/structure/closet/crate/freezer
	containername = "egg crate"
	cost = 15

/decl/hierarchy/supply_pack/galley/milk
	name = "Perishables - Milk"
	contains = list(/obj/item/weapon/reagent_containers/food/drinks/milk = 3)
	containertype = /obj/structure/closet/crate/freezer
	containername = "milk crate"
	cost = 15

/decl/hierarchy/supply_pack/galley/pizza
	num_contained = 5
	name = "Emergency - Surprise pack of five pizzas"
	contains = list(/obj/item/pizzabox/margherita,
					/obj/item/pizzabox/mushroom,
					/obj/item/pizzabox/meat,
					/obj/item/pizzabox/vegetable)
	cost = 15
	containertype = /obj/structure/closet/crate/freezer
	containername = "pizza crate"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/galley/rations
	num_contained = 6
	name = "Emergency - MREs"
	contains = list(/obj/item/weapon/storage/mre,
					/obj/item/weapon/storage/mre/menu2,
					/obj/item/weapon/storage/mre/menu3,
					/obj/item/weapon/storage/mre/menu4,
					/obj/item/weapon/storage/mre/menu5,
					/obj/item/weapon/storage/mre/menu6,
					/obj/item/weapon/storage/mre/menu7,
					/obj/item/weapon/storage/mre/menu8,
					/obj/item/weapon/storage/mre/menu9,
					/obj/item/weapon/storage/mre/menu10)
	cost = 30
	containertype = /obj/structure/closet/crate/freezer
	containername = "emergency rations"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/galley/party
	name = "Bar - Party equipment"
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
			/obj/item/weapon/storage/box/glowsticks = 2,
			/obj/item/weapon/clothingbag/rubbermask,
			/obj/item/weapon/clothingbag/rubbersuit)
	cost = 20
	containername = "party equipment crate"

// TODO; Add more premium drinks at a later date. Could be useful for diplomatic events or fancy parties.
/decl/hierarchy/supply_pack/galley/premiumalcohol
	name = "Bar - Premium drinks"
	contains = list(/obj/item/weapon/reagent_containers/food/drinks/bottle/premiumwine = 1,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/premiumvodka = 1)
	cost = 60
	containertype = /obj/structure/closet/crate/freezer
	containername = "premium drinks crate"

/decl/hierarchy/supply_pack/galley/barsupplies
	name = "Bar - Bar supplies"
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
	containername = "bar supplies crate"

/decl/hierarchy/supply_pack/galley/beer_dispenser
	name = "Equipment - Booze dispenser"
	contains = list(
			/obj/machinery/chemical_dispenser/bar_alc{anchored = 0}
		)
	cost = 25
	containertype = /obj/structure/largecrate
	containername = "booze dispenser crate"

/decl/hierarchy/supply_pack/galley/soda_dispenser
	name = "Equipment - Soda dispenser"
	contains = list(
			/obj/machinery/chemical_dispenser/bar_soft{anchored = 0}
		)
	cost = 25
	containertype = /obj/structure/largecrate
	containername = "soda dispenser crate"
