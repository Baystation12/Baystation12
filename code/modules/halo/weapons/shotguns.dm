
//M90 shotgun
//nothing special here, basically just a resprite
/obj/item/weapon/gun/projectile/shotgun/pump/m90_ts
	name = "M90 tactical shotgun"
	desc = "The UNSC's primary shotgun and one of the most effective close range infantry weapons used by front line forces. Has an inbuilt side mounted flashlight."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "m90"
	item_state = "m90"
	fire_sound = 'code/modules/halo/sounds/Shotgun_Fire_New.wav'
	reload_sound = 'code/modules/halo/sounds/Shotgun_Reload_New.wav'
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	max_shells = 8
	fire_delay = 8
	one_hand_penalty = -1
	dispersion = list(0.45)
	hud_bullet_row_num = 8
	hud_bullet_reffile = 'code/modules/halo/icons/hud_display/hud_bullet_7x8.dmi'
	hud_bullet_iconstate = "shell"
	var/on = 0
	var/activation_sound = 'code/modules/halo/sounds/Assault_Rifle_Flashlight.wav'
	w_class = ITEM_SIZE_LARGE
	wielded_item_state = "m90-wielded"
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		slot_back_str = 'code/modules/halo/weapons/icons/Back_Weapons.dmi',
		slot_s_store_str = 'code/modules/halo/weapons/icons/Armor_Weapons.dmi',
		)


/obj/item/weapon/gun/projectile/shotgun/pump/m90_ts/verb/toggle_light()
	set category = "Object"
	set name = "Toggle Gun Light"
	on = !on
	if(on && activation_sound)
		playsound(src.loc, activation_sound, 75, 1)
		set_light(4)
	else
		set_light(0)

//SOE Shotgun

/obj/item/weapon/gun/projectile/shotgun/soe
	name = "KV-32 custom shotgun"
	desc = "An old model of a shotgun, has two barrels."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "KV-32_unloaded"
	item_state = "KV-32"
	load_method = MAGAZINE
	caliber = "shotgunlowpower"
	slot_flags = SLOT_BACK
	magazine_type = /obj/item/ammo_magazine/kv32
	one_hand_penalty = -1
	burst = 1
	fire_delay = 5
	burst_delay = 1
	screen_shake = 1
	accuracy = -1
	dispersion = list(0.45)
	hud_bullet_reffile = 'code/modules/halo/icons/hud_display/hud_bullet_7x8.dmi'
	hud_bullet_iconstate = "shell"
	hud_bullet_row_num = 2
	w_class = ITEM_SIZE_LARGE
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)
	wielded_item_state = "KV-32-wielded" //sort of placeholder
	fire_sound = 'code/modules/halo/sounds/Shotgun_Shot_Sound_Effect.ogg'
	reload_sound = 'code/modules/halo/sounds/Shotgun_Pump_Slide.ogg'

/obj/item/weapon/gun/projectile/shotgun/soe/update_icon()
	if(ammo_magazine)
		icon_state = "KV-32_loaded"
	else
		icon_state = "KV-32_unloaded"
	. = ..()

/obj/item/ammo_magazine/kv32
	name = "magazine (12 gauge) Buckshot"
	desc = "12 gauge magazine containing 4 rounds. Fits the KV-32."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "kv_mag"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/shotgun/pellet/low_power
	matter = list(DEFAULT_WALL_MATERIAL = 1500)
	caliber = "shotgunlowpower"
	max_ammo = 4
	multiple_sprites = 1

//M45 TS shotgun

/obj/item/weapon/gun/projectile/shotgun/pump/m45_ts
	name = "M45 TS tactical shotgun"
	desc = "The UNSC's older model of the primary shotgun and one of the most effective close range infantry weapons used by front line forces. Has an inbuilt side mounted flashlight."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "M45 TS"
	item_state = "m45"
	fire_sound = 'code/modules/halo/sounds/Shotgun_Shot_Sound_Effect.ogg'
	reload_sound = 'code/modules/halo/sounds/Shotgun_Pump_Slide.ogg'
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	max_shells = 6
	one_hand_penalty = -1
	dispersion = list(0.45)
	hud_bullet_row_num = 6
	hud_bullet_reffile = 'code/modules/halo/icons/hud_display/hud_bullet_7x8.dmi'
	hud_bullet_iconstate = "shell"
	var/on = 0
	var/activation_sound = 'sound/effects/flashlight.ogg'
	w_class = ITEM_SIZE_LARGE
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)


/obj/item/weapon/gun/projectile/shotgun/pump/m45_ts/police
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag

/obj/item/weapon/gun/projectile/shotgun/pump/m45_ts/verb/toggle_light()
	set category = "Object"
	set name = "Toggle Gun Light"
	on = !on
	if(on && activation_sound)
		playsound(src.loc, activation_sound, 75, 1)
		set_light(4)
	else
		set_light(0)