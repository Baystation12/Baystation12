/obj/item/weapon/robot_module/uncertified
	name = "uncertified robot module"
	sprites = list(
		"Roller" = "omoikane"
	)
	upgrade_locked = TRUE
	skills = list(
		SKILL_FINANCE = SKILL_PROF
	) // For the money launcher, of course

/obj/item/weapon/robot_module/uncertified/party
	name = "Madhouse Productions Official Party Module"
	display_name = "Party"
	channels = list(
		"Service" = TRUE,
		"Entertainment" = TRUE
	)
	networks = list(
		NETWORK_THUNDER
	)
	equipment = list(
		/obj/item/device/boombox,
		/obj/item/weapon/bikehorn/airhorn,
		/obj/item/weapon/party_light,
		/obj/item/weapon/gun/launcher/money
	)

/obj/item/weapon/robot_module/uncertified/party/finalize_equipment()
	. = ..()
	var/obj/item/weapon/gun/launcher/money/MC = new (src)
	MC.receptacle_value = 5000
	MC.dispensing = 100
