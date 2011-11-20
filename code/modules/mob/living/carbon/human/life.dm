#define HUMAN_MAX_OXYLOSS 12 //Defines how much oxyloss humans can get per tick. No air applies this value.

/mob/living/carbon/human
	var
		oxygen_alert = 0
		toxins_alert = 0
		fire_alert = 0

		temperature_alert = 0


/mob/living/carbon/human/Life()
	set invisibility = 0
	set background = 1

	if (monkeyizing)
		return

	if(!loc)			// Fixing a null error that occurs when the mob isn't found in the world -- TLE
		return

	var/datum/gas_mixture/environment = loc.return_air()

	if (stat != 2) //still breathing

		//First, resolve location and get a breath

		if(air_master.current_cycle%4==2)
			//Only try to take a breath every 4 seconds, unless suffocating
			spawn(0) breathe()

		else //Still give containing object the chance to interact
			if(istype(loc, /obj/))
				var/obj/location_as_object = loc
				location_as_object.handle_internal_lifeform(src, 0)

	//Apparently, the person who wrote this code designed it so that
	//blinded get reset each cycle and then get activated later in the
	//code. Very ugly. I dont care. Moving this stuff here so its easy
	//to find it.
	blinded = null

	//Update Mind
	update_mind()

	//Disease Check
	handle_virus_updates()

	//Changeling things
	handle_changeling()

	//Handle temperature/pressure differences between body and environment
	handle_environment(environment)

	//Mutations and radiation
	handle_mutations_and_radiation()

	//Chemicals in the body
	handle_chemicals_in_body()

	//stuff in the stomach
	handle_stomach()

	//Disabilities
	handle_disabilities()

	//Status updates, death etc.
	UpdateLuminosity()
	handle_regular_status_updates()

	// Update clothing
	update_clothing()

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

	if(isturf(loc) && rand(1,1000) == 1) //0.1% chance of playing a scary sound to someone who's in complete darkness
		var/turf/currentTurf = loc
		if(!currentTurf.sd_lumcount)
			playsound_local(src,pick(scarySounds),50, 1, -1)

	..() //for organs


/mob/living/carbon/human
	proc
		clamp_values()

			stunned = max(min(stunned, 20),0)
			paralysis = max(min(paralysis, 20), 0)
			weakened = max(min(weakened, 20), 0)
			sleeping = max(min(sleeping, 20), 0)
			bruteloss = max(getBruteLoss(), 0)
			toxloss = max(getToxLoss(), 0)
			oxyloss = max(getOxyLoss(), 0)
			fireloss = max(fireloss, 0)


		update_mind()
			if(!mind && client)
				mind = new
				mind.current = src
				mind.assigned_role = job
				if(!mind.assigned_role)
					mind.assigned_role = "Assistant"
				mind.key = key


		handle_disabilities()
			if (disabilities & 2)
				if ((prob(1) && paralysis < 1 && r_epil < 1))
					src << "\red You have a seizure!"
					for(var/mob/O in viewers(src, null))
						if(O == src)
							continue
						O.show_message(text("\red <B>[src] starts having a seizure!"), 1)
					paralysis = max(10, paralysis)
					make_jittery(1000)
			if (disabilities & 4)
				if ((prob(5) && paralysis <= 1 && r_ch_cou < 1))
					drop_item()
					spawn( 0 )
						emote("cough")
						return
			if (disabilities & 8)
				if ((prob(10) && paralysis <= 1 && r_Tourette < 1))
					stunned = max(10, stunned)
					spawn( 0 )
						switch(rand(1, 3))
							if(1)
								emote("twitch")
							if(2 to 3)
								say("[prob(50) ? ";" : ""][pick("SHIT", "PISS", "FUCK", "CUNT", "COCKSUCKER", "MOTHERFUCKER", "TITS")]")
						var/old_x = pixel_x
						var/old_y = pixel_y
						pixel_x += rand(-2,2)
						pixel_y += rand(-1,1)
						sleep(2)
						pixel_x = old_x
						pixel_y = old_y
						return
			if (disabilities & 16)
				if (prob(10))
					stuttering = max(10, stuttering)
			if (brainloss >= 60 && stat != 2)
				if (prob(7))
					switch(pick(1,2,3))
						if(1)
							say(pick("IM A PONY NEEEEEEIIIIIIIIIGH", "without oxigen blob don't evoluate?", "CAPTAINS A COMDOM", "[pick("", "that faggot traitor")] [pick("joerge", "george", "gorge", "gdoruge")] [pick("mellens", "melons", "mwrlins")] is grifing me HAL;P!!!", "can u give me [pick("telikesis","halk","eppilapse")]?", "THe saiyans screwed", "Bi is THE BEST OF BOTH WORLDS>", "I WANNA PET TEH MONKIES", "stop grifing me!!!!", "SOTP IT#"))
						if(2)
							say(pick("fucking 4rries!", "stat me", ">my face", "roll it easy!", "waaaaaagh!!!", "red wonz go fasta", "FOR TEH EMPRAH", "lol2cat", "dem dwarfs man, dem dwarfs", "SPESS MAHREENS", "hwee did eet fhor khayosss", "lifelike texture ;_;", "luv can bloooom"))
						if(3)
							emote("drool")


		handle_mutations_and_radiation()
			if(fireloss)
				if(mutations & COLD_RESISTANCE || (prob(1) && prob(75)))
					heal_organ_damage(0,1)

			if (mutations & HULK && health <= 25)
				mutations &= ~HULK
				src << "\red You suddenly feel very weak."
				weakened = 3
				emote("collapse")

			if (radiation)
				if (radiation > 100)
					radiation = 100
					weakened = 10
					src << "\red You feel weak."
					emote("collapse")

				if (radiation < 0)
					radiation = 0

				switch(radiation)
					if(1 to 49)
						radiation--
						if(prob(25))
							adjustToxLoss(1)
							updatehealth()

					if(50 to 74)
						radiation -= 2
						adjustToxLoss(1)
						if(prob(5))
							radiation -= 5
							weakened = 3
							src << "\red You feel weak."
							emote("collapse")
						updatehealth()

					if(75 to 100)
						radiation -= 3
						adjustToxLoss(3)
						if(prob(1))
							src << "\red You mutate!"
							randmutb(src)
							domutcheck(src,null)
							emote("gasp")
						updatehealth()


		breathe()

			if(reagents.has_reagent("lexorin")) return
			if(istype(loc, /obj/machinery/atmospherics/unary/cryo_cell)) return

			var/datum/gas_mixture/environment = loc.return_air()
			var/datum/air_group/breath
			// HACK NEED CHANGING LATER
			if(health < 0)
				losebreath++

			if(losebreath>0) //Suffocating so do not take a breath
				losebreath--
				if (prob(75)) //High chance of gasping for air
					spawn emote("gasp")
				if(istype(loc, /obj/))
					var/obj/location_as_object = loc
					location_as_object.handle_internal_lifeform(src, 0)
			else
				//First, check for air from internal atmosphere (using an air tank and mask generally)
				breath = get_breath_from_internal(BREATH_VOLUME) // Super hacky -- TLE
				//breath = get_breath_from_internal(0.5) // Manually setting to old BREATH_VOLUME amount -- TLE

				//No breath from internal atmosphere so get breath from location
				if(!breath)
					if(istype(loc, /obj/))
						var/obj/location_as_object = loc
						breath = location_as_object.handle_internal_lifeform(src, BREATH_VOLUME)
					else if(istype(loc, /turf/))
						var/breath_moles = 0
						/*if(environment.return_pressure() > ONE_ATMOSPHERE)
							// Loads of air around (pressure effect will be handled elsewhere), so lets just take a enough to fill our lungs at normal atmos pressure (using n = Pv/RT)
							breath_moles = (ONE_ATMOSPHERE*BREATH_VOLUME/R_IDEAL_GAS_EQUATION*environment.temperature)
						else*/
							// Not enough air around, take a percentage of what's there to model this properly
						breath_moles = environment.total_moles()*BREATH_PERCENTAGE

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
				if (!contents.Find(internal))
					internal = null
				if (!wear_mask || !(wear_mask.flags & MASKINTERNALS) )
					internal = null
				if(internal)
					//if (internals) //should be unnecessary, uncomment if it isn't. -raftaf0
					//	internals.icon_state = "internal1"
					return internal.remove_air_volume(volume_needed)
				else if(internals)
					internals.icon_state = "internal0"
			return null

		update_canmove()
			if(paralysis || stunned || weakened || buckled || (changeling && changeling.changeling_fakedeath)) canmove = 0
			else canmove = 1

		handle_breath(datum/gas_mixture/breath)
			if(nodamage)
				return

			if(!breath || (breath.total_moles() == 0))
				if(reagents.has_reagent("inaprovaline"))
					return
				oxyloss += HUMAN_MAX_OXYLOSS

				oxygen_alert = max(oxygen_alert, 1)

				return 0

			var/safe_oxygen_min = 16 // Minimum safe partial pressure of O2, in kPa
			//var/safe_oxygen_max = 140 // Maximum safe partial pressure of O2, in kPa (Not used for now)
			var/safe_co2_max = 10 // Yes it's an arbitrary value who cares?
			var/safe_toxins_max = 0.005
			var/SA_para_min = 1
			var/SA_sleep_min = 5
			var/oxygen_used = 0
			var/breath_pressure = (breath.total_moles()*R_IDEAL_GAS_EQUATION*breath.temperature)/BREATH_VOLUME

			//Partial pressure of the O2 in our breath
			var/O2_pp = (breath.oxygen/breath.total_moles())*breath_pressure
			// Same, but for the toxins
			var/Toxins_pp = (breath.toxins/breath.total_moles())*breath_pressure
			// And CO2, lets say a PP of more than 10 will be bad (It's a little less really, but eh, being passed out all round aint no fun)
			var/CO2_pp = (breath.carbon_dioxide/breath.total_moles())*breath_pressure // Tweaking to fit the hacky bullshit I've done with atmo -- TLE
			//var/CO2_pp = (breath.carbon_dioxide/breath.total_moles())*0.5 // The default pressure value

			if(O2_pp < safe_oxygen_min) 			// Too little oxygen
				if(prob(20))
					spawn(0) emote("gasp")
				if(O2_pp > 0)
					var/ratio = safe_oxygen_min/O2_pp
					oxyloss += min(5*ratio, HUMAN_MAX_OXYLOSS) // Don't fuck them up too fast (space only does HUMAN_MAX_OXYLOSS after all!)
					oxygen_used = breath.oxygen*ratio/6
				else
					oxyloss += HUMAN_MAX_OXYLOSS
				oxygen_alert = max(oxygen_alert, 1)
			/*else if (O2_pp > safe_oxygen_max) 		// Too much oxygen (commented this out for now, I'll deal with pressure damage elsewhere I suppose)
				spawn(0) emote("cough")
				var/ratio = O2_pp/safe_oxygen_max
				oxyloss += 5*ratio
				oxygen_used = breath.oxygen*ratio/6
				oxygen_alert = max(oxygen_alert, 1)*/
			else								// We're in safe limits
				oxyloss = max(getOxyLoss()-5, 0)
				oxygen_used = breath.oxygen/6
				oxygen_alert = 0

			breath.oxygen -= oxygen_used
			breath.carbon_dioxide += oxygen_used

			if(CO2_pp > safe_co2_max)
				if(!co2overloadtime) // If it's the first breath with too much CO2 in it, lets start a counter, then have them pass out after 12s or so.
					co2overloadtime = world.time
				else if(world.time - co2overloadtime > 120)
					paralysis = max(paralysis, 3)
					oxyloss += 3 // Lets hurt em a little, let them know we mean business
					if(world.time - co2overloadtime > 300) // They've been in here 30s now, lets start to kill them for their own good!
						oxyloss += 8
				if(prob(20)) // Lets give them some chance to know somethings not right though I guess.
					spawn(0) emote("cough")

			else
				co2overloadtime = 0

			if(Toxins_pp > safe_toxins_max) // Too much toxins
				var/ratio = breath.toxins/safe_toxins_max
				adjustToxLoss(min(ratio, 10))	//Limit amount of damage toxin exposure can do per second
				toxins_alert = max(toxins_alert, 1)
			else
				toxins_alert = 0

			if(breath.trace_gases.len)	// If there's some other shit in the air lets deal with it here.
				for(var/datum/gas/sleeping_agent/SA in breath.trace_gases)
					var/SA_pp = (SA.moles/breath.total_moles())*breath_pressure
					if(SA_pp > SA_para_min) // Enough to make us paralysed for a bit
						paralysis = max(paralysis, 3) // 3 gives them one second to wake up and run away a bit!
						if(SA_pp > SA_sleep_min) // Enough to make us sleep as well
							sleeping = max(sleeping, 2)
					else if(SA_pp > 0.01)	// There is sleeping gas in their lungs, but only a little, so give them a bit of a warning
						if(prob(20))
							spawn(0) emote(pick("giggle", "laugh"))


			if(breath.temperature > (T0C+66) && !(mutations & COLD_RESISTANCE)) // Hot air hurts :(
				if(prob(20))
					src << "\red You feel a searing heat in your lungs!"
				fire_alert = max(fire_alert, 1)
			else
				fire_alert = 0



			//Temporary fixes to the alerts.

			return 1

		handle_environment(datum/gas_mixture/environment)
			if(!environment)
				return
			var/environment_heat_capacity = environment.heat_capacity()
			var/loc_temp = T0C
			if(istype(loc, /turf/space))
				environment_heat_capacity = loc:heat_capacity
				loc_temp = 2.7
			else if(istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))
				loc_temp = loc:air_contents.temperature
			else
				loc_temp = environment.temperature

			var/thermal_protection = get_thermal_protection()

			//world << "Loc temp: [loc_temp] - Body temp: [bodytemperature] - Fireloss: [fireloss] - Thermal protection: [get_thermal_protection()] - Fire protection: [thermal_protection + add_fire_protection(loc_temp)]"

			if(stat != 2 && abs(bodytemperature - 310.15) < 50)
				bodytemperature += adjust_body_temperature(bodytemperature, 310.15, thermal_protection)
			if(loc_temp < 310.15) // a cold place -> add in cold protection
				bodytemperature += adjust_body_temperature(bodytemperature, loc_temp, 1/thermal_protection)
			else // a hot place -> add in heat protection
				thermal_protection += add_fire_protection(loc_temp)
				bodytemperature += adjust_body_temperature(bodytemperature, loc_temp, 1/thermal_protection)

			// lets give them a fair bit of leeway so they don't just start dying
			//as that may be realistic but it's no fun
			if((bodytemperature > (T0C + 50)) || (bodytemperature < (T0C + 10)) && (!istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))) // Last bit is just disgusting, i know
				if(environment.temperature > (T0C + 50) || (environment.temperature < (T0C + 10)))
					var/transfer_coefficient

					transfer_coefficient = 1
					if(head && (head.body_parts_covered & HEAD) && (environment.temperature < head.protective_temperature))
						transfer_coefficient *= head.heat_transfer_coefficient
					if(wear_mask && (wear_mask.body_parts_covered & HEAD) && (environment.temperature < wear_mask.protective_temperature))
						transfer_coefficient *= wear_mask.heat_transfer_coefficient
					if(wear_suit && (wear_suit.body_parts_covered & HEAD) && (environment.temperature < wear_suit.protective_temperature))
						transfer_coefficient *= wear_suit.heat_transfer_coefficient

					handle_temperature_damage(HEAD, environment.temperature, environment_heat_capacity*transfer_coefficient)

					transfer_coefficient = 1
					if(wear_suit && (wear_suit.body_parts_covered & UPPER_TORSO) && (environment.temperature < wear_suit.protective_temperature))
						transfer_coefficient *= wear_suit.heat_transfer_coefficient
					if(w_uniform && (w_uniform.body_parts_covered & UPPER_TORSO) && (environment.temperature < w_uniform.protective_temperature))
						transfer_coefficient *= w_uniform.heat_transfer_coefficient

					handle_temperature_damage(UPPER_TORSO, environment.temperature, environment_heat_capacity*transfer_coefficient)

					transfer_coefficient = 1
					if(wear_suit && (wear_suit.body_parts_covered & LOWER_TORSO) && (environment.temperature < wear_suit.protective_temperature))
						transfer_coefficient *= wear_suit.heat_transfer_coefficient
					if(w_uniform && (w_uniform.body_parts_covered & LOWER_TORSO) && (environment.temperature < w_uniform.protective_temperature))
						transfer_coefficient *= w_uniform.heat_transfer_coefficient

					handle_temperature_damage(LOWER_TORSO, environment.temperature, environment_heat_capacity*transfer_coefficient)

					transfer_coefficient = 1
					if(wear_suit && (wear_suit.body_parts_covered & LEGS) && (environment.temperature < wear_suit.protective_temperature))
						transfer_coefficient *= wear_suit.heat_transfer_coefficient
					if(w_uniform && (w_uniform.body_parts_covered & LEGS) && (environment.temperature < w_uniform.protective_temperature))
						transfer_coefficient *= w_uniform.heat_transfer_coefficient

					handle_temperature_damage(LEGS, environment.temperature, environment_heat_capacity*transfer_coefficient)

					transfer_coefficient = 1
					if(wear_suit && (wear_suit.body_parts_covered & ARMS) && (environment.temperature < wear_suit.protective_temperature))
						transfer_coefficient *= wear_suit.heat_transfer_coefficient
					if(w_uniform && (w_uniform.body_parts_covered & ARMS) && (environment.temperature < w_uniform.protective_temperature))
						transfer_coefficient *= w_uniform.heat_transfer_coefficient

					handle_temperature_damage(ARMS, environment.temperature, environment_heat_capacity*transfer_coefficient)

					transfer_coefficient = 1
					if(wear_suit && (wear_suit.body_parts_covered & HANDS) && (environment.temperature < wear_suit.protective_temperature))
						transfer_coefficient *= wear_suit.heat_transfer_coefficient
					if(gloves && (gloves.body_parts_covered & HANDS) && (environment.temperature < gloves.protective_temperature))
						transfer_coefficient *= gloves.heat_transfer_coefficient

					handle_temperature_damage(HANDS, environment.temperature, environment_heat_capacity*transfer_coefficient)

					transfer_coefficient = 1
					if(wear_suit && (wear_suit.body_parts_covered & FEET) && (environment.temperature < wear_suit.protective_temperature))
						transfer_coefficient *= wear_suit.heat_transfer_coefficient
					if(shoes && (shoes.body_parts_covered & FEET) && (environment.temperature < shoes.protective_temperature))
						transfer_coefficient *= shoes.heat_transfer_coefficient

					handle_temperature_damage(FEET, environment.temperature, environment_heat_capacity*transfer_coefficient)

			/*if(stat==2) //Why only change body temp when they're dead? That makes no sense!!!!!!
				bodytemperature += 0.8*(environment.temperature - bodytemperature)*environment_heat_capacity/(environment_heat_capacity + 270000)
			*/

			//Account for massive pressure differences
			return //TODO: DEFERRED

		adjust_body_temperature(current, loc_temp, boost)
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

		get_thermal_protection()
			var/thermal_protection = 1.0
			//Handle normal clothing
			if(head && (head.body_parts_covered & HEAD))
				thermal_protection += 0.5
			if(wear_suit && (wear_suit.body_parts_covered & UPPER_TORSO))
				thermal_protection += 0.5
			if(w_uniform && (w_uniform.body_parts_covered & UPPER_TORSO))
				thermal_protection += 0.5
			if(wear_suit && (wear_suit.body_parts_covered & LEGS))
				thermal_protection += 0.2
			if(wear_suit && (wear_suit.body_parts_covered & ARMS))
				thermal_protection += 0.2
			if(wear_suit && (wear_suit.body_parts_covered & HANDS))
				thermal_protection += 0.2
			if(shoes && (shoes.body_parts_covered & FEET))
				thermal_protection += 0.2
			if(wear_suit && (wear_suit.flags & SUITSPACE))
				thermal_protection += 3
			if(w_uniform && (w_uniform.flags & SUITSPACE))
				thermal_protection += 3
			if(head && (head.flags & HEADSPACE))
				thermal_protection += 1
			if(mutations & COLD_RESISTANCE)
				thermal_protection += 5

			return thermal_protection

		add_fire_protection(var/temp)
			var/fire_prot = 0
			if(head)
				if(head.protective_temperature > temp)
					fire_prot += (head.protective_temperature/10)
			if(wear_mask)
				if(wear_mask.protective_temperature > temp)
					fire_prot += (wear_mask.protective_temperature/10)
			if(glasses)
				if(glasses.protective_temperature > temp)
					fire_prot += (glasses.protective_temperature/10)
			if(ears)
				if(ears.protective_temperature > temp)
					fire_prot += (ears.protective_temperature/10)
			if(wear_suit)
				if(wear_suit.protective_temperature > temp)
					fire_prot += (wear_suit.protective_temperature/10)
			if(w_uniform)
				if(w_uniform.protective_temperature > temp)
					fire_prot += (w_uniform.protective_temperature/10)
			if(gloves)
				if(gloves.protective_temperature > temp)
					fire_prot += (gloves.protective_temperature/10)
			if(shoes)
				if(shoes.protective_temperature > temp)
					fire_prot += (shoes.protective_temperature/10)

			return fire_prot

		handle_temperature_damage(body_part, exposed_temperature, exposed_intensity)
			if(nodamage)
				return
			var/discomfort = min(abs(exposed_temperature - bodytemperature)*(exposed_intensity)/2000000, 1.0)

			if(mutantrace == "plant")
				discomfort *= 3 //I don't like magic numbers. I'll make mutantraces a datum with vars sometime later. -- Urist
			else
				discomfort *= 1.5 //Dangercon 2011 - Upping damage by use of magic numbers - Errorage

			switch(body_part)
				if(HEAD)
					apply_damage(2.5*discomfort, BURN, "head")
				if(UPPER_TORSO)
					apply_damage(2.5*discomfort, BURN, "chest")
				if(LEGS)
					apply_damage(0.6*discomfort, BURN, "l_leg")
					apply_damage(0.6*discomfort, BURN, "r_leg")
				if(ARMS)
					apply_damage(0.4*discomfort, BURN, "l_arm")
					apply_damage(0.4*discomfort, BURN, "r_arm")

		handle_chemicals_in_body()
			if(reagents) reagents.metabolize(src)

			if(mutantrace == "plant") //couldn't think of a better place to place it, since it handles nutrition -- Urist
				var/light_amount = 0 //how much light there is in the place, affects receiving nutrition and healing
				if(istype(loc,/turf)) //else, there's considered to be no light
					light_amount = min(10,loc:sd_lumcount) - 5 //hardcapped so it's not abused by having a ton of flashlights
				if(nutrition < 500) //so they can't store nutrition to survive without light forever
					nutrition += light_amount
				if(light_amount > 0) //if there's enough light, heal
					if(fireloss)
						heal_overall_damage(0,1)
					if(getBruteLoss())
						heal_overall_damage(1,0)
					adjustToxLoss(-1)

					if(getOxyLoss())
						oxyloss--

			if(overeatduration > 500 && !(mutations & FAT))
				src << "\red You suddenly feel blubbery!"
				mutations |= FAT
				update_body()
			if (overeatduration < 100 && mutations & FAT)
				src << "\blue You feel fit again!"
				mutations &= ~FAT
				update_body()

			// nutrition decrease
			if (nutrition > 0 && stat != 2)
				nutrition = max (0, nutrition - HUNGER_FACTOR)

			if (nutrition > 450)
				if(overeatduration < 600) //capped so people don't take forever to unfat
					overeatduration++
			else
				if(overeatduration > 1)
					overeatduration -= 2 //doubled the unfat rate

			if(mutantrace == "plant")
				if(nutrition < 200)
					take_overall_damage(2,0)

			if (drowsyness)
				drowsyness--
				eye_blurry = max(2, eye_blurry)
				if (prob(5))
					sleeping = 1
					paralysis = 5

			confused = max(0, confused - 1)
			// decrement dizziness counter, clamped to 0
			if(resting)
				dizziness = max(0, dizziness - 15)
				jitteriness = max(0, jitteriness - 15)
			else
				dizziness = max(0, dizziness - 3)
				jitteriness = max(0, jitteriness - 3)

			updatehealth()

			return //TODO: DEFERRED

		handle_regular_status_updates()

		//	health = 100 - (getOxyLoss() + getToxLoss() + fireloss + bruteloss + cloneloss)

			if(getOxyLoss() > 50) paralysis = max(paralysis, 3)

			if(sleeping)
				paralysis = max(paralysis, 3)
				if (prob(10) && health) spawn(0) emote("snore")
				sleeping--

			if(resting)
				weakened = max(weakened, 3)

			if(health < config.health_threshold_dead || brain_op_stage == 4.0)
				death()
			else if(health < config.health_threshold_crit)
				if(health <= 20 && prob(1)) spawn(0) emote("gasp")

				//if(!rejuv) oxyloss++
				if(!reagents.has_reagent("inaprovaline")) oxyloss++

				if(stat != 2)	stat = 1
				paralysis = max(paralysis, 5)

			if (stat != 2) //Alive.
				if (silent)
					silent--

				if (paralysis || stunned || weakened || (changeling && changeling.changeling_fakedeath)) //Stunned etc.
					if (stunned > 0)
						stunned--
						stat = 0
					if (weakened > 0)
						weakened--
						lying = 1
						stat = 0
					if (paralysis > 0)
						paralysis--
						blinded = 1
						lying = 1
						stat = 1
					var/h = hand
					hand = 0
					drop_item()
					hand = 1
					drop_item()
					hand = h

				else	//Not stunned.
					lying = 0
					stat = 0

			else //Dead.
				lying = 1
				blinded = 1
				stat = 2
				silent = 0

			if (stuttering) stuttering--

			if (eye_blind)
				eye_blind--
				blinded = 1

			if (ear_deaf > 0) ear_deaf--
			if (ear_damage < 25)
				ear_damage -= 0.05
				ear_damage = max(ear_damage, 0)

			density = !( lying )

			if ((sdisabilities & 1 || istype(glasses, /obj/item/clothing/glasses/blindfold)))
				blinded = 1
			if ((sdisabilities & 4 || istype(ears, /obj/item/clothing/ears/earmuffs)))
				ear_deaf = 1

			if (eye_blurry > 0)
				eye_blurry--
				eye_blurry = max(0, eye_blurry)

			if (druggy > 0)
				druggy--
				druggy = max(0, druggy)

			return 1

		handle_regular_hud_updates()

			if(!client)	return 0

			for(var/image/hud in client.images)
				if(copytext(hud.icon_state,1,4) == "hud") //ugly, but icon comparison is worse, I believe
					del(hud)

			if (stat == 2 || mutations & XRAY)
				sight |= SEE_TURFS
				sight |= SEE_MOBS
				sight |= SEE_OBJS
				see_in_dark = 8
				if(!druggy)
					see_invisible = 2

			else if (seer)
				var/obj/effect/rune/R = locate() in loc
				if (istype(R) && R.word1 == wordsee && R.word2 == wordhell && R.word3 == wordjoin)
					see_invisible = 15
				else
					seer = 0
					see_invisible = 0
			else if (istype(wear_mask, /obj/item/clothing/mask/gas/voice/space_ninja))
				switch(wear_mask:mode)
					if(0)
						if(client)
							var/target_list[] = list()
							for(var/mob/living/target in oview(src))
								if( target.mind&&(target.mind.special_role||issilicon(target)) )//They need to have a mind.
									target_list += target
							if(target_list.len)//Everything else is handled by the ninja mask proc.
								wear_mask:assess_targets(target_list, src)
						if (!druggy)
							see_invisible = 0
					if(1)
						see_in_dark = 5
						if(!druggy)
							see_invisible = 0
					if(2)
						sight |= SEE_MOBS
						if(!druggy)
							see_invisible = 2
					if(3)
						sight |= SEE_TURFS
						if(!druggy)
							see_invisible = 0

			else if(istype(glasses, /obj/item/clothing/glasses/meson))
				sight |= SEE_TURFS
				if(!druggy)
					see_invisible = 0
			else if(istype(glasses, /obj/item/clothing/glasses/night))
				see_in_dark = 5
				if(!druggy)
					see_invisible = 0
			else if(istype(glasses, /obj/item/clothing/glasses/thermal))
				sight |= SEE_MOBS
				if(!druggy)
					see_invisible = 2
			else if(istype(glasses, /obj/item/clothing/glasses/material))
				sight |= SEE_OBJS
				if (!druggy)
					see_invisible = 0

			else if(stat != 2)
				sight &= ~SEE_TURFS
				sight &= ~SEE_MOBS
				sight &= ~SEE_OBJS
				if (mutantrace == "lizard" || mutantrace == "metroid")
					see_in_dark = 3
					see_invisible = 1
				else if (druggy) // If drugged~
					see_in_dark = 2
					//see_invisible regulated by drugs themselves.
				else
					see_in_dark = 2
					var/seer = 0
					for(var/obj/effect/rune/R in world)
						if(loc==R.loc && R.word1==wordsee && R.word2==wordhell && R.word3==wordjoin)
							seer = 1
					if(!seer)
						see_invisible = 0

			else if(istype(head, /obj/item/clothing/head/helmet/welding))
				if(!head:up && tinted_weldhelh)
					see_in_dark = 1

		/* HUD shit goes here, as long as it doesn't modify src.sight flags */
		// The purpose of this is to stop xray and w/e from preventing you from using huds -- Love, Doohl
			if(istype(glasses, /obj/item/clothing/glasses/hud/health))
				if(client)
					glasses:process_hud(src)
				if (!druggy)
					see_invisible = 0

			if(istype(glasses, /obj/item/clothing/glasses/hud/security))
				if(client)
					glasses:process_hud(src)
				if (!druggy)
					see_invisible = 0

			if(istype(glasses, /obj/item/clothing/glasses/sunglasses))
				see_in_dark = 1
				if(istype(glasses, /obj/item/clothing/glasses/sunglasses/sechud))
					if(client)
						if(glasses:hud)
							glasses:hud:process_hud(src)
				if (!druggy)
					see_invisible = 0

/*
			if (istype(glasses, /obj/item/clothing/glasses))
				sight = glasses.vision_flags
				see_in_dark = 2 + glasses.darkness_view
				see_invisible = invisa_view

					if(istype(glasses, /obj/item/clothing/glasses/hud))
						if(client)
							glasses:process_hud(src)
*/
//Should finish this up later



			if (sleep) sleep.icon_state = text("sleep[]", sleeping)
			if (rest) rest.icon_state = text("rest[]", resting)

			if (healths)
				if (stat != 2)
					switch(health)
						if(100 to INFINITY)
							healths.icon_state = "health0"
						if(80 to 100)
							healths.icon_state = "health1"
						if(60 to 80)
							healths.icon_state = "health2"
						if(40 to 60)
							healths.icon_state = "health3"
						if(20 to 40)
							healths.icon_state = "health4"
						if(0 to 20)
							healths.icon_state = "health5"
						else
							healths.icon_state = "health6"
				else
					healths.icon_state = "health7"

			if (nutrition_icon)
				switch(nutrition)
					if(450 to INFINITY)
						nutrition_icon.icon_state = "nutrition0"
					if(350 to 450)
						nutrition_icon.icon_state = "nutrition1"
					if(250 to 350)
						nutrition_icon.icon_state = "nutrition2"
					if(150 to 250)
						nutrition_icon.icon_state = "nutrition3"
					else
						nutrition_icon.icon_state = "nutrition4"

			if(pullin)	pullin.icon_state = "pull[pulling ? 1 : 0]"

			if(resting || lying || sleeping)	rest.icon_state = "rest[(resting || lying || sleeping) ? 1 : 0]"


			if (toxin)	toxin.icon_state = "tox[toxins_alert ? 1 : 0]"
			if (oxygen) oxygen.icon_state = "oxy[oxygen_alert ? 1 : 0]"
			if (fire) fire.icon_state = "fire[fire_alert ? 1 : 0]"
			//NOTE: the alerts dont reset when youre out of danger. dont blame me,
			//blame the person who coded them. Temporary fix added.

			switch(bodytemperature) //310.055 optimal body temp

				if(370 to INFINITY)
					bodytemp.icon_state = "temp4"
				if(350 to 370)
					bodytemp.icon_state = "temp3"
				if(335 to 350)
					bodytemp.icon_state = "temp2"
				if(320 to 335)
					bodytemp.icon_state = "temp1"
				if(300 to 320)
					bodytemp.icon_state = "temp0"
				if(295 to 300)
					bodytemp.icon_state = "temp-1"
				if(280 to 295)
					bodytemp.icon_state = "temp-2"
				if(260 to 280)
					bodytemp.icon_state = "temp-3"
				else
					bodytemp.icon_state = "temp-4"

			client.screen -= hud_used.blurry
			client.screen -= hud_used.druggy
			client.screen -= hud_used.vimpaired
			client.screen -= hud_used.darkMask

			if ((blind && stat != 2))
				if ((blinded))
					blind.layer = 18
				else
					blind.layer = 0

					if (disabilities & 1 && !istype(glasses, /obj/item/clothing/glasses/regular) )
						client.screen += hud_used.vimpaired

					if (eye_blurry)
						client.screen += hud_used.blurry

					if (druggy)
						client.screen += hud_used.druggy

					if (istype(head, /obj/item/clothing/head/helmet/welding))
						if(!head:up && tinted_weldhelh)
							client.screen += hud_used.darkMask

			if (stat != 2)
				if (machine)
					if (!( machine.check_eye(src) ))
						reset_view(null)
				else
					if(!client.adminobs)
						reset_view(null)

			return 1

		handle_random_events()
			if (prob(1) && prob(2))
				spawn(0)
					emote("sneeze")
					return

		handle_virus_updates()
			if(bodytemperature > 406)
				for(var/datum/disease/D in viruses)
					D.cure()


			if(!virus2)
				for(var/mob/living/carbon/M in oviewers(4,src))
					if(M.virus2)
						infect_virus2(src,M.virus2)
				for(var/obj/effect/decal/cleanable/blood/B in view(4, src))
					if(B.virus2)
						infect_virus2(src,B.virus2)
			else
				virus2.activate(src)



			return


		check_if_buckled()
			if (buckled)
				lying = istype(buckled, /obj/structure/stool/bed) || istype(buckled, /obj/machinery/conveyor)
				if(lying)
					drop_item()
				density = 1
			else
				density = !lying

		handle_stomach()
			spawn(0)
				for(var/mob/M in stomach_contents)
					if(M.loc != src)
						stomach_contents.Remove(M)
						continue
					if(istype(M, /mob/living/carbon) && stat != 2)
						if(M.stat == 2)
							M.death(1)
							stomach_contents.Remove(M)
							del(M)
							continue
						if(air_master.current_cycle%3==1)
							if(!M.nodamage)
								M.bruteloss += 5
							nutrition += 10

		handle_changeling()
			if (mind)
				if (mind.special_role == "Changeling" && changeling)
					changeling.chem_charges = between(0, (max((0.9 - (changeling.chem_charges / 50)), 0.1) + changeling.chem_charges), 50)


/*
			// Commented out so hunger system won't be such shock
			// Damage and effect from not eating
			if(nutrition <= 50)
				if (prob (0.1))
					src << "\red Your stomach rumbles."
				if (prob (10))
					bruteloss++
				if (prob (5))
					src << "You feel very weak."
					weakened += rand(2, 3)
*/
/*
snippets

	if (mach)
		if (machine)
			mach.icon_state = "mach1"
		else
			mach.icon_state = null

	if (!m_flag)
		moved_recently = 0
	m_flag = null



		if ((istype(loc, /turf/space) && !( locate(/obj/movable, loc) )))
			var/layers = 20
			// ******* Check
			if (((istype(head, /obj/item/clothing/head) && head.flags & 4) || (istype(wear_mask, /obj/item/clothing/mask) && (!( wear_mask.flags & 4 ) && wear_mask.flags & 8))))
				layers -= 5
			if (istype(w_uniform, /obj/item/clothing/under))
				layers -= 5
			if ((istype(wear_suit, /obj/item/clothing/suit) && wear_suit.flags & 8))
				layers -= 10
			if (layers > oxcheck)
				oxcheck = layers


				if(bodytemperature < 282.591 && (!firemut))
					if(bodytemperature < 250)
						fireloss += 4
						updatehealth()
						if(paralysis <= 2)	paralysis += 2
					else if(prob(1) && !paralysis)
						if(paralysis <= 5)	paralysis += 5
						emote("collapse")
						src << "\red You collapse from the cold!"
				if(bodytemperature > 327.444  && (!firemut))
					if(bodytemperature > 345.444)
						if(!eye_blurry)	src << "\red The heat blurs your vision!"
						eye_blurry = max(4, eye_blurry)
						if(prob(3))	fireloss += rand(1,2)
					else if(prob(3) && !paralysis)
						paralysis += 2
						emote("collapse")
						src << "\red You collapse from heat exaustion!"
				plcheck = t_plasma
				oxcheck = t_oxygen
				G.turf_add(T, G.total_moles())
*/