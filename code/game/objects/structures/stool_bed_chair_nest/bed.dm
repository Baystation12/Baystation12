/* Beds... get your mind out of the gutter, they're for sleeping!
 * Contains:
 * 		Beds
 *		Roller beds
 */

/*
 * Beds
 */
/obj/structure/bed
	name = "bed"
	desc = "This is used to lie in, sleep in or strap on."
	icon = 'icons/obj/objects.dmi'
	icon_state = "bed"
	pressure_resistance = 15
	anchored = 1
	can_buckle = 1
	buckle_lying = 1
	var/material/material
	var/apply_cosmetics = 1

/obj/structure/bed/New(var/newloc, var/new_material)
	..(newloc)
	if(!new_material)
		new_material = DEFAULT_WALL_MATERIAL

	material = get_material_by_name(new_material)
	if(!istype(material))
		qdel(src)
		return
	if(apply_cosmetics)
		color = material.icon_colour
		name = "[material.display_name] [initial(name)]"
		desc = "[initial(desc)] It's made of [material.display_name]."

/obj/structure/bed/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				qdel(src)
				return

/obj/structure/bed/blob_act()
	if(prob(75))
		material.place_sheet(get_turf(src))
		qdel(src)

/obj/structure/bed/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		material.place_sheet(get_turf(src))
		qdel(src)
	else if(istype(W, /obj/item/weapon/grab))
		user.visible_message("<span class='notice'>[user] attempts to buckle [W:affecting] into \the [src]!</span>")
		if(do_after(user, 20))
			W:affecting.loc = loc
			if(buckle_mob(W:affecting))
				W:affecting.visible_message(\
					"<span class='danger'>[W:affecting.name] is buckled to [src] by [user.name]!</span>",\
					"<span class='danger'>You are buckled to [src] by [user.name]!</span>",\
					"<span class='notice'>You hear metal clanking.</span>")
	else
		..()

/obj/structure/bed/psych
	name = "psychiatrist's couch"
	desc = "For prime comfort during psychiatric evaluations."
	icon_state = "psychbed"
	apply_cosmetics = 0

/obj/structure/bed/psych/New(var/newloc)
	..(newloc,"leather")

/obj/structure/bed/alien
	name = "resting contraption"
	desc = "This looks similar to contraptions from earth. Could aliens be stealing our technology?"
	icon_state = "abed"
	apply_cosmetics = 0


/obj/structure/bed/alien/New(var/newloc)
	..(newloc,"resin")

/*
 * Roller beds
 */
/obj/structure/bed/roller
	name = "roller bed"
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "down"
	anchored = 0
	apply_cosmetics = 0

/obj/structure/bed/roller/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/roller_holder))
		if(buckled_mob)
			user_unbuckle_mob(user)
		else
			visible_message("[user] collapses \the [src.name].")
			new/obj/item/roller(get_turf(src))
			spawn(0)
				qdel(src)
		return
	..()

/obj/item/roller
	name = "roller bed"
	desc = "A collapsed roller bed that can be carried around."
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "folded"
	w_class = 4.0 // Can't be put in backpacks. Oh well.

/obj/item/roller/attack_self(mob/user)
		var/obj/structure/bed/roller/R = new /obj/structure/bed/roller(user.loc)
		R.add_fingerprint(user)
		qdel(src)

/obj/item/roller/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if(istype(W,/obj/item/roller_holder))
		var/obj/item/roller_holder/RH = W
		if(!RH.held)
			user << "<span class='notice'>You collect the roller bed.</span>"
			src.loc = RH
			RH.held = src
			return

	..()

/obj/item/roller_holder
	name = "roller bed rack"
	desc = "A rack for carrying a collapsed roller bed."
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "folded"
	var/obj/item/roller/held

/obj/item/roller_holder/New()
	..()
	held = new /obj/item/roller(src)

/obj/item/roller_holder/attack_self(mob/user as mob)

	if(!held)
		user << "<span class='notice'>The rack is empty.</span>"
		return

	user << "<span class='notice'>You deploy the roller bed.</span>"
	var/obj/structure/bed/roller/R = new /obj/structure/bed/roller(user.loc)
	R.add_fingerprint(user)
	qdel(held)
	held = null


/obj/structure/bed/roller/Move()
	..()
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			buckled_mob.loc = src.loc
		else
			buckled_mob = null

/obj/structure/bed/roller/post_buckle_mob(mob/living/M as mob)
	if(M == buckled_mob)
		M.pixel_y = 6
		M.old_y = 6
		density = 1
		icon_state = "up"
	else
		M.pixel_y = 0
		M.old_y = 0
		density = 0
		icon_state = "down"

	return ..()

/obj/structure/bed/roller/MouseDrop(over_object, src_location, over_location)
	..()
	if((over_object == usr && (in_range(src, usr) || usr.contents.Find(src))))
		if(!ishuman(usr))	return
		if(buckled_mob)	return 0
		visible_message("[usr] collapses \the [src.name].")
		new/obj/item/roller(get_turf(src))
		spawn(0)
			qdel(src)
		return
