
/obj/item/weapon/shard/supermatter
	name = "supermatter shard"
	desc = "A shard of supermatter. Incredibly dangerous, though not large enough to go critical."
	force = 10.0
	throwforce = 20.0
	icon_state = "supermatterlarge"
	sharp = 1
	edge = 1
	w_class = 2
	flags = CONDUCT
	l_color = "#8A8A00"
	luminosity = 2

/obj/item/weapon/shard/supermatter/New()
	src.icon_state = pick("supermatterlarge")
	switch(src.icon_state)
		if("supermattersmall")
			src.pixel_x = rand(-12, 12)
			src.pixel_y = rand(-12, 12)
		if("supermattermedium")
			src.pixel_x = rand(-8, 8)
			src.pixel_y = rand(-8, 8)
		if("supermatterlarge")
			src.pixel_x = rand(-5, 5)
			src.pixel_y = rand(-5, 5)
		else
	return

/obj/item/weapon/shard/supermatter/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()

/obj/item/weapon/shard/supermatter/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return ..()

/obj/item/weapon/shard/supermatter/Crossed(AM as mob|obj)
	if(ismob(AM))
		var/mob/M = AM
		M << "\red <B>You step on \the [src]!</B>"
		playsound(src.loc, 'sound/effects/glass_step_sm.ogg', 70, 1) // not sure how to handle metal shards with sounds
		if(ishuman(M))
			var/mob/living/carbon/human/H = M

			if(H.species.flags & IS_SYNTHETIC || (H.species.siemens_coefficient<0.5)) //Thick skin.
				return

			if( !H.shoes && ( !H.wear_suit || !(H.wear_suit.body_parts_covered & FEET) ) )
				var/datum/organ/external/affecting = H.get_organ(pick("l_foot", "r_foot"))
				if(affecting.status & ORGAN_ROBOT)
					return
				if(affecting.take_damage(5, 20))
					H.UpdateDamageIcon()
				H.updatehealth()
				if(!(H.species && (H.species.flags & NO_PAIN)))
					H.Weaken(3)
	..()
