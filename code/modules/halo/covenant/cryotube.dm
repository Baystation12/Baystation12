
/obj/machinery/atmospherics/unary/cryo_cell/covenant
	icon = 'cryotube.dmi'
	icon_state = "pod_preview"

/obj/machinery/atmospherics/unary/cryo_cell/covenant/put_mob(mob/living/carbon/M as mob)
	var/fail = 0
	if(istype(M) && M.species.type in COVENANT_SPECIES_AND_MOBS)
		fail = 1
	if(M.type in COVENANT_SPECIES_AND_MOBS)
		fail = 1
	if(fail)
		to_chat(usr, "<span class='warning'>[src] is not designed to fit [M]'s species!</span>")
		return

	. = ..()
