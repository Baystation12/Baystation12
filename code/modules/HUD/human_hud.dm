/mob/living/carbon/human
	hud_type = /datum/mob_hud/human

/datum/mob_hud/human
	

/datum/mob_hud/human/prepare(var/ui_style, var/ui_color, var/ui_alpha)
	hud_images += new /obj/screen/hud_image/drop(ui_style, ui_color, ui_alpha)

	hud_images += new /obj/screen/hud_image/zone_selector(ui_style, ui_color, ui_alpha)

	hud_images += new /obj/screen/hud_image/health(ui_style, ui_color, ui_alpha)

	hud_images += new /obj/screen/hud_image/nutrition(ui_style, ui_color, ui_alpha)
	hud_images += new /obj/screen/hud_image/pressure_warning(ui_style, ui_color, ui_alpha)
	hud_images += new /obj/screen/hud_image/toxin_warning(ui_style, ui_color, ui_alpha)
	hud_images += new /obj/screen/hud_image/oxygen_warning(ui_style, ui_color, ui_alpha)
	hud_images += new /obj/screen/hud_image/fire_warning(ui_style, ui_color, ui_alpha)
	hud_images += new /obj/screen/hud_image/temperature_warning(ui_style, ui_color, ui_alpha)

/obj/screen/hud_image/drop
	name = "drop"
	icon_state = "act_drop"
	screen_loc = ui_drop_throw

/obj/screen/hud_image/drop/Click()
	usr.client.drop_item()

/obj/screen/hud_image/zone_selector
	name = "damage zone"
	icon_state = "zone_sel"
	screen_loc = ui_zonesel
	var/selecting = BP_CHEST

/obj/screen/hud_image/zone_selector/update()
	overlays.Cut()
	overlays += image('icons/mob/zone_sel.dmi', "[selecting]")

/obj/screen/hud_image/zone_selector/Click(location, control, params)
	var/list/PL = params2list(params)
	var/icon_x = text2num(PL["icon-x"])
	var/icon_y = text2num(PL["icon-y"])
	var/old_selecting = selecting //We're only going to update_icon() if there's been a change

	switch(icon_y)
		if(1 to 3) //Feet
			switch(icon_x)
				if(10 to 15)
					selecting = BP_R_FOOT
				if(17 to 22)
					selecting = BP_L_FOOT
				else
					return 1
		if(4 to 9) //Legs
			switch(icon_x)
				if(10 to 15)
					selecting = BP_R_LEG
				if(17 to 22)
					selecting = BP_L_LEG
				else
					return 1
		if(10 to 13) //Hands and groin
			switch(icon_x)
				if(8 to 11)
					selecting = BP_R_HAND
				if(12 to 20)
					selecting = BP_GROIN
				if(21 to 24)
					selecting = BP_L_HAND
				else
					return 1
		if(14 to 22) //Chest and arms to shoulders
			switch(icon_x)
				if(8 to 11)
					selecting = BP_R_ARM
				if(12 to 20)
					selecting = BP_CHEST
				if(21 to 24)
					selecting = BP_L_ARM
				else
					return 1
		if(23 to 30) //Head, but we need to check for eye or mouth
			if(icon_x in 12 to 20)
				selecting = BP_HEAD
				switch(icon_y)
					if(23 to 24)
						if(icon_x in 15 to 17)
							selecting = BP_MOUTH
					if(26) //Eyeline, eyes are on 15 and 17
						if(icon_x in 14 to 18)
							selecting = BP_EYES
					if(25 to 27)
						if(icon_x in 15 to 17)
							selecting = BP_EYES

	if(old_selecting != selecting)
		update()
	return 1

/obj/screen/hud_image/health
	name = "health"
	screen_loc = ui_health

/obj/screen/hud_image/health/update(var/mob/living/carbon/human/H)
	if(H.chem_effects[CE_PAINKILLER] > 100)
		icon_state = "health_numb"
	else
		switch(H.hal_screwyhud)
			if(1)
				icon_state = "health6"
			if(2)
				icon_state = "health7"
			else
				// Generate a by-limb health display.
				icon_state = "blank"
				overlays = null

				var/no_damage = 1
				var/trauma_val = 0 // Used in calculating softcrit/hardcrit indicators.
				if(!H.can_feel_pain())
					trauma_val = max(H.traumatic_shock, H.getHalLoss()) / H.species.total_health
				// Collect and apply the images all at once to avoid appearance churn.
				var/list/health_images = list()
				for(var/obj/item/organ/external/E in H.organs)
					if(no_damage && (E.brute_dam || E.burn_dam))
						no_damage = 0
					health_images += E.get_damage_hud_image()

				// Apply a fire overlay if we're burning.
				if(H.on_fire)
					health_images += image('icons/mob/screen1_health.dmi',"burning")

				// Show a general pain/crit indicator if needed.
				if(trauma_val)
					if(H.can_feel_pain())
						if(trauma_val > 0.7)
							health_images += image('icons/mob/screen1_health.dmi',"softcrit")
						if(trauma_val >= 1)
							health_images += image('icons/mob/screen1_health.dmi',"hardcrit")
				else if(no_damage)
					health_images += image('icons/mob/screen1_health.dmi',"fullhealth")

				overlays += health_images

/obj/screen/hud_image/nutrition
	name = "nutrition"
	screen_loc = ui_nutrition

/obj/screen/hud_image/nutrition/update(var/mob/living/carbon/human/H)
	switch(H.nutrition)
		if(450 to INFINITY)
			icon_state = "nutrition0"
		if(350 to 450)
			icon_state = "nutrition1"
		if(250 to 350)
			icon_state = "nutrition2"
		if(150 to 250)
			icon_state = "nutrition3"
		else
			icon_state = "nutrition4"

/obj/screen/hud_image/pressure_warning
	name = "pressure"
	screen_loc = ui_pressure

/obj/screen/hud_image/pressure_warning/update(var/mob/living/carbon/human/H)
	icon_state = "pressure[H.pressure_alert]"

/obj/screen/hud_image/toxin_warning
	name = "toxin"
	screen_loc = ui_toxin

/obj/screen/hud_image/toxin_warning/update(var/mob/living/carbon/human/H)
	if(H.hal_screwyhud == 4 || H.phoron_alert)
		icon_state = "tox1"
	else
		icon_state = "tox0"

/obj/screen/hud_image/oxygen_warning
	name = "oxygen"
	screen_loc = ui_oxygen

/obj/screen/hud_image/oxygen_warning/update(var/mob/living/carbon/human/H)
	if(H.hal_screwyhud == 3 || H.oxygen_alert)
		icon_state = "oxy1"
	else
		icon_state = "oxy0"

/obj/screen/hud_image/fire_warning
	name = "fire"
	screen_loc = ui_fire

/obj/screen/hud_image/fire_warning/update(var/mob/living/carbon/human/H)
	if(H.fire_alert)
		icon_state = "fire[H.fire_alert]"
	else
		icon_state = "fire0"

/obj/screen/hud_image/temperature_warning
	name = "body temperature"
	screen_loc = ui_temp

/obj/screen/hud_image/temperature_warning/update(var/mob/living/carbon/human/H)
	var/base_temperature = H.species.body_temperature
	if(base_temperature == null) //some species don't have a set metabolic temperature
		base_temperature = (H.getSpeciesOrSynthTemp(HEAT_LEVEL_1) + H.getSpeciesOrSynthTemp(COLD_LEVEL_1)) / 2

	var/temp_step
	if(H.bodytemperature >= base_temperature)
		temp_step = (H.getSpeciesOrSynthTemp(HEAT_LEVEL_1) - base_temperature)/4

		if(H.bodytemperature >= H.getSpeciesOrSynthTemp(HEAT_LEVEL_1))
			icon_state = "temp4"
		else if(H.bodytemperature >= base_temperature + temp_step*3)
			icon_state = "temp3"
		else if(H.bodytemperature >= base_temperature + temp_step*2)
			icon_state = "temp2"
		else if(H.bodytemperature >= base_temperature + temp_step*1)
			icon_state = "temp1"
		else
			icon_state = "temp0"

	else if(H.bodytemperature < base_temperature)
		temp_step = (base_temperature - H.getSpeciesOrSynthTemp(COLD_LEVEL_1))/4

		if(H.bodytemperature <= H.getSpeciesOrSynthTemp(COLD_LEVEL_1))
			icon_state = "temp-4"
		else if(H.bodytemperature <= base_temperature - temp_step*3)
			icon_state = "temp-3"
		else if(H.bodytemperature <= base_temperature - temp_step*2)
			icon_state = "temp-2"
		else if(H.bodytemperature <= base_temperature - temp_step*1)
			icon_state = "temp-1"
		else
			icon_state = "temp0"
