


//MA5B assault rifle

/obj/item/weapon/gun/projectile/ma5b_ar
	var/unique_name
	var/static/list/gun_options
	name = "\improper MA5B Assault Rifle"
	desc = "Standard-issue service rifle of the UNSC Marines. Takes 7.62mm calibre magazines."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "MA5B"
	item_state = "ma5b"
	caliber = "a762"
	slot_flags = SLOT_BACK
	fire_sound = 'code/modules/halo/sounds/Assault_Rifle_Short_Burst_Sound_Effect.ogg'
	//fire_sound_burst = 'code/modules/halo/sounds/Assault_Rifle_Short_Burst_Sound_Effect.ogg'
	reload_sound = 'code/modules/halo/sounds/AssaultRifle&BattleRifle_ReloadSound_Effect.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m762_ap/MA5B
	allowed_magazines = list(/obj/item/ammo_magazine/m762_ap) //Disallows loading LMG boxmags into the MA5B
	burst = 3
	burst_delay = 2
	one_hand_penalty = -1

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)

	firemodes = list(
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=6,    burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 0.6)),
		list(mode_name="short bursts", 	burst=5, fire_delay=null, move_delay=6,    burst_accuracy=list(-1,-1,-2,-2,-3), dispersion=list(0.6, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/weapon/gun/projectile/ma5b_ar/update_icon()
	if(ammo_magazine)
		icon_state = "MA5B"
	else
		icon_state = "MA5B_unloaded"

/obj/item/weapon/gun/projectile/ma5b_ar/MA37
	name = "\improper MA37 ICWS"
	desc = "Also formally known as the MA5."
	icon_state = "MA37"
	magazine_type = /obj/item/ammo_magazine/m762_ap/MA37

/obj/item/weapon/gun/projectile/ma5b_ar/MA37/update_icon()
	if(ammo_magazine)
		icon_state = "MA37"
	else
		icon_state = "MA37_unloaded"


/obj/item/weapon/gun/projectile/ma5b_ar/verb/rename_gun()
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

//BR85 battle

/obj/item/weapon/gun/projectile/br85
	var/unique_name
	var/static/list/gun_options
	name = "\improper BR85 Battle Rifle"
	desc = "When nothing else gets the job done, the BR85 Battle Rifle will do. Takes 9.5mm calibre magazines."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "Br85"
	item_state = "br85"
	caliber = "9.5mm"
	slot_flags = SLOT_BACK
	fire_sound = 'code/modules/halo/sounds/BattleRifleShotSoundEffect.ogg'
	reload_sound = 'code/modules/halo/sounds/AssaultRifle&BattleRifle_ReloadSound_Effect.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m95_sap
	one_hand_penalty = -1
	burst = 3
	burst_delay = 1
	accuracy = 1

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)

/obj/item/weapon/gun/projectile/br85/verb/scope()
	set category = "Object"
	set name = "Use Scope (1.15x)"
	set popup_menu = 1

	toggle_scope(usr, 1.15)

/obj/item/weapon/gun/projectile/br85/update_icon()
	if(ammo_magazine)
		icon_state = "Br85"
	else
		icon_state = "Br85_unloaded"

/obj/item/weapon/gun/projectile/br85/verb/rename_gun()
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
