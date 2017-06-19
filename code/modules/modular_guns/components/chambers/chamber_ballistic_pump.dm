/obj/item/gun_component/chamber/ballistic/pump
	icon_state="shotgun"
	name = "pump-action loader"
	weapon_type = GUN_SHOTGUN
	max_shots = 4
	load_method = SINGLE_CASING
	handle_casings = HOLD_CASINGS
	has_user_interaction = 1

/obj/item/gun_component/chamber/ballistic/pump/consume_next_projectile()
	if(chambered)
		return chambered.projectile
	return null

/obj/item/gun_component/chamber/ballistic/pump/do_user_interaction(var/mob/user)
	playsound(user, 'sound/weapons/shotgunpump.ogg', 60, 1)

	var/result
	if(chambered)//We have a shell in the chamber
		chambered.forceMove(get_turf(src))
		chambered = null
		result = 1
	if(loaded.len)
		var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
		loaded -= AC //Remove casing from loaded list.
		chambered = AC
		result = 1
	if(result)
		user << "<span class='notice'>You pump \the [holder].</span>"
	else
		user << "<span class='warning'>You pump \the [holder] and it clicks empty!</span>"

	update_ammo_overlay()
	return 1

/obj/item/gun_component/chamber/ballistic/pump/combat
	icon_state = "shotgun_combat"
	max_shots = 6
