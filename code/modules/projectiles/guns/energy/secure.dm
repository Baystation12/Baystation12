/obj/item/weapon/gun/energy/gun/small/secure
	name = "compact smartgun"
	desc = "Combining the two LAEP90 variants, the secure and compact LAEP90-CS is the next best thing to keeping your security forces on a literal leash."
	icon = 'icons/obj/gun_secure.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/onmob/items/lefthand_guns_secure.dmi',
		slot_r_hand_str = 'icons/mob/onmob/items/righthand_guns_secure.dmi',
		)
	req_one_access = list(access_brig, access_heads)
	authorized_modes = list(ALWAYS_AUTHORIZED, AUTHORIZED)

/obj/item/weapon/gun/energy/stunrevolver/secure
	name = "smart stun revolver"
	desc = "This A&M X6 is fitted with an NT1019 chip which allows remote authorization of weapon functionality. It has an SCG emblem on the grip."
	icon = 'icons/obj/gun_secure.dmi'
	icon_state = "revolverstun"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/onmob/items/lefthand_guns_secure.dmi',
		slot_r_hand_str = 'icons/mob/onmob/items/righthand_guns_secure.dmi',
		)
	firemodes = list(
					list(mode_name="stun", projectile_type=/obj/item/projectile/energy/electrode/green, modifystate="revolverstun"),
					list(mode_name="shock", projectile_type=/obj/item/projectile/energy/electrode/stunshot, modifystate="revolvershock")
					)
	item_state = null
	req_one_access = list(access_brig, access_heads)
	projectile_type = /obj/item/projectile/energy/electrode/green

/obj/item/weapon/gun/energy/gun/secure
	name = "smartgun"
	desc = "A more secure LAEP90, the LAEP90-S is designed to please paranoid constituents. Body cam not included."
	icon = 'icons/obj/gun_secure.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/onmob/items/lefthand_guns_secure.dmi',
		slot_r_hand_str = 'icons/mob/onmob/items/righthand_guns_secure.dmi',
		)
	item_state = null	//so the human update icon uses the icon_state instead.
	req_one_access = list(access_brig, access_heads)
	authorized_modes = list(ALWAYS_AUTHORIZED, AUTHORIZED)

/obj/item/weapon/gun/energy/gun/secure/mounted
	name = "robot energy gun"
	desc = "A robot-mounted equivalent of the LAEP90-S, which is always registered to its owner."
	self_recharge = 1
	use_external_power = 1
	one_hand_penalty = 0

/obj/item/weapon/gun/energy/gun/secure/mounted/New()
	var/mob/borg = get_holder_of_type(src, /mob/living/silicon/robot)
	if(!borg)
		CRASH("Invalid spawn location.")
	registered_owner = borg.name
	GLOB.registered_cyborg_weapons += src
	..()

/obj/item/weapon/gun/energy/laser/secure
	name = "laser carbine"
	desc = "A Hephaestus Industries G40E carbine, designed to kill with concentrated energy blasts. Fitted with an NT1019 chip to make sure killcount is tracked appropriately."
	icon = 'icons/obj/gun_secure.dmi'
	icon_state = "lasersec"
	req_one_access = list(access_brig, access_heads)