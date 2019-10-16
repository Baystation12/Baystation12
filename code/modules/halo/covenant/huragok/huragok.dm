//////////////////////////////////////////////////////////////////////////////////////////
//Dependencies located in robot.dm and robot_modules.dm, they are vital for this to work//
//////////////////////////////////////////////////////////////////////////////////////////

/mob/living/silicon/robot/huragok
	name = "Huragok"
	real_name = "Huragok"
	icon = 'code/modules/halo/covenant/engineer.dmi'
	icon_state = "engineer"
	maxHealth = 75
	health = 75

	modules_available = list("Huragok Engineer", "Huragok Lifeworker")

	universal_understand = 1
	scrambledcodes = 1
	req_access = list(-1)

	cell = /obj/item/weapon/cell/infinite
	radio = /obj/item/device/radio/headset/covenant
	common_radio = /obj/item/device/radio/headset/covenant

/mob/living/silicon/robot/huragok/updatename(var/prefix as text)
	name = "[modtype] [num2text(ident)]"
	real_name = name