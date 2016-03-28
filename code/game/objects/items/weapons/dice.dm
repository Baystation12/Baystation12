/obj/item/weapon/dice
	name = "d6"
	desc = "A dice with six sides."
	icon = 'icons/obj/dice.dmi'
	icon_state = "d66"
	w_class = 1
	var/sides = 6
	attack_verb = list("diced")

/obj/item/weapon/dice/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = O
		if(C.use(5))
			user.visible_message("<span class='notice'>[user] begins attaching some wires to \the [src]...</span>", "<span class='notice'>You begin attaching some wires to \the [src]..</span>")
			if(do_after(user, 60))
				user << "<span class='notice'>You have modified \the [src]!</span>"
				var/obj/item/device/assembly/dice/D = new()
				D.forceMove(get_turf(src))
				qdel(src)
		else
			user << "<span class='notice'>You need atleast five lengths of cable to do that!</span>"

/obj/item/weapon/dice/New()
	icon_state = "[name][rand(1,sides)]"

/obj/item/weapon/dice/d20
	name = "d20"
	desc = "A dice with twenty sides."
	icon_state = "d2020"
	sides = 20

/obj/item/weapon/dice/attack_self(mob/user as mob)
	var/result = rand(1, sides)
	var/comment = ""
	if(sides == 20 && result == 20)
		comment = "Nat 20!"
	else if(sides == 20 && result == 1)
		comment = "Ouch, bad luck."
	icon_state = "[name][result]"
	user.visible_message("<span class='notice'>[user] has thrown [src]. It lands on [result]. [comment]</span>", \
						 "<span class='notice'>You throw [src]. It lands on a [result]. [comment]</span>", \
						 "<span class='notice'>You hear [src] landing on a [result]. [comment]</span>")
