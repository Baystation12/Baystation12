/obj/item/ammo_casing
	name = "bullet casing"
	desc = "A bullet casing."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "s-casing"
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 1
	w_class = 1.0
	var/caliber = ""							//Which kind of guns it can be loaded into
	var/projectile_type = ""//The bullet type to create when New() is called
	var/obj/item/projectile/BB = null 			//The loaded bullet


	New()
		..()
		if(projectile_type)
			BB = new projectile_type(src)
		pixel_x = rand(-10.0, 10)
		pixel_y = rand(-10.0, 10)
		dir = pick(cardinal)


/obj/item/ammo_casing/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/screwdriver))
		if(BB)
			if(initial(BB.name) == "bullet")
				var/tmp_label = ""
				var/label_text = sanitize(input(user, "Inscribe some text into \the [initial(BB.name)]","Inscription",tmp_label))
				if(length(label_text) > 20)
					user << "\red The inscription can be at most 20 characters long."
				else
					if(label_text == "")
						user << "\blue You scratch the inscription off of [initial(BB)]."
						BB.name = initial(BB.name)
					else
						user << "\blue You inscribe \"[label_text]\" into \the [initial(BB.name)]."
						BB.name = "[initial(BB.name)] \"[label_text]\""
			else
				user << "\blue You can only inscribe a metal bullet."	//because inscribing beanbags is silly
		else
			user << "\blue There is no bullet in the casing to inscribe anything into."


//Boxes of ammo
/obj/item/ammo_magazine
	name = "ammo box (.357)"
	desc = "A box of ammo"
	icon_state = "357"
	icon = 'icons/obj/ammo.dmi'
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT
	item_state = "syringe_kit"
	matter = list("metal" = 50000)
	throwforce = 2
	w_class = 2.0
	throw_speed = 4
	throw_range = 10
	var/list/stored_ammo = list()
	var/ammo_type = "/obj/item/ammo_casing"
	var/max_ammo = 7
	var/multiple_sprites = 0


	New()
		for(var/i = 1, i <= max_ammo, i++)
			stored_ammo += new ammo_type(src)
		update_icon()


	update_icon()
		if(multiple_sprites)
			icon_state = "[initial(icon_state)]-[stored_ammo.len]"
		desc = "There are [stored_ammo.len] shell\s left!"
