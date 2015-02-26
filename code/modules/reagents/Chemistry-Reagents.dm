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
	var/list/filtering_organs = null // These organs help in chemical removal if they are working
	var/list/filtering_speed = null
	var/dose = 0
	var/max_dose = 0
	var/overdose = 0
	var/addictive = 0
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

/datum/reagent/proc/touch_obj(var/obj/O) // Cleaner cleaning, lube lubbing, etc, all go here
	return

/datum/reagent/proc/touch_turf(var/turf/T) // Acid melting, cleaner cleaning, etc
	return

/datum/reagent/proc/on_mob_life(var/mob/living/carbon/M, var/alien) // Currently, on_mob_life is called on carbons. Any interaction with non-carbon mobs (lube) will need to be done in touch_mob.
	if(!istype(M))
		return
	if(!affects_dead && M.stat == DEAD)
		return
	if(overdose && (((state == CHEM_BLOOD) && (volume > overdose)) || ((state == CHEM_INGEST) && (volume > overdose * 2))))
		overdose(M, alien) // Swallowing gives smaller effects, but is harder to overdose.
	var/removed = metabolism
	if(state == CHEM_TOUCH)
		removed *= 2
	if(state == CHEM_INGEST)
		removed *= 3
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
						return
					if(O.is_bruised())
						remove_self(filtering_speed[i] * 0.5)
						bruised_organ(M, alien, removed, name)
						return
					remove_self(filtering_speed[i])
				else
					if(M.species.has_organ[name]) // Let's not kill dionae for not having a liver
						missing_organ(M, alien, removed, name)
					else
						no_organ(M, alien, removed, name)
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
	color = "#0064C8"

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

/datum/reagent/ethanol // TODO
	name = "Ethanol" //Parent class for all alcoholic reagents.
	id = "ethanol"
	description = "A well-known alcohol with a variety of applications."
	reagent_state = LIQUID
	color = "#404030"
	filtering_organs = list("liver")
	filtering_speed = list(REM)
	var/nutriment_factor = 0
	var/dizzy_start = 0			// Dose, in units, after which mob gets dizzy
	var/dizzy_add = 3			// How much dizziness per tick
	var/drowsy_start = 0		// Ditto, drowsyness
	var/drowsy_add = 0
	var/slurr_start = 40		// Ditto
	var/slurr_add = 3
	var/confused_start = 50
	var/confused_add = 2
	var/blur_start = 60
	var/toxic_dose = 70
	var/toxicity = 1
	var/pass_out = 80

	glass_icon_state = "glass_clear"
	glass_name = "glass of ethanol"
	glass_desc = "A well-known alcohol with a variety of applications."

/datum/reagent/ethanol/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	if(state == CHEM_TOUCH)
		M.adjust_fire_stacks(removed / 15)
		return
	if(state == CHEM_BLOOD)
		M.adjustToxLoss(removed * 2)
		return
	M.nutrition += nutriment_factor * removed

	var/strength_mod = 1
	if(alien == IS_SKRELL)
		strength_mod *= 5
	if(alien == IS_DIONA)
		strength_mod = 0

	if(dose / strength_mod >= dizzy_start)
		M.make_dizzy(dizzy_add)
	if(dose / strength_mod >= drowsy_start)
		M.drowsyness += drowsy_add
	if(dose / strength_mod >= slurr_start)
		M.slurring += slurr_add
	if(dose / strength_mod >= confused_start)
		M.confused += confused_add
	if(dose / strength_mod >= blur_start)
		M.eye_blurry = max(M.eye_blurry, 10)
	if(dose / strength_mod >= toxic_dose)
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
	if(dose / strength_mod >= pass_out)
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
		M.chem_effects.Add("Iron")

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
	overdose = REAGENTS_OVERDOSE * 2
	metabolism = REM * 0.5
	scannable = 1
	painkiler = 25

/datum/reagent/inaprovaline/affect_mob(var/mob/living/carbon/M, var/alien, var/removed)
	if(state == CHEM_TOUCH)
		return
	if(alien != IS_DIONA)
		M.chem_effects.Add("Nocrit")

/datum/reagent/bicaridine
	name = "Bicaridine"
	id = "bicaridine"
	description = "Bicaridine is an analgesic medication and can be used to treat blunt trauma."
	reagent_state = LIQUID
	color = "#BF0000"
	overdose = REAGENTS_OVERDOSE
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
	overdose = REAGENTS_OVERDOSE
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
	overdose = REAGENTS_OVERDOSE
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
	overdose = REAGENTS_OVERDOSE / 2
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
	overdose = REAGENTS_OVERDOSE
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
	overdose = REAGENTS_OVERDOSE/2
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

/datum/reagent/soporific
	name = "Soporific"
	id = "soporific"
	description = "An effective hypnotic used to treat insomnia."
	reagent_state = LIQUID
	color = "#009CA8" // rgb: 232, 149, 204
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE

/datum/reagent/soporific/affect_mob(var/mob/living/carbon/M as mob, var/alien, var/removed)
	if(state != CHEM_BLOOD || alien == IS_DIONA)
		return
	if(dose < 1)
		if(prob(5))
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

/datum/reagent/space_drugs
	name = "Space drugs"
	id = "space_drugs"
	description = "An illegal chemical compound used as drug."
	reagent_state = LIQUID
	color = "#60A584"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE

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
	M.nutrition += nutriment_factor // For hunger and fatness

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
	M.adjustToxLoss(-0.5 * removed)
	return

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

/* Alcohol */

/* Things that didn't fit anywhere else */

/datum/reagent/paint // TODO
	name = "Paint"
	id = "paint"
	description = "This paint will stick to almost any object."
	reagent_state = LIQUID
	color = "#808080"