
//MA5B assault rifle

/obj/item/weapon/gun/projectile/ma5b_ar
	name = "\improper MA5B Assault Rifle"
	desc = "Standard-issue service rifle of the UNSC Marines. Has an inbuilt underbarrel flashlight. Takes 7.62mm calibre magazines."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "MA5-Base-Empty"
	item_state = "ma5b"
	caliber = "a762"
	slot_flags = SLOT_BACK
	fire_sound = 'code/modules/halo/sounds/Assault_Rifle_Fire_New.wav'
	reload_sound = 'code/modules/halo/sounds/Assault_Rifle_Reload_New.wav'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m762_ap/MA5B
	allowed_magazines = list(/obj/item/ammo_magazine/m762_ap/MA5B) //Disallows loading LMG boxmags into the MA5B

	burst = 5
	burst_delay = 1.8
	one_hand_penalty = -1
	dispersion = list(0.0,0.2,0.3,0.5,0.73) //@ 7 tiles, deviation is 0 - 1 tiles.
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

/obj/item/weapon/gun/projectile/ma5b_ar/MA37/add_flashlight()
	return

/obj/item/weapon/gun/projectile/ma5b_ar/training
	magazine_type = /obj/item/ammo_magazine/m762_ap/MA5B/TTR

/obj/item/weapon/gun/projectile/ma5b_ar/MA37
	name = "\improper MA37 ICWS"
	desc = "Also formally known as the MA5. Takes 7.62mm ammo."
	icon_state = "MA37"
	item_state = "ma37"
	fire_sound = 'code/modules/halo/sounds/MA37_Fire_New.wav'
	//fire_sound_burst = 'code/modules/halo/sounds/MA37_Fire_New.wav'
	reload_sound = 'code/modules/halo/sounds/MA37_Reload_New.wav'
	magazine_type = /obj/item/ammo_magazine/m762_ap/MA37

	burst = 3
	burst_delay = 2.0
	dispersion = list(0.0,0.3,0.5)
	hud_bullet_row_num = 18

	ammo_icon_state = null
	allowed_magazines = list(/obj/item/ammo_magazine/m762_ap/MA37)
	attachment_slots = null
	attachments_on_spawn = null

/obj/item/weapon/gun/projectile/ma5b_ar/MA37/update_icon()
	. = ..()
	if(ammo_magazine)
		icon_state = "MA37"
	else
		icon_state = "MA37_unloaded"

/obj/item/weapon/gun/projectile/ma5b_ar/proc/toggle_light()
	set category = "Weapon"
	set name = "Toggle Gun Light"
	on = !on
	if(on && activation_sound)
		playsound(src.loc, activation_sound, 75, 1)
		set_light(4)
	else
		set_light(0)

/obj/item/weapon/gun/projectile/ma5b_ar/MA3
	name = "\improper MA3 Assault Rifle"
	desc = "An obsolete military assault rifle commonly available on the black market. Takes 7.62mm ammo."
	icon_state = "MA3"
	item_state = "ma3"
	magazine_type = /obj/item/ammo_magazine/m762_ap/MA3
	ammo_icon_state = null
	allowed_magazines = list(/obj/item/ammo_magazine/m762_ap/MA3)
	attachment_slots = null
	attachments_on_spawn = null
	burst = 4
	burst_delay = 1.7
	one_hand_penalty = -1
	dispersion = list(0.2,0.3,0.5,0.73)
	fire_sound = 'code/modules/halo/sounds/MA3firefix.ogg'
	reload_sound = 'code/modules/halo/sounds/MA3reload.ogg'

	attachment_slots = list("underbarrel rail","sight","barrel")
	attachments_on_spawn = list(/obj/item/weapon_attachment/light/flashlight)


/obj/item/weapon/gun/projectile/ma5b_ar/MA3/update_icon()
	. = ..()
	if(ammo_magazine)
		icon_state = "MA3"
	else
		icon_state = "MA3_unloaded"

//BR85 battle

/obj/item/weapon/gun/projectile/br85
	name = "\improper BR85 Battle Rifle"
	desc = "When nothing else gets the job done, the BR85 Battle Rifle will do. Takes 9.5mm calibre magazines."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "Br85"
	item_state = "br85"
	caliber = "9.5mm"
	slot_flags = SLOT_BACK
	fire_sound = 'code/modules/halo/sounds/BattleRifleShotSoundEffect.ogg'
	reload_sound = 'code/modules/halo/sounds/AssaultRifle&BattleRifle_ReloadSound_Effect.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m95_sap
	allowed_magazines = list(/obj/item/ammo_magazine/m95_sap)
	one_hand_penalty = -1
	burst = 3
	burst_delay = 1.2
	hud_bullet_row_num = 18
	w_class = ITEM_SIZE_LARGE
	dispersion=list(0.26, 0.26, 0.26) //About a third of a tile at 7 tile range.
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)

/obj/item/weapon/gun/projectile/br85/can_use_when_prone()
	return 1

/obj/item/weapon/gun/projectile/br85/verb/scope()
	set category = "Weapon"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(usr, 1.15)

/obj/item/weapon/gun/projectile/br85/update_icon()
	if(ammo_magazine)
		icon_state = "Br85"
	else
		icon_state = "Br85_unloaded"
	. = ..()

/obj/item/weapon/gun/projectile/br55
	name = "\improper BR55 Battle Rifle"
	desc = "The BR55 is an all-round infantry weapon with a 2x magnification scope."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "BR55-Loaded-Base"
	item_state = "br55"
	magazine_type = /obj/item/ammo_magazine/m95_sap/br55
	allowed_magazines = list(/obj/item/ammo_magazine/m95_sap)
	caliber = "9.5mm"
	slot_flags = SLOT_BACK
	fire_sound = 'code/modules/halo/sounds/Battle_Rifle_Fire_New.wav'
	reload_sound = 'code/modules/halo/sounds/Battle_Rifle_Reload_New.wav'
	load_method = MAGAZINE
	one_hand_penalty = -1
	burst = 3
	burst_delay = 1.2
	hud_bullet_row_num = 18
	w_class = ITEM_SIZE_LARGE
	dispersion=list(0.26, 0.26, 0.26)
	wielded_item_state = "br55-wielded"
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		slot_back_str = 'code/modules/halo/weapons/icons/Back_Weapons.dmi',
		slot_s_store_str = 'code/modules/halo/weapons/icons/Armor_Weapons.dmi',
		)
	attachment_slots = list("barrel","underbarrel rail","upper rail","upper stock")
	attachments_on_spawn = list(/obj/item/weapon_attachment/barrel/br55,/obj/item/weapon_attachment/br55_stock_cheekrest,/obj/item/weapon_attachment/br55_bottom,/obj/item/weapon_attachment/br55_upper,/obj/item/weapon_attachment/sight/br55_scope)

/obj/item/weapon/gun/projectile/br55/can_use_when_prone()
	return 1

/obj/item/weapon/gun/projectile/br55/update_icon()
	if(ammo_magazine)
		icon_state = "BR55-Loaded-Base"
	else
		icon_state = "BR55-Unloaded-Base"
	. = ..()