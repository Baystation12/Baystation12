// Big Gigachad Towels
/obj/item/rolled_towel
	name = "rolled big towel"
	desc = "A collapsed big towel - looks like you can't use it as a normal one... Try it on a beach."
	icon = 'packs/infinity/icons/obj/items.dmi'
	icon_state = "rolled_towel"
	w_class = 2

	force = 0.3 // Big soft towel is more harmless
	attack_verb = list("whipped")
	hitsound = 'sound/weapons/towelwhip.ogg'
	// SIERRA TODO: port to Bay12 drop sounds
	// drop_sound = 'sound/items/drop/cloth.ogg'
	// pickup_sound = 'sound/items/pickup/cloth.ogg'

	var/beach_towel = /obj/structure/towel

/obj/item/rolled_towel/attack_self(mob/living/user as mob)
	var/obj/item/rolled_towel/R = new beach_towel(user.loc)
	R.add_fingerprint(user)
	qdel(src)

/obj/structure/towel
	name = "big towel"
	icon = 'packs/infinity/icons/obj/towels.dmi'
	icon_state = "beach_towel"
	anchored = FALSE
	var/rolled_towel = /obj/item/rolled_towel

/obj/structure/towel/attack_hand(mob/living/user as mob)
	..()
	if(!ishuman(user))
		return 0
	visible_message("<span class='notice'>[usr] rolled up [src].</span>")
	var/obj/item/rolled_towel/B = new rolled_towel(get_turf(src))
	usr.put_in_hands(B)
	qdel(src)

/obj/item/rolled_towel/black
	name = "black rolled towel"
	icon_state = "black_rolled_towel"
	beach_towel = /obj/structure/towel/black

/obj/structure/towel/black
	name = "black big towel"
	icon_state = "black_beach_towel"
	rolled_towel = /obj/item/rolled_towel/black

/obj/item/rolled_towel/blue_stripped
	name = "blue rolled towel"
	icon_state = "bluestripp_towel"
	beach_towel = /obj/structure/towel/blue_stripped

/obj/structure/towel/blue_stripped
	name = "blue big towel"
	icon_state = "bluestripp_beach"
	rolled_towel = /obj/item/rolled_towel/blue_stripped

/obj/item/rolled_towel/red_stripped
	name = "red rolled towel"
	icon_state = "redstripp_towel"
	beach_towel = /obj/structure/towel/red_stripped

/obj/structure/towel/red_stripped
	name = "red big towel"
	icon_state = "redstripp_beach"
	rolled_towel = /obj/item/rolled_towel/red_stripped

/obj/item/rolled_towel/green_stripped
	name = "green rolled towel"
	icon_state = "greenstripp_towel"
	beach_towel = /obj/structure/towel/green_stripped

/obj/structure/towel/green_stripped
	name = "green big towel"
	icon_state = "greenstripp_beach"
	rolled_towel = /obj/item/rolled_towel/green_stripped

/obj/item/rolled_towel/yellow_stripped
	name = "yellow rolled towel"
	icon_state = "yellowstripp_towel"
	beach_towel = /obj/structure/towel/yellow_stripped

/obj/structure/towel/yellow_stripped
	name = "green big towel"
	icon_state = "yellowstripp_beach"
	rolled_towel = /obj/item/rolled_towel/yellow_stripped

/obj/item/rolled_towel/pink_stripped
	name = "pink rolled towel"
	icon_state = "pinkstripp_towel"
	beach_towel = /obj/structure/towel/pink_stripped

/obj/structure/towel/pink_stripped
	name = "green big towel"
	icon_state = "pinkstripp_beach"
	rolled_towel = /obj/item/rolled_towel/pink_stripped

/obj/item/rolled_towel/ilove
	name = "*i <3 you* rolled towel"
	icon_state = "rolled_towel"
	beach_towel = /obj/structure/towel/ilove

/obj/structure/towel/ilove
	name = "*i <3 you* big towel"
	icon_state = "ilove_beach"
	rolled_towel = /obj/item/rolled_towel/ilove

/obj/item/rolled_towel/fitness
	name = "rolled fitness mat"
	desc = "A fitness mat - place it in a gym for better training.."
	icon_state = "rolled_gym_beach"
	beach_towel = /obj/structure/towel/fitness

/obj/structure/towel/fitness
	name = "fitness mat"
	icon_state = "gym_beach"
	rolled_towel = /obj/item/rolled_towel/fitness

/obj/structure/towel/holo
	name = "big holographic towel"
	icon = 'packs/infinity/icons/obj/towels.dmi'
	icon_state = "beach_towel"
	anchored = TRUE
	rolled_towel = null

/obj/structure/towel/holo/attack_hand(mob/living/user as mob)
	return

/obj/structure/towel/holo/ilove
	name = "*i <3 you* big towel"
	icon_state = "ilove_beach"

/obj/structure/towel/holo/blue_stripped
	name = "blue big towel"
	icon_state = "bluestripp_beach"
