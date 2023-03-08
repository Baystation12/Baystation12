/obj/aura/blueforge_aura
	name = "Blueforge Aura"
	icon = 'icons/mob/human_races/species/eyes.dmi'
	icon_state = "eyes_blueforged_s"
	layer = MOB_LAYER

/obj/aura/blueforge_aura/aura_check_life()
	user.adjustToxLoss(-10)
	return EMPTY_BITFIELD

/obj/aura/blueforge_aura/aura_check_bullet(obj/item/projectile/proj, def_zone	)
	if (proj.damtype == DAMAGE_BURN)
		proj.damage *= 2
	else if (proj.agony || proj.stun)
		return AURA_FALSE
	return EMPTY_BITFIELD
