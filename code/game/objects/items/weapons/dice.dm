//from tg
/obj/item/weapon/dice
	name = "d6"
	desc = "A die with six sides. Basic and servicable."
	icon = 'icons/obj/dice.dmi'
	icon_state = "d6"
	w_class = 1
	var/sides = 6
	attack_verb = list("diced")

/obj/item/weapon/dice/New()
	icon_state = "[initial(icon_state)][rand(1, sides)]"

/obj/item/weapon/dice/d2
	name = "d2"
	desc = "A die with two sides. Coins are undignified!"
	icon_state = "d2"
	sides = 2

/obj/item/weapon/dice/d4
	name = "d4"
	desc = "A die with four sides. The nerd's caltrop."
	icon_state = "d4"
	sides = 4

/obj/item/weapon/dice/d8
	name = "d8"
	desc = "A die with eight sides. It feels... lucky."
	icon_state = "d8"
	sides = 8

/obj/item/weapon/dice/d10
	name = "d10"
	desc = "A die with ten sides. Useful for percentages."
	icon_state = "d10"
	sides = 10

/obj/item/weapon/dice/d00
	name = "d00"
	desc = "A die with ten sides. Works better for d100 rolls than a golfball."
	icon_state = "d00"
	sides = 10

/obj/item/weapon/dice/d12
	name = "d12"
	desc = "A die with twelve sides. There's an air of neglect about it."
	icon_state = "d12"
	sides = 12

/obj/item/weapon/dice/d20
	name = "d20"
	desc = "A die with twenty sides. The prefered die to throw at the GM."
	icon_state = "d20"
	sides = 20

/obj/item/weapon/dice/attack_self(mob/user as mob)
	diceroll(user)

/obj/item/weapon/dice/throw_at(atom/target, range, speed, mob/user as mob)
	..()
	diceroll(user)

/obj/item/weapon/dice/proc/diceroll(mob/user as mob)
	var/result = rand(1, sides)
	var/comment = ""
	if(sides == 20 && result == 20)
		comment = "Nat 20!"
	else if(sides == 20 && result == 1)
		comment = "Ouch, bad luck."
	icon_state = "[initial(icon_state)][result]"
	if(initial(icon_state) == "d00")
		result = (result - 1)*10
	if(user != null) //Dice was rolled in someone's hand
		user.visible_message("<span class='notice'>[user] has thrown [src]. It lands on [result]. [comment]</span>", \
							 "<span class='notice'>You throw [src]. It lands on [result]. [comment]</span>", \
							 "<span class='notice'>You hear [src] landing on [result]. [comment]</span>")
	else if(src.throwing == 0) //Dice was thrown and is coming to rest
		src.loc.visible_message("<span class='notice'>[src] rolls to a stop, landing on [result]. [comment]</span>")

/obj/item/weapon/dice/d4/Crossed(var/mob/living/carbon/human/H)
	if(istype(H) && !H.shoes)
		H << "<span class='userdanger'>You step on the D4!</span>"
		H.apply_damage(4,BRUTE,(pick("l_leg", "r_leg")))
		H.Weaken(3)

//bag
/obj/item/weapon/storage/pill_bottle/dice
	name = "bag of dice"
	desc = "Contains all the luck you'll ever need."
	icon = 'icons/obj/dice.dmi'
	icon_state = "dicebag"

	New()
		..()
		new /obj/item/weapon/dice/d4( src )
		new /obj/item/weapon/dice( src )
		new /obj/item/weapon/dice/d8( src )
		new /obj/item/weapon/dice/d10( src )
		new /obj/item/weapon/dice/d00( src )
		new /obj/item/weapon/dice/d12( src )
		new /obj/item/weapon/dice/d20( src )
