/obj/machinery/vending/tool
	name = "\improper YouTool"
	desc = "Tools for tools."
	icon_state = "tool"
	icon_deny = "tool-deny"
	icon_vend = "tool-vend"
	base_type = /obj/machinery/vending/tool
	antag_slogans = {"\

	"}
	products = list(
		/obj/item/stack/cable_coil = 10,
		/obj/item/crowbar = 5,
		/obj/item/weldingtool = 3,
		/obj/item/wirecutters = 5,
		/obj/item/wrench = 5,
		/obj/item/device/scanner/gas = 5,
		/obj/item/device/t_scanner = 5,
		/obj/item/screwdriver = 5,
		/obj/item/device/flashlight/flare/glowstick = 3,
		/obj/item/device/flashlight/flare/glowstick/red = 3,
		/obj/item/tape_roll = 8
	)
	rare_products = list(
		/obj/item/device/augment_implanter/engineering_toolset  = 50
	)
	contraband = list(
		/obj/item/weldingtool/hugetank = 2,
		/obj/item/clothing/gloves/insulated = 1
	)
	premium = list(
		/obj/item/clothing/gloves/insulated/cheap = 2
	)
	antag = list(
		/obj/item/storage/toolbox/syndicate = 1,
		/obj/item/device/augment_implanter/engineering_toolset  = 0
	)
