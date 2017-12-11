
/obj/effect/flora
	name = "bush"
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "firstbush_1"
	anchored = 1

/obj/effect/flora/New()
	..()
	pick_icon_state()

/obj/effect/flora/proc/pick_icon_state()
	var/list/possible_icon_states = icon_states(src.icon)
	icon_state = pick(possible_icon_states)

/obj/effect/flora/attackby(obj/item/I as obj, mob/user as mob)
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
