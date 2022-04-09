/mob/living/simple_animal/Life()
	. = ..()
	if(!.)
		return FALSE
	//Health
	if(stat == DEAD)
		if(health > 0)
			icon_state = icon_living
			switch_from_dead_to_living_mob_list()
			set_stat(CONSCIOUS)
			set_density(1)
		return 0

	handle_atmos()

	if(health <= 0)
		death()
		return

	if(health > maxHealth)
		health = maxHealth

	handle_stunned()
	handle_weakened()
	handle_paralysed()
	handle_confused()
	handle_supernatural()
	handle_impaired_vision()

	handle_special()

	if(can_bleed && bleed_ticks > 0)
		handle_bleeding()

	if(buckled && can_escape)
		if(istype(buckled, /obj/effect/energy_net))
			var/obj/effect/energy_net/Net = buckled
			Net.escape_net(src)
		else if(prob(50))
			escape(src, buckled)
		else if(prob(50))
			visible_message("<span class='warning'>\The [src] struggles against \the [buckled]!</span>")

	return 1


/mob/living/simple_animal/proc/handle_atmos(var/atmos_suitable = 1)
	//Atmos

	if(!loc)
		return

	var/datum/gas_mixture/environment = loc.return_air()
	if(!(MUTATION_SPACERES in mutations) && environment)

		if(abs(environment.temperature - bodytemperature) > 40 )
			bodytemperature += ((environment.temperature - bodytemperature) / 5)

		 // don't bother checking it twice if we got a supplied 0 val.
		if(atmos_suitable)
			if(LAZYLEN(min_gas))
				for(var/gas in min_gas)
					if(environment.gas[gas] < min_gas[gas])
						atmos_suitable = FALSE
						break
			if(atmos_suitable && LAZYLEN(max_gas))
				for(var/gas in max_gas)
					if(environment.gas[gas] > max_gas[gas])
						atmos_suitable = FALSE
						break

	//Atmos effect
	if(bodytemperature < minbodytemp)
		fire_alert = 2
		adjustBruteLoss(cold_damage_per_tick)
	else if(bodytemperature > maxbodytemp)
		fire_alert = 1
		adjustBruteLoss(heat_damage_per_tick)
	else
		fire_alert = 0

	if(!atmos_suitable)
		adjustBruteLoss(unsuitable_atmos_damage)

/mob/living/simple_animal/proc/escape(mob/living/M, obj/O)
	O.unbuckle_mob(M)
	visible_message("<span class='danger'>\The [M] escapes from \the [O]!</span>")

/mob/living/simple_animal/proc/handle_supernatural()
	if(purge)
		purge -= 1

/mob/living/simple_animal/gib()
	..(icon_gib,1)

/mob/living/simple_animal/proc/visible_emote(var/act_desc)
	custom_emote(1, act_desc)

/mob/living/simple_animal/proc/audible_emote(var/act_desc)
	custom_emote(2, act_desc)

/mob/living/simple_animal/proc/handle_special()
	return