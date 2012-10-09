//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/mob/living/carbon/alien/larva

	var/temperature_alert = 0


/mob/living/carbon/alien/larva/Life()
	set invisibility = 0
	set background = 1

	if (monkeyizing)
		return

	..()
	var/datum/gas_mixture/enviroment = loc.return_air()
	if (stat != DEAD) //still breathing

		// GROW!
		if(amount_grown < max_grown)
			amount_grown++

		//First, resolve location and get a breath
		if(air_master.current_cycle%4==2)
			//Only try to take a breath every 4 seconds, unless suffocating
			spawn(0) breathe()
		else //Still give containing object the chance to interact
			if(istype(loc, /obj/))
				var/obj/location_as_object = loc
				location_as_object.handle_internal_lifeform(src, 0)
		//Mutations and radiation
		handle_mutations_and_radiation()

		//Chemicals in the body
		handle_chemicals_in_body()


	//Apparently, the person who wrote this code designed it so that
	//blinded get reset each cycle and then get activated later in the
	//code. Very ugly. I dont care. Moving this stuff here so its easy
	//to find it.
	blinded = null

	//Disease Check
	//handle_virus_updates() There is no disease that affects larva

	//Handle temperature/pressure differences between body and environment
	handle_environment(enviroment)

	//stuff in the stomach
	//handle_stomach()

	//Status updates, death etc.
	handle_regular_status_updates()
	update_canmove()

	// Grabbing
	for(var/obj/item/weapon/grab/G in src)
		G.process()

	if(client)
		handle_regular_hud_updates()


/mob/living/carbon/alien/larva

	proc/breathe()

		if(reagents.has_reagent("lexorin")) return
		if(istype(loc, /obj/machinery/atmospherics/unary/cryo_cell)) return

		var/datum/gas_mixture/environment = loc.return_air()
		var/datum/gas_mixture/breath
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
			breath = get_breath_from_internal(BREATH_VOLUME)

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


	proc/get_breath_from_internal(volume_needed)
		if(internal)
			if (!contents.Find(internal))
				internal = null
			if (!wear_mask || !(wear_mask.flags & MASKINTERNALS) )
				internal = null
			if(internal)
				if (internals)
					internals.icon_state = "internal1"
				return internal.remove_air_volume(volume_needed)
			else
				if (internals)
					internals.icon_state = "internal0"
		return null

	proc/handle_breath(datum/gas_mixture/breath)
		if(nodamage)
			return

		if(!breath || (breath.total_moles == 0))
			//Aliens breathe in vaccuum
			return 0

		var/toxins_used = 0
		var/breath_pressure = (breath.total_moles()*R_IDEAL_GAS_EQUATION*breath.temperature)/BREATH_VOLUME

		//Partial pressure of the toxins in our breath
		var/Toxins_pp = (breath.toxins/breath.total_moles())*breath_pressure

		if(Toxins_pp) // Detect toxins in air

			adjustToxLoss(breath.toxins*250)
			toxins_alert = max(toxins_alert, 1)

			toxins_used = breath.toxins

		else
			toxins_alert = 0

		//Breathe in toxins and out oxygen
		breath.toxins -= toxins_used
		breath.oxygen += toxins_used

		if(breath.temperature > (T0C+66) && !(COLD_RESISTANCE in mutations)) // Hot air hurts :(
			if(prob(20))
				src << "\red You feel a searing heat in your lungs!"
			fire_alert = max(fire_alert, 1)
		else
			fire_alert = 0

		//Temporary fixes to the alerts.

		return 1


	proc/handle_chemicals_in_body()
		if(reagents) reagents.metabolize(src)

		if(FAT in mutations)
			if(nutrition < 100)
				if(prob(round((50 - nutrition) / 100)))
					src << "\blue You feel fit again!"
					mutations.Add(FAT)
		else
			if(nutrition > 500)
				if(prob(5 + round((nutrition - max_grown) / 2)))
					src << "\red You suddenly feel blubbery!"
					mutations.Add(FAT)

		if (nutrition > 0)
			nutrition-= HUNGER_FACTOR

		if (drowsyness)
			drowsyness--
			eye_blurry = max(2, eye_blurry)
			if (prob(5))
				sleeping += 1
				Paralyse(5)

		confused = max(0, confused - 1)
		// decrement dizziness counter, clamped to 0
		if(resting)
			dizziness = max(0, dizziness - 5)
			jitteriness = max(0, jitteriness - 5)
		else
			dizziness = max(0, dizziness - 1)
			jitteriness = max(0, jitteriness - 1)

		updatehealth()

		return //TODO: DEFERRED

	proc/handle_regular_status_updates()
		updatehealth()

		if(stat == DEAD)	//DEAD. BROWN BREAD. SWIMMING WITH THE SPESS CARP
			blinded = 1
			silent = 0
		else				//ALIVE. LIGHTS ARE ON
			if(health < config.health_threshold_dead || brain_op_stage == 4.0)
				death()
				blinded = 1
				silent = 0
				return 1

			//UNCONSCIOUS. NO-ONE IS HOME
			if( (getOxyLoss() > 50) || (config.health_threshold_crit > health) )
				if( health <= 20 && prob(1) )
					spawn(0)
						emote("gasp")
				if(!reagents.has_reagent("inaprovaline"))
					adjustOxyLoss(1)
				Paralyse(3)

			if(paralysis)
				AdjustParalysis(-2)
				blinded = 1
				stat = UNCONSCIOUS
			else if(sleeping)
				sleeping = max(sleeping-1, 0)
				blinded = 1
				stat = UNCONSCIOUS
				if( prob(10) && health )
					spawn(0)
						emote("hiss")
			//CONSCIOUS
			else
				stat = CONSCIOUS

			/*	What in the living hell is this?*/
			if(move_delay_add > 0)
				move_delay_add = max(0, move_delay_add - rand(1, 2))

			//Eyes
			if(sdisabilities & BLIND)	//disabled-blind, doesn't get better on its own
				blinded = 1
			else if(eye_blind)			//blindness, heals slowly over time
				eye_blind = max(eye_blind-1,0)
				blinded = 1
			else if(eye_blurry)	//blurry eyes heal slowly
				eye_blurry = max(eye_blurry-1, 0)

			//Ears
			if(sdisabilities & DEAF)	//disabled-deaf, doesn't get better on its own
				ear_deaf = max(ear_deaf, 1)
			else if(ear_deaf)			//deafness, heals slowly over time
				ear_deaf = max(ear_deaf-1, 0)
			else if(ear_damage < 25)	//ear damage heals slowly under this threshold.
				ear_damage = max(ear_damage-0.05, 0)

			//Other
			if(stunned)
				AdjustStunned(-1)

			if(weakened)
				weakened = max(weakened-1,0)	//before you get mad Rockdtben: I done this so update_canmove isn't called multiple times

			if(stuttering)
				stuttering = max(stuttering-1, 0)

			if(silent)
				silent = max(silent-1, 0)

			if(druggy)
				druggy = max(druggy-1, 0)
		return 1


	proc/handle_regular_hud_updates()

		if (stat == 2 || (XRAY in mutations))
			sight |= SEE_TURFS
			sight |= SEE_MOBS
			sight |= SEE_OBJS
			see_in_dark = 8
			see_invisible = SEE_INVISIBLE_LEVEL_TWO
		else if (stat != 2)
			sight |= SEE_MOBS
			sight &= ~SEE_TURFS
			sight &= ~SEE_OBJS
			see_in_dark = 4
			see_invisible = SEE_INVISIBLE_LEVEL_TWO

		if (healths)
			if (stat != 2)
				switch(health)
					if(25 to INFINITY)
						healths.icon_state = "health0"
					if(19 to 25)
						healths.icon_state = "health1"
					if(13 to 19)
						healths.icon_state = "health2"
					if(7 to 13)
						healths.icon_state = "health3"
					if(0 to 7)
						healths.icon_state = "health4"
					else
						healths.icon_state = "health5"
			else
				healths.icon_state = "health6"

		if(pullin)	pullin.icon_state = "pull[pulling ? 1 : 0]"


		if (toxin)	toxin.icon_state = "tox[toxins_alert ? 1 : 0]"
		if (oxygen) oxygen.icon_state = "oxy[oxygen_alert ? 1 : 0]"
		if (fire) fire.icon_state = "fire[fire_alert ? 1 : 0]"
		//NOTE: the alerts dont reset when youre out of danger. dont blame me,
		//blame the person who coded them. Temporary fix added.


		client.screen.Remove(global_hud.blurry,global_hud.druggy,global_hud.vimpaired)

		if ((blind && stat != 2))
			if ((blinded))
				blind.layer = 18
			else
				blind.layer = 0

				if (disabilities & NEARSIGHTED)
					client.screen += global_hud.vimpaired

				if (eye_blurry)
					client.screen += global_hud.blurry

				if (druggy)
					client.screen += global_hud.druggy

		if (stat != 2)
			if (machine)
				if (!( machine.check_eye(src) ))
					reset_view(null)
			else
				if(!client.adminobs)
					reset_view(null)

		return 1

	proc/handle_random_events()
		return

	proc/handle_virus_updates()
		if(bodytemperature > 406)
			for(var/datum/disease/D in viruses)
				D.cure()
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
						if(!M.nodamage)
							M.adjustBruteLoss(5)
						nutrition += 10