//Regular rig suits
/obj/item/clothing/head/helmet/space/rig
	name = "engineering hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Has radiation shielding."
	icon_state = "rig0-engineering"
	item_state = "eng_helm"
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 60)
	allowed = list(/obj/item/device/flashlight)
	var/brightness_on = 4 //luminosity when on
	var/on = 0
	color = "engineering" //Determines used sprites: rig[on]-[color] and rig[on]-[color]2 (lying down sprite)
	icon_action_button = "action_hardhat"

	attack_self(mob/user)
		if(!isturf(user.loc))
			user << "You cannot turn the light on while in this [user.loc]" //To prevent some lighting anomalities.
			return
		on = !on
		icon_state = "rig[on]-[color]"
//		item_state = "rig[on]-[color]"

		if(on)	user.SetLuminosity(user.luminosity + brightness_on)
		else	user.SetLuminosity(user.luminosity - brightness_on)

	pickup(mob/user)
		if(on)
			user.SetLuminosity(user.luminosity + brightness_on)
//			user.UpdateLuminosity()
			SetLuminosity(0)

	dropped(mob/user)
		if(on)
			user.SetLuminosity(user.luminosity - brightness_on)
//			user.UpdateLuminosity()
			SetLuminosity(brightness_on)

/obj/item/clothing/suit/space/rig
	name = "engineering hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has radiation shielding."
	icon_state = "rig-engineering"
	item_state = "eng_hardsuit"
	slowdown = 2
	armor = list(melee = 40, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 60)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/weapon/storage/satchel,/obj/item/device/t_scanner,/obj/item/weapon/pickaxe, /obj/item/weapon/rcd)


//Chief Engineer's rig
/obj/item/clothing/head/helmet/space/rig/elite
	name = "advanced hardsuit helmet"
	icon_state = "rig0-white"
	item_state = "ce_helm"
	color = "white"

/obj/item/clothing/suit/space/rig/elite
	icon_state = "rig-white"
	name = "advanced hardsuit"
	item_state = "ce_hardsuit"


//Mining rig
/obj/item/clothing/head/helmet/space/rig/mining
	name = "mining hardsuit helmet"
	icon_state = "rig0-mining"
	item_state = "mining_helm"
	color = "mining"

/obj/item/clothing/suit/space/rig/mining
	icon_state = "rig-mining"
	name = "mining hardsuit"
	item_state = "mining_hardsuit"


//Syndicate rig
/obj/item/clothing/head/helmet/space/rig/syndi
	name = "blood-red hardsuit helmet"
	icon_state = "rig0-syndi"
	item_state = "syndie_helm"
	color = "syndi"
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 35, bio = 100, rad = 60)

/obj/item/clothing/suit/space/rig/syndi
	icon_state = "rig-syndi"
	name = "blood-red hardsuit"
	item_state = "syndie_hardsuit"
	slowdown = 1
	w_class = 3
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 60)
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy/sword,/obj/item/weapon/handcuffs,/obj/item/weapon/tank/emergency_oxygen)

//Security rig
/obj/item/clothing/head/helmet/space/rig/security
	name = "security hardsuit helmet"
	icon_state = "rig0-security"
	color = "security"
	armor = list(melee = 60, bullet = 10, laser = 30, energy = 5, bomb = 45, bio = 100, rad = 10)

/obj/item/clothing/suit/space/rig/security
	name = "security hardsuit"
	desc = "A suit specially designed for security to offer minor protection from environmental hazards, and greater protection from human hazards"
	icon_state = "rig-security"
	item_state = "rig-security"
	slowdown = 1
	armor = list(melee = 60, bullet = 10, laser = 30, energy = 5, bomb = 45, bio = 100, rad = 10)
	allowed = list(/obj/item/weapon/gun/energy/laser, /obj/item/weapon/gun/energy/pulse_rifle, /obj/item/device/flashlight, /obj/item/weapon/tank/emergency_oxygen, /obj/item/weapon/gun/energy/taser, /obj/item/weapon/melee/baton)

//Atmos Rig
/obj/item/clothing/head/helmet/space/rig/atmos
	name = "atmospherics pressure suit helmet"
	icon_state = "rig0-atmos"
	item_state = "atmos_helm"
	color = "atmos"
	flags = STOPSPRESSUREDMAGE
	armor = list(melee = 40, bullet = 0, laser = 0, energy = 0, bomb = 25, bio = 100, rad = 0)
	gas_transfer_coefficient = 0
	permeability_coefficient = 0
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECITON_TEMPERATURE

/obj/item/clothing/suit/space/rig/atmos
	icon_state = "rig-atmos"
	name = "atmospherics pressure suit"
	item_state = "atmos_hardsuit"
	flags = STOPSPRESSUREDMAGE
	armor = list(melee = 40, bullet = 0, laser = 0, energy = 0, bomb = 25, bio = 100, rad = 0)
	gas_transfer_coefficient = 0
	permeability_coefficient = 0
	slowdown = 1.0
	heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECITON_TEMPERATURE