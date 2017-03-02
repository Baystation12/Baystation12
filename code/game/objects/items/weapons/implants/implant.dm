#define MALFUNCTION_TEMPORARY 1
#define MALFUNCTION_PERMANENT 2


/obj/item/weapon/implant
	name = "implant"
	icon = 'icons/obj/device.dmi'
	icon_state = "implant"
	w_class = ITEM_SIZE_TINY
	var/implanted = null
	var/mob/imp_in = null
	var/obj/item/organ/external/part = null
	var/implant_color = "b"
	var/malfunction = 0

/obj/item/weapon/implant/proc/trigger(emote, source)
	return

/obj/item/weapon/implant/proc/hear(message)
	return

/obj/item/weapon/implant/proc/activate()
	return

// What does the implant do upon injection?
// return 0 if the implant fails (ex. Revhead and loyalty implant.)
// return TRUE if the implant succeeds (ex. Nonrevhead and loyalty implant.)
/obj/item/weapon/implant/proc/implanted(var/mob/source)
	return TRUE

/obj/item/weapon/implant/proc/can_implant(mob/M, mob/user, var/target_zone)
	var/mob/living/carbon/human/H = M
	if(istype(H) && !H.get_organ(target_zone))
		to_chat(user, "<span class='warning'>\The [M] is missing that body part.</span>")
		return FALSE
	return TRUE

/obj/item/weapon/implant/proc/implant_in_mob(mob/M, var/target_zone)
	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affected = H.get_organ(target_zone)
		if(affected)
			affected.implants += src
			part = affected

		BITSET(H.hud_updateflag, IMPLOYAL_HUD)

	forceMove(M)
	imp_in = M
	implanted = 1
	implanted(M)

	return TRUE

/obj/item/weapon/implant/proc/removed()
	imp_in = null
	if(part)
		part.implants -= src
		part = null
	implanted = 0

//Called in surgery when incision is retracted open / ribs are opened - basically before you can take implant out
/obj/item/weapon/implant/proc/exposed()
	return

/obj/item/weapon/implant/proc/get_data()
	return "No information available"

/obj/item/weapon/implant/interact(user)
	var/datum/browser/popup = new(user, capitalize(name), capitalize(name), 300, 700, src)
	var/dat = get_data()
	if(malfunction)
		popup.title = "??? implant"
		dat = stars(dat,10)
	popup.set_content(dat)
	popup.open()

/obj/item/weapon/implant/proc/islegal()
	return FALSE

/obj/item/weapon/implant/proc/meltdown()	//breaks it down, making implant unrecongizible
	to_chat(imp_in, "<span class='warning'>You feel something melting inside [part ? "your [part.name]" : "you"]!</span>")
	if (part)
		part.take_damage(burn = 15, used_weapon = "Electronics meltdown")
	else
		var/mob/living/M = imp_in
		M.apply_damage(15,BURN)
	name = "melted implant"
	desc = "Charred circuit in melted plastic case. Wonder what that used to be..."
	icon_state = "implant_melted"
	malfunction = MALFUNCTION_PERMANENT

/obj/item/weapon/implant/Destroy()
	if(part)
		part.implants.Remove(src)
	return ..()