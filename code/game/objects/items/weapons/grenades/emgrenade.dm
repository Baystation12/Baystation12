/obj/item/weapon/grenade/empgrenade
	name = "classic emp grenade"
	icon_state = "emp"
	item_state = "emp"
	origin_tech = list(TECH_MATERIAL = 2, TECH_MAGNET = 3)

	prime()
		..()
		if(empulse(src, 4, 10))
			qdel(src)
		return
