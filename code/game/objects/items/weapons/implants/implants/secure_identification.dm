/obj/item/weapon/implant/sic
	name = "secure identification chip implant"
	desc = "Connecting you to the shared consciousness."
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 2, TECH_DATA = 3)
	hidden = 1

	var/unique_id = ""
	var/alias = ""
	var/ignored = FALSE
	var/max_bill = 3000
	var/current_bill = 0
	var/free_messaging = FALSE

/obj/item/weapon/implant/sic/get_data()
	. = {"
	<b>Implant Specifications:</b><BR>
	<b>Name:</b> Secure Identification Chip Implant<BR>
	<b>Life:</b> 1 lifetime.<BR>
	<HR>"}

/obj/item/weapon/implant/sic/Topic(href, href_list)
	..()

/obj/item/weapon/implant/sic/implanted(mob/M)
	var/mob/living/carbon/human/H = M
	if(!istype(H))
		return FALSE
	return TRUE

/obj/item/weapon/implant/sic/removed()
	if(!malfunction)
		to_chat(imp_in,"<span class='warning'>A wave of nausea comes over you.</span><br><span class='good'>Silence washes over you, no longer hearing the voices of millions in your head.</span>")
	..()

/obj/item/weapon/implant/sic/emp_act(severity)
	var/power = 4 - severity
	if(prob(power * 15))
		meltdown()
	else if(prob(power * 40))
		disable(rand(power*1000,power*10000)) // oh shit, implant temporarily disabled

/obj/item/weapon/implant/sic/meltdown()
	if(!malfunction)//if it's already broken don't send the message again
		to_chat(imp_in,"<span class='warning'>A wave of nausea comes over you.</span><br><span class='good'>Silence washes over you, no longer hearing the voices of millions in your head.</span>")
	. = ..()

/obj/item/weapon/implant/sic/can_implant(mob/M, mob/user, target_zone)
	var/mob/living/carbon/human/H = M
	if(istype(H))
		var/obj/item/organ/internal/B = H.internal_organs_by_name[BP_BRAIN]
		if(!B || H.isSynthetic())
			to_chat(user, "<span class='warning'>\The [M] cannot be implanted.</span>")
			return FALSE
		if(!(B.parent_organ == check_zone(target_zone)))
			to_chat(user, "<span class='warning'>\The [src] must be implanted in [H.get_organ(B.parent_organ)].</span>")
			return FALSE
	return TRUE

/obj/item/weapon/implanter/sic
	name = "secure identification chip implanter"
	imp = /obj/item/weapon/implant/sic

/obj/item/weapon/implantcase/sic
	name = "glass case - 'secure identification chip'"
	imp = /obj/item/weapon/implant/sic