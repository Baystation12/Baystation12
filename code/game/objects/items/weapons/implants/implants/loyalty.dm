/obj/item/weapon/implant/loyalty
	name = "loyalty implant"
	desc = "Makes you loyal or such."
	known = 1

/obj/item/weapon/implant/loyalty/get_data()
	return {"
	<b>Implant Specifications:</b><BR>
	<b>Name:</b> [GLOB.using_map.company_name] Employee Management Implant<BR>
	<b>Life:</b> Ten years.<BR>
	<b>Important Notes:</b> Personnel injected with this device tend to be much more loyal to the company.<BR>
	<HR>
	<b>Implant Details:</b><BR>
	<b>Function:</b> Contains a small pod of nanobots that manipulate the host's mental functions.<BR>
	<b>Special Features:</b> Will prevent and cure most forms of brainwashing.<BR>
	<b>Integrity:</b> Implant will last so long as the nanobots are inside the bloodstream."}

/obj/item/weapon/implant/loyalty/implanted(mob/M)
	if(!istype(M, /mob/living/carbon/human))	return FALSE
	var/mob/living/carbon/human/H = M
	var/datum/antagonist/antag_data = get_antag_data(H.mind.special_role)
	if(antag_data && (antag_data.flags & ANTAG_IMPLANT_IMMUNE))
		H.visible_message("[H] seems to resist the implant!", "You feel the corporate tendrils of [GLOB.using_map.company_name] try to invade your mind!")
		return FALSE
	else
		clear_antag_roles(H.mind, 1)
		to_chat(H, "<span class='notice'>You feel a surge of loyalty towards [GLOB.using_map.company_name].</span>")
	return TRUE

/obj/item/weapon/implanter/loyalty
	name = "implanter-loyalty"
	imp = /obj/item/weapon/implant/loyalty

/obj/item/weapon/implantcase/loyalty
	name = "glass case - 'loyalty'"
	imp = /obj/item/weapon/implant/loyalty