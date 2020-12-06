/obj/aura/blueforge_aura
	name = "Blueforge Aura"
	icon = 'icons/mob/human_races/species/eyes.dmi'
	icon_state = "eyes_blueforged_s"
	layer = MOB_LAYER

/obj/aura/blueforge_aura/life_tick()
	user.adjustToxLoss(-10)
	return 0

/obj/aura/blueforge_aura/bullet_act(var/obj/item/projectile/P)
	if(P.damtype == BURN)
		P.damage *=2
	else if(P.agony || P.stun)
		return AURA_FALSE
	return 0