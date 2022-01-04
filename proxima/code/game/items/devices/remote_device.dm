#define REMOTE_OPEN "Open Door"
#define REMOTE_BOLT "Toggle Bolts"
#define REMOTE_ELECT "Electrify Door"

/obj/item/device/remote_device
	name = "door remote"
	desc = "Remotely controls airlocks."
	icon = 'proxima/icons/obj/remote_device.dmi'
	icon_state = "gangtool-white"
	item_state = "electronic"
	w_class = ITEM_SIZE_TINY
	var/mode = REMOTE_OPEN
	var/region_access = ACCESS_REGION_NONE
	var/obj/item/card/id/ID
	var/emagged = FALSE
	var/disabled = FALSE
	var/safety = TRUE

/obj/item/device/remote_device/Initialize()
	. = ..()
	create_access()

/obj/item/device/remote_device/proc/create_access(var/obj/item/card/id/user_id)
	QDEL_NULL(ID)
	ID = new /obj/item/card/id
	ID.access = list()

	for(var/access in region_access)
		ID.access += get_region_accesses(access)

	if(user_id?.access && !safety)
		ID.access |= user_id.access

/obj/item/device/remote_device/Destroy()
	QDEL_NULL(ID)
	return ..()

/obj/item/device/remote_device/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/card/id))
		var/obj/item/card/id/ID = I
		if((ID.access && region_access) && (ID.access & region_access))
			safety = !safety
			to_chat(user, SPAN_NOTICE("You swipe your indefication card on \the [src]. The safety lock [safety ? "has been reset" : "off"]."))
			var/static/list/beepsounds = list(
				'sound/effects/compbeep1.ogg','sound/effects/compbeep2.ogg', \
				'sound/effects/compbeep3.ogg','sound/effects/compbeep4.ogg', \
				'sound/effects/compbeep5.ogg')
			playsound(src.loc, pick(beepsounds),15,1,10)
			create_access(ID)

	if(istype(I, /obj/item/card/emag) && !emagged)
		safety = FALSE
		emagged = TRUE
		to_chat(user, "This device now can electrify doors.")

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	return

/obj/item/device/remote_device/attack_self(mob/user)
	if(mode == REMOTE_OPEN)
		if(emagged)
			mode = REMOTE_ELECT
		else mode = REMOTE_BOLT
	else if(mode == REMOTE_BOLT)
		mode = REMOTE_OPEN
	else if(mode == REMOTE_ELECT)
		mode = REMOTE_BOLT
	to_chat(user, "Now in mode: [mode].")

/obj/item/device/remote_device/afterattack(obj/machinery/door/airlock/D, mob/user)
	if(!istype(D) || safety || disabled || user.client.eye != user.client.mob)
		return
	if(!(D.arePowerSystemsOn()))
		to_chat(user, "<span class='danger'>[D] has no power!</span>")
		return
	if(!D.requiresID())
		to_chat(user, "<span class='danger'>[D]'s ID scan is disabled!</span>")
		return
	if(D.check_access(ID) && D.canAIControl(user))
		switch(mode)
			if(REMOTE_OPEN)
				if(D.density)
					D.open()
				else
					D.close()
			if(REMOTE_BOLT)
				if(D.locked)
					D.unlock()
				else
					D.lock()
			if(REMOTE_ELECT)
				if(D.electrified_until > 0)
					D.electrified_until = 0
				else
					D.electrified_until = 10
	else
		to_chat(user, "<span class='danger'>[src] does not have access to this door.</span>")

/obj/item/device/remote_device/omni
	name = "omni door remote"
	desc = "This remote control device can access any door on the facility."
	icon_state = "gangtool-yellow"
	safety = FALSE
	region_access = ACCESS_REGION_ALL

/obj/item/device/remote_device/captain
	name = "command door remote"
	icon_state = "gangtool-yellow"
	region_access = ACCESS_REGION_COMMAND

/obj/item/device/remote_device/chief_engineer
	name = "engineering door remote"
	icon_state = "gangtool-orange"
	region_access = ACCESS_REGION_ENGINEERING

/obj/item/device/remote_device/research_director
	name = "research door remote"
	icon_state = "gangtool-purple"
	region_access = ACCESS_REGION_RESEARCH

/obj/item/device/remote_device/head_of_security
	name = "security door remote"
	icon_state = "gangtool-red"
	region_access = ACCESS_REGION_SECURITY

/obj/item/device/remote_device/quartermaster
	name = "supply door remote"
	icon_state = "gangtool-green"
	region_access = ACCESS_REGION_SUPPLY

/obj/item/device/remote_device/chief_medical_officer
	name = "medical door remote"
	icon_state = "gangtool-blue"
	region_access = ACCESS_REGION_MEDBAY

/obj/item/device/remote_device/civillian
	name = "civillian door remote"
	icon_state = "gangtool-white"
	region_access = ACCESS_REGION_SERVICE

#undef REMOTE_OPEN
#undef REMOTE_BOLT
#undef REMOTE_ELECT
