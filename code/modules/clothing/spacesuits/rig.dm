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
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/weapon/storage/bag/ore,/obj/item/device/t_scanner,/obj/item/weapon/pickaxe, /obj/item/weapon/rcd)


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

//Wizard Rig
/obj/item/clothing/head/helmet/space/rig/wizard
	name = "gem-encrusted hardsuit helmet"
	icon_state = "rig0-wiz"
	item_state = "wiz_helm"
	color = "wiz"
	unacidable = 1 //No longer shall our kind be foiled by lone chemists with spray bottles!
	armor = list(melee = 40, bullet = 20, laser = 20,energy = 20, bomb = 35, bio = 100, rad = 60)

/obj/item/clothing/suit/space/rig/wizard
	icon_state = "rig-wiz"
	name = "gem-encrusted hardsuit"
	item_state = "wiz_hardsuit"
	slowdown = 1
	w_class = 3
	unacidable = 1
	armor = list(melee = 40, bullet = 20, laser = 20,energy = 20, bomb = 35, bio = 100, rad = 60)
	allowed = list(/obj/item/weapon/teleportation_scroll,/obj/item/weapon/tank/emergency_oxygen)



//Medical Rig
/obj/item/clothing/head/helmet/space/rig/medical
	name = "medical hardsuit helmet"
	icon_state = "rig0-medical"
	item_state = "medical_helm"
	color = "medical"

/obj/item/clothing/suit/space/rig/medical
	icon_state = "rig-medical"
	name = "medical hardsuit"
	item_state = "medical_hardsuit"
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/weapon/storage/firstaid,/obj/item/device/healthanalyzer,/obj/item/stack/medical)