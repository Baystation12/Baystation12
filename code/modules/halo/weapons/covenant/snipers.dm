
/obj/item/weapon/gun/projectile/type51carbine
	name = "Type-51 Carbine"
	desc = "One of the few covenant weapons that utilise magazines."
	icon = 'code/modules/halo/weapons/icons/Covenant Weapons.dmi'
	icon_state = "type51"
	item_state = "carbine"
	w_class = ITEM_SIZE_LARGE
	slot_flags = SLOT_BACK
	fire_sound = 'code/modules/halo/sounds/cov_carbine_fire.ogg'
	magazine_type = /obj/item/ammo_magazine/type51mag
	handle_casings = CLEAR_CASINGS
	caliber = "cov_carbine"
	load_method = MAGAZINE
	reload_sound = 'code/modules/halo/sounds/cov_carbine_reload.ogg'
	fire_delay = 3 //Doesn't have the 3rnd burst of the counterpart BR
	dispersion = list(0.26)
	one_hand_penalty = -1
	irradiate_non_cov = 8
	scope_zoom_amount = 2
	accuracy = 1
	wielded_item_state = "carbine-wielded"
	advanced_covenant = 1
	speed_reload_time = -1 //already auto-ejects
	matter = list("nanolaminate" = 1)
	hud_bullet_row_num = 9
	hud_bullet_reffile = 'code/modules/halo/icons/hud_display/hud_bullet_7x8.dmi'
	hud_bullet_iconstate = "carbineround"

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		slot_back_str = 'code/modules/halo/weapons/icons/Back_Weapons.dmi',
		slot_s_store_str = 'code/modules/halo/weapons/icons/Armor_Weapons.dmi',
		)
	crosshair_file = 'code/modules/halo/weapons/icons/dragaim_icon.dmi'

/obj/item/weapon/gun/projectile/type51carbine/can_use_when_prone()
	return 1

/obj/item/weapon/gun/projectile/type51carbine/verb/scope()
	set category = "Weapon"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(usr, scope_zoom_amount)

/obj/item/weapon/gun/projectile/type51carbine/load_ammo(var/item/I,var/mob/user)
	unload_ammo(user,1)
	. = ..()

/obj/item/weapon/gun/projectile/type51carbine/unload_ammo(var/mob/user,var/allow_dump = 0)
	if(ammo_magazine)
		to_chat(user,"<span class = 'notice'>The automatic reload mechanism of [src.name] is locked, use a magazine on it to attempt a reload.</span>")
	if(allow_dump)
		. = ..()

/obj/item/weapon/gun/projectile/type51carbine/update_icon()
	if(ammo_magazine)
		icon_state = "type51"
	else
		icon_state = "type51_unloaded"
	. = ..()

/obj/item/weapon/gun/energy/beam_rifle
	name = "Type-27 Special Application Sniper Rifle"
	desc = "Fires a short-lived but powerful lance of plasma, repeated quick firing will overheat the weapon and leave it unsuable for a short while."
	icon = 'code/modules/halo/weapons/icons/Covenant Weapons.dmi'
	icon_state = "beam rifle"
	item_state = "beamrifle"
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	fire_sound = 'code/modules/halo/sounds/beam_rifle_fire.ogg'
	charge_meter = 0
	max_shots = 24
	projectile_type = /obj/item/projectile/bullet/covenant/beamrifle
	one_hand_penalty = -1
	irradiate_non_cov = 12
	wielded_item_state = "beamrifle-wielded"
	fire_delay = 10
	accuracy = -12 //Honestly stop hipfiring snipers damn it
	dispersion = list(0)
	scope_zoom_amount = 8
	min_zoom_amount = 3
	is_scope_variable = 1
	scoped_accuracy = 7
	advanced_covenant = 1
	overheat_sfx = 'code/modules/halo/sounds/beam_rifle_overheat.ogg'
	overheat_capacity = 4 //SRS mag equiv, but overheats on 4th click
	overheat_fullclear_delay = 2 SECONDS
	hud_bullet_usebar = 1

	alt_charge_method = 1
	matter = list("nanolaminate" = 2)
	salvage_components = list(/obj/item/plasma_core)

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		slot_back_str = 'code/modules/halo/weapons/icons/Back_Weapons.dmi',
		slot_s_store_str = 'code/modules/halo/weapons/icons/Armor_Weapons.dmi',
		)
	crosshair_file = 'code/modules/halo/weapons/icons/dragaim_icon.dmi'

/obj/item/weapon/gun/energy/beam_rifle/can_use_when_prone()
	return 1

/obj/item/weapon/gun/energy/beam_rifle/verb/scope()
	set category = "Weapon"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(usr, scope_zoom_amount)

/obj/item/weapon/gun/energy/beam_rifle/proc/cov_plasma_recharge_tick()
	if(max_shots > 0)
		if(power_supply.charge < power_supply.maxcharge)
			power_supply.give(charge_cost)
			update_icon()
			return 1

/obj/item/weapon/gun/projectile/type31needlerifle
	name = "Type-31 Needle Rifle"
	desc = "A unique combination of the Type-33 and Type-51."
	icon = 'code/modules/halo/weapons/icons/Covenant Weapons.dmi'
	icon_state = "Needle rifle"
	item_state = "needlerifle"
	w_class = ITEM_SIZE_LARGE
	slot_flags = SLOT_BACK
	fire_sound = 'code/modules/halo/sounds/cov_needlerifle_fire.ogg'
	magazine_type = /obj/item/ammo_magazine/rifleneedlepack
	handle_casings = CLEAR_CASINGS
	caliber = "needle_rifle"
	load_method = MAGAZINE
	reload_sound = 'code/modules/halo/sounds/cov_needlerifle_reload.ogg'
	one_hand_penalty = -1
	dispersion = list(0)
	scope_zoom_amount = 3
	is_scope_variable = 1
	hud_bullet_row_num = 7
	hud_bullet_reffile = 'code/modules/halo/icons/hud_display/hud_bullet_7x8.dmi'
	hud_bullet_iconstate = "bigneedle"
	accuracy = -1
	scoped_accuracy = 2
	wielded_item_state = "needlerifle-wielded"
	matter = list("nanolaminate" = 1)

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		slot_back_str = 'code/modules/halo/weapons/icons/Back_Weapons.dmi',
		slot_s_store_str = 'code/modules/halo/weapons/icons/Armor_Weapons.dmi',
		)
	crosshair_file = 'code/modules/halo/weapons/icons/dragaim_icon.dmi'

/obj/item/weapon/gun/projectile/type31needlerifle/can_use_when_prone()
	return 1

/obj/item/weapon/gun/projectile/type31needlerifle/verb/scope()
	set category = "Weapon"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(usr, scope_zoom_amount)