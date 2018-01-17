


//Magnum M6D pistol

/obj/item/weapon/gun/projectile/m6d_magnum
	var/unique_name
	var/static/list/gun_options
	name = "\improper M6D Magnum"
	desc = "A common UNSC sidearm and one of the variants of Misriah Armory's M6 handgun series. Takes 12.7mm calibre magazines."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "magnum"
	item_state = "halo_pistol"
	magazine_type = /obj/item/ammo_magazine/m127_saphe
	caliber = "12.7mm"
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	fire_sound = 'code/modules/halo/sounds/MagnumShotSoundEffect.ogg'
	reload_sound = 'code/modules/halo/sounds/MagnumReloadSoundEffect.ogg'
	load_method = MAGAZINE

/obj/item/weapon/gun/projectile/m6d_magnum/update_icon()
	if(ammo_magazine)
		icon_state = "magnum"
	else
		icon_state = "magnum_unloaded"

/obj/item/weapon/gun/projectile/m6d_magnum/verb/rename_gun()
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


//Magnum M6S silenced pistol

/obj/item/weapon/gun/projectile/m6c_magnum_s
	var/unique_name
	var/static/list/gun_options
	name = "\improper M6S silenced magnum"
	desc = "The M6C/SOCOM is a special operations variant of the popular M6C but with a whole host of inbuilt attachments. Takes 12.7mm calibre magazines."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "SOCOM"
	item_state = "halo_spistol"
	magazine_type = /obj/item/ammo_magazine/m127_saphp
	caliber = "12.7mm"
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	reload_sound = 'code/modules/halo/sounds/MagnumReloadSoundEffect.ogg'
	load_method = MAGAZINE
	fire_delay = 3
	silenced = 1
	screen_shake = 0

/obj/item/weapon/gun/projectile/m6c_magnum_s/update_icon()
	if(ammo_magazine)
		icon_state = "SOCOM"
	else
		icon_state = "SOCOM_unloaded"

/obj/item/weapon/gun/projectile/m6c_magnum_s/verb/rename_gun()
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

