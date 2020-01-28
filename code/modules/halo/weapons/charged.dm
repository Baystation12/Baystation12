
/obj/item/weapon/gun/energy/charged
	name = "charged gun"
	desc = "a generic charged gun"

	is_charged_weapon = 1


/obj/item/weapon/gun/energy/charged/spartanlaser
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

	accuracy = 1000
	one_hand_penalty = -1
	self_recharge = 1
	recharge_time = 20
	max_shots = 4

	arm_time = 30 //Deciseconds
	charge_meter = 0
	force = 10
	screen_shake = 0.5

	fire_sound = null

	origin_tech = list(TECH_COMBAT = 10, TECH_POWER = 20)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	projectile_type = /obj/item/projectile/beam/spartan


/obj/item/weapon/gun/energy/charged/spartanlaser/verb/scope()
	set category = "Weapon"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(usr, 1.25)
