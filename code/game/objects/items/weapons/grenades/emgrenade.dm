/obj/item/grenade/empgrenade
	name = "classic emp grenade"
	icon_state = "emp"
	item_state = "empgrenade"
	origin_tech = list(TECH_MATERIAL = 2, TECH_MAGNET = 3)

/obj/item/grenade/empgrenade/detonate()
	..()
	if(empulse(src, 2, 5))
		qdel(src)
	return

/obj/item/grenade/empgrenade/low_yield
	name = "low yield emp grenade"
	desc = "A weaker variant of the classic emp grenade."
	icon_state = "lyemp"
	item_state = "lyempgrenade"
	origin_tech = list(TECH_MATERIAL = 2, TECH_MAGNET = 3)

/obj/item/grenade/empgrenade/low_yield/detonate()
	..()
	if(empulse(src, 1, 3))
		qdel(src)
	return
