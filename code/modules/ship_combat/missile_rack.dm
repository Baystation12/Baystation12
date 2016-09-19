/obj/structure/missile_rack
	name = "missile rack"
	desc = "A rack that can hold a single missile compactly."
	icon = 'icons/obj/ship_battles.dmi'
	icon_state = "rack"
	density = 1
	anchored = 1

	var/contained_count = 2
	var/obj/machinery/missile/contained
	var/contained_type = /obj/machinery/missile/standard

	attackby(var/obj/item/I, var/mob/living/carbon/human/user)
		if(istype(I, /obj/item/weapon/missile_grab))
			var/obj/item/weapon/missile_grab/G = I
			if(G.holding && (G.holding.type == contained_type || !contained_type))
				if(contained && contained_count >= (8 - contained.req_grabs*2))
					user << "<span class='warning'>\The [src] has no space for \the [G.holding]!</span>"
				else
					user.visible_message("<span class='notice'>\The [user] begins placing \the [G.holding] into \the [src]</span>")
					if(do_after(user, 150))
						if(G && G.holding)
							user.visible_message("<span class='notice'>\The [user] places \the [G.holding] into \the [src]</span>")
							if(contained)
								qdel(G.holding)
								contained_count++
							else
								var/obj/machinery/missile/M = G.holding
								M.let_go()
								M.forceMove(src)
								contained = M
								if(!contained_type)
									contained_type = M.type
									contained_count = M.req_grabs * 2
									name = "[M.name] missile rack."

			else
				user << "<span class='warning'>\The [G.holding] will not fit into \the [src]!</span>"
		else if(istype(I, /obj/item/weapon/wrench))
			if(contained || contained_count)
				user << "<span class='warning'>\The [src] must be emptied first!</span>"
			else
				anchored = !anchored
				src.visible_message("<span class='notice'>\The [user] [anchored ? "anchors" : "unanchors"] \the [src]!</span>")
		return ..()

	New()
		..()
		if(contained_type)
			contained = new contained_type(src)
/*			switch(contained.req_grabs)
				if(1)
					contained_count = 6
				else if(2)
					contained_count = 4
				else
					contained_count = 2
			contained_count -= 1
		return
*/

	Destroy()
		qdel(contained)
		contained = null
		return ..()

//	ex_act()
//		contained.ex_act()
//		spawn(1)
//			qdel(src)

	attack_hand(var/mob/living/carbon/human/user)
		if(!anchored)
			user << "<span class='warning'>\The [src] has to be anchored first!</span>"
			return
		if(contained)
			user.visible_message("<span class='notice'>[user] removes \the [contained] from \the [src].</span>")
			contained.forceMove(get_turf(user))
			contained.add_fingerprint(user)
			contained = null
			spawn(rand(20,200))
				if(contained_count)
					contained = new contained_type(src)
					contained_count--
					src.visible_message("<span class='notice'>[src] clunks as it loads another [contained].")
		else
			user << "<span class='notice'>\The [src] is empty!</span>"

	examine(var/mob/user)
		..()
		if(contained)
			user << "<span class='notice'>It contains [contained_count+1] [contained]s!</span>"
		else
			user << "<span class='warning'>It is empty!</span>"

/obj/structure/missile_rack/built
	contained_type = null
	contained_count = null
	anchored = 0

/obj/structure/missile_rack/light
	name = "light missile rack"
	desc = "A rack that can hold a quad-pack of light missiles compactly."
	contained_type = /obj/machinery/missile
	contained_count = 4

/obj/structure/missile_rack/heavy
	name = "heavy missile rack"
	desc = "A rack that can hold a pair of heavy missiles compactly."
	contained_type = /obj/machinery/missile/heavy
	contained_count = 2

/obj/structure/missile_rack/scatter
	name = "scatter missile rack"
	desc = "A rack that can hold a single scatter missile compactly."
	contained_type = /obj/machinery/missile/scatter
	contained_count = 1

/obj/structure/missile_rack/emp
	name = "emp missile rack"
	desc = "A rack that can hold a pair of emp missiles compactly."
	contained_type = /obj/machinery/missile/emp
	contained_count = 2

/obj/structure/missile_rack/emp/breach
	name = "breach emp missile rack"
	desc = "A rack that can hold a breach emp missile compactly."
	contained_type = /obj/machinery/missile/emp/breach
	contained_count = 1

/obj/structure/missile_rack/bomb
	name = "bomb rack"
	desc = "A rack that can hold a pair of bombs compactly."
	contained_type = /obj/machinery/missile/bomb

/obj/structure/missile_rack/bomb/emp
	name = "emp bomb rack"
	desc = "A rack that can hold a pair of emp bombs compactly."
	contained_type = /obj/machinery/missile/bomb/emp

/obj/structure/missile_rack/bomb/necrosis
	name = "necrosis bomb rack"
	desc = "A rack that can hold a pair of necrosis bombs compactly."
	contained_type = /obj/machinery/missile/bomb/necrosis

/obj/structure/missile_rack/bomb/incendiary
	name = "incendiary bomb rack"
	desc = "A rack that can hold a pair of incendiary bombs compactly."
	contained_type = /obj/machinery/missile/bomb/incendiary

/obj/structure/missile_rack/bomb/gravity
	name = "gravity bomb rack"
	desc = "A rack that can hold a pair of gravity bombs compactly."
	contained_type = /obj/machinery/missile/bomb/grav

/obj/structure/missile_rack/bomb/plant
	name = "vine bomb rack"
	desc = "A rack that can hold a single vine bomb compactly."
	contained_type = /obj/machinery/missile/bomb/plant
	contained_count = 1




