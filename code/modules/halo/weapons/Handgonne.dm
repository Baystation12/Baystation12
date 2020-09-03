
//Hand Cannon

/obj/item/weapon/gun/projectile/heavysniper/handgonne
	name = "Handgonne"
	desc = "A very rare sidearm made for some kind of big game hunting. Takes 14.5mm shells."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "handcannon"
	item_state = "handgonne"
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	caliber = "14.5mm"
	screen_shake = 1 //extra kickback
	max_shells = 3
	one_hand_penalty = 0
	dispersion = list(0.1) //Sniper pistol, using sniper dispersions.
	ammo_type = /obj/item/ammo_casing/m233
	w_class = ITEM_SIZE_NORMAL
	accuracy = 0
	wielded_item_state = "handgonne"
	hud_bullet_row_num = 1
	hud_bullet_reffile = 'code/modules/halo/icons/hud_display/hud_bullet_7x8.dmi'
	hud_bullet_iconstate = "bigpistol"

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)

/obj/item/weapon/gun/projectile/heavysniper/handgonne/scope()
	 return
