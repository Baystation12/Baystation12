
/obj/item/weapon/gun/energy/spartanlaser
	name = "M6 Grindell/Galilean Nonlinear Rifle"
	desc = "Also known as the spartan laser, is the most powerful handheld weapon produced by the UNSC. It can disable most vehicles and infantry in a single hit."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "spartanlaser"
	item_state = "m41"
	slot_flags = SLOT_BACK
	w_class = ITEM_SIZE_HUGE

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)

	one_hand_penalty = -1
	self_recharge = 1
	recharge_time = 20
	max_shots = 4
	is_charged_weapon = TRUE

	arm_time = 5 //Deciseconds
	charge_meter = 0
	force = 10
	screen_shake = 0.5
	fire_delay = 10
	scope_zoom_amount = 3
	overheat_capacity = 3
	overheat_fullclear_delay = 18

	fire_sound = null

	origin_tech = list(TECH_COMBAT = 10, TECH_POWER = 20)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	projectile_type = /obj/item/projectile/beam/spartan

	hud_bullet_usebar = 1

	burst = 2
	burst_delay = 2.5

/obj/item/weapon/gun/energy/spartanlaser/verb/scope()
	set category = "Weapon"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(usr,scope_zoom_amount)

/obj/item/projectile/beam/spartan
	name = "spartan laser"
	icon_state = "heavylaser"
	damage = 100
	shield_damage = 100 //No shields for you
	armor_penetration = 100

	fire_sound = 'code/modules/halo/sounds/Spartan_Laser_Beam_Shot_Sound_Effect.ogg'

	muzzle_type = /obj/effect/projectile/laser_heavy/muzzle
	tracer_type = /obj/effect/projectile/laser_heavy/tracer
	impact_type = /obj/effect/projectile/laser_heavy/impact
