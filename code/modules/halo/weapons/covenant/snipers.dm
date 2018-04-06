
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
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)

/obj/item/weapon/gun/projectile/type51carbine/verb/scope()
	set category = "Weapon"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(usr, 1.25)

/obj/item/weapon/gun/projectile/type51carbine/load_ammo(var/item/I,var/mob/user)
	unload_ammo(user,1)
	. = ..()

/obj/item/weapon/gun/projectile/type51carbine/unload_ammo(var/mob/user,var/allow_dump = 0)
	if(ammo_magazine)
		to_chat(user,"<span class = 'notice'>The automatic reload mechanism of [src.name] is locked, use a magazine on it to attempt a reload.</span>")
	if(allow_dump)
		. = ..()

/obj/item/weapon/gun/energy/beam_rifle
	name = "Type-27 Special Application Sniper Rifle"
	desc = "Fires a short-lived but powerful lance of plasma, repeated quick firing will overheat the weapon and leave it unsuable for a short while."
	icon = 'code/modules/halo/icons/Covenant Weapons.dmi'
	icon_state = "beam rifle"
	item_state = "beam rifle"
	slot_flags = SLOT_BACK | SLOT_BELT
	fire_sound = 'code/modules/halo/sounds/beam_rifle_fire.ogg'
	charge_meter = 0
	self_recharge = 1
	max_shots = 5
	recharge_time = 2 SECONDS
	projectile_type = /obj/item/projectile/covenant/beamrifle

	var/next_allowed_fire

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)

/obj/item/weapon/gun/energy/beam_rifle/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(usr, 1.5)

/obj/item/weapon/gun/energy/beam_rifle/proc/update_next_allowed_fire(var/seconds_increase = 1)
	next_allowed_fire = world.time + seconds_increase SECONDS

/obj/item/weapon/gun/energy/beam_rifle/Fire(atom/target,var/mob/living/user)
	if(world.time < next_allowed_fire)
		update_next_allowed_fire(3)
		playsound(user,'code/modules/halo/sounds/beam_rifle_overheat.ogg',100,1)
		to_chat(user,"<span class = 'warning'>[src.name]'s automatic cooling system activates, halting the firing process!</span>")
	else
		update_next_allowed_fire()
		. = ..()
