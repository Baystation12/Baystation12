/obj/aura/shadowling_aura
	name = "Shadowling Aura"
	var/added_mutation = FALSE

/obj/aura/shadowling_aura/added_to(mob/living/L)
	..()
	if(!(MUTATION_SPACERES in L.mutations))
		L.mutations += MUTATION_SPACERES
		added_mutation = TRUE

/obj/aura/shadowling_aura/removed()
	if(added_mutation)
		added_mutation = FALSE
		user.mutations -= MUTATION_SPACERES
	..()

/obj/aura/shadowling_aura/aura_check_bullet(obj/item/projectile/proj, def_zone)
	if (HAS_FLAGS(proj.damage_flags(), DAMAGE_FLAG_LASER))
		proj.damage *= 2
	if (proj.agony)
		proj.agony *= 2
	return EMPTY_BITFIELD
