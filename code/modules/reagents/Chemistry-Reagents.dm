/datum/reagent
	var/name = "Reagent"
	var/id = "reagent"
	var/description = "A non-descript chemical."
	var/datum/reagents/holder = null
	var/state = CHEM_TOUCH
	var/reagent_state = SOLID
	var/list/data = null
	var/volume = 0
	var/metabolism = REM // This would be 0.2 normally
	var/ingest_met = 0
	var/touch_met = 0
	var/list/filtering_organs = null // These organs help in chemical removal if they are working
	var/list/filtering_speed = null
	var/dose = 0
	var/max_dose = 0
	var/overdose_blood = 0
	var/overdose_ingest = 0
	var/addiction = null
	var/addiction_strength = 0
	var/scannable = 0 // Shows up on health analyzers.
	var/painkiler = 0
	var/affects_dead = 0
	var/glass_icon_state = null
	var/glass_name = null
	var/glass_desc = null
	var/glass_center_of_mass = null
	var/color = "#000000"

/datum/reagent/proc/remove_self(var/amount) // Shortcut
	holder.remove_reagent(id, amount, state)

/datum/reagent/proc/touch_mob(var/mob/M) // By default, moves everything to mob in CHEM_TOUCH state. Could be overridden. // TODO: protection
	holder.trans_id_to(M, id, volume)
	return

/datum/reagent/proc/touch_obj(var/obj/O) // Acid melting, cleaner cleaning, etc
	return

/datum/reagent/proc/touch_turf(var/turf/T) // Cleaner cleaning, lube lubbing, etc, all go here
	return

/datum/reagent/proc/on_mob_life(var/mob/living/carbon/M, var/alien) // Currently, on_mob_life is called on carbons. Any interaction with non-carbon mobs (lube) will need to be done in touch_mob.
	if(!istype(M))
		return
	if(!affects_dead && M.stat == DEAD)
		return
	if((overdose_blood && (state == CHEM_BLOOD) && dose > overdose_blood) || (overdose_ingest && (state == CHEM_INGEST) && dose > overdose_ingest))
		overdose(M, alien)
	var/removed = metabolism
	if(ingest_met && (state == CHEM_INGEST))
		removed = ingest_met
	if(touch_met && (state == CHEM_TOUCH))
		removed = touch_met
	removed = min(removed, volume)
	max_dose = max(volume, max_dose)
	dose = min(dose + removed, max_dose)
	if(painkiler)
		M.analgesic += painkiler
	world << "Reagent: [id], volume: [volume], dose: [dose], max_dose: [max_dose], state: [state], removed: [removed], metabolism: [metabolism]"
	if(removed >= (metabolism * 0.1)) // If there's too little chemical, don't affect the mob, just remove it
		affect_mob(M, alien, removed)
	remove_self(removed)
	if(filtering_organs && filtering_organs.len)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			for(var/i = 1 to filtering_organs.len)
				var/name = filtering_organs[i]
				var/datum/organ/internal/O = H.internal_organs_by_name[name]
				if(O)
					if(O.is_broken())
						broken_organ(M, alien, removed, name)
					else if(O.is_bruised())
						remove_self(filtering_speed[i] * 0.5)
						bruised_organ(M, alien, removed, name)
					else
						remove_self(filtering_speed[i])
				else
					if(M.species.has_organ[name]) // Let's not kill dionae for not having a liver
						missing_organ(M, alien, removed, name)
					else
						no_organ(M, alien, removed, name)
	if(addiction && ishuman(M))
		var/mob/living/carbon/human/H = M
		H.addict(addiction, addiction_strength * removed)
	return

/datum/reagent/proc/bruised_organ(var/mob/living/carbon/M, var/alien, var/removed, var/name) // Organ exists but is bruised
	return

/datum/reagent/proc/broken_organ(var/mob/living/carbon/M, var/alien, var/removed, var/name) // Organ exists but is broken
	return

/datum/reagent/proc/missing_organ(var/mob/living/carbon/M, var/alien, var/removed, var/name) // Organ is meant to exist but doesn't - probably surgery
	return

/datum/reagent/proc/no_organ(var/mob/living/carbon/M, var/alien, var/removed, var/name) // Species don't have this organ
	return

/datum/reagent/proc/affect_mob(var/mob/living/carbon/M, var/alien, var/removed) // This is the main working proc where the chemical does its magic
	return

/datum/reagent/proc/overdose(var/mob/living/carbon/M, var/alien) // Overdose effect. Doesn't happen instantly.
	M.adjustToxLoss(REM)
	return

/datum/reagent/proc/addiction_effect(var/mob/living/carbon/M, var/alien, var/stage) // TODO
	return

/datum/reagent/proc/initialize_data() // Called when the reagent is created.
	return

/datum/reagent/proc/mix_data(var/newdata) // You have a reagent with data, and new reagent with its own data get added, how do you deal with that?
	return

/datum/reagent/proc/get_data() // Just in case you have a reagent that handles data differently. See paint.
	return data

/* DEPRECATED - TODO: REMOVE EVERYWHERE */

/datum/reagent/proc/reaction_turf(var/turf/target)
	touch_turf(target)

/datum/reagent/proc/reaction_obj(var/obj/target)
	touch_obj(target)

/datum/reagent/proc/reaction_mob(var/mob/target)
	touch_mob(target)


/* REAGENTS START HERE */

/* Core reagents - the most important ones */

/datum/reagent/blood
	data = new/list("donor" = null, "viruses" = null, "species" = "Human", "blood_DNA" = null, "blood_type" = null, "blood_colour" = "#A10808", "resistances" = null, "trace_chem" = null, "antibodies" = list())
	name = "Blood"
	id = "blood"
	reagent_state = LIQUID
	metabolism = REM * 5
	color = "#C80000"

	glass_icon_state = "glass_red"
	glass_name = "glass of tomato juice"
	glass_desc = "Are you sure this is tomato juice?"

/datum/reagent/blood/touch_turf(var/turf/simulated/T)
	if(!istype(T) || volume < 3)
		return
	if(!data["donor"] || istype(data["donor"], /mob/living/carbon/human))
		blood_splatter(T, src, 1)
	else if(istype(data["donor"], /mob/living/carbon/monkey))
		var/obj/effect/decal/cleanable/blood/B = blood_splatter(T, src, 1)
		if(B)
			B.blood_DNA["Non-Human DNA"] = "A+"
	else if(istype(data["donor"], /mob/living/carbon/alien))
		var/obj/effect/decal/cleanable/blood/B = blood_splatter(T, src, 1)
		if(B)
			B.blood_DNA["UNKNOWN DNA STRUCTURE"] = "X*"

/datum/reagent/blood/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	if(state == CHEM_INGEST)
		if(dose > 5)
			M.adjustToxLoss(removed)
		if(dose > 15)
			M.adjustToxLoss(removed)
	if(state == CHEM_TOUCH)
		if(data && data["viruses"])
			for(var/datum/disease/D in data["viruses"])
				if(D.spread_type == SPECIAL || D.spread_type == NON_CONTAGIOUS)
					continue
				M.contract_disease(D)
		if(data && data["virus2"])
			var/list/vlist = data["virus2"]
			if(vlist.len)
				for(var/ID in vlist)
					var/datum/disease2/disease/V = vlist[ID]
					infect_virus2(M, V.getcopy())
		if(data && data["antibodies"])
			M.antibodies |= data["antibodies"]
	if(state == CHEM_BLOOD)
		M.inject_blood(src, volume)
		remove_self(volume)

/datum/reagent/vaccine
	name = "Vaccine"
	id = "vaccine"
	reagent_state = LIQUID
	color = "#C81040"

/datum/reagent/vaccine/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	if(data && state == CHEM_BLOOD)
		for(var/datum/disease/D in M.viruses)
			if(istype(D, /datum/disease/advance))
				var/datum/disease/advance/A = D
				if(A.GetDiseaseID() == data)
					D.cure()
			else
				if(D.type == data)
					D.cure()

		M.resistances += data
	return

#define WATER_LATENT_HEAT 19000 // How much heat is removed when applied to a hot turf, in J/unit (19000 makes 120 u of water roughly equivalent to 4L)
/datum/reagent/water
	name = "Water"
	id = "water"
	description = "A ubiquitous chemical substance that is composed of hydrogen and oxygen."
	reagent_state = LIQUID
	color = "#0064C877"

	glass_icon_state = "glass_clear"
	glass_name = "glass of water"
	glass_desc = "The father of all refreshments."

/datum/reagent/water/touch_turf(var/turf/simulated/T)
	if(!istype(T))
		return

	var/datum/gas_mixture/environment = T.return_air()
	var/min_temperature = T0C + 100 // 100C, the boiling point of water

	var/hotspot = (locate(/obj/fire) in T)
	if(hotspot && !istype(T, /turf/space))
		var/datum/gas_mixture/lowertemp = T.remove_air(T:air:total_moles)
		lowertemp.temperature = max(min(lowertemp.temperature-2000, lowertemp.temperature / 2), 0)
		lowertemp.react()
		T.assume_air(lowertemp)
		del(hotspot)

	if (environment && environment.temperature > min_temperature) // Abstracted as steam or something
		var/removed_heat = between(0, volume * WATER_LATENT_HEAT, -environment.get_thermal_energy_change(min_temperature))
		environment.add_thermal_energy(-removed_heat)
		if (prob(5))
			T.visible_message("<span class='warning'>The water sizzles as it lands on \the [T]!</span>")
	else
		if(volume >= 3)
			if(T.wet >= 1)
				return
			T.wet = 1
			if(T.wet_overlay)
				T.overlays -= T.wet_overlay
				T.wet_overlay = null
			T.wet_overlay = image('icons/effects/water.dmi',T,"wet_floor")
			T.overlays += T.wet_overlay

			spawn(800) // This is terrible and needs to be changed when possible.
				if(!T || !istype(T))
					return
				if(T.wet >= 2)
					return
				T.wet = 0
				if(T.wet_overlay)
					T.overlays -= T.wet_overlay
					T.wet_overlay = null

/datum/reagent/water/touch_obj(var/obj/O)
	if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/monkeycube))
		var/obj/item/weapon/reagent_containers/food/snacks/monkeycube/cube = O
		if(!cube.wrapped)
			cube.Expand()

/datum/reagent/water/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	if(istype(M, /mob/living/carbon/slime))
		var/mob/living/carbon/slime/S = M
		S.adjustToxLoss(100 * removed) // 1.5 units/7.5 ticks for baby, 2/10 for adult
		if(!S.client)
			if(S.Target) // Like cats
				S.Target = null
				++S.Discipline
		if(dose == removed * 2)
			S.visible_message("<span class='warning'>[S]'s flesh sizzles where the water touches it!</span>", "<span class='danger'>Your flesh burns in the water!</span>")
	if(state == CHEM_TOUCH)
		var/needed = M.fire_stacks * 10
		if(volume > needed)
			M.fire_stacks = 0
			M.ExtinguishMob()
			remove_self(needed)
		else
			M.adjust_fire_stacks(-(volume / 10))
			remove_self(volume)
		return

/datum/reagent/fuel
	name = "Welding fuel"
	id = "fuel"
	description = "Required for welders. Flamable."
	reagent_state = LIQUID
	color = "#660000"

	glass_icon_state = "dr_gibb_glass"
	glass_name = "glass of welder fuel"
	glass_desc = "Unless you are an industrial tool, this is probably not safe for consumption."

/datum/reagent/fuel/touch_turf(var/turf/T)
	new /obj/effect/decal/cleanable/liquid_fuel(T, volume)
	remove_self(volume)
	return

/datum/reagent/fuel/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	if(state == CHEM_INGEST)
		M.adjustToxLoss(1 * removed)
		return
	if(state == CHEM_BLOOD)
		M.adjustToxLoss(2 * removed)
		return
	if(state == CHEM_TOUCH) // Splashing people with welding fuel to make them easy to ignite!
		M.adjust_fire_stacks(0.1 * removed)
		return

/* Basic dispenser chemicals */

/datum/reagent/aluminum
	name = "Aluminum"
	id = "aluminum"
	description = "A silvery white and ductile member of the boron group of chemical elements."
	reagent_state = SOLID
	color = "#A8A8A8"

/datum/reagent/carbon
	name = "Carbon"
	id = "carbon"
	description = "A chemical element, the builing block of life."
	reagent_state = SOLID
	color = "#1C1300"

/datum/reagent/carbon/touch_turf(var/turf/T)
	if(!istype(T, /turf/space))
		var/obj/effect/decal/cleanable/dirt/dirtoverlay = locate(/obj/effect/decal/cleanable/dirt, T)
		if (!dirtoverlay)
			dirtoverlay = new/obj/effect/decal/cleanable/dirt(T)
			dirtoverlay.alpha = volume * 30
		else
			dirtoverlay.alpha = min(dirtoverlay.alpha + volume * 30, 255)

/datum/reagent/chlorine
	name = "Chlorine"
	id = "chlorine"
	description = "A chemical element with a characteristic odour."
	reagent_state = GAS
	color = "#808080"

/datum/reagent/chlorine/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	M.take_organ_damage(1*REM, 0) // State doesn't matter here

/datum/reagent/copper
	name = "Copper"
	id = "copper"
	description = "A highly ductile metal."
	color = "#6E3B08"

/datum/reagent/ethanol
	name = "Ethanol" //Parent class for all alcoholic reagents.
	id = "ethanol"
	description = "A well-known alcohol with a variety of applications."
	reagent_state = LIQUID
	color = "#404030"
	filtering_organs = list("liver")
	filtering_speed = list(REM)
	addiction = /datum/addiction/alcohol
	addiction_strength = 1
	var/nutriment_factor = 0
	var/strength = 10 // This is, essentially, units between stages - the lower, the stronger. Less fine tuning, more clarity.
	var/toxicity = 1

	glass_icon_state = "glass_clear"
	glass_name = "glass of ethanol"
	glass_desc = "A well-known alcohol with a variety of applications."

/datum/reagent/ethanol/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	if(state == CHEM_TOUCH)
		M.adjust_fire_stacks(removed / 15)
		return
	if(state == CHEM_BLOOD)
		M.adjustToxLoss(removed * 2 * toxicity)
		return
	M.nutrition += nutriment_factor * removed

	var/strength_mod = 1
	if(alien == IS_SKRELL)
		strength_mod *= 5
	if(alien == IS_DIONA)
		strength_mod = 0

	if(dose / strength_mod >= strength) // Early warning
		M.make_dizzy(5) // It is decreased at the speed of 3 per tick
	if(dose / strength_mod >= strength * 4)
		M.slurring = max(M.slurring, 30)
	if(dose / strength_mod >= strength * 5)
		M.confused = max(M.confused, 20)
	if(dose / strength_mod >= strength * 6)
		M.eye_blurry = max(M.eye_blurry, 10)
	if(dose / strength_mod >= strength * 7)
		M.drowsyness = max(M.drowsyness, 20)
	if(dose / strength_mod >= strength * 8)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			var/datum/organ/internal/liver/O = H.internal_organs_by_name["liver"]
			if(!O || !istype(O) || O.is_broken())
				M.adjustToxLoss(removed * toxicity)
			else
				if(!O.is_bruised()) // Working liver, we're (mostly) good
					O.take_damage(removed * toxicity * 0.1, prob(1)) // Chance to warn them
				else
					O.take_damage(removed * toxicity * 0.05, prob(3))
					M.adjustToxLoss(removed * toxicity * 0.5) // This is in addition to the damage caused just by drinking
		else
			M.adjustToxLoss(removed * toxicity)
	if(dose / strength_mod >= strength * 9)
		M.paralysis = max(M.paralysis, 20)
		M.sleeping  = max(M.sleeping, 30)

/datum/reagent/ethanol/bruised_organ(var/mob/living/carbon/M, var/alien, var/removed, var/name)
	if(name == "liver")
		M.adjustToxLoss(removed * toxicity)
	return

/datum/reagent/ethanol/broken_organ(var/mob/living/carbon/M, var/alien, var/removed, var/name)
	if(name == "liver")
		M.adjustToxLoss(removed * toxicity * 2)
	return

/datum/reagent/ethanol/missing_organ(var/mob/living/carbon/M, var/alien, var/removed, var/name)
	if(name == "liver")
		M.adjustToxLoss(removed * toxicity * 3)
	return

/datum/reagent/ethanol/touch_obj(var/obj/O)
	if(istype(O, /obj/item/weapon/paper))
		var/obj/item/weapon/paper/paperaffected = O
		paperaffected.clearpaper()
		usr << "The solution dissolves the ink on the paper."
		return
	if(istype(O, /obj/item/weapon/book))
		if(volume < 5)
			return
		if(istype(O, /obj/item/weapon/book/tome))
			usr << "<span class='notice'>The solution does nothing. Whatever this is, it isn't normal ink.</span>"
			return
		var/obj/item/weapon/book/affectedbook = O
		affectedbook.dat = null
		usr << "<span class='notice'>The solution dissolves the ink on the book.</span>"
	return

/datum/reagent/fluorine
	name = "Fluorine"
	id = "fluorine"
	description = "A highly-reactive chemical element."
	reagent_state = GAS
	color = "#808080"

/datum/reagent/fluorine/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustToxLoss(removed)

/datum/reagent/hydrogen
	name = "Hydrogen"
	id = "hydrogen"
	description = "A colorless, odorless, nonmetallic, tasteless, highly combustible diatomic gas."
	reagent_state = GAS
	color = "#808080"

/datum/reagent/iron
	name = "Iron"
	id = "iron"
	description = "Pure iron is a metal."
	reagent_state = SOLID
	color = "#353535"

/datum/reagent/iron/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	if(state == CHEM_INGEST && alien != IS_DIONA)
		M.add_chemical_effect(CE_BLOODRESTORE, 8 * removed)

/datum/reagent/lithium
	name = "Lithium"
	id = "lithium"
	description = "A chemical element, used as antidepressant."
	reagent_state = SOLID
	color = "#808080"

/datum/reagent/lithium/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	if(state != CHEM_TOUCH && alien != IS_DIONA)
		if(M.canmove && !M.restrained() && istype(M.loc, /turf/space))
			step(M, pick(cardinal))
		if(prob(5))
			M.emote(pick("twitch", "drool", "moan"))

/datum/reagent/mercury
	name = "Mercury"
	id = "mercury"
	description = "A chemical element."
	reagent_state = LIQUID
	color = "#484848"

/datum/reagent/mercury/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	if(state != CHEM_TOUCH && alien != IS_DIONA)
		if(M.canmove && !M.restrained() && istype(M.loc, /turf/space))
			step(M, pick(cardinal))
		if(prob(5))
			M.emote(pick("twitch", "drool", "moan"))
		M.adjustBrainLoss(2)

/datum/reagent/nitrogen
	name = "Nitrogen"
	id = "nitrogen"
	description = "A colorless, odorless, tasteless gas."
	reagent_state = GAS
	color = "#808080"

/datum/reagent/nitrogen/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_VOX)
		if(state == CHEM_BLOOD)
			M.adjustOxyLoss(-removed * 3)
		if(state == CHEM_INGEST)
			M.reagents.add_reagent(id, removed, CHEM_BLOOD)

/datum/reagent/oxygen
	name = "Oxygen"
	id = "oxygen"
	description = "A colorless, odorless gas."
	reagent_state = GAS
	color = "#808080"

/datum/reagent/oxygen/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	if(state == CHEM_TOUCH)
		return
	if(alien == IS_VOX)
		var/effect = (state == CHEM_BLOOD ? 1.5 : 1)
		M.adjustToxLoss(removed * 2 * effect)

/datum/reagent/phosphorus
	name = "Phosphorus"
	id = "phosphorus"
	description = "A chemical element, the backbone of biological energy carriers."
	reagent_state = SOLID
	color = "#832828"

/datum/reagent/potassium
	name = "Potassium"
	id = "potassium"
	description = "A soft, low-melting solid that can easily be cut with a knife. Reacts violently with water."
	reagent_state = SOLID
	color = "#A0A0A0"

/datum/reagent/radium
	name = "Radium"
	id = "radium"
	description = "Radium is an alkaline earth metal. It is extremely radioactive."
	reagent_state = SOLID
	color = "#C7C7C7"

/datum/reagent/radium/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	M.apply_effect(2 * removed, IRRADIATE, 0) // Radium may increase your chances to cure a disease
	if(state == CHEM_BLOOD) // Make sure to only use it on carbon mobs
		if(M.virus2.len)
			for(var/ID in M.virus2)
				var/datum/disease2/disease/V = M.virus2[ID]
				if(prob(5))
					M.antibodies |= V.antigen
					if(prob(50))
						M.radiation += 50 // curing it that way may kill you instead
						var/absorbed = 0
						var/datum/organ/internal/diona/nutrients/rad_organ = locate() in M.internal_organs
						if(rad_organ && !rad_organ.is_broken())
							absorbed = 1
						if(!absorbed)
							M.adjustToxLoss(100)

/datum/reagent/radium/touch_turf(var/turf/T)
	if(volume >= 3)
		if(!istype(T, /turf/space))
			var/obj/effect/decal/cleanable/greenglow/glow = locate(/obj/effect/decal/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/decal/cleanable/greenglow(T)
			return

/datum/reagent/toxin/acid
	name = "Sulphuric acid"
	id = "sacid"
	description = "A very corrosive mineral acid with the molecular formula H2SO4."
	reagent_state = LIQUID
	color = "#DB5008"
	power = 5
	metabolism = REM * 50 // It's acid!
	var/meltdose = 10 // How much is needed to melt

/datum/reagent/toxin/acid/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	if(state == CHEM_INGEST)
		M.take_organ_damage(0, removed)
	if(state == CHEM_BLOOD)
		M.take_organ_damage(0, removed * 2)
	if(state == CHEM_TOUCH) // This is the most interesting
		if(volume < meltdose) // Not enough to melt anything
			M.take_organ_damage(removed)
			return
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.head)
				if(H.head.unacidable)
					H << "<span class='danger'>Your [H.head] protects you from the acid.</span>"
					remove_self(volume)
					return
				else
					H << "<span class='danger'>Your [H.head] melts away!</span>"
					del(H.head)
					H.update_inv_head(0)
					H.update_hair(0)
					remove_self(meltdose)
			if(volume <= 0)
				world << "Yep, it's needed"
				return

			if(H.wear_mask)
				if(H.wear_mask.unacidable)
					H << "<span class='danger'>Your [H.wear_mask] protects you from the acid.</span>"
					remove_self(volume)
					return
				else
					H << "<span class='danger'>Your [H.wear_mask] melts away!</span>"
					del(H.wear_mask)
					H.update_inv_wear_mask(0)
					H.update_hair(0)
					remove_self(meltdose)
			if(volume <= 0)
				world << "Yep, it's needed"
				return

			if(H.glasses)
				if(H.glasses.unacidable && dose == removed)
					H << "<span class='danger'>Your [H.glasses] partially protect you from the acid!</span>"
					remove_self(meltdose / 2)
				else if(!H.glasses.unacidable)
					H << "<span class='danger'>Your [H.glasses] melt away!</span>"
					del(H.glasses)
					H.update_inv_glasses(0)
					remove_self(meltdose / 2)
			if(volume <= 0)
				world << "Yep, it's needed"
				return

		if(ismonkey(M))
			var/mob/living/carbon/monkey/MK = M
			if(MK.wear_mask)
				if(MK.wear_mask.unacidable && dose == removed)
					MK << "<span class='danger'>Your [MK.wear_mask] partially protects you from the acid!</span>"
					remove_self(meltdose / 2)
					return
				else
					MK << "<span class='danger'>Your [MK.wear_mask] melts away!</span>"
					del(MK.wear_mask)
					MK.update_inv_wear_mask(0)
					remove_self(meltdose)
			if(volume <= 0)
				world << "Yep, it's needed"
				return

		if(!M.unacidable)
			if(istype(M, /mob/living/carbon/human) && volume >= meltdose)
				var/mob/living/carbon/human/H = M
				var/datum/organ/external/affecting = H.get_organ("head")
				if(affecting)
					if(affecting.take_damage(removed * power * 2, removed * power))
						H.UpdateDamageIcon()
					if(prob(100 * removed / meltdose)) //Applies disfigurement
						if (!(H.species && (H.species.flags & NO_PAIN)))
							H.emote("scream")
						H.status_flags |= DISFIGURED
			else
				M.take_organ_damage(removed * power * 2, removed * power)

/datum/reagent/toxin/acid/touch_obj(var/obj/O)
	if(O.unacidable)
		return
	if((istype(O, /obj/item) || istype(O, /obj/effect/glowshroom)) && (volume > meltdose))
		var/obj/effect/decal/cleanable/molten_item/I = new/obj/effect/decal/cleanable/molten_item(O.loc)
		I.desc = "Looks like this was \an [O] some time ago."
		for(var/mob/M in viewers(5, O))
			M << "<span class='warning'>\The [O] melts.</span>"
		del(O)
		remove_self(meltdose) // 10 units of acid will not melt EVERYTHING on the tile

/datum/reagent/silicon
	name = "Silicon"
	id = "silicon"
	description = "A tetravalent metalloid, silicon is less reactive than its chemical analog carbon."
	reagent_state = SOLID
	color = "#A8A8A8"

/datum/reagent/sodium
	name = "Sodium"
	id = "sodium"
	description = "A chemical element, readily reacts with water."
	reagent_state = SOLID
	color = "#808080"

/datum/reagent/sugar
	name = "Sugar"
	id = "sugar"
	description = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
	reagent_state = SOLID
	color = "#FFFFFF"
	glass_icon_state = "iceglass"
	glass_name = "glass of sugar"
	glass_desc = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."

/datum/reagent/sugar/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	if(state != CHEM_TOUCH)
		M.nutrition += removed * 3

/datum/reagent/sulfur
	name = "Sulfur"
	id = "sulfur"
	description = "A chemical element with a pungent smell."
	reagent_state = SOLID
	color = "#BF8C00"

/* General medicine */

/datum/reagent/inaprovaline
	name = "Inaprovaline"
	id = "inaprovaline"
	description = "Inaprovaline is a synaptic stimulant and cardiostimulant. Commonly used to stabilize patients."
	reagent_state = LIQUID
	color = "#00BFFF"
	overdose_blood = REAGENTS_OVERDOSE * 2
	overdose_ingest = REAGENTS_OVERDOSE * 4
	metabolism = REM * 0.5
	scannable = 1
	painkiler = 25

/datum/reagent/inaprovaline/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	if(state == CHEM_TOUCH)
		return
	if(alien != IS_DIONA)
		M.add_chemical_effect(CE_STABLE)
		M.add_chemical_effect(CE_PAINKILLER, 25)

/datum/reagent/bicaridine
	name = "Bicaridine"
	id = "bicaridine"
	description = "Bicaridine is an analgesic medication and can be used to treat blunt trauma."
	reagent_state = LIQUID
	color = "#BF0000"
	overdose_blood = REAGENTS_OVERDOSE
	overdose_ingest = REAGENTS_OVERDOSE * 2
	scannable = 1

/datum/reagent/bicaridine/affect_mob(var/mob/living/carbon/M as mob, var/alien, var/removed)
	if(state == CHEM_TOUCH)
		return
	var/effect = (state == CHEM_BLOOD ? 1.5 : 1)
	if(alien != IS_DIONA)
		M.heal_organ_damage(4 * removed * effect, 0)

/datum/reagent/metorapan
	name = "Metorapan"
	id = "metorapan"
	description = "Metorapan is an analgesic medication that is more effective than Bicaridine."
	reagent_state = LIQUID
	color = "#BF3030"
	overdose_blood = REAGENTS_OVERDOSE * 0.5
	overdose_ingest = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/metorapan/affect_mob(var/mob/living/carbon/M as mob, var/alien, var/removed)
	if(state == CHEM_TOUCH)
		return
	var/effect = (state == CHEM_BLOOD ? 1.5 : 1)
	if(alien != IS_DIONA)
		M.heal_organ_damage(8 * removed * effect, 0)

/datum/reagent/kelotane
	name = "Kelotane"
	id = "kelotane"
	description = "Kelotane is a drug used to treat burns."
	reagent_state = LIQUID
	color = "#FFA800"
	overdose_blood = REAGENTS_OVERDOSE
	overdose_ingest = REAGENTS_OVERDOSE * 2
	scannable = 1

/datum/reagent/kelotane/affect_mob(var/mob/living/carbon/M as mob, var/alien, var/removed)
	if(state == CHEM_TOUCH)
		return
	var/effect = (state == CHEM_BLOOD ? 1.5 : 1)
	if(alien != IS_DIONA)
		M.heal_organ_damage(0, 4 * removed * effect)

/datum/reagent/dermaline
	name = "Dermaline"
	id = "dermaline"
	description = "Dermaline is the next step in burn medication. Works twice as good as kelotane and enables the body to restore even the direst heat-damaged tissue."
	reagent_state = LIQUID
	color = "#FF8000"
	overdose_blood = REAGENTS_OVERDOSE * 0.5
	overdose_ingest = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/dermaline/affect_mob(var/mob/living/carbon/M as mob, var/alien, var/removed)
	if(state == CHEM_TOUCH)
		return
	var/effect = (state == CHEM_BLOOD ? 1.5 : 1)
	if(alien != IS_DIONA)
		M.heal_organ_damage(0, 8 * removed * effect)

/datum/reagent/dylovene
	name = "Dylovene"
	id = "dylovene"
	description = "Dylovene is a broad-spectrum antitoxin."
	reagent_state = LIQUID
	color = "#00A000"
	scannable = 1

/datum/reagent/dylovene/affect_mob(var/mob/living/carbon/M as mob, var/alien, var/removed)
	if(state == CHEM_TOUCH)
		return
	var/effect = (state == CHEM_BLOOD ? 1.5 : 1)
	if(alien != IS_DIONA)
		M.drowsyness = max(0, M.drowsyness - 4 * removed * effect)
		M.hallucination = max(0, M.hallucination - 6 * removed * effect)
		M.adjustToxLoss(-4 * removed)

/datum/reagent/dexalin
	name = "Dexalin"
	id = "dexalin"
	description = "Dexalin is used in the treatment of oxygen deprivation."
	reagent_state = LIQUID
	color = "#0080FF"
	overdose_blood = REAGENTS_OVERDOSE
	overdose_ingest = REAGENTS_OVERDOSE * 2
	scannable = 1

/datum/reagent/dexalin/affect_mob(var/mob/living/carbon/M as mob, var/alien, var/removed)
	if(state == CHEM_TOUCH)
		return
	var/effect = (state == CHEM_BLOOD ? 1.5 : 1)
	if(alien == IS_VOX)
		M.adjustToxLoss(removed * 4 * effect)
	else if(alien != IS_DIONA)
		M.adjustOxyLoss(-10 * removed * effect)

	holder.remove_reagent("lexorin", 2 * removed, state)

/datum/reagent/dexalinp
	name = "Dexalin Plus"
	id = "dexalinp"
	description = "Dexalin Plus is used in the treatment of oxygen deprivation. It is highly effective."
	reagent_state = LIQUID
	color = "#0040FF"
	overdose_blood = REAGENTS_OVERDOSE * 0.5
	overdose_ingest = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/dexalin/affect_mob(var/mob/living/carbon/M as mob, var/alien, var/removed)
	if(state == CHEM_TOUCH)
		return
	var/effect = (state == CHEM_BLOOD ? 1.5 : 1)
	if(alien == IS_VOX)
		M.adjustToxLoss(removed * 6 * effect)
	else if(alien != IS_DIONA)
		M.adjustOxyLoss(-200 * removed * effect) // So around 20 per tick under standard settings, should be enough

	holder.remove_reagent("lexorin", 3 * removed, state)

/datum/reagent/tricordrazine
	name = "Tricordrazine"
	id = "tricordrazine"
	description = "Tricordrazine is a highly potent stimulant, originally derived from cordrazine. Can be used to treat a wide range of injuries."
	reagent_state = LIQUID
	color = "#8040FF"
	scannable = 1

/datum/reagent/tricordrazine/affect_mob(var/mob/living/carbon/M as mob, var/alien, var/removed)
	if(state == CHEM_TOUCH)
		return
	var/effect = (state == CHEM_BLOOD ? 1.5 : 1)
	if(alien != IS_DIONA)
		M.adjustOxyLoss(-4 * removed * effect)
		M.heal_organ_damage(2 * removed * effect, 2 * removed * effect)
		M.adjustToxLoss(-2 * removed * effect)

/* Other medicine */

/datum/reagent/spaceacillin
	name = "Spaceacillin"
	id = "spaceacillin"
	description = "An all-purpose antiviral agent."
	reagent_state = LIQUID
	color = "#C1C1C1"
	metabolism = REM * 0.05
	overdose_blood = REAGENTS_OVERDOSE
	overdose_ingest = REAGENTS_OVERDOSE * 2
	scannable = 1

/* Toxins, poisons, venoms, drugs */

/datum/reagent/toxin
	name = "Toxin"
	id = "toxin"
	description = "A toxic chemical."
	reagent_state = LIQUID
	color = "#CF3600"
	metabolism = REM * 0.5
	var/power = 4 // How much damage it deals per unit

/datum/reagent/toxin/affect_mob(var/mob/living/carbon/M as mob, var/alien, var/removed)
	if(state == CHEM_TOUCH)
		return
	var/effect = (state == CHEM_BLOOD ? 1.5 : 1)
	if(power && alien != IS_DIONA) // TODO: liver
		M.adjustToxLoss(power * removed * effect)

/datum/reagent/toxin/fertilizer //Reagents used for plant fertilizers.
	name = "fertilizer"
	id = "fertilizer"
	description = "A chemical mix good for growing plants with."
	reagent_state = LIQUID
	power = 0.5 //It's not THAT poisonous.
	color = "#664330"

/datum/reagent/toxin/fertilizer/eznutrient
	name = "EZ Nutrient"
	id = "eznutrient"

/datum/reagent/toxin/fertilizer/left4zed
	name = "Left-4-Zed"
	id = "left4zed"

/datum/reagent/toxin/fertilizer/robustharvest
	name = "Robust Harvest"
	id = "robustharvest"

/datum/reagent/soporific
	name = "Soporific"
	id = "soporific"
	description = "An effective hypnotic used to treat insomnia."
	reagent_state = LIQUID
	color = "#009CA8" // rgb: 232, 149, 204
	metabolism = REM * 0.5
	overdose_blood = REAGENTS_OVERDOSE
	overdose_ingest = REAGENTS_OVERDOSE * 2

/datum/reagent/soporific/affect_mob(var/mob/living/carbon/M as mob, var/alien, var/removed)
	if(state != CHEM_BLOOD || alien == IS_DIONA)
		return
	if(dose < 1)
		if(dose == metabolism * 2 || prob(5))
			M.emote("yawn")
	else if(dose < 1.5)
		M.eye_blurry = max(M.eye_blurry, 10)
	else if(dose < 5)
		if(prob(50))
			M.Weaken(2)
		M.drowsyness = max(M.drowsyness, 20)
	else
		M.sleeping = max(M.sleeping, 20)
		M.drowsyness = max(M.drowsyness, 60)

/datum/reagent/toxin/chloralhydrate
	name = "Chloral Hydrate"
	id = "chloralhydrate"
	description = "A powerful sedative."
	reagent_state = SOLID
	color = "#000067"
	power = 1
	metabolism = REM * 0.5
	overdose_blood = REAGENTS_OVERDOSE * 0.5
	overdose_ingest = REAGENTS_OVERDOSE

/datum/reagent/toxin/chloralhydrate/affect_mob(var/mob/living/carbon/M as mob, var/alien, var/removed)
	..()
	if(state != CHEM_BLOOD || alien == IS_DIONA)
		return
	if(dose == metabolism)
		M.confused += 2
		M.drowsyness += 2
	else if(dose < 2)
		M.Weaken(30)
		M.eye_blurry = max(M.eye_blurry, 10)
	else
		M.sleeping = max(M.sleeping, 30)

/datum/reagent/space_drugs
	name = "Space drugs"
	id = "space_drugs"
	description = "An illegal chemical compound used as drug."
	reagent_state = LIQUID
	color = "#60A584"
	metabolism = REM * 0.5
	overdose_blood = REAGENTS_OVERDOSE
	overdose_ingest = REAGENTS_OVERDOSE * 2

/datum/reagent/space_drugs/affect_mob(var/mob/living/carbon/M as mob, var/alien, var/removed)
	M.druggy = max(M.druggy, 15)
	if(prob(10) && isturf(M.loc) && !istype(M.loc, /turf/space) && M.canmove && !M.restrained())
		step(M, pick(cardinal))
	if(prob(7))
		M.emote(pick("twitch", "drool", "moan", "giggle"))

/* Food */

/datum/reagent/nutriment
	name = "Nutriment"
	id = "nutriment"
	description = "All the vitamins, minerals, and carbohydrates the body needs in pure form."
	reagent_state = SOLID
	metabolism = REM * 4
	var/nutriment_factor = 30 // Per unit
	var/injectable = 0
	color = "#664330"

/datum/reagent/nutriment/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	if(state == CHEM_TOUCH)
		return
	if(state == CHEM_BLOOD && !injectable)
		M.adjustToxLoss(0.1 * removed)
		return
	M.heal_organ_damage(0.5 * removed, 0)
	M.nutrition += nutriment_factor * removed // For hunger and fatness
	M.add_chemical_effect(CE_BLOODRESTORE, 4 * removed)

/datum/reagent/nutriment/protein // Bad for Skrell!
	name = "animal protein"
	id = "protein"
	color = "#440000"

/datum/reagent/nutriment/protein/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien && alien == IS_SKRELL)
		M.adjustToxLoss(0.5 * removed)
		return
	..()

/datum/reagent/nutriment/sprinkles
	name = "Sprinkles"
	id = "sprinkles"
	description = "Multi-colored little bits of sugar, commonly found on donuts. Loved by cops."
	nutriment_factor = 1
	color = "#FF00FF"

/*if(istype(M, /mob/living/carbon/human) && M.job in list("Security Officer", "Head of Security", "Detective", "Warden")) <- they used to heal security. Leaving the old code there.
	if(!M) M = holder.my_atom
	M.heal_organ_damage(1,1)
	M.nutrition += nutriment_factor
	..()
	return*/

/* Drinks */

/datum/reagent/drink
	name = "Drink"
	id = "drink"
	description = "Uh, some kind of drink."
	reagent_state = LIQUID
	color = "#E78108"
	var/nutrition = 0 // Per unit
	var/adj_dizzy = 0 // Per tick
	var/adj_drowsy = 0
	var/adj_sleepy = 0
	var/adj_temp = 0

/datum/reagent/drink/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	if(state == CHEM_BLOOD)
		M.adjustToxLoss(removed) // Probably not a good idea; not very deadly though
		return
	if(state == CHEM_INGEST)
		M.nutrition += nutrition * removed
		M.dizziness = max(0, M.dizziness + adj_dizzy)
		M.drowsyness = max(0, M.drowsyness + adj_drowsy)
		M.sleeping = max(0, M.sleeping + adj_sleepy)
		if(adj_temp > 0 && M.bodytemperature < 310) // 310 is the normal bodytemp. 310.055
			M.bodytemperature = min(310, M.bodytemperature + (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))
		if(adj_temp < 0 && M.bodytemperature > 310)
			M.bodytemperature = min(310, M.bodytemperature - (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))

// Juices

/datum/reagent/drink/grapejuice
	name = "Grape Juice"
	id = "grapejuice"
	description = "It's grrrrrape!"
	color = "#863333" // rgb: 134, 51, 51

	glass_icon_state = "grapejuice"
	glass_name = "glass of grape juice"
	glass_desc = "It's grrrrrape!"

/datum/reagent/drink/limejuice
	name = "Lime Juice"
	id = "limejuice"
	description = "The sweet-sour juice of limes."
	color = "#365E30" // rgb: 54, 94, 48

	glass_icon_state = "glass_green"
	glass_name = "glass of lime juice"
	glass_desc = "A glass of sweet-sour lime juice"

/datum/reagent/drink/limejuice/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(state == CHEM_TOUCH || state == CHEM_BLOOD || alien == IS_DIONA)
		return
	M.adjustToxLoss(-0.5 * removed)

/datum/reagent/drink/orangejuice
	name = "Orange juice"
	id = "orangejuice"
	description = "Both delicious AND rich in Vitamin C, what more do you need?"
	color = "#E78108"

	glass_icon_state = "glass_orange"
	glass_name = "glass of orange juice"
	glass_desc = "Vitamins! Yay!"

/datum/reagent/drink/orangejuice/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(state == CHEM_TOUCH || state == CHEM_BLOOD || alien == IS_DIONA)
		return
	M.adjustOxyLoss(-2 * removed)

/datum/reagent/drink/tomatojuice
	name = "Tomato Juice"
	id = "tomatojuice"
	description = "Tomatoes made into juice. What a waste of big, juicy tomatoes, huh?"
	color = "#731008"

	glass_icon_state = "glass_red"
	glass_name = "glass of tomato juice"
	glass_desc = "Are you sure this is tomato juice?"

/datum/reagent/drink/tomatojuice/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(state == CHEM_TOUCH || state == CHEM_BLOOD || alien == IS_DIONA)
		return
	M.heal_organ_damage(0, 0.5 * removed)

// Everything else

/datum/reagent/drink/milk
	name = "Milk"
	id = "milk"
	description = "An opaque white liquid produced by the mammary glands of mammals."
	color = "#DFDFDF"

	glass_icon_state = "glass_white"
	glass_name = "glass of milk"
	glass_desc = "White and nutritious goodness!"

/datum/reagent/drink/milk/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(state == CHEM_TOUCH || state == CHEM_BLOOD || alien == IS_DIONA)
		return
	M.heal_organ_damage(0.5 * removed, 0)
	holder.remove_reagent("capsaicin", 10 * removed)

/datum/reagent/drink/milk/cream
	name = "Cream"
	id = "cream"
	description = "The fatty, still liquid part of milk. Why don't you mix this with sum scotch, eh?"
	color = "#DFD7AF"

	glass_icon_state = "glass_white"
	glass_name = "glass of cream"
	glass_desc = "Ewwww..."

/datum/reagent/drink/tea
	name = "Tea"
	id = "tea"
	description = "Tasty black tea, it has antioxidants, it's good for you!"
	color = "#101000"
	adj_dizzy = -2
	adj_drowsy = -1
	adj_sleepy = -3
	adj_temp = 20

	glass_icon_state = "bigteacup"
	glass_name = "cup of tea"
	glass_desc = "Tasty black tea, it has antioxidants, it's good for you!"

/datum/reagent/drink/tea/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(state == CHEM_TOUCH || state == CHEM_BLOOD || alien == IS_DIONA)
		return
	M.adjustToxLoss(-0.5 * removed)

/datum/reagent/drink/tea/icetea
	name = "Iced Tea"
	id = "icetea"
	description = "No relation to a certain rap artist/ actor."
	color = "#104038" // rgb: 16, 64, 56
	adj_temp = -5

	glass_icon_state = "icedteaglass"
	glass_name = "glass of iced tea"
	glass_desc = "No relation to a certain rap artist/ actor."
	glass_center_of_mass = list("x"=15, "y"=10)

/datum/reagent/drink/coffee
	name = "Coffee"
	id = "coffee"
	description = "Coffee is a brewed drink prepared from roasted seeds, commonly called coffee beans, of the coffee plant."
	color = "#482000"
	adj_dizzy = -5
	adj_drowsy = -3
	adj_sleepy = -2
	adj_temp = 25

	glass_icon_state = "hot_coffee"
	glass_name = "cup of coffee"
	glass_desc = "Don't drop it, or you'll send scalding liquid and glass shards everywhere."

/datum/reagent/drink/coffee/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(state == CHEM_TOUCH || state == CHEM_BLOOD || alien == IS_DIONA)
		return
	M.make_jittery(5)
	if(adj_temp > 0)
		holder.remove_reagent("frostoil", 10 * removed)

/datum/reagent/drink/hot_coco
	name = "Hot Chocolate"
	id = "hot_coco"
	description = "Made with love! And cocoa beans."
	reagent_state = LIQUID
	color = "#403010"
	nutrition = 2
	adj_temp = 5

	glass_icon_state = "chocolateglass"
	glass_name = "glass of hot chocolate"
	glass_desc = "Made with love! And cocoa beans."

/datum/reagent/drink/sodawater
	name = "Soda Water"
	id = "sodawater"
	description = "A can of club soda. Why not make a scotch and soda?"
	color = "#619494"
	adj_dizzy = -5
	adj_drowsy = -3
	adj_temp = -5

	glass_icon_state = "glass_clear"
	glass_name = "glass of soda water"
	glass_desc = "Soda water. Why not make a scotch and soda?"

/datum/reagent/drink/tonic
	name = "Tonic Water"
	id = "tonic"
	description = "It tastes strange but at least the quinine keeps the Space Malaria at bay."
	color = "#664300"
	adj_dizzy = -5
	adj_drowsy = -3
	adj_sleepy = -2
	adj_temp = -5

	glass_icon_state = "glass_clear"
	glass_name = "glass of tonic water"
	glass_desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."

/datum/reagent/drink/grenadine
	name = "Grenadine Syrup"
	id = "grenadine"
	description = "Made in the modern day with proper pomegranate substitute. Who uses real fruit, anyways?"
	color = "#FF004F"

	glass_icon_state = "grenadineglass"
	glass_name = "glass of grenadine syrup"
	glass_desc = "Sweet and tangy, a bar syrup used to add color or flavor to drinks."
	glass_center_of_mass = list("x"=17, "y"=6)

/datum/reagent/drink/space_cola
	name = "Space Cola"
	id = "cola"
	description = "A refreshing beverage."
	reagent_state = LIQUID
	color = "#100800"
	adj_drowsy = -3
	adj_temp = -5

	glass_icon_state  = "glass_brown"
	glass_name = "glass of Space Cola"
	glass_desc = "A glass of refreshing Space Cola"

/datum/reagent/drink/spacemountainwind
	name = "Mountain Wind"
	id = "spacemountainwind"
	description = "Blows right through you like a space wind."
	color = "#102000"
	adj_drowsy = -7
	adj_sleepy = -1
	adj_temp = -5

	glass_icon_state = "Space_mountain_wind_glass"
	glass_name = "glass of Space Mountain Wind"
	glass_desc = "Space Mountain Wind. As you know, there are no mountains in space, only wind."

/datum/reagent/drink/dr_gibb
	name = "Dr. Gibb"
	id = "dr_gibb"
	description = "A delicious blend of 42 different flavours"
	color = "#102000"
	adj_drowsy = -6
	adj_temp = -5

	glass_icon_state = "dr_gibb_glass"
	glass_name = "glass of Dr. Gibb"
	glass_desc = "Dr. Gibb. Not as dangerous as the name might imply."

/datum/reagent/drink/space_up
	name = "Space-Up"
	id = "space_up"
	description = "Tastes like a hull breach in your mouth."
	color = "#202800"
	adj_temp = -8

	glass_icon_state = "space-up_glass"
	glass_name = "glass of Space-up"
	glass_desc = "Space-up. It helps keep your cool."

/datum/reagent/drink/lemon_lime
	name = "Lemon Lime"
	description = "A tangy substance made of 0.5% natural citrus!"
	id = "lemon_lime"
	color = "#878F00"
	adj_temp = -8

	glass_icon_state = "lemonlime"
	glass_name = "glass of lemon lime soda"
	glass_desc = "A tangy substance made of 0.5% natural citrus!"

/datum/reagent/drink/doctor_delight
	name = "The Doctor's Delight"
	id = "doctorsdelight"
	description = "A gulp a day keeps the MediBot away. That's probably for the best."
	reagent_state = LIQUID
	color = "#FF8CFF"
	nutrition = 1

	glass_icon_state = "doctorsdelightglass"
	glass_name = "glass of The Doctor's Delight"
	glass_desc = "A healthy mixture of juices, guaranteed to keep you healthy until the next toolboxing takes place."
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/drink/doctor_delight/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(state == CHEM_TOUCH || state == CHEM_BLOOD || alien == IS_DIONA)
		return
	M.adjustOxyLoss(-4 * removed)
	M.heal_organ_damage(2 * removed, 2 * removed)
	M.adjustToxLoss(-2 * removed)
	if(M.dizziness) 
		M.dizziness = max(0, M.dizziness - 15)
	if(M.confused)
		M.confused = max(0, M.confused - 5)

/datum/reagent/drink/dry_ramen
	name = "Dry Ramen"
	id = "dry_ramen"
	description = "Space age food, since August 25, 1958. Contains dried noodles, vegetables, and chemicals that boil in contact with water."
	reagent_state = SOLID
	nutrition = 1
	color = "#302000"

/datum/reagent/drink/hot_ramen
	name = "Hot Ramen"
	id = "hot_ramen"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	reagent_state = LIQUID
	color = "#302000"
	nutrition = 5
	adj_temp = 5

/datum/reagent/drink/hell_ramen
	name = "Hell Ramen"
	id = "hell_ramen"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	reagent_state = LIQUID
	color = "#302000"
	nutrition = 5

/datum/reagent/drink/hell_ramen/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(state == CHEM_TOUCH || state == CHEM_BLOOD || alien == IS_DIONA)
		return
	M.bodytemperature += 10 * TEMPERATURE_DAMAGE_COEFFICIENT

/datum/reagent/drink/ice
	name = "Ice"
	id = "ice"
	description = "Frozen water, your dentist wouldn't like you chewing this."
	reagent_state = SOLID
	color = "#619494"
	adj_temp = -5

	glass_icon_state = "iceglass"
	glass_name = "glass of ice"
	glass_desc = "Generally, you're supposed to put something else in there too..."

/* Alcohol */

// Basic

/datum/reagent/ethanol/absinthe
	name = "Absinthe"
	id = "absinthe"
	description = "Watch out that the Green Fairy doesn't come for you!"
	color = "#33EE00"
	strength = 12

	glass_icon_state = "absintheglass"
	glass_name = "glass of absinthe"
	glass_desc = "Wormwood, anise, oh my."
	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/ethanol/ale
	name = "Ale"
	id = "ale"
	description = "A dark alchoholic beverage made by malted barley and yeast."
	color = "#664300"
	strength = 50

	glass_icon_state = "aleglass"
	glass_name = "glass of ale"
	glass_desc = "A freezing pint of delicious ale"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/beer
	name = "Beer"
	id = "beer"
	description = "An alcoholic beverage made from malted grains, hops, yeast, and water."
	color = "#664300"
	strength = 50
	nutriment_factor = 1

	glass_icon_state = "beerglass"
	glass_name = "glass of beer"
	glass_desc = "A freezing pint of beer"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/beer/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(state == CHEM_TOUCH || state == CHEM_BLOOD || alien == IS_DIONA)
		return
	M.jitteriness = max(M.jitteriness - 3, 0)

/datum/reagent/ethanol/bluecuracao
	name = "Blue Curacao"
	id = "bluecuracao"
	description = "Exotically blue, fruity drink, distilled from oranges."
	color = "#0000CD"
	strength = 15

	glass_icon_state = "curacaoglass"
	glass_name = "glass of blue curacao"
	glass_desc = "Exotically blue, fruity drink, distilled from oranges."
	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/ethanol/cognac
	name = "Cognac"
	id = "cognac"
	description = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing. Classy as fornication."
	color = "#AB3C05"
	strength = 15

	glass_icon_state = "cognacglass"
	glass_name = "glass of cognac"
	glass_desc = "Damn, you feel like some kind of French aristocrat just by holding this."
	glass_center_of_mass = list("x"=16, "y"=6)

/datum/reagent/ethanol/deadrum
	name = "Deadrum"
	id = "deadrum"
	description = "Popular with the sailors. Not very popular with everyone else."
	color = "#664300"
	strength = 50

	glass_icon_state = "rumglass"
	glass_name = "glass of rum"
	glass_desc = "Now you want to Pray for a pirate suit, don't you?"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/deadrum/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(state == CHEM_TOUCH || state == CHEM_BLOOD || alien == IS_DIONA)
		return
	M.dizziness +=5

/datum/reagent/ethanol/gin
	name = "Gin"
	id = "gin"
	description = "It's gin. In space. I say, good sir."
	color = "#664300"
	strength = 50

	glass_icon_state = "ginvodkaglass"
	glass_name = "glass of gin"
	glass_desc = "A crystal clear glass of Griffeater gin."
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/kahlua
	name = "Kahlua"
	id = "kahlua"
	description = "A widely known, Mexican coffee-flavoured liqueur. In production since 1936!"
	color = "#664300"
	strength = 15

	glass_icon_state = "kahluaglass"
	glass_name = "glass of RR coffee liquor"
	glass_desc = "DAMN, THIS THING LOOKS ROBUST"
	glass_center_of_mass = list("x"=15, "y"=7)

/datum/reagent/ethanol/kahlua/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(state == CHEM_TOUCH || state == CHEM_BLOOD || alien == IS_DIONA)
		return
	M.dizziness = max(0, M.dizziness - 5)
	M.drowsyness = max(0, M.drowsyness - 3)
	M.sleeping = max(0, M.sleeping - 2)
	if (M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
	M.make_jittery(5)

/datum/reagent/ethanol/melonliquor
	name = "Melon Liquor"
	id = "melonliquor"
	description = "A relatively sweet and fruity 46 proof liquor."
	color = "#138808" // rgb: 19, 136, 8
	strength = 50

	glass_icon_state = "emeraldglass"
	glass_name = "glass of melon liquor"
	glass_desc = "A relatively sweet and fruity 46 proof liquor."
	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/ethanol/rum
	name = "Rum"
	id = "rum"
	description = "Yohoho and all that."
	color = "#664300"
	strength = 15

	glass_icon_state = "rumglass"
	glass_name = "glass of rum"
	glass_desc = "Now you want to Pray for a pirate suit, don't you?"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/tequilla
	name = "Tequila"
	id = "tequilla"
	description = "A strong and mildly flavoured, mexican produced spirit. Feeling thirsty hombre?"
	color = "#FFFF91"
	strength = 25

	glass_icon_state = "tequillaglass"
	glass_name = "glass of Tequilla"
	glass_desc = "Now all that's missing is the weird colored shades!"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/thirteenloko
	name = "Thirteen Loko"
	id = "thirteenloko"
	description = "A potent mixture of caffeine and alcohol."
	color = "#102000"
	strength = 25
	nutriment_factor = 1

	glass_icon_state = "thirteen_loko_glass"
	glass_name = "glass of Thirteen Loko"
	glass_desc = "This is a glass of Thirteen Loko, it appears to be of the highest quality. The drink, not the glass."

/datum/reagent/ethanol/thirteenloko/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(state == CHEM_TOUCH || state == CHEM_BLOOD || alien == IS_DIONA)
		return
	M.drowsyness = max(0, M.drowsyness - 7)
	if (M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
	M.make_jittery(5)

/datum/reagent/ethanol/vermouth
	name = "Vermouth"
	id = "vermouth"
	description = "You suddenly feel a craving for a martini..."
	color = "#91FF91" // rgb: 145, 255, 145
	strength = 15

	glass_icon_state = "vermouthglass"
	glass_name = "glass of vermouth"
	glass_desc = "You wonder why you're even drinking this straight."
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/vodka
	name = "Vodka"
	id = "vodka"
	description = "Number one drink AND fueling choice for Russians worldwide."
	color = "#0064C8" // rgb: 0, 100, 200
	strength = 15

	glass_icon_state = "ginvodkaglass"
	glass_name = "glass of vodka"
	glass_desc = "The glass contain wodka. Xynta."
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/vodka/on_mob_life(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.radiation = max(M.radiation - 1 * removed, 0)

/datum/reagent/ethanol/whiskey
	name = "Whiskey"
	id = "whiskey"
	description = "A superb and well-aged single-malt whiskey. Damn."
	color = "#664300"
	strength = 25

	glass_icon_state = "whiskeyglass"
	glass_name = "glass of whiskey"
	glass_desc = "The silky, smokey whiskey goodness inside the glass makes the drink look very classy."
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/wine
	name = "Wine"
	id = "wine"
	description = "An premium alchoholic beverage made from distilled grape juice."
	color = "#7E4043" // rgb: 126, 64, 67
	strength = 15

	glass_icon_state = "wineglass"
	glass_name = "glass of wine"
	glass_desc = "A very classy looking drink."
	glass_center_of_mass = list("x"=15, "y"=7)

// Cocktails

/datum/reagent/ethanol/bananahonk
	name = "Banana Mama"
	id = "bananahonk"
	description = "A drink from Clown Heaven."
	nutriment_factor = 1
	color = "#FFFF91"
	boozepwr = 12

	glass_icon_state = "bananahonkglass"
	glass_name = "glass of Banana Honk"
	glass_desc = "A drink from Banana Heaven."
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/driestmartini
	name = "Driest Martini"
	id = "driestmartini"
	description = "Only for the experienced. You think you see sand floating in the glass."
	nutriment_factor = 1
	color = "#2E6671"
	boozepwr = 12

	glass_icon_state = "driestmartiniglass"
	glass_name = "glass of Driest Martini"
	glass_desc = "Only for the experienced. You think you see sand floating in the glass."
	glass_center_of_mass = list("x"=17, "y"=8)

/* Things that didn't fit anywhere else */

/datum/reagent/water/holywater
	name = "Holy Water"
	id = "holywater"
	description = "An ashen-obsidian-water mix, this solution will alter certain sections of the brain's rationality."
	color = "#E0E8EF" // rgb: 224, 232, 239

	glass_icon_state = "glass_clear"
	glass_name = "glass of holy water"
	glass_desc = "An ashen-obsidian-water mix, this solution will alter certain sections of the brain's rationality."

/datum/reagent/water/holywater/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(ishuman(M)) // Any state
		if((M.mind in ticker.mode.cult) && prob(10))
			ticker.mode.remove_cultist(M.mind)
			M.visible_message("<span class='notice'>[M]'s eyes blink and become clearer.", "<span class='notice'>A cooling sensation from inside you brings you an untold calmness.</notice>")

/datum/reagent/paint // TODO
	name = "Paint"
	id = "paint"
	description = "This paint will stick to almost any object."
	reagent_state = LIQUID
	color = "#808080"

/datum/reagent/ammonia
	name = "Ammonia"
	id = "ammonia"
	description = "A caustic substance commonly used in fertilizer or household cleaners."
	reagent_state = GAS
	color = "#404030"

/datum/reagent/diethylamine
	name = "Diethylamine"
	id = "diethylamine"
	description = "A secondary amine, mildly corrosive."
	reagent_state = LIQUID
	color = "#604030"

/datum/reagent/ultraglue
	name = "Ultra Glue"
	id = "glue"
	description = "An extremely powerful bonding agent."
	color = "#FFFFCC"