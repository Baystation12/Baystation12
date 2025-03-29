
/obj/item/weapon/gun/projectile/railrifle
	name = "Asymmetric Recoilles Carbine-920"
	desc = "An Acheron Security experimental railgun, capable of firing ferromagnetic slugs at incredibly high speeds. Heavy, but powerful."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "railgun"
	item_state = "ionrifle-wielded"
	fire_sound = 'code/modules/halo/sounds/railgun_fire.ogg'
	load_method = SINGLE_CASING
	handle_casings = CASELESS
	max_shells = 1
	auto_eject = 1
	is_charged_weapon = TRUE
	arm_time = 20
	charge_sound = 'code/modules/halo/sounds/railgun_charge.ogg'
	fire_delay = 10
	one_hand_penalty = -1
	hud_bullet_row_num = 1
	hud_bullet_reffile = 'code/modules/halo/icons/hud_display/hud_bullet_32x16.dmi'
	hud_bullet_iconstate = "sniper"
	accuracy = 0
	scoped_accuracy = 1
	scope_zoom_amount = 3
	is_scope_variable = 1
	caliber = "railslug"
	screen_shake = 1.5
	slot_flags = SLOT_BACK
	w_class = ITEM_SIZE_LARGE
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	ammo_type = /obj/item/ammo_casing/railslug
	slowdown_general = 0.4