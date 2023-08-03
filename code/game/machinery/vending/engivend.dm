/obj/machinery/vending/engivend
	name = "\improper Engi-Vend"
	desc = "Spare tool vending. What? Did you expect some witty description?"
	icon_state = "engivend"
	icon_deny = "engivend-deny"
	icon_vend = "engivend-vend"
	base_type = /obj/machinery/vending/engivend
	req_access = list(list(access_atmospherics,access_engine_equip))
	antag_slogans = {"\
		Equipment only 75% guaranteed to not blow up in your face!;\
		This vendor proudly supplied the electronics for 9 out of 10 ships involved in crashes!;\
		With electronics like this, is it a surprise the mortality rate in this dump is so high?\
	"}
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
	rare_products = list(
		/obj/item/device/uplink_service/fake_crew_announcement = 40,
		/obj/item/device/uplink_service/fake_rad_storm = 20
	)
	contraband = list(
		/obj/item/cell/high = 3
	)
	premium = list(
		/obj/item/storage/belt/utility = 3
	)
	antag = list(
		/obj/item/device/uplink_service/fake_ion_storm = 1,
		/obj/item/device/uplink_service/fake_crew_announcement = 0,
		/obj/item/device/uplink_service/fake_rad_storm = 0
	)
