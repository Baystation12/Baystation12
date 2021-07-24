
/obj/item/weapon/gun/projectile/m545_lmg
	name = "\improper M545 Light Machine Gun"
	desc = "An antiquated light machine gun. Takes 7.62mm box type magazines"
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "Innie 30cal LMG - Full Closed"
	item_state = "30cal"
	caliber = "7.62mm"
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m545/m118
	allowed_magazines = list(/obj/item/ammo_magazine/m545)
	//fire_sound = 'code/modules/halo/sounds/MagnumShotSoundEffect.ogg'
	reload_sound = 'code/modules/halo/sounds/UNSC_Saw_Reload_Sound_Effect.ogg'
	one_hand_penalty = -1
	dispersion = list(0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.6, 0.6, 0.6, 0.6)
	w_class = ITEM_SIZE_HUGE
	hud_bullet_row_num = 50
	hud_bullet_reffile = 'code/modules/halo/icons/hud_display/hud_bullet_2x5.dmi'
	wielded_item_state = "SAW-wielded"
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)
	burst_delay = 1.5
	move_delay_malus = 1.5
	slowdown_general = 1

	firemodes = list(\
	list(mode_name="short bursts",  burst=12,accuracy=0, dispersion=list(0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.6, 0.6, 0.6, 0.6)),
	list(mode_name="extended bursts", burst=32, accuracy=-1,dispersion=list(0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.7, 0.7, 0.7, 0.7))
	)

/obj/item/weapon/gun/projectile/m545_lmg/update_icon()
	. = ..()
	if(ammo_magazine)
		icon_state = "Innie 30cal LMG - Full Closed"
	else
		icon_state = "Innie 30cal LMG - Empty Open"

//Bit of handling for the loading states.
/obj/item/weapon/gun/projectile/m545_lmg/load_ammo(var/item/I,var/mob/user)
	flick("Innie 30cal LMG - Empty Open",src)
	. = ..()

/obj/item/weapon/gun/projectile/m545_lmg/unload_ammo(var/mob/user,var/allow_dump = 0)
	flick("Innie 30cal LMG - Full Open",src)
	. = ..()

//Basic Magazine

/obj/item/ammo_magazine/m545
	name = "M545 box magazine"
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "Innie 30cal box - Full"
	mag_type = MAGAZINE
	caliber = "7.62mm"
	max_ammo = 150
	multiple_sprites = 1
	w_class = ITEM_SIZE_NORMAL

//M118 Ammunition

/obj/item/ammo_magazine/m545/m118
	name = "M545 box magazine (7.62mm) M118"
	desc = "7.62x51mm M118 Full Metal Jacket Armour Piercing (FMJ-AP) box magazine for the M545 squad support weapon containing 150 shots."
	ammo_type = /obj/item/ammo_casing/m118

/obj/item/weapon/storage/box/large/m545_m118
	name = "box of M545 7.62mm M118 box magazines"
	startswith = list(/obj/item/ammo_magazine/m545/m118 = 3)
