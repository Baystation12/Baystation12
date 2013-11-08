/mob/living/carbon/amorph
	var/obj/item/weapon/card/id/wear_id = null // Fix for station bounced radios -- Skie

	var/oxygen_alert = 0
	var/toxins_alert = 0
	var/fire_alert = 0

	var/temperature_alert = 0


/mob/living/carbon/amorph/Life()
	set invisibility = 0
	set background = 1

	if (src.monkeyizing)
		return

	..()

	var/datum/gas_mixture/environment // Added to prevent null location errors-- TLE
	if(src.loc)
		environment = loc.return_air()

	if (src.stat != 2) //still breathing

		//First, resolve location and get a breath

		if(air_master.current_cycle%4==2)
			//Only try to take a breath every 4 seconds, unless suffocating
			breathe()

		else //Still give containing object the chance to interact
			if(istype(loc, /obj/))
				var/obj/location_as_object = loc
				location_as_object.handle_internal_lifeform(src, 0)

	//Apparently, the person who wrote this code designed it so that
	//blinded get reset each cycle and then get activated later in the
	//code. Very ugly. I dont care. Moving this stuff here so its easy
	//to find it.
	src.blinded = null

	//Disease Check
	handle_virus_updates()

	//Handle temperature/pressure differences between body and environment
	if(environment)	// More error checking -- TLE
		handle_environment(environment)

	//Mutations and radiation
	handle_mutations_and_radiation()

	//Chemicals in the body
	handle_chemicals_in_body()

	//Disabilities
	handle_disabilities()

	//Status updates, death etc.
//	UpdateLuminosity()
	handle_regular_status_updates()

	if(client)
		handle_regular_hud_updates()

	//Being buckled to a chair or bed
	check_if_buckled()

	// Yup.
	update_canmove()

	clamp_values()

	// Grabbing
	for(var/obj/item/weapon/grab/G in src)
		G.process()

/mob/living/carbon/amorph
	proc

		clamp_values()

			AdjustStunned(0)
			AdjustParalysis(0)
			AdjustWeakened(0)

		handle_disabilities()
			if (src.disabilities & 4)
				if ((prob(5) && src.paralysis <= 1 && src.r_ch_cou < 1))
					src.drop_item()
					spawn( 0 )
						emote("cough")
						return
			if (src.disabilities & 8)
				if ((prob(10) && src.paralysis <= 1 && src.r_Tourette < 1))
					Stun(10)
					spawn( 0 )
						emote("twitch")
						return
			if (src.disabilities & 16)
				if (prob(10))
					src.stuttering = max(10, src.stuttering)

		update_mind()
			if(!mind && client)
				mind = new
				mind.current = src
				mind.key = key

		handle_mutations_and_radiation()
			// amorphs are immune to this stuff

		breathe()
			if(src.reagents)

				if(src.reagents.has_reagent("lexorin")) return

			if(!loc) return //probably ought to make a proper fix for this, but :effort: --NeoFite

			var/datum/gas_mixture/environment = loc.return_air()
			var/datum/gas_mixture/breath

			if(losebreath>0) //Suffocating so do not take a breath
				src.losebreath--
				if (prob(75)) //High chance of gasping for air
					spawn emote("gasp")
				if(istype(loc, /obj/))
					var/obj/location_as_object = loc
					location_as_object.handle_internal_lifeform(src, 0)
			else
				//First, check for air from internal atmosphere (using an air tank and mask generally)
				breath = get_breath_from_internal(BREATH_VOLUME)

				//No breath from internal atmosphere so get breath from location
				if(!breath)
					if(istype(loc, /obj/))
						var/obj/location_as_object = loc
						breath = location_as_object.handle_internal_lifeform(src, BREATH_VOLUME)
					else if(istype(loc, /turf/))
						var/breath_moles = environment.total_moles()*BREATH_PERCENTAGE
						breath = loc.remove_air(breath_moles)

						// Handle chem smoke effect  -- Doohl
						var/block = 0
						if(wear_mask)
							if(istype(wear_mask, /obj/item/clothing/mask/gas))
								block = 1

						if(!block)

							for(var/obj/effect/effect/chem_smoke/smoke in view(1, src))
								if(smoke.reagents.total_volume)
									smoke.reagents.reaction(src, INGEST)
									spawn(5)
										if(smoke)
											smoke.reagents.copy_to(src, 10) // I dunno, maybe the reagents enter the blood stream through the lungs?
									break // If they breathe in the nasty stuff once, no need to continue checking


				else //Still give containing object the chance to interact
					if(istype(loc, /obj/))
						var/obj/location_as_object = loc
						location_as_object.handle_internal_lifeform(src, 0)

			handle_breath(breath)

			if(breath)
				loc.assume_air(breath)


		get_breath_from_internal(volume_needed)
			if(internal)
				if (!contents.Find(src.internal))
					internal = null
				if (!wear_mask || !(wear_mask.flags|MASKINTERNALS) )
					internal = null
				if(internal)
					if (src.internals)
						src.internals.icon_state = "internal1"
					return internal.remove_air_volume(volume_needed)
				else
					if (src.internals)
						src.internals.icon_state = "internal0"
			return null

		update_canmove()
			if(paralysis || stunned || weakened || buckled || (changeling && changeling.changeling_fakedeath)) canmove = 0
			else canmove = 1

		handle_breath(datum/gas_mixture/breath)
			if(src.nodamage)
				return

			if(!breath || (breath.total_moles == 0))
				adjustOxyLoss(7)

				oxygen_alert = max(oxygen_alert, 1)

				return 0

			var/safe_oxygen_min = 8 // Minimum safe partial pressure of O2, in kPa
			//var/safe_oxygen_max = 140 // Maximum safe partial pressure of O2, in kPa (Not used for now)
			var/SA_para_min = 0.5
			var/SA_sleep_min = 5
			var/oxygen_used = 0
			var/breath_pressure = (breath.total_moles()*R_IDEAL_GAS_EQUATION*breath.temperature)/BREATH_VOLUME

			//Partial pressure of the O2 in our breath
			var/O2_pp = (breath.oxygen/breath.total_moles())*breath_pressure

			if(O2_pp < safe_oxygen_min) 			// Too little oxygen
				if(prob(20))
					spawn(0) emote("gasp")
				if (O2_pp == 0)
					O2_pp = 0.01
				var/ratio = safe_oxygen_min/O2_pp
				adjustOxyLoss(min(5*ratio, 7)) // Don't fuck them up too fast (space only does 7 after all!)
				oxygen_used = breath.oxygen*ratio/6
				oxygen_alert = max(oxygen_alert, 1)
			else 									// We're in safe limits
				adjustOxyLoss(-5)
				oxygen_used = breath.oxygen/6
				oxygen_alert = 0

			breath.oxygen -= oxygen_used
			breath.carbon_dioxide += oxygen_used

			if(breath.trace_gases.len)	// If there's some other shit in the air lets deal with it here.
				for(var/datum/gas/sleeping_agent/SA in breath.trace_gases)
					var/SA_pp = (SA.moles/breath.total_moles())*breath_pressure
					if(SA_pp > SA_para_min) // Enough to make us paralysed for a bit
						Paralyse(3) // 3 gives them one second to wake up and run away a bit!
						if(SA_pp > SA_sleep_min) // Enough to make us sleep as well
							src.sleeping = max(src.sleeping+2, 10)
					else if(SA_pp > 0.01)	// There is sleeping gas in their lungs, but only a little, so give them a bit of a warning
						if(prob(20))
							spawn(0) emote(pick("giggle", "laugh"))

			return 1

		handle_environment(datum/gas_mixture/environment)
			if(!environment)
				return
			var/environment_heat_capacity = environment.heat_capacity()
			if(istype(loc, /turf/space))
				environment_heat_capacity = loc:heat_capacity

			if((environment.temperature > (T0C + 50)) || (environment.temperature < (T0C + 10)))
				var/transfer_coefficient

				transfer_coefficient = 1
				if(wear_mask && (wear_mask.body_parts_covered & HEAD) && (environment.temperature < wear_mask.protective_temperature))
					transfer_coefficient *= wear_mask.heat_transfer_coefficient

				handle_temperature_damage(HEAD, environment.temperature, environment_heat_capacity*transfer_coefficient)

			if(stat==2)
				bodytemperature += 0.1*(environment.temperature - bodytemperature)*environment_heat_capacity/(environment_heat_capacity + 270000)

			//Account for massive pressure differences


			var/pressure = environment.return_pressure()

		//	if(!wear_suit)		Monkies cannot into space.
		//		if(!istype(wear_suit, /obj/item/clothing/suit/space))

					/*if(pressure < 20)
						if(prob(25))
							src << "You feel the splittle on your lips and the fluid on your eyes boiling away, the capillteries in your skin breaking."
						adjustBruteLoss(5)
					*/

			if(pressure > HAZARD_HIGH_PRESSURE)

				adjustBruteLoss(min((10+(round(pressure/(HIGH_STEP_PRESSURE)-2)*5)),MAX_PRESSURE_DAMAGE))



			return //TODO: DEFERRED

		handle_temperature_damage(body_part, exposed_temperature, exposed_intensity)
			if(src.nodamage) return
			var/discomfort = min( abs(exposed_temperature - bodytemperature)*(exposed_intensity)/2000000, 1.0)
			if(exposed_temperature > bodytemperature)
				adjustFireLoss(20.0*discomfort)

			else
				adjustFireLoss(5.0*discomfort)

		handle_chemicals_in_body()
			// most chemicals will have no effect on amorphs
			//if(reagents) reagents.metabolize(src)

			if (src.drowsyness)
				src.drowsyness--
				src.eye_blurry = max(2, src.eye_blurry)
				if (prob(5))
					src.sleeping += 1
					Paralyse(5)

			confused = max(0, confused - 1)
			// decrement dizziness counter, clamped to 0
			if(resting)
				dizziness = max(0, dizziness - 5)
			else
				dizziness = max(0, dizziness - 1)

			src.updatehealth()

			return //TODO: DEFERRED

		handle_regular_status_updates()

			health = 100 - (getOxyLoss() + getToxLoss() + getFireLoss() + getBruteLoss() + getCloneLoss())

			if(getOxyLoss() > 25) Paralyse(3)

			if(src.sleeping)
				Paralyse(5)
				if (prob(1) && health) spawn(0) emote("snore")

			if(src.resting)
				Weaken(5)

			if(health < config.health_threshold_dead && stat != 2)
				death()
			else if(src.health < config.health_threshold_crit)
				if(src.health <= 20 && prob(1)) spawn(0) emote("gasp")

				// shuffle around the chemical effects for amorphs a little ;)
				if(!src.reagents.has_reagent("antitoxin") && src.stat != 2) src.adjustOxyLoss(2)

				if(src.stat != 2)	src.stat = 1
				Paralyse(5)

			if (src.stat != 2) //Alive.

				if (src.paralysis || src.stunned || src.weakened) //Stunned etc.
					if (src.stunned > 0)
						AdjustStunned(-1)
						src.stat = 0
					if (src.weakened > 0)
						AdjustWeakened(-1)
						src.lying = 1
						src.stat = 0
					if (src.paralysis > 0)
						AdjustParalysis(-1)
						src.blinded = 1
						src.lying = 1
						src.stat = 1
					var/h = src.hand
					src.hand = 0
					drop_item()
					src.hand = 1
					drop_item()
					src.hand = h

				else	//Not stunned.
					src.lying = 0
					src.stat = 0

			else //Dead.
				src.lying = 1
				src.blinded = 1
				src.stat = 2

			if (src.stuttering) src.stuttering--
			if (src.slurring) src.slurring--

			if (src.eye_blind)
				src.eye_blind--
				src.blinded = 1

			if (src.ear_deaf > 0) src.ear_deaf--
			if (src.ear_damage < 25)
				src.ear_damage -= 0.05
				src.ear_damage = max(src.ear_damage, 0)

			src.density = !( src.lying )

			if (src.disabilities & 128)
				src.blinded = 1
			if (src.disabilities & 32)
				src.ear_deaf = 1

			if (src.eye_blurry > 0)
				src.eye_blurry--
				src.eye_blurry = max(0, src.eye_blurry)

			if (src.druggy > 0)
				src.druggy--
				src.druggy = max(0, src.druggy)

			return 1

		handle_regular_hud_updates()

			if (src.stat == 2 || (XRAY in mutations))
				src.sight |= SEE_TURFS
				src.sight |= SEE_MOBS
				src.sight |= SEE_OBJS
				src.see_in_dark = 8
				src.see_invisible = 2
			else if (src.stat != 2)
				src.sight &= ~SEE_TURFS
				src.sight &= ~SEE_MOBS
				src.sight &= ~SEE_OBJS
				src.see_in_dark = 2
				src.see_invisible = 0

			if (src.sleep)
				src.sleep.icon_state = text("sleep[]", src.sleeping > 0 ? 1 : 0)
				src.sleep.overlays = null
				if(src.sleeping_willingly)
					src.sleep.overlays += icon(src.sleep.icon, "sleep_willing")
			if (src.rest) src.rest.icon_state = text("rest[]", src.resting)

			if (src.healths)
				if (src.stat != 2)
					switch(health)
						if(100 to INFINITY)
							src.healths.icon_state = "health0"
						if(80 to 100)
							src.healths.icon_state = "health1"
						if(60 to 80)
							src.healths.icon_state = "health2"
						if(40 to 60)
							src.healths.icon_state = "health3"
						if(20 to 40)
							src.healths.icon_state = "health4"
						if(0 to 20)
							src.healths.icon_state = "health5"
						else
							src.healths.icon_state = "health6"
				else
					src.healths.icon_state = "health7"

			if (pressure)
				var/datum/gas_mixture/environment = loc.return_air()
				if(environment)
					switch(environment.return_pressure())

						if(HAZARD_HIGH_PRESSURE to INFINITY)
							pressure.icon_state = "pressure2"
						if(WARNING_HIGH_PRESSURE to HAZARD_HIGH_PRESSURE)
							pressure.icon_state = "pressure1"
						if(WARNING_LOW_PRESSURE to WARNING_HIGH_PRESSURE)
							pressure.icon_state = "pressure0"
						if(HAZARD_LOW_PRESSURE to WARNING_LOW_PRESSURE)
							pressure.icon_state = "pressure-1"
						else
							pressure.icon_state = "pressure-2"

			if(src.pullin)	src.pullin.icon_state = "pull[src.pulling ? 1 : 0]"


			if (src.toxin)	src.toxin.icon_state = "tox[src.toxins_alert ? 1 : 0]"
			if (src.oxygen) src.oxygen.icon_state = "oxy[src.oxygen_alert ? 1 : 0]"
			if (src.fire) src.fire.icon_state = "fire[src.fire_alert ? 1 : 0]"
			//NOTE: the alerts dont reset when youre out of danger. dont blame me,
			//blame the person who coded them. Temporary fix added.

			if(bodytemp)
				switch(src.bodytemperature) //310.055 optimal body temp
					if(345 to INFINITY)
						src.bodytemp.icon_state = "temp4"
					if(335 to 345)
						src.bodytemp.icon_state = "temp3"
					if(327 to 335)
						src.bodytemp.icon_state = "temp2"
					if(316 to 327)
						src.bodytemp.icon_state = "temp1"
					if(300 to 316)
						src.bodytemp.icon_state = "temp0"
					if(295 to 300)
						src.bodytemp.icon_state = "temp-1"
					if(280 to 295)
						src.bodytemp.icon_state = "temp-2"
					if(260 to 280)
						src.bodytemp.icon_state = "temp-3"
					else
						src.bodytemp.icon_state = "temp-4"

			src.client.screen -= src.hud_used.blurry
			src.client.screen -= src.hud_used.druggy
			src.client.screen -= src.hud_used.vimpaired

			if ((src.blind && src.stat != 2))
				if ((src.blinded))
					src.blind.layer = 18
				else
					src.blind.layer = 0

					if (src.disabilities & 1)
						src.client.screen += src.hud_used.vimpaired

					if (src.eye_blurry)
						src.client.screen += src.hud_used.blurry

					if (src.druggy)
						src.client.screen += src.hud_used.druggy

			if (src.stat != 2)
				if (src.machine)
					if (!( src.machine.check_eye(src) ))
						src.reset_view(null)
				else
					if(!client.adminobs)
						reset_view(null)

			return 1

		handle_virus_updates()
			// amorphs can't come down with human diseases
			return