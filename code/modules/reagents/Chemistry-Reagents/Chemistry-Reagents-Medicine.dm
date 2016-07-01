/* General medicine */

/datum/reagent/inaprovaline
	name = "Inaprovaline"
	id = "inaprovaline"
	description = "Inaprovaline is a fast metabolizing synaptic stimulant and cardiostimulant. Commonly used to stabilize patients."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#00BFFF"
	overdose = REAGENTS_OVERDOSE * 2
	metabolism = REM * 2
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/inaprovaline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_STABLE)
	M.add_chemical_effect(CE_PAINKILLER, 15)
	M.add_chemical_effect(CE_PULSE, 1)

/datum/reagent/bicaridine
	name = "Bicaridine"
	id = "bicaridine"
	description = "Bicaridine is an analgesic medication and can be used to treat blunt trauma."
	taste_description = "bitterness"
	taste_mult = 3
	reagent_state = LIQUID
	color = "#BF0000"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/bicaridine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.heal_organ_damage(5 * removed, 0)

/datum/reagent/kelotane
	name = "Kelotane"
	id = "kelotane"
	description = "Kelotane is a drug used to treat burns."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#FFA800"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/kelotane/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.heal_organ_damage(0, 5 * removed)

/datum/reagent/dermaline
	name = "Dermaline"
	id = "dermaline"
	description = "Dermaline is derived from kelotane, it is more effective in restoring heat-damaged tissue."
	taste_description = "bitterness"
	taste_mult = 1.5
	reagent_state = LIQUID
	color = "#FF8000"
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/dermaline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.heal_organ_damage(0, 10 * removed)

/datum/reagent/dylovene
	name = "Dylovene"
	id = "anti_toxin"
	description = "Dylovene is a broad-spectrum antitoxin."
	taste_description = "a roll of gauze"
	reagent_state = LIQUID
	color = "#00A000"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/dylovene/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.drowsyness = max(0, M.drowsyness - 6 * removed)
	M.hallucination = max(0, M.hallucination - 9 * removed)
	M.adjustToxLoss(-3 * removed)

/datum/reagent/dexalin
	name = "Dexalin"
	id = "dexalin"
	description = "Dexalin is used for treating oxygen deprivation, it rapidly oxygenates the blood and counteract the effects of hypoxemia."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#0080FF"
	overdose = REAGENTS_OVERDOSE
	metabolism = REM * 2
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/dexalin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_VOX)
		M.adjustToxLoss(removed * 6)
	else 
		M.adjustOxyLoss(-10 * removed)

	holder.remove_reagent("lexorin", 2 * removed)

/datum/reagent/dexalinp
	name = "Dexalin Plus"
	id = "dexalinp"
	description = "Dexalin plus is derrived from dexalin, it is used to treat severe oxygen deprivation. It is more effective than standard dexalin."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#0040FF"
	overdose = REAGENTS_OVERDOSE * 0.5
	metabolism = REM * 2
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/dexalinp/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_VOX)
		M.adjustToxLoss(removed * 9)
	else
		M.adjustOxyLoss(-30 * removed)

	holder.remove_reagent("lexorin", 3 * removed)

/datum/reagent/tricordrazine
	name = "Tricordrazine"
	id = "tricordrazine"
	description = "Tricordrazine is a highly potent stimulant, originally derived from cordrazine. Can be used to treat a wide range of injuries, but less effectively than other specialized medication."
	taste_description = "grossness"
	reagent_state = LIQUID
	color = "#8040FF"
	overdose = REAGENTS_OVERDOSE
	metabolism = REM * 0.5	
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/tricordrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustOxyLoss(-4 * removed)
	M.heal_organ_damage(2 * removed, 2 * removed)
	M.adjustToxLoss(-2 * removed)

/datum/reagent/cryoxadone
	name = "Cryoxadone"
	id = "cryoxadone"
	description = "A chemical mixture used in cryotherapy for treating a wide variety of injuries and genetic damage. The body temperature of the patient must be between 200K and 100K for it to metabolize correctly, it is most effective at temperatures between 170K and 130K."
	taste_description = "sludge"
	reagent_state = LIQUID
	color = "#8080FF"
	metabolism = REM * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/cryoxadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.bodytemperature <=170 && M.bodytemperature >= 130)
		M.adjustCloneLoss(-10 * removed)
		M.adjustOxyLoss(-10 * removed)
		M.heal_organ_damage(10 * removed, 10 * removed)
		M.adjustToxLoss(-10 * removed)
		M.add_chemical_effect(CE_PULSE, -2)
	else if (M.bodytemperature <=200 && M.bodytemperature >= 100) //Placeholder until I implement scaling by temperature gradient
		M.adjustCloneLoss(-4 * removed)
		M.adjustOxyLoss(-4 * removed)
		M.heal_organ_damage(4 * removed, 4 * removed)
		M.adjustToxLoss(-4 * removed)
		M.add_chemical_effect(CE_PULSE, -2)

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
	if(M.bodytemperature <= 110 && M.bodytemperature >= 90)
		M.adjustCloneLoss(-20 * removed)
		M.adjustOxyLoss(-20 * removed)
		M.heal_organ_damage(20 * removed, 20 * removed)
		M.adjustToxLoss(-20 * removed)
		M.add_chemical_effect(CE_PULSE, -2)
	else if (M.bodytemperature <=140 && M.bodytemperature >= 60) //Placeholder until I implement scaling by temperature gradient
		M.adjustCloneLoss(-6 * removed)
		M.adjustOxyLoss(-6 * removed)
		M.heal_organ_damage(6 * removed, 6 * removed)
		M.adjustToxLoss(-6 * removed)
		M.add_chemical_effect(CE_PULSE, -2)

/* Painkillers */

/datum/reagent/paracetamol
	name = "Paracetamol"
	id = "paracetamol"
	description = "Most probably know this as Tylenol, but this chemical is a mild, simple painkiller."
	taste_description = "sickness"
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE * 2
	metabolism = REM * 2
	scannable = 1
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
	metabolism = REM * 2
	flags = IGNORE_MOB_SIZE

/datum/reagent/tramadol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 50)

/datum/reagent/tramadol/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.hallucination = max(M.hallucination, 3)

/datum/reagent/oxycodone
	name = "Oxycodone"
	id = "oxycodone"
	description = "An effective and very addictive painkiller."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#800080"
	overdose = REAGENTS_OVERDOSE * 0.5
	metabolism = REM * 2
	flags = IGNORE_MOB_SIZE

/datum/reagent/oxycodone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 80)

/datum/reagent/oxycodone/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.druggy = max(M.druggy, 10)
	M.hallucination = max(M.hallucination, 4)

/* Other medicine */

/datum/reagent/synaptizine
	name = "Synaptizine"
	id = "synaptizine"
	description = "Synaptizine is a slow metabolizing synaptic stimulant used to treat acute neurological disorders. Warning: will cause neurotoxicity."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#99CCFF"
	metabolism = REM * 0.1
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1

/datum/reagent/synaptizine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.drowsyness = max(M.drowsyness - 5, 0)
	M.AdjustParalysis(-1)
	M.AdjustStunned(-1)
	M.AdjustWeakened(-1)
	holder.remove_reagent("mindbreaker", 5)
	M.hallucination = max(0, M.hallucination - 10)
	M.adjustToxLoss(5 * removed) // It used to be incredibly deadly due to an oversight. Not anymore!
	M.adjustBrainLoss(5 * removed)
	M.add_chemical_effect(CE_PAINKILLER, 40)

/datum/reagent/alkysine
	name = "Alkysine"
	id = "alkysine"
	description = "Alkysine is a drug used to treat severe nerve injuries and neurotoxicity. May cause minor neurological side effects. Medicate cautiously."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#FFFF66"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE * 0.33
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/alkysine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustBrainLoss(-15 * removed)
	M.add_chemical_effect(CE_PAINKILLER, 10)
	// TODO: add negative effects

/datum/reagent/imidazoline
	name = "Imidazoline"
	id = "imidazoline"
	description = "Imidazoline is an eye medication that specifically affect the retina and optic nerves, it is commonly used to treat eye injuries through direct application to the affected eye. May cause headaches and minor neurotoxicity."
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
		var/obj/item/organ/eyes/E = H.internal_organs_by_name["eyes"]
		if(E && istype(E))
			if(E.damage > 0)
				E.damage = max(E.damage - 5 * removed, 0)
		if(prob(10))
			M.adjustBrainLoss(1 * removed)

/datum/reagent/peridaxon
	name = "Peridaxon"
	id = "peridaxon"
	description = "Peridaxon is used to encourage recovery of damaged internal organs and nervous systems. Medicate cautiously."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#561EC3"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE * 0.33
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/peridaxon/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/I in H.internal_organs)
			if((I.damage > 0) && (I.robotic != 2)) //Peridaxon heals only non-robotic organs
				I.damage = max(I.damage - removed, 0)

/datum/reagent/ryetalyn
	name = "Ryetalyn"
	id = "ryetalyn"
	description = "Ryetalyn is used to treat genetic abnomalities via a rapid catalytic process. Warning: will increase blood toxicity due to mutative properties."
	taste_description = "acid"
	reagent_state = SOLID
	color = "#004000"
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1
	metabolism = REM * 2

/datum/reagent/ryetalyn/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/needs_update = M.mutations.len > 0
	M.mutations = list()
	M.disabilities = 0
	M.sdisabilities = 0
	M.adjustToxLoss(2 * removed)
	// Might need to update appearance for hulk etc.
	if(needs_update && ishuman(M))
		var/mob/living/carbon/human/H = M
		H.update_mutations()
		

/datum/reagent/hyperzine
	name = "Hyperzine"
	id = "hyperzine"
	description = "Hyperzine is a highly effective muscle stimulant. It also quickens the metabolism of all drugs in the bloodstream."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#FF3300"
	metabolism = REM * 2
	overdose = REAGENTS_OVERDOSE * 0.5

/datum/reagent/hyperzine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(prob(5))
		M.emote(pick("twitch", "blink_r", "shiver"))
	M.add_chemical_effect(CE_SPEEDBOOST, 1)
	M.add_chemical_effect(CE_PULSE, 2)
	
	for(var/datum/reagent/R in M.reagents.reagent_list)
		R.metabolism *= 2 // Placeholder while I figure out out to make this loop only run once, so metabolisom won't hit ludicrous speed

/datum/reagent/ethylredoxrazine
	name = "Ethylredoxrazine"
	id = "ethylredoxrazine"
	description = "A powerful oxidizer that reacts with ethanol."
	reagent_state = SOLID
	color = "#605048"
	metabolism = REM * 2
	overdose = REAGENTS_OVERDOSE	

/datum/reagent/ethylredoxrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.dizziness = 0
	M.drowsyness = 0
	M.stuttering = 0
	M.confused = 0
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
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/hyronalin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.radiation = max(M.radiation - 20 * removed, 0)

/datum/reagent/arithrazine
	name = "Arithrazine"
	id = "arithrazine"
	description = "Arithrazine is an unstable medication used for the most extreme cases of radiation poisoning."
	reagent_state = LIQUID
	color = "#008000"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE

/datum/reagent/arithrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.radiation = max(M.radiation - 60 * removed, 0)
	M.adjustToxLoss(-10 * removed)
	if(prob(60))
		M.take_organ_damage(4 * removed, 0)

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
	touch_met = 5

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

/* Psychological drugs */

#define ANTIDEPRESSANT_MESSAGE_DELAY 5*60*10

/datum/reagent/methylphenidate
	name = "Methylphenidate"
	id = "methylphenidate"
	description = "Improves the ability to concentrate."
	taste_description = "sourness"
	reagent_state = LIQUID
	color = "#BF80BF"
	metabolism = REM * 0.05
	data = 0

/datum/reagent/methylphenidate/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(volume <= 0.1 && dose >= 0.5 && world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
		data = world.time
		M << "<span class='warning'>You lose focus...</span>"
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			M << "<span class='notice'>Your mind feels focused and undivided.</span>"

/datum/reagent/citalopram
	name = "Citalopram"
	id = "citalopram"
	description = "Stabilizes the mind a little."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#FF80FF"
	metabolism = REM * 0.05
	data = 0

/datum/reagent/citalopram/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(volume <= 0.1 && dose >= 0.5 && world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
		data = world.time
		M << "<span class='warning'>Your mind feels a little less stable...</span>"
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			M << "<span class='notice'>Your mind feels stable... a little stable.</span>"

/datum/reagent/paroxetine
	name = "Paroxetine"
	id = "paroxetine"
	description = "Stabilizes the mind greatly, but has a chance of adverse effects."
	reagent_state = LIQUID
	color = "#FF80BF"
	metabolism = REM * 0.05
	data = 0

/datum/reagent/paroxetine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(volume <= 0.1 && dose >= 0.5 && world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
		data = world.time
		M << "<span class='warning'>Your mind feels much less stable...</span>"
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			if(prob(90))
				M << "<span class='notice'>Your mind feels much more stable.</span>"
			else
				M << "<span class='warning'>Your mind breaks apart...</span>"
				M.hallucination += 200
				
/datum/reagent/nicotine
	name = "Nicotine"
	id = "nicotine"
	description = "Stimulates and relaxes the mind and body."
	taste_description = "smoke"
	reagent_state = LIQUID
	color = "#181818"
	metabolism = REM * 0.002 // Snowflakey, but required to make cigarettes work properly
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1	
	data = 0

/datum/reagent/nicotine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PULSE, 1)
	if(volume <= 0.02 && dose >= 0.05 && world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY * 0.3) // Very snowflakey
		data = world.time
		M << "<span class='warning'>You feel antsy, your concentration wavers...</span>"
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY * 0.3)
			data = world.time
			M << "<span class='notice'>You feel invigorated and calm.</span>"
