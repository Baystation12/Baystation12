/obj/aura/shadowling_aura
	name = "Shadowling Aura"
	var/added_mutation = FALSE

/obj/aura/shadowling_aura/added_to(var/mob/living/L)
	..()
	if(!(SPACERES in L.mutations))
		L.mutations += SPACERES
		added_mutation = TRUE

/obj/aura/shadowling_aura/removed()
	if(added_mutation)
		added_mutation = FALSE
		user.mutations -= SPACERES
	..()

/obj/aura/shadowling_aura/bullet_act(var/obj/item/projectile/P)
	if(P.check_armour == "laser")
		P.damage *= 2
	if(P.agony)
		P.agony *= 2
	return 0