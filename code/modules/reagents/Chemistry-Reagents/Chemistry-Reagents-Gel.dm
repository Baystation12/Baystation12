////////////////////////////////////////////////////////////////////////////////
/// Gel
////////////////////////////////////////////////////////////////////////////////

/* Medicine */

//TODO - "make reagent_state actually do shit ~ Ravensdale"

/datum/reagent/gel
	name = "gel"
	id = "useless_gel"
	description = "Looks like petroleum jelly."
	taste_description = "lubricant"
	taste_mult = 3
	reagent_state = GEL
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	var/strength = 4
	var/target_organ

/datum/reagent/gel/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(strength && alien != IS_DIONA)
		M.add_chemical_effect(CE_TOXIN, strength)
		var/dam = (strength * removed)
		if(target_organ && ishuman(M))
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/internal/I = H.internal_organs_by_name[target_organ]
			if(I)
				var/can_damage = I.max_damage - I.damage
				if(can_damage > 0)
					if(dam > can_damage)
						I.take_damage(can_damage, silent=TRUE)
						dam -= can_damage
					else
						I.take_damage(dam, silent=TRUE)
						dam = 0
		if(dam)
			M.adjustToxLoss(target_organ ? (dam * 0.75) : dam)

/*	Gel Meds	*/

/datum/reagent/gel/inaprovaline
	name = "Inaprovaline gel"
	id = "inaprovaline_gel"
	description = "Inaprovaline is a multipurpose neurostimulant and cardioregulator. Commonly used to slow bleeding and stabilize patients. This dose comes in gel form."
	color = "#0083C3"
	overdose = null

/datum/reagent/gel/inaprovaline/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.add_chemical_effect(CE_STABLE)
		M.add_chemical_effect(CE_PAINKILLER, 10)
	M.add_chemical_effect(CE_PULSE, -1)

/datum/reagent/gel/bicaridine
	name = "Bicaridine gel"
	id = "bicaridine_gel"
	description = "Bicaridine is an analgesic medication and can be used to treat blunt trauma. This dose comes in gel form."
	color = "#830000"

/datum/reagent/gel/bicaridine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	M.heal_organ_damage(6 * removed, 0)

/datum/reagent/gel/kelotane
	name = "Kelotane gel"
	id = "kelotane_gel"
	description = "Kelotane is a drug used to treat burns. This dose comes in gel form."
	color = "#C36C00"

/datum/reagent/gel/kelotane/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.heal_organ_damage(0, 6 * removed)

/datum/reagent/gel/dermaline
	name = "Dermaline gel"
	id = "dermaline_gel"
	description = "Dermaline is the next step in burn medication. Works twice as good as kelotane and enables the body to restore even the direst heat-damaged tissue. This dose comes in gel form."
	color = "#C36C00"
	overdose = REAGENTS_OVERDOSE * 0.5

/datum/reagent/gel/dermaline/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.heal_organ_damage(0, 12 * removed)

/datum/reagent/gel/dylovene
	name = "Dylovene gel"
	id = "dylovene_gel"
	description = "Dylovene is a broad-spectrum antitoxin used to neutralize poisons before they can do significant harm. This dose comes in a gel form."
	color = "#006400"

/datum/reagent/gel/dylovene/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.drowsyness = max(0, M.drowsyness - 6 * removed)
	M.hallucination = max(0, M.hallucination - 9 * removed)
	M.add_chemical_effect(CE_ANTITOX, 1)

/*/datum/reagent/gel/dylovenep
	name = "Dylovene Plus gel"
	id = "dylovenep_gel"
	description = "Dylovene Plus is a concentrated anti-toxin to neutralize poisons and assist organ filtration and recovery. This dose comes in gel form"
	color = "#001E00"
	overdose = REAGENTS_OVERDOSE * 0.5

/datum/reagent/gel/dylovenep/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.drowsyness = max(0, M.drowsyness - 9 * removed)
	M.hallucination = max(0, M.hallucination - 12 * removed)
	M.add_chemical_effect(CE_ANTITOX, 2)

	M.radiation = max(M.radiation - 20 * removed, 0)

	var/removing = (6 * removed)
	for(var/datum/reagent/R in M.ingested.reagent_list)
		if(istype(R, /datum/reagent/toxin) || (R.id in remove_toxins))
			M.ingested.remove_reagent(R.id, removing)
			return
	for(var/datum/reagent/R in M.reagents.reagent_list)
		if(istype(R, /datum/reagent/toxin) || (R.id in remove_toxins))
			M.reagents.remove_reagent(R.id, removing)
			return
*/
/datum/reagent/gel/dexalin
	name = "Dexalin gel"
	id = "dexalin_gel"
	description = "Dexalin is used in the treatment of oxygen deprivation. This dose comes in gel form."
	color = "#0044C3"

/datum/reagent/gel/dexalin/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_VOX)
		M.adjustToxLoss(removed * 6)
	else if(alien != IS_DIONA)
		M.add_chemical_effect(CE_OXYGENATED, 1)
	holder.remove_reagent("lexorin", 2 * removed)

/datum/reagent/gel/dexalinp
	name = "Dexalin Plus gel"
	id = "dexalinp_gel"
	description = "Dexalin Plus is used in the treatment of oxygen deprivation. It is highly effective. This dose comes in gel form."
	color = "#0004c3"
	overdose = REAGENTS_OVERDOSE * 0.5

/datum/reagent/gel/dexalinp/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_VOX)
		M.adjustToxLoss(removed * 9)
	else if(alien != IS_DIONA)
		M.add_chemical_effect(CE_OXYGENATED, 2)
	holder.remove_reagent("lexorin", 3 * removed)

/datum/reagent/gel/tricordrazine
	name = "Tricordrazine gel"
	id = "tricordrazine_gel"
	description = "Tricordrazine is a highly potent stimulant, originally derived from cordrazine. Can be used to treat a wide range of injuries. This dose comes in gel form."
	color = "#4404C3"

/datum/reagent/gel/tricordrazine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.heal_organ_damage(3 * removed, 3 * removed)

/* Gel Misc Meds */

/datum/reagent/gel/hyperzine
	name = "Hyperzine gel"
	id = "hyperzine_gel"
	description = "Hyperzine is a highly effective, long lasting, muscle stimulant. This dose comes in gel form."
	color = "#FF3300"
	metabolism = REM * 0.15
	overdose = REAGENTS_OVERDOSE * 0.5

/datum/reagent/gel/hyperzine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(prob(5))
		M.emote(pick("twitch", "blink_r", "shiver"))
	M.add_chemical_effect(CE_SPEEDBOOST, 1)
	M.add_chemical_effect(CE_PULSE, 2)

/datum/reagent/gel/hyronalin
	name = "Hyronalin gel"
	id = "hyronalin_gel"
	description = "Hyronalin is a medicinal drug used to counter the effect of radiation poisoning. This dose comes in gel form."
	color = "#044400"
	metabolism = REM * 0.25

/datum/reagent/gel/hyronalin/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	M.radiation = max(M.radiation - 30 * removed, 0)

/datum/reagent/gel/arithrazine
	name = "Arithrazine gel"
	id = "arithrazine_gel"
	description = "Arithrazine is an unstable medication used for the most extreme cases of radiation poisoning. This dose comes in gel form."
	color = "#004400"
	metabolism = REM * 0.25

/datum/reagent/gel/arithrazine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	M.radiation = max(M.radiation - 70 * removed, 0)
	M.adjustToxLoss(-10 * removed)
	if(prob(60))
		M.take_organ_damage(4 * removed, 0)

/datum/reagent/gel/leporazine
	name = "Leporazine gel"
	id = "leporazine_gel"
	description = "Leporazine can be use to stabilize an individuals body temperature. This dose comes in gel form."
	color = "#7869A0"

/datum/reagent/gel/leporazine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (40 * TEMPERATURE_DAMAGE_COEFFICIENT))
	else if(M.bodytemperature < 311)
		M.bodytemperature = min(310, M.bodytemperature + (40 * TEMPERATURE_DAMAGE_COEFFICIENT))

/datum/reagent/gel/rezadone
	name = "Rezadone gel"
	id = "rezadone_gel"
	description = "A gel imbued with the power of cosmic fish, this substance can effectively treat genetic damage in humanoids, though excessive consumption has side effects."
	color = "#2A5D00"

/datum/reagent/gel/rezadone/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustCloneLoss(-20 * removed)
	M.adjustOxyLoss(-2 * removed)
	M.heal_organ_damage(20 * removed, 20 * removed)
	M.adjustToxLoss(-20 * removed)
	if(dose > 3 && ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/external/E in H.organs)
			E.disfigured = 1 //currently only matters for the head, but might as well disfigure them all.
	if(dose > 10)
		M.make_dizzy(5)
		M.make_jittery(5)

/datum/reagent/gel/noexcutite
	name = "Noexcutite gel"
	id = "noexcutite_gel"
	description = "A honey-like gel that has a lethargic effect. Used to cure cases of jitteriness."
	color = "#80004E"

/datum/reagent/gel/noexcutite/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.make_jittery(-50)

/*	Gel Toxins */

/datum/reagent/gel/phoron
	name = "Jellied Phoron"
	id = "phoron_gel"
	description = "Phoron in a semi-solid state. Extremely combustible."
	taste_mult = 1.5
	color = "#FF0A64"
	strength = 30
	touch_met = 5
	var/fire_mult = 15
	taste_description = "pure poison"

/datum/reagent/gel/phoron/touch_mob(var/mob/living/L, var/amount)
	if(istype(L))
		L.adjust_fire_stacks(amount / fire_mult)

/datum/reagent/gel/phoron/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	M.take_organ_damage(0, removed * 0.5) //Getting touched by concentrated phoron causes burns.
	if(prob(20 * fire_mult))
		M.pl_effects()

/datum/reagent/gel/phoron/touch_turf(var/turf/simulated/T)
	if(!istype(T))
		return
	T.assume_gas("phoron", volume, T20C)
	remove_self(volume)

/datum/reagent/gel/slimejelly
	name = "Jellied Slime"
	id = "slimejelly_gel"
	description = "Just like grandmammy used to make."
	taste_description = "concetrated slime"
	taste_mult = 1.3
	reagent_state = LIQUID
	color = "#801E28"

/datum/reagent/slimejelly/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(prob(10))
		to_chat(M, "<span class='notice'>You think you just felt something move inside you.</span>")