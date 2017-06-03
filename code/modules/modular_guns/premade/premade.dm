/obj/item/weapon/gun/composite/premade
	icon = 'icons/obj/gun.dmi'
	var/set_model
	var/variant_chamber = /obj/item/gun_component/chamber
	var/variant_body =    /obj/item/gun_component/body
	var/variant_barrel =  /obj/item/gun_component/barrel
	var/variant_stock =   /obj/item/gun_component/stock
	var/variant_grip =    /obj/item/gun_component/grip
	var/ammo_type // Set to autoload the gun at spawn.

/obj/item/weapon/gun/composite/premade/New()
	//icon_state = "" // READD AFTER FIXING GUN ICONS IN 510.

	// Mandatory parts.
	barrel =  new variant_barrel  (src, use_model = set_model)
	body =    new variant_body    (src, use_model = set_model)
	chamber = new variant_chamber (src, use_model = set_model)
	grip =    new variant_grip    (src, use_model = set_model)

	// Optional parts.
	if(variant_stock) stock = new variant_stock (src, use_model = set_model)

	// Accessories.
	accessories.Cut()
	for(var/obj/item/gun_component/accessory/acc in contents)
		accessories += acc
	update_from_components()

	..()

	if(ammo_type) // Assumes that it's a ballistic weapon. Don't specify ammo_type for lasers.
		var/obj/item/gun_component/chamber/ballistic/B = chamber
		new ammo_type (B)
		if(B.load_method != MAGAZINE)
			for(var/i in 2 to max_shots)
				new ammo_type (B)
		spawn(0)
			if(B)
				B.update_ammo_from_contents()
