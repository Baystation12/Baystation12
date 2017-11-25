
//M90 shotgun
//nothing special here, basically just a resprite
/obj/item/weapon/gun/projectile/shotgun/pump/m90_ts
	name = "M90 tactical shotgun"
	desc = "The UNSC's primary shotgun and one of the most effective close range infantry weapons used by front line forces."
	icon = 'code/modules/halo/icons/Weapon Sprites.dmi'
	icon_state = "M45 TS"		//pretend it's the M90
	item_state = "m90"
	fire_sound = 'code/modules/halo/sounds/Shotgun_Shot_Sound_Effect.ogg'
	reload_sound = 'code/modules/halo/sounds/Shotgun_Pump_Slide.ogg'
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	max_shells = 6

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/icons/Weapon_Inhands_right.dmi',
		)
