/obj/item/ammo_casing
	name = "bullet casing"
	desc = "A bullet casing."
	icon = 'ammo.dmi'
	icon_state = "s-casing"
	flags = FPRINT | TABLEPASS | CONDUCT | ONBELT
	throwforce = 1
	w_class = 1.0
	var
		caliber = ""							//Which kind of guns it can be loaded into
		projectile_type = ""//The bullet type to create when New() is called
		obj/item/projectile/BB = null 			//The loaded bullet


	New()
		..()
		if(projectile_type)
			BB = new projectile_type(src)
		pixel_x = rand(-10.0, 10)
		pixel_y = rand(-10.0, 10)
		dir = pick(cardinal)



//Boxes of ammo
/obj/item/ammo_magazine
	name = "ammo box (.357)"
	desc = "A box of ammo"
	icon_state = "357"
	icon = 'ammo.dmi'
	flags = FPRINT | TABLEPASS | CONDUCT | ONBELT
	item_state = "syringe_kit"
	m_amt = 50000
	throwforce = 2
	w_class = 1.0
	throw_speed = 4
	throw_range = 10
	var
		list/stored_ammo = list()
		ammo_type = "/obj/item/ammo_casing"
		max_ammo = 7
		multiple_sprites = 0


	New()
		for(var/i = 1, i <= max_ammo, i++)
			stored_ammo += new ammo_type(src)
		update_icon()


	update_icon()
		if(multiple_sprites)
			icon_state = text("[initial(icon_state)]-[]", stored_ammo.len)
		desc = text("There are [] shell\s left!", stored_ammo.len)
