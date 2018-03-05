


//M739 Light Machine Gun

/obj/item/weapon/gun/projectile/m739_lmg
	name = "\improper M739 Light Machine Gun"
	desc = "Standard-issue squad automatic weapon, designed for use in heavy engagements. Takes 7.62mm calibre ordinary and box type magazines."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "M739"
	item_state = "SAW"
	caliber = "a762"
	slot_flags = 0	//too unwieldy to carry on your back
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a762_box_ap
	allowed_magazines = list(/obj/item/ammo_magazine/a762_box_ap) //Disallows loading normal ma5b mags into the LMG.
	//fire_sound = 'code/modules/halo/sounds/MagnumShotSoundEffect.ogg'			//no halo firing sfx for this one yet
	reload_sound = 'code/modules/halo/sounds/UNSC_Saw_Reload_Sound_Effect.ogg'
	one_hand_penalty = -1
	burst = 5
	burst_delay = 3
	w_class = ITEM_SIZE_HUGE
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)

	firemodes = list(
		list(mode_name="short bursts",	burst=5, move_delay=6, burst_accuracy = list(0,-1,-1,-2,-2),          dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(mode_name="long bursts",	burst=8, move_delay=8, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/weapon/gun/projectile/m739_lmg/update_icon()
	if(ammo_magazine)
		icon_state = "M739"
	else
		icon_state = "M739_unloaded"
