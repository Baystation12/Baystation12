
//M90 shotgun
//nothing special here, basically just a resprite
/obj/item/weapon/gun/projectile/shotgun/pump/m90_ts
	name = "M90 tactical shotgun"
	desc = "The UNSC's primary shotgun and one of the most effective close range infantry weapons used by front line forces. Has an inbuilt side mounted flashlight."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "M45 TS"		//pretend it's the M90
	item_state = "m90"
	fire_sound = 'code/modules/halo/sounds/Shotgun_Shot_Sound_Effect.ogg'
	reload_sound = 'code/modules/halo/sounds/Shotgun_Pump_Slide.ogg'
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	max_shells = 8
	one_hand_penalty = -1
	var/on = 0
	var/activation_sound = 'sound/effects/flashlight.ogg'
	w_class = ITEM_SIZE_LARGE
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)


/obj/item/weapon/gun/projectile/shotgun/pump/m90_ts/police
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag

/obj/item/weapon/gun/projectile/shotgun/pump/m90_ts/verb/toggle_light()
	set category = "Object"
	set name = "Toggle Gun Light"
	on = !on
	if(on && activation_sound)
		playsound(src.loc, activation_sound, 75, 1)
		set_light(4)
	else
		set_light(0)