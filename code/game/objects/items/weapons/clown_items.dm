/* Clown Items
 * Contains:
 * 		Banana Peels
 *		Soap
 *		Bike Horns
 */

/*
 * Banana Peals
 */
/obj/item/weapon/bananapeel/Crossed(AM as mob|obj)
	if (istype(AM, /mob/living))
		var/mob/living/M = AM
		M.slip("the [src.name]",4)
/*
 * Soap
 */
/obj/item/weapon/soap/New()
	..()
	create_reagents(5)
	wet()
 
/obj/item/weapon/soap/proc/wet()
	reagents.add_reagent("cleaner", 5)

/obj/item/weapon/soap/Crossed(AM as mob|obj)
	if (istype(AM, /mob/living))
		var/mob/living/M =	AM
		M.slip("the [src.name]",3)

/obj/item/weapon/soap/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity) return
	//I couldn't feasibly  fix the overlay bugs caused by cleaning items we are wearing.
	//So this is a workaround. This also makes more sense from an IC standpoint. ~Carn
	if(user.client && (target in user.client.screen))
		user << "<span class='notice'>You need to take that [target.name] off before cleaning it.</span>"
	else if(istype(target,/obj/effect/decal/cleanable))
		user << "<span class='notice'>You scrub \the [target.name] out.</span>"
		qdel(target)
	else if(istype(target,/turf))
		user << "<span class='notice'>You scrub \the [target.name] clean.</span>"
		var/turf/T = target
		T.clean(src, user)
	else if(istype(target,/obj/structure/sink))
		user << "<span class='notice'>You wet \the [src] in the sink.</span>"
		wet()
	else
		user << "<span class='notice'>You clean \the [target.name].</span>"
		target.clean_blood()
	return

/obj/item/weapon/soap/attack(mob/target as mob, mob/user as mob)
	if(target && user && ishuman(target) && ishuman(user) && !target.stat && !user.stat && user.zone_sel &&user.zone_sel.selecting == "mouth" )
		user.visible_message("\red \the [user] washes \the [target]'s mouth out with soap!")
		return
	..()

/*
 * Bike Horns
 */
/obj/item/weapon/bikehorn/attack_self(mob/user as mob)
	if (spam_flag == 0)
		spam_flag = 1
		playsound(src.loc, 'sound/items/bikehorn.ogg', 50, 1)
		src.add_fingerprint(user)
		spawn(20)
			spam_flag = 0
	return
