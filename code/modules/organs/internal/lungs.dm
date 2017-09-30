/obj/item/organ/internal/lungs
	name = "lungs"
	icon_state = "lungs"
	gender = PLURAL
	organ_tag = BP_LUNGS
	parent_organ = BP_CHEST
	w_class = ITEM_SIZE_NORMAL
	min_bruised_damage = 25
	min_broken_damage = 45
	max_damage = 70
	relative_size = 60

	var/active_breathing = 1

	var/breath_type
	var/poison_type
	var/exhale_type

	var/min_breath_pressure

	var/oxygen_deprivation = 0
	var/safe_exhaled_max = 10
	var/safe_toxins_max = 0.2
	var/SA_para_min = 1
	var/SA_sleep_min = 5
	var/breathing = 0
	var/last_failed_breath
	var/breath_fail_ratio // How badly they failed a breath. Higher is worse.

/obj/item/organ/internal/lungs/proc/remove_oxygen_deprivation(var/amount)
	var/last_suffocation = oxygen_deprivation
	oxygen_deprivation = min(species.total_health,max(0,oxygen_deprivation - amount))
	return -(oxygen_deprivation - last_suffocation)

/obj/item/organ/internal/lungs/proc/add_oxygen_deprivation(var/amount)
	var/last_suffocation = oxygen_deprivation
	oxygen_deprivation = min(species.total_health,max(0,oxygen_deprivation + amount))
	return (oxygen_deprivation - last_suffocation)

// Returns a percentage value for use by GetOxyloss().
/obj/item/organ/internal/lungs/proc/get_oxygen_deprivation()
	if(status & ORGAN_DEAD)
		return 100
	return round((oxygen_deprivation/species.total_health)*100)

/obj/item/organ/internal/lungs/robotize()
	. = ..()
	icon_state = "lungs-prosthetic"

/obj/item/organ/internal/lungs/set_dna(var/datum/dna/new_dna)
	..()
	sync_breath_types()

/obj/item/organ/internal/lungs/replaced()
	..()
	sync_breath_types()

/**
 *  Set these lungs' breath types based on the lungs' species
 */
/obj/item/organ/internal/lungs/proc/sync_breath_types()
	min_breath_pressure = species.breath_pressure
	breath_type = species.breath_type ? species.breath_type : "oxygen"
	poison_type = species.poison_type ? species.poison_type : "phoron"
	exhale_type = species.exhale_type ? species.exhale_type : "carbon_dioxide"

/obj/item/organ/internal/lungs/process()
	..()
	if(!owner)
		return

	if (germ_level > INFECTION_LEVEL_ONE && active_breathing)
		if(prob(5))
			owner.emote("cough")		//respitory tract infection

	if(is_bruised() && !owner.is_asystole())
		if(prob(2))
			if(active_breathing)
				owner.visible_message(
					"<B>\The [owner]</B> coughs up blood!",
					"<span class='warning'>You cough up blood!</span>",
					"You hear someone coughing!",
				)
			else
				var/obj/item/organ/parent = owner.get_organ(parent_organ)
				owner.visible_message(
					"blood drips from <B>\the [owner]'s</B> [parent.name]!",
				)

			owner.drip(10)
		if(prob(4))
			if(active_breathing)
				owner.visible_message(
					"<B>\The [owner]</B> gasps for air!",
					"<span class='danger'>You can't breathe!</span>",
					"You hear someone gasp for air!",
				)
			else
				to_chat(owner, "<span class='danger'>You're having trouble getting enough [breath_type]!</span>")

			owner.losebreath += round(damage/2)

/obj/item/organ/internal/lungs/proc/rupture()
	var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
	if(istype(parent))
		owner.custom_pain("You feel a stabbing pain in your [parent.name]!", 50, affecting = parent)
	bruise()

/obj/item/organ/internal/lungs/proc/handle_breath(datum/gas_mixture/breath, var/forced)
	if(!owner)
		return 1
	if(!breath)
		breath_fail_ratio = 1
		handle_failed_breath()
		return 1

	var/breath_pressure = breath.total_moles*R_IDEAL_GAS_EQUATION*breath.temperature/BREATH_VOLUME
	//exposure to extreme pressures can rupture lungs
	if(breath_pressure < species.hazard_low_pressure || breath_pressure > species.hazard_high_pressure)
		var/datum/gas_mixture/environment = loc.return_air_for_internal_lifeform()
		var/env_pressure = environment.return_pressure()
		var/lung_rupture_prob =  robotic >= ORGAN_ROBOT ? prob(2.5) : prob(5) //Robotic lungs are less likely to rupture.
		if(env_pressure < species.hazard_low_pressure || env_pressure > species.hazard_high_pressure)
			if(!is_bruised() && lung_rupture_prob) //only rupture if NOT already ruptured
				rupture()
	if(breath.total_moles == 0)
		breath_fail_ratio = 1
		handle_failed_breath()
		return 1

	var/safe_pressure_min = min_breath_pressure // Minimum safe partial pressure of breathable gas in kPa
	// Lung damage increases the minimum safe pressure.
	safe_pressure_min *= 1 + rand(1,4) * damage/max_damage

	if(!forced && owner.chem_effects[CE_BREATHLOSS] && !owner.chem_effects[CE_STABLE]) //opiates are bad mmkay
		safe_pressure_min *= 1 + rand(1,4) * owner.chem_effects[CE_BREATHLOSS]

	var/failed_inhale = 0
	var/failed_exhale = 0

	var/inhaling = breath.gas[breath_type]
	var/poison = breath.gas[poison_type]
	var/exhaling = exhale_type ? breath.gas[exhale_type] : 0

	var/inhale_pp = (inhaling/breath.total_moles)*breath_pressure
	var/toxins_pp = (poison/breath.total_moles)*breath_pressure
	var/exhaled_pp = (exhaling/breath.total_moles)*breath_pressure

	var/inhale_efficiency = max(round(inhale_pp/safe_pressure_min, 0.001), 3)
	// Not enough to breathe
	if(inhale_efficiency < 1)
		if(prob(20) && active_breathing)
			owner.emote("gasp")

		breath_fail_ratio = 1 - inhale_efficiency
		failed_inhale = 1
	else
		breath_fail_ratio = 0

	owner.oxygen_alert = failed_inhale * 2

	var/inhaled_gas_used = inhaling/6
	breath.adjust_gas(breath_type, -inhaled_gas_used, update = 0) //update afterwards

	if(exhale_type)
		breath.adjust_gas_temp(exhale_type, inhaled_gas_used, owner.bodytemperature, update = 0) //update afterwards
		// Too much exhaled gas in the air
		var/word
		var/warn_prob
		var/oxyloss
		var/alert

		if(exhaled_pp > safe_exhaled_max)
			word = pick("extremely dizzy","short of breath","faint","confused")
			warn_prob = 15
			oxyloss = HUMAN_MAX_OXYLOSS
			alert = 1
			failed_exhale = 1
		else if(exhaled_pp > safe_exhaled_max * 0.7)
			word = pick("dizzy","short of breath","faint","momentarily confused")
			warn_prob = 1
			alert = 1
			failed_exhale = 1
			var/ratio = 1.0 - (safe_exhaled_max - exhaled_pp)/(safe_exhaled_max*0.3)
			if (owner.getOxyLoss() < 50*ratio)
				oxyloss = HUMAN_MAX_OXYLOSS
		else if(exhaled_pp > safe_exhaled_max * 0.6)
			word = pick("a little dizzy","short of breath")
			warn_prob = 1
		else
			owner.co2_alert = 0

		if(!owner.co2_alert && word && prob(warn_prob))
			to_chat(owner, "<span class='warning'>You feel [word].</span>")
			owner.adjustOxyLoss(oxyloss)
			owner.co2_alert = alert

	// Too much poison in the air.
	if(toxins_pp > safe_toxins_max)
		var/ratio = (poison/safe_toxins_max) * 10
		if(robotic >= ORGAN_ROBOT)
			ratio /= 2 //Robolungs filter out some of the inhaled toxic air.
		owner.reagents.add_reagent(/datum/reagent/toxin, Clamp(ratio, MIN_TOXIN_DAMAGE, MAX_TOXIN_DAMAGE))
		breath.adjust_gas(poison_type, -poison/6, update = 0) //update after
		owner.phoron_alert = 1
	else
		owner.phoron_alert = 0

	// If there's some other shit in the air lets deal with it here.
	if(breath.gas["sleeping_agent"])
		var/SA_pp = (breath.gas["sleeping_agent"] / breath.total_moles) * breath_pressure
		if(SA_pp > SA_para_min)		// Enough to make us paralysed for a bit
			owner.Paralyse(3)	// 3 gives them one second to wake up and run away a bit!
			if(SA_pp > SA_sleep_min)	// Enough to make us sleep as well
				owner.Sleeping(5)
		else if(SA_pp > 0.15)	// There is sleeping gas in their lungs, but only a little, so give them a bit of a warning
			if(prob(20))
				owner.emote(pick("giggle", "laugh"))

		breath.adjust_gas("sleeping_agent", -breath.gas["sleeping_agent"]/6, update = 0) //update after

	// Were we able to breathe?
	var/failed_breath = failed_inhale || failed_exhale
	if(failed_breath)
		if(isnull(last_failed_breath))
			last_failed_breath = world.time
	else
		last_failed_breath = null
		owner.adjustOxyLoss(-5 * inhale_efficiency)
		if(robotic < ORGAN_ROBOT && species.breathing_sound && is_below_sound_pressure(get_turf(owner)))
			if(breathing || owner.shock_stage >= 10)
				sound_to(owner, sound(species.breathing_sound,0,0,0,5))
				breathing = 0
			else
				breathing = 1

	handle_temperature_effects(breath)
	breath.update_values()

	if(failed_breath)
		handle_failed_breath()
	else
		owner.oxygen_alert = 0
	return failed_breath

/obj/item/organ/internal/lungs/proc/handle_failed_breath()
	if(prob(15) && !owner.nervous_system_failure())
		if(!owner.is_asystole())
			if(active_breathing)
				owner.emote("gasp")
		else
			owner.emote(pick("shiver","twitch"))

	if(damage || owner.chem_effects[CE_BREATHLOSS] || world.time > last_failed_breath + 2 MINUTES)
		owner.adjustOxyLoss(HUMAN_MAX_OXYLOSS*breath_fail_ratio)

	owner.oxygen_alert = max(owner.oxygen_alert, 2)

/obj/item/organ/internal/lungs/proc/handle_temperature_effects(datum/gas_mixture/breath)
	// Hot air hurts :(
	if((breath.temperature < species.cold_level_1 || breath.temperature > species.heat_level_1) && !(COLD_RESISTANCE in owner.mutations))
		var/damage = 0
		if(breath.temperature <= species.cold_level_1)
			if(prob(20))
				to_chat(owner, "<span class='danger'>You feel your face freezing and icicles forming in your lungs!</span>")
			switch(breath.temperature)
				if(species.cold_level_3 to species.cold_level_2)
					damage = COLD_GAS_DAMAGE_LEVEL_3
				if(species.cold_level_2 to species.cold_level_1)
					damage = COLD_GAS_DAMAGE_LEVEL_2
				else
					damage = COLD_GAS_DAMAGE_LEVEL_1

			if(prob(20))
				owner.apply_damage(damage, BURN, BP_HEAD, used_weapon = "Excessive Cold")
			else
				src.damage += damage
			owner.fire_alert = 1
		else if(breath.temperature >= species.heat_level_1)
			if(prob(20))
				to_chat(owner, "<span class='danger'>You feel your face burning and a searing heat in your lungs!</span>")

			switch(breath.temperature)
				if(species.heat_level_1 to species.heat_level_2)
					damage = HEAT_GAS_DAMAGE_LEVEL_1
				if(species.heat_level_2 to species.heat_level_3)
					damage = HEAT_GAS_DAMAGE_LEVEL_2
				else
					damage = HEAT_GAS_DAMAGE_LEVEL_3

			if(prob(20))
				owner.apply_damage(damage, BURN, BP_HEAD, used_weapon = "Excessive Heat")
			else
				src.damage += damage
			owner.fire_alert = 2

		//breathing in hot/cold air also heats/cools you a bit
		var/temp_adj = breath.temperature - owner.bodytemperature
		if (temp_adj < 0)
			temp_adj /= (BODYTEMP_COLD_DIVISOR * 5)	//don't raise temperature as much as if we were directly exposed
		else
			temp_adj /= (BODYTEMP_HEAT_DIVISOR * 5)	//don't raise temperature as much as if we were directly exposed

		var/relative_density = breath.total_moles / (MOLES_CELLSTANDARD * BREATH_PERCENTAGE)
		temp_adj *= relative_density

		if (temp_adj > BODYTEMP_HEATING_MAX) temp_adj = BODYTEMP_HEATING_MAX
		if (temp_adj < BODYTEMP_COOLING_MAX) temp_adj = BODYTEMP_COOLING_MAX
//		log_debug("Breath: [breath.temperature], [src]: [bodytemperature], Adjusting: [temp_adj]")
		owner.bodytemperature += temp_adj

	else if(breath.temperature >= species.heat_discomfort_level)
		species.get_environment_discomfort(owner,"heat")
	else if(breath.temperature <= species.cold_discomfort_level)
		species.get_environment_discomfort(owner,"cold")