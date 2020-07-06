
#define CLEAR_CASINGS 1
#define CASELESS 4

/obj/item/weapon/gun/projectile/m41
	name = "M41 SSR"
	desc = "Surface to surface rocket launcher for anti armor and anti infantry purposes. Takes SPNKr tubes."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "M41closed"
	item_state = "m41"
	fire_sound = 'code/modules/halo/sounds/Rocket_Launcher_Fire_New.wav'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/spnkr
	fire_delay = 8
	one_hand_penalty = -1
	dispersion = list(0.73)
	caliber = "spnkr"
	handle_casings = CASELESS
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)
	slowdown_general = 1

/obj/item/weapon/gun/projectile/m41/update_icon()
	if(ammo_magazine)
		icon_state = "M41closed"
	else
		icon_state = "M41open-empty"
	..()

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
	dispersion = list(2.6)
	one_hand_penalty = -1
	caliber = "m26"
	handle_casings = CASELESS
	w_class = ITEM_SIZE_HUGE
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)
/obj/item/weapon/gun/projectile/ACL55/update_icon()
	. = ..()
	if(ammo_magazine)
		icon_state = "rawketlauncha"
	else
		icon_state = "rawketlauncha_unloaded"