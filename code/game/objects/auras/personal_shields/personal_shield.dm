/obj/aura/personal_shield
	name = "personal shield"

/obj/aura/personal_shield/added_to(mob/living/L)
	..()
	playsound(user,'sound/weapons/flash.ogg',35,1)
	to_chat(user,SPAN_NOTICE("You feel your body prickle as \the [src] comes online."))

/obj/aura/personal_shield/aura_check_bullet(obj/item/projectile/proj, def_zone)
	user.visible_message(SPAN_WARNING("\The [user]'s [name] flashes before \the [proj] can hit them!"))
	new /obj/temporary(get_turf(src), 2 SECONDS,'icons/obj/machines/shielding.dmi',"shield_impact")
	playsound(user,'sound/effects/basscannon.ogg',35,1)
	return AURA_FALSE|AURA_CANCEL

/obj/aura/personal_shield/removed()
	to_chat(user,SPAN_WARNING("\The [src] goes offline!"))
	playsound(user,'sound/mecha/internaldmgalarm.ogg',25,1)
	..()

/obj/aura/personal_shield/device
	var/obj/item/device/personal_shield/shield

/obj/aura/personal_shield/device/aura_check_bullet(obj/item/projectile/proj, def_zone)
	. = ..()
	if(shield)
		shield.take_charge()

/obj/aura/personal_shield/device/New(mob/living/user, user_shield)
	..()
	shield = user_shield

/obj/aura/personal_shield/device/Destroy()
	shield = null
	return ..()
