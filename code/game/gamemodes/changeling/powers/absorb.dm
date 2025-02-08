/datum/power/changeling/absorb_dna
	name = "Absorb DNA"
	desc = "Permits us to syphon the DNA from a human. They become one with us, and we become stronger if they were of our kind. Emboldens our core, so that it may help us."
	ability_icon_state = "ling_absorb_dna"
	genomecost = 0
	power_category = CHANGELING_POWER_INHERENT
	verbpath = /mob/living/proc/changeling_absorb_dna

/**
 * Absorbs the victim's DNA. Requires a strong grip on the victim.
 * Doesn't cost anything as it's the most basic ability.
 */
/mob/proc/toggle_absorb_type()
	set category = "Changeling"
	set name = "Toggle Absorb Type"
	set desc = "Allows us to determine whether we wish to kill targets we absorb."
	if(src.mind.changeling)
		if(src.mind.changeling.absorbing_lethally == ABSORB_NONLETHAL)
			to_chat(src,SPAN_INFO("We will now kill creatures whose DNA we sample."))
			src.mind.changeling.absorbing_lethally = ABSORB_LETHAL
			return
		if(src.mind.changeling.absorbing_lethally == ABSORB_LETHAL)
			to_chat(src,SPAN_INFO("We will no longer kill creatures whose DNA we sample."))
			src.mind.changeling.absorbing_lethally = ABSORB_NONLETHAL
			return

/mob/living/proc/changeling_absorb_dna(mob/living/carbon/M)
	set category = "Changeling"
	set name = "Absorb DNA"
	var/list/names = list()

	var/datum/changeling/changeling = changeling_power(0,0,100)
	if(!changeling)	return

	var/obj/item/grab/G = src.get_active_hand()
	if(!istype(G))
		to_chat(src, SPAN_WARNING("We must be grabbing a creature in our active hand to absorb them."))
		return

	var/mob/living/carbon/human/T = G.affecting
	if (G.affecting.species == SPECIES_DIONA)
		to_chat(src, SPAN_WARNING("Its form is unknown to our manifestation. We can't find their DNA to be compatible."))
		return
	for(var/datum/absorbed_dna/DNA in changeling.absorbed_dna)
		names += "[DNA.name]"
	if(T.real_name in names)
		to_chat(src,SPAN_NOTICE("We have already sampled the DNA of this creature. There is nothing further to learn here."))
		return
	if(T == src)
		to_chat(src,SPAN_WARNING("We would have to be very silly to try absorbing ourselves."))
		return
	if(!istype(T) || T.isSynthetic() || (T.get_species() in changeling.species_blacklist))
		to_chat(src, SPAN_WARNING("\The [T] is not compatible with our biology."))
		return

	if(MUTATION_HUSK in T.mutations) //Lings can always absorb other lings, unless someone beat them to it first.
		if(!T.mind.changeling || T.mind.changeling && T.mind.changeling.geneticpoints < 0)
			to_chat(src, SPAN_WARNING("This creature's DNA is ruined beyond useability!"))
			return

	if(!G.force_danger())
		to_chat(src, SPAN_WARNING("We must have a tighter grip to absorb this creature."))
		return

	if(changeling.isabsorbing)
		to_chat(src, SPAN_WARNING("We are already absorbing!"))
		return

	changeling.isabsorbing = TRUE
	for(var/stage = 1, stage<=3, stage++)
		switch(stage)
			if(1)
				to_chat(src, SPAN_NOTICE("This creature is compatible. We must hold still.."))
			if(2)
				to_chat(src, SPAN_NOTICE("We extend a proboscis."))
				src.visible_message(SPAN_WARNING("[src] extends a proboscis!"))
			if(3)
				to_chat(src, SPAN_NOTICE("We stab [T] with the proboscis."))
				src.visible_message(SPAN_DANGER("[src] stabs [T] with the proboscis!"))
				to_chat(T, SPAN_DANGER("You feel a sharp stabbing pain!"))
				admin_attack_log(src,T,"Absorbed (changeling)")
				var/obj/item/organ/external/affecting = T.get_organ(src.zone_sel.selecting)
				T.apply_damage(50, DAMAGE_BRUTE, affecting , damage_flags = DAMAGE_FLAG_SHARP, used_weapon="organic needle", armor_pen=50)

		if(!do_mob(src, T, 150, progress= TRUE) || !G.force_danger())
			to_chat(src, SPAN_WARNING("Our absorption of the DNA of \the [T] has been interrupted!"))
			changeling.isabsorbing = FALSE
			return

	to_chat(src, SPAN_NOTICE("We have absorbed the DNA of \the [T]!"))
	changeling.chem_charges += 10

	var/mob/living/carbon/ling = src
	for (var/obj/item/organ/internal/augment/lingcore/core in ling.internal_organs)
		if (core.stasiscount < 2)
			to_chat(ling, SPAN_NOTICE("Our core feels emboldened. We can once again count on its help. Stasis now has [core.stasiscount] charges."))
			core.stasiscount++ // Can stasis again.

	// Add pronouns to this line.
	var/datum/absorbed_dna/newDNA = new(T.real_name, T.dna, T.species.name, T.languages, T.gender, T.pronouns, T.flavor_texts, T.icon_render_keys, T.descriptors)
	absorbDNA(newDNA)

	if(T.mind && T.mind.changeling)
		if(T.mind.changeling.absorbed_dna)
			for(var/datum/absorbed_dna/dna_data in T.mind.changeling.absorbed_dna)	//steal all their loot
				if(dna_data in changeling.absorbed_dna)
					continue
				absorbDNA(dna_data)
				changeling.absorbedcount++
			LIST_RESIZE(T.mind.changeling.absorbed_dna, 1)

		// This is where lings get boosts from eating eachother
		if(T.mind.changeling.lingabsorbedcount)
			for(var/a = 1 to T.mind.changeling.lingabsorbedcount)
				changeling.lingabsorbedcount++
				changeling.geneticpoints += 6
				changeling.max_geneticpoints += 6

		to_chat(src, SPAN_NOTICE("We have feasted upon a fellow changeling, and grown stronger."))

		T.mind.changeling.chem_charges = 0
		T.mind.changeling.geneticpoints = -1
		T.mind.changeling.max_geneticpoints = -1 //To prevent revival.
		T.mind.changeling.absorbedcount = 0
		T.mind.changeling.lingabsorbedcount = 0
		T.death(0)
		T.Drain()
		return TRUE
	changeling.absorbedcount++
	changeling.isabsorbing = FALSE
	to_chat(T, SPAN_DANGER("You feel everything go black, as \the [src] releases you."))
	if(changeling.absorbing_lethally == ABSORB_LETHAL)
		T.death(0)
		T.Drain()
		changeling.geneticpoints += 1
		changeling.max_geneticpoints += 1
	if(changeling.absorbing_lethally == ABSORB_NONLETHAL)
		changeling.geneticpoints += 2
		changeling.max_geneticpoints += 2
		T.Sleeping(200)
	return TRUE
