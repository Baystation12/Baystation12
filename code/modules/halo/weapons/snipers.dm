


//SRS99 sniper rifle
//basically just a resprite
/obj/item/weapon/gun/projectile/srs99_sniper
	name = "SRS99 sniper rifle"
	desc = "Special Applications Rifle, system 99 Anti-Matériel. Deadly at extreme range.  Takes 14.5mm calibre magazines."
	icon = 'code/modules/halo/icons/Weapon Sprites.dmi'
	icon_state = "SRS99"
	item_state = "heavysniper"
	load_method = MAGAZINE
	caliber = "14.5mm"
	slot_flags = SLOT_BACK
	magazine_type = /obj/item/ammo_magazine/m145_ap
	fire_sound = 'code/modules/halo/sounds/SniperShotSoundEffect.ogg'
	reload_sound = 'code/modules/halo/sounds/SniperRifleReloadSoundEffect.ogg'
	scoped_accuracy = 3
	screen_shake = 0

/obj/item/weapon/gun/projectile/srs99_sniper/verb/scope()
	set category = "Object"
	set name = "Use Scope (2x)"
	set popup_menu = 1

	toggle_scope(2.0)

/obj/item/weapon/gun/projectile/srs99_sniper/update_icon()
	if(ammo_magazine)
		icon_state = "SRS99"
	else
		icon_state = "SRS99_unloaded"



//M392 designated marksman rifle
//todo: should this be a sniper?
/obj/item/weapon/gun/projectile/m392_dmr
	name = "M392 Designated Marksman Rifle"
	desc = "This rifle favors mid- to long-ranged combat, offering impressive stopping power over a long distance.  Takes 7.62mm calibre magazines."
	icon = 'code/modules/halo/icons/Weapon Sprites.dmi'
	icon_state = "M395"
	item_state = "halo_dmr"
	load_method = MAGAZINE
	caliber = "a762"
	slot_flags = SLOT_BACK
	magazine_type = /obj/item/ammo_magazine/m762_ap
	fire_sound = 'code/modules/halo/sounds/DMR_ShotSoundEffect.ogg'
	reload_sound = 'code/modules/halo/sounds/DMR_Reload_Sound_Effect.ogg'

	accuracy = 1
	scoped_accuracy = 2

/obj/item/weapon/gun/projectile/m392_dmr/verb/scope()
	set category = "Object"
	set name = "Use Scope (1.25x)"
	set popup_menu = 1

	toggle_scope(1.25)

/obj/item/weapon/gun/projectile/m392_dmr/update_icon()
	if(ammo_magazine)
		icon_state = "M395"
	else
		icon_state = "M395_unloaded"
