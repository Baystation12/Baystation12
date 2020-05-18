/obj/aura/personal_shield
	name = "personal shield"

/obj/aura/personal_shield/added_to(var/mob/living/L)
	..()
	playsound(user,'sound/weapons/flash.ogg',35,1)
	to_chat(user,"<span class='notice'>You feel your body prickle as \the [src] comes online.</span>")

/obj/aura/personal_shield/bullet_act(var/obj/item/projectile/P, var/def_zone)
	user.visible_message("<span class='warning'>\The [user]'s [src.name] flashes before \the [P] can hit them!</span>")
	new /obj/effect/temporary(get_turf(src), 2 SECONDS,'icons/obj/machines/shielding.dmi',"shield_impact")
	playsound(user,'sound/effects/basscannon.ogg',35,1)
	return AURA_FALSE|AURA_CANCEL

/obj/aura/personal_shield/removed()
	to_chat(user,"<span class='warning'>\The [src] goes offline!</span>")
	playsound(user,'sound/mecha/internaldmgalarm.ogg',25,1)
	..()

/obj/aura/personal_shield/device
	var/obj/item/device/personal_shield/shield

/obj/aura/personal_shield/device/bullet_act()
	. = ..()
	if(shield)
		shield.take_charge()

/obj/aura/personal_shield/device/New(var/mob/living/user, var/user_shield)
	..()
	shield = user_shield

/obj/aura/personal_shield/device/Destroy()
	shield = null
	return ..()