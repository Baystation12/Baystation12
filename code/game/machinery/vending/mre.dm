/obj/machinery/vending/mredispenser
	name = "mre-dispenser"
	desc = "A Vending machine filled with MRE's."
	icon_state = "mrevend"
	icon_deny = "mrevend-deny"
	icon_vend = "mrevend-vend"
	base_type = /obj/machinery/vending/mredispenser
	idle_power_usage = 200
	product_slogans = {"\
		STARFIGHTER TESTED! STARFIGHTER RECOMMENDED! STARFIGHTER APPROVED!;\
		YOU ARE NOT ALLOWED A JELLY DOUGHNUT!;\
		YOU DON'T WANT TO DIE HUNGRY, SOLDIER!\
	"}
	product_ads = {"\
		Everything the body needs!;\
		Now transfat free!;\
		Vegan options are available.;\
		Rated for all known species*!\
	"}
	products = list(
		/obj/item/storage/mre = 2,
		/obj/item/storage/mre/menu2 = 2,
		/obj/item/storage/mre/menu3 = 2,
		/obj/item/storage/mre/menu4 = 2,
		/obj/item/storage/mre/menu5 = 2,
		/obj/item/storage/mre/menu6 = 2,
		/obj/item/storage/mre/menu7 = 2,
		/obj/item/storage/mre/menu8 = 2,
		/obj/item/storage/mre/menu9 = 10,
		/obj/item/storage/mre/menu10 = 10
	)
	contraband = list(
		/obj/item/storage/mre/menu11 = 5,
		/obj/item/reagent_containers/food/snacks/liquidfood = 5
	)
