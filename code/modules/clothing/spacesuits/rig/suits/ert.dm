/obj/item/weapon/storage/rig/ert
	name = "ERT-C hardsuit control module"
	desc = "A suit worn by the commander of a NanoTrasen Emergency Response Team. Has blue highlights. Armoured and space ready."
	suit_type = "ERT commander"
	icon_state = "ert_commander_rig"
	siemens_coefficient = 0.6
	offline_slowdown = 3

	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 100, rad = 100)
	allowed = list(/obj/item/device/flashlight, /obj/item/weapon/tank, /obj/item/device/t_scanner, /obj/item/weapon/rcd, /obj/item/weapon/crowbar, \
	/obj/item/weapon/screwdriver, /obj/item/weapon/weldingtool, /obj/item/weapon/wirecutters, /obj/item/weapon/wrench, /obj/item/device/multitool, \
	/obj/item/device/radio, /obj/item/device/analyzer, /obj/item/weapon/gun/energy/laser, /obj/item/weapon/gun/energy/pulse_rifle, \
	/obj/item/weapon/gun/energy/taser, /obj/item/weapon/melee/baton, /obj/item/weapon/gun/energy/gun)

	initial_modules = list()

/obj/item/weapon/storage/rig/ert/engineer
	name = "ERT-E suit control module"
	desc = "A suit worn by the commander of a NanoTrasen Emergency Response Team. Has orange highlights. Armoured and space ready."
	suit_type = "ERT engineer"
	icon_state = "ert_engineer_rig"

/obj/item/weapon/storage/rig/ert/medical
	name = "ERT-M suit control module"
	desc = "A suit worn by the commander of a NanoTrasen Emergency Response Team. Has white highlights. Armoured and space ready."
	suit_type = "ERT medic"
	icon_state = "ert_medical_rig"

/obj/item/weapon/storage/rig/ert/security
	name = "ERT-S suit control module"
	desc = "A suit worn by the commander of a NanoTrasen Emergency Response Team. Has red highlights. Armoured and space ready."
	suit_type = "ERT security"
	icon_state = "ert_security_rig"
