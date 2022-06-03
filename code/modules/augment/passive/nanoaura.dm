/obj/item/organ/internal/augment/active/nanounit
	name = "Nanite MCU"
	augment_slots = AUGMENT_CHEST
	icon_state = "armor-chest"
	desc = "Nanomachines, son."
	action_button_name = "Toggle Nanomachines"
	var/obj/aura/nanoaura/aura
	var/charges = 4


/obj/item/organ/internal/augment/active/nanounit/onInstall()
	aura = new /obj/aura/nanoaura (owner, src)


/obj/item/organ/internal/augment/active/nanounit/onRemove()
	QDEL_NULL(aura)
	..()


/obj/item/organ/internal/augment/active/nanounit/proc/catastrophic_failure()
	playsound(owner,'sound/mecha/internaldmgalarm.ogg',25,1)
	owner.visible_message(SPAN_WARNING("The nanites attempt to harden. But they seem... brittle."))
	for(var/obj/item/organ/external/E in owner.organs)
		if (prob(25))
			E.status |= ORGAN_BRITTLE
			to_chat(owner, SPAN_DANGER("Your [E.name] feels cold and rigid"))
	QDEL_NULL(aura)


/obj/item/organ/internal/augment/active/nanounit/activate()
	if(!aura || !can_activate())
		return
	if(aura.active)
		aura.active = FALSE
		to_chat(owner, SPAN_NOTICE("Nanites entering sleep mode."))
	else
		aura.active = TRUE
		to_chat(owner, SPAN_NOTICE("Activation sequence in progress."))
	playsound(owner, 'sound/weapons/flash.ogg', 35, 1)


/obj/item/organ/internal/augment/active/nanounit/Destroy()
	. = ..()
	QDEL_NULL(aura)


/obj/aura/nanoaura
	name = "Nanoaura"
	var/obj/item/organ/internal/augment/active/nanounit/unit
	var/active


/obj/aura/nanoaura/Initialize(maploading, obj/item/organ/internal/augment/active/nanounit/holder)
	. = ..()
	unit = holder
	playsound(loc, 'sound/weapons/flash.ogg',35,1)
	to_chat(loc, SPAN_NOTICE("Your skin tingles as the nanites spread over your body."))


/obj/aura/nanoaura/bullet_act(obj/item/projectile/P, def_zone)
	if (!active)
		return
	if (unit.charges > 0)
		user.visible_message(SPAN_WARNING("The nanomachines harden as a response to physical trauma!"))
		playsound(user, 'sound/effects/basscannon.ogg',35,1)
		unit.charges -= 1
		if (unit.charges <= 0)
			to_chat(user, SPAN_DANGER("Warning: Critical damage treshold passed. Shut down unit to avoid further damage"))
		return AURA_FALSE | AURA_CANCEL
	unit.catastrophic_failure()


/obj/aura/nanoaura/Destroy()
	to_chat(user, SPAN_WARNING("\The nanites dissolve!"))
	unit = null
	return ..()
