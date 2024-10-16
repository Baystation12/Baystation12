/obj/machinery/vending/games
	name = "\improper Good Clean Fun"
	desc = "Vends things that the CO and SEA are probably not going to appreciate you fiddling with instead of your job..."
	icon_state = "games"
	icon_deny = "games-deny"
	icon_vend = "games-vend"
	base_type = /obj/machinery/vending/games
	maxrandom = 5
	product_slogans = {"
		Escape to a fantasy world!;\
		Fuel your gambling addiction!;\
		Ruin your friendships!\
	"}
	product_ads = {"\
		Elves and dwarves!;\
		Totally not satanic!;\
		Fun times forever!\
	"}
	antag_slogans = {"\
		We put the laughter in slaughter!;\
		Is it a surprise that the ship staffed by overgrown toddlers needs a game vending machine?;\
		Affordable toys, because you can't afford real fun!;\
		Barros thinks politics is a game, so why don’t you start playing?\
	"}
	prices = list(
		/obj/item/toy/blink = 3,
		/obj/item/toy/eightball = 10,
		/obj/item/deck/tarot = 3,
		/obj/item/deck/cards = 3,
		/obj/item/pack/cardemon = 5,
		/obj/item/pack/spaceball = 5,
		/obj/item/storage/pill_bottle/dice_nerd = 6,
		/obj/item/storage/pill_bottle/dice = 6,
		/obj/item/storage/box/checkers = 10,
		/obj/item/storage/box/checkers/chess/red = 10,
		/obj/item/storage/box/checkers/chess = 10,
		/obj/item/stack/package_wrap/gift_wrap = 10,
		/obj/item/board = 2,
		/obj/item/storage/fancy/crayons = 3,
		/obj/item/reagent_containers/spray/waterflower = 10,
		/obj/item/storage/box/snappops = 15
	)
	products = list(
		/obj/item/toy/blink = 0,
		/obj/item/toy/eightball = 0,
		/obj/item/deck/cards = 0,
		/obj/item/deck/tarot = 0,
		/obj/item/pack/cardemon = 0,
		/obj/item/pack/spaceball = 0,
		/obj/item/storage/pill_bottle/dice_nerd = 0,
		/obj/item/storage/pill_bottle/dice = 0,
		/obj/item/storage/box/checkers = 0,
		/obj/item/storage/box/checkers/chess/red = 0,
		/obj/item/storage/box/checkers/chess = 0,
		/obj/item/stack/package_wrap/gift_wrap = 0,
		/obj/item/board = 0,
		/obj/item/storage/fancy/crayons = 0,
		/obj/item/reagent_containers/spray/waterflower = 0,
		/obj/item/storage/box/snappops = 0
	)
	rare_products = list(
		/obj/item/reagent_containers/spray/waterflower = 30,
		/obj/item/storage/box/snappops = 30,
		/obj/item/storage/box/large/foam_gun/revolving/tampered = 20,
		/obj/item/toy/balloon = 5
	)
	contraband = list(
		/obj/item/toy/crossbow = 1,
		/obj/item/toy/ammo/crossbow = 4,
		/obj/item/toy/sword = 3,
		/obj/item/toy/katana = 3,
		/obj/item/gun/projectile/revolving/capgun = 1,
		/obj/item/ammo_magazine/caps = 4
	)
	premium = list(
		/obj/item/spirit_board = 1
	)
	antag = list(
		/obj/item/clothing/head/bowlerhat/razor = 1,
		/obj/item/storage/box/large/foam_gun/revolving/tampered = 0,
		/obj/item/toy/balloon = 0
	)
