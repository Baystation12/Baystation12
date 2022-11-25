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
	contraband = list(
		/obj/item/inflatable_duck = 1
	)
