/obj/item/weapon/pen/reagent
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	origin_tech = list(TECH_MATERIAL = 2, TECH_ESOTERIC = 5)

/obj/item/weapon/pen/reagent/New()
	..()
	create_reagents(30)

/obj/item/weapon/pen/reagent/attack(mob/living/M, mob/user, var/target_zone)

	if(!istype(M))
		return

	. = ..()

	if(M.can_inject(user, target_zone))
		if(reagents.total_volume)
			if(M.reagents)
				var/contained_reagents = reagents.get_reagents()
				var/trans = reagents.trans_to_mob(M, 30, CHEM_BLOOD)
				admin_inject_log(user, M, src, contained_reagents, trans)

/*
 * Sleepy Pens
 */
/obj/item/weapon/pen/reagent/sleepy
	desc = "It's a black ink pen with a sharp point and a carefully engraved \"Waffle Co.\"."
	origin_tech = list(TECH_MATERIAL = 2, TECH_ESOTERIC = 5)

/obj/item/weapon/pen/reagent/sleepy/New()
	..()
	reagents.add_reagent(/datum/reagent/vecuronium_bromide, 15)
