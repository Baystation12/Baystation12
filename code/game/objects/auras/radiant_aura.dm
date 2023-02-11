/obj/aura/radiant_aura
	name = "radiant aura"
	icon = 'icons/effects/effects.dmi'
	icon_state = "fire_goon"
	layer = ABOVE_WINDOW_LAYER

/obj/aura/radiant_aura/added_to(mob/living/L)
	..()
	to_chat(L,SPAN_NOTICE("A bubble of light appears around you, exuding protection and warmth."))
	set_light(6, 6, "#e09d37")

/obj/aura/radiant_aura/removed()
	to_chat(user, SPAN_WARNING("Your protective aura dissipates, leaving you feeling cold and unsafe."))
	..()

/obj/aura/radiant_aura/aura_check_bullet(obj/item/projectile/proj, def_zone)
	if (HAS_FLAGS(proj.damage_flags(), DAMAGE_FLAG_LASER))
		user.visible_message(SPAN_WARNING("\The [proj] refracts, bending into \the [user]'s aura."))
		return AURA_FALSE
	return EMPTY_BITFIELD
