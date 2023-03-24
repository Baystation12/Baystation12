#define STATE_VERB 2 //for powers
#define STATE_STING 1
#define STATE_UPGRADE 0

//Restores our verbs. It will only restore verbs allowed during lesser (monkey) form if we are not human
/mob/proc/make_changeling()

	if(!mind)				return
	if(!mind.changeling)	mind.changeling = new /datum/changeling(gender)

	verbs += /datum/changeling/proc/EvolutionMenu
	add_language("Changeling")

	if(iscarbon(src))
		var/mob/living/carbon/C = src
		var/obj/item/organ/internal/brain/brain = C.internal_organs_by_name[BP_BRAIN]
		if(brain)
			brain.fake_brain = 1

	if(!powerinstances.len)
		for(var/P in powers)
			powerinstances += new P()

	// Code to auto-purchase free powers.
	for(var/datum/power/changeling/P in powerinstances)
		if(!P.genomecost) // Is it free?
			if(!(P in mind.changeling.purchasedpowers)) // Do we not have it already?
				mind.changeling.purchasePower(mind, P.name, 0)// Purchase it. Don't remake our verbs, we're doing it after this.

	for(var/datum/power/changeling/P in mind.changeling.purchasedpowers)
		switch(P.state)
			if(2) //verbs
				if(!ishuman(src) && !P.allowduringlesserform)
					continue
				if(!(P in src.verbs))
					src.verbs += P.verbpath
			if(1) //stings
				var/exists = 0
				for(var/obj/screen/ability/changeling/button in src.ability_master.ability_objects)
					if(P.name == button.name)
						exists = 1
				if(!exists)
					if(!ishuman(src) && !P.allowduringlesserform)
						continue
					ability_master.add_ling_ability(P.name, P.verbpath, P.icon_state)

	for(var/language in languages)
		mind.changeling.absorbed_languages |= language

	var/mob/living/carbon/human/H = src
	if(istype(H))
		var/datum/absorbed_dna/newDNA = new(H.real_name, H.dna, H.species.name, H.languages)
		absorbDNA(newDNA)
//[INF]
	for(var/mob/living/carbon/human/i in GLOB.human_mob_list)
		i.give_compatable_genome()
//[/INF]
	return 1

//removes our changeling verbs
/mob/proc/remove_changeling_powers()
	if(!mind || !mind.changeling)	return

	if(iscarbon(src))
		var/mob/living/carbon/C = src
		var/obj/item/organ/internal/brain/brain = C.internal_organs_by_name[BP_BRAIN]
		if(brain)
			brain.fake_brain = 0
/*
	for(var/datum/power/changeling/P in mind.changeling.purchasedpowers)
		if(P.isVerb)
			verbs -= P.verbpath
*/
	for(var/datum/power/changeling/P in mind.changeling.purchasedpowers)
		switch(P.state)
			if(2) //verbs
				verbs -= P.verbpath
			if(1) //stings
				ability_master.remove_all_abilities()
				ability_master.ability_objects.Cut()

	if(hud_used)
		ling_sting.icon_state = null
		ling_sting.invisibility = INVISIBILITY_ABSTRACT

//Helper proc. Does all the checks and stuff for us to avoid copypasta
/mob/proc/changeling_power(var/required_chems=0, var/required_dna=0, var/max_genetic_damage=100, var/max_stat=0)

	if(!src.mind)		return
	if(!iscarbon(src))	return

	var/datum/changeling/changeling = src.mind.changeling
	if(!changeling)
		to_world_log("[src] has the changeling_transform() verb but is not a changeling.")
		return

	if(src.stat > max_stat)
		to_chat(src, SPAN_LING("Мы обездвижены."))
		return

	if(changeling.absorbed_dna.len < required_dna)
		to_chat(src, SPAN_LING("Нам нужно [required_dna] образцов совместимых ДНКа."))
		return

	if(changeling.chem_charges < required_chems)
		to_chat(src, SPAN_LING("Нам нужно [required_chems] единиц химикатов для этого!"))
		return

	if(changeling.geneticdamage > max_genetic_damage)
		to_chat(src, SPAN_LING("Нам геном всё ещё перестраивается. Нужно время на регенерацию генетического урона."))
		return

	return changeling

/mob/proc/changeling_update_languages(var/updated_languages)

	languages = list()
	for(var/language in updated_languages)
		languages += language

	//This isn't strictly necessary but just to be safe...
	add_language("Changeling")

	return

/mob/proc/handle_changeling_transform(var/datum/absorbed_dna/chosen_dna)
	src.visible_message(SPAN_WARNING("[src] transforms!"))

	src.dna = chosen_dna.dna
	src.real_name = chosen_dna.name
	src.flavor_text = ""

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		var/newSpecies = chosen_dna.speciesName
		H.set_species(newSpecies,1)
		H.b_type = chosen_dna.dna.b_type
		H.sync_organ_dna()
//		H.flavor_texts = chosen_dna.flavour_texts ? chosen_dna.flavour_texts.Copy() : null

	domutcheck(src, null)
	src.UpdateAppearance()
	ability_master.open_ability_master() //fix for hud icons
