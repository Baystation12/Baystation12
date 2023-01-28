/datum/power/changeling/absorb_dna
	name = "Absorb DNA"
	desc = "Permits us to syphon the DNA from a human. They become one with us, and we become stronger if they were of our kind."
	ability_icon_state = "ling_absorb_dna"
	genomecost = 0
	power_category = CHANGELING_POWER_INHERENT
	verbpath = /mob/living/proc/changeling_absorb_dna

//Absorbs the victim's DNA. Requires a strong grip on the victim.
//Doesn't cost anything as it's the most basic ability.
/mob/living/proc/changeling_absorb_dna(mob/living/carbon/M)
	set category = "Changeling"
	set name = "Absorb DNA"

	var/datum/changeling/changeling = changeling_power(0,0,100)
	if(!changeling)	return

	var/obj/item/grab/G = src.get_active_hand()
	if(!istype(G))
		to_chat(src, "<span class='warning'>We must be grabbing a creature in our active hand to absorb them.</span>")
		return

	var/mob/living/carbon/human/T = G.affecting
	if(!istype(T) || T.isSynthetic())
		to_chat(src, "<span class='warning'>\The [T] is not compatible with our biology.</span>")
		return

	if(MUTATION_HUSK in T.mutations) //Lings can always absorb other lings, unless someone beat them to it first.
		if(!T.mind.changeling || T.mind.changeling && T.mind.changeling.geneticpoints < 0)
			to_chat(src, "<span class='warning'>This creature's DNA is ruined beyond useability!</span>")
			return

	if(!G.force_danger())
		to_chat(src, "<span class='warning'>We must have a tighter grip to absorb this creature.</span>")
		return

	if(changeling.isabsorbing)
		to_chat(src, "<span class='warning'>We are already absorbing!</span>")
		return

	changeling.isabsorbing = 1
	for(var/stage = 1, stage<=3, stage++)
		switch(stage)
			if(1)
				to_chat(src, "<span class='notice'>This creature is compatible. We must hold still...</span>")
			if(2)
				to_chat(src, "<span class='notice'>We extend a proboscis.</span>")
				src.visible_message("<span class='warning'>[src] extends a proboscis!</span>")
			if(3)
				to_chat(src, "<span class='notice'>We stab [T] with the proboscis.</span>")
				src.visible_message("<span class='danger'>[src] stabs [T] with the proboscis!</span>")
				to_chat(T, "<span class='danger'>You feel a sharp stabbing pain!</span>")
				admin_attack_log(src,T,"Absorbed (changeling)")
				var/obj/item/organ/external/affecting = T.get_organ(src.zone_sel.selecting)
				if(affecting.receive_damage(39,0,1,0,"large organic needle"))
					T:UpdateDamageIcon()

		if(!do_mob(src, T, 150) || !G.force_danger())
			to_chat(src, "<span class='warning'>Our absorption of [T] has been interrupted!</span>")
			changeling.isabsorbing = 0
			return

	to_chat(src, "<span class='notice'>We have absorbed [T]!</span>")
	src.visible_message("<span class='danger'>[src] sucks the fluids from [T]!</span>")
	to_chat(T, "<span class='danger'>You have been absorbed by the changeling!</span>")
	M.adjust_nutrition(T.nutrition)
	changeling.chem_charges += 10
	if(changeling.readapts <= 0)
		changeling.readapts = 0 //SANITYYYYYY
	changeling.readapts++
	if(changeling.readapts > changeling.max_readapts)
		changeling.readapts = changeling.max_readapts

	to_chat(src, "<span class='notice'>We can now re-adapt, reverting our evolution so that we may start anew, if needed.</span>")

	var/datum/absorbed_dna/newDNA = new(T.real_name, T.dna, T.species.name, T.languages, T.gender, T.flavor_texts, T.modifiers)
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
				changeling.geneticpoints += 4
				changeling.max_geneticpoints += 4

		to_chat(src, "<span class='notice'>We absorbed another changeling, and we grow stronger.  Our genomes increase.</span>")

		T.mind.changeling.chem_charges = 0
		T.mind.changeling.geneticpoints = -1
		T.mind.changeling.max_geneticpoints = -1 //To prevent revival.
		T.mind.changeling.absorbedcount = 0
		T.mind.changeling.lingabsorbedcount = 0

	changeling.absorbedcount++
	changeling.isabsorbing = 0

	T.death(0)
	T.Drain()
	return TRUE
