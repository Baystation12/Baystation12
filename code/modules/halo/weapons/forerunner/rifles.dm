
/obj/item/weapon/gun/projectile/suppressor
	name = "Z-130 Directed Energy Automatic Weapon"
	desc = "A hardlight weapon capable of firing incredibly fast, although reaiming after bursts of fire takes longer."
	icon = 'code/modules/halo/weapons/icons/forerunner_sprites.dmi'
	icon_state = "suppressor"
	item_state = "suppressor"
	wielded_item_state = "suppressor"
	caliber = "hardlightSuppressor"
	slot_flags = SLOT_BACK
	fire_sound = 'code/modules/halo/sounds/suppressor_fire.ogg'
	reload_sound = 'code/modules/halo/sounds/suppressor_reload.ogg'
	auto_eject = 1
	auto_eject_sound = 'code/modules/halo/sounds/suppressor_reload.ogg'
	load_method = MAGAZINE
	handle_casings = CASELESS
	magazine_type = /obj/item/ammo_magazine/suppressor

	fire_delay = 8
	burst = 6
	burst_delay = 1.4
	one_hand_penalty = -1
	dispersion = list(0.0,0.2,0.3,0.5,0.73,0.8)
	w_class = ITEM_SIZE_LARGE

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/forerunner_sprites_inhand_l.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/forerunner_sprites_inhand_r.dmi',
		)

/obj/item/weapon/gun/projectile/suppressor/can_use_when_prone()
	return 1

/obj/item/weapon/gun/projectile/suppressor/update_icon()
	. = ..()
	if(ammo_magazine)
		icon_state = "suppressor"
	else
		icon_state = "suppressor_empty"