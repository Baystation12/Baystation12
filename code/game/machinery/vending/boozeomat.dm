/obj/machinery/vending/boozeomat
	name = "\improper Booze-O-Mat"
	desc = "A refrigerated vending unit for alcoholic beverages and alcoholic beverage accessories."
	icon_state = "fridge_dark"
	icon_deny = "fridge_dark-deny"
	base_type = /obj/machinery/vending/boozeomat
	req_access = list(access_kitchen)
	idle_power_usage = 200
	product_slogans = {"\
		I hope nobody asks me for a bloody cup o' tea...;\
		Alcohol is humanity's friend. Would you abandon a friend?;\
		Quite delighted to serve you!;\
		Is nobody thirsty on this station?\
	"}
	product_ads = {"
		Drink up!;\
		Booze is good for you!;\
		Alcohol is humanity's best friend.;\
		Quite delighted to serve you!;\
		Care for a nice, cold beer?;\
		Nothing cures you like booze!;\
		Have a sip!;\
		Have a drink!;\
		Have a beer!;\
		Beer is good for you!;\
		Only the finest alcohol!;\
		Best quality booze since 2053!;\
		Award-winning wine!;\
		Maximum alcohol!;\
		Man loves beer.;\
		A toast for progress!\
	"}
	antag_slogans = {"\
		Drink away the pain of living under SolGov!;\
		Vodka is the only acceptable drink!;\
		Is this the best you can serve, bartender? This swill?!;\
		These drinks are as tasteless as Sol's people!;\
		Who are you kidding? You knew you were about to drink piss the second you stepped in here.;\
		Drinking on the job is socially acceptable for executives, why not for you?\
	"}
	products = list(
		/obj/item/reagent_containers/food/drinks/glass2/square = 10,
		/obj/item/reagent_containers/food/drinks/flask/barflask = 5,
		/obj/item/reagent_containers/food/drinks/flask/vacuumflask = 5,
		/obj/item/reagent_containers/food/drinks/bottle/absinthe = 5,
		/obj/item/reagent_containers/food/drinks/bottle/baijiu = 5,
		/obj/item/reagent_containers/food/drinks/bottle/blackstrap = 5,
		/obj/item/reagent_containers/food/drinks/bottle/bluecuracao = 5,
		/obj/item/reagent_containers/food/drinks/bottle/cachaca = 5,
		/obj/item/reagent_containers/food/drinks/bottle/champagne = 5,
		/obj/item/reagent_containers/food/drinks/bottle/cognac = 5,
		/obj/item/reagent_containers/food/drinks/bottle/gin = 5,
		/obj/item/reagent_containers/food/drinks/bottle/herbal = 5,
		/obj/item/reagent_containers/food/drinks/bottle/jagermeister = 5,
		/obj/item/reagent_containers/food/drinks/bottle/kahlua = 5,
		/obj/item/reagent_containers/food/drinks/bottle/melonliquor = 5,
		/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing =5,
		/obj/item/reagent_containers/food/drinks/bottle/prosecco = 5,
		/obj/item/reagent_containers/food/drinks/bottle/rakia = 5,
		/obj/item/reagent_containers/food/drinks/bottle/rum = 5,
		/obj/item/reagent_containers/food/drinks/bottle/sake = 5,
		/obj/item/reagent_containers/food/drinks/bottle/soju = 5,
		/obj/item/reagent_containers/food/drinks/bottle/tequilla = 5,
		/obj/item/reagent_containers/food/drinks/bottle/vodka = 5,
		/obj/item/reagent_containers/food/drinks/bottle/vermouth = 5,
		/obj/item/reagent_containers/food/drinks/bottle/whiskey = 5,
		/obj/item/reagent_containers/food/drinks/bottle/llanbrydewhiskey = 5,
		/obj/item/reagent_containers/food/drinks/bottle/specialwhiskey = 5,
		/obj/item/reagent_containers/food/drinks/bottle/wine = 5,
		/obj/item/reagent_containers/food/drinks/bottle/small/beer = 15,
		/obj/item/reagent_containers/food/drinks/bottle/small/alcoholfreebeer = 15,
		/obj/item/reagent_containers/food/drinks/bottle/small/ale = 15,
		/obj/item/reagent_containers/food/drinks/bottle/small/hellshenpa = 15,
		/obj/item/reagent_containers/food/drinks/bottle/small/lager = 15,
		/obj/item/reagent_containers/food/drinks/bottle/small/gingerbeer = 15,
		/obj/item/reagent_containers/food/drinks/bottle/small/dandelionburdock = 15,
		/obj/item/reagent_containers/food/drinks/cans/rootbeer = 15,
		/obj/item/reagent_containers/food/drinks/cans/speer = 10,
		/obj/item/reagent_containers/food/drinks/cans/ale = 10,
		/obj/item/reagent_containers/food/drinks/bottle/small/cola = 10,
		/obj/item/reagent_containers/food/drinks/bottle/small/space_up = 10,
		/obj/item/reagent_containers/food/drinks/bottle/small/space_mountain_wind = 10,
		/obj/item/reagent_containers/food/drinks/cans/cola_diet = 5,
		/obj/item/reagent_containers/food/drinks/cans/ionbru = 5,
		/obj/item/reagent_containers/food/drinks/cans/beastenergy = 5,
		/obj/item/reagent_containers/food/drinks/tea/black = 15,
		/obj/item/reagent_containers/food/drinks/bottle/orangejuice = 2,
		/obj/item/reagent_containers/food/drinks/bottle/tomatojuice = 2,
		/obj/item/reagent_containers/food/drinks/bottle/limejuice = 2,
		/obj/item/reagent_containers/food/drinks/bottle/lemonjuice = 2,
		/obj/item/reagent_containers/food/drinks/bottle/unathijuice = 2,
		/obj/item/reagent_containers/food/drinks/bottle/maplesyrup = 2,
		/obj/item/reagent_containers/food/drinks/cans/tonic = 15,
		/obj/item/reagent_containers/food/drinks/bottle/cream = 5,
		/obj/item/reagent_containers/food/drinks/cans/sodawater = 15,
		/obj/item/reagent_containers/food/drinks/bottle/grenadine = 5,
		/obj/item/reagent_containers/food/drinks/bottle/thoom = 2,
		/obj/item/reagent_containers/food/condiment/mint = 2,
		/obj/item/reagent_containers/food/drinks/ice = 10,
		/obj/item/glass_extra/stick = 15,
		/obj/item/glass_extra/straw = 15
	)
	contraband = list(
		/obj/item/reagent_containers/food/drinks/bottle/premiumwine = 5,
		/obj/item/reagent_containers/food/drinks/bottle/premiumvodka = 5,
		/obj/item/reagent_containers/food/drinks/bottle/patron = 5,
		/obj/item/reagent_containers/food/drinks/bottle/goldschlager = 5,
		/obj/item/reagent_containers/food/drinks/bottle/tadmorwine = 5,
		/obj/item/reagent_containers/food/drinks/bottle/brandy = 5
	)
	rare_products = list(
		/obj/item/reagent_containers/glass/bottle/dye/polychromic/strong = 50,
		/obj/item/storage/pill_bottle/tramadol = 50
	)
	antag = list(
		/obj/item/storage/secure/briefcase/money = 1,
		/obj/item/reagent_containers/glass/bottle/dye/polychromic/strong = 0,
		/obj/item/storage/pill_bottle/tramadol = 0
	)
