/obj/item/weapon/material/star
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

/obj/item/weapon/material/star/New()
	..()
	src.pixel_x = rand(-12, 12)
	src.pixel_y = rand(-12, 12)

/obj/item/weapon/material/star/throw_impact(atom/hit_atom)
	..()
	if(material.radioactivity>0 && istype(hit_atom,/mob/living))
		var/mob/living/M = hit_atom
		M.adjustToxLoss(rand(20,40))

/obj/item/weapon/material/star/ninja
	default_material = "uranium"