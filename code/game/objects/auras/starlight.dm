/obj/aura/starborn
	name = "starborn's gift"
	icon = 'icons/effects/effects.dmi'
	icon_state = "white_electricity_constant"
	color = "#33cc33"
	layer = MOB_LAYER

/obj/aura/starborn/bullet_act(obj/item/projectile/P, def_zone)
	if (P.damage_type == DAMAGE_BURN)
		user.visible_message("<span class='warning'>\The [P] seems to only make \the [user] stronger.</span>")
		user.adjustBruteLoss(-P.damage)
		return AURA_FALSE
	return 0

/obj/aura/starborn/attackby(obj/item/I, mob/i_user)
	if(I.damtype == DAMAGE_BURN)
		to_chat(i_user, "<span class='warning'>\The [I] seems to only feed into \the [user]'s flames.</span>")
		user.adjustBruteLoss(-I.force)
		return AURA_FALSE
	return 0
