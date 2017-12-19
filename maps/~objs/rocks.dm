
/obj/effect/rocks
	name = "rocks"
	icon = 'icons/obj/flora/rocks.dmi'
	icon_state = "medrocks_1"
	anchored = 1
	var/stone_amount = 10

/obj/effect/rocks/New()
	icon_state = "medrocks_[rand(1,5)]"

/obj/effect/rocks/attackby(obj/item/I as obj, mob/user as mob)
	. = ..()

	if (istype(I, /obj/item/weapon/pickaxe))

		var/obj/item/weapon/pickaxe/P = I

		user.visible_message("<span class='info'>[user] starts clearing [src]</span>")
		to_chat(user,"<span class='info'>You start clearing [src]...</span>")

		playsound(src.loc, P.drill_sound, 20, 1)

		spawn(0)
			if(do_after(user, 20))
				to_chat(user,"<span class='info'>You break the [src] and get some stone scraps.</span>")
				new /obj/item/stack/material/stone(src.loc, stone_amount)
				qdel(src)
	else
		to_chat(user,"<span class='warning'>You need something better at breaking stone to clear away [src]</span>")

/obj/effect/rocks/small
	name = "small rocks"
	icon_state = "smallrocks_1"
	stone_amount = 5

/obj/effect/rocks/small/New()
	icon_state = "smallrocks_[rand(1,5)]"
