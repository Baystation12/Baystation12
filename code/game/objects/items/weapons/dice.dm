/obj/item/weapon/dice
	name = "d6"
	desc = "A dice with six sides."
	icon = 'icons/obj/dice.dmi'
	icon_state = "d66"
	w_class = ITEM_SIZE_TINY
	var/sides = 6
	attack_verb = list("diced")

/obj/item/weapon/dice/New()
	icon_state = "[name][rand(1,sides)]"

/obj/item/weapon/dice/d4
	name = "d4"
	desc = "A dice with four sides."
	icon_state = "d44"
	sides = 4

/obj/item/weapon/dice/d8
	name = "d8"
	desc = "A dice with eight sides."
	icon_state = "d88"
	sides = 8

/obj/item/weapon/dice/d10
	name = "d10"
	desc = "A dice with ten sides."
	icon_state = "d1010"
	sides = 10

/obj/item/weapon/dice/d12
	name = "d12"
	desc = "A dice with twelve sides."
	icon_state = "d1212"
	sides = 12

/obj/item/weapon/dice/d20
	name = "d20"
	desc = "A dice with twenty sides."
	icon_state = "d2020"
	sides = 20

/obj/item/weapon/dice/d100
	name = "d100"
	desc = "A dice with ten sides. This one is for the tens digit."
	icon_state = "d10010"
	sides = 10

/obj/item/weapon/dice/proc/roll_die()
	var/result = rand(1, sides)
	return list(result, "")

/obj/item/weapon/dice/d20/roll_die()
	var/result = rand(1, sides)
	var/comment = ""
	if(result == 20)
		comment = "Nat 20!"
	else if(result == 1)
		comment = "Ouch, bad luck."
	return list(result, comment)

/obj/item/weapon/dice/attack_self(mob/user as mob)
	var/list/roll_result = roll_die()
	var/result = roll_result[1]
	var/comment = roll_result[2]
	icon_state = "[name][result]"
	user.visible_message("<span class='notice'>[user] has thrown [src]. It lands on [result]. [comment]</span>", \
						 "<span class='notice'>You throw [src]. It lands on a [result]. [comment]</span>", \
						 "<span class='notice'>You hear [src] landing on a [result]. [comment]</span>")

/obj/item/weapon/dice/throw_impact(atom/hit_atom, var/speed)
	..()
	var/list/roll_result = roll_die()
	var/result = roll_result[1]
	var/comment = roll_result[2]
	icon_state = "[name][result]"
	src.visible_message("<span class='notice'>\The [src] lands on [result]. [comment]</span>")