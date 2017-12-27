
/obj/item/weapon/gun/projectile/type51carbine
	name = "Type-51 Carbine"
	desc = "One of the few covenant weapons that utilise magazines."
	icon = 'code/modules/halo/icons/Covenant Weapons.dmi'
	icon_state = "type 51"
	item_state = "type 51"
	slot_flags = SLOT_BACK
	fire_sound = 'code/modules/halo/sounds/cov_carbine_fire.ogg'
	magazine_type = /obj/item/ammo_magazine/type51mag
	handle_casings = CLEAR_CASINGS
	caliber = "cov_carbine"
	load_method = MAGAZINE
	reload_sound = 'code/modules/halo/sounds/cov_carbine_reload.ogg'
	one_hand_penalty = -1

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/icons/Weapon_Inhands_right.dmi',
		)

/obj/item/weapon/gun/projectile/type51carbine/load_ammo(var/item/I,var/mob/user)
	unload_ammo(user,1)
	. = ..()

/obj/item/weapon/gun/projectile/type51carbine/unload_ammo(var/mob/user,var/allow_dump = 0)
	if(ammo_magazine)
		to_chat(user,"<span class = 'notice'>The automatic reload mechanism of [src.name] is locked, use a magazine on it to attempt a reload.</span>")
	if(allow_dump)
		. = ..()