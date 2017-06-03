/obj/item/gun_component/chamber/ballistic/breech/revolver
	icon_state="revolver"
	name = "revolver cylinder"
	weapon_type = GUN_PISTOL
	handle_casings = CYCLE_CASINGS
	load_method = SINGLE_CASING|SPEEDLOADER
	max_shots = 6
	has_alt_interaction = 1
	revolver = 1
	accuracy_mod = 0
	color = COLOR_GUNMETAL
	var/chamber_offset = 0

/obj/item/gun_component/chamber/ballistic/breech/revolver/consume_next_projectile()
	if(chamber_offset)
		chamber_offset--
		return
	return ..()

/obj/item/gun_component/chamber/ballistic/breech/revolver/load_ammo(var/obj/item/A, var/mob/user)
	chamber_offset = 0
	return ..(A, user)

/obj/item/gun_component/chamber/ballistic/breech/revolver/unload_ammo(var/mob/user)
	chamber_offset = 0
	return ..(user)

/obj/item/gun_component/chamber/ballistic/breech/revolver/do_user_alt_interaction(var/mob/user)
	if(!breech_open)
		chamber_offset = 0
		visible_message("<span class='warning'>\The [user] spins the cylinder of \the [holder]!</span>")
		playsound(src.loc, 'sound/weapons/revolver_spin.ogg', 100, 1)
		loaded = shuffle(loaded)
		if(rand(1,max_shots) > loaded.len)
			chamber_offset = rand(0,max_shots-loaded.len)
		return 1
	else
		visible_message("<span class='notice'>\The [user] unloads the cylinder of \the [holder].</span>")
		for(var/obj/item/ammo_casing/C in loaded)
			C.forceMove(get_turf(src))
		loaded.Cut()
		return 1

/obj/item/gun_component/chamber/ballistic/breech/revolver/get_examine_text()
	. += "When cylinder is closed, you can spin it with alt-clicking the gun in hand to play Russian Roulette.<br>"
	. += "When cylinder is open, you can empty all casings out of it with alt-click.<br>"
