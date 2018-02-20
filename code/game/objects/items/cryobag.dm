
/obj/item/bodybag/cryobag
	name = "stasis bag"
	desc = "A folded, non-reusable bag designed to prevent additional damage to an occupant, especially useful if short on time or in \
	a hostile enviroment."
	icon = 'icons/obj/cryobag.dmi'
	icon_state = "bodybag_folded"
	origin_tech = list(TECH_BIO = 4)
	var/stasis_power

/obj/item/bodybag/cryobag/attack_self(mob/user)
	var/obj/structure/closet/body_bag/cryobag/R = new /obj/structure/closet/body_bag/cryobag(user.loc)
	if(stasis_power)
		R.stasis_power = stasis_power
	R.update_icon()
	R.add_fingerprint(user)
	qdel(src)

/obj/structure/closet/body_bag/cryobag
	name = "stasis bag"
	desc = "A non-reusable plastic bag designed to prevent additional damage to an occupant, especially useful if short on time or in \
	a hostile enviroment."
	icon = 'icons/obj/cryobag.dmi'
	item_path = /obj/item/bodybag/cryobag

	storage_types = CLOSET_STORAGE_MOBS
	var/datum/gas_mixture/airtank

	var/stasis_power = 20
	var/degradation_time = 150 //ticks until stasis power degrades, ~5 minutes

/obj/structure/closet/body_bag/cryobag/Initialize()
	. = ..()
	airtank = new()
	airtank.temperature = T0C
	airtank.adjust_gas("oxygen", MOLES_O2STANDARD, 0)
	airtank.adjust_gas("nitrogen", MOLES_N2STANDARD)
	update_icon()

/obj/structure/closet/body_bag/cryobag/Destroy()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(airtank)
	return ..()

/obj/structure/closet/body_bag/cryobag/Entered(atom/movable/AM)
	if(ishuman(AM))
		START_PROCESSING(SSobj, src)
	..()

/obj/structure/closet/body_bag/cryobag/Exited(atom/movable/AM)
	if(ishuman(AM))
		STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/structure/closet/body_bag/cryobag/update_icon()
	..()
	overlays.Cut()
	var/image/I = image(icon, "indicator[opened]")
	I.appearance_flags = RESET_COLOR
	var/maxstasis = initial(stasis_power)
	if(stasis_power > 0.5 * maxstasis)
		I.color = COLOR_LIME
	else if(stasis_power)
		I.color = COLOR_YELLOW
	else
		I.color = COLOR_RED
	overlays += I

/obj/structure/closet/body_bag/cryobag/proc/get_saturation()
	return -155 * (1 - stasis_power/initial(stasis_power))

/obj/structure/closet/body_bag/cryobag/fold(var/user)
	var/obj/item/bodybag/cryobag/folded = ..()
	if(istype(folded))
		folded.stasis_power = stasis_power
		folded.color = color_saturation(get_saturation())

/obj/structure/closet/body_bag/cryobag/Process()
	if(stasis_power < 2)
		return PROCESS_KILL
	var/mob/living/carbon/human/H = locate() in src
	if(!H)
		return PROCESS_KILL
	degradation_time--
	if(degradation_time < 0)
		degradation_time = initial(degradation_time)
		stasis_power = round(0.75 * stasis_power)
		animate(src, color = color_saturation(get_saturation()), time = 10)
		update_icon()

	if(H.stasis_sources[STASIS_CRYOBAG] != stasis_power)
		H.SetStasis(stasis_power, STASIS_CRYOBAG)

/obj/structure/closet/body_bag/cryobag/return_air() //Used to make stasis bags protect from vacuum.
	if(airtank)
		return airtank
	..()

/obj/structure/closet/body_bag/cryobag/examine(mob/user)
	. = ..()
	to_chat(user,"The stasis meter shows '[stasis_power]x'.")
	if(Adjacent(user)) //The bag's rather thick and opaque from a distance.
		to_chat(user, "<span class='info'>You peer into \the [src].</span>")
		for(var/mob/living/L in contents)
			L.examine(user)

/obj/item/usedcryobag
	name = "used stasis bag"
	desc = "Pretty useless now.."
	icon_state = "bodybag_used"
	icon = 'icons/obj/cryobag.dmi'