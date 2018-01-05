
/obj/structure/tree
	name = "tree"
	icon = 'code/modules/halo/icons/doodads/trees.dmi'
	icon_state = "tree1"
	var/woodleft = 3
	anchored = 1

/obj/structure/tree/two
	icon_state = "tree2"

/obj/structure/tree/three
	icon_state = "tree3"

/obj/structure/tree/four
	icon_state = "tree4"

/obj/structure/tree/rand/New()
	..()
	icon_state = "tree[rand(1,4)]"

/obj/structure/tree/attackby(obj/item/I as obj, mob/user as mob)
	. = 1
	if(woodleft <= 0)
		to_chat(user,"<span class='warning'>There is no wood left on [src]!</span>")
		qdel(src)
		return 1

	var/chopping = 0
	if(has_edge(I))
		chopping = 2
	else if(is_sharp(I))
		chopping = 1
	if(chopping)
		var/tmp/str_out = "<span class='info'>You start chopping down [src]... "
		if(chopping < 2)
			str_out += "The [I.name] isn't very effective."
		str_out += "</span>"
		to_chat(user,str_out)
		user.visible_message("<span class='info'>[user] starts chopping down [src]</span>")

		playsound(src.loc, 'sound/effects/woodhit.ogg', 50, 5, 0)
		spawn(10)
			playsound(src.loc, 'sound/effects/woodhit.ogg', 50, 5, 0)
			spawn(10)
				playsound(src.loc, 'sound/effects/woodhit.ogg', 50, 5, 0)
		spawn(0)
			if(do_after(user, 20 + 20 / chopping))
				woodleft -= 1
				to_chat(user,"<span class='info'>You chop some wood from [src]. There is [src.woodleft] planks left.</span>")
				var/obj/item/stack/material/wood/W = new(src.loc)
				W.amount = 10
				if(woodleft <= 0)
					qdel(src)
	else
		to_chat(user, "<span class='warning'>You need something sharp to chop down [src]</span>")

/obj/structure/tree/bushy
	icon_state = "bush1"

/obj/structure/tree/bushy/two
	icon_state = "bush2"

/obj/structure/tree/bushy/rand/New()
	..()
	icon_state = "bush[rand(1,2)]"

/obj/structure/tree/ex_act(var/severity)
	qdel(src)

/obj/structure/tree/fire_act(var/datum/gas_mixture/air, var/exposed_temperature, var/exposed_volume)
	ex_act(1)
