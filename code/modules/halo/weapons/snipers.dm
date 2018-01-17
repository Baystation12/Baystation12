


//SRS99 sniper rifle
//basically just a resprite
/obj/item/weapon/gun/projectile/srs99_sniper
	var/unique_name
	var/static/list/gun_options
	name = "SRS99 sniper rifle"
	desc = "Special Applications Rifle, system 99 Anti-Matériel. Deadly at extreme range.  Takes 14.5mm calibre magazines."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "SRS99"
	item_state = "SRS99"
	load_method = MAGAZINE
	caliber = "14.5mm"
	slot_flags = SLOT_BACK
	magazine_type = /obj/item/ammo_magazine/m145_ap
	fire_sound = 'code/modules/halo/sounds/SniperShotSoundEffect.ogg'
	reload_sound = 'code/modules/halo/sounds/SniperRifleReloadSoundEffect.ogg'
	one_hand_penalty = -1
	scoped_accuracy = 3
	screen_shake = 0

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)

/obj/item/weapon/gun/projectile/srs99_sniper/verb/scope()
	set category = "Object"
	set name = "Use Scope (2x)"
	set popup_menu = 1

	toggle_scope(usr, 2.0)

/obj/item/weapon/gun/projectile/srs99_sniper/update_icon()
	if(ammo_magazine)
		icon_state = "SRS99"
	else
		icon_state = "SRS99_unloaded"

/obj/item/weapon/gun/projectile/srs99_sniper/verb/rename_gun()
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


//M392 designated marksman rifle
//todo: should this be a sniper?
/obj/item/weapon/gun/projectile/m392_dmr
	var/unique_name
	var/static/list/gun_options
	name = "M392 Designated Marksman Rifle"
	desc = "This rifle favors mid- to long-ranged combat, offering impressive stopping power over a long distance.  Takes 7.62mm calibre magazines."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "M395"
	item_state = "m392"
	load_method = MAGAZINE
	caliber = "a762"
	slot_flags = SLOT_BACK
	magazine_type = /obj/item/ammo_magazine/m762_ap
	allowed_magazines = list(/obj/item/ammo_magazine/m762_ap) //Disallows loading LMG boxmags into the DMR.
	fire_sound = 'code/modules/halo/sounds/DMR_ShotSoundEffect.ogg'
	reload_sound = 'code/modules/halo/sounds/DMR_Reload_Sound_Effect.ogg'
	one_hand_penalty = -1

	accuracy = 1
	scoped_accuracy = 2

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)

/obj/item/weapon/gun/projectile/m392_dmr/verb/scope()
	set category = "Object"
	set name = "Use Scope (1.25x)"
	set popup_menu = 1

	toggle_scope(usr, 1.25)

/obj/item/weapon/gun/projectile/m392_dmr/update_icon()
	if(ammo_magazine)
		icon_state = "M395"
	else
		icon_state = "M395_unloaded"

/obj/item/weapon/gun/projectile/m392_dmr/verb/rename_gun()
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
