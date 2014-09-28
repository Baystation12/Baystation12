/* Table parts and rack parts
 * Contains:
 *		Table Parts
 *		Reinforced Table Parts
 *		Wooden Table Parts
 *		Rack Parts
 */



/*
 * Table Parts
 */
/obj/item/weapon/table_parts/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/weapon/wrench))
		new /obj/item/stack/sheet/metal( user.loc )
		//SN src = null
		del(src)
	if (istype(W, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = W
		if (R.use(4))
			new /obj/item/weapon/table_parts/reinforced(get_turf(loc))
			user << "<span class='notice'>You reinforce the [name].</span>"
			del(src)
		else
			user << "<span class='warning'>You need at least four rods to reinforce the [name].</span>"

/obj/item/weapon/table_parts/attack_self(mob/user as mob)
	new /obj/structure/table( user.loc )
	user.drop_item()
	del(src)
	return


/*
 * Reinforced Table Parts
 */
/obj/item/weapon/table_parts/reinforced/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/wrench))
		new /obj/item/stack/sheet/metal( get_turf(loc) )
		new /obj/item/stack/rods( get_turf(loc) )
		del(src)

/obj/item/weapon/table_parts/reinforced/attack_self(mob/user as mob)
	new /obj/structure/table/reinforced( user.loc )
	user.drop_item()
	del(src)
	return

/*
 * Wooden Table Parts
 */
/obj/item/weapon/table_parts/wood/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/weapon/wrench))
		new /obj/item/stack/sheet/wood( get_turf(loc) )
		//SN src = null
		del(src)
	if (istype(W, /obj/item/stack/tile/carpet))
		var/obj/item/stack/tile/carpet/C = W
		if (C.use(1))
			new /obj/item/weapon/table_parts/gambling(get_turf(loc))
			user << "<span class='notice'>You put a layer of carpet on the table.</span>"
			del(src)

/obj/item/weapon/table_parts/wood/attack_self(mob/user as mob)
	new /obj/structure/table/woodentable( user.loc )
	user.drop_item()
	del(src)
	return

/*
 * Gambling Table Parts
 */
/obj/item/weapon/table_parts/gambling/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/wrench))
		new /obj/item/stack/sheet/wood( get_turf(loc) )
		new /obj/item/stack/tile/carpet( get_turf(loc) )
		del(src)
	if (istype(W, /obj/item/weapon/crowbar))
		new /obj/item/stack/tile/carpet( get_turf(loc) )
		new /obj/item/weapon/table_parts/wood( get_turf(loc) )
		user << "<span class='notice'>You pry the carpet out of the table.</span>"
		del(src)

/obj/item/weapon/table_parts/gambling/attack_self(mob/user as mob)
	new /obj/structure/table/gamblingtable( user.loc )
	user.drop_item()
	del(src)
	return
/*
 * Rack Parts
 */
/obj/item/weapon/rack_parts/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/weapon/wrench))
		new /obj/item/stack/sheet/metal( get_turf(loc) )
		del(src)
		return
	return

/obj/item/weapon/rack_parts/attack_self(mob/user as mob)
	var/obj/structure/rack/R = new /obj/structure/rack( user.loc )
	R.add_fingerprint(user)
	user.drop_item()
	del(src)
	return