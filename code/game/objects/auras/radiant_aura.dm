/obj/aura/radiant_aura
	name = "radiant aura"
	icon = 'icons/effects/effects.dmi'
	icon_state = "fire_goon"
	plane = LYING_MOB_PLANE - 1

/obj/aura/radiant_aura/New()
	..()
	to_chat(user,"<span class='notice'>A bubble of light appears around you, exuding protection and warmth.</span>")
	set_light(6,6, "#e09d37")

/obj/aura/radiant_aura/Destroy()
	to_chat(user, "<span class='warning'>Your protective aura dissipates, leaving you feeling cold and unsafe.</span>")
	return ..()

/obj/aura/radiant_aura/bullet_act(var/obj/item/projectile/P, var/def_zone)
	if(P.check_armour == "laser")
		user.visible_message("<span class='warning'>\The [P] refracts, bending into \the [user]'s aura.</span>")
		return AURA_FALSE
	return 0