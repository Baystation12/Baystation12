var/global/vs_control/vsc = new

/vs_control
	var/fire_consuption_rate = 0.25
	var/fire_consuption_rate_NAME = "Fire - Air Consumption Ratio"
	var/fire_consuption_rate_DESC = "Ratio of air removed and combusted per tick."

	var/fire_firelevel_multiplier = 25
	var/fire_firelevel_multiplier_NAME = "Fire - Firelevel Constant"
	var/fire_firelevel_multiplier_DESC = "Multiplied by the equation for firelevel, affects mainly the extingiushing of fires."

	//Note that this parameter and the phoron heat capacity have a significant impact on TTV yield.
	var/fire_fuel_energy_release = 866000 //J/mol. Adjusted to compensate for fire energy release being fixed, was 397000
	var/fire_fuel_energy_release_NAME = "Fire - Fuel energy release"
	var/fire_fuel_energy_release_DESC = "The energy in joule released when burning one mol of a burnable substance"


	var/IgnitionLevel = 0.5
	var/IgnitionLevel_DESC = "Determines point at which fire can ignite"

	var/airflow_lightest_pressure = 20
	var/airflow_lightest_pressure_NAME = "Airflow - Small Movement Threshold %"
	var/airflow_lightest_pressure_DESC = "Percent of 1 Atm. at which items with the small weight classes will move."

	var/airflow_light_pressure = 35
	var/airflow_light_pressure_NAME = "Airflow - Medium Movement Threshold %"
	var/airflow_light_pressure_DESC = "Percent of 1 Atm. at which items with the medium weight classes will move."

	var/airflow_medium_pressure = 50
	var/airflow_medium_pressure_NAME = "Airflow - Heavy Movement Threshold %"
	var/airflow_medium_pressure_DESC = "Percent of 1 Atm. at which items with the largest weight classes will move."

	var/airflow_heavy_pressure = 65
	var/airflow_heavy_pressure_NAME = "Airflow - Mob Movement Threshold %"
	var/airflow_heavy_pressure_DESC = "Percent of 1 Atm. at which mobs will move."

	var/airflow_dense_pressure = 85
	var/airflow_dense_pressure_NAME = "Airflow - Dense Movement Threshold %"
	var/airflow_dense_pressure_DESC = "Percent of 1 Atm. at which items with canisters and closets will move."

	var/airflow_stun_pressure = 60
	var/airflow_stun_pressure_NAME = "Airflow - Mob Stunning Threshold %"
	var/airflow_stun_pressure_DESC = "Percent of 1 Atm. at which mobs will be stunned by airflow."

	var/airflow_stun_cooldown = 60
	var/airflow_stun_cooldown_NAME = "Aiflow Stunning - Cooldown"
	var/airflow_stun_cooldown_DESC = "How long, in tenths of a second, to wait before stunning them again."

	var/airflow_stun = 1
	var/airflow_stun_NAME = "Airflow Impact - Stunning"
	var/airflow_stun_DESC = "How much a mob is stunned when hit by an object."

	var/airflow_damage = 2
	var/airflow_damage_NAME = "Airflow Impact - Damage"
	var/airflow_damage_DESC = "Damage from airflow impacts."

	var/airflow_speed_decay = 1.5
	var/airflow_speed_decay_NAME = "Airflow Speed Decay"
	var/airflow_speed_decay_DESC = "How rapidly the speed gained from airflow decays."

	var/airflow_delay = 30
	var/airflow_delay_NAME = "Airflow Retrigger Delay"
	var/airflow_delay_DESC = "Time in deciseconds before things can be moved by airflow again."

	var/airflow_mob_slowdown = 1
	var/airflow_mob_slowdown_NAME = "Airflow Slowdown"
	var/airflow_mob_slowdown_DESC = "Time in tenths of a second to add as a delay to each movement by a mob if they are fighting the pull of the airflow."

	var/connection_insulation = 1
	var/connection_insulation_NAME = "Connections - Insulation"
	var/connection_insulation_DESC = "Boolean, should doors forbid heat transfer?"

	var/connection_temperature_delta = 10
	var/connection_temperature_delta_NAME = "Connections - Temperature Difference"
	var/connection_temperature_delta_DESC = "The smallest temperature difference which will cause heat to travel through doors."


/vs_control/var/list/settings = list()
/vs_control/var/list/bitflags = list("1","2","4","8","16","32","64","128","256","512","1024")
/vs_control/var/pl_control/plc = new()

/vs_control/New()
	. = ..()
	settings = vars.Copy()

	var/datum/D = new() //Ensure only unique vars are put through by making a datum and removing all common vars.
	for(var/V in D.vars)
		settings -= V

	for(var/V in settings)
		if(findtextEx(V,"_RANDOM") || findtextEx(V,"_DESC") || findtextEx(V,"_METHOD"))
			settings -= V

	settings -= "settings"
	settings -= "bitflags"
	settings -= "plc"

/vs_control/proc/ChangeSettingsDialog(mob/user,list/L)
	//var/which = input(user,"Choose a setting:") in L
	var/dat = ""
	for(var/ch in L)
		if(findtextEx(ch,"_RANDOM") || findtextEx(ch,"_DESC") || findtextEx(ch,"_METHOD") || findtextEx(ch,"_NAME")) continue
		var/vw
		var/vw_desc = "No Description."
		var/vw_name = ch
		if(ch in plc.settings)
			vw = plc.vars[ch]
			if("[ch]_DESC" in plc.vars) vw_desc = plc.vars["[ch]_DESC"]
			if("[ch]_NAME" in plc.vars) vw_name = plc.vars["[ch]_NAME"]
		else
			vw = vars[ch]
			if("[ch]_DESC" in vars) vw_desc = vars["[ch]_DESC"]
			if("[ch]_NAME" in vars) vw_name = vars["[ch]_NAME"]
		dat += "<b>[vw_name] = [vw]</b> <A href='?src=\ref[src];changevar=[ch]'>\[Change\]</A><br>"
		dat += "<i>[vw_desc]</i><br><br>"
	user << browse(dat,"window=settings")

/vs_control/Topic(href,href_list)
	if("changevar" in href_list)
		ChangeSetting(usr,href_list["changevar"])

/vs_control/proc/ChangeSetting(mob/user,ch)
	var/vw
	var/how = "Text"
	var/display_description = ch
	if(ch in plc.settings)
		vw = plc.vars[ch]
		if("[ch]_NAME" in plc.vars)
			display_description = plc.vars["[ch]_NAME"]
		if("[ch]_METHOD" in plc.vars)
			how = plc.vars["[ch]_METHOD"]
		else
			if(isnum(vw))
				how = "Numeric"
			else
				how = "Text"
	else
		vw = vars[ch]
		if("[ch]_NAME" in vars)
			display_description = vars["[ch]_NAME"]
		if("[ch]_METHOD" in vars)
			how = vars["[ch]_METHOD"]
		else
			if(isnum(vw))
				how = "Numeric"
			else
				how = "Text"
	var/newvar = vw
	switch(how)
		if("Numeric")
			newvar = input(user,"Enter a number:","Settings",newvar) as num
		if("Bit Flag")
			var/flag = input(user,"Toggle which bit?","Settings") in bitflags
			flag = text2num(flag)
			if(newvar & flag)
				newvar &= ~flag
			else
				newvar |= flag
		if("Toggle")
			newvar = !newvar
		if("Text")
			newvar = input(user,"Enter a string:","Settings",newvar) as text
		if("Long Text")
			newvar = input(user,"Enter text:","Settings",newvar) as message
	vw = newvar
	if(ch in plc.settings)
		plc.vars[ch] = vw
	else
		vars[ch] = vw
	if(how == "Toggle")
		newvar = (newvar?"ON":"OFF")
	world << "<span class='notice'><b>[key_name(user)] changed the setting [display_description] to [newvar].</b></span>"
	if(ch in plc.settings)
		ChangeSettingsDialog(user,plc.settings)
	else
		ChangeSettingsDialog(user,settings)

/vs_control/proc/RandomizeWithProbability()
	for(var/V in settings)
		var/newvalue
		if("[V]_RANDOM" in vars)
			if(isnum(vars["[V]_RANDOM"]))
				newvalue = prob(vars["[V]_RANDOM"])
			else if(istext(vars["[V]_RANDOM"]))
				newvalue = roll(vars["[V]_RANDOM"])
			else
				newvalue = vars[V]
		V = newvalue

/vs_control/proc/ChangePhoron()
	for(var/V in plc.settings)
		plc.Randomize(V)

/vs_control/proc/SetDefault(var/mob/user)
	var/list/setting_choices = list("Phoron - Standard", "Phoron - Low Hazard", "Phoron - High Hazard", "Phoron - Oh Shit!",\
	"ZAS - Normal", "ZAS - Forgiving", "ZAS - Dangerous", "ZAS - Hellish", "ZAS/Phoron - Initial")
	var/def = input(user, "Which of these presets should be used?") as null|anything in setting_choices
	if(!def)
		return
	switch(def)
		if("Phoron - Standard")
			plc.CLOTH_CONTAMINATION = 1 //If this is on, phoron does damage by getting into cloth.
			plc.PHORONGUARD_ONLY = 0
			plc.GENETIC_CORRUPTION = 0 //Chance of genetic corruption as well as toxic damage, X in 1000.
			plc.SKIN_BURNS = 0       //Phoron has an effect similar to mustard gas on the un-suited.
			plc.EYE_BURNS = 1 //Phoron burns the eyes of anyone not wearing eye protection.
			plc.PHORON_HALLUCINATION = 0
			plc.CONTAMINATION_LOSS = 0.02

		if("Phoron - Low Hazard")
			plc.CLOTH_CONTAMINATION = 0 //If this is on, phoron does damage by getting into cloth.
			plc.PHORONGUARD_ONLY = 0
			plc.GENETIC_CORRUPTION = 0 //Chance of genetic corruption as well as toxic damage, X in 1000
			plc.SKIN_BURNS = 0       //Phoron has an effect similar to mustard gas on the un-suited.
			plc.EYE_BURNS = 1 //Phoron burns the eyes of anyone not wearing eye protection.
			plc.PHORON_HALLUCINATION = 0
			plc.CONTAMINATION_LOSS = 0.01

		if("Phoron - High Hazard")
			plc.CLOTH_CONTAMINATION = 1 //If this is on, phoron does damage by getting into cloth.
			plc.PHORONGUARD_ONLY = 0
			plc.GENETIC_CORRUPTION = 0 //Chance of genetic corruption as well as toxic damage, X in 1000.
			plc.SKIN_BURNS = 1       //Phoron has an effect similar to mustard gas on the un-suited.
			plc.EYE_BURNS = 1 //Phoron burns the eyes of anyone not wearing eye protection.
			plc.PHORON_HALLUCINATION = 1
			plc.CONTAMINATION_LOSS = 0.05

		if("Phoron - Oh Shit!")
			plc.CLOTH_CONTAMINATION = 1 //If this is on, phoron does damage by getting into cloth.
			plc.PHORONGUARD_ONLY = 1
			plc.GENETIC_CORRUPTION = 5 //Chance of genetic corruption as well as toxic damage, X in 1000.
			plc.SKIN_BURNS = 1       //Phoron has an effect similar to mustard gas on the un-suited.
			plc.EYE_BURNS = 1 //Phoron burns the eyes of anyone not wearing eye protection.
			plc.PHORON_HALLUCINATION = 1
			plc.CONTAMINATION_LOSS = 0.075

		if("ZAS - Normal")
			airflow_lightest_pressure = 20
			airflow_light_pressure = 35
			airflow_medium_pressure = 50
			airflow_heavy_pressure = 65
			airflow_dense_pressure = 85
			airflow_stun_pressure = 60
			airflow_stun_cooldown = 60
			airflow_stun = 1
			airflow_damage = 2
			airflow_speed_decay = 1.5
			airflow_delay = 30
			airflow_mob_slowdown = 1

		if("ZAS - Forgiving")
			airflow_lightest_pressure = 45
			airflow_light_pressure = 60
			airflow_medium_pressure = 120
			airflow_heavy_pressure = 110
			airflow_dense_pressure = 200
			airflow_stun_pressure = 150
			airflow_stun_cooldown = 90
			airflow_stun = 0.15
			airflow_damage = 0.15
			airflow_speed_decay = 1.5
			airflow_delay = 50
			airflow_mob_slowdown = 0

		if("ZAS - Dangerous")
			airflow_lightest_pressure = 15
			airflow_light_pressure = 30
			airflow_medium_pressure = 45
			airflow_heavy_pressure = 55
			airflow_dense_pressure = 70
			airflow_stun_pressure = 50
			airflow_stun_cooldown = 50
			airflow_stun = 2
			airflow_damage = 3
			airflow_speed_decay = 1.2
			airflow_delay = 25
			airflow_mob_slowdown = 2

		if("ZAS - Hellish")
			airflow_lightest_pressure = 20
			airflow_light_pressure = 30
			airflow_medium_pressure = 40
			airflow_heavy_pressure = 50
			airflow_dense_pressure = 60
			airflow_stun_pressure = 40
			airflow_stun_cooldown = 40
			airflow_stun = 3
			airflow_damage = 4
			airflow_speed_decay = 1
			airflow_delay = 20
			airflow_mob_slowdown = 3
			connection_insulation = 0

		if("ZAS/Phoron - Initial")
			fire_consuption_rate 			= initial(fire_consuption_rate)
			fire_firelevel_multiplier 		= initial(fire_firelevel_multiplier)
			fire_fuel_energy_release 		= initial(fire_fuel_energy_release)
			IgnitionLevel 					= initial(IgnitionLevel)
			airflow_lightest_pressure 		= initial(airflow_lightest_pressure)
			airflow_light_pressure 			= initial(airflow_light_pressure)
			airflow_medium_pressure 		= initial(airflow_medium_pressure)
			airflow_heavy_pressure 			= initial(airflow_heavy_pressure)
			airflow_dense_pressure 			= initial(airflow_dense_pressure)
			airflow_stun_pressure 			= initial(airflow_stun_pressure)
			airflow_stun_cooldown 			= initial(airflow_stun_cooldown)
			airflow_stun 					= initial(airflow_stun)
			airflow_damage 					= initial(airflow_damage)
			airflow_speed_decay 			= initial(airflow_speed_decay)
			airflow_delay 					= initial(airflow_delay)
			airflow_mob_slowdown 			= initial(airflow_mob_slowdown)
			connection_insulation 			= initial(connection_insulation)
			connection_temperature_delta 	= initial(connection_temperature_delta)

			plc.PHORON_DMG 					= initial(plc.PHORON_DMG)
			plc.CLOTH_CONTAMINATION 		= initial(plc.CLOTH_CONTAMINATION)
			plc.PHORONGUARD_ONLY 			= initial(plc.PHORONGUARD_ONLY)
			plc.GENETIC_CORRUPTION 			= initial(plc.GENETIC_CORRUPTION)
			plc.SKIN_BURNS 					= initial(plc.SKIN_BURNS)
			plc.EYE_BURNS 					= initial(plc.EYE_BURNS)
			plc.CONTAMINATION_LOSS 			= initial(plc.CONTAMINATION_LOSS)
			plc.PHORON_HALLUCINATION 		= initial(plc.PHORON_HALLUCINATION)
			plc.N2O_HALLUCINATION 			= initial(plc.N2O_HALLUCINATION)


	world << "<span class='notice'><b>[key_name(user)] changed the global phoron/ZAS settings to \"[def]\"</b></span>"

/pl_control/var/list/settings = list()

/pl_control/New()
	. = ..()
	settings = vars.Copy()

	var/datum/D = new() //Ensure only unique vars are put through by making a datum and removing all common vars.
	for(var/V in D.vars)
		settings -= V

	for(var/V in settings)
		if(findtextEx(V,"_RANDOM") || findtextEx(V,"_DESC"))
			settings -= V

	settings -= "settings"

/pl_control/proc/Randomize(V)
	var/newvalue
	if("[V]_RANDOM" in vars)
		if(isnum(vars["[V]_RANDOM"]))
			newvalue = prob(vars["[V]_RANDOM"])
		else if(istext(vars["[V]_RANDOM"]))
			var/txt = vars["[V]_RANDOM"]
			if(findtextEx(txt,"PROB"))
				txt = text2list(txt,"/")
				txt[1] = replacetext(txt[1],"PROB","")
				var/p = text2num(txt[1])
				var/r = txt[2]
				if(prob(p))
					newvalue = roll(r)
				else
					newvalue = vars[V]
			else if(findtextEx(txt,"PICK"))
				txt = replacetext(txt,"PICK","")
				txt = text2list(txt,",")
				newvalue = pick(txt)
			else
				newvalue = roll(txt)
		else
			newvalue = vars[V]
		vars[V] = newvalue
