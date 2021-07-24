
//ACL-55 rocket launcher

/obj/item/weapon/gun/launcher/rocket/rgl
	name = "RGL-Mk12"
	desc = "Rocket Grenade Launcher"
	icon = 'code/modules/halo/weapons/icons/URF gadgetry.dmi'
	icon_state = "1shot_launcher"
	item_state = "m41"
	fire_sound = 'code/modules/halo/sounds/RocketLauncherShotSoundEffect.ogg'
	//reload_sound = 'code/modules/halo/sounds/RocketLauncherReloadSoundEffect.ogg'
	one_hand_penalty = -1
	w_class = ITEM_SIZE_HUGE
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)

/obj/item/weapon/gun/projectile/ACL55
	name = "ACL-55"
	desc = "The Adaptiv Combat Launcher or ACL-55 is a new surface to surface rocket launcher model for anti armor and anti infantry purposes desgined by X-25. Takes M-20 series tubes."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "rawketlauncha"
	item_state = "w_rocketlauncher"
	fire_sound = 'code/modules/halo/sounds/RocketLauncherShotSoundEffect.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m26
	fire_delay = 8
	dispersion = list(0.73)
	one_hand_penalty = -1
	hud_bullet_row_num = 1
	hud_bullet_reffile = 'code/modules/halo/icons/hud_display/hud_bullet_32x16.dmi'
	hud_bullet_iconstate = "rocket"
	caliber = "m26"
	handle_casings = CASELESS
	w_class = ITEM_SIZE_HUGE
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)
	crosshair_file = 'code/modules/halo/weapons/icons/dragaim_missile.dmi'

/obj/item/weapon/gun/projectile/ACL55/update_icon()
	. = ..()
	if(ammo_magazine)
		icon_state = "rawketlauncha"
	else
		icon_state = "rawketlauncha_unloaded"
