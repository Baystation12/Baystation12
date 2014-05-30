//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

//NOTE: Breathing happens once per FOUR TICKS, unless the last breath fails. In which case it happens once per ONE TICK! So oxyloss healing is done once per 4 ticks while oxyloss damage is applied once per tick!
#define HUMAN_MAX_OXYLOSS 1 //Defines how much oxyloss humans can get per tick. A tile with no air at all (such as space) applies this value, otherwise it's a percentage of it.
#define HUMAN_CRIT_MAX_OXYLOSS ( (last_tick_duration) /5) //The amount of damage you'll get when in critical condition. We want this to be a 5 minute deal = 300s. There are 100HP to get through, so (1/3)*last_tick_duration per second. Breaths however only happen every 4 ticks.

#define HEAT_DAMAGE_LEVEL_1 2 //Amount of damage applied when your body temperature just passes the 360.15k safety point
#define HEAT_DAMAGE_LEVEL_2 4 //Amount of damage applied when your body temperature passes the 400K point
#define HEAT_DAMAGE_LEVEL_3 8 //Amount of damage applied when your body temperature passes the 1000K point

#define COLD_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when your body temperature just passes the 260.15k safety point
#define COLD_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when your body temperature passes the 200K point
#define COLD_DAMAGE_LEVEL_3 3 //Amount of damage applied when your body temperature passes the 120K point

//Note that gas heat damage is only applied once every FOUR ticks.
#define HEAT_GAS_DAMAGE_LEVEL_1 2 //Amount of damage applied when the current breath's temperature just passes the 360.15k safety point
#define HEAT_GAS_DAMAGE_LEVEL_2 4 //Amount of damage applied when the current breath's temperature passes the 400K point
#define HEAT_GAS_DAMAGE_LEVEL_3 8 //Amount of damage applied when the current breath's temperature passes the 1000K point

#define COLD_GAS_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when the current breath's temperature just passes the 260.15k safety point
#define COLD_GAS_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when the current breath's temperature passes the 200K point
#define COLD_GAS_DAMAGE_LEVEL_3 3 //Amount of damage applied when the current breath's temperature passes the 120K point

/mob/living/carbon/human
	var/oxygen_alert = 0
	var/phoron_alert = 0
	var/co2_alert = 0
	var/fire_alert = 0
	var/pressure_alert = 0
	var/prev_gender = null // Debug for plural genders
	var/temperature_alert = 0
	var/in_stasis = 0


/mob/living/carbon/human/Life()
	set invisibility = 0
	set background = 1

	if (monkeyizing)	return
	if(!loc)			return	// Fixing a null error that occurs when the mob isn't found in the world -- TLE

	..()

	/*
	//This code is here to try to determine what causes the gender switch to plural error. Once the error is tracked down and fixed, this code should be deleted
	//Also delete var/prev_gender once this is removed.
	if(prev_gender != gender)
		prev_gender = gender
		if(gender in list(PLURAL, NEUTER))
			message_admins("[src] ([ckey]) gender has been changed to plural or neuter. Please record what has happened recently to the person and then notify coders. (<A HREF='?_src_=holder;adminmoreinfo=\ref[src]'>?</A>)  (<A HREF='?_src_=vars;Vars=\ref[src]'>VV</A>) (<A HREF='?priv_msg=\ref[src]'>PM</A>) (<A HREF='?_src_=holder;adminplayerobservejump=\ref[src]'>JMP</A>)")
	*/
	//Apparently, the person who wrote this code designed it so that
	//blinded get reset each cycle and then get activated later in the
	//code. Very ugly. I dont care. Moving this stuff here so its easy
	//to find it.
	blinded = null
	fire_alert = 0 //Reset this here, because both breathe() and handle_environment() have a chance to set it.

	//TODO: seperate this out
	// update the current life tick, can be used to e.g. only do something every 4 ticks
	life_tick++
	var/datum/gas_mixture/environment = loc.return_air()

	in_stasis = istype(loc, /obj/structure/closet/body_bag/cryobag) && loc:opened == 0
	if(in_stasis) loc:used++

	if(life_tick%30==15)
		hud_updateflag = 1022

	voice = GetVoice()

	//No need to update all of these procs if the guy is dead.
	if(stat != DEAD && !in_stasis)
		if(air_master.current_cycle%4==2 || failed_last_breath) 	//First, resolve location and get a breath
			breathe() 				//Only try to take a breath every 4 ticks, unless suffocating

		else //Still give containing object the chance to interact
			if(istype(loc, /obj/))
				var/obj/location_as_object = loc
				location_as_object.handle_internal_lifeform(src, 0)

		//Updates the number of stored chemicals for powers
		handle_changeling()

		//Mutations and radiation
		handle_mutations_and_radiation()

		//Chemicals in the body
		handle_chemicals_in_body()

		//Disabilities
		handle_disabilities()

		//Random events (vomiting etc)
		handle_random_events()

		handle_virus_updates()

		//stuff in the stomach
		handle_stomach()

		handle_shock()

		handle_pain()

		handle_medical_side_effects()

	handle_stasis_bag()

	if(life_tick > 5 && timeofdeath && (timeofdeath < 5 || world.time - timeofdeath > 6000))	//We are long dead, or we're junk mobs spawned like the clowns on the clown shuttle
		return											//We go ahead and process them 5 times for HUD images and other stuff though.

	//Handle temperature/pressure differences between body and environment
	handle_environment(environment)		//Optimized a good bit.

	//Status updates, death etc.
	handle_regular_status_updates()		//Optimized a bit
	update_canmove()

	//Update our name based on whether our face is obscured/disfigured
	name = get_visible_name()

	handle_regular_hud_updates()

	pulse = handle_pulse()

	// Grabbing
	for(var/obj/item/weapon/grab/G in src)
		G.process()


/mob/living/carbon/human/calculate_affecting_pressure(var/pressure)
	..()
	var/pressure_difference = abs( pressure - ONE_ATMOSPHERE )

	var/pressure_adjustment_coefficient = 1	//Determins how much the clothing you are wearing protects you in percent.
	if(wear_suit && (wear_suit.flags & STOPSPRESSUREDMAGE))
		pressure_adjustment_coefficient -= PRESSURE_SUIT_REDUCTION_COEFFICIENT
	if(head && (head.flags & STOPSPRESSUREDMAGE))
		pressure_adjustment_coefficient -= PRESSURE_HEAD_REDUCTION_COEFFICIENT
	pressure_adjustment_coefficient = max(pressure_adjustment_coefficient,0) //So it isn't less than 0
	pressure_difference = pressure_difference * pressure_adjustment_coefficient
	if(pressure > ONE_ATMOSPHERE)
		return ONE_ATMOSPHERE + pressure_difference
	else
		return ONE_ATMOSPHERE - pressure_difference

/mob/living/carbon/human
	proc/handle_disabilities()
		if (disabilities & EPILEPSY)
			if ((prob(1) && paralysis < 1))
				src << "\red You have a seizure!"
				for(var/mob/O in viewers(src, null))
					if(O == src)
						continue
					O.show_message(text("\red <B>[src] starts having a seizure!"), 1)
				Paralyse(10)
				make_jittery(1000)
		if (disabilities & COUGHING)
			if ((prob(5) && paralysis <= 1))
				drop_item()
				spawn( 0 )
					emote("cough")
					return
		if (disabilities & TOURETTES)
			speech_problem_flag = 1
			if ((prob(10) && paralysis <= 1))
				Stun(10)
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
		if (disabilities & NERVOUS)
			speech_problem_flag = 1
			if (prob(10))
				stuttering = max(10, stuttering)
		// No. -- cib
		/*if (getBrainLoss() >= 60 && stat != 2)
			if (prob(3))
				switch(pick(1,2,3))
					if(1)
						say(pick("IM A PONY NEEEEEEIIIIIIIIIGH", "without oxigen blob don't evoluate?", "CAPTAINS A COMDOM", "[pick("", "that meatball traitor")] [pick("joerge", "george", "gorge", "gdoruge")] [pick("mellens", "melons", "mwrlins")] is grifing me HAL;P!!!", "can u give me [pick("telikesis","halk","eppilapse")]?", "THe saiyans screwed", "Bi is THE BEST OF BOTH WORLDS>", "I WANNA PET TEH monkeyS", "stop grifing me!!!!", "SOTP IT#"))
					if(2)
						say(pick("FUS RO DAH","fucking 4rries!", "stat me", ">my face", "roll it easy!", "waaaaaagh!!!", "red wonz go fasta", "FOR TEH EMPRAH", "lol2cat", "dem dwarfs man, dem dwarfs", "SPESS MAHREENS", "hwee did eet fhor khayosss", "lifelike texture ;_;", "luv can bloooom", "PACKETS!!!"))
					if(3)
						emote("drool")
		*/

		if(stat != 2)
			var/rn = rand(0, 200)
			if(getBrainLoss() >= 5)
				if(0 <= rn && rn <= 3)
					custom_pain("Your head feels numb and painful.")
			if(getBrainLoss() >= 15)
				if(4 <= rn && rn <= 6) if(eye_blurry <= 0)
					src << "\red It becomes hard to see for some reason."
					eye_blurry = 10
			if(getBrainLoss() >= 35)
				if(7 <= rn && rn <= 9) if(hand && equipped())
					src << "\red Your hand won't respond properly, you drop what you're holding."
					drop_item()
			if(getBrainLoss() >= 50)
				if(10 <= rn && rn <= 12) if(!lying)
					src << "\red Your legs won't respond properly, you fall down."
					resting = 1

	proc/handle_stasis_bag()
		// Handle side effects from stasis bag
		if(in_stasis)
			// First off, there's no oxygen supply, so the mob will slowly take brain damage
			adjustBrainLoss(0.1)

			// Next, the method to induce stasis has some adverse side-effects, manifesting
			// as cloneloss
			adjustCloneLoss(0.1)

	proc/handle_mutations_and_radiation()

		if(species.flags & IS_SYNTHETIC) //Robots don't suffer from mutations or radloss.
			return

		if(getFireLoss())
			if((COLD_RESISTANCE in mutations) || (prob(1)))
				heal_organ_damage(0,1)

		// DNA2 - Gene processing.
		// The HULK stuff that was here is now in the hulk gene.
		for(var/datum/dna/gene/gene in dna_genes)
			if(!gene.block)
				continue
			if(gene.is_active(src))
				speech_problem_flag = 1
				gene.OnMobLife(src)

		if (radiation)
			if (radiation > 100)
				radiation = 100
				Weaken(10)
				src << "\red You feel weak."
				emote("collapse")

			if (radiation < 0)
				radiation = 0

			else

				if(species.flags & RAD_ABSORB)
					var/rads = radiation/25
					radiation -= rads
					nutrition += rads
					adjustBruteLoss(-(rads))
					adjustOxyLoss(-(rads))
					adjustToxLoss(-(rads))
					updatehealth()
					return

				var/damage = 0
				switch(radiation)
					if(1 to 49)
						radiation--
						if(prob(25))
							adjustToxLoss(1)
							damage = 1
							updatehealth()

					if(50 to 74)
						radiation -= 2
						damage = 1
						adjustToxLoss(1)
						if(prob(5))
							radiation -= 5
							Weaken(3)
							src << "\red You feel weak."
							emote("collapse")
						updatehealth()

					if(75 to 100)
						radiation -= 3
						adjustToxLoss(3)
						damage = 1
						if(prob(1))
							src << "\red You mutate!"
							randmutb(src)
							domutcheck(src,null)
							emote("gasp")
						updatehealth()

				if(damage && organs.len)
					var/datum/organ/external/O = pick(organs)
					if(istype(O)) O.add_autopsy_data("Radiation Poisoning", damage)

	proc/breathe()
		if(reagents.has_reagent("lexorin")) return
		if(istype(loc, /obj/machinery/atmospherics/unary/cryo_cell)) return
		if(species && (species.flags & NO_BREATHE || species.flags & IS_SYNTHETIC)) return

		var/datum/organ/internal/lungs/L = internal_organs["lungs"]
		L.process()

		var/datum/gas_mixture/environment = loc.return_air()
		var/datum/gas_mixture/breath
		// HACK NEED CHANGING LATER
		if(health < config.health_threshold_crit)
			losebreath++
		if(losebreath>0) //Suffocating so do not take a breath
			losebreath--
			if (prob(10)) //Gasp per 10 ticks? Sounds about right.
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
				if(isobj(loc))
					var/obj/location_as_object = loc
					breath = location_as_object.handle_internal_lifeform(src, BREATH_MOLES)
				else if(isturf(loc))
					var/breath_moles = 0
					/*if(environment.return_pressure() > ONE_ATMOSPHERE)
						// Loads of air around (pressure effect will be handled elsewhere), so lets just take a enough to fill our lungs at normal atmos pressure (using n = Pv/RT)
						breath_moles = (ONE_ATMOSPHERE*BREATH_VOLUME/R_IDEAL_GAS_EQUATION*environment.temperature)
					else*/
						// Not enough air around, take a percentage of what's there to model this properly
					breath_moles = environment.total_moles()*BREATH_PERCENTAGE

					breath = loc.remove_air(breath_moles)

					if(istype(wear_mask, /obj/item/clothing/mask/gas) && breath)
						var/obj/item/clothing/mask/gas/G = wear_mask
						var/datum/gas_mixture/filtered = new

						filtered.copy_from(breath)
						filtered.phoron *= G.gas_filter_strength
						for(var/datum/gas/gas in filtered.trace_gases)
							gas.moles *= G.gas_filter_strength
						filtered.update_values()
						loc.assume_air(filtered)

						breath.phoron *= 1 - G.gas_filter_strength
						for(var/datum/gas/gas in breath.trace_gases)
							gas.moles *= 1 - G.gas_filter_strength
						breath.update_values()

					if(!is_lung_ruptured())
						if(!breath || breath.total_moles < BREATH_MOLES / 5 || breath.total_moles > BREATH_MOLES * 5)
							if(prob(5))
								rupture_lung()

					// Handle filtering
					var/block = 0
					if(wear_mask)
						if(wear_mask.flags & BLOCK_GAS_SMOKE_EFFECT)
							block = 1
					if(glasses)
						if(glasses.flags & BLOCK_GAS_SMOKE_EFFECT)
							block = 1
					if(head)
						if(head.flags & BLOCK_GAS_SMOKE_EFFECT)
							block = 1

					if(!block)

						for(var/obj/effect/effect/smoke/chem/smoke in view(1, src))
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

			//spread some viruses while we are at it
			if (virus2.len > 0)
				if (prob(10) && get_infection_chance(src))
//					log_debug("[src] : Exhaling some viruses")
					for(var/mob/living/carbon/M in view(1,src))
						src.spread_disease_to(M)


	proc/get_breath_from_internal(volume_needed)
		if(internal)
			if (!contents.Find(internal))
				internal = null
			if (!wear_mask || !(wear_mask.flags & MASKINTERNALS) )
				internal = null
			if(internal)
				return internal.remove_air_volume(volume_needed)
			else if(internals)
				internals.icon_state = "internal0"
		return null


	proc/handle_breath(datum/gas_mixture/breath)
		if(status_flags & GODMODE)
			return

		if(!breath || (breath.total_moles() == 0) || suiciding)
			if(reagents.has_reagent("inaprovaline"))
				return
			if(suiciding)
				adjustOxyLoss(2)//If you are suiciding, you should die a little bit faster
				failed_last_breath = 1
				oxygen_alert = max(oxygen_alert, 1)
				return 0
			if(health > config.health_threshold_crit)
				adjustOxyLoss(HUMAN_MAX_OXYLOSS)
				failed_last_breath = 1
			else
				adjustOxyLoss(HUMAN_CRIT_MAX_OXYLOSS)
				failed_last_breath = 1

			oxygen_alert = max(oxygen_alert, 1)

			return 0

		var/safe_pressure_min = 16 // Minimum safe partial pressure of breathable gas in kPa
		//var/safe_pressure_max = 140 // Maximum safe partial pressure of breathable gas in kPa (Not used for now)
		var/safe_exhaled_max = 10 // Yes it's an arbitrary value who cares?
		var/safe_toxins_max = 0.005
		var/SA_para_min = 1
		var/SA_sleep_min = 5
		var/inhaled_gas_used = 0

		var/breath_pressure = (breath.total_moles()*R_IDEAL_GAS_EQUATION*breath.temperature)/BREATH_VOLUME

		var/inhaling
		var/exhaling
		var/poison
		var/no_exhale
		
		var/failed_inhale = 0
		var/failed_exhale = 0

		switch(species.breath_type)
			if("nitrogen")
				inhaling = breath.nitrogen
			if("phoron")
				inhaling = breath.phoron
			if("carbon_dioxide")
				inhaling = breath.carbon_dioxide
			else
				inhaling = breath.oxygen

		switch(species.poison_type)
			if("oxygen")
				poison = breath.oxygen
			if("nitrogen")
				poison = breath.nitrogen
			if("carbon_dioxide")
				poison = breath.carbon_dioxide
			else
				poison = breath.phoron

		switch(species.exhale_type)
			if("carbon_dioxide")
				exhaling = breath.carbon_dioxide
			if("oxygen")
				exhaling = breath.oxygen
			if("nitrogen")
				exhaling = breath.nitrogen
			if("phoron")
				exhaling = breath.phoron
			else
				no_exhale = 1

		var/inhale_pp = (inhaling/breath.total_moles())*breath_pressure
		var/toxins_pp = (poison/breath.total_moles())*breath_pressure
		var/exhaled_pp = (exhaling/breath.total_moles())*breath_pressure

		// Not enough to breathe
		if(inhale_pp < safe_pressure_min)
			if(prob(20))
				spawn(0) emote("gasp")
			if(inhale_pp > 0)
				var/ratio = safe_pressure_min/inhale_pp

				 // Don't fuck them up too fast (space only does HUMAN_MAX_OXYLOSS after all!)
				 // The hell? By definition ratio > 1, and HUMAN_MAX_OXYLOSS = 1... why do we even have this?
				adjustOxyLoss(min(5*ratio, HUMAN_MAX_OXYLOSS))
				failed_inhale = 1
				inhaled_gas_used = inhaling*ratio/6

			else

				adjustOxyLoss(HUMAN_MAX_OXYLOSS)
				failed_inhale = 1

			oxygen_alert = max(oxygen_alert, 1)

		else
			// We're in safe limits
			inhaled_gas_used = inhaling/6
			oxygen_alert = 0

		switch(species.breath_type)
			if("nitrogen")
				breath.nitrogen -= inhaled_gas_used
			if("phoron")
				breath.phoron -= inhaled_gas_used
			if("carbon_dioxide")
				breath.carbon_dioxide-= inhaled_gas_used
			else
				breath.oxygen -= inhaled_gas_used

		if(!no_exhale)
			switch(species.exhale_type)
				if("oxygen")
					breath.oxygen += inhaled_gas_used
				if("nitrogen")
					breath.nitrogen += inhaled_gas_used
				if("phoron")
					breath.phoron += inhaled_gas_used
				if("CO2")
					breath.carbon_dioxide += inhaled_gas_used

		// Too much exhaled gas in the air
		if(exhaled_pp > safe_exhaled_max)
			if (!co2_alert|| prob(15))
				var/word = pick("extremely dizzy","short of breath","faint","confused")
				src << "\red <b>You feel [word].</b>"
			
			adjustOxyLoss(HUMAN_MAX_OXYLOSS)
			co2_alert = 1
			failed_exhale = 1
			
		else if(exhaled_pp > safe_exhaled_max * 0.7)
			if (!co2_alert || prob(1))
				var/word = pick("dizzy","short of breath","faint","momentarily confused")
				src << "\red You feel [word]."
			
			//scale linearly from 0 to 1 between safe_exhaled_max and safe_exhaled_max*0.7
			var/ratio = 1.0 - (safe_exhaled_max - exhaled_pp)/(safe_exhaled_max*0.3)
			
			//give them some oxyloss, up to the limit - we don't want people falling unconcious due to CO2 alone until they're pretty close to safe_exhaled_max.
			if (getOxyLoss() < 50*ratio)
				adjustOxyLoss(HUMAN_MAX_OXYLOSS)
			co2_alert = 1
			failed_exhale = 1
			
		else if(exhaled_pp > safe_exhaled_max * 0.6)
			if (prob(0.3))
				var/word = pick("a little dizzy","short of breath")
				src << "\red You feel [word]."
			
		else
			co2_alert = 0

		// Too much poison in the air.
		if(toxins_pp > safe_toxins_max)
			var/ratio = (poison/safe_toxins_max) * 10
			if(reagents)
				//TODO: Fix Ravensdale's shit, make toxins toxins again instead of phoron.
				reagents.add_reagent("phoron", Clamp(ratio, MIN_PHORON_DAMAGE, MAX_PHORON_DAMAGE))
			phoron_alert = max(phoron_alert, 1)
		else
			phoron_alert = 0

		// If there's some other shit in the air lets deal with it here.
		if(breath.trace_gases.len)
			for(var/datum/gas/sleeping_agent/SA in breath.trace_gases)
				var/SA_pp = (SA.moles/breath.total_moles())*breath_pressure

				// Enough to make us paralysed for a bit
				if(SA_pp > SA_para_min)

					// 3 gives them one second to wake up and run away a bit!
					Paralyse(3)

					// Enough to make us sleep as well
					if(SA_pp > SA_sleep_min)
						sleeping = min(sleeping+2, 10)

				// There is sleeping gas in their lungs, but only a little, so give them a bit of a warning
				else if(SA_pp > 0.15)
					if(prob(20))
						spawn(0) emote(pick("giggle", "laugh"))
				SA.moles = 0
		
		// Were we able to breathe?
		if (failed_inhale || failed_exhale)
			failed_last_breath = 1
		else
			failed_last_breath = 0
			adjustOxyLoss(-5)
		
		// Hot air hurts :(
		if( (abs(310.15 - breath.temperature) > 50) && !(COLD_RESISTANCE in mutations)) 

			if(status_flags & GODMODE)
				return 1

			if(breath.temperature < species.cold_level_1)
				if(prob(20))
					src << "\red You feel your face freezing and an icicle forming in your lungs!"
			else if(breath.temperature > species.heat_level_1)
				if(prob(20))
					src << "\red You feel your face burning and a searing heat in your lungs!"

			switch(breath.temperature)
				if(-INFINITY to species.cold_level_3)
					apply_damage(COLD_GAS_DAMAGE_LEVEL_3, BURN, "head", used_weapon = "Excessive Cold")
					fire_alert = max(fire_alert, 1)
				if(species.cold_level_3 to species.cold_level_2)
					apply_damage(COLD_GAS_DAMAGE_LEVEL_2, BURN, "head", used_weapon = "Excessive Cold")
					fire_alert = max(fire_alert, 1)
				if(species.cold_level_2 to species.cold_level_1)
					apply_damage(COLD_GAS_DAMAGE_LEVEL_1, BURN, "head", used_weapon = "Excessive Cold")
					fire_alert = max(fire_alert, 1)
				if(species.heat_level_1 to species.heat_level_2)
					apply_damage(HEAT_GAS_DAMAGE_LEVEL_1, BURN, "head", used_weapon = "Excessive Heat")
					fire_alert = max(fire_alert, 2)
				if(species.heat_level_2 to species.heat_level_3)
					apply_damage(HEAT_GAS_DAMAGE_LEVEL_2, BURN, "head", used_weapon = "Excessive Heat")
					fire_alert = max(fire_alert, 2)
				if(species.heat_level_3 to INFINITY)
					apply_damage(HEAT_GAS_DAMAGE_LEVEL_3, BURN, "head", used_weapon = "Excessive Heat")
					fire_alert = max(fire_alert, 2)

		//Temporary fixes to the alerts.

		return 1

	proc/handle_environment(datum/gas_mixture/environment)
		if(!environment)
			return

		//Moved pressure calculations here for use in skip-processing check.
		var/pressure = environment.return_pressure()
		var/adjusted_pressure = calculate_affecting_pressure(pressure)

		if(!istype(get_turf(src), /turf/space)) //space is not meant to change your body temperature.
			var/loc_temp = T0C
			if(istype(loc, /obj/mecha))
				var/obj/mecha/M = loc
				loc_temp =  M.return_temperature()
			else if(istype(get_turf(src), /turf/space))
			else if(istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))
				loc_temp = loc:air_contents.temperature
			else
				loc_temp = environment.temperature

			if(adjusted_pressure < species.warning_low_pressure && adjusted_pressure > species.warning_low_pressure && abs(loc_temp - 293.15) < 20 && abs(bodytemperature - 310.14) < 0.5 && environment.phoron < MOLES_PHORON_VISIBLE)
				return // Temperatures are within normal ranges, fuck all this processing. ~Ccomp

			//Body temperature is adjusted in two steps. Firstly your body tries to stabilize itself a bit.
			if(stat != 2)
				stabilize_temperature_from_calories()

			//After then, it reacts to the surrounding atmosphere based on your thermal protection
			if(loc_temp < BODYTEMP_COLD_DAMAGE_LIMIT)			//Place is colder than we are
				var/thermal_protection = get_cold_protection(loc_temp) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
				if(thermal_protection < 1)
					var/amt = min((1-thermal_protection) * ((loc_temp - bodytemperature) / BODYTEMP_COLD_DIVISOR), BODYTEMP_COOLING_MAX)
					bodytemperature += amt
			else if (loc_temp > BODYTEMP_HEAT_DAMAGE_LIMIT)			//Place is hotter than we are
				var/thermal_protection = get_heat_protection(loc_temp) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
				if(thermal_protection < 1)
					var/amt = min((1-thermal_protection) * ((loc_temp - bodytemperature) / BODYTEMP_HEAT_DIVISOR), BODYTEMP_HEATING_MAX)
					bodytemperature += amt

		// +/- 50 degrees from 310.15K is the 'safe' zone, where no damage is dealt.
		if(bodytemperature > BODYTEMP_HEAT_DAMAGE_LIMIT)
			//Body temperature is too hot.
			fire_alert = max(fire_alert, 1)
			if(status_flags & GODMODE)	return 1	//godmode
			switch(bodytemperature)
				if(360 to 400)
					apply_damage(HEAT_DAMAGE_LEVEL_1, BURN, used_weapon = "High Body Temperature")
					fire_alert = max(fire_alert, 2)
				if(400 to 1000)
					apply_damage(HEAT_DAMAGE_LEVEL_2, BURN, used_weapon = "High Body Temperature")
					fire_alert = max(fire_alert, 2)
				if(1000 to INFINITY)
					apply_damage(HEAT_DAMAGE_LEVEL_3, BURN, used_weapon = "High Body Temperature")
					fire_alert = max(fire_alert, 2)

		else if(bodytemperature < BODYTEMP_COLD_DAMAGE_LIMIT)
			fire_alert = max(fire_alert, 1)
			if(status_flags & GODMODE)	return 1	//godmode
			if(!istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))
				switch(bodytemperature)
					if(200 to 260)
						apply_damage(COLD_DAMAGE_LEVEL_1, BURN, used_weapon = "Low Body Temperature")
						fire_alert = max(fire_alert, 1)
					if(120 to 200)
						apply_damage(COLD_DAMAGE_LEVEL_2, BURN, used_weapon = "Low Body Temperature")
						fire_alert = max(fire_alert, 1)
					if(-INFINITY to 120)
						apply_damage(COLD_DAMAGE_LEVEL_3, BURN, used_weapon = "Low Body Temperature")
						fire_alert = max(fire_alert, 1)

		// Account for massive pressure differences.  Done by Polymorph
		// Made it possible to actually have something that can protect against high pressure... Done by Errorage. Polymorph now has an axe sticking from his head for his previous hardcoded nonsense!
		if(status_flags & GODMODE)	return 1	//godmode

		if(adjusted_pressure >= species.hazard_high_pressure)
			adjustBruteLoss( min( ( (adjusted_pressure / species.hazard_high_pressure) -1 )*PRESSURE_DAMAGE_COEFFICIENT , MAX_HIGH_PRESSURE_DAMAGE) )
			pressure_alert = 2
		else if(adjusted_pressure >= species.warning_high_pressure)
			pressure_alert = 1
		else if(adjusted_pressure >= species.warning_low_pressure)
			pressure_alert = 0
		else if(adjusted_pressure >= species.hazard_low_pressure)
			pressure_alert = -1

			if(species && species.flags & IS_SYNTHETIC)
				bodytemperature += 0.5 * TEMPERATURE_DAMAGE_COEFFICIENT //Synthetics suffer overheating in a vaccuum. ~Z

		else

			if(species && species.flags & IS_SYNTHETIC)
				bodytemperature += 1 * TEMPERATURE_DAMAGE_COEFFICIENT

			if( !(COLD_RESISTANCE in mutations))
				adjustBruteLoss( LOW_PRESSURE_DAMAGE )
				pressure_alert = -2
			else
				pressure_alert = -1

		if(environment.phoron > MOLES_PHORON_VISIBLE)
			pl_effects()
		return

	/*
	proc/adjust_body_temperature(current, loc_temp, boost)
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
	*/

	proc/stabilize_temperature_from_calories()
		var/body_temperature_difference = 310.15 - bodytemperature
		if (abs(body_temperature_difference) < 0.5)
			return //fuck this precision
		switch(bodytemperature)
			if(-INFINITY to 260.15) //260.15 is 310.15 - 50, the temperature where you start to feel effects.
				if(nutrition >= 2) //If we are very, very cold we'll use up quite a bit of nutriment to heat us up.
					nutrition -= 2
				var/recovery_amt = max((body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR), BODYTEMP_AUTORECOVERY_MINIMUM)
//				log_debug("Cold. Difference = [body_temperature_difference]. Recovering [recovery_amt]")
				bodytemperature += recovery_amt
			if(260.15 to 360.15)
				var/recovery_amt = body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR
//				log_debug("Norm. Difference = [body_temperature_difference]. Recovering [recovery_amt]")
				bodytemperature += recovery_amt
			if(360.15 to INFINITY) //360.15 is 310.15 + 50, the temperature where you start to feel effects.
				//We totally need a sweat system cause it totally makes sense...~
				var/recovery_amt = min((body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR), -BODYTEMP_AUTORECOVERY_MINIMUM)	//We're dealing with negative numbers
//				log_debug("Hot. Difference = [body_temperature_difference]. Recovering [recovery_amt]")
				bodytemperature += recovery_amt

	//This proc returns a number made up of the flags for body parts which you are protected on. (such as HEAD, UPPER_TORSO, LOWER_TORSO, etc. See setup.dm for the full list)
	proc/get_heat_protection_flags(temperature) //Temperature is the temperature you're being exposed to.
		var/thermal_protection_flags = 0
		//Handle normal clothing
		if(head)
			if(head.max_heat_protection_temperature && head.max_heat_protection_temperature >= temperature)
				thermal_protection_flags |= head.heat_protection
		if(wear_suit)
			if(wear_suit.max_heat_protection_temperature && wear_suit.max_heat_protection_temperature >= temperature)
				thermal_protection_flags |= wear_suit.heat_protection
		if(w_uniform)
			if(w_uniform.max_heat_protection_temperature && w_uniform.max_heat_protection_temperature >= temperature)
				thermal_protection_flags |= w_uniform.heat_protection
		if(shoes)
			if(shoes.max_heat_protection_temperature && shoes.max_heat_protection_temperature >= temperature)
				thermal_protection_flags |= shoes.heat_protection
		if(gloves)
			if(gloves.max_heat_protection_temperature && gloves.max_heat_protection_temperature >= temperature)
				thermal_protection_flags |= gloves.heat_protection
		if(wear_mask)
			if(wear_mask.max_heat_protection_temperature && wear_mask.max_heat_protection_temperature >= temperature)
				thermal_protection_flags |= wear_mask.heat_protection

		return thermal_protection_flags

	proc/get_heat_protection(temperature) //Temperature is the temperature you're being exposed to.
		var/thermal_protection_flags = get_heat_protection_flags(temperature)

		var/thermal_protection = 0.0
		if(thermal_protection_flags)
			if(thermal_protection_flags & HEAD)
				thermal_protection += THERMAL_PROTECTION_HEAD
			if(thermal_protection_flags & UPPER_TORSO)
				thermal_protection += THERMAL_PROTECTION_UPPER_TORSO
			if(thermal_protection_flags & LOWER_TORSO)
				thermal_protection += THERMAL_PROTECTION_LOWER_TORSO
			if(thermal_protection_flags & LEG_LEFT)
				thermal_protection += THERMAL_PROTECTION_LEG_LEFT
			if(thermal_protection_flags & LEG_RIGHT)
				thermal_protection += THERMAL_PROTECTION_LEG_RIGHT
			if(thermal_protection_flags & FOOT_LEFT)
				thermal_protection += THERMAL_PROTECTION_FOOT_LEFT
			if(thermal_protection_flags & FOOT_RIGHT)
				thermal_protection += THERMAL_PROTECTION_FOOT_RIGHT
			if(thermal_protection_flags & ARM_LEFT)
				thermal_protection += THERMAL_PROTECTION_ARM_LEFT
			if(thermal_protection_flags & ARM_RIGHT)
				thermal_protection += THERMAL_PROTECTION_ARM_RIGHT
			if(thermal_protection_flags & HAND_LEFT)
				thermal_protection += THERMAL_PROTECTION_HAND_LEFT
			if(thermal_protection_flags & HAND_RIGHT)
				thermal_protection += THERMAL_PROTECTION_HAND_RIGHT


		return min(1,thermal_protection)

	//See proc/get_heat_protection_flags(temperature) for the description of this proc.
	proc/get_cold_protection_flags(temperature)
		var/thermal_protection_flags = 0
		//Handle normal clothing

		if(head)
			if(head.min_cold_protection_temperature && head.min_cold_protection_temperature <= temperature)
				thermal_protection_flags |= head.cold_protection
		if(wear_suit)
			if(wear_suit.min_cold_protection_temperature && wear_suit.min_cold_protection_temperature <= temperature)
				thermal_protection_flags |= wear_suit.cold_protection
		if(w_uniform)
			if(w_uniform.min_cold_protection_temperature && w_uniform.min_cold_protection_temperature <= temperature)
				thermal_protection_flags |= w_uniform.cold_protection
		if(shoes)
			if(shoes.min_cold_protection_temperature && shoes.min_cold_protection_temperature <= temperature)
				thermal_protection_flags |= shoes.cold_protection
		if(gloves)
			if(gloves.min_cold_protection_temperature && gloves.min_cold_protection_temperature <= temperature)
				thermal_protection_flags |= gloves.cold_protection
		if(wear_mask)
			if(wear_mask.min_cold_protection_temperature && wear_mask.min_cold_protection_temperature <= temperature)
				thermal_protection_flags |= wear_mask.cold_protection

		return thermal_protection_flags

	proc/get_cold_protection(temperature)

		if(COLD_RESISTANCE in mutations)
			return 1 //Fully protected from the cold.

		temperature = max(temperature, 2.7) //There is an occasional bug where the temperature is miscalculated in ares with a small amount of gas on them, so this is necessary to ensure that that bug does not affect this calculation. Space's temperature is 2.7K and most suits that are intended to protect against any cold, protect down to 2.0K.
		var/thermal_protection_flags = get_cold_protection_flags(temperature)

		var/thermal_protection = 0.0
		if(thermal_protection_flags)
			if(thermal_protection_flags & HEAD)
				thermal_protection += THERMAL_PROTECTION_HEAD
			if(thermal_protection_flags & UPPER_TORSO)
				thermal_protection += THERMAL_PROTECTION_UPPER_TORSO
			if(thermal_protection_flags & LOWER_TORSO)
				thermal_protection += THERMAL_PROTECTION_LOWER_TORSO
			if(thermal_protection_flags & LEG_LEFT)
				thermal_protection += THERMAL_PROTECTION_LEG_LEFT
			if(thermal_protection_flags & LEG_RIGHT)
				thermal_protection += THERMAL_PROTECTION_LEG_RIGHT
			if(thermal_protection_flags & FOOT_LEFT)
				thermal_protection += THERMAL_PROTECTION_FOOT_LEFT
			if(thermal_protection_flags & FOOT_RIGHT)
				thermal_protection += THERMAL_PROTECTION_FOOT_RIGHT
			if(thermal_protection_flags & ARM_LEFT)
				thermal_protection += THERMAL_PROTECTION_ARM_LEFT
			if(thermal_protection_flags & ARM_RIGHT)
				thermal_protection += THERMAL_PROTECTION_ARM_RIGHT
			if(thermal_protection_flags & HAND_LEFT)
				thermal_protection += THERMAL_PROTECTION_HAND_LEFT
			if(thermal_protection_flags & HAND_RIGHT)
				thermal_protection += THERMAL_PROTECTION_HAND_RIGHT

		return min(1,thermal_protection)

	/*
	proc/add_fire_protection(var/temp)
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

	proc/handle_temperature_damage(body_part, exposed_temperature, exposed_intensity)
		if(nodamage)
			return
		//world <<"body_part = [body_part], exposed_temperature = [exposed_temperature], exposed_intensity = [exposed_intensity]"
		var/discomfort = min(abs(exposed_temperature - bodytemperature)*(exposed_intensity)/2000000, 1.0)

		if(exposed_temperature > bodytemperature)
			discomfort *= 4

		if(mutantrace == "plant")
			discomfort *= TEMPERATURE_DAMAGE_COEFFICIENT * 2 //I don't like magic numbers. I'll make mutantraces a datum with vars sometime later. -- Urist
		else
			discomfort *= TEMPERATURE_DAMAGE_COEFFICIENT //Dangercon 2011 - now with less magic numbers!
		//world <<"[discomfort]"

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
	*/

	proc/handle_chemicals_in_body()

		if(reagents && !(species.flags & IS_SYNTHETIC)) //Synths don't process reagents.
			var/alien = 0 //Not the best way to handle it, but neater than checking this for every single reagent proc.
			if(species && species.name == "Diona")
				alien = 1
			else if(species && species.name == "Vox")
				alien = 2
			reagents.metabolize(src,alien)

		var/total_phoronloss = 0
		for(var/obj/item/I in src)
			if(I.contaminated)
				total_phoronloss += vsc.plc.CONTAMINATION_LOSS
		if(status_flags & GODMODE)	return 0	//godmode
		adjustToxLoss(total_phoronloss)

		if(species.flags & REQUIRE_LIGHT)
			var/light_amount = 0 //how much light there is in the place, affects receiving nutrition and healing
			if(isturf(loc)) //else, there's considered to be no light
				var/turf/T = loc
				var/area/A = T.loc
				if(A)
					if(A.lighting_use_dynamic)	light_amount = min(10,T.lighting_lumcount) - 5 //hardcapped so it's not abused by having a ton of flashlights
					else						light_amount =  5
			nutrition += light_amount
			traumatic_shock -= light_amount

			if(species.flags & IS_PLANT)
				if(nutrition > 500)
					nutrition = 500
				if(light_amount >= 3) //if there's enough light, heal
					adjustBruteLoss(-(light_amount))
					adjustToxLoss(-(light_amount))
					adjustOxyLoss(-(light_amount))
					//TODO: heal wounds, heal broken limbs.

		if(dna && dna.mutantrace == "shadow")
			var/light_amount = 0
			if(isturf(loc))
				var/turf/T = loc
				var/area/A = T.loc
				if(A)
					if(A.lighting_use_dynamic)	light_amount = T.lighting_lumcount
					else						light_amount =  10
			if(light_amount > 2) //if there's enough light, start dying
				take_overall_damage(1,1)
			else if (light_amount < 2) //heal in the dark
				heal_overall_damage(1,1)

/*		//The fucking FAT mutation is the dumbest shit ever. It makes the code so difficult to work with
		if(FAT in mutations)
			if(overeatduration < 100)
				src << "\blue You feel fit again!"
				mutations.Remove(FAT)
				update_mutantrace(0)
				update_mutations(0)
				update_inv_w_uniform(0)
				update_inv_wear_suit()
		else
			if(overeatduration > 500)
				src << "\red You suddenly feel blubbery!"
				mutations.Add(FAT)
				update_mutantrace(0)
				update_mutations(0)
				update_inv_w_uniform(0)
				update_inv_wear_suit()
*/

		// nutrition decrease
		if (nutrition > 0 && stat != 2)
			nutrition = max (0, nutrition - HUNGER_FACTOR)

		if (nutrition > 450)
			if(overeatduration < 600) //capped so people don't take forever to unfat
				overeatduration++
		else
			if(overeatduration > 1)
				overeatduration -= 2 //doubled the unfat rate

		if(species.flags & REQUIRE_LIGHT)
			if(nutrition < 200)
				take_overall_damage(2,0)
				traumatic_shock++

		if (drowsyness)
			drowsyness--
			eye_blurry = max(2, eye_blurry)
			if (prob(5))
				sleeping += 1
				Paralyse(5)

		confused = max(0, confused - 1)
		// decrement dizziness counter, clamped to 0
		if(resting)
			dizziness = max(0, dizziness - 15)
			jitteriness = max(0, jitteriness - 15)
		else
			dizziness = max(0, dizziness - 3)
			jitteriness = max(0, jitteriness - 3)

		if(!(species.flags & IS_SYNTHETIC)) handle_trace_chems()

		var/datum/organ/internal/liver/liver = internal_organs["liver"]
		liver.process()

		var/datum/organ/internal/eyes/eyes = internal_organs["eyes"]
		eyes.process()

		updatehealth()

		return //TODO: DEFERRED

	proc/handle_regular_status_updates()
		if(stat == DEAD)	//DEAD. BROWN BREAD. SWIMMING WITH THE SPESS CARP
			blinded = 1
			silent = 0
		else				//ALIVE. LIGHTS ARE ON
			updatehealth()	//TODO
			if(!in_stasis)
				handle_organs()	//Optimized.
				handle_blood()

			if(health <= config.health_threshold_dead || brain_op_stage == 4.0)
				death()
				blinded = 1
				silent = 0
				return 1

			// the analgesic effect wears off slowly
			analgesic = max(0, analgesic - 1)

			//UNCONSCIOUS. NO-ONE IS HOME
			if( (getOxyLoss() > 50) || (config.health_threshold_crit > health) )
				Paralyse(3)

				/* Done by handle_breath()
				if( health <= 20 && prob(1) )
					spawn(0)
						emote("gasp")
				if(!reagents.has_reagent("inaprovaline"))
					adjustOxyLoss(1)*/

			if(hallucination)
				if(hallucination >= 20)
					if(prob(3))
						fake_attack(src)
					if(!handling_hal)
						spawn handle_hallucinations() //The not boring kind!

				if(hallucination<=2)
					hallucination = 0
					halloss = 0
				else
					hallucination -= 2

			else
				for(var/atom/a in hallucinations)
					del a

				if(halloss > 100)
					src << "<span class='notice'>You're in too much pain to keep going...</span>"
					for(var/mob/O in oviewers(src, null))
						O.show_message("<B>[src]</B> slumps to the ground, too weak to continue fighting.", 1)
					Paralyse(10)
					setHalLoss(99)

			if(paralysis)
				AdjustParalysis(-1)
				blinded = 1
				stat = UNCONSCIOUS
				if(halloss > 0)
					adjustHalLoss(-3)
			else if(sleeping)
				speech_problem_flag = 1
				handle_dreams()
				adjustHalLoss(-3)
				if (mind)
					if((mind.active && client != null) || immune_to_ssd) //This also checks whether a client is connected, if not, sleep is not reduced.
						sleeping = max(sleeping-1, 0)
				blinded = 1
				stat = UNCONSCIOUS
				if( prob(2) && health && !hal_crit )
					spawn(0)
						emote("snore")
			else if(resting)
				if(halloss > 0)
					adjustHalLoss(-3)
			//CONSCIOUS
			else
				stat = CONSCIOUS
				if(halloss > 0)
					adjustHalLoss(-1)

			if(embedded_flag && !(life_tick % 10))
				var/list/E
				E = get_visible_implants(0)
				if(!E.len)
					embedded_flag = 0


			//Eyes
			if(sdisabilities & BLIND)	//disabled-blind, doesn't get better on its own
				blinded = 1
			else if(eye_blind)			//blindness, heals slowly over time
				eye_blind = max(eye_blind-1,0)
				blinded = 1
			else if(istype(glasses, /obj/item/clothing/glasses/sunglasses/blindfold))	//resting your eyes with a blindfold heals blurry eyes faster
				eye_blurry = max(eye_blurry-3, 0)
				blinded = 1
			else if(eye_blurry)	//blurry eyes heal slowly
				eye_blurry = max(eye_blurry-1, 0)

			//Ears
			if(sdisabilities & DEAF)	//disabled-deaf, doesn't get better on its own
				ear_deaf = max(ear_deaf, 1)
			else if(ear_deaf)			//deafness, heals slowly over time
				ear_deaf = max(ear_deaf-1, 0)
			else if(istype(l_ear, /obj/item/clothing/ears/earmuffs) || istype(r_ear, /obj/item/clothing/ears/earmuffs))	//resting your ears with earmuffs heals ear damage faster
				ear_damage = max(ear_damage-0.15, 0)
				ear_deaf = max(ear_deaf, 1)
			else if(ear_damage < 25)	//ear damage heals slowly under this threshold. otherwise you'll need earmuffs
				ear_damage = max(ear_damage-0.05, 0)

			//Other
			if(stunned)
				speech_problem_flag = 1
				AdjustStunned(-1)

			if(weakened)
				weakened = max(weakened-1,0)	//before you get mad Rockdtben: I done this so update_canmove isn't called multiple times

			if(stuttering)
				speech_problem_flag = 1
				stuttering = max(stuttering-1, 0)
			if (slurring)
				speech_problem_flag = 1
				slurring = max(slurring-1, 0)
			if(silent)
				speech_problem_flag = 1
				silent = max(silent-1, 0)

			if(druggy)
				druggy = max(druggy-1, 0)
/*
			// Increase germ_level regularly
			if(prob(40))
				germ_level += 1
			// If you're dirty, your gloves will become dirty, too.
			if(gloves && germ_level > gloves.germ_level && prob(10))
				gloves.germ_level += 1
*/
		return 1

	proc/handle_regular_hud_updates()
		if(hud_updateflag)
			handle_hud_list()


		if(!client)	return 0

		if(hud_updateflag)
			handle_hud_list()


		for(var/image/hud in client.images)
			if(copytext(hud.icon_state,1,4) == "hud") //ugly, but icon comparison is worse, I believe
				client.images.Remove(hud)

		client.screen.Remove(global_hud.blurry, global_hud.druggy, global_hud.vimpaired, global_hud.darkMask, global_hud.nvg)

		update_action_buttons()

		if(damageoverlay.overlays)
			damageoverlay.overlays = list()

		if(stat == UNCONSCIOUS)
			//Critical damage passage overlay
			if(health <= 0)
				var/image/I
				switch(health)
					if(-20 to -10)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "passage1")
					if(-30 to -20)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "passage2")
					if(-40 to -30)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "passage3")
					if(-50 to -40)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "passage4")
					if(-60 to -50)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "passage5")
					if(-70 to -60)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "passage6")
					if(-80 to -70)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "passage7")
					if(-90 to -80)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "passage8")
					if(-95 to -90)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "passage9")
					if(-INFINITY to -95)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "passage10")
				damageoverlay.overlays += I
		else
			//Oxygen damage overlay
			if(oxyloss)
				var/image/I
				switch(oxyloss)
					if(10 to 20)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay1")
					if(20 to 25)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay2")
					if(25 to 30)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay3")
					if(30 to 35)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay4")
					if(35 to 40)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay5")
					if(40 to 45)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay6")
					if(45 to INFINITY)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay7")
				damageoverlay.overlays += I

			//Fire and Brute damage overlay (BSSR)
			var/hurtdamage = src.getBruteLoss() + src.getFireLoss() + damageoverlaytemp
			damageoverlaytemp = 0 // We do this so we can detect if someone hits us or not.
			if(hurtdamage)
				var/image/I
				switch(hurtdamage)
					if(10 to 25)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "brutedamageoverlay1")
					if(25 to 40)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "brutedamageoverlay2")
					if(40 to 55)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "brutedamageoverlay3")
					if(55 to 70)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "brutedamageoverlay4")
					if(70 to 85)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "brutedamageoverlay5")
					if(85 to INFINITY)
						I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "brutedamageoverlay6")
				damageoverlay.overlays += I

		if( stat == DEAD )
			sight |= (SEE_TURFS|SEE_MOBS|SEE_OBJS)
			see_in_dark = 8
			if(!druggy)		see_invisible = SEE_INVISIBLE_LEVEL_TWO
			if(healths)		healths.icon_state = "health7"	//DEAD healthmeter
			if(client)
				if(client.view != world.view)
					if(locate(/obj/item/weapon/gun/energy/sniperrifle, contents))
						var/obj/item/weapon/gun/energy/sniperrifle/s = locate() in src
						if(s.zoom)
							s.zoom()

		else
			sight &= ~(SEE_TURFS|SEE_MOBS|SEE_OBJS)
			see_in_dark = species.darksight
			see_invisible = see_in_dark>2 ? SEE_INVISIBLE_LEVEL_ONE : SEE_INVISIBLE_LIVING
			if(dna)
				switch(dna.mutantrace)
					if("slime")
						see_in_dark = 3
						see_invisible = SEE_INVISIBLE_LEVEL_ONE
					if("shadow")
						see_in_dark = 8
						see_invisible = SEE_INVISIBLE_LEVEL_ONE

			if(XRAY in mutations)
				sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS
				see_in_dark = 8
				if(!druggy)		see_invisible = SEE_INVISIBLE_LEVEL_TWO

			if(seer==1)
				var/obj/effect/rune/R = locate() in loc
				if(R && R.word1 == cultwords["see"] && R.word2 == cultwords["hell"] && R.word3 == cultwords["join"])
					see_invisible = SEE_INVISIBLE_OBSERVER
				else
					see_invisible = SEE_INVISIBLE_LIVING
					seer = 0

			if(istype(wear_mask, /obj/item/clothing/mask/gas/voice/space_ninja))
				var/obj/item/clothing/mask/gas/voice/space_ninja/O = wear_mask
				switch(O.mode)
					if(0)
						var/target_list[] = list()
						for(var/mob/living/target in oview(src))
							if( target.mind&&(target.mind.special_role||issilicon(target)) )//They need to have a mind.
								target_list += target
						if(target_list.len)//Everything else is handled by the ninja mask proc.
							O.assess_targets(target_list, src)
						if(!druggy)		see_invisible = SEE_INVISIBLE_LIVING
					if(1)
						see_in_dark = 5
						if(!druggy)		see_invisible = SEE_INVISIBLE_LIVING
					if(2)
						sight |= SEE_MOBS
						if(!druggy)		see_invisible = SEE_INVISIBLE_LEVEL_TWO
					if(3)
						sight |= SEE_TURFS
						if(!druggy)		see_invisible = SEE_INVISIBLE_LIVING

			if(glasses)
				var/obj/item/clothing/glasses/G = glasses
				if(istype(G))
					see_in_dark += G.darkness_view
					if(G.vision_flags)		// MESONS
						sight |= G.vision_flags
						if(!druggy)
							see_invisible = SEE_INVISIBLE_MINIMUM
				if(istype(G,/obj/item/clothing/glasses/night))
					see_invisible = SEE_INVISIBLE_MINIMUM
					client.screen += global_hud.nvg

	/* HUD shit goes here, as long as it doesn't modify sight flags */
	// The purpose of this is to stop xray and w/e from preventing you from using huds -- Love, Doohl

				if(istype(glasses, /obj/item/clothing/glasses/sunglasses/sechud))
					var/obj/item/clothing/glasses/sunglasses/sechud/O = glasses
					if(O.hud)		O.hud.process_hud(src)
					if(!druggy)		see_invisible = SEE_INVISIBLE_LIVING
				else if(istype(glasses, /obj/item/clothing/glasses/hud))
					var/obj/item/clothing/glasses/hud/O = glasses
					O.process_hud(src)
					if(!druggy)
						see_invisible = SEE_INVISIBLE_LIVING

			else if(!seer)
				see_invisible = SEE_INVISIBLE_LIVING



			if(healths)
				if (analgesic)
					healths.icon_state = "health_health_numb"
				else
					switch(hal_screwyhud)
						if(1)	healths.icon_state = "health6"
						if(2)	healths.icon_state = "health7"
						else
							//switch(health - halloss)
							switch(100 - ((species && species.flags & NO_PAIN & !IS_SYNTHETIC) ? 0 : traumatic_shock))
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

			if(pullin)
				if(pulling)								pullin.icon_state = "pull1"
				else									pullin.icon_state = "pull0"
//			if(rest)	//Not used with new UI
//				if(resting || lying || sleeping)		rest.icon_state = "rest1"
//				else									rest.icon_state = "rest0"
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

			if(blind)
				if(blinded)		blind.layer = 18
				else			blind.layer = 0

			if(disabilities & NEARSIGHTED)	//this looks meh but saves a lot of memory by not requiring to add var/prescription
				if(glasses)					//to every /obj/item
					var/obj/item/clothing/glasses/G = glasses
					if(!G.prescription)
						client.screen += global_hud.vimpaired
				else
					client.screen += global_hud.vimpaired

			if(eye_blurry)			client.screen += global_hud.blurry
			if(druggy)				client.screen += global_hud.druggy

			var/masked = 0

			if( istype(head, /obj/item/clothing/head/welding) || istype(head, /obj/item/clothing/head/helmet/space/unathi))
				var/obj/item/clothing/head/welding/O = head
				if(!O.up && tinted_weldhelh)
					client.screen += global_hud.darkMask
					masked = 1

			if(!masked && istype(glasses, /obj/item/clothing/glasses/welding) )
				var/obj/item/clothing/glasses/welding/O = glasses
				if(!O.up && tinted_weldhelh)
					client.screen += global_hud.darkMask

			if(machine)
				if(!machine.check_eye(src))		reset_view(null)
			else
				var/isRemoteObserve = 0
				if((mRemote in mutations) && remoteview_target)
					if(remoteview_target.stat==CONSCIOUS)
						isRemoteObserve = 1
				if(!isRemoteObserve && client && !client.adminobs)
					remoteview_target = null
					reset_view(null)
		return 1

	proc/handle_random_events()
		// Puke if toxloss is too high
		if(!stat)
			if (getToxLoss() >= 45 && nutrition > 20)
				vomit()

		//0.1% chance of playing a scary sound to someone who's in complete darkness
		if(isturf(loc) && rand(1,1000) == 1)
			var/turf/currentTurf = loc
			if(!currentTurf.lighting_lumcount)
				playsound_local(src,pick(scarySounds),50, 1, -1)

	proc/handle_virus_updates()
		if(status_flags & GODMODE)	return 0	//godmode
		if(bodytemperature > 406)
			for(var/datum/disease/D in viruses)
				D.cure()
			for (var/ID in virus2)
				var/datum/disease2/disease/V = virus2[ID]
				V.cure(src)

		for(var/obj/effect/decal/cleanable/O in view(1,src))
			if(istype(O,/obj/effect/decal/cleanable/blood))
				var/obj/effect/decal/cleanable/blood/B = O
				if(B.virus2.len)
					for (var/ID in B.virus2)
						var/datum/disease2/disease/V = B.virus2[ID]
						infect_virus2(src,V)

			else if(istype(O,/obj/effect/decal/cleanable/mucus))
				var/obj/effect/decal/cleanable/mucus/M = O
				if(M.virus2.len)
					for (var/ID in M.virus2)
						var/datum/disease2/disease/V = M.virus2[ID]
						infect_virus2(src,V)


		if(virus2.len)
			for (var/ID in virus2)
				var/datum/disease2/disease/V = virus2[ID]
				if(isnull(V)) // Trying to figure out a runtime error that keeps repeating
					CRASH("virus2 nulled before calling activate()")
				else
					V.activate(src)
				// activate may have deleted the virus
				if(!V) continue

				// check if we're immune
				if(V.antigen & src.antibodies)
					V.dead = 1

		return

	proc/handle_stomach()
		spawn(0)
			for(var/mob/living/M in stomach_contents)
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
						if(!(M.status_flags & GODMODE))
							M.adjustBruteLoss(5)
						nutrition += 10

	proc/handle_changeling()
		if(mind && mind.changeling)
			mind.changeling.regenerate()

	handle_shock()
		..()
		if(status_flags & GODMODE)	return 0	//godmode
		if(analgesic || (species && species.flags & NO_PAIN)) return // analgesic avoids all traumatic shock temporarily

		if(health < config.health_threshold_softcrit)// health 0 makes you immediately collapse
			shock_stage = max(shock_stage, 61)

		if(traumatic_shock >= 80)
			shock_stage += 1
		else if(health < config.health_threshold_softcrit)
			shock_stage = max(shock_stage, 61)
		else
			shock_stage = min(shock_stage, 160)
			shock_stage = max(shock_stage-1, 0)
			return

		if(shock_stage == 10)
			src << "<font color='red'><b>"+pick("It hurts so much!", "You really need some painkillers..", "Dear god, the pain!")

		if(shock_stage >= 30)
			if(shock_stage == 30) emote("me",1,"is having trouble keeping their eyes open.")
			eye_blurry = max(2, eye_blurry)
			stuttering = max(stuttering, 5)

		if(shock_stage == 40)
			src << "<font color='red'><b>"+pick("The pain is excrutiating!", "Please, just end the pain!", "Your whole body is going numb!")

		if (shock_stage >= 60)
			if(shock_stage == 60) emote("me",1,"'s body becomes limp.")
			if (prob(2))
				src << "<font color='red'><b>"+pick("The pain is excrutiating!", "Please, just end the pain!", "Your whole body is going numb!")
				Weaken(20)

		if(shock_stage >= 80)
			if (prob(5))
				src << "<font color='red'><b>"+pick("The pain is excrutiating!", "Please, just end the pain!", "Your whole body is going numb!")
				Weaken(20)

		if(shock_stage >= 120)
			if (prob(2))
				src << "<font color='red'><b>"+pick("You black out!", "You feel like you could die any moment now.", "You're about to lose consciousness.")
				Paralyse(5)

		if(shock_stage == 150)
			emote("me",1,"can no longer stand, collapsing!")
			Weaken(20)

		if(shock_stage >= 150)
			Weaken(20)

	proc/handle_pulse()

		if(life_tick % 5) return pulse	//update pulse every 5 life ticks (~1 tick/sec, depending on server load)

		if(species && species.flags & NO_BLOOD) return PULSE_NONE //No blood, no pulse.

		if(stat == DEAD)
			return PULSE_NONE	//that's it, you're dead, nothing can influence your pulse

		var/temp = PULSE_NORM

		if(round(vessel.get_reagent_amount("blood")) <= BLOOD_VOLUME_BAD)	//how much blood do we have
			temp = PULSE_THREADY	//not enough :(

		if(status_flags & FAKEDEATH)
			temp = PULSE_NONE		//pretend that we're dead. unlike actual death, can be inflienced by meds

		for(var/datum/reagent/R in reagents.reagent_list)
			if(R.id in bradycardics)
				if(temp <= PULSE_THREADY && temp >= PULSE_NORM)
					temp--
					break		//one reagent is enough
								//comment out the breaks to make med effects stack
		for(var/datum/reagent/R in reagents.reagent_list)				//handles different chems' influence on pulse
			if(R.id in tachycardics)
				if(temp <= PULSE_FAST && temp >= PULSE_NONE)
					temp++
					break
		for(var/datum/reagent/R in reagents.reagent_list) //To avoid using fakedeath
			if(R.id in heartstopper)
				temp = PULSE_NONE
				break
		for(var/datum/reagent/R in reagents.reagent_list) //Conditional heart-stoppage
			if(R.id in cheartstopper)
				if(R.volume >= R.overdose)
					temp = PULSE_NONE
					break

		return temp

/*
	Called by life(), instead of having the individual hud items update icons each tick and check for status changes
	we only set those statuses and icons upon changes.  Then those HUD items will simply add those pre-made images.
	This proc below is only called when those HUD elements need to change as determined by the mobs hud_updateflag.
*/


/mob/living/carbon/human/proc/handle_hud_list()

	if(hud_updateflag & 1 << HEALTH_HUD)
		var/image/holder = hud_list[HEALTH_HUD]
		if(stat == 2)
			holder.icon_state = "hudhealth-100" 	// X_X
		else
			holder.icon_state = "hud[RoundHealth(health)]"

		hud_list[HEALTH_HUD] = holder

	if(hud_updateflag & 1 << STATUS_HUD)
		var/foundVirus = 0
		for(var/datum/disease/D in viruses)
			if(!D.hidden[SCANNER])
				foundVirus++
		for (var/ID in virus2)
			if (ID in virusDB)
				foundVirus = 1
				break

		var/image/holder = hud_list[STATUS_HUD]
		var/image/holder2 = hud_list[STATUS_HUD_OOC]
		if(stat == 2)
			holder.icon_state = "huddead"
			holder2.icon_state = "huddead"
		else if(status_flags & XENO_HOST)
			holder.icon_state = "hudxeno"
			holder2.icon_state = "hudxeno"
		else if(foundVirus)
			holder.icon_state = "hudill"
		else if(has_brain_worms())
			var/mob/living/simple_animal/borer/B = has_brain_worms()
			if(B.controlling)
				holder.icon_state = "hudbrainworm"
			else
				holder.icon_state = "hudhealthy"
			holder2.icon_state = "hudbrainworm"
		else
			holder.icon_state = "hudhealthy"
			if(virus2.len)
				holder2.icon_state = "hudill"
			else
				holder2.icon_state = "hudhealthy"

		hud_list[STATUS_HUD] = holder
		hud_list[STATUS_HUD_OOC] = holder2

	if(hud_updateflag & 1 << ID_HUD)
		var/image/holder = hud_list[ID_HUD]
		if(wear_id)
			var/obj/item/weapon/card/id/I = wear_id.GetID()
			if(I)
				holder.icon_state = "hud[ckey(I.GetJobName())]"
			else
				holder.icon_state = "hudunknown"
		else
			holder.icon_state = "hudunknown"


		hud_list[ID_HUD] = holder

	if(hud_updateflag & 1 << WANTED_HUD)
		var/image/holder = hud_list[WANTED_HUD]
		holder.icon_state = "hudblank"
		var/perpname = name
		if(wear_id)
			var/obj/item/weapon/card/id/I = wear_id.GetID()
			if(I)
				perpname = I.registered_name

		for(var/datum/data/record/E in data_core.general)
			if(E.fields["name"] == perpname)
				for (var/datum/data/record/R in data_core.security)
					if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "*Arrest*"))
						holder.icon_state = "hudwanted"
						break
					else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Incarcerated"))
						holder.icon_state = "hudprisoner"
						break
					else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Parolled"))
						holder.icon_state = "hudparolled"
						break
					else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Released"))
						holder.icon_state = "hudreleased"
						break
		hud_list[WANTED_HUD] = holder

	if(hud_updateflag & 1 << IMPLOYAL_HUD || hud_updateflag & 1 << IMPCHEM_HUD || hud_updateflag & 1 << IMPTRACK_HUD)
		var/image/holder1 = hud_list[IMPTRACK_HUD]
		var/image/holder2 = hud_list[IMPLOYAL_HUD]
		var/image/holder3 = hud_list[IMPCHEM_HUD]

		holder1.icon_state = "hudblank"
		holder2.icon_state = "hudblank"
		holder3.icon_state = "hudblank"

		for(var/obj/item/weapon/implant/I in src)
			if(I.implanted)
				if(istype(I,/obj/item/weapon/implant/tracking))
					holder1.icon_state = "hud_imp_tracking"
				if(istype(I,/obj/item/weapon/implant/loyalty))
					holder2.icon_state = "hud_imp_loyal"
				if(istype(I,/obj/item/weapon/implant/chem))
					holder3.icon_state = "hud_imp_chem"

		hud_list[IMPTRACK_HUD] = holder1
		hud_list[IMPLOYAL_HUD] = holder2
		hud_list[IMPCHEM_HUD] = holder3

	if(hud_updateflag & 1 << SPECIALROLE_HUD)
		var/image/holder = hud_list[SPECIALROLE_HUD]
		holder.icon_state = "hudblank"
		if(mind)

			switch(mind.special_role)
				if("traitor","Syndicate")
					holder.icon_state = "hudsyndicate"
				if("Revolutionary")
					holder.icon_state = "hudrevolutionary"
				if("Head Revolutionary")
					holder.icon_state = "hudheadrevolutionary"
				if("Cultist")
					holder.icon_state = "hudcultist"
				if("Changeling")
					holder.icon_state = "hudchangeling"
				if("Wizard","Fake Wizard")
					holder.icon_state = "hudwizard"
				if("Death Commando")
					holder.icon_state = "huddeathsquad"
				if("Ninja")
					holder.icon_state = "hudninja"

			hud_list[SPECIALROLE_HUD] = holder
	hud_updateflag = 0


#undef HUMAN_MAX_OXYLOSS
#undef HUMAN_CRIT_MAX_OXYLOSS
