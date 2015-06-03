/obj/item/weapon/stool
	name = "stool"
	desc = "Apply butt."
	icon = 'icons/obj/objects.dmi'
	icon_state = "stool"
	pixel_y = 0
	force = 10
	throwforce = 10
	w_class = 5

/obj/item/weapon/stool/attack(mob/M as mob, mob/user as mob)
	if (prob(5) && istype(M,/mob/living))
		user.visible_message("\red [user] breaks [src] over [M]'s back!")
		user.u_equip(src)
		var/obj/item/stack/sheet/metal/m = new/obj/item/stack/sheet/metal
		m.loc = get_turf(src)
		del src
		var/mob/living/T = M
		T.Weaken(10)
		T.apply_damage(20)
		return
	..()

/obj/item/weapon/stool/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if (prob(50))
				del(src)
				return
		if(3.0)
			if (prob(5))
				del(src)
				return

/obj/item/weapon/stool/blob_act()
	if(prob(75))
		new /obj/item/stack/sheet/metal(src.loc)
		del(src)

/obj/item/weapon/stool/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		new /obj/item/stack/sheet/metal(src.loc)
		del(src)
	..()

/obj/structure/stool/bed/chair/bench
	name = "bench"
	desc = "It has a massive mark!"
	icon = 'icons/obj/objects.dmi'
	icon_state = "bench"

/obj/structure/stool/bed/chair/bench/attackby(obj/item/weapon/W as obj, mob/user as mob)
	return

/obj/structure/stool/bed/chair/bench/MouseDrop(atom/over_object)
	return