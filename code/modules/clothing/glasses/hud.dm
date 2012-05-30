//This file was auto-corrected by findeclaration.exe on 29/05/2012 15:03:05

/obj/item/clothing/glasses/hud
	name = "HUD"
	desc = "A heads-up display that provides important info in (almost) real time."
	flags = null //doesn't protect eyes because it's a monocle, duh
	origin_tech = "magnets=3;biotech=2"
	var/list/icon/current = list() //the current hud icons

	proc
		process_hud(var/mob/M)	return



/obj/item/clothing/glasses/hud/health
	name = "Health Scanner HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their health status."
	icon_state = "healthhud"
	proc
		RoundHealth(health)


	RoundHealth(health)
		switch(health)
			if(100 to INFINITY)
				return "health100"
			if(90 to 100)
				return "health90"
			if(80 to 90)
				return "health80"
			if(70 to 80)
				return "health70"
			if(60 to 70)
				return "health60"
			if(50 to 60)
				return "health50"
			if(40 to 50)
				return "health40"
			if(30 to 40)
				return "health30"
			if(20 to 30)
				return "health20"
			if(10 to 20)
				return "health10"
			if(0 to 10)
				return "health1"
			if(-50 to 0)
				return "health-50"
			if(-99 to -50)
				return "health-99"
			else
				return "health-100"
		return "0"


	process_hud(var/mob/M)
		if(!M)	return
		if(!M.client)	return
		var/client/C = M.client
		for(var/mob/living/carbon/human/patient in view(M))
			var/foundVirus = 0
			for(var/datum/disease/D in patient.viruses)
				if(!D.hidden[SCANNER])
					foundVirus++

			// jesus fuck, no, don't display vira by just looking at them
			/*if(patient.virus2)
				foundVirus++*/
			patient.health_img.icon_state = "hud[RoundHealth(patient.health)]"
			C.images += patient.health_img
			if(patient.stat == 2)
				patient.med_img.icon_state = "huddead"
			else if(patient.alien_egg_flag)
				patient.med_img.icon_state = "hudxeno"
			else if(foundVirus)
				patient.med_img.icon_state = "hudill"
			else
				patient.med_img.icon_state = "hudhealthy"
			C.images += patient.med_img


/obj/item/clothing/glasses/hud/security
	name = "Security HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their ID status and security records."
	icon_state = "securityhud"

/obj/item/clothing/glasses/hud/security/jensenshades
	name = "Augmented shades"
	desc = "Polarized bioneural eyewear, designed to augment your vision."
	icon_state = "jensenshades"
	item_state = "jensenshades"
	protective_temperature = 1500
	vision_flags = SEE_MOBS
	invisa_view = 2

/obj/item/clothing/glasses/hud/security/process_hud(var/mob/M)
	if(!M)	return
	if(!M.client)	return
	var/client/C = M.client
	for(var/mob/living/carbon/human/perp in view(M))
		if(!C) continue
		var/perpname = "wot"
		if(perp.wear_id)
			perp.sec_img.icon_state = "hud[ckey(perp:wear_id:GetJobName())]"
			C.images += perp.sec_img
			if(istype(perp.wear_id,/obj/item/weapon/card/id))
				perpname = perp.wear_id:registered_name
			else if(istype(perp.wear_id,/obj/item/device/pda))
				var/obj/item/device/pda/tempPda = perp.wear_id
				perpname = tempPda.owner
			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.security)
						if ((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "*Arrest*"))
							perp.sec2_img.icon_state = "hudwanted"
							C.images += perp.sec2_img
							break
						else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Incarcerated"))
							perp.sec2_img.icon_state = "hudprisoner"
							C.images += perp.sec2_img
							break
		else
			perp.sec_img.icon_state = "hudunknown"
			C.images += perp.sec_img

		for(var/named in perp.organs)
			var/datum/organ/external/E = perp.organs[named]
			for(var/obj/item/weapon/implant/I in E.implant)
				if(I.implanted)
					if(istype(I,/obj/item/weapon/implant/tracking))
						perp.imp_img.icon_state = "hud_imp_tracking"
						C.images += perp.imp_img
					if(istype(I,/obj/item/weapon/implant/loyalty))
						perp.imp_img.icon_state = "hud_imp_loyal"
						C.images += perp.imp_img


