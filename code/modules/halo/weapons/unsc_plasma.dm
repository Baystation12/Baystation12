//See code/modules/halo/machinery/unsc_plasma_charger.dm



/* ASSAULT RIFLE */

/obj/item/weapon/gun/energy/unsc_plasma
	name = "\improper MA5P ICWS Assault Rifle"
	desc = "Advanced version of the UNSC standard-issue service rifle. Fires plasma rounds"
	icon_state = "ma5p_dry"
	cell_type = /obj/item/unsc_plasma_cell/light_rounds
	projectile_type = /obj/item/projectile/energy/unsc_plasma_light
	fire_sound = 'code/modules/halo/sounds/laserAR660rpm2.wav'
	var/reload_sound = 'code/modules/halo/sounds/Assault_Rifle_Reload_New.wav'
	slot_flags = SLOT_BACK

	//obj sprites
	var/full_state = "ma5p"
	var/dry_state = "ma5p_dry"
	var/unloaded_state = "ma5p_unloaded"

	//default stuff
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	w_class = ITEM_SIZE_LARGE
	charge_meter = 0
	charge_cost = 1
	one_hand_penalty = -1

	//fire settings
	burst = 5
	burst_delay = 1.8
	dispersion = list(0.0,0.2,0.3,0.5,0.73)
	hud_bullet_usebar = 1

	//mob sprites
	var/item_state_full = "ma5p"
	var/item_state_dry = "ma5b"
	item_state = "ma5b"
	wielded_item_state = "ma5b-wielded"
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		slot_back_str = 'code/modules/halo/weapons/icons/Back_Weapons.dmi',
		slot_s_store_str = 'code/modules/halo/weapons/icons/Armor_Weapons.dmi',
		)

/obj/item/weapon/gun/energy/unsc_plasma/update_icon()

	var/old_state = icon_state
	if(power_supply)
		if(power_supply.charge)
			icon_state = full_state
			item_state = item_state_full
			wielded_item_state = "[item_state_full]-wielded"
		else
			icon_state = dry_state
			item_state = item_state_dry
			wielded_item_state = "[item_state_dry]-wielded"
	else
		icon_state = unloaded_state
		item_state = item_state_dry
		wielded_item_state = "[item_state_dry]-wielded"

	. = ..()

	var/mob/M = src.loc
	if(istype(M))
		if(old_state != icon_state)

			if(M.l_hand == src)
				M.update_inv_l_hand()
			else if(M.r_hand == src)
				M.update_inv_r_hand()

/obj/item/weapon/gun/energy/unsc_plasma/attack_hand(mob/user)
	if(src.loc == user && user.get_inactive_hand() == src)
		//unloading
		if(power_supply)
			//tell the user
			to_chat(user,"<span class='info'>You remove [power_supply] from [src].</span>")
			playsound(src, reload_sound, 100, 1)

			//remove it
			if(!user.put_in_hands(power_supply))
				power_supply.forceMove(get_turf(power_supply))
			power_supply = null

			//update the sprite
			update_icon()

		else
			to_chat(user,"<span class='info'>[src] has no plasma power cell inserted.</span>")
	else
		return ..()

/obj/item/weapon/gun/energy/unsc_plasma/attackby(var/obj/item/I, mob/user)
	//reloading
	if(istype(I, cell_type))
		if(power_supply)
			to_chat(user,"<span class='info'>[src] already has [power_supply] loaded.</span>")
		else
			//move it in
			user.drop_item()
			I.forceMove(src)
			power_supply = I

			//update the sprite
			update_icon()

			//tell the user
			to_chat(user,"<span class='info'>You load [I] into [src].</span>")
			playsound(src, reload_sound, 100, 1)

	else if(istype(I, /obj/item/unsc_plasma_cell))
		to_chat(user,"<span class='info'>[src] does not accept that kind of plasma cell.</span>")

	else
		return ..()

/obj/item/weapon/gun/energy/unsc_plasma/consume_next_projectile()
	. = ..()
	if(power_supply && !power_supply.charge)
		update_icon()

/obj/item/unsc_plasma_cell/light_rounds
	name = "UNSC light plasma magazine"
	desc = "Plasma rounds for the MA5P."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "plasma_mag_light0"
	icon_state_base = "plasma_mag_light"
	maxcharge = 200

/obj/item/projectile/energy/unsc_plasma_light
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "plasma_proj_light"
	damage = 25

/obj/item/weapon/gun/energy/unsc_plasma/full
	icon_state = "ma5p"
	item_state = "ma5p"
	wielded_item_state = "ma5p-wielded"

/obj/item/weapon/gun/energy/unsc_plasma/full/Initialize()
	. = ..()
	power_supply.give(power_supply.maxcharge)



/* DESIGNATED MARKSMAN RIFLE */

/obj/item/weapon/gun/energy/unsc_plasma/marksman
	name = "\improper M414 Designated Marksman Rifle"
	desc = "Advanced version of the UNSC's Designated Marksman Rifle that fires superheated plasma rounds"
	icon_state = "m414_dry"
	cell_type = /obj/item/unsc_plasma_cell/heavy_rounds
	projectile_type = /obj/item/projectile/energy/unsc_plasma_heavy
	fire_sound = 'code/modules/halo/sounds/WPN_Rifle_Laser_Fire_Player_03.wav'
	reload_sound = 'code/modules/halo/sounds/DMR_Reload_New.wav'

	//obj sprites
	full_state = "m414"
	dry_state = "m414_dry"
	unloaded_state = "m414_unloaded"

	//mob sprites
	item_state_full = "m414"
	item_state_dry = "m392"
	//
	item_state = "m392"
	wielded_item_state = "m392-wielded"

	//fire settings
	accuracy = 2
	burst = 1
	fire_delay = 10
	dispersion = list(0.26)
	hud_bullet_usebar = 1

	//mob sprites
	item_state = "m392"
	wielded_item_state = "m392-wielded"
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		slot_back_str = 'code/modules/halo/weapons/icons/Back_Weapons.dmi',
		slot_s_store_str = 'code/modules/halo/weapons/icons/Armor_Weapons.dmi',
		)

/obj/item/unsc_plasma_cell/heavy_rounds
	name = "UNSC heavy plasma magazine"
	desc = "Plasma rounds for the M414 DMR."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "plasma_mag_heavy0"
	icon_state_base = "plasma_mag_heavy"
	maxcharge = 75

/obj/item/projectile/energy/unsc_plasma_heavy
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "plasma_proj_heavy"
	damage = 25
	armor_penetration = 15

/obj/item/weapon/gun/energy/unsc_plasma/marksman/full
	icon_state = "m414"
	item_state = "m414"
	wielded_item_state = "m414-wielded"

/obj/item/weapon/gun/energy/unsc_plasma/marksman/full/Initialize()
	. = ..()
	power_supply.give(power_supply.maxcharge)
