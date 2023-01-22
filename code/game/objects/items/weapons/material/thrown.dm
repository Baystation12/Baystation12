/obj/item/material/star
	name = "shuriken"
	desc = "A sharp, perfectly weighted piece of metal."
	icon = 'icons/obj/weapons/other.dmi'
	icon_state = "star"
	randpixel = 12
	max_force = 10
	force_multiplier = 0.1 // 6 with hardness 60 (steel)
	thrown_force_multiplier = 1 // 20 with weight 20 (steel)
	throw_speed = 8
	throw_range = 15
	sharp = TRUE
	edge =  TRUE
	w_class = ITEM_SIZE_TINY

/obj/item/material/star/New()
	..()

/obj/item/material/star/throw_impact(atom/hit_atom)
	..()
	if(material.radioactivity>0 && istype(hit_atom,/mob/living))
		var/mob/living/M = hit_atom
		var/urgh = material.radioactivity
		M.adjustToxLoss(rand(urgh/2,urgh))

/obj/item/material/star/ninja
	default_material = MATERIAL_URANIUM
