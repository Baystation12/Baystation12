
//MA5B assault rifle

/obj/item/weapon/gun/projectile/ma5b_ar
	name = "\improper MA5B Assault Rifle"
	desc = "Standard-issue service rifle of the UNSC Marines. Has an inbuilt underbarrel flashlight. Takes 7.62mm calibre magazines."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "MA5-Base-Empty"
	item_state = "ma5b"
	caliber = "7.62mm"
	slot_flags = SLOT_BACK
	fire_sound = 'code/modules/halo/sounds/Assault_Rifle_Fire_New.wav'
	reload_sound = 'code/modules/halo/sounds/Assault_Rifle_Reload_New.wav'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/ma5b/m118
	allowed_magazines = list(/obj/item/ammo_magazine/ma5b)

	burst = 5
	burst_delay = 1.8
	one_hand_penalty = -1
	dispersion = list(0.0,0.2,0.4,0.6,0.73) //@ 7 tiles, deviation is 0 - 1 tiles.
	hud_bullet_row_num = 20

	var/on = 0
	var/activation_sound = 'code/modules/halo/sounds/Assault_Rifle_Flashlight.wav'

	w_class = ITEM_SIZE_LARGE
	wielded_item_state = "ma5b-wielded"

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		slot_back_str = 'code/modules/halo/weapons/icons/Back_Weapons.dmi',
		slot_s_store_str = 'code/modules/halo/weapons/icons/Armor_Weapons.dmi',
		)

	firemodes = list(\
	list(mode_name="short bursts",  burst=5, dispersion=list(0.0,0.2,0.4,0.6,0.73)),
	list(mode_name="extended bursts",  burst=15, dispersion=list(0.2,0.2,0.3,0.4, 0.5, 0.6, 0.7, 0.7, 0.8, 1.0))
	)

	attachment_slots = list("barrel","underbarrel rail","upper rail","upper stock", "stock")
	attachments_on_spawn = list(/obj/item/weapon_attachment/ma5_stock_cheekrest,/obj/item/weapon_attachment/ma5_stock_butt,/obj/item/weapon_attachment/ma5_upper,/obj/item/weapon_attachment/light/flashlight)

/obj/item/weapon/gun/projectile/ma5b_ar/can_use_when_prone()
	return 1

/obj/item/weapon/gun/projectile/ma5b_ar/update_icon()
	. = ..()
	if(ammo_magazine)
		icon_state = "MA5-Base-Loaded"
	else
		icon_state = "MA5-Base-Empty"

/obj/item/weapon/gun/projectile/ma5b_ar/proc/add_flashlight()
	verbs += /obj/item/weapon/gun/projectile/ma5b_ar/proc/toggle_light

/obj/item/weapon/gun/projectile/ma5b_ar/proc/toggle_light()
	set category = "Weapon"
	set name = "Toggle Gun Light"
	on = !on
	if(on && activation_sound)
		playsound(src.loc, activation_sound, 75, 1)
		set_light(4)
	else
		set_light(0)

//Variant that spawns with nonlethal ammo

/obj/item/weapon/gun/projectile/ma5b_ar/training
	magazine_type = /obj/item/ammo_magazine/ma5b/m118_ttr

//Basic Magazine

/obj/item/ammo_magazine/ma5b
	name = "MA5B magazine"
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "MA5B_mag"
	mag_type = MAGAZINE
	caliber = "7.62mm"
	max_ammo = 60
	multiple_sprites = 1

//M118 Ammunition

/obj/item/ammo_magazine/ma5b/m118
	name = "MA5B magazine (7.62mm) M118"
	desc = "7.62x51mm M118 Full Metal Jacket Armour Piercing (FMJ-AP) magazine for the MA5B containing 60 shots."
	ammo_type = /obj/item/ammo_casing/m118

/obj/item/weapon/storage/box/ma5b_m118
	name = "box of MA5B 7.62mm M118 magazines"
	startswith = list(/obj/item/ammo_magazine/ma5b/m118 = 7)

//M118 TTR Ammunition

/obj/item/ammo_magazine/ma5b/m118_ttr
	name = "MA5B magazine (7.62mm) M118-TTR"
	desc = "7.62x51mm M118 Tactical Training Rounds (TTR) magazine for the MA5B containing 60 shots."
	ammo_type = /obj/item/ammo_casing/m118_ttr

/obj/item/weapon/storage/box/ma5b_ttr
	name = "box of MA5B 7.62mm M118-TTR magazines"
	startswith = list(/obj/item/ammo_magazine/ma5b/m118_ttr = 7)
