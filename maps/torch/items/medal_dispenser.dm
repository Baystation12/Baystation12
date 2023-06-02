/obj/machinery/vending/medals
	name = "\improper Medal Dispenser"
	desc = "A machine that stores and issues medals."
	icon_state = "medalvend"
	base_type = /obj/machinery/vending/medals
	req_access = list(access_captain)
	products = list(
	/obj/item/clothing/accessory/medal/solgov/mil/bronze_heart = null,
	/obj/item/clothing/accessory/medal/solgov/mil/iron_star = null,
	/obj/item/clothing/accessory/medal/solgov/mil/medical = null,
	/obj/item/clothing/accessory/medal/solgov/mil/armed_forces = null,
	/obj/item/clothing/accessory/medal/solgov/mil/silver_sword = null,
	/obj/item/clothing/accessory/medal/solgov/mil/service_cross = null
	)

	rare_products = list(
	/obj/item/clothing/accessory/medal/solgov/mil/armed_forces = 50,
	/obj/item/clothing/accessory/medal/solgov/mil/silver_sword = 30,
	/obj/item/clothing/accessory/medal/solgov/mil/service_cross = 10
	)

	contraband = list(
		/obj/item/clothing/accessory/medal/solgov/mil/medal_of_honor = 1
	)
