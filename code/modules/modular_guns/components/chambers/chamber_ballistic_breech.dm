/obj/item/gun_component/chamber/ballistic/breech
	icon_state="rifle"
	name = "breech loader"
	weapon_type = GUN_RIFLE
	max_shots = 1
	load_method = SINGLE_CASING|SPEEDLOADER
	handle_casings = EJECT_CASINGS
	has_user_interaction = 1
	accuracy_mod = 1
	var/breech_open

/obj/item/gun_component/chamber/ballistic/breech/get_extra_examine_info()
	return "The breech is [breech_open ? "open" : "closed"]."

/obj/item/gun_component/chamber/ballistic/breech/am
	icon_state="sniper"
	accuracy_mod = 2

/obj/item/gun_component/chamber/ballistic/breech/consume_next_projectile()
	if(breech_open)
		if(holder)
			var/mob/M = holder.loc
			if(istype(M))
				M << "<span class='warning'>The breech is open.</span>"
		return 0
	return ..()

/obj/item/gun_component/chamber/ballistic/breech/can_load(var/mob/user)
	if(!breech_open)
		user << "<span class='warning'>The breech is closed.</span>"
		return 0
	return 1

/obj/item/gun_component/chamber/ballistic/breech/can_unload(var/mob/user)
	if(!breech_open)
		user << "<span class='warning'>The breech is closed.</span>"
		return 0
	return 1

/obj/item/gun_component/chamber/ballistic/breech/do_user_interaction(var/mob/user)
	playsound(user, 'sound/weapons/empty.ogg', 50, 1)
	breech_open = !breech_open
	user << "<span class='notice'>You [breech_open ? "work open" : "snap shut"] \the [holder].</span>"

/obj/item/gun_component/chamber/ballistic/breech/shotgun
	icon_state="shotgun_hunting"
	weapon_type = GUN_SHOTGUN
	max_shots = 1
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING