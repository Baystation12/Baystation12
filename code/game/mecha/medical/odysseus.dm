/obj/mecha/medical/odysseus
	desc = "These exosuits are developed and produced by Vey-Med. (&copy; All rights reserved)."
	name = "Odysseus"
	icon_state = "odysseus"
	initial_icon = "odysseus"
	step_in = 2
	max_temperature = 15000
	health = 120
	wreckage = /obj/effect/decal/mecha_wreckage/odysseus
	internal_damage_threshold = 35
	deflect_chance = 15
	var/obj/item/clothing/glasses/hud/health/mech/hud

	New()
		..()
		hud = new /obj/item/clothing/glasses/hud/health/mech(src)
		return

	moved_inside(var/mob/living/carbon/human/H as mob)
		if(..())
			if(H.glasses)
				occupant_message("<font color='red'>[H.glasses] prevent you from using [src] [hud]</font>")
			else
				H.glasses = hud
			return 1
		else
			return 0

	go_out()
		if(ishuman(occupant))
			var/mob/living/carbon/human/H = occupant
			if(H.glasses == hud)
				H.glasses = null
		..()
		return
/*
	verb/set_perspective()
		set name = "Set client perspective."
		set category = "Exosuit Interface"
		set src = usr.loc
		var/perspective = input("Select a perspective type.",
                      "Client perspective",
                      occupant.client.perspective) in list(MOB_PERSPECTIVE,EYE_PERSPECTIVE)
		log_debug("[perspective]")

		occupant.client.perspective = perspective
		return

	verb/toggle_eye()
		set name = "Toggle eye."
		set category = "Exosuit Interface"
		set src = usr.loc
		if(occupant.client.eye == occupant)
			occupant.client.eye = src
		else
			occupant.client.eye = occupant
		log_debug("[occupant.client.eye]")

		return
*/

//TODO - Check documentation for client.eye and client.perspective...
/obj/item/clothing/glasses/hud/health/mech
	name = "Integrated Medical Hud"


	process_hud(var/mob/M)
/*
		log_debug("view(M)")

		for(var/mob/mob in view(M))
			log_debug("[mob]")

		log_debug("view(M.client)")

		for(var/mob/mob in view(M.client))
			log_debug("[mob]")

		log_debug("view(M.loc)")

		for(var/mob/mob in view(M.loc))
			log_debug("[mob]")

*/

		if(!M || M.stat || !(M in view(M)))	return
		if(!M.client)	return
		var/client/C = M.client
		var/image/holder
		for(var/mob/living/carbon/human/patient in view(M.loc))
			if(M.see_invisible < patient.invisibility)
				continue
			var/foundVirus = 0

			for (var/ID in patient.virus2)
				if (ID in virusDB)
					foundVirus = 1
					break

			holder = patient.hud_list[HEALTH_HUD]
			if(patient.stat == DEAD)
				holder.icon_state = "hudhealth-100"
				C.images += holder
			else
				holder.icon_state = "hudhealth-100" // TODO
				C.images += holder

			holder = patient.hud_list[STATUS_HUD]
			if(patient.stat == DEAD)
				holder.icon_state = "huddead"
			else if(patient.status_flags & XENO_HOST)
				holder.icon_state = "hudxeno"
			else if(foundVirus)
				holder.icon_state = "hudill"
			else if(patient.has_brain_worms())
				var/mob/living/simple_animal/borer/B = patient.has_brain_worms()
				if(B.controlling)
					holder.icon_state = "hudbrainworm"
				else
					holder.icon_state = "hudhealthy"
			else
				holder.icon_state = "hudhealthy"

			C.images += holder

/obj/mecha/medical/odysseus/loaded/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/tool/sleeper
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tool/sleeper
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tool/syringe_gun
	ME.attach(src)