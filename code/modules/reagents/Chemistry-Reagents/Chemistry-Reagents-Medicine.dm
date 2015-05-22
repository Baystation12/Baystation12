/datum/reagent/inaprovaline
	name = "Inaprovaline"
	id = "inaprovaline"
	description = "Inaprovaline is a synaptic stimulant and cardiostimulant. Commonly used to stabilize patients."
	reagent_state = LIQUID
	color = "#00BFFF" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE*2
	scannable = 1

/datum/reagent/inaprovaline/on_mob_life(var/mob/living/M as mob, var/alien)
	if(!M) M = holder.my_atom

	if(alien && alien == IS_VOX)
		M.adjustToxLoss(REAGENTS_METABOLISM)
	else
		if(M.losebreath >= 10)
			M.losebreath = max(10, M.losebreath-5)

	holder.remove_reagent(src.id, 0.5 * REAGENTS_METABOLISM)
	return

/datum/reagent/bicaridine
	name = "Bicaridine"
	id = "bicaridine"
	description = "Bicaridine is an analgesic medication and can be used to treat blunt trauma."
	reagent_state = LIQUID
	color = "#BF0000" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/bicaridine/on_mob_life(var/mob/living/M as mob, var/alien)
	if(M.stat == 2.0)
		return
	if(!M) M = holder.my_atom
	if(alien != IS_DIONA)
		M.heal_organ_damage(2*REM,0)
	..()
	return

/datum/reagent/kelotane
	name = "Kelotane"
	id = "kelotane"
	description = "Kelotane is a drug used to treat burns."
	reagent_state = LIQUID
	color = "#FFA800" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/kelotane/on_mob_life(var/mob/living/M as mob)
	if(M.stat == 2.0)
		return
	if(!M) M = holder.my_atom
	//This needs a diona check but if one is added they won't be able to heal burn damage at all.
	M.heal_organ_damage(0,2*REM)
	..()
	return

/datum/reagent/dermaline
	name = "Dermaline"
	id = "dermaline"
	description = "Dermaline is the next step in burn medication. Works twice as good as kelotane and enables the body to restore even the direst heat-damaged tissue."
	reagent_state = LIQUID
	color = "#FF8000" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE/2
	scannable = 1

/datum/reagent/dermaline/on_mob_life(var/mob/living/M as mob, var/alien)
	if(M.stat == 2.0) //THE GUY IS **DEAD**! BEREFT OF ALL LIFE HE RESTS IN PEACE etc etc. He does NOT metabolise shit anymore, god DAMN
		return
	if(!M) M = holder.my_atom
	if(!alien || alien != IS_DIONA)
		M.heal_organ_damage(0,3*REM)
	..()
	return

/datum/reagent/anti_toxin
	name = "Dylovene"
	id = "anti_toxin"
	description = "Dylovene is a broad-spectrum antitoxin."
	reagent_state = LIQUID
	color = "#00A000" // rgb: 200, 165, 220
	scannable = 1

/datum/reagent/anti_toxin/on_mob_life(var/mob/living/M as mob, var/alien)
	if(!M) M = holder.my_atom
	if(!alien || alien != IS_DIONA)
		M.reagents.remove_all_type(/datum/reagent/toxin, 1*REM, 0, 1)
		M.drowsyness = max(M.drowsyness-2*REM, 0)
		M.hallucination = max(0, M.hallucination - 5*REM)
		M.adjustToxLoss(-2*REM)
	..()
	return

/datum/reagent/dexalin
	name = "Dexalin"
	id = "dexalin"
	description = "Dexalin is used in the treatment of oxygen deprivation."
	reagent_state = LIQUID
	color = "#0080FF" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/dexalin/on_mob_life(var/mob/living/M as mob, var/alien)
	if(M.stat == 2.0)
		return  //See above, down and around. --Agouri
	if(!M) M = holder.my_atom

	if(alien && alien == IS_VOX)
		M.adjustToxLoss(2*REM)
	else if(!alien || alien != IS_DIONA)
		M.adjustOxyLoss(-2*REM)

	holder.remove_reagent("lexorin", 2*REM)
	..()
	return

/datum/reagent/dexalinp
	name = "Dexalin Plus"
	id = "dexalinp"
	description = "Dexalin Plus is used in the treatment of oxygen deprivation. It is highly effective."
	reagent_state = LIQUID
	color = "#0040FF" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE/2
	scannable = 1

/datum/reagent/dexalinp/on_mob_life(var/mob/living/M as mob, var/alien)
	if(M.stat == 2.0)
		return
	if(!M) M = holder.my_atom

	if(alien && alien == IS_VOX)
		M.adjustOxyLoss()
	else if(!alien || alien != IS_DIONA)
		M.adjustOxyLoss(-M.getOxyLoss())

	holder.remove_reagent("lexorin", 2*REM)
	..()
	return

/datum/reagent/tricordrazine
	name = "Tricordrazine"
	id = "tricordrazine"
	description = "Tricordrazine is a highly potent stimulant, originally derived from cordrazine. Can be used to treat a wide range of injuries."
	reagent_state = LIQUID
	color = "#8040FF" // rgb: 200, 165, 220
	scannable = 1

/datum/reagent/tricordrazine/on_mob_life(var/mob/living/M as mob, var/alien)
	if(M.stat == 2.0)
		return
	if(!M) M = holder.my_atom
	if(!alien || alien != IS_DIONA)
		if(M.getOxyLoss()) M.adjustOxyLoss(-1*REM)
		if(M.getBruteLoss() && prob(80)) M.heal_organ_damage(1*REM,0)
		if(M.getFireLoss() && prob(80)) M.heal_organ_damage(0,1*REM)
		if(M.getToxLoss() && prob(80)) M.adjustToxLoss(-1*REM)
	..()
	return

/datum/reagent/cryoxadone
	name = "Cryoxadone"
	id = "cryoxadone"
	description = "A chemical mixture with almost magical healing powers. Its main limitation is that the targets body temperature must be under 170K for it to metabolise correctly."
	reagent_state = LIQUID
	color = "#8080FF" // rgb: 200, 165, 220
	scannable = 1

/datum/reagent/cryoxadone/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(M.bodytemperature < 170)
		M.adjustCloneLoss(-1)
		M.adjustOxyLoss(-1)
		M.heal_organ_damage(1,1)
		M.adjustToxLoss(-1)
	..()
	return

/datum/reagent/clonexadone
	name = "Clonexadone"
	id = "clonexadone"
	description = "A liquid compound similar to that used in the cloning process. Can be used to 'finish' the cloning process when used in conjunction with a cryo tube."
	reagent_state = LIQUID
	color = "#80BFFF" // rgb: 200, 165, 220
	scannable = 1

/datum/reagent/clonexadone/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(M.bodytemperature < 170)
		M.adjustCloneLoss(-3)
		M.adjustOxyLoss(-3)
		M.heal_organ_damage(3,3)
		M.adjustToxLoss(-3)
	..()
	return

/datum/reagent/paracetamol
	name = "Paracetamol"
	id = "paracetamol"
	description = "Most probably know this as Tylenol, but this chemical is a mild, simple painkiller."
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = 60
	scannable = 1
	custom_metabolism = 0.025 // Lasts 10 minutes for 15 units

/datum/reagent/paracetamol/on_mob_life(var/mob/living/M as mob)
	if (volume > overdose)
		M.hallucination = max(M.hallucination, 2)
	..()
	return

/datum/reagent/tramadol
	name = "Tramadol"
	id = "tramadol"
	description = "A simple, yet effective painkiller."
	reagent_state = LIQUID
	color = "#CB68FC"
	overdose = 30
	scannable = 1
	custom_metabolism = 0.025 // Lasts 10 minutes for 15 units

/datum/reagent/tramadol/on_mob_life(var/mob/living/M as mob)
	if (volume > overdose)
		M.hallucination = max(M.hallucination, 2)
	..()
	return

/datum/reagent/oxycodone
	name = "Oxycodone"
	id = "oxycodone"
	description = "An effective and very addictive painkiller."
	reagent_state = LIQUID
	color = "#800080"
	overdose = 20
	custom_metabolism = 0.25 // Lasts 10 minutes for 15 units

/datum/reagent/oxycodone/on_mob_life(var/mob/living/M as mob)
	if (volume > overdose)
		M.druggy = max(M.druggy, 10)
		M.hallucination = max(M.hallucination, 3)
	..()
	return

/datum/reagent/synaptizine
	name = "Synaptizine"
	id = "synaptizine"
	description = "Synaptizine is used to treat various diseases."
	reagent_state = LIQUID
	color = "#99CCFF" // rgb: 200, 165, 220
	custom_metabolism = 0.01
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/synaptizine/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.drowsyness = max(M.drowsyness-5, 0)
	M.AdjustParalysis(-1)
	M.AdjustStunned(-1)
	M.AdjustWeakened(-1)
	holder.remove_reagent("mindbreaker", 5)
	M.hallucination = max(0, M.hallucination - 10)
	if(prob(60))	M.adjustToxLoss(1)
	..()
	return

/datum/reagent/alkysine
	name = "Alkysine"
	id = "alkysine"
	description = "Alkysine is a drug used to lessen the damage to neurological tissue after a catastrophic injury. Can heal brain tissue."
	reagent_state = LIQUID
	color = "#FFFF66" // rgb: 200, 165, 220
	custom_metabolism = 0.05
	overdose = REAGENTS_OVERDOSE
	scannable = 1
/datum/reagent/alkysine/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.adjustBrainLoss(-3*REM)
	..()
	return

/datum/reagent/imidazoline
	name = "Imidazoline"
	id = "imidazoline"
	description = "Heals eye damage"
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/imidazoline/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.eye_blurry = max(M.eye_blurry-5 , 0)
	M.eye_blind = max(M.eye_blind-5 , 0)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/eyes/E = H.internal_organs_by_name["eyes"]
		if(E && istype(E))
			if(E.damage > 0)
				E.damage = max(E.damage - 1, 0)
	..()
	return

/datum/reagent/peridaxon
	name = "Peridaxon"
	id = "peridaxon"
	description = "Used to encourage recovery of internal organs and nervous systems. Medicate cautiously."
	reagent_state = LIQUID
	color = "#561EC3" // rgb: 200, 165, 220
	overdose = 10
	scannable = 1

/datum/reagent/peridaxon/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(ishuman(M))
		var/mob/living/carbon/human/H = M

		//Peridaxon heals only non-robotic organs
		for(var/obj/item/organ/I in H.internal_organs)
			if((I.damage > 0) && (I.robotic != 2))
				I.damage = max(I.damage - 0.20, 0)
	..()
	return

/datum/reagent/ryetalyn
	name = "Ryetalyn"
	id = "ryetalyn"
	description = "Ryetalyn can cure all genetic abnomalities via a catalytic process."
	reagent_state = SOLID
	color = "#004000" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE

/datum/reagent/ryetalyn/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom

	var/needs_update = M.mutations.len > 0

	M.mutations = list()
	M.disabilities = 0
	M.sdisabilities = 0

	// Might need to update appearance for hulk etc.
	if(needs_update && ishuman(M))
		var/mob/living/carbon/human/H = M
		H.update_mutations()

	..()
	return

/datum/reagent/hyperzine
	name = "Hyperzine"
	id = "hyperzine"
	description = "Hyperzine is a highly effective, long lasting, muscle stimulant."
	reagent_state = LIQUID
	color = "#FF3300" // rgb: 200, 165, 220
	custom_metabolism = 0.03
	overdose = REAGENTS_OVERDOSE/2

/datum/reagent/hyperzine/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(prob(5)) M.emote(pick("twitch","blink_r","shiver"))
	..()
	return

/datum/reagent/ethylredoxrazine	// FUCK YOU, ALCOHOL
	name = "Ethylredoxrazine"
	id = "ethylredoxrazine"
	description = "A powerful oxidizer that reacts with ethanol."
	reagent_state = SOLID
	color = "#605048" // rgb: 96, 80, 72
	overdose = REAGENTS_OVERDOSE

/datum/reagent/ethylredoxrazine/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.dizziness = 0
	M.drowsyness = 0
	M.stuttering = 0
	M.confused = 0
	M.reagents.remove_all_type(/datum/reagent/ethanol, 1*REM, 0, 1)
	..()
	return

/datum/reagent/hyronalin
	name = "Hyronalin"
	id = "hyronalin"
	description = "Hyronalin is a medicinal drug used to counter the effect of radiation poisoning."
	reagent_state = LIQUID
	color = "#408000" // rgb: 200, 165, 220
	custom_metabolism = 0.05
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/hyronalin/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.radiation = max(M.radiation-3*REM,0)
	..()
	return

/datum/reagent/arithrazine
	name = "Arithrazine"
	id = "arithrazine"
	description = "Arithrazine is an unstable medication used for the most extreme cases of radiation poisoning."
	reagent_state = LIQUID
	color = "#008000" // rgb: 200, 165, 220
	custom_metabolism = 0.05
	overdose = REAGENTS_OVERDOSE

/datum/reagent/arithrazine/on_mob_life(var/mob/living/M as mob)
	if(M.stat == 2.0)
		return  //See above, down and around. --Agouri
	if(!M) M = holder.my_atom
	M.radiation = max(M.radiation-7*REM,0)
	M.adjustToxLoss(-1*REM)
	if(prob(15))
		M.take_organ_damage(1, 0)
	..()
	return

/datum/reagent/spaceacillin
	name = "Spaceacillin"
	id = "spaceacillin"
	description = "An all-purpose antiviral agent."
	reagent_state = LIQUID
	color = "#C1C1C1" // rgb: 200, 165, 220
	custom_metabolism = 0.01
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/spaceacillin/on_mob_life(var/mob/living/M as mob)
	..()
	return

/datum/reagent/sterilizine
	name = "Sterilizine"
	id = "sterilizine"
	description = "Sterilizes wounds in preparation for surgery."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220

	//makes you squeaky clean
/datum/reagent/sterilizine/reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
	if (method == TOUCH)
		M.germ_level -= min(volume*20, M.germ_level)

/datum/reagent/sterilizine/reaction_obj(var/obj/O, var/volume)
	O.germ_level -= min(volume*20, O.germ_level)

/datum/reagent/sterilizine/reaction_turf(var/turf/T, var/volume)
	T.germ_level -= min(volume*20, T.germ_level)

/*		reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
		src = null
		if (method==TOUCH)
			if(istype(M, /mob/living/carbon/human))
				if(M.health >= -100 && M.health <= 0)
					M.crit_op_stage = 0.0
		if (method==INGEST)
			usr << "Well, that was stupid."
			M.adjustToxLoss(3)
		return
	on_mob_life(var/mob/living/M as mob)
		if(!M) M = holder.my_atom
			M.radiation += 3
			..()
			return
*/

/datum/reagent/leporazine
	name = "Leporazine"
	id = "leporazine"
	description = "Leporazine can be use to stabilize an individuals body temperature."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/leporazine/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (40 * TEMPERATURE_DAMAGE_COEFFICIENT))
	else if(M.bodytemperature < 311)
		M.bodytemperature = min(310, M.bodytemperature + (40 * TEMPERATURE_DAMAGE_COEFFICIENT))
	..()
	return

#define ANTIDEPRESSANT_MESSAGE_DELAY 5*60*10

/datum/reagent/antidepressant/methylphenidate
	name = "Methylphenidate"
	id = "methylphenidate"
	description = "Improves the ability to concentrate."
	reagent_state = LIQUID
	color = "#BF80BF"
	custom_metabolism = 0.01
	data = 0

	on_mob_life(var/mob/living/M as mob)
		if(!M) M = holder.my_atom
		if(src.volume <= 0.1) if(data != -1)
			data = -1
			M << "\red You lose focus.."
		else
			if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
				data = world.time
				M << "\blue Your mind feels focused and undivided."
		..()
		return

/datum/chemical_reaction/methylphenidate
	name = "Methylphenidate"
	id = "methylphenidate"
	result = "methylphenidate"
	required_reagents = list("mindbreaker" = 1, "hydrogen" = 1)
	result_amount = 3

/datum/reagent/antidepressant/citalopram
	name = "Citalopram"
	id = "citalopram"
	description = "Stabilizes the mind a little."
	reagent_state = LIQUID
	color = "#FF80FF"
	custom_metabolism = 0.01
	data = 0

	on_mob_life(var/mob/living/M as mob)
		if(!M) M = holder.my_atom
		if(src.volume <= 0.1) if(data != -1)
			data = -1
			M << "\red Your mind feels a little less stable.."
		else
			if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
				data = world.time
				M << "\blue Your mind feels stable.. a little stable."
		..()
		return

/datum/chemical_reaction/citalopram
	name = "Citalopram"
	id = "citalopram"
	result = "citalopram"
	required_reagents = list("mindbreaker" = 1, "carbon" = 1)
	result_amount = 3


/datum/reagent/antidepressant/paroxetine
	name = "Paroxetine"
	id = "paroxetine"
	description = "Stabilizes the mind greatly, but has a chance of adverse effects."
	reagent_state = LIQUID
	color = "#FF80BF"
	custom_metabolism = 0.01
	data = 0

	on_mob_life(var/mob/living/M as mob)
		if(!M) M = holder.my_atom
		if(src.volume <= 0.1) if(data != -1)
			data = -1
			M << "\red Your mind feels much less stable.."
		else
			if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
				data = world.time
				if(prob(90))
					M << "\blue Your mind feels much more stable."
				else
					M << "\red Your mind breaks apart.."
					M.hallucination += 200
		..()
		return

/datum/chemical_reaction/paroxetine
	name = "Paroxetine"
	id = "paroxetine"
	result = "paroxetine"
	required_reagents = list("mindbreaker" = 1, "oxygen" = 1, "inaprovaline" = 1)
	result_amount = 3

/datum/reagent/rezadone
	name = "Rezadone"
	id = "rezadone"
	description = "A powder derived from fish toxin, this substance can effectively treat genetic damage in humanoids, though excessive consumption has side effects."
	reagent_state = SOLID
	color = "#669900" // rgb: 102, 153, 0
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/rezadone/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(!data) data = 1
	data++
	switch(data)
		if(1 to 15)
			M.adjustCloneLoss(-1)
			M.heal_organ_damage(1,1)
		if(15 to 35)
			M.adjustCloneLoss(-2)
			M.heal_organ_damage(2,1)
			M.status_flags &= ~DISFIGURED
		if(35 to INFINITY)
			M.adjustToxLoss(1)
			M.make_dizzy(5)
			M.make_jittery(5)

	..()
	return
