/obj/machinery/vending/lavatory
	name = "\improper Lavatory Essentials"
	desc = "Vends things that make you less reviled in the work-place!"
	icon_state = "lavatory"
	icon_deny = "lavatory-deny"
	icon_vend = "lavatory-vend"
	base_type = /obj/machinery/vending/lavatory
	product_slogans = {"\
		Take a shower you hippie.;\
		Get a haircut, hippie!;\
		Reeking of vox taint? Take a shower!\
	"}
	antag_slogans = {"\
		You reek of capitalist pig! Freshen up with some communism!;\
		Hey, you dropped something!;\
		Cleansing the world, one Solarian skull at a time!\
	"}
	prices = list(
		/obj/item/soap = 20,
		/obj/item/mirror = 40,
		/obj/item/haircomb/random = 40,
		/obj/item/haircomb/brush = 80,
		/obj/item/towel/random = 50,
		/obj/item/reagent_containers/spray/cleaner/deodorant = 30
	)
	products = list(
		/obj/item/soap = 12,
		/obj/item/mirror = 8,
		/obj/item/haircomb/random = 8,
		/obj/item/haircomb/brush = 4,
		/obj/item/towel/random = 6,
		/obj/item/reagent_containers/spray/cleaner/deodorant = 5
	)
	rare_products = list(
		/obj/item/grenade/chem_grenade/metalfoam = 80,
		/obj/item/gun/projectile/shotgun/cane  = 40
	)
	contraband = list(
		/obj/item/inflatable_duck = 1
	)
	antag = list(
		/obj/item/cane/concealed = 1,
		/obj/item/grenade/chem_grenade/metalfoam = 0,
		/obj/item/gun/projectile/shotgun/cane = 0
	)
