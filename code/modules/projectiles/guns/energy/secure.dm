/obj/item/weapon/gun/energy/gun/small/secure
	name = "compact smartgun"
	desc = "The secure variant of the NE-15C, the NE-15CS is the best way to keep yourself safe and not piss off your gun controlling senators. Uses an N.E Smart Chip to prevent unauthorized use of lethal force."
	icon = 'icons/obj/guns/small_egun_secure.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/onmob/items/lefthand_guns_secure.dmi',
		slot_r_hand_str = 'icons/mob/onmob/items/righthand_guns_secure.dmi',
		)
	req_one_access = list(access_brig, access_bridge)
	authorized_modes = list(ALWAYS_AUTHORIZED, AUTHORIZED)

/obj/item/weapon/gun/energy/stunrevolver/secure
	name = "smart stun revolver"
	desc = "The A6 Vortex, a weapon primarily used by police agencies until Nelwen Electronics, fires stun rounds at targets."
	icon = 'icons/obj/guns/stunrevolver_secure.dmi'
	icon_state = "revolverstun100"
	modifystate= "revolverstun"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/onmob/items/lefthand_guns_secure.dmi',
		slot_r_hand_str = 'icons/mob/onmob/items/righthand_guns_secure.dmi',
		)
	firemodes = list(
					list(mode_name="stun", projectile_type=/obj/item/projectile/energy/electrode/green, modifystate="revolverstun"),
					list(mode_name="shock", projectile_type=/obj/item/projectile/energy/electrode/stunshot, modifystate="revolvershock")
					)
	item_state = null
	req_one_access = list(access_brig, access_bridge)
	projectile_type = /obj/item/projectile/energy/electrode/green

/obj/item/weapon/gun/energy/gun/secure
	name = "smartgun"
	desc = "The more secured variant of the NE-15, primarily used to please gun-regulated police departments in Terran space. Uses an N.E. Smart Chip to prevent unauthorized use of lethal force."
	icon = 'icons/obj/guns/energy_gun_secure.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/onmob/items/lefthand_guns_secure.dmi',
		slot_r_hand_str = 'icons/mob/onmob/items/righthand_guns_secure.dmi',
		)
	item_state = null	//so the human update icon uses the icon_state instead.
	req_one_access = list(access_brig, access_bridge)
	authorized_modes = list(ALWAYS_AUTHORIZED, AUTHORIZED)

/obj/item/weapon/gun/energy/revolver/secure
	name = "smart service revolver"
	desc = "The LAER680-S, a standard issue service revolver commonly used by higher ranking offcers among the SCG. Fitted with an NT1019 chip which allows remote authorization of the weapon's functionality."
	icon = 'icons/obj/guns/energy_revolver.dmi'
	icon_state = "energyrevolverstun100"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/onmob/items/lefthand_guns_secure.dmi',
		slot_r_hand_str = 'icons/mob/onmob/items/righthand_guns_secure.dmi',
		)
	modifystate = "energyrevolverstun"
	item_state = null
	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, modifystate="energyrevolverstun"),
		list(mode_name="shock", projectile_type=/obj/item/projectile/beam/stun/shock, modifystate="energyrevolvershock"),
		list(mode_name="kill", projectile_type=/obj/item/projectile/beam, modifystate="energyrevolverkill"),
		)
	req_one_access = list(access_brig, access_heads)
	authorized_modes = list(ALWAYS_AUTHORIZED, AUTHORIZED)

/obj/item/weapon/gun/energy/gun/secure/mounted
	name = "robot energy gun"
	desc = "A robot-mounted equivalent of the LAEP90-S, which is always registered to its owner."
	self_recharge = 1
	use_external_power = 1
	one_hand_penalty = 0
	has_safety = FALSE

/obj/item/weapon/gun/energy/gun/secure/mounted/Initialize()
	var/mob/borg = get_holder_of_type(src, /mob/living/silicon/robot)
	if(!borg)
		CRASH("Invalid spawn location.")
	registered_owner = borg.name
	GLOB.registered_cyborg_weapons += src
	. = ..()

/obj/item/weapon/gun/energy/laser/secure
	name = "laser carbine"
	desc = "The NE-12, mass produced by Nelwen Electronics. The forefront of modern energy weaponry. This one looks older and a little worn."
	icon_state = "lasersec"
	req_one_access = list(access_brig, access_bridge)