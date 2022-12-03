/obj/machinery/vending/robotics
	name = "\improper Robotech Deluxe"
	desc = "All the tools you need to create your own robot army."
	icon_state = "robotics"
	icon_deny = "robotics-deny"
	icon_vend = "robotics-vend"
	base_type = /obj/machinery/vending/robotics
	req_access = list(access_robotics)
	products = list(
		/obj/item/reagent_containers/food/drinks/bottle/oiljug = 5,
		/obj/item/stack/cable_coil = 4,
		/obj/item/device/flash/synthetic = 4,
		/obj/item/cell/standard = 4,
		/obj/item/device/scanner/health = 2,
		/obj/item/scalpel = 1,
		/obj/item/circular_saw = 1,
		/obj/item/tank/anesthetic = 2,
		/obj/item/clothing/mask/breath/medical = 5,
		/obj/item/screwdriver = 2,
		/obj/item/crowbar = 2
	)
	contraband = list(
		/obj/item/device/flash = 2
	)
