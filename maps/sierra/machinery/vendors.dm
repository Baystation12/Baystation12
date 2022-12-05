/obj/machinery/vending/robotics/sierra
	products = list(
		/obj/item/cell/standard = 4,
		/obj/item/device/flash/synthetic = 4,
		/obj/item/device/robotanalyzer = 2,
		/obj/item/device/scanner/health = 2,
		/obj/item/reagent_containers/food/drinks/bottle/oiljug = 5,
		/obj/item/stack/cable_coil = 4,
	)

/obj/machinery/vending/medical/sierra
	req_access = list(access_medical)

/obj/machinery/vending/security
	products = list(/obj/item/handcuffs = 8,/obj/item/grenade/flashbang = 8,/obj/item/grenade/chem_grenade/teargas = 4,/obj/item/device/flash = 5,
					/obj/item/bodybag = 4,/obj/item/storage/box/evidence = 6, /obj/item/clothing/accessory/badge/holo/NT = 4, /obj/item/clothing/accessory/badge/holo/NT/cord = 4)
//	contraband = list(/obj/item/clothing/glasses/sunglasses = 2,/obj/item/storage/box/donut = 2)
