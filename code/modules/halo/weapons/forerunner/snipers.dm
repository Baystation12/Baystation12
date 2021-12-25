
/obj/item/weapon/gun/projectile/binary_rifle
	name = "Z-750 Special Application Sniper Rifle"
	desc = "A poor fit for close range combat, this rifle requires a short duration of focus, which then unleashes a dual-shot of hardlight projectiles."
	icon = 'code/modules/halo/weapons/icons/forerunner_sprites64.dmi'
	icon_state = "binaryrifle"
	item_state = "binaryrifle"
	wielded_item_state = "binaryrifle"
	w_class = ITEM_SIZE_HUGE
	load_method = MAGAZINE
	handle_casings = CASELESS
	caliber = "hardlightBinaryrifle"
	slot_flags = SLOT_BACK
	magazine_type = /obj/item/ammo_magazine/binaryrifle
	fire_sound = 'code/modules/halo/sounds/binaryrifle_fire.ogg'
	reload_sound = 'code/modules/halo/sounds/binaryrifle_reload.ogg'
	one_hand_penalty = -1
	accuracy = -12
	screen_shake = 0
	dispersion = list(0)
	fire_delay = 12
	burst = 2
	burst_delay = 1
	fire_delay = 8

	is_charged_weapon = 1
	arm_time = 5
	charge_sound = null
	auto_eject = 1

	scope_zoom_amount = 8
	min_zoom_amount = 3
	is_scope_variable = 1

	scoped_accuracy = 7

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/forerunner_sprites_inhand_l.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/forerunner_sprites_inhand_r.dmi',
		)

/obj/item/weapon/gun/projectile/binary_rifle/can_use_when_prone()
	return 1

/obj/item/weapon/gun/projectile/binary_rifle/verb/scope()
	set category = "Weapon"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(usr, scope_zoom_amount)

/obj/item/weapon/gun/projectile/binary_rifle/update_icon()
	if(ammo_magazine)
		icon_state = "binaryrifle"
	else
		icon_state = "binaryrifle_empty"
	. = ..()
