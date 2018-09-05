/obj/aura/nanoaura
	name = "Nanoaura"

/obj/aura/nanoaura/New(var/mob/living/user)
	..()
	playsound(user,'sound/weapons/flash.ogg',35,1)
	to_chat(user,SPAN_NOTICE("Your skin tingles as the nanites spread over your body."))

/obj/aura/nanoaura/bullet_act(var/obj/item/projectile/P, var/def_zone)
	user.visible_message(SPAN_WARNING("The nanomachines harden as a response to physical trauma!"))
	playsound(user,'sound/effects/basscannon.ogg',35,1)
	return AURA_FALSE|AURA_CANCEL

/obj/aura/nanoaura/Destroy()
	to_chat(user, SPAN_WARNING("\The nanites dissolve!"))
	playsound(user,'sound/mecha/internaldmgalarm.ogg',25,1)
	return ..()





//The organ itself

/obj/item/organ/internal/augment/nanounit
	name = "Nanite MCU"
	allowed_organs = list(BP_CHEST)
	icon_state = "armor-chest"
	desc = "Nanomachines, son"
	var/obj/aura/nanoaura = null


/obj/item/organ/internal/augment/nanounit/onInstall()
	nanoaura = new /obj/aura/nanoaura(owner)

/obj/item/organ/internal/augment/nanounit/onRemove()
	QDEL_NULL(nanoaura)
