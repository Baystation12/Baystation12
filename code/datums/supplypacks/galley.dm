/decl/hierarchy/supply_pack/galley
	name = "Galley"

/decl/hierarchy/supply_pack/galley/food
	name = "General - Kitchen supply crate"
	contains = list(/obj/item/weapon/reagent_containers/food/condiment/flour = 6,
					/obj/item/weapon/reagent_containers/food/drinks/milk = 4,
					/obj/item/weapon/reagent_containers/food/drinks/soymilk = 2,
					/obj/item/weapon/storage/fancy/egg_box = 2,
					/obj/item/weapon/reagent_containers/food/snacks/tofu = 4,
					/obj/item/weapon/reagent_containers/food/snacks/meat = 4
					)
	cost = 10
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Food crate"

/decl/hierarchy/supply_pack/galley/beef
	name = "Perishables - Beef crate"
	contains = list(/obj/item/weapon/reagent_containers/food/snacks/meat/beef = 6)
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Beef crate"
	cost = 20

/decl/hierarchy/supply_pack/galley/goat
	name = "Perishables - Goat meat crate"
	contains = list(/obj/item/weapon/reagent_containers/food/snacks/meat/goat = 6)
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Goat meat crate"
	cost = 20

/decl/hierarchy/supply_pack/galley/chicken
	name = "Perishables - Chicken meat crate"
	contains = list(/obj/item/weapon/reagent_containers/food/snacks/meat/chicken = 6)
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Chicken meat crate"
	cost = 20

/decl/hierarchy/supply_pack/galley/seafood
	name = "Perishables - Seafood crate"
	contains = list(
		/obj/item/weapon/reagent_containers/food/snacks/fish = 2,
		/obj/item/weapon/reagent_containers/food/snacks/fish/shark = 2,
		/obj/item/weapon/reagent_containers/food/snacks/fish/octopus = 2
		)
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Seafood crate"
	cost = 20

/decl/hierarchy/supply_pack/galley/eggs
	name = "Perishables - Eggs crate"
	contains = list(/obj/item/weapon/storage/fancy/egg_box = 2)
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Egg crate"
	cost = 15

/decl/hierarchy/supply_pack/galley/milk
	name = "Perishables - Milk crate"
	contains = list(/obj/item/weapon/reagent_containers/food/drinks/milk = 3)
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Milk crate"
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
	containername = "\improper Pizza crate"
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
	containername = "\improper Party equipment"

// TODO; Add more premium drinks at a later date. Could be useful for diplomatic events or fancy parties.
/decl/hierarchy/supply_pack/galley/premiumalcohol
	name = "Bar - Premium drinks crate"
	contains = list(/obj/item/weapon/reagent_containers/food/drinks/bottle/premiumwine = 1,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/premiumvodka = 1)
	cost = 60
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Premium drinks"

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
	containername = "crate of bar supplies"

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

/decl/hierarchy/supply_pack/galley/alcohol_reagents
	name = "Refills - Bar alcoholic dispenser refill"
	contains = list(
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/beer,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/kahlua,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/whiskey,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/wine,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/vodka,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/gin,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/rum,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/tequila,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/vermouth,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/cognac,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/ale,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/mead
		)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "alcoholic drinks crate"
	access = list(access_bar)

/decl/hierarchy/supply_pack/galley/softdrink_reagents
	name = "Refills - soft drink dispenser refill"
	contains = list(
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/water,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/ice,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/coffee,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/cream,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/tea,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/icetea,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/cola,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/smw,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/dr_gibb,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/spaceup,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/tonic,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/sodawater,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/lemon_lime,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/sugar,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/orange,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/lime,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/watermelon
		)
	cost = 50
	containertype = /obj/structure/closet/crate
	containername = "soft drinks crate"

/decl/hierarchy/supply_pack/galley/coffee_reagents
	name = "Refills - Coffee machine dispenser refill"
	contains = list(
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/coffee,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/cafe_latte,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/soy_latte,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/hot_coco,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/milk,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/cream,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/tea,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/ice
		)
	cost = 50
	containertype = /obj/structure/closet/crate
	containername = "coffee drinks crate"