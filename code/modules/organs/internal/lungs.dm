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
	var/has_gills = FALSE
	var/breath_type
	var/exhale_type
	var/list/poison_types

	var/min_breath_pressure
	var/last_int_pressure
	var/last_ext_pressure
	var/max_pressure_diff = 60

	var/oxygen_deprivation = 0
	var/safe_exhaled_max = 6
	var/safe_toxins_max = 0.2
	var/SA_para_min = 1
	var/SA_sleep_min = 5
	var/breathing = 0
	var/last_successful_breath
	var/breath_fail_ratio // How badly they failed a breath. Higher is worse.

/obj/item/organ/internal/lungs/proc/can_drown()
	return (is_broken() || !has_gills)

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
	max_pressure_diff = species.max_pressure_diff

/obj/item/organ/internal/lungs/replaced()
	..()
	sync_breath_types()

/**
 *  Set these lungs' breath types based on the lungs' species
 */
/obj/item/organ/internal/lungs/proc/sync_breath_types()
	min_breath_pressure = species.breath_pressure
	breath_type = species.breath_type ? species.breath_type : GAS_OXYGEN
	poison_types = species.poison_types ? species.poison_types : list(GAS_PHORON = TRUE)
	exhale_type = species.exhale_type ? species.exhale_type : GAS_CO2

/obj/item/organ/internal/lungs/Process()
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

			owner.drip(1)
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

//exposure to extreme pressures can rupture lungs
/obj/item/organ/internal/lungs/proc/check_rupturing(breath_pressure)
	if(isnull(last_int_pressure))
		last_int_pressure = breath_pressure
		return
	var/datum/gas_mixture/environment = loc.return_air_for_internal_lifeform()
	var/ext_pressure = environment && environment.return_pressure() // May be null if, say, our owner is in nullspace
	var/int_pressure_diff = abs(last_int_pressure - breath_pressure)
	var/ext_pressure_diff = abs(last_ext_pressure - ext_pressure) * owner.get_pressure_weakness(ext_pressure)
	if(int_pressure_diff > max_pressure_diff && ext_pressure_diff > max_pressure_diff)
		var/lung_rupture_prob = BP_IS_ROBOTIC(src) ? prob(30) : prob(60) //Robotic lungs are less likely to rupture.
		if(!is_bruised() && lung_rupture_prob) //only rupture if NOT already ruptured
			rupture()

/obj/item/organ/internal/lungs/proc/handle_breath(datum/gas_mixture/breath, var/forced)

	if(!owner)
		return 1

	if(!breath || (max_damage <= 0))
		breath_fail_ratio = 1
		handle_failed_breath()
		return 1

	var/breath_pressure = breath.return_pressure()
	check_rupturing(breath_pressure)

	var/datum/gas_mixture/environment = loc.return_air_for_internal_lifeform()
	last_ext_pressure = environment && environment.return_pressure()
	last_int_pressure = breath_pressure
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
	var/inhale_efficiency = min(round(((inhaling/breath.total_moles)*breath_pressure)/safe_pressure_min, 0.001), 3)

	// Not enough to breathe
	if(inhale_efficiency < 1)
		if(prob(20) && active_breathing)
			if(inhale_efficiency < 0.8)
				owner.emote("gasp")
			else if(prob(20))
				to_chat(owner, SPAN_WARNING("It's hard to breathe..."))
		breath_fail_ratio = 1 - inhale_efficiency
		failed_inhale = 1
	else
		breath_fail_ratio = 0

	owner.oxygen_alert = failed_inhale * 2

	var/inhaled_gas_used = inhaling / 4
	breath.adjust_gas(breath_type, -inhaled_gas_used, update = 0) //update afterwards

	owner.phoron_alert = 0 // Reset our toxins alert for now.
	if(!failed_inhale) // Enough gas to tell we're being poisoned via chemical burns or whatever.
		var/poison_total = 0
		if(poison_types)
			for(var/gname in breath.gas)
				if(poison_types[gname])
					poison_total += breath.gas[gname]
		if(((poison_total/breath.total_moles)*breath_pressure) > safe_toxins_max)
			owner.phoron_alert = 1

	// Pass reagents from the gas into our body.
	// Presumably if you breathe it you have a specialized metabolism for it, so we drop/ignore breath_type. Also avoids
	// humans processing thousands of units of oxygen over the course of a round for the sole purpose of poisoning vox.
	var/ratio = BP_IS_ROBOTIC(src)? 0.66 : 1
	for(var/gasname in breath.gas - breath_type)
		var/breathed_product = gas_data.breathed_product[gasname]
		if(breathed_product)
			var/reagent_amount = breath.gas[gasname] * REAGENT_GAS_EXCHANGE_FACTOR * ratio
			 // Little bit of sanity so we aren't trying to add 0.0000000001 units of CO2, and so we don't end up with 99999 units of CO2.
			if(reagent_amount >= 0.05)
				owner.reagents.add_reagent(breathed_product, reagent_amount)
				breath.adjust_gas(gasname, -breath.gas[gasname], update = 0) //update after

	// Moved after reagent injection so we don't instantly poison ourselves with CO2 or whatever.
	if(exhale_type && (!istype(owner.wear_mask) || !(exhale_type in owner.wear_mask.filtered_gases)))
		breath.adjust_gas_temp(exhale_type, inhaled_gas_used, owner.bodytemperature, update = 0) //update afterwards

	// Were we able to breathe?
	var/failed_breath = failed_inhale || failed_exhale
	if(!failed_breath)
		last_successful_breath = world.time
		owner.adjustOxyLoss(-5 * inhale_efficiency)
		if(!BP_IS_ROBOTIC(src) && species.breathing_sound && is_below_sound_pressure(get_turf(owner)))
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

	if(damage || owner.chem_effects[CE_BREATHLOSS] || world.time > last_successful_breath + 2 MINUTES)
		owner.adjustOxyLoss(HUMAN_MAX_OXYLOSS*breath_fail_ratio)

	owner.oxygen_alert = max(owner.oxygen_alert, 2)
	last_int_pressure = 0

/obj/item/organ/internal/lungs/proc/handle_temperature_effects(datum/gas_mixture/breath)
	// Hot air hurts :(
	if((breath.temperature < species.cold_level_1 || breath.temperature > species.heat_level_1) && !(MUTATION_COLD_RESISTANCE in owner.mutations))
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

		var/relative_density = breath.total_moles / (MOLES_CELLSTANDARD * breath.volume/CELL_VOLUME)
		temp_adj *= relative_density

		if (temp_adj > BODYTEMP_HEATING_MAX) temp_adj = BODYTEMP_HEATING_MAX
		if (temp_adj < BODYTEMP_COOLING_MAX) temp_adj = BODYTEMP_COOLING_MAX
//		log_debug("Breath: [breath.temperature], [src]: [bodytemperature], Adjusting: [temp_adj]")
		owner.bodytemperature += temp_adj

	else if(breath.temperature >= species.heat_discomfort_level)
		species.get_environment_discomfort(owner,"heat")
	else if(breath.temperature <= species.cold_discomfort_level)
		species.get_environment_discomfort(owner,"cold")

/obj/item/organ/internal/lungs/listen()
	if(owner.failed_last_breath || !active_breathing)
		return "no respiration"

	if(BP_IS_ROBOTIC(src))
		if(is_bruised())
			return "malfunctioning fans"
		else
			return "air flowing"

	. = list()
	if(is_bruised())
		. += "[pick("wheezing", "gurgling")] sounds"

	var/list/breathtype = list()
	if(get_oxygen_deprivation() > 50)
		breathtype += pick("straining","labored")
	if(owner.shock_stage > 50)
		breathtype += pick("shallow and rapid")
	if(!breathtype.len)
		breathtype += "healthy"

	. += "[english_list(breathtype)] breathing"

	return english_list(.)