/obj/structure/missile_rack
	name = "missile rack"
	desc = "A rack that can hold a single missile compactly."
	icon = 'icons/obj/ship_battles.dmi'
	icon_state = "rack"
	density = 1
	anchored = 1

	var/contained_count = 0
	var/obj/machinery/missile/contained
	var/contained_type = /obj/machinery/missile/standard

	New()
		..()
		if(contained_type)
			contained = new contained_type(src)
			switch(contained.req_grabs)
				if(1)
					contained_count = 4
				else if(2)
					contained_count = 3
				else
					contained_count = 2
			contained_count -= 1
		return

	Destroy()
		qdel(contained)
		contained = null
		return ..()

	ex_act()
		contained.ex_act()
		spawn(1)
			qdel(src)

	attack_hand(var/mob/living/carbon/human/user)
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

/obj/structure/missile_rack/light
	name = "light missile rack"
	desc = "A rack that can hold a pair of light missiles compactly."
	contained_type = /obj/machinery/missile

/obj/structure/missile_rack/heavy
	name = "heavy missile rack"
	desc = "A rack that can hold a single heavy missile compactly."
	contained_type = /obj/machinery/missile/heavy

/obj/structure/missile_rack/scatter
	name = "scatter missile rack"
	desc = "A rack that can hold a single scatter missile compactly."
	contained_type = /obj/machinery/missile/scatter

/obj/structure/missile_rack/emp
	name = "emp missile rack"
	desc = "A rack that can hold a single emp missile compactly."
	contained_type = /obj/machinery/missile/emp

/obj/structure/missile_rack/emp/breach
	name = "breach emp missile rack"
	desc = "A rack that can hold a breach emp missile compactly."
	contained_type = /obj/machinery/missile/emp/breach

/obj/structure/missile_rack/bomb
	name = "bomb rack"
	desc = "A rack that can hold a pair of bombs compactly."
	contained_type = /obj/machinery/missile/bomb

	New()
		..()
		contained_count = 2

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
	desc = "A rack that can hold a pair of vine bombs compactly."
	contained_type = /obj/machinery/missile/bomb/plant




