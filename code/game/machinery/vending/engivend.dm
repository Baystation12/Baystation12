/obj/machinery/vending/engivend
	name = "\improper Engi-Vend"
	desc = "Spare tool vending. What? Did you expect some witty description?"
	icon_state = "engivend"
	icon_deny = "engivend-deny"
	icon_vend = "engivend-vend"
	base_type = /obj/machinery/vending/engivend
	req_access = list(list(access_atmospherics,access_engine_equip))
	products = list(
		/obj/item/clothing/glasses/meson = 2,
		/obj/item/device/multitool = 4,
		/obj/item/device/geiger = 4,
		/obj/item/airlock_electronics = 10,
		/obj/item/intercom_electronics = 10,
		/obj/item/module/power_control = 10,
		/obj/item/airalarm_electronics = 10,
		/obj/item/cell/standard = 10,
		/obj/item/clamp = 10
	)
	contraband = list(
		/obj/item/cell/high = 3
	)
	premium = list(
		/obj/item/storage/belt/utility = 3
	)
