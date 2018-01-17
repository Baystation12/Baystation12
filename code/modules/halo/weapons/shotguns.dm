
//M90 shotgun
//nothing special here, basically just a resprite
/obj/item/weapon/gun/projectile/shotgun/pump/m90_ts
	var/unique_name
	var/static/list/gun_options
	name = "M90 tactical shotgun"
	desc = "The UNSC's primary shotgun and one of the most effective close range infantry weapons used by front line forces."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "M45 TS"		//pretend it's the M90
	item_state = "m90"
	fire_sound = 'code/modules/halo/sounds/Shotgun_Shot_Sound_Effect.ogg'
	reload_sound = 'code/modules/halo/sounds/Shotgun_Pump_Slide.ogg'
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	max_shells = 6
	one_hand_penalty = -1

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)

/obj/item/weapon/gun/projectile/shotgun/pump/m90_ts/verb/rename_gun()
	set name = "Name Gun"
	set category = "Object"
	set desc = "Rename your gun."

	var/mob/M = usr
	if(!M.mind)	return 0
	if(M.incapacitated()) return 0

	var/input = sanitizeSafe(input("What do you want to name the gun?","Rename gun"), MAX_NAME_LEN)

	if(src && input && !M.incapacitated() && in_range(M,src))
		if(!findtext(input, "the", 1, 4))
			input = "\improper [input]"
		name = input
		unique_name = input
		to_chat(M, "Your gun is now named '[input]'.")
		return 1

