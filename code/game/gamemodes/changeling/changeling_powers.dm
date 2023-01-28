
var/global/list/possible_changeling_IDs = list("Alpha","Beta","Gamma","Delta","Epsilon","Zeta","Eta","Theta","Iota","Kappa","Lambda","Mu","Nu","Xi","Omicron","Pi","Rho","Sigma","Tau","Upsilon","Phi","Chi","Psi","Omega")

/datum/changeling //stores changeling powers, changeling recharge thingie, changeling absorbed DNA and changeling ID (for changeling hivemind)
	var/list/datum/absorbed_dna/absorbed_dna = list()
	var/list/absorbed_languages = list() // Necessary because of set_species stuff
	var/absorbedcount = 0
	var/lingabsorbedcount = 1	//Starts at one, because that's us
	var/chem_charges = 20
	var/chem_recharge_rate = 0.5
	var/chem_storage = 50
	var/sting_range = 1
	var/changelingID = "Changeling"
	var/geneticdamage = 0
	var/isabsorbing = 0
	var/geneticpoints = 15
	var/max_geneticpoints = 15
	var/list/purchased_powers = list()
	var/list/purchased_organs = list()
	var/already_regenerating = FALSE
	var/mimicing = ""
	var/cloaked = 0
	var/absorbing_lethally = ABSORB_NONLETHAL
	var/selected_ranged_sting = null;
	var/tendons_reinforced = FALSE;
	var/list/toxin_victims = list()
	var/armor_deployed = 0 //This is only used for changeling_generic_equip_all_slots() at the moment.
	var/recursive_enhancement = 0 //Used to power up other abilities from the ling power with the same name.
	var/list/purchased_powers_history = list() //Used for round-end report, includes respec uses too.
	var/last_shriek = null // world.time when the ling last used a shriek.
	var/next_escape = 0	// world.time when the ling can next use Escape Restraints
	var/thermal_sight = FALSE	// Is our Vision Augmented? With thermals?
	var/last_human_form = null
/datum/changeling/New(gender=FEMALE)
	..()
	if(length(possible_changeling_IDs))
		changelingID = pick(possible_changeling_IDs)
		possible_changeling_IDs -= changelingID
		changelingID = "[changelingID]"
	else
		changelingID = "[rand(1,999)]"

/datum/changeling/proc/regenerate()
	chem_charges = min(max(0, chem_charges+chem_recharge_rate), chem_storage)
	geneticdamage = max(0, geneticdamage-1)

/datum/changeling/proc/GetDNA(dna_owner)
	for(var/datum/absorbed_dna/DNA in absorbed_dna)
		if(dna_owner == DNA.name)
			return DNA

/mob/proc/absorbDNA(datum/absorbed_dna/newDNA)
	var/datum/changeling/changeling = null
	if(src.mind && src.mind.changeling)
		changeling = src.mind.changeling
	if(!changeling)
		return

	for(var/language in newDNA.languages)
		changeling.absorbed_languages |= language

	changeling_update_languages(changeling.absorbed_languages)

	if(!changeling.GetDNA(newDNA.name)) // Don't duplicate - I wonder if it's possible for it to still be a different DNA? DNA code could use a rewrite
		changeling.absorbed_dna += newDNA
//ling creation, add unique organ here
//Restores our verbs. It will only restore verbs allowed during lesser (monkey) form if we are not human
/mob/proc/make_changeling()

	if(!mind)				return
	if(!mind.changeling)	mind.changeling = new /datum/changeling(gender)

	verbs.Add(/datum/changeling/proc/EvolutionTree)
	verbs.Add(/mob/proc/toggle_absorb_type)
	add_language("Changeling")

	var/lesser_form = !ishuman(src)
	var/has_core = FALSE
	if(!length(GLOB.powerinstances))
		for(var/P in powers)
			GLOB.powerinstances += new P()

	// Code to auto-purchase free powers.
	for(var/datum/power/changeling/P in GLOB.powerinstances)
		if(!P.genomecost) // Is it free?
			if(!(P in mind.changeling.purchased_powers)) // Do we not have it already?
				mind.changeling.purchased_powers += P /// Add it.
				mind.changeling.purchasePower(mind, P, 0)// Purchase it. Don't remake our verbs, we're doing it after this.

	for(var/datum/power/changeling/P in mind.changeling.purchased_powers)
		if(P.isVerb)
			if(lesser_form && !P.allowduringlesserform)	continue
			if(!(P in src.verbs))
				verbs.Add(P.verbpath)
			if(P.make_hud_button)
				if(!src.ability_master)
					src.ability_master = new /obj/screen/movable/ability_master(null, src)
				src.ability_master.add_ling_ability(
					object_given = src,
					verb_given = P.verbpath,
					name_given = P.name,
					ability_icon_given = P.ability_icon_state,
					arguments = list()
					)

	for(var/language in languages)
		mind.changeling.absorbed_languages |= language



	var/mob/living/carbon/human/H = src
	if(istype(H))
		var/saved_dna = H.dna.Clone() /// Prevent transform from breaking.
		var/datum/absorbed_dna/newDNA = new(H.real_name, saved_dna, H.species.name, H.languages, H.gender, H.pronouns, H.flavor_texts, H.icon_render_keys, H.descriptors)
		absorbDNA(newDNA)
	for(var/obj/item/organ/internal/augment/lingcore/C in H.internal_organs)
		has_core++
	if(has_core == 0 && istype(src,/mob/living/carbon/human))
		var/obj/item/organ/external/chest = H.get_organ(BP_CHEST)
		var/obj/item/organ/internal/augment/core = new /obj/item/organ/internal/augment/lingcore
		core.forceMove(src)
		core.replaced(src, chest)
		core = null
	var/obj/item/organ/external/parent = H.get_organ(BP_CHEST)
	var/obj/item/organ/internal/brain/mbrain = H.internal_organs_by_name[BP_BRAIN]
	mbrain.parent_organ = BP_CHEST
	mbrain.forceMove(parent)
	var/obj/item/organ/external/head = H.get_organ(BP_HEAD)
	for(var/obj/item/organ/internal/I in head.internal_organs)
		if(istype(I,/obj/item/organ/internal/brain))
			head.internal_organs.Remove(I)
	return 1

//removes our changeling verbs
/mob/proc/remove_changeling_powers()
	if(!mind || !mind.changeling)	return
	for(var/datum/power/changeling/P in mind.changeling.purchased_powers)
		if(P.isVerb)
			verbs.Remove(P.verbpath)
			var/obj/screen/ability/verb_based/changeling/C = ability_master.get_ability_by_proc_ref(P.verbpath)
			if(C)
				ability_master.remove_ability(C)


//Helper proc. Does all the checks and stuff for us to avoid copypasta
/mob/proc/changeling_power(required_chems=0, required_dna=0, max_genetic_damage=100, max_stat=0)

	if(!src.mind)		return
	if(!iscarbon(src))	return

	var/datum/changeling/changeling = src.mind.changeling
	if(!changeling)
		to_world_log("[src] has the changeling_transform() verb but is not a changeling.")
		return

	if(src.stat > max_stat)
		to_chat(src, "<span class='warning'>We are incapacitated.</span>")
		return

	if(length(changeling.absorbed_dna) < required_dna)
		to_chat(src, "<span class='warning'>We require at least [required_dna] samples of compatible DNA.</span>")
		return

	if(changeling.chem_charges < required_chems)
		to_chat(src, "<span class='warning'>We require at least [required_chems] units of chemicals to do that!</span>")
		return

	if(changeling.geneticdamage > max_genetic_damage)
		to_chat(src, "<span class='warning'>Our genomes are still reassembling. We need time to recover first.</span>")
		return

	return changeling

//Used to dump the languages from the changeling datum into the actual mob.
/mob/proc/changeling_update_languages(updated_languages)
	languages = list()
	for(var/language in updated_languages)
		languages += language

	//This isn't strictly necessary but just to be safe...
	add_language("Changeling")

	//////////
	//STINGS//	//They get a pretty header because there's just so fucking many of them ;_;
	//////////

/turf/proc/AdjacentTurfsRangedSting()
	//Yes this is snowflakey, but I couldn't get it to work any other way.. -Luke
	var/list/allowed = list(
		/obj/structure/table,
		/obj/structure/closet,
		/obj/structure/cable,
		/obj/structure/disposalpipe,
		/obj/machinery,
		/mob
	)

	var/L[] = new()
	for(var/turf/simulated/t in oview(src,1))
		var/add = 1
		if(t.density)
			add = 0
		if(add && LinkBlocked(src,t))
			add = 0
		if(add && TurfBlockedNonWindow(t))
			add = 0
		for(var/obj/O in t)
			if(O.density)
				add = 0
				break
			if(istype(O, /obj/machinery/door))
				//not sure why this doesn't fire on LinkBlocked()
				add = 0
				break
			for(var/type in allowed)
				if (istype(O, type))
					add = 1
					break
			if(!add)
				break
		if(add)
			L.Add(t)
	return L


/mob/proc/sting_can_reach(mob/M as mob, sting_range = 1)
	if(M.loc == src.loc)
		return 1 //target and source are in the same thing
	if(!isturf(src.loc) || !isturf(M.loc))
		to_chat(src, "<span class='warning'>We cannot reach \the [M] with a sting!</span>")
		return 0 //One is inside, the other is outside something.
	// Maximum queued turfs set to 25; I don't *think* anything raises sting_range above 2, but if it does the 25 may need raising
	if(!AStar(src.loc, M.loc, /turf/proc/AdjacentTurfsRangedSting, /turf/proc/Distance, max_nodes=25, max_node_depth=sting_range)) //If we can't find a path, fail
		to_chat(src, "<span class='warning'>We cannot find a path to sting \the [M] by!</span>")
		return 0
	return 1

//Handles the general sting code to reduce on copypasta (seeming as somebody decided to make SO MANY dumb abilities)
/mob/proc/changeling_sting(required_chems=0, verb_path)
	var/datum/changeling/changeling = changeling_power(required_chems)
	var/mob/living/carbon/human/ling = src
	if(!changeling)								return

	var/list/victims = list()
	for(var/mob/living/carbon/C in oview(changeling.sting_range))
		victims += C
	var/mob/living/carbon/T = input(src, "Who will we sting?") as null|anything in victims

	if(!T)
		return
	if(T.isSynthetic())
		to_chat(src, "<span class='notice'>We are unable to pierce the outer shell of [T].</span>")
		return
	if(!(T in view(changeling.sting_range))) return
	if(!sting_can_reach(T, changeling.sting_range)) return
	if(!changeling_power(required_chems)) return

	if(!(T.can_inject(ling,ling.zone_sel.selecting, FALSE) == CAN_INJECT))
		to_chat(src,SPAN_WARNING("We are unable to pierce the thick material covering [T]."))
		return
	changeling.chem_charges -= required_chems
	changeling.sting_range = 1
	src.verbs -= verb_path
	spawn(10)	src.verbs += verb_path

	to_chat(src, "<span class='notice'>We stealthily sting [T].</span>")
	if(!T.mind || !T.mind.changeling)	return T	//T will be affected by the sting
	to_chat(T, "<span class='warning'>You feel a tiny prick.</span>")
	return
