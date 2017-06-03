//An item that holds casings and can be used to put them inside guns
/obj/item/ammo_magazine
	name = "magazine"
	desc = "A magazine for some kind of gun."
	icon_state = "pistol_mag"
	icon = 'icons/obj/gun_components/ammo.dmi'
	slot_flags = SLOT_BELT
	item_state = "syringe_kit"
	matter = list(DEFAULT_WALL_MATERIAL = 500)
	throwforce = 5
	w_class = 2
	throw_speed = 4
	throw_range = 10

	var/list/stored_ammo = list()
	var/caliber = CALIBER_357
	var/max_ammo = 7
	var/ammo_type = /obj/item/ammo_casing //ammo type that is initially loaded
	var/initial_ammo = null
	var/mag_type = MAGAZINE

	var/multiple_sprites // temp for compilation

/obj/item/ammo_magazine/New()
	..()
	if(isnull(initial_ammo))
		initial_ammo = max_ammo
	if(initial_ammo)
		caliber = null
		for(var/i = 1 to initial_ammo)
			if(!caliber)
				var/obj/item/ammo_casing/AC = new ammo_type(src)
				caliber = AC.caliber
				stored_ammo += AC
			else
				stored_ammo += new ammo_type(src)
	name = "[initial(name)] ([caliber])"
	update_icon()

/obj/item/ammo_magazine/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/C = W
		if(C.caliber != caliber)
			user << "<span class='warning'>[C] does not fit into [src].</span>"
			return
		if(stored_ammo.len >= max_ammo)
			user << "<span class='warning'>[src] is full!</span>"
			return
		user.unEquip(C)
		C.forceMove(src)
		stored_ammo.Insert(1, C) //add to the head of the list
		update_icon()

/obj/item/ammo_magazine/attack_self(mob/user)
	if(!stored_ammo.len)
		user << "<span class='notice'>[src] is already empty!</span>"
		return
	user << "<span class='notice'>You empty [src].</span>"
	for(var/obj/item/ammo_casing/C in stored_ammo)
		C.forceMove(user.loc)
		C.set_dir(pick(cardinal))
	stored_ammo.Cut()
	update_icon()

/obj/item/ammo_magazine/examine(mob/user)
	..()
	user << "<span class='notice'>There [(stored_ammo.len == 1)? "is" : "are"] [stored_ammo.len] round\s left.</span>"

// Predefined
/obj/item/ammo_magazine/assault
	name = "assault rifle magazine"
	icon_state = "assault_mag"
	ammo_type = /obj/item/ammo_casing/rifle_small
	max_ammo = 30
/obj/item/ammo_magazine/assault/large
	ammo_type = /obj/item/ammo_casing/rifle_large

/obj/item/ammo_magazine/pistol
	name = "pistol magazine"
	ammo_type = /obj/item/ammo_casing/pistol_small
/obj/item/ammo_magazine/pistol/medium
	ammo_type = /obj/item/ammo_casing/pistol_medium
/obj/item/ammo_magazine/pistol/large
	ammo_type = /obj/item/ammo_casing/pistol_large
/obj/item/ammo_magazine/pistol/a38
	ammo_type = /obj/item/ammo_casing/a38
/obj/item/ammo_magazine/pistol/a45
	ammo_type = /obj/item/ammo_casing/a45

/obj/item/ammo_magazine/submachine
	name = "submachine gun magazine"
	icon_state = "submachine_mag"
	ammo_type = /obj/item/ammo_casing/pistol_small
	max_ammo = 30
	color = COLOR_GUNMETAL

/obj/item/ammo_magazine/submachine/medium
	ammo_type = /obj/item/ammo_casing/pistol_medium
/obj/item/ammo_magazine/submachine/large
	ammo_type = /obj/item/ammo_casing/pistol_large
/obj/item/ammo_magazine/submachine/a38
	ammo_type = /obj/item/ammo_casing/a38
/obj/item/ammo_magazine/submachine/a45
	ammo_type = /obj/item/ammo_casing/a45

/obj/item/ammo_magazine/autocannon
	name = "ammunition belt"
	icon_state = "cannon_belt"
	ammo_type = /obj/item/ammo_casing/gyrojet
