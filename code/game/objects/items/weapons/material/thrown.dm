/obj/item/weapon/star
	name = "shuriken"
	desc = "A sharp, perfectly weighted piece of metal."
	icon_state = "star"
	force = 5
	throw_speed = 10
	throwforce =  15
	throw_range = 15
	sharp = 1
	edge =  1
	matter = list(DEFAULT_WALL_MATERIAL = 500)

	var/poisoned = 0

/obj/item/weapon/star/New()
	..()
	src.pixel_x = rand(-12, 12)
	src.pixel_y = rand(-12, 12)

//TODO: consider making this something done with reagents.
/obj/item/weapon/star/throw_impact(atom/hit_atom)
	..()
	if(poisoned && istype(hit_atom,/mob/living))
		var/mob/living/M = hit_atom
		M.adjustToxLoss(rand(20,40))
		poisoned = 0
		color = null

/obj/item/weapon/star/ninja
	color = "#007700"
	poisoned = 1