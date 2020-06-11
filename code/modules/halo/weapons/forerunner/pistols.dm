
/obj/item/weapon/gun/projectile/boltshot
	name = "Type-110 Directed Energy Pistol, Exotic"
	desc = "Commonly called the \"Boltshot\", this pistol reconfigures itself when loaded with different magazines, allowing for mid-long range firing and close range combat."
	icon = 'code/modules/halo/weapons/icons/forerunner_sprites.dmi'
	icon_state = "boltshot"
	item_state = "boltshot"

	load_method = MAGAZINE
	handle_casings = CASELESS
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	caliber = "hardlightBoltshot"
	wielded_item_state = "boltshot"

	one_hand_penalty = 1

	magazine_type = /obj/item/ammo_magazine/boltshot
	auto_eject = 1
	auto_eject_sound = 'code/modules/halo/sounds/boltshot_reload.ogg'
	reload_sound = 'code/modules/halo/sounds/boltshot_reload.ogg'

	dispersion = list(0.4)

	slowdown_general = 0

	fire_sound = null //Purposeful, pulls from ammo for fire sounds.
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/forerunner_sprites_inhand_l.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/forerunner_sprites_inhand_r.dmi',
		)

/obj/item/weapon/gun/projectile/boltshot/update_icon()
	if(!ammo_magazine)
		icon_state = "boltshot_empty"
	else
		if(istype(ammo_magazine,/obj/item/ammo_magazine/boltshot_sg))
			icon_state = "boltshot_shotgun"
			fire_delay = initial(fire_delay) + 2
		else
			icon_state = "boltshot"
			fire_delay = initial(fire_delay)
	. = ..()

/obj/item/weapon/gun/projectile/boltshot/shotgun_preload
	icon_state = "boltshot_shotgun"
	magazine_type = /obj/item/ammo_magazine/boltshot_sg