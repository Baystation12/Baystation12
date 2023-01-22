/decl/hierarchy/supply_pack/galley
	name = "Galley"

/decl/hierarchy/supply_pack/galley/food
	name = "General - Kitchen supplies"
	contains = list(/obj/item/reagent_containers/food/condiment/flour = 6,
					/obj/item/reagent_containers/food/drinks/milk = 4,
					/obj/item/reagent_containers/food/drinks/soymilk = 2,
					/obj/item/storage/fancy/egg_box = 2,
					/obj/item/reagent_containers/food/snacks/tofu = 4,
					/obj/item/reagent_containers/food/snacks/meat = 4,
					/obj/item/reagent_containers/food/condiment/enzyme = 1,
					/obj/item/reagent_containers/glass/bottle/dye/polychromic = 1
					)
	cost = 10
	containertype = /obj/structure/closet/crate/freezer
	containername = "kitchen supplies crate"


/decl/hierarchy/supply_pack/galley/donkpocket
	name = "General - Donk-Pocket Turnovers"
	contains = list(
		/obj/item/storage/box/donkpocket_protein = 2,
		/obj/item/storage/box/donkpocket_vegetable = 2,
		/obj/item/storage/box/donkpocket_fruit = 1,
		/obj/item/storage/box/donkpocket_dessert = 1
	)
	cost = 10
	containertype = /obj/item/storage/backpack/dufflebag
	containername = "donk-pocket dufflebag"


/decl/hierarchy/supply_pack/galley/donkpocket_premium
	name = "General - Premium Donk-Pocket Turnovers"
	contains = list(
		/obj/item/storage/box/donkpocket_premium = 3
	)
	cost = 20
	hidden = TRUE
	containertype = /obj/item/storage/backpack/dufflebag
	containername = "donk-pocket dufflebag"


/decl/hierarchy/supply_pack/galley/beef
	name = "Perishables - Beef"
	contains = list(/obj/item/reagent_containers/food/snacks/meat/beef = 6)
	containertype = /obj/structure/closet/crate/freezer
	containername = "cow meat crate"
	cost = 20

/decl/hierarchy/supply_pack/galley/goat
	name = "Perishables - Goat meat"
	contains = list(/obj/item/reagent_containers/food/snacks/meat/goat = 6)
	containertype = /obj/structure/closet/crate/freezer
	containername = "goat meat crate"
	cost = 20

/decl/hierarchy/supply_pack/galley/chicken
	name = "Perishables - Poultry"
	contains = list(/obj/item/reagent_containers/food/snacks/meat/chicken = 6)
	containertype = /obj/structure/closet/crate/freezer
	containername = "chicken meat crate"
	cost = 20

/decl/hierarchy/supply_pack/galley/seafood
	name = "Perishables - Seafood"
	contains = list(
		/obj/random/fish = 8
	)
	containertype = /obj/structure/closet/crate/freezer
	containername = "seafood crate"
	cost = 20

/decl/hierarchy/supply_pack/galley/eggs
	name = "Perishables - Eggs"
	contains = list(/obj/item/storage/fancy/egg_box = 2)
	containertype = /obj/structure/closet/crate/freezer
	containername = "egg crate"
	cost = 15

/decl/hierarchy/supply_pack/galley/milk
	name = "Perishables - Milk"
	contains = list(/obj/item/reagent_containers/food/drinks/milk = 3)
	containertype = /obj/structure/closet/crate/freezer
	containername = "milk crate"
	cost = 15

/decl/hierarchy/supply_pack/galley/pizza
	name = "Emergency - Surprise pack of five pizzas"
	contains = list(
		/obj/item/pizzabox/margherita,
		/obj/item/pizzabox/mushroom,
		/obj/item/pizzabox/meat,
		/obj/item/pizzabox/vegetable,
		/obj/item/pizzabox/fruit
	)
	cost = 20
	containertype = /obj/structure/closet/crate/freezer
	containername = "pizza crate"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/galley/rations
	num_contained = 6
	name = "Emergency - MREs"
	contains = list(/obj/item/storage/mre,
					/obj/item/storage/mre/menu2,
					/obj/item/storage/mre/menu3,
					/obj/item/storage/mre/menu4,
					/obj/item/storage/mre/menu5,
					/obj/item/storage/mre/menu6,
					/obj/item/storage/mre/menu7,
					/obj/item/storage/mre/menu8,
					/obj/item/storage/mre/menu9,
					/obj/item/storage/mre/menu10)
	cost = 35
	containertype = /obj/structure/closet/crate/freezer
	containername = "emergency rations"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/galley/party
	name = "Bar - Party equipment"
	contains = list(
			/obj/item/storage/box/mixedglasses = 2,
			/obj/item/storage/box/glasses/square,
			/obj/item/reagent_containers/food/drinks/shaker,
			/obj/item/reagent_containers/food/drinks/flask/barflask,
			/obj/item/reagent_containers/food/drinks/bottle/patron,
			/obj/item/reagent_containers/food/drinks/bottle/goldschlager,
			/obj/item/reagent_containers/food/drinks/bottle/specialwhiskey,
			/obj/item/storage/fancy/cigarettes/dromedaryco,
			/obj/item/lipstick/random,
			/obj/item/reagent_containers/food/drinks/bottle/small/ale = 2,
			/obj/item/reagent_containers/food/drinks/bottle/small/beer = 4,
			/obj/item/storage/box/glowsticks = 2,
			/obj/item/clothingbag/rubbermask,
			/obj/item/clothingbag/rubbersuit)
	cost = 20
	containername = "party equipment crate"

// TODO; Add more premium drinks at a later date. Could be useful for diplomatic events or fancy parties.
/decl/hierarchy/supply_pack/galley/premiumalcohol
	name = "Bar - Premium drinks"
	contains = list(/obj/item/reagent_containers/food/drinks/bottle/premiumwine = 1,
					/obj/item/reagent_containers/food/drinks/bottle/premiumvodka = 1)
	cost = 55
	containertype = /obj/structure/closet/crate/freezer
	containername = "premium drinks crate"

/decl/hierarchy/supply_pack/galley/barsupplies
	name = "Bar - Bar supplies"
	contains = list(
			/obj/item/storage/box/glasses/cocktail,
			/obj/item/storage/box/glasses/rocks,
			/obj/item/storage/box/glasses/square,
			/obj/item/storage/box/glasses/pint,
			/obj/item/storage/box/glasses/wine,
			/obj/item/storage/box/glasses/shake,
			/obj/item/storage/box/glasses/shot,
			/obj/item/storage/box/glasses/mug,
			/obj/item/reagent_containers/food/drinks/shaker,
			/obj/item/storage/box/glass_extras/straws,
			/obj/item/storage/box/glass_extras/sticks
			)
	cost = 10
	containername = "bar supplies crate"


/decl/hierarchy/supply_pack/galley/beer_dispenser
	name = "Equipment - Booze dispenser"
	contains = list(
			/obj/machinery/chemical_dispenser/bar_alc{anchored = FALSE}
		)
	cost = 25
	containertype = /obj/structure/largecrate
	containername = "booze dispenser crate"

/decl/hierarchy/supply_pack/galley/soda_dispenser
	name = "Equipment - Soda dispenser"
	contains = list(
			/obj/machinery/chemical_dispenser/bar_soft{anchored = FALSE}
		)
	cost = 25
	containertype = /obj/structure/largecrate
	containername = "soda dispenser crate"

/decl/hierarchy/supply_pack/galley/mre_dispenser
	name = "Equipment - MRE dispenser"
	contains = list(
			/obj/machinery/vending/mredispenser{anchored = FALSE}
		)
	cost = 50
	containertype = /obj/structure/largecrate
	containername = "MRE dispenser crate"


/decl/hierarchy/supply_pack/galley/silverware
	name = "Equipment - Silver Cutlery"
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "silver cutlery crate"
	access = access_kitchen
	contains = list(
		/obj/item/storage/box/silverware
	)
