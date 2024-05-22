/obj/machinery/vending/sovietsoda
	name = "\improper BODA"
	desc = "An old soda vending machine. How could this have got here?"
	icon_state = "sovietsoda"
	icon_vend = "sovietsoda-vend"
	icon_deny = "sovietsoda-deny"
	base_type = /obj/machinery/vending/sovietsoda
	idle_power_usage = 200
	product_ads = {"\
		For Tsar and Country.;\
		Have you fulfilled your nutrition quota today?;\
		Very nice!;\
		We are simple people, for this is all we eat.;\
		If there is a person, there is a problem. If there is no person, then there is no problem.\
	"}
	product_slogans = {"\
		I would drink it again perhaps.;\
		Enough REAL sugar to taste!;\
		BODA: It is acceptable;\
		You're strong. Drink Boda.\
	"}
	antag_slogans = {"\
		It may not be the best, but our wares are actually GOOD for the consumer. Suck it, capitalists.;\
		There is only our, there is no mine. Unless you're sent to gulag.;\
		Guaranteed to help you tear 'em a new Gaia.;\
		100% less additives and preservatives than our SCG competitors.\
	"}
	products = list(
		/obj/item/reagent_containers/food/drinks/cans/syndicola = 0,
		/obj/item/reagent_containers/food/drinks/cans/syndicolax = 0,
		/obj/item/reagent_containers/food/drinks/cans/artbru = 0,
		/obj/item/reagent_containers/food/drinks/glass2/square/boda = 0,
		/obj/item/reagent_containers/food/drinks/glass2/square/bodaplus = 0,
		/obj/item/reagent_containers/food/drinks/bottle/small/space_up = 0
	)
	contraband = list(
		/obj/item/clothing/under/soviet = 1,
		/obj/item/clothing/suit/hgpirate = 1

	)
	rare_products = list(
		/obj/item/reagent_containers/food/drinks/bottle/small/space_up = 50,
		/obj/item/card/id/syndicate = 25,
		/obj/item/storage/box/syndie_kit/spy = 50
	)
	antag = list(
		/obj/item/gun/projectile/heavysniper/boltaction = 1,
		/obj/item/ammo_magazine/rifle  = 1,
		/obj/item/card/id/syndicate = 0,
		/obj/item/storage/box/syndie_kit/spy = 0
	)
