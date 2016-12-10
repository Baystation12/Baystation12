/mob/living/carbon/slime/Life()
	set invisibility = 0
	set background = 1

	if (src.transforming)
		return

	..()

	if(stat != DEAD)
		handle_nutrition()

		if(!client)
			handle_regular_AI()

/mob/living/carbon/slime/handle_environment(datum/gas_mixture/environment)
	if(!environment)
		adjustToxLoss(rand(10,20))
		return

	//var/environment_heat_capacity = environment.heat_capacity()
	var/loc_temp = T0C
	if(istype(get_turf(src), /turf/space))
		//environment_heat_capacity = loc:heat_capacity
		var/turf/heat_turf = get_turf(src)
		loc_temp = heat_turf.temperature
	else if(istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))
		loc_temp = loc:air_contents.temperature
	else
		loc_temp = environment.temperature

	bodytemperature += adjust_body_temperature(bodytemperature, loc_temp, 1)

	if(bodytemperature < (T0C + 5)) // start calculating temperature damage etc
		if(bodytemperature <= hurt_temperature)
			if(bodytemperature <= die_temperature)
				adjustToxLoss(200)
			else
				// could be more fancy, but doesn't worth the complexity: when the slimes goes into a cold area
				// the damage is mostly determined by how fast its body cools
				adjustToxLoss(30)

	updatehealth()

	return //TODO: DEFERRED

/mob/living/carbon/slime/proc/adjust_body_temperature(current, loc_temp, boost)
	var/temperature = current
	var/difference = abs(current-loc_temp)	//get difference
	var/increments// = difference/10			//find how many increments apart they are
	if(difference > 50)
		increments = difference/5
	else
		increments = difference/10
	var/change = increments*boost	// Get the amount to change by (x per increment)
	var/temp_change
	if(current < loc_temp)
		temperature = min(loc_temp, temperature+change)
	else if(current > loc_temp)
		temperature = max(loc_temp, temperature-change)
	temp_change = (temperature - current)
	return temp_change

/mob/living/carbon/slime/handle_chemicals_in_body()
	chem_effects.Cut()

	if(touching) touching.metabolize()
	if(ingested) ingested.metabolize()
	if(bloodstr) bloodstr.metabolize()

	src.updatehealth()

	return //TODO: DEFERRED

/mob/living/carbon/slime/handle_regular_status_updates()

	src.blinded = null

	health = maxHealth - (getOxyLoss() + getToxLoss() + getFireLoss() + getBruteLoss() + getCloneLoss())

	if(health < 0 && stat != DEAD)
		death()
		return

	if (halloss)
		halloss = 0

	if(prob(30))
		adjustOxyLoss(-1)
		adjustToxLoss(-1)
		adjustFireLoss(-1)
		adjustCloneLoss(-1)
		adjustBruteLoss(-1)

	if (src.stat == DEAD)
		src.lying = 1
		src.blinded = 1
	else
		if (src.paralysis || src.stunned || src.weakened || (status_flags && FAKEDEATH)) //Stunned etc.
			if (src.stunned > 0)
				src.stat = 0
			if (src.weakened > 0)
				src.lying = 0
				src.stat = 0
			if (src.paralysis > 0)
				src.blinded = 0
				src.lying = 0
				src.stat = 0

		else
			src.lying = 0
			src.stat = 0

	if (src.stuttering) src.stuttering = 0

	if (src.eye_blind)
		src.eye_blind = 0
		src.blinded = 1

	if (src.ear_deaf > 0) src.ear_deaf = 0
	if (src.ear_damage < 25)
		src.ear_damage = 0

	src.density = !( src.lying )

	if (src.sdisabilities & BLIND)
		src.blinded = 1
	if (src.sdisabilities & DEAF)
		src.ear_deaf = 1

	if (src.eye_blurry > 0)
		src.eye_blurry = 0

	if (src.druggy > 0)
		src.druggy = 0

	return 1

/mob/living/carbon/slime/proc/handle_nutrition()

	nutrition -= 0.1 + 0.05 * is_adult

	if(nutrition <= 0)
		nutrition = 0
		adjustToxLoss(2)
		if (client && prob(5))
			to_chat(src, "<span class='danger'>You are starving!</span>")

	else if (nutrition >= get_grow_nutrition() && amount_grown < 10)
		nutrition -= 20
		amount_grown++

/mob/living/carbon/slime/proc/get_max_nutrition() // Can't go above it
	if (is_adult) return 1200
	else return 1000

/mob/living/carbon/slime/proc/get_grow_nutrition() // Above it we grow, below it we can eat
	if (is_adult) return 1000
	else return 800

/mob/living/carbon/slime/proc/get_hunger_nutrition() // Below it we will always eat
	if (is_adult) return 600
	else return 500

/mob/living/carbon/slime/proc/get_starve_nutrition() // Below it we will eat before everything else
	if (is_adult) return 300
	else return 200

/mob/living/carbon/slime/slip() //Can't slip something without legs.
	return 0
