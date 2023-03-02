/obj/aura/starborn
	name = "starborn's gift"
	icon = 'icons/effects/effects.dmi'
	icon_state = "white_electricity_constant"
	color = "#33cc33"
	layer = MOB_LAYER

/obj/aura/starborn/aura_check_bullet(obj/item/projectile/proj, def_zone)
	if (proj.damage_type == DAMAGE_BURN)
		user.visible_message(SPAN_WARNING("\The [proj] seems to only make \the [user] stronger."))
		user.adjustBruteLoss(-proj.damage)
		return AURA_FALSE
	return EMPTY_BITFIELD

/obj/aura/starborn/aura_check_weapon(obj/item/weapon, mob/attacker, click_params)
	if (weapon.damtype == DAMAGE_BURN)
		user.visible_message(SPAN_WARNING("\The [weapon] seems to only feed into \the [user]'s flames."))
		user.adjustBruteLoss(-weapon.force)
		return AURA_FALSE
	return EMPTY_BITFIELD
