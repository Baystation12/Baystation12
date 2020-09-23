/* General medicine */

/datum/reagent/inaprovaline
	name = "Inaprovaline"
	description = "Inaprovaline is a multipurpose neurostimulant and cardioregulator. Commonly used to slow bleeding and stabilize patients."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#00bfff"
	overdose = REAGENTS_OVERDOSE * 2
	metabolism = REM * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 3.5

	codex_mechanics = "<p>Inaprovaline is a common medicine and your best friend as a medic. It provides the following effects:</p>\
		<ul>\
			<li>Has no effect on Diona</li>\
			<li>Acts as a mild painkiller</li>\
			<li>Aids in breathing and blood oxygenation when injured</li>\
			<li>Slightly reduces brain damage taken from blood loss</li>\
			<li>Stabilizes abnormal heart rates</li>\
			<li>Slightly reduces arterial bleeding</li>\
			<li>Helps counteract chemical effects that reduce breathing</li>\
		</ul>\
		<p>It can be synthesized using sleepers and is commonly found in autoinjector, bottle, pill, and lollipop form in survival kits, trauma and low oxygen pouches or crates, advanced and light first aid kits, NanoMeds, and medical closets.</p>\
		<p>Overdose effects include slowed reactions, slurring, and drowsyness.</p>"
	codex_antag = "<p>Inaprovaline autoinjectors are a good idea for hairy situations. They'll stabilize you and could mean the difference between life or death in a fight.</p>"

/datum/reagent/inaprovaline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.add_chemical_effect(CE_STABLE)
		M.add_chemical_effect(CE_PAINKILLER, 10)

/datum/reagent/inaprovaline/overdose(var/mob/living/carbon/M, var/alien)
	M.add_chemical_effect(CE_SLOWDOWN, 1)
	if(prob(5))
		M.slurring = max(M.slurring, 10)
	if(prob(2))
		M.drowsyness = max(M.drowsyness, 5)

/datum/reagent/bicaridine
	name = "Bicaridine"
	description = "Bicaridine is a fast-acting medication to treat physical trauma."
	taste_description = "bitterness"
	taste_mult = 3
	reagent_state = LIQUID
	color = "#bf0000"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 4.9

	codex_mechanics = "<p>Bicaridine is a common medicine used to treat brute trauma injury. Do not use if the patient is scheduled for surgery, \
		as the effects of bicaridine will cause incisions to close themselves. It provides the following effects:</p>\
		<ul>\
			<li>Has no effect on Diona</li>\
			<li>Acts as a mild painkiller</li>\
			<li>Heals external body parts</li>\
		</ul>\
		<p>It is commonly found in pill or lollipop form in combat medkits.</p>\
		<p>Bicaridine overdose can stop arterial bleeding, at the cost of the below overdose effects and an inability to operate surgically. \
		This can be useful for triage if all active surgeons are busy.</p>\
		<p>Overdose effects include toxin damage and blockage of blood flow.</p>"

/datum/reagent/bicaridine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.heal_organ_damage(6 * removed, 0)
		M.add_chemical_effect(CE_PAINKILLER, 10)

/datum/reagent/bicaridine/overdose(var/mob/living/carbon/M, var/alien)
	..()
	if(ishuman(M))
		M.add_chemical_effect(CE_BLOCKAGE, (15 + volume - overdose)/100)
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/external/E in H.organs)
			if(E.status & ORGAN_ARTERY_CUT && prob(2))
				E.status &= ~ORGAN_ARTERY_CUT

/datum/reagent/kelotane
	name = "Kelotane"
	description = "Kelotane is a drug used to treat burns."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#ffa800"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 2.9

	codex_mechanics = "<p>Kelotane is a common medicine used to treat burns and is typically combined with Dermaline.</p>\
		<p>Its only effect is treating burns on external limbs. Has no effect on diona.</p>\
		<p>It can be synthesized using upgraded sleepers and is commonly found in lollipop and pill forms in advanced first-aid kits and burn crates.</p>\
		<p>Overdose effects include toxin damage.</p>"

/datum/reagent/kelotane/affect_blood(mob/living/carbon/M, alien, removed)
	if(alien != IS_DIONA)
		M.heal_organ_damage(0, 6 * removed)

/datum/reagent/dermaline
	name = "Dermaline"
	description = "Dermaline is the next step in burn medication. Works twice as good as kelotane and enables the body to restore even the direst heat-damaged tissue."
	taste_description = "bitterness"
	taste_mult = 1.5
	reagent_state = LIQUID
	color = "#ff8000"
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 3.9

	codex_mechanics = "<p>Dermaline is a common medicine used to treat burns more effectively with Kelotane, but is usually combined with it's sister compound.</p>\
		<p>Its only effect is treating burns on external limbs at twice the effectiveness as Kelotane. Has no effect on diona.</p>\
		<p>It can be found in pill form in combat medkits.</p>\
		<p>Overdose effects include toxin damage.</p>"

/datum/reagent/dermaline/affect_blood(mob/living/carbon/M, alien, removed)
	if(alien != IS_DIONA)
		M.heal_organ_damage(0, 12 * removed)

/datum/reagent/dylovene
	name = "Dylovene"
	description = "Dylovene is a broad-spectrum antitoxin used to neutralize poisons before they can do significant harm."
	taste_description = "a roll of gauze"
	reagent_state = LIQUID
	color = "#00a000"
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 2.1
	var/remove_generic = 1
	var/list/remove_toxins = list(
		/datum/reagent/toxin/zombiepowder
	)

	codex_mechanics = "<p>Dylovene is a common medicine used to treat poisonings, venoms, and general toxin damage. Its effects include:</p>\
		<ul>\
			<li>Has no effect on Diona</li>\
			<li>Mitigates drowsyness and hallucinations</li>\
			<li>Reduces toxin levels in internal organs</li>\
			<li>Mitigates the toxic effects of failing kidneys</li>\
			<li>Slowly heals liver damage</li>\
			<li>Improves filtration effect of livers</li>\
			<li>Neutralizes most toxic chemicals in the stomach and bloodstream</li>\
		</ul>\
		<p>It can be synthesized in sleepers and can be found in autoinjector, bottle, lollipop, and pill forms in advanced first-aid kits, toxin pouches, NanoMeds, and medical closets.</p>\
		<p>It has no overdose effect and can help mitigate the toxin damage from overdosing other medications.</p>"

/datum/reagent/dylovene/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return

	if(remove_generic)
		M.drowsyness = max(0, M.drowsyness - 6 * removed)
		M.adjust_hallucination(-9 * removed)
		M.add_up_to_chemical_effect(CE_ANTITOX, 1)

	var/removing = (4 * removed)
	var/datum/reagents/ingested = M.get_ingested_reagents()
	for(var/datum/reagent/R in ingested.reagent_list)
		if((remove_generic && istype(R, /datum/reagent/toxin)) || (R.type in remove_toxins))
			ingested.remove_reagent(R.type, removing)
			return
	for(var/datum/reagent/R in M.reagents.reagent_list)
		if((remove_generic && istype(R, /datum/reagent/toxin)) || (R.type in remove_toxins))
			M.reagents.remove_reagent(R.type, removing)
			return

/datum/reagent/dexalin
	name = "Dexalin"
	description = "Dexalin is used in the treatment of oxygen deprivation."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#0080ff"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 2.4

	codex_mechanics = "<p>Dexalin is a common medicine used to treat oxygen deprivation. Its effects include:</p>\
		<ul>\
			<li>It has no effect on Diona or Mantids except Lexorin removal.</li>\
			<li>Neutralizes Lexorin in the blood stream.</li>\
			<li>Helps oxygenate the blood.</li>\
		</ul>\
		<p>It is toxic to Vox.</p>\
		<p>It can be synthesized in sleepers and can be found in autoinjector and pill form in low oxygen pouches or crates, and advanced and light first-aid kits.</p>\
		<p>Overdoes effects include toxin damage.</p>"

/datum/reagent/dexalin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_VOX)
		M.adjustToxLoss(removed * 6)
	else if(alien != IS_DIONA && alien != IS_MANTID)
		M.add_chemical_effect(CE_OXYGENATED, 1)
	holder.remove_reagent(/datum/reagent/lexorin, 2 * removed)

/datum/reagent/dexalinp
	name = "Dexalin Plus"
	description = "Dexalin Plus is used in the treatment of oxygen deprivation. It is highly effective."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#0040ff"
	overdose = REAGENTS_OVERDOSE * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 3.7

	codex_mechanics = "<p>Dexalin Plus is a superior version of Dexalin used to treat oxygen deprivation. Its effects include:</p>\
		<ul>\
			<li>It has no effect on Diona or Mantids except Lexorin removal.</li>\
			<li>Neutralizes Lexorin in the blood stream.</li>\
			<li>Helps oxygenate the blood.</li>\
		</ul>\
		<p>Overdose effects include toxin damage.</p>"

/datum/reagent/dexalinp/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_VOX)
		M.adjustToxLoss(removed * 9)
	else if(alien != IS_DIONA && alien != IS_MANTID)
		M.add_chemical_effect(CE_OXYGENATED, 2)
	holder.remove_reagent(/datum/reagent/lexorin, 3 * removed)

/datum/reagent/tricordrazine
	name = "Tricordrazine"
	description = "Tricordrazine is a highly potent stimulant, originally derived from cordrazine. Can be used to treat a wide range of injuries."
	taste_description = "grossness"
	reagent_state = LIQUID
	color = "#8040ff"
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 6

	codex_mechanics = "<p>Tricordrazine is a common medicine that provides minor healing of both burns and trauma. Do not use if the patient is scheduled for surgery, \
		as the effects of Tricordrazine will cause incisions to close themselves. Its effects include:</p>\
		<ul>\
			<li>Does not affect Diona.</li>\
			<li>Heals external brute and burn damage at an inferior rate to bicaridine and kelotane.</li>\
		</ul>\
		<p>It can be found in lollipop form and is synthesized by medbots.</p>\
		<p>Overdose effects include toxin damage.</p>"

/datum/reagent/tricordrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.heal_organ_damage(3 * removed, 3 * removed)

/datum/reagent/cryoxadone
	name = "Cryoxadone"
	description = "A chemical mixture with almost magical healing powers. Its main limitation is that the targets body temperature must be under 170K for it to metabolise correctly."
	taste_description = "sludge"
	reagent_state = LIQUID
	color = "#8080ff"
	metabolism = REM * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 3.9

	codex_mechanics = "<p>Cryoxadone is a cryogenic medicine intended for use in cryo cells. Its effects include:</p>\
		<ul>\
			<li>Mitigates damage from extremely cold temperatures</li>\
			<li>The following effects only take place if body temperature is below 170K (-103.15 C):</li>\
			<li>Heals genetic damage</li>\
			<li>Oxygenates the blood</li>\
			<li>Heals external burn and trauma damage</li>\
			<li>Significantly lowers heart rate</li>\
			<li>Heals non-robotic internal organs</li>\
		</ul>\
		<p>It is intended for use only in cryo cells. Directly injecting patients is not recommended.</p>"

/datum/reagent/cryoxadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_CRYO, 1)
	if(M.bodytemperature < 170)
		M.adjustCloneLoss(-100 * removed)
		M.add_chemical_effect(CE_OXYGENATED, 1)
		M.heal_organ_damage(30 * removed, 30 * removed)
		M.add_chemical_effect(CE_PULSE, -2)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			for(var/obj/item/organ/internal/I in H.internal_organs)
				if(!BP_IS_ROBOTIC(I))
					I.heal_damage(20*removed)


/datum/reagent/clonexadone
	name = "Clonexadone"
	description = "A liquid compound similar to that used in the cloning process. Can be used to 'finish' the cloning process when used in conjunction with a cryo tube."
	taste_description = "slime"
	reagent_state = LIQUID
	color = "#80bfff"
	metabolism = REM * 0.5
	scannable = 1
	flags = IGNORE_MOB_SIZE
	heating_products = list(/datum/reagent/cryoxadone, /datum/reagent/sodium)
	heating_point = 50 CELSIUS
	heating_message = "turns back to sludge."
	value = 5.5

	codex_mechanics = "<p>Clonexadone is a cryogenic medicine intended for use in cryo cells that is more effective than cryoxadone. Its effects include:</p>\
		<ul>\
			<li>Mitigates damage from extremely cold temperatures</li>\
			<li>The following effects only take place if body temperature is below 170K (-103.15 C):</li>\
			<li>Heals genetic damage</li>\
			<li>Oxygenates the blood</li>\
			<li>Heals external burn and trauma damage</li>\
			<li>Significantly lowers heart rate</li>\
			<li>Heals non-robotic internal organs</li>\
		</ul>\
		<p>It is intended for use only in cryo cells. Directly injecting patients is not recommended.</p>"

/datum/reagent/clonexadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_CRYO, 1)
	if(M.bodytemperature < 170)
		M.adjustCloneLoss(-300 * removed)
		M.add_chemical_effect(CE_OXYGENATED, 2)
		M.heal_organ_damage(50 * removed, 50 * removed)
		M.add_chemical_effect(CE_PULSE, -2)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			for(var/obj/item/organ/internal/I in H.internal_organs)
				if(!BP_IS_ROBOTIC(I))
					I.heal_damage(30*removed)

/datum/reagent/nanitefluid
	name = "Nanite Fluid"
	description = "A solution of repair nanites used to repair robotic organs. Due to the nature of the small magnetic fields used to guide the nanites, it must be used in temperatures below 170K."
	taste_description = "metallic sludge"
	reagent_state = LIQUID
	color = "#c2c2d6"
	scannable = 1
	flags = IGNORE_MOB_SIZE

	codex_mechanics = "<p>Nanite Fluid is a cryogenic medicine intended for use in cryo cells that can repair prosthetics and IPCs, but does not heal organic components. Its effects include:</p>\
		<ul>\
			<li>Mitigates damage from extremely cold temperatures</li>\
			<li>The following effects only take place if body temperature is below 170K (-103.15 C):</li>\
			<li>Heals external burn and trauma damage on robotic limbs</li>\
			<li>Heals robotic internal organs</li>\
		</ul>\
		<p>It is intended for use only in cryo cells. Directly injecting patients is not recommended.</p>"

/datum/reagent/nanitefluid/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_CRYO, 1)
	if(M.bodytemperature < 170)
		M.heal_organ_damage(30 * removed, 30 * removed, affect_robo = 1)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			for(var/obj/item/organ/internal/I in H.internal_organs)
				if(BP_IS_ROBOTIC(I))
					I.heal_damage(20*removed)

/* Painkillers */

/datum/reagent/paracetamol
	name = "Paracetamol"
	description = "Most probably know this as Tylenol, but this chemical is a mild, simple painkiller."
	taste_description = "sickness"
	reagent_state = LIQUID
	color = "#c8a5dc"
	overdose = 60
	reagent_state = LIQUID
	scannable = 1
	metabolism = 0.02
	flags = IGNORE_MOB_SIZE
	value = 3.3

	codex_mechanics = "<p>Paracetamol is a common, mild painkiller.</p>\
		<p>Unlike opiate-based painkillers, it is safe to take with alcohol.</p>\
		<p>It can be synthesized in sleepers and found in lollipop and pill form in NanoMeds and trauma and burn pouches.</p>\
		<p>Overdose effects include toxin damage, a drug-like effect, and additional painkilling.</p>"

/datum/reagent/paracetamol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 35)

/datum/reagent/paracetamol/overdose(var/mob/living/carbon/M, var/alien)
	M.add_chemical_effect(CE_TOXIN, 1)
	M.druggy = max(M.druggy, 2)
	M.add_chemical_effect(CE_PAINKILLER, 10)

/datum/reagent/tramadol
	name = "Tramadol"
	description = "A simple, yet effective painkiller. Don't mix with alcohol."
	taste_description = "sourness"
	reagent_state = LIQUID
	color = "#cb68fc"
	overdose = 30
	scannable = 1
	metabolism = 0.05
	ingest_met = 0.02
	flags = IGNORE_MOB_SIZE
	value = 3.1
	var/pain_power = 80 //magnitide of painkilling effect
	var/effective_dose = 0.5 //how many units it need to process to reach max power

	codex_mechanics = "<p>Tramadal is a common, moderate opiate-based painkiller. Its effects include:</p>\
		<ul>\
			<li>A moderate level of painkilling.</li>\
			<li>Can cause reduced reaction speed and slurring at dosages above 1/2 the overdose limit.</li>\
			<li>Pinpointed pupils.</li>\
		</ul>\
		<p>When taken with alcohol, it negatively impacts breathing and damages the liver. The effect is magnified if overdosed.</p>\
		<p>It can be found in pill form in advanced first-aid and combat medkits and burn crates.</p>\
		<p>Overdose effects include weakness, drowsyness, hallucinations, a drug-like effect, difficulty breathing, and increased painkilling.</p>"

/datum/reagent/tramadol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/effectiveness = 1
	if(M.chem_doses[type] < effective_dose) //some ease-in ease-out for the effect
		effectiveness = M.chem_doses[type]/effective_dose
	else if(volume < effective_dose)
		effectiveness = volume/effective_dose
	M.add_chemical_effect(CE_PAINKILLER, pain_power * effectiveness)
	if(M.chem_doses[type] > 0.5 * overdose)
		M.add_chemical_effect(CE_SLOWDOWN, 1)
		if(prob(1))
			M.slurring = max(M.slurring, 10)
	if(M.chem_doses[type] > 0.75 * overdose)
		M.add_chemical_effect(CE_SLOWDOWN, 1)
		if(prob(5))
			M.slurring = max(M.slurring, 20)
	if(M.chem_doses[type] > overdose)
		M.add_chemical_effect(CE_SLOWDOWN, 1)
		M.slurring = max(M.slurring, 30)
		if(prob(1))
			M.Weaken(2)
			M.drowsyness = max(M.drowsyness, 5)
	var/boozed = isboozed(M)
	if(boozed)
		M.add_chemical_effect(CE_ALCOHOL_TOXIC, 1)
		M.add_chemical_effect(CE_BREATHLOSS, 0.1 * boozed) //drinking and opiating makes breathing kinda hard

/datum/reagent/tramadol/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.hallucination(120, 30)
	M.druggy = max(M.druggy, 10)
	M.add_chemical_effect(CE_PAINKILLER, pain_power*0.5) //extra painkilling for extra trouble
	M.add_chemical_effect(CE_BREATHLOSS, 0.6) //Have trouble breathing, need more air
	if(isboozed(M))
		M.add_chemical_effect(CE_BREATHLOSS, 0.2) //Don't drink and OD on opiates folks

/datum/reagent/tramadol/proc/isboozed(var/mob/living/carbon/M)
	. = 0
	var/datum/reagents/ingested = M.get_ingested_reagents()
	if(ingested)
		var/list/pool = M.reagents.reagent_list | ingested.reagent_list
		for(var/datum/reagent/ethanol/booze in pool)
			if(M.chem_doses[booze.type] < 2) //let them experience false security at first
				continue
			. = 1
			if(booze.strength < 40) //liquor stuff hits harder
				return 2

/datum/reagent/tramadol/oxycodone
	name = "Oxycodone"
	description = "An effective and very addictive painkiller. Don't mix with alcohol."
	taste_description = "bitterness"
	color = "#800080"
	scannable = 1
	overdose = 20
	pain_power = 200
	effective_dose = 2

	codex_mechanics = "<p>Oxycodone is a strong opiate-based painkiller. Its effects include:</p>\
		<ul>\
			<li>A strong level of painkilling.</li>\
			<li>Can cause reduced reaction speed and slurring at dosages above 1/2 the overdose limit.</li>\
			<li>Pinpointed pupils.</li>\
		</ul>\
		<p>It is a controlled substance outside of legitimate medical use.</p>\
		<p>When taken with alcohol, it negatively impacts breathing and damages the liver. The effect is magnified if overdosed.</p>\
		<p>Overdose effects include weakness, drowsyness, hallucinations, a drug-like effect, difficulty breathing, and increased painkilling.</p>"

/datum/reagent/deletrathol
	name = "Deletrathol"
	description = "An effective painkiller that causes confusion."
	taste_description = "confusion"
	color = "#800080"
	reagent_state = LIQUID
	overdose = 15
	scannable = 1
	metabolism = 0.02
	flags = IGNORE_MOB_SIZE

	codex_mechanics = "<p>Deletrathol is a moderate painkiller comparable to Tramadol but with its own trade-offs. Its effects include:</p>\
		<ul>\
			<li>A moderate level of painkilling.</li>\
			<li>Slowed reaction speed</li>\
			<li>Dizziness</li>\
			<li>Drowsiness</li>\
			<li>Confusion</li>\
		</ul>\
		<p>Unlike opiate-based painkillers, it is safe to take with alcohol.</p>\
		<p>It can be found in autoinjector form in light first-aid kits.</p>\
		<p>Overdose effects include toxin damage, drug-like effects, and increased painkilling.</p>"

/datum/reagent/deletrathol/affect_blood(var/mob/living/carbon/human/H, var/alien, var/removed)
	H.add_chemical_effect(CE_PAINKILLER, 80)
	H.add_chemical_effect(CE_SLOWDOWN, 1)
	H.make_dizzy(2)
	if(prob(75))
		H.drowsyness++
	if(prob(25))
		H.confused++

/datum/reagent/deletrathol/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.druggy = max(M.druggy, 2)
	M.add_chemical_effect(CE_PAINKILLER, 10)

/* Other medicine */

/datum/reagent/synaptizine
	name = "Synaptizine"
	description = "Synaptizine is used to treat various diseases."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#99ccff"
	metabolism = REM * 0.05
	overdose = REAGENTS_OVERDOSE / 6 // 5
	scannable = 1
	value = 4.6

	codex_mechanics = "<p>Synpatizine is a general purpose treatment for viruses and various common symptoms but causes toxin damage. Its effects include:</p>\
		<ul>\
			<li>It has no effect on Diona.</li>\
			<li>Mitigation of drowsyness, paralysis, stun effects, weakened effects, and hallucinations.</li>\
			<li>Neutralizes mindbreaker toxin.</li>\
			<li>Mild to moderate painkilling.</li>\
			<li>Mind altering effects that may stabilize the mind.</li>\
			<li>Moderate toxin damage.</li>\
		</ul>\
		<p>It is a controlled substance outside of legitimate medical use.</p>\
		<p>Overdose effects include additional toxin damage.</p>"
	codex_antag = "<p>Synaptizine can be used as a combat stimulant to reduce the effects of being stunned, sedated, or tased. Combining with dylovene is recommended to help counteract the toxin effect.</p>\
		<p>It is one of the chemicals found in zoom pills and sin pockets.</p>\
		<p>It is illegal so be careful not to be caught with it.</p>"

/datum/reagent/synaptizine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.drowsyness = max(M.drowsyness - 5, 0)
	M.AdjustParalysis(-1)
	M.AdjustStunned(-1)
	M.AdjustWeakened(-1)
	holder.remove_reagent(/datum/reagent/mindbreaker, 5)
	M.adjust_hallucination(-10)
	M.add_chemical_effect(CE_MIND, 2)
	M.adjustToxLoss(5 * removed) // It used to be incredibly deadly due to an oversight. Not anymore!
	M.add_chemical_effect(CE_PAINKILLER, 20)
	M.add_chemical_effect(CE_STIMULANT, 10)

/datum/reagent/dylovene/venaxilin
	name = "Venaxilin"
	description = "Venixalin is a strong, specialised antivenom for dealing with advanced toxins and venoms."
	taste_description = "overpowering sweetness"
	color = "#dadd98"
	scannable = 1
	metabolism = REM * 2
	remove_generic = 0
	remove_toxins = list(
		/datum/reagent/toxin/venom,
		/datum/reagent/toxin/carpotoxin
	)

	codex_mechanics = "<p>Venixalin is a powerful antivenom primarily used for treating spider and carp bites. It neutralizes spider and carp venoms.</p>"

/datum/reagent/alkysine
	name = "Alkysine"
	description = "Alkysine is a drug used to lessen the damage to neurological tissue after a injury. Can aid in healing brain tissue."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#ffff66"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 5.9

	codex_mechanics = "<p>Alkysine is a medicine used to treat brain damage but causes confusion and drowsyness. Its effects include:</p>\
		<ul>\
			<li>Has no effect on Diona.</li>\
			<li>Mild painkilling effect.</li>\
			<li>Heals brain damage.</li>\
			<li>Causes confusion and drowsyness.</li>\
		</ul>\
		<p>Overdose effects include toxin damage.</p>"

/datum/reagent/alkysine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.add_chemical_effect(CE_PAINKILLER, 10)
	M.add_chemical_effect(CE_BRAIN_REGEN, 1)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.confused++
		H.drowsyness++

/datum/reagent/imidazoline
	name = "Imidazoline"
	description = "Heals eye damage"
	taste_description = "dull toxin"
	reagent_state = LIQUID
	color = "#c8a5dc"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 4.2

	codex_mechanics = "<p>Imidazoline is a medicine used to treat eye damage. Its effects include:</p>\
		<ul>\
			<p>Mitigation of blurred vision and blindness.</p>\
			<p>Healing of organic and robotic eyes.</p>\
		</ul>\
		<p>Contrary to popular belief, it can be injected and does not have to be eyedropped onto the eyes to work.</p>\
		<p>Overdose effects include toxin damage.</p>"

/datum/reagent/imidazoline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.eye_blurry = max(M.eye_blurry - 5, 0)
	M.eye_blind = max(M.eye_blind - 5, 0)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[BP_EYES]
		if(E && istype(E))
			if(E.damage > 0)
				E.damage = max(E.damage - 5 * removed, 0)

/datum/reagent/peridaxon
	name = "Peridaxon"
	description = "Used to encourage recovery of internal organs and nervous systems. Medicate cautiously."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#561ec3"
	overdose = 10
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 6

	codex_mechanics = "<p>Peridaxon is a medicine used to repair internal organs. Its effects include:</p>\
		<ul>\
			<li>Confusion and drowsyness.</li>\
			<li>Heals minor brain damage.</li>\
			<li>Heals non-robotic internal organ damage.</li>\
			<li>Can treat organ necrosis.</li>\
		</ul>\
		<p>Overdose effects include toxin damage.</p>"

/datum/reagent/peridaxon/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/internal/I in H.internal_organs)
			if(!BP_IS_ROBOTIC(I))
				if(I.organ_tag == BP_BRAIN)
					// if we have located an organic brain, apply side effects
					H.confused++
					H.drowsyness++
					// peridaxon only heals minor brain damage
					if(I.damage >= I.min_bruised_damage)
						continue
				I.heal_damage(removed)

/datum/reagent/ryetalyn
	name = "Ryetalyn"
	description = "Ryetalyn can cure all genetic abnomalities via a catalytic process."
	taste_description = "acid"
	reagent_state = SOLID
	color = "#004000"
	scannable = 1
	overdose = REAGENTS_OVERDOSE
	value = 3.6

	codex_mechanics = "<p>Ryetalyn is a medicine used to treat genetic damage. Its effects include:</p>\
		<ul>\
			<li>Removal of genetic mutations, defects, and disabilities.</li>\
		</ul>\
		<p>Only a single unit of ryetalyn is needed for full effect.</p>\
		<p>Overdose effects include toxin damage.</p>"

/datum/reagent/ryetalyn/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/needs_update = M.mutations.len > 0

	M.disabilities = 0
	M.sdisabilities = 0

	if(needs_update && ishuman(M))
		M.dna.ResetUI()
		M.dna.ResetSE()
		domutcheck(M, null, MUTCHK_FORCED)

/datum/reagent/hyperzine
	name = "Hyperzine"
	description = "Hyperzine is a highly effective, long lasting, muscle stimulant."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#ff3300"
	metabolism = REM * 0.15
	overdose = REAGENTS_OVERDOSE * 0.5
	value = 3.9

	codex_mechanics = "<p>Hyperzine is a drug used to increase reaction and movement speed. Its effects include:</p>\
		<ul>\
			<li>Has no effect on Diona.</li>\
			<li>Uncontrolled twitching, blinking, and shiverring.</li>\
			<li>Increased movement speed.</li>\
			<li>Elevated heart rate.</li>\
			<li>Slows down slimes if injected into them.</li>\
		</ul>\
		<p>It is a controlled substance outside of legitimate medical use.</p>\
		<p>It can be found in lollipop form.</p>\
		<p>Overdose effects include toxin damage.</p>"
	codex_antag = "<p>Hyperzine is useful for giving yourself a speed boost.</p>\
		<p>It is one of the chemicals found in zoom pills, sin pockets, and steroids syringes (Found by hacking SweatMAX vendors).</p>\
		<p>It is illegal so be careful not to be caught with it.</p>"

/datum/reagent/hyperzine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(prob(5))
		M.emote(pick("twitch", "blink_r", "shiver"))
	M.add_chemical_effect(CE_SPEEDBOOST, 1)
	M.add_chemical_effect(CE_PULSE, 3)
	M.add_chemical_effect(CE_STIMULANT, 4)

/datum/reagent/ethylredoxrazine
	name = "Ethylredoxrazine"
	description = "A powerful oxidizer that reacts with ethanol."
	reagent_state = SOLID
	color = "#605048"
	scannable = 1
	overdose = REAGENTS_OVERDOSE
	value = 3.1

	codex_mechanics = "<p>Ethylredozrazine is a medicine used to treat alcohol poisoning. Its effects include:</p>\
		<ul>\
			<li>Does not effect Diona.</li>\
			<li>Mitigates dizziness, drowsyness, stuttering, and confusion.</li>\
			<li>Neutralizes ethanol in the bloodstream.</li>\
		</ul>\
		<p>Overdose effects include toxin damage.</p>"

/datum/reagent/ethylredoxrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.dizziness = 0
	M.drowsyness = 0
	M.stuttering = 0
	M.confused = 0
	var/datum/reagents/ingested = M.get_ingested_reagents()
	if(ingested)
		for(var/datum/reagent/R in ingested.reagent_list)
			if(istype(R, /datum/reagent/ethanol))
				M.chem_doses[R.type] = max(M.chem_doses[R.type] - removed * 5, 0)

/datum/reagent/hyronalin
	name = "Hyronalin"
	description = "Hyronalin is a medicinal drug used to counter the effect of radiation poisoning."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#408000"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 2.3

	codex_mechanics = "<p>Hyronalin is a medicine used to treat radiation poisoning. Its effects include:</p>\
		<ul>\
			<li>Reduction of radiation levels.</li>\
		</ul>\
		<p>It does not treat the symptoms or damage caused by radiation.</p>\
		<p>It can be synthesized in upgraded sleepers and can be found in autoinjector, pill, and lollipop form in advanced first-aid kits, engineering survival kits, radiation pouches, and toxin crates.</p>\
		<p>Overdose effects include toxin damage.</p>"

/datum/reagent/hyronalin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.radiation = max(M.radiation - 30 * removed, 0)

/datum/reagent/arithrazine
	name = "Arithrazine"
	description = "Arithrazine is an unstable medication used for the most extreme cases of radiation poisoning."
	reagent_state = LIQUID
	color = "#008000"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 2.7

	codex_mechanics = "<p>Arithrazine is a medicine used to treat radiation poisoning more effectively than hyronalin but causes exteranl damage in the process. Its effects include:</p>\
		<ul>\
			<li>Reduction of radiation levels.</li>\
			<li>Brute trauma damage acrossed the body.</li>\
		</ul>\
		<p>Combining it with bicaridine or tricordrazine is recommended unless surgery is planned for the patient.</p>\
		<p>It does not treat the symptoms or damage caused by radiation.</p>\
		<p>Overdose effects include toxin damage.</p>"

/datum/reagent/arithrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.radiation = max(M.radiation - 70 * removed, 0)
	M.adjustToxLoss(-10 * removed)
	if(prob(60))
		M.take_organ_damage(4 * removed, 0, ORGAN_DAMAGE_FLESH_ONLY)

/datum/reagent/spaceacillin
	name = "Spaceacillin"
	description = "An all-purpose antiviral agent."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#c1c1c1"
	metabolism = REM * 0.1
	overdose = REAGENTS_OVERDOSE/2
	scannable = 1
	value = 2.5

	codex_mechanics = "<p>Spaceacillin is a common medicine used to treat infections and viruses. Its effects include:</p>\
		<ul>\
			<li>Reduced immunity. Higher dosages have a more pronounced permanent effect on immunity.</li>\
			<li>Mitigation of common viruses. Higher dosages are more effective on rarer and stronger viruses.</li>\
			<li>Removal of infections.</li>\
			<li>If combined with immunobooster, causes severe toxin damage.</li>\
		</ul>\
		<p>It can be found in pill and syringe form in burn crates and NanoMeds.</p>\
		<p>Overdose effects include toxin damage, severely reduced immunity, mitigation of exotic viruses, and a chance of permanently compromised immune systems.</p>"
	codex_antag = "<p>If combined with immunobooster, makes for an effective poison.</p>"

/datum/reagent/spaceacillin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.immunity = max(M.immunity - 0.1, 0)
	M.add_chemical_effect(CE_ANTIVIRAL, VIRUS_COMMON)
	M.add_chemical_effect(CE_ANTIBIOTIC, 1)
	if(volume > 10)
		M.immunity = max(M.immunity - 0.3, 0)
		M.add_chemical_effect(CE_ANTIVIRAL, VIRUS_ENGINEERED)
	if(M.chem_doses[type] > 15)
		M.immunity = max(M.immunity - 0.25, 0)

/datum/reagent/spaceacillin/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.immunity = max(M.immunity - 0.25, 0)
	M.add_chemical_effect(CE_ANTIVIRAL, VIRUS_EXOTIC)
	if(prob(2))
		M.immunity_norm = max(M.immunity_norm - 1, 0)

/datum/reagent/sterilizine
	name = "Sterilizine"
	description = "Sterilizes wounds in preparation for surgery and thoroughly removes blood."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#c8a5dc"
	touch_met = 5
	value = 2.2

	codex_mechanics = "<p>Sterilizine is a chemical used to sterilize patients for surgery. Its effects include:</p>\
		<ul>\
			<li>Removal of germs and blood from sprayed surfaces.</li>\
		</ul>\
		<p>It can be found in spray bottle form.</p>\
		<p>It is not an effective cure for infections.</p>"
	codex_antag = "<p>Blood removed by sterilizine does not appear with UV lights or luminol.</p>"

/datum/reagent/sterilizine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.germ_level < INFECTION_LEVEL_TWO) // rest and antibiotics is required to cure serious infections
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
	description = "Leporazine can be use to stabilize an individuals body temperature."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#c8a5dc"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	chilling_products = list(/datum/reagent/leporazine/cold)
	chilling_point = -10 CELSIUS
	chilling_message = "Takes on the consistency of slush."
	heating_products = list(/datum/reagent/leporazine/hot)
	heating_point = 110 CELSIUS
	heating_message = "starts swirling, glowing occasionally."
	value = 2

	codex_mechanics = "<p>Leporazine is a medicine used to stabilize body temperature. It's effects include:</p>\
		<ul>\
			<li>Raises or lowers body temperature as needed to reach 310K (37C).</li>\
		</ul>\
		<p>Overdose effects include toxin damage.</p>"

/datum/reagent/leporazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (40 * TEMPERATURE_DAMAGE_COEFFICIENT))
	else if(M.bodytemperature < 311)
		M.bodytemperature = min(310, M.bodytemperature + (40 * TEMPERATURE_DAMAGE_COEFFICIENT))

/datum/reagent/leporazine/hot
	name = "Pyrogenic Leporazine"
	chilling_products = list(/datum/reagent/leporazine)
	chilling_point = 0 CELSIUS
	chilling_message = "Stops swirling and glowing."
	heating_products = null
	heating_point = null
	heating_message = null
	scannable = 1

	codex_mechanics = "<p>Pyrogenic Leporazine is the result of improperly stored Leporazine that has become too warm. Its effects include:</p>\
		<ul>\
			<li>Raises body temperature to above 330K (57C).</li>\
		</ul>\
		<p>Overdose effects include toxin damage.</p>"

/datum/reagent/leporazine/hot/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.bodytemperature < 330)
		M.bodytemperature = min(330, M.bodytemperature + (40 * TEMPERATURE_DAMAGE_COEFFICIENT))

/datum/reagent/leporazine/cold
	name = "Cryogenic Leporazine"
	chilling_products = null
	chilling_point = null
	chilling_message = null
	heating_products = list(/datum/reagent/leporazine)
	heating_point = 100 CELSIUS
	heating_message = "Becomes clear and smooth."
	scannable = 1

	codex_mechanics = "<p>Cryogenic Leporazine is the result of improperly stored Leporazine that has become too cold. Its effects include:</p>\
		<ul>\
			<li>Reduces body temperature to below 290K (17C).</li>\
		</ul>\
		<p>Overdose effects include toxin damage.</p>"

/datum/reagent/leporazine/cold/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.bodytemperature > 290)
		M.bodytemperature = max(290, M.bodytemperature - (40 * TEMPERATURE_DAMAGE_COEFFICIENT))

/* Antidepressants */

#define ANTIDEPRESSANT_MESSAGE_DELAY 5*60*10

/datum/reagent/methylphenidate
	name = "Methylphenidate"
	description = "Improves the ability to concentrate."
	taste_description = "sourness"
	reagent_state = LIQUID
	color = "#bf80bf"
	scannable = 1
	metabolism = 0.01
	data = 0
	value = 6

	codex_mechanics = "<p>Methylphenidate is a psychiatric medicine use to improve concentration. Its effects include:</p>\
		<ul>\
			<li>Does not effect Diona.</p>\
			<li>Improved focus (No actual mechanical effect).</li>\
		</ul>\
		<p>It can be found in lollipop and pill forms in psychiatrist's lockers.</p>"

/datum/reagent/methylphenidate/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(volume <= 0.1 && M.chem_doses[type] >= 0.5 && world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
		data = world.time
		to_chat(M, "<span class='warning'>You lose focus...</span>")
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			to_chat(M, "<span class='notice'>Your mind feels focused and undivided.</span>")

/datum/reagent/citalopram
	name = "Citalopram"
	description = "Stabilizes the mind a little."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#ff80ff"
	scannable = 1
	metabolism = 0.01
	data = 0
	value = 6

	codex_mechanics = "<p>Citalopram is a psychiatric medicine used to stabilize the mind. Its effects include:</p>\
		<ul>\
			<p>Has no effect on Diona.</p>\
			<p>Stabilizes the mind.</p>\
		</ul>\
		<p>Can be found in lollipop and pill forms in psychiatrist's lockers.</p>"

/datum/reagent/citalopram/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(volume <= 0.1 && M.chem_doses[type] >= 0.5 && world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
		data = world.time
		to_chat(M, "<span class='warning'>Your mind feels a little less stable...</span>")
	else
		M.add_chemical_effect(CE_MIND, 1)
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			to_chat(M, "<span class='notice'>Your mind feels stable... a little stable.</span>")

/datum/reagent/paroxetine
	name = "Paroxetine"
	description = "Stabilizes the mind greatly, but has a chance of adverse effects."
	reagent_state = LIQUID
	color = "#ff80bf"
	scannable = 1
	metabolism = 0.01
	data = 0
	value = 3.5

	codex_mechanics = "<p>Paroxetine is a psychiatric medicine used to stabilize the mind. It is more effective than Citalopram but may have adverse effects. Its effects include:</p>\
		<ul>\
			<li>Has no effect on Diona.</li>\
			<li>Stabilizes the mind.</li>\
			<li>Has a chance of hallucinations.</li>\
		</ul>\
		<p>Can be found in pill form in psychiatrist's lockers.</p>"

/datum/reagent/paroxetine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(volume <= 0.1 && M.chem_doses[type] >= 0.5 && world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
		data = world.time
		to_chat(M, "<span class='warning'>Your mind feels much less stable...</span>")
	else
		M.add_chemical_effect(CE_MIND, 2)
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			if(prob(90))
				to_chat(M, "<span class='notice'>Your mind feels much more stable.</span>")
			else
				to_chat(M, "<span class='warning'>Your mind breaks apart...</span>")
				M.hallucination(200, 100)

/datum/reagent/nicotine
	name = "Nicotine"
	description = "A sickly yellow liquid sourced from tobacco leaves. Stimulates and relaxes the mind and body."
	taste_description = "peppery bitterness"
	reagent_state = LIQUID
	color = "#efebaa"
	metabolism = REM * 0.002
	overdose = 6
	scannable = 1
	data = 0
	value = 2

	codex_mechanics = "<p>Nicotine is an addictive but legal drug commonly found in cigarettes. Its effects include:</p>\
		<ul>\
			<li>Has no effect on Diona.</li>\
			<li>A sense of invograting calmness (No actual mechanical effect).</li>\
			<li>Elevated heart rate.</li>\
			<li>Increases carbon dioxide emissions and oxygen usage in the room when smoked.</li>\
		</ul>\
		<p>It is commonly found in cigarettes and tobacco.</p>\
		<p>Overdose effects include toxin damage and even more elevated heart rate.</p>"

/datum/reagent/nicotine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(prob(volume*20))
		M.add_chemical_effect(CE_PULSE, 1)
	if(volume <= 0.02 && M.chem_doses[type] >= 0.05 && world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY * 0.3)
		data = world.time
		to_chat(M, "<span class='warning'>You feel antsy, your concentration wavers...</span>")
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY * 0.3)
			data = world.time
			to_chat(M, "<span class='notice'>You feel invigorated and calm.</span>")

/datum/reagent/nicotine/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.add_chemical_effect(CE_PULSE, 2)

/datum/reagent/tobacco
	name = "Tobacco"
	description = "Cut and processed tobacco leaves."
	taste_description = "tobacco"
	reagent_state = SOLID
	color = "#684b3c"
	scannable = 1
	value = 3
	scent = "cigarette smoke"
	scent_descriptor = SCENT_DESC_ODOR
	scent_range = 4

	codex_mechanics = "<p>Nicotine is an addictive but legal drug commonly found in cigarettes. Its effects include:</p>\
		<ul>\
			<li>Has no effect on Diona.</li>\
			<li>A sense of invograting calmness (No actual mechanical effect).</li>\
			<li>Elevated heart rate.</li>\
			<li>Increases carbon dioxide emissions and oxygen usage in the room when smoked.</li>\
		</ul>\
		<p>It is commonly found in cigarettes and tobacco.</p>\
		<p>Overdose effects include toxin damage and even more elevated heart rate.</p>"

	var/nicotine = REM * 0.2

/datum/reagent/tobacco/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.reagents.add_reagent(/datum/reagent/nicotine, nicotine)

/datum/reagent/tobacco/fine
	name = "Fine Tobacco"
	taste_description = "fine tobacco"
	value = 5
	scent = "fine tobacco smoke"
	scent_descriptor = SCENT_DESC_FRAGRANCE

/datum/reagent/tobacco/bad
	name = "Terrible Tobacco"
	taste_description = "acrid smoke"
	value = 0
	scent = "acrid tobacco smoke"
	scent_intensity = /decl/scent_intensity/strong
	scent_descriptor = SCENT_DESC_ODOR

/datum/reagent/tobacco/liquid
	name = "Nicotine Solution"
	description = "A diluted nicotine solution."
	reagent_state = LIQUID
	taste_mult = 0
	color = "#fcfcfc"
	nicotine = REM * 0.1
	scent = null
	scent_intensity = null
	scent_descriptor = null
	scent_range = null

/datum/reagent/menthol
	name = "Menthol"
	description = "Tastes naturally minty, and imparts a very mild numbing sensation."
	taste_description = "mint"
	reagent_state = LIQUID
	color = "#80af9c"
	metabolism = REM * 0.002
	overdose = REAGENTS_OVERDOSE * 0.25
	scannable = 1
	data = 0

	codex_mechanics = "<p>Menthol is a common nicotine-free alternative to tobacco used in cigarettes. Its effects include:</p>\
		<ul>\
			<li>Has no effect on Diona.</li>\
			<li>Sore throat (No actualmechanical effect).</li>\
		</ul>\
		<p>It is commonly found in menthol cigarettes.</p>\
		<p>Overdose effects include toxin damage.</p>"

/datum/reagent/menthol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY * 0.35)
		data = world.time
		to_chat(M, "<span class='notice'>You feel faintly sore in the throat.</span>")

/datum/reagent/rezadone
	name = "Rezadone"
	description = "A powder with almost magical properties, this substance can effectively treat genetic damage in humanoids, though excessive consumption has side effects."
	taste_description = "sickness"
	reagent_state = SOLID
	color = "#669900"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE
	value = 5

	codex_mechanics = "<p>Rezadone is a medicine used to treat genetic damage but has side effects. Effects include:</p>\
		<ul>\
			<li>Healing of genetic, toxin, and external burn and traume damage.</li>\
			<li>Helps treat difficulty breathing.</li>\
			<li>Can cause external limb disfiguration in dosages greater than 3u.</li>\
			<li>Can cause dizziness and jitterness in dosages greater than 10u.</li>\
		</ul>\
		<p>Overdose effects include toxin damage.</p>"

/datum/reagent/rezadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustCloneLoss(-20 * removed)
	M.adjustOxyLoss(-2 * removed)
	M.heal_organ_damage(20 * removed, 20 * removed)
	M.adjustToxLoss(-20 * removed)
	if(M.chem_doses[type] > 3 && ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/external/E in H.organs)
			E.status |= ORGAN_DISFIGURED //currently only matters for the head, but might as well disfigure them all.
	if(M.chem_doses[type] > 10)
		M.make_dizzy(5)
		M.make_jittery(5)

/datum/reagent/noexcutite
	name = "Noexcutite"
	description = "A thick, syrupy liquid that has a lethargic effect. Used to cure cases of jitteriness."
	taste_description = "numbing coldness"
	reagent_state = LIQUID
	color = "#bc018a"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	flags = IGNORE_MOB_SIZE

	codex_mechanics = "<p>Noexcutite is a medicine used to treat jitters and shaking. Its effects include:</p>\
		<ul>\
			<li>Has no effect on Diona.</li>\
			<li>Reduces jitteriness.</li>\
		</ul>\
		<p>It can be found in pill form.</p>\
		<p>Overdose effects include toxin damage.</p>"

/datum/reagent/noexcutite/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)

	if(alien != IS_DIONA)
		M.make_jittery(-50)

/datum/reagent/antidexafen
	name = "Antidexafen"
	description = "All-in-one cold medicine. Fever, cough, sneeze, safe for babies."
	taste_description = "cough syrup"
	reagent_state = LIQUID
	color = "#c8a5dc"
	overdose = 60
	scannable = 1
	metabolism = REM * 0.05
	flags = IGNORE_MOB_SIZE

	codex_mechanics = "<p>Antidexafen is a common cold medicine. Its effects include:</p>\
		<ul>\
			<li>It has no effect on Diona.</li>\
			<li>Mild painkiller effect.</li>\
			<li>Mitigation of minor viruses.</li>\
		</ul>\
		<p>Can be found in lollipop and pill forms.</p>\
		<p>Overdose effects include toxin damage, hallucination, and a mild drug-like effect.</p>"

/datum/reagent/antidexafen/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return

	M.add_chemical_effect(CE_PAINKILLER, 15)
	M.add_chemical_effect(CE_ANTIVIRAL, 1)

/datum/reagent/antidexafen/overdose(var/mob/living/carbon/M, var/alien)
	M.add_chemical_effect(CE_TOXIN, 1)
	M.hallucination(60, 20)
	M.druggy = max(M.druggy, 2)

/datum/reagent/adrenaline
	name = "Adrenaline"
	description = "Adrenaline is a hormone used as a drug to treat cardiac arrest and other cardiac dysrhythmias resulting in diminished or absent cardiac output."
	taste_description = "rush"
	reagent_state = LIQUID
	color = "#c8a5dc"
	scannable = 1
	overdose = 20
	metabolism = 0.1
	value = 2

	codex_mechanics = "<p>Adrenaline is a hormone used to treat cardiac arrest or reduced heart rates. Its effects include:</p>\
		<ul>\
			<li>Has no effect on Diona.</li>\
			<li>Painkiller effect. Painkiller effects are reduced over time regardless of dosage.</li>\
			<li>Increased heart rate.</li>\
			<li>Dilated pupils.</li>\
			<li>Jitteriness at dosaged over 10u.</li>\
			<li>Can restart the heart but also causes heart damage in the process.</li>\
		</ul>\
		<p>Adrenaline is naturally produced by the body when stressed. Common sources include stunning, tasing, and severe pain.</p>\
		<p>Can be found in autoinjector form in burn and low oxygen pouches.</p>\
		<p>Overdose effects include toxin damage.</p>"
	codex_antag = "<p>It can be found in steroids syringes (Acquired by hacking SweatMAX dispensers)</p>"

/datum/reagent/adrenaline/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return

	if(M.chem_doses[type] < 0.2)	//not that effective after initial rush
		M.add_chemical_effect(CE_PAINKILLER, min(30*volume, 80))
		M.add_chemical_effect(CE_PULSE, 1)
	else if(M.chem_doses[type] < 1)
		M.add_chemical_effect(CE_PAINKILLER, min(10*volume, 20))
	M.add_chemical_effect(CE_PULSE, 2)
	M.add_chemical_effect(CE_STIMULANT, 2)
	if(M.chem_doses[type] > 10)
		M.make_jittery(5)
	if(volume >= 5 && M.is_asystole())
		remove_self(5)
		if(M.resuscitate())
			var/obj/item/organ/internal/heart = M.internal_organs_by_name[BP_HEART]
			heart.take_internal_damage(heart.max_damage * 0.15)

/datum/reagent/lactate
	name = "Lactate"
	description = "Lactate is produced by the body during strenuous exercise. It often correlates with elevated heart rate, shortness of breath, and general exhaustion."
	taste_description = "sourness"
	reagent_state = LIQUID
	color = "#eeddcc"
	scannable = 1
	overdose = REAGENTS_OVERDOSE
	metabolism = REM

	codex_mechanics = "<p>Lactate is a hormone naturally produced by the body during strenuous excercise. Its effects include:</p>\
		<ul>\
			<li>Has no effect on Diona.</li>\
			<li>Increased heart rate.</li>\
			<li>Minor difficult breathing.</li>\
			<li>Reduced reaction speed.</li>\
			<li>Jitteryness.</li>\
		</ul>\
		<p>Overdose effects include toxin damage.</p>"

/datum/reagent/lactate/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return

	M.add_chemical_effect(CE_PULSE, 1)
	M.add_chemical_effect(CE_BREATHLOSS, 0.02 * volume)
	if(volume >= 5)
		M.add_chemical_effect(CE_PULSE, 1)
		M.add_chemical_effect(CE_SLOWDOWN, (volume/5) ** 2)
	else if(M.chem_doses[type] > 20) //after prolonged exertion
		M.make_jittery(10)

/datum/reagent/nanoblood
	name = "Nanoblood"
	description = "A stable hemoglobin-based nanoparticle oxygen carrier, used to rapidly replace lost blood. Toxic unless injected in small doses. Does not contain white blood cells."
	taste_description = "blood with bubbles"
	reagent_state = LIQUID
	color = "#c10158"
	scannable = 1
	overdose = 5
	metabolism = 1

	codex_mechanics = "<p>Nanoblood is a blood substitute used in IV bags to replenish blood supply. Its effects include:</p>\
		<ul>\
			<li>Has no effect on creatures that don't normally have hearts.</li>\
			<li>Regenates blood supply.</li>\
			<li>Reduces immunity.</li>\
		</ul>\
		<p>Due to its low overdose threshhold, it should only be used in IV bags.</p>\
		<p>Can be ordered from supply.</p>\
		<p>Overdose effects include toxin damage.</p>"

/datum/reagent/nanoblood/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed)
	if(!M.should_have_organ(BP_HEART)) //We want the var for safety but we can do without the actual blood.
		return
	if(M.regenerate_blood(4 * removed))
		M.immunity = max(M.immunity - 0.1, 0)
		if(M.chem_doses[type] > M.species.blood_volume/8) //half of blood was replaced with us, rip white bodies
			M.immunity = max(M.immunity - 0.5, 0)

// Sleeping agent, produced by breathing N2O.
/datum/reagent/nitrous_oxide
	name = "Nitrous Oxide"
	description = "An ubiquitous sleeping agent also known as laughing gas."
	taste_description = "dental surgery"
	reagent_state = LIQUID
	color = COLOR_GRAY80
	metabolism = 0.05 // So that low dosages have a chance to build up in the body.
	var/do_giggle = TRUE

/datum/reagent/nitrous_oxide/xenon
	name = "Xenon"
	description = "A nontoxic gas used as a general anaesthetic."
	do_giggle = FALSE
	taste_description = "nothing"
	color = COLOR_GRAY80

/datum/reagent/nitrous_oxide/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	var/dosage = M.chem_doses[type]
	if(dosage >= 1)
		if(prob(5)) M.Sleeping(3)
		M.dizziness =  max(M.dizziness, 3)
		M.confused =   max(M.confused, 3)
	if(dosage >= 0.3)
		if(prob(5)) M.Paralyse(1)
		M.drowsyness = max(M.drowsyness, 3)
		M.slurring =   max(M.slurring, 3)
	if(do_giggle && prob(20))
		M.emote(pick("giggle", "laugh"))
	M.add_chemical_effect(CE_PULSE, -1)


	// Immunity-restoring reagent
/datum/reagent/immunobooster
	name = "Immunobooster"
	description = "A drug that helps restore the immune system. Will not replace a normal immunity."
	taste_description = "chalky"
	reagent_state = LIQUID
	color = "#ffc0cb"
	metabolism = REM
	overdose = REAGENTS_OVERDOSE
	value = 1.5
	scannable = 1

	codex_mechanics = "<p>Immunoboosters are used to temporarily boost the immune system. Effects include:</p>\
		<ul>\
			<li>Has no effect on Diona.</li>\
			<li>Temporarily boosts immunity to half of the person's max permanent immunity.</li>\
			<li>If combined with spaceacillin, the above effect is lost and it instead causes severe toxin damage.</li>\
		</ul>\
		<p>Does not repair a fully compromised immune system.</p>\
		<p>Overdose effects include toxin damage and loss of immunity boosting benefits.</p>"
	codex_antag = "<p>If combined with spaceacillin, makes for an effective poison.</p>"

/datum/reagent/immunobooster/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(volume < REAGENTS_OVERDOSE && !M.chem_effects[CE_ANTIVIRAL])
		M.immunity = min(M.immunity_norm * 0.5, removed + M.immunity) // Rapidly brings someone up to half immunity.
	if(M.chem_effects[CE_ANTIVIRAL]) //don't take with 'cillin
		M.add_chemical_effect(CE_TOXIN, 4) // as strong as taking vanilla 'toxin'


/datum/reagent/immunobooster/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.add_chemical_effect(CE_TOXIN, 1)
	M.immunity -= 0.5 //inverse effects when abused
