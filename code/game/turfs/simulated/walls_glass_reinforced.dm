/turf/simulated/wall/g_wall/reinforced
	name = "reinforced glass window"
	desc = "A few panes of glass inserted into a reinforced metal frame."
	icon_state = "gr_wall"
	opacity = 0
	density = 1

	damage = 0
	damage_cap = 150
	max_temperature = 5000

	walltype = "grwall"


/turf/simulated/wall/g_wall/reinforced/deconstruction( obj/item/W as obj, mob/user as mob )
	switch(d_state)
		if(0)
			if (istype(W, /obj/item/weapon/screwdriver))
				playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
				src.d_state = 1

				user << "<span class='notice'>You loosen the reinforcing frame.</span>"
				return

		if(1)
			if (istype(W, /obj/item/weapon/screwdriver))
				playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
				src.d_state = 0

				user << "<span class='notice'>You tighten the reinforcing frame.</span>"
				return
			else if (istype(W, /obj/item/weapon/wirecutters))
				playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
				new /obj/item/stack/rods( src )
				new /obj/item/stack/rods( src )

				user << "<span class='notice'>You remove the reinforcing frame.</span>"

				ChangeTurf(/turf/space)
				new /turf/simulated/wall/g_wall( locate(src.x, src.y, src.z) )

				return
