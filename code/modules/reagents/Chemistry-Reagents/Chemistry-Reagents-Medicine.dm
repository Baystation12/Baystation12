/* General medicine */

/datum/reagent/inaprovaline
	name = "Inaprovaline"
	id = "inaprovaline"
	description = "Inaprovaline is a synaptic stimulant and cardiostimulant. Commonly used to stabilize patients."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#00BFFF"
	overdose = REAGENTS_OVERDOSE * 2
	metabolism = REM * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/inaprovaline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.add_chemical_effect(CE_STABLE, 20)
		M.add_chemical_effect(CE_PAINKILLER, 10)
		M.adjustOxyLoss(-5 * removed)
		M.add_chemical_effect(CE_PULSE, 1)

/datum/reagent/chloromydride
	name = "Chloromydride"
	id = "chloromydride"
	description = "Chloromydride is similar to inaprovaline and mildly improves blood oxygenation levels. May cause hypertension."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#006080"
	overdose = REAGENTS_OVERDOSE
	metabolism = REM * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/chloromydride/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.add_chemical_effect(CE_STABLE, 40)
		M.adjustOxyLoss(-8 * removed) //flat rate, heals oxloss slower than dexalin, but without the side effects
		M.add_chemical_effect(CE_PULSE, 3)

/datum/reagent/bicaridine
	name = "Bicaridine"
	id = "bicaridine"
	description = "Bicaridine is an analgesic medication and can be used to treat blunt trauma. Ineffective for mild injuries."
	taste_description = "bitterness"
	taste_mult = 3
	reagent_state = LIQUID
	color = "#BF0000"
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/bicaridine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.heal_organ_damage(sqrt(M.getBruteLoss()) * 0.6 * removed, 0)
		apply_fatigue_effect(M, removed, 0, 10, 10, 20, 10)


/datum/reagent/metorapan
	name = "Metorapan"
	id = "metorapan"
	description = "Metorapan is an weak bicaridine substitute and can be used to treat minor trauma. Ineffective for severe injuries."
	taste_description = "bitterness"
	taste_mult = 3
	reagent_state = LIQUID
	color = "#FFB3B3"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/metorapan/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.heal_organ_damage(15 / (sqrt(M.getBruteLoss()) +  1) * removed, 0)
		apply_fatigue_effect(M, removed, 0, 10, 10, 10, 5)

/datum/reagent/kelotane
	name = "Kelotane"
	id = "kelotane"
	description = "Kelotane is a drug used to treat minor burns."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#FFA800"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/kelotane/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.heal_organ_damage(0, 15 / (sqrt(M.getFireLoss()) +  1) * removed)
		apply_fatigue_effect(M, removed, 0, 10, 10, 10, 5)

/datum/reagent/dermaline
	name = "Dermaline"
	id = "dermaline"
	description = "Dermaline is the next step in burn medication above kelotane. Ineffective for minor burns."
	taste_description = "bitterness"
	taste_mult = 1.5
	reagent_state = LIQUID
	color = "#FF8000"
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/dermaline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.heal_organ_damage(0, sqrt(M.getFireLoss()) * 0.6 * removed)
		apply_fatigue_effect(M, removed, 0, 10, 10, 20, 10)

/datum/reagent/dylovene
	name = "Dylovene"
	id = "anti_toxin"
	description = "Dylovene is a broad-spectrum antitoxin effective against moderate poisoning."
	taste_description = "a roll of gauze"
	reagent_state = LIQUID
	color = "#00A000"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/dylovene/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.adjustToxLoss(sqrt(M.getToxLoss()) * -0.5 * removed)
		apply_fatigue_effect(M, removed, 0, 10, 10, 10, 5)

/datum/reagent/charcoal
	name = "Activated Charcoal"
	id = "charcoal"
	description = "Activated charcoal is a medication used to treat mild poisoning. Oral administration only." //shouldn't treat injected poisons but whatever
	taste_description = "ash"
	reagent_state = LIQUID
	color = "#333333"
	overdose = REAGENTS_OVERDOSE * 2
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/charcoal/affect_blood(var/mob/living/carbon/M, var/alien, var/removed) //why are you trying to inject black shit into your blood?
	if(alien != IS_DIONA)
		M.adjustToxLoss(2 * removed)

/datum/reagent/charcoal/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.adjustToxLoss(-2.5 * removed)
		if(M.ingested && M.ingested.reagent_list.len > 1)
			var/effect = 1 / (M.ingested.reagent_list.len - 1)
			for(var/datum/reagent/R in M.ingested.reagent_list)
				if(R == src)
					continue
				M.ingested.remove_reagent(R.id, removed * effect)

/datum/reagent/polyglobulin
	name = "Polyglobulin"
	id = "polyglobulin"
	description = "Polyglobulin is a very effective toxin inhibitor used to treat severe poisoning and illnesses. May decrease blood oxygen levels."
	taste_description = "putrid mucus"
	reagent_state = LIQUID
	color = "#E6FFE6"
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/polyglobulin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.adjustToxLoss(sqrt(M.getToxLoss()) * -3 * removed)
		M.adjustOxyLoss(removed * 2)
		apply_fatigue_effect(M, removed, 0, 10, 10, 20, 10)

/datum/reagent/dexalin
	name = "Dexalin"
	id = "dexalin"
	description = "Dexalin is used in treating acute oxygen deprivation. Also binds with and neutralizes lexorin."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#0080FF"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/dexalin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		holder.remove_reagent("lexorin", 3 * removed) //yes, it works for vox too
		if(alien == IS_VOX)
			M.adjustToxLoss(removed * 6)
			return
		M.adjustOxyLoss(sqrt(M.getOxyLoss()) * -10 * removed)
		apply_fatigue_effect(M, removed, 0, 10, 10, 20, 10)
		M.take_organ_damage(removed * 2, 0)

/datum/reagent/dexalinp
	name = "Dexalin Plus"
	id = "dexalinp"
	description = "Dexalin Plus is a highly concentrated form of dexalin."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#0040FF"
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/dexalinp/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		holder.remove_reagent("lexorin", 6 * removed)
		if(alien == IS_VOX)
			M.adjustToxLoss(removed * 9)
			return
		M.adjustOxyLoss(sqrt(M.getOxyLoss()) * -20 * removed)
		apply_fatigue_effect(M, removed, 0, 10, 10, 30, 15)
		M.take_organ_damage(removed * 4, 0)
		if(dose > 10)
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				for(var/obj/item/organ/I in H.internal_organs)
					if((I.damage > 0) && !(I.robotic >= ORGAN_ROBOT))
						I.damage = max(I.damage + removed * 0.5, 0)

/datum/reagent/tricordrazine
	name = "Tricordrazine"
	id = "tricordrazine"
	description = "Tricordrazine is a highly potent stimulant, originally derived from cordrazine. Can be used to treat a wide range of minor injuries. Ineffective for severe injuries."
	taste_description = "grossness"
	reagent_state = LIQUID
	color = "#8040FF"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/tricordrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.heal_organ_damage(6 / (sqrt(M.getBruteLoss()) +  1) * removed, 6 / (sqrt(M.getFireLoss()) +  1) * removed) //heals 1.2 * removed at 25 damage
		M.adjustToxLoss(-6 / (sqrt(M.getToxLoss()) +  1) * removed)
		apply_fatigue_effect(M, removed, 0, 10, 10, 5, 2)

/datum/reagent/cryoxadone
	name = "Cryoxadone"
	id = "cryoxadone"
	description = "A chemical mixture used in cryotherapy for treating a wide variety of injuries and genetic damage. The body temperature of the patient must be between 200K and 50K for it to metabolize correctly, it is most effective at temperatures between 170K and 100K."
	taste_description = "sludge"
	reagent_state = LIQUID
	color = "#8080FF"
	metabolism = REM * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/cryoxadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.nutrition = max(M.nutrition - 3 * removed, 0)
	if(M.bodytemperature <=170 && M.bodytemperature >= 100)
		M.adjustCloneLoss(-8 * removed)
		M.adjustOxyLoss(-6 * removed)
		M.heal_organ_damage(6 * removed, 6 * removed)
		M.adjustToxLoss(-6 * removed)
		M.add_chemical_effect(CE_PULSE, -2)
	else if (M.bodytemperature <=200 && M.bodytemperature >= 50)
		M.adjustCloneLoss(-4 * removed)
		M.adjustOxyLoss(-3 * removed)
		M.heal_organ_damage(3 * removed, 3 * removed)
		M.adjustToxLoss(-3 * removed)
		M.add_chemical_effect(CE_PULSE, -2)
	apply_fatigue_effect(M, removed, 0, 10, 10, 20, 10)

/datum/reagent/clonexadone
	name = "Clonexadone"
	id = "clonexadone"
	description = "A liquid compound derived from cryoxadone for use in advanced cryotherapy. It is more effective than its predecessor, but requires the body temperature of the patient to be between 140K and 60K to metabolize correctly. It is most effective at temperatures between 110K and 90K."
	taste_description = "slime"
	reagent_state = LIQUID
	color = "#80BFFF"
	metabolism = REM * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/clonexadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.nutrition = max(M.nutrition - 5 * removed, 0)
	if(M.bodytemperature <= 110 && M.bodytemperature >= 90)
		M.adjustCloneLoss(-14 * removed)
		M.adjustOxyLoss(-10 * removed)
		M.heal_organ_damage(10 * removed, 10 * removed)
		M.adjustToxLoss(-10 * removed)
		M.add_chemical_effect(CE_PULSE, -2)
	else if (M.bodytemperature <=140 && M.bodytemperature >= 60)
		M.adjustCloneLoss(-6 * removed)
		M.adjustOxyLoss(-5 * removed)
		M.heal_organ_damage(5 * removed, 5 * removed)
		M.adjustToxLoss(-5 * removed)
		M.add_chemical_effect(CE_PULSE, -2)
	apply_fatigue_effect(M, removed, 0, 10, 10, 30, 15)

/* Painkillers */

/datum/reagent/paracetamol
	name = "Paracetamol"
	id = "paracetamol"
	description = "Most probably know this as Tylenol, but this chemical is a mild, simple painkiller."
	taste_description = "sickness"
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE * 2
	scannable = 1
	metabolism = REM * 0.1
	flags = IGNORE_MOB_SIZE

/datum/reagent/paracetamol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 25)

/datum/reagent/paracetamol/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.hallucination = max(M.hallucination, 2)

/datum/reagent/tramadol
	name = "Tramadol"
	id = "tramadol"
	description = "A simple, yet effective painkiller."
	taste_description = "sourness"
	reagent_state = LIQUID
	color = "#CB68FC"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	metabolism = REM * 0.1
	flags = IGNORE_MOB_SIZE

/datum/reagent/tramadol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 80)

/datum/reagent/tramadol/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.hallucination = max(M.hallucination, 2)

/datum/reagent/oxycodone
	name = "Oxycodone"
	id = "oxycodone"
	description = "An effective and very addictive painkiller."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#800080"
	overdose = REAGENTS_OVERDOSE * 0.5
	metabolism = REM * 0.1
	flags = IGNORE_MOB_SIZE

/datum/reagent/oxycodone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 150)

/datum/reagent/oxycodone/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.druggy = max(M.druggy, 10)
	M.hallucination = max(M.hallucination, 3)

/* Other medicine */

/datum/reagent/synaptizine
	name = "Synaptizine"
	id = "synaptizine"
	description = "Synaptizine is a slow metabolizing synaptic stimulant used to treat acute neurological disorders."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#99CCFF"
	metabolism = REM * 0.15
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1

/datum/reagent/synaptizine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.drowsyness = max(M.drowsyness - 5, 0)
	M.AdjustParalysis(-1)
	M.AdjustStunned(-1)
	M.AdjustWeakened(-1)
	holder.remove_reagent("mindbreaker", 5 * removed)
	M.hallucination = max(0, M.hallucination - 10)
	M.adjustToxLoss(removed)
	M.add_chemical_effect(CE_PAINKILLER, 20)
	M.adjustBrainLoss(removed * 0.25) //very slow brain damage

/datum/reagent/alkysine
	name = "Alkysine"
	id = "alkysine"
	description = "Alkysine is a drug used to treat severe nerve injuries and neurotoxicity."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#FFFF66"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/alkysine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.adjustBrainLoss(-10 * removed)
	M.add_chemical_effect(CE_PAINKILLER, 10)
	apply_fatigue_effect(M, removed, 0, 10, 10, 10, 5)

/datum/reagent/imidazoline
	name = "Imidazoline"
	id = "imidazoline"
	description = "Heals eye damage."
	taste_description = "dull toxin"
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/imidazoline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.eye_blurry = max(M.eye_blurry - 5, 0)
	M.eye_blind = max(M.eye_blind - 5, 0)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[BP_EYES]
		if(E && istype(E))
			if(E.damage > 0)
				E.damage = max(E.damage - 5 * removed, 0)

/datum/reagent/aurazapine
	name = "Aurazapine"
	id = "aurazapine"
	description = "Aurazapine encourages recovery of acute ear damage."
	taste_description = "earwax"
	reagent_state = LIQUID
	color = "#6600FF"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/aurazapine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustEarDamage(-5 * removed, 0)
	M.ear_deaf = max(M.ear_deaf - 5, 0)

/datum/reagent/peridaxon
	name = "Peridaxon"
	id = "peridaxon"
	description = "Used to encourage recovery of internal organs and nervous systems. Medicate cautiously."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#561EC3"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/peridaxon/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/I in H.internal_organs)
			if((I.damage > 0) && !(I.robotic >= ORGAN_ROBOT)) //Peridaxon heals only non-robotic organs
				I.damage = max(I.damage - removed, 0)
	apply_fatigue_effect(M, removed, 0, 10, 10, 30, 15)
	apply_weakened_effect(M, removed, 0, 10, 10, 20, 30)

/datum/reagent/thrombocytolamine
	name = "Thrombocytolamine"
	id = "thrombocytolamine"
	description = "Used to rapidly clot internal hemorrhages by increasing the effectiveness of platelets."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#B091EE"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/thrombocytolamine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/external/O in H.bad_external_organs)
			for(var/datum/wound/W in O.wounds)
				if(W.internal)
					W.damage = max(W.damage - removed, 0)
					if(W.damage <= 0)
						O.wounds -= W
	apply_fatigue_effect(M, removed, 0, 10, 10, 30, 20)
	apply_weakened_effect(M, removed, 0, 10, 10, 20, 30)

/datum/reagent/osteolazarazine
	name = "Osteolazarazine"
	id = "osteolazarazine"
	description = "An experimental drug used to heal bone fractures by altering its cellular matrices and forcibly joining breaks together."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#260D59"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/osteolazarazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/external/O in H.bad_external_organs)
			if(O.status & ORGAN_BROKEN)
				if(dose >= 14)
					O.mend_fracture()
					H.custom_pain("You feel a terrible agony tear through your bones!",60)
	apply_fatigue_effect(M, removed, 0, 10, 10, 40, 30)
	apply_weakened_effect(M, removed, 0, 10, 10, 30, 50)

/datum/reagent/ryetalyn
	name = "Ryetalyn"
	id = "ryetalyn"
	description = "Ryetalyn can cure all genetic abnomalities via a catalytic process."
	taste_description = "acid"
	reagent_state = SOLID
	color = "#004000"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/ryetalyn/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/needs_update = M.mutations.len > 0

	M.mutations = list()
	M.disabilities = 0
	M.sdisabilities = 0

	// Might need to update appearance for hulk etc.
	if(needs_update && ishuman(M))
		var/mob/living/carbon/human/H = M
		H.update_mutations()

/datum/reagent/hyperzine
	name = "Hyperzine"
	id = "hyperzine"
	description = "Hyperzine is a highly effective, long lasting, muscle stimulant."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#FF3300"
	metabolism = REM * 0.15
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1

/datum/reagent/hyperzine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(prob(5))
		M.emote(pick("twitch", "blink_r", "shiver"))
	M.add_chemical_effect(CE_SPEEDBOOST, 3)
	M.add_chemical_effect(CE_PULSE, 2)
	M.add_chemical_effect(CE_STIM)
	M.stuttering += 1
	M.make_jittery(5)
	M.adjustBrainLoss(removed * 0.25) //very slow brain damage
	M.adjustToxLoss(removed) // slow poisoning

/datum/reagent/ethylredoxrazine
	name = "Ethylredoxrazine"
	id = "ethylredoxrazine"
	description = "A powerful oxidizer that reacts with ethanol."
	reagent_state = SOLID
	color = "#605048"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/ethylredoxrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.dizziness = max(M.dizziness - 10 * removed, 0)
	M.drowsyness = max(M.drowsyness - 5 *removed, 0)
	M.stuttering = max(M.stuttering - 5 * removed, 0)
	M.confused = max(M.confused - 5 * removed, 0)
	if(M.ingested)
		for(var/datum/reagent/R in M.ingested.reagent_list)
			if(istype(R, /datum/reagent/ethanol))
				R.dose = max(R.dose - removed * 5, 0)

/datum/reagent/hyronalin
	name = "Hyronalin"
	id = "hyronalin"
	description = "Hyronalin is a medicinal drug used to counter the effect of radiation poisoning."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#408000"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/hyronalin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.radiation = max(M.radiation - 30 * removed, 0)
		apply_fatigue_effect(M, removed, 0, 10, 10, 10, 5)

/datum/reagent/arithrazine
	name = "Arithrazine"
	id = "arithrazine"
	description = "Arithrazine is an unstable medication used for the most extreme cases of radiation poisoning."
	reagent_state = LIQUID
	color = "#008000"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/arithrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.radiation = max(M.radiation - 150 * removed, 0)
		M.adjustToxLoss(-10 * removed)
		M.adjustHalLoss(20 * removed)
		if(prob(60))
			M.take_organ_damage(4 * removed, 0)
		apply_fatigue_effect(M, removed, 0, 10, 10, 20, 10)

/datum/reagent/spaceacillin
	name = "Spaceacillin"
	id = "spaceacillin"
	description = "An all-purpose antiviral agent."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#C1C1C1"
	metabolism = REM * 0.05
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/sterilizine
	name = "Sterilizine"
	id = "sterilizine"
	description = "Sterilizes wounds in preparation for surgery and thoroughly removes blood."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE * 0.5
	touch_met = 5

/datum/reagent/sterilizine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.adjustToxLoss(5 * removed)

/datum/reagent/sterilizine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	M.germ_level -= min(removed*20, M.germ_level)
	for(var/obj/item/I in M.contents)
		I.was_bloodied = null
	M.was_bloodied = null

/datum/reagent/sterilizine/touch_obj(var/obj/O)
	O.germ_level -= min(volume*20, O.germ_level)
	O.was_bloodied = null

/datum/reagent/sterilizine/touch_turf(var/turf/T)
	T.germ_level -= min(volume*20, T.germ_level)
	for(var/obj/item/I in T.contents)
		I.was_bloodied = null
	for(var/obj/effect/decal/cleanable/blood/B in T)
		qdel(B)

/datum/reagent/leporazine
	name = "Leporazine"
	id = "leporazine"
	description = "Leporazine can be use to stabilize an individuals body temperature."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/leporazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (40 * TEMPERATURE_DAMAGE_COEFFICIENT))
	else if(M.bodytemperature < 311)
		M.bodytemperature = min(310, M.bodytemperature + (40 * TEMPERATURE_DAMAGE_COEFFICIENT))

/datum/reagent/saline
	name = "Hemodextro Saline"
	id = "saline"
	description = "A saline solution infused with dextrose and iron supplements. Commonly used to treat bloodloss, nutritional deficiencies and other chemical imbalances. Administer intravenously. High doses may cause minor hypoxemia."
	taste_description = "salty sweetness"
	reagent_state = LIQUID
	color = "#E6FFFF"
	metabolism = REM * 3
	scannable = 1

/datum/reagent/saline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.add_chemical_effect(CE_BLOODRESTORE, removed)
		M.nutrition += removed
		if(dose > 60) //you'll never reach this number unless you spam saline nonstop
			M.adjustOxyLoss(removed)
			M.adjustHalLoss(5 * removed)

/datum/reagent/saline/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed) // why are you trying to drink this?
	if(alien != IS_DIONA)
		if(prob(10))
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				H.vomit()

/* Special Medicine */

/datum/reagent/adminordrazine //An OP chemical for admins
	name = "Adminordrazine"
	id = "adminordrazine"
	description = "It's magic. We don't have to explain it."
	taste_description = "100% abuse"
	reagent_state = LIQUID
	color = "#C8A5DC"
	flags = AFFECTS_DEAD //This can even heal dead people.

	glass_name = "liquid gold"
	glass_desc = "It's magic. We don't have to explain it."

/datum/reagent/adminordrazine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	affect_blood(M, alien, removed)

/datum/reagent/adminordrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.rejuvenate() //fuck it, easier this way

/datum/reagent/primordapine
	name = "Primordapine"
	id = "primordapine"
	description = "An experimental, long lasting drug used to increase blood production and treat severe burns and traumas. Also removes toxins from the body."
	taste_description = "grossness"
	reagent_state = LIQUID
	color = "#FFEA97"
	overdose = REAGENTS_OVERDOSE
	metabolism = REM * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/primordapine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.add_chemical_effect(CE_BLOODRESTORE, 6 * removed)
		M.heal_organ_damage(sqrt(M.getBruteLoss()) * 1.2 * removed, sqrt(M.getFireLoss()) * 1.2 * removed)
		M.adjustToxLoss(sqrt(M.getToxLoss()) * -1.2 * removed)
		apply_fatigue_effect(M, removed, 0, 10, 10, 5, 2)

/datum/reagent/sarcohemalazapine
	name = "Sarcohemalazapine"
	id = "sarcohemalazapine"
	description = "A strictly controlled drug that induces abnormal cell growth to bridge ruptured blood vessels and broken bones."
	taste_description = "grossness"
	reagent_state = LIQUID
	color = "#D1E7B5"
	overdose = REAGENTS_OVERDOSE * 0.5
	metabolism = REM * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/sarcohemalazapine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/external/O in H.bad_external_organs)
			if(O.status & ORGAN_BROKEN)
				if(dose >= 3)
					O.mend_fracture()
					H.custom_pain("You feel a tingling sensation through your bones!",40)
			for(var/datum/wound/W in O.wounds)
				if(W.internal)
					W.damage = max(W.damage - removed, 0)
					if(W.damage <= 0)
						O.wounds -= W
	apply_fatigue_effect(M, removed, 0, 10, 10, 20, 10)

/* Antidepressants */

#define ANTIDEPRESSANT_MESSAGE_DELAY 5*60*10

/datum/reagent/methylphenidate
	name = "Methylphenidate"
	id = "methylphenidate"
	description = "Improves the ability to concentrate."
	taste_description = "sourness"
	reagent_state = LIQUID
	color = "#BF80BF"
	metabolism = 0.01
	data = 0

/datum/reagent/methylphenidate/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(volume <= 0.1 && dose >= 0.5 && world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
		data = world.time
		to_chat(M, "<span class='warning'>You lose focus...</span>")
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			to_chat(M, "<span class='notice'>Your mind feels focused and undivided.</span>")

/datum/reagent/citalopram
	name = "Citalopram"
	id = "citalopram"
	description = "Stabilizes the mind a little."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#FF80FF"
	metabolism = 0.01
	data = 0

/datum/reagent/citalopram/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(volume <= 0.1 && dose >= 0.5 && world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
		data = world.time
		to_chat(M, "<span class='warning'>Your mind feels a little less stable...</span>")
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			to_chat(M, "<span class='notice'>Your mind feels stable... a little stable.</span>")

/datum/reagent/paroxetine
	name = "Paroxetine"
	id = "paroxetine"
	description = "Stabilizes the mind greatly, but has a chance of adverse effects."
	reagent_state = LIQUID
	color = "#FF80BF"
	metabolism = 0.01
	data = 0

/datum/reagent/paroxetine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(volume <= 0.1 && dose >= 0.5 && world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
		data = world.time
		to_chat(M, "<span class='warning'>Your mind feels much less stable...</span>")
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			if(prob(90))
				to_chat(M, "<span class='notice'>Your mind feels much more stable.</span>")
			else
				to_chat(M, "<span class='warning'>Your mind breaks apart...</span>")
				M.hallucination += 200

/datum/reagent/nicotine
	name = "Nicotine"
	id = "nicotine"
	description = "Stimulates and relaxes the mind and body."
	taste_description = "smoke"
	reagent_state = LIQUID
	color = "#181818"
	metabolism = REM * 0.002
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1
	data = 0

/datum/reagent/nicotine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.add_chemical_effect(CE_PULSE, 1)
	if(volume <= 0.02 && dose >= 0.05 && world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY * 0.3)
		data = world.time
		to_chat(M, "<span class='warning'>You feel antsy, your concentration wavers...</span>")
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY * 0.3)
			data = world.time
			to_chat(M, "<span class='notice'>You feel invigorated and calm.</span>")

/datum/reagent/menthol
	name = "Menthol"
	id = "menthol"
	description = "Tastes naturally minty, and imparts a very mild numbing sensation."
	taste_description = "mint"
	reagent_state = LIQUID
	color = "#80AF9C"
	metabolism = REM * 0.002
	overdose = REAGENTS_OVERDOSE * 0.25
	scannable = 1
	data = 0

/datum/reagent/menthol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY * 0.35)
		data = world.time
		to_chat(M, "<span class='notice'>You feel faintly sore in the throat.</span>")

/datum/reagent/rezadone
	name = "Rezadone"
	id = "rezadone"
	description = "A powder with almost magical properties, this substance can effectively treat genetic damage in humanoids, though excessive consumption has side effects."
	taste_description = "sickness"
	reagent_state = SOLID
	color = "#669900"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/rezadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
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