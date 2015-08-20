/mob/living/carbon/human/handle_vision()
	..()
	if(stat == DEAD)
		sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS|SEE_SELF
		see_in_dark = 8
		if(!druggy)		see_invisible = SEE_INVISIBLE_LEVEL_TWO
		return

	sight &= ~(SEE_TURFS|SEE_MOBS|SEE_OBJS)
	see_invisible = see_in_dark>2 ? SEE_INVISIBLE_LEVEL_ONE : SEE_INVISIBLE_LIVING

	if(XRAY in mutations)
		sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS
		see_in_dark = 8
		if(!druggy)		see_invisible = SEE_INVISIBLE_LEVEL_TWO

	if(seer)
		var/obj/effect/rune/R = locate() in loc
		if(R && R.word1 == cultwords["see"] && R.word2 == cultwords["hell"] && R.word3 == cultwords["join"])
			see_invisible = SEE_INVISIBLE_CULT
		else
			see_invisible = SEE_INVISIBLE_LIVING
			seer = 0
	else
		sight = species.vision_flags
		see_in_dark = species.darksight
		see_invisible = see_in_dark>2 ? SEE_INVISIBLE_LEVEL_ONE : SEE_INVISIBLE_LIVING

	// TODO: Better glasses handling here. Look at the see_invisible handling above
	/*
	var/tmp/glasses_processed = 0
	var/obj/item/weapon/rig/rig = back
	if(istype(rig) && rig.visor)
		if(!rig.helmet || (head && rig.helmet == head))
			if(rig.visor && rig.visor.vision && rig.visor.active && rig.visor.vision.glasses)
				glasses_processed = 1
				process_glasses(rig.visor.vision.glasses)

	if(glasses && !glasses_processed)
		glasses_processed = 1
		process_glasses(glasses)

	if(!glasses_processed && (species.vision_flags > 0))
		sight |= species.vision_flags
	if(!seer && !glasses_processed)
		see_invisible = SEE_INVISIBLE_LIVING
	if(!seer)
		see_invisible = SEE_INVISIBLE_LIVING*/

/mob/living/carbon/human/proc/process_glasses(var/obj/item/clothing/glasses/G)
	if(G && G.active)
		see_in_dark += G.darkness_view
		if(G.overlay)
			client.screen |= G.overlay
		if(G.vision_flags)
			sight |= G.vision_flags
			if(!druggy && !seer)
				see_invisible = SEE_INVISIBLE_MINIMUM
		if(G.see_invisible >= 0)
			see_invisible = G.see_invisible
		if(istype(G,/obj/item/clothing/glasses/night) && !seer)
			see_invisible = SEE_INVISIBLE_MINIMUM
/* HUD shit goes here, as long as it doesn't modify sight flags */
// The purpose of this is to stop xray and w/e from preventing you from using huds -- Love, Doohl
		var/obj/item/clothing/glasses/hud/O = G
		if(istype(G, /obj/item/clothing/glasses/sunglasses/sechud))
			var/obj/item/clothing/glasses/sunglasses/sechud/S = G
			O = S.hud
		if(istype(O))
			O.process_hud(src)
			if(!druggy && !seer)	see_invisible = SEE_INVISIBLE_LIVING

/mob/living/carbon/human/handle_hud_icons()
	..()
	if(!overlays_cache)
		overlays_cache = list()
		overlays_cache.len = 23
		overlays_cache[1] = image('icons/mob/screen1_full.dmi', "icon_state" = "passage1")
		overlays_cache[2] = image('icons/mob/screen1_full.dmi', "icon_state" = "passage2")
		overlays_cache[3] = image('icons/mob/screen1_full.dmi', "icon_state" = "passage3")
		overlays_cache[4] = image('icons/mob/screen1_full.dmi', "icon_state" = "passage4")
		overlays_cache[5] = image('icons/mob/screen1_full.dmi', "icon_state" = "passage5")
		overlays_cache[6] = image('icons/mob/screen1_full.dmi', "icon_state" = "passage6")
		overlays_cache[7] = image('icons/mob/screen1_full.dmi', "icon_state" = "passage7")
		overlays_cache[8] = image('icons/mob/screen1_full.dmi', "icon_state" = "passage8")
		overlays_cache[9] = image('icons/mob/screen1_full.dmi', "icon_state" = "passage9")
		overlays_cache[10] = image('icons/mob/screen1_full.dmi', "icon_state" = "passage10")
		overlays_cache[11] = image('icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay1")
		overlays_cache[12] = image('icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay2")
		overlays_cache[13] = image('icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay3")
		overlays_cache[14] = image('icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay4")
		overlays_cache[15] = image('icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay5")
		overlays_cache[16] = image('icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay6")
		overlays_cache[17] = image('icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay7")
		overlays_cache[18] = image('icons/mob/screen1_full.dmi', "icon_state" = "brutedamageoverlay1")
		overlays_cache[19] = image('icons/mob/screen1_full.dmi', "icon_state" = "brutedamageoverlay2")
		overlays_cache[20] = image('icons/mob/screen1_full.dmi', "icon_state" = "brutedamageoverlay3")
		overlays_cache[21] = image('icons/mob/screen1_full.dmi', "icon_state" = "brutedamageoverlay4")
		overlays_cache[22] = image('icons/mob/screen1_full.dmi', "icon_state" = "brutedamageoverlay5")
		overlays_cache[23] = image('icons/mob/screen1_full.dmi', "icon_state" = "brutedamageoverlay6")

	if(hud_updateflag) // update our mob's hud overlays, AKA what others see flaoting above our head
		handle_hud_list()

	// now handle what we see on our screen

	if(!client)
		return 0

	for(var/image/hud in client.images)
		if(copytext(hud.icon_state,1,4) == "hud") //ugly, but icon comparison is worse, I believe
			client.images.Remove(hud)

	client.screen.Remove(global_hud.blurry, global_hud.druggy, global_hud.vimpaired, global_hud.darkMask, global_hud.nvg, global_hud.thermal, global_hud.meson, global_hud.science)

	if(damageoverlay.overlays)
		damageoverlay.overlays = list()

	if(stat == UNCONSCIOUS)
		//Critical damage passage overlay
		if(health <= 0)
			var/image/I
			switch(health)
				if(-20 to -10)
					I = overlays_cache[1]
				if(-30 to -20)
					I = overlays_cache[2]
				if(-40 to -30)
					I = overlays_cache[3]
				if(-50 to -40)
					I = overlays_cache[4]
				if(-60 to -50)
					I = overlays_cache[5]
				if(-70 to -60)
					I = overlays_cache[6]
				if(-80 to -70)
					I = overlays_cache[7]
				if(-90 to -80)
					I = overlays_cache[8]
				if(-95 to -90)
					I = overlays_cache[9]
				if(-INFINITY to -95)
					I = overlays_cache[10]
			damageoverlay.overlays += I
	else
		//Oxygen damage overlay
		if(oxyloss)
			var/image/I
			switch(oxyloss)
				if(10 to 20)
					I = overlays_cache[11]
				if(20 to 25)
					I = overlays_cache[12]
				if(25 to 30)
					I = overlays_cache[13]
				if(30 to 35)
					I = overlays_cache[14]
				if(35 to 40)
					I = overlays_cache[15]
				if(40 to 45)
					I = overlays_cache[16]
				if(45 to INFINITY)
					I = overlays_cache[17]
			damageoverlay.overlays += I

		//Fire and Brute damage overlay (BSSR)
		var/hurtdamage = src.getBruteLoss() + src.getFireLoss() + damageoverlaytemp
		damageoverlaytemp = 0 // We do this so we can detect if someone hits us or not.
		if(hurtdamage)
			var/image/I
			switch(hurtdamage)
				if(10 to 25)
					I = overlays_cache[18]
				if(25 to 40)
					I = overlays_cache[19]
				if(40 to 55)
					I = overlays_cache[20]
				if(55 to 70)
					I = overlays_cache[21]
				if(70 to 85)
					I = overlays_cache[22]
				if(85 to INFINITY)
					I = overlays_cache[23]
			damageoverlay.overlays += I

	if(stat == DEAD)
		if(healths)		healths.icon_state = "health7"	//DEAD healthmeter
		return

	if(healths)
		if (analgesic > 100)
			healths.icon_state = "health_health_numb"
		else
			switch(hal_screwyhud)
				if(1)	healths.icon_state = "health6"
				if(2)	healths.icon_state = "health7"
				else
					//switch(health - halloss)
					switch(100 - ((species.flags & NO_PAIN) ? 0 : traumatic_shock))
						if(100 to INFINITY)		healths.icon_state = "health0"
						if(80 to 100)			healths.icon_state = "health1"
						if(60 to 80)			healths.icon_state = "health2"
						if(40 to 60)			healths.icon_state = "health3"
						if(20 to 40)			healths.icon_state = "health4"
						if(0 to 20)				healths.icon_state = "health5"
						else					healths.icon_state = "health6"

	if(nutrition_icon)
		switch(nutrition)
			if(450 to INFINITY)				nutrition_icon.icon_state = "nutrition0"
			if(350 to 450)					nutrition_icon.icon_state = "nutrition1"
			if(250 to 350)					nutrition_icon.icon_state = "nutrition2"
			if(150 to 250)					nutrition_icon.icon_state = "nutrition3"
			else							nutrition_icon.icon_state = "nutrition4"

	if(pressure)
		pressure.icon_state = "pressure[pressure_alert]"
	if(toxin)
		if(hal_screwyhud == 4 || phoron_alert)	toxin.icon_state = "tox1"
		else									toxin.icon_state = "tox0"
	if(oxygen)
		if(hal_screwyhud == 3 || oxygen_alert)	oxygen.icon_state = "oxy1"
		else									oxygen.icon_state = "oxy0"
	if(fire)
		if(fire_alert)							fire.icon_state = "fire[fire_alert]" //fire_alert is either 0 if no alert, 1 for cold and 2 for heat.
		else									fire.icon_state = "fire0"

	if(bodytemp)
		if (!species)
			switch(bodytemperature) //310.055 optimal body temp
				if(370 to INFINITY)		bodytemp.icon_state = "temp4"
				if(350 to 370)			bodytemp.icon_state = "temp3"
				if(335 to 350)			bodytemp.icon_state = "temp2"
				if(320 to 335)			bodytemp.icon_state = "temp1"
				if(300 to 320)			bodytemp.icon_state = "temp0"
				if(295 to 300)			bodytemp.icon_state = "temp-1"
				if(280 to 295)			bodytemp.icon_state = "temp-2"
				if(260 to 280)			bodytemp.icon_state = "temp-3"
				else					bodytemp.icon_state = "temp-4"
		else
			var/temp_step
			if (bodytemperature >= species.body_temperature)
				temp_step = (species.heat_level_1 - species.body_temperature)/4

				if (bodytemperature >= species.heat_level_1)
					bodytemp.icon_state = "temp4"
				else if (bodytemperature >= species.body_temperature + temp_step*3)
					bodytemp.icon_state = "temp3"
				else if (bodytemperature >= species.body_temperature + temp_step*2)
					bodytemp.icon_state = "temp2"
				else if (bodytemperature >= species.body_temperature + temp_step*1)
					bodytemp.icon_state = "temp1"
				else
					bodytemp.icon_state = "temp0"

			else if (bodytemperature < species.body_temperature)
				temp_step = (species.body_temperature - species.cold_level_1)/4

				if (bodytemperature <= species.cold_level_1)
					bodytemp.icon_state = "temp-4"
				else if (bodytemperature <= species.body_temperature - temp_step*3)
					bodytemp.icon_state = "temp-3"
				else if (bodytemperature <= species.body_temperature - temp_step*2)
					bodytemp.icon_state = "temp-2"
				else if (bodytemperature <= species.body_temperature - temp_step*1)
					bodytemp.icon_state = "temp-1"
				else
					bodytemp.icon_state = "temp0"
	if(blind)
		if(blinded)		blind.layer = BLIND_LAYER
		else			blind.layer = 0

	// TODO: Set in handle_vision if we have eye disabilities and non-corrective glasses
	// if(eye_impaired)		client.screen += global_hud.vimpaired
	if(eye_blurry)			client.screen += global_hud.blurry
	if(druggy)				client.screen += global_hud.druggy
	// Attempt TODO: Handle meson, thermal, welding, etc. overlays here rather than in glasses
	// if(welding_vision)		client.screen += global_hud.darkMask, etc.

	if(machine)
		var/viewflags = machine.check_eye(src)
		if(viewflags < 0)
			reset_view(null, 0)
		else if(viewflags)
			sight |= viewflags
	else if(eyeobj)
		if(eyeobj.owner != src)

			reset_view(null)
	else
		var/isRemoteObserve = 0
		if((mRemote in mutations) && remoteview_target)
			if(remoteview_target.stat==CONSCIOUS)
				isRemoteObserve = 1
		if(!isRemoteObserve && client && !client.adminobs)
			remoteview_target = null
			reset_view(null, 0)


/*
	Code torn out from vision handling
	if(disabilities & NEARSIGHTED)	//this looks meh but saves a lot of memory by not requiring to add var/prescription
		if(glasses)					//to every /obj/item
			var/obj/item/clothing/glasses/G = glasses
			if(!G.prescription)
				client.screen += global_hud.vimpaired
		else
			client.screen += global_hud.vimpaired



	if(config.welder_vision)
		var/found_welder
		if(istype(glasses, /obj/item/clothing/glasses/welding))
			var/obj/item/clothing/glasses/welding/O = glasses
			if(!O.up)
				found_welder = 1
		if(!found_welder && istype(head, /obj/item/clothing/head/welding))
			var/obj/item/clothing/head/welding/O = head
			if(!O.up)
				found_welder = 1
		if(!found_welder && istype(back, /obj/item/weapon/rig))
			var/obj/item/weapon/rig/O = back
			if(O.helmet && O.helmet == head && (O.helmet.body_parts_covered & EYES))
				if((O.offline && O.offline_vision_restriction == 1) || (!O.offline && O.vision_restriction == 1))
					found_welder = 1
		if(found_welder)
			client.screen |= global_hud.darkMask
*/