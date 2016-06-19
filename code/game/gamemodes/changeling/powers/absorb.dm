/datum/power/changeling/absorb_dna
	name = "Absorb DNA"
	desc = "Permits us to syphon the DNA from a human. They become one with us, and we become stronger if they were of our kind."
	genomecost = 0
	verbpath = /mob/living/carbon/proc/changeling_absorb_dna

//Absorbs the victim's DNA. Requires a strong grip on the victim.
//Doesn't cost anything as it's the most basic ability.
/mob/living/carbon/proc/changeling_absorb_dna()
	set category = "Changeling"
	set name = "Absorb DNA"

	var/datum/changeling/changeling = changeling_power(0,0,100)
	if(!changeling)	return

	var/obj/item/weapon/grab/G = src.get_active_hand()
	if(!istype(G))
		src << "<span class='warning'>We must be grabbing a creature in our active hand to absorb them.</span>"
		return

	var/mob/living/carbon/human/T = G.affecting
	if(!istype(T) || T.isSynthetic())
		src << "<span class='warning'>\The [T] is not compatible with our biology.</span>"
		return

	if(T.species.flags & NO_SCAN)
		src << "<span class='warning'>We do not know how to parse this creature's DNA!</span>"
		return

	if(HUSK in T.mutations) //Lings can always absorb other lings, unless someone beat them to it first.
		if(!T.mind.changeling || T.mind.changeling && T.mind.changeling.geneticpoints < 0)
			src << "<span class='warning'>This creature's DNA is ruined beyond useability!</span>"
			return

	if(G.state != GRAB_KILL)
		src << "<span class='warning'>We must have a tighter grip to absorb this creature.</span>"
		return

	if(changeling.isabsorbing)
		src << "<span class='warning'>We are already absorbing!</span>"
		return

	changeling.isabsorbing = 1
	for(var/stage = 1, stage<=3, stage++)
		switch(stage)
			if(1)
				src << "<span class='notice'>This creature is compatible. We must hold still...</span>"
			if(2)
				src << "<span class='notice'>We extend a proboscis.</span>"
				src.visible_message("<span class='warning'>[src] extends a proboscis!</span>")
			if(3)
				src << "<span class='notice'>We stab [T] with the proboscis.</span>"
				src.visible_message("<span class='danger'>[src] stabs [T] with the proboscis!</span>")
				T << "<span class='danger'>You feel a sharp stabbing pain!</span>"
				var/obj/item/organ/external/affecting = T.get_organ(src.zone_sel.selecting)
				if(affecting.take_damage(39,0,1,0,"large organic needle"))
					T:UpdateDamageIcon()

		feedback_add_details("changeling_powers","A[stage]")
		if(!do_mob(src, T, 150))
			src << "<span class='warning'>Our absorption of [T] has been interrupted!</span>"
			changeling.isabsorbing = 0
			return

	src << "<span class='notice'>We have absorbed [T]!</span>"
	src.visible_message("<span class='danger'>[src] sucks the fluids from [T]!</span>")
	T << "<span class='danger'>You have been absorbed by the changeling!</span>"

	if(src.nutrition < 400)
		src.nutrition = min((src.nutrition + T.nutrition), 400)
	changeling.chem_charges += 10

	src.verbs += /mob/proc/changeling_respec
	src << "<span class='notice'>We can now re-adapt, reverting our evolution so that we may start anew, if needed.</span>"

	var/datum/absorbed_dna/newDNA = new(T)
	absorbDNA(newDNA)

	if(T.mind && T.mind.changeling)
		if(T.mind.changeling.absorbed_dna)
			for(var/datum/absorbed_dna/dna_data in T.mind.changeling.absorbed_dna)	//steal all their loot
				if(dna_data in changeling.absorbed_dna)
					continue
				absorbDNA(dna_data)
				changeling.absorbedcount++
			T.mind.changeling.absorbed_dna.len = 1

		changeling.geneticpoints += 5
		changeling.max_geneticpoints += 5
		src << "<span class='notice'>We absorbed another changeling, and we grow stronger.  Our genomes increase.</span>"

		T.mind.changeling.chem_charges = 0
		T.mind.changeling.geneticpoints = -1
		T.mind.changeling.max_geneticpoints = -1 //To prevent revival.
		T.mind.changeling.absorbedcount = 0

	changeling.absorbedcount++
	changeling.isabsorbing = 0

	T.death(0)
	T.Drain()
	return 1
