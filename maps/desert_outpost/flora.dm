
/obj/structure/tree
	var/woodleft = 3
	anchored = 1

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

/obj/structure/tree/palm
	name = "palm tree"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "palm1"
	woodleft = 2

/obj/structure/tree/palm/New()
	..()
	if(prob(50))
		icon_state = "palm2"

/obj/effect/desertflora
	icon = 'icons/obj/flora/ausflora.dmi'
	anchored = 1

/obj/effect/desertflora/New()
	name = pick(\
		"yellow flowers",\
		"sunny bush",\
		"sparse grass")
	switch(name)
		if("yellow flowers")
			icon_state = "ywflowers_[rand(1,4)]"
		if("sunny bush")
			icon_state = "sunnybush_[rand(1,3)]"
		if("sparse grass")
			icon_state = "sparsegrass_[rand(1,3)]"

/obj/effect/desertflora/attackby(obj/item/I as obj, mob/user as mob)
	. = 1

	var/chopping = 0
	if(has_edge(I))
		chopping = 2
	else if(is_sharp(I))
		chopping = 1
	if(chopping)
		var/tmp/str_out = "<span class='info'>You start clearing [src]... "
		if(chopping < 2)
			str_out += "The [I.name] isn't very effective."
		str_out += "</span>"
		to_chat(user,str_out)
		user.visible_message("<span class='info'>[user] starts clearing [src]</span>")

		playsound(src.loc, pick(rustle_sound), 50, 5, 0)
		spawn(10)
			playsound(src.loc, pick(rustle_sound), 50, 5, 0)
			spawn(10)
				playsound(src.loc, pick(rustle_sound), 50, 5, 0)
		spawn(0)
			if(do_after(user, 10 + 20 / chopping))
				to_chat(user,"<span class='info'>You clear away the [src] and get some cloth scraps.</span>")
				new /obj/item/stack/material/cloth(src.loc)
				qdel(src)
	else
		to_chat(user,"<span class='warning'>You need something sharp to clear away [src]</span>")
