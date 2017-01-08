/obj/structure/skele_stand
	name = "hanging skeleton model"
	anchored = 1
	density = 1
	icon = 'icons/obj/surgery.dmi'
	icon_state = "hangskele"
	desc = "It's an anatomical model of a human skeletal system made of plaster."

/obj/structure/skele_stand/New()
	..()
	gender = pick(MALE, FEMALE)

/obj/structure/skele_stand/proc/rattle_bones()
	visible_message("\The [src] rattles on \his stand.")
	//Dear future people: Put a sound here if you want. ~TH

/obj/structure/skele_stand/attack_hand(mob/user)
	rattle_bones()

/obj/structure/skele_stand/Bumped()
	rattle_bones()

/obj/structure/skele_stand/attackby(obj/item/weapon/W, mob/user)
	rattle_bones()
