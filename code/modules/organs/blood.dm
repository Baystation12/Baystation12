/****************************************************
				BLOOD SYSTEM
****************************************************/

/mob/living/carbon/human/var/datum/reagents/vessel // Container for blood and BLOOD ONLY. Do not transfer other chems here.

//Initializes blood vessels
/mob/living/carbon/human/proc/make_blood()

	if(vessel)
		return

	vessel = new/datum/reagents(species.blood_volume, src)

	if(!should_have_organ(BP_HEART)) //We want the var for safety but we can do without the actual blood.
		return

	vessel.add_reagent(/datum/reagent/blood,species.blood_volume)
	fixblood()

//Resets blood data
/mob/living/carbon/human/proc/fixblood()
	for(var/datum/reagent/blood/B in vessel.reagent_list)
		if(B.type == /datum/reagent/blood)
			B.data = list(
				"donor" = weakref(src),
				"species" = species.name,
				"blood_DNA" = dna.unique_enzymes,
				"blood_colour" = species.get_blood_colour(src),
				"blood_type" = dna.b_type,
				"trace_chem" = null
			)
			B.color = B.data["blood_colour"]

//Makes a blood drop, leaking amt units of blood from the mob
/mob/living/carbon/human/proc/drip(var/amt, var/tar = src, var/ddir)
	if(remove_blood(amt))
		if(bloodstr.total_volume && vessel.total_volume)
			var/chem_share = round(0.3 * amt * (bloodstr.total_volume/vessel.total_volume), 0.01)
			bloodstr.remove_any(chem_share * bloodstr.total_volume)
		blood_splatter(tar, src, (ddir && ddir>0), spray_dir = ddir)
		return amt
	return 0

#define BLOOD_SPRAY_DISTANCE 2
/mob/living/carbon/human/proc/blood_squirt(var/amt, var/turf/sprayloc)
	if(amt <= 0 || !istype(sprayloc))
		return
	var/spraydir = pick(GLOB.alldirs)
	amt = ceil(amt/BLOOD_SPRAY_DISTANCE)
	var/bled = 0
	spawn(0)
		for(var/i = 1 to BLOOD_SPRAY_DISTANCE)
			sprayloc = get_step(sprayloc, spraydir)
			if(!istype(sprayloc) || sprayloc.density)
				break
			var/hit_mob
			for(var/thing in sprayloc)
				var/atom/A = thing
				if(!A.simulated)
					continue

				if(ishuman(A))
					var/mob/living/carbon/human/H = A
					if(!H.lying)
						H.bloody_body(src)
						H.bloody_hands(src)
						var/blinding = FALSE
						if(ran_zone() == BP_HEAD)
							blinding = TRUE
							for(var/obj/item/I in list(H.head, H.glasses, H.wear_mask))
								if(I && (I.body_parts_covered & EYES))
									blinding = FALSE
									break
						if(blinding)
							H.eye_blurry = max(H.eye_blurry, 10)
							H.eye_blind = max(H.eye_blind, 5)
							to_chat(H, "<span class='danger'>You are blinded by a spray of blood!</span>")
						else
							to_chat(H, "<span class='danger'>You are hit by a spray of blood!</span>")
						hit_mob = TRUE

				if(hit_mob || !A.CanPass(src, sprayloc))
					break

			drip(amt, sprayloc, spraydir)
			bled += amt
			if(hit_mob) break
			sleep(1)
	return bled
#undef BLOOD_SPRAY_DISTANCE

/mob/living/carbon/human/proc/remove_blood(var/amt)
	if(!should_have_organ(BP_HEART)) //TODO: Make drips come from the reagents instead.
		return 0
	if(!amt)
		return 0

	amt *= ((src.mob_size/MOB_MEDIUM) ** 0.5)

	return vessel.remove_reagent(/datum/reagent/blood, amt)

/****************************************************
				BLOOD TRANSFERS
****************************************************/

//Gets blood from mob to the container, preserving all data in it.
/mob/living/carbon/proc/take_blood(obj/item/reagent_containers/container, var/amount)
	var/datum/reagent/blood/B = get_blood(container.reagents)
	if(!B)
		container.reagents.add_reagent(/datum/reagent/blood, amount, get_blood_data())
	else
		B.sync_to(src)
		B.volume += amount
	return 1

//For humans, blood does not appear from blue, it comes from vessels.
/mob/living/carbon/human/take_blood(obj/item/reagent_containers/container, var/amount)

	if(!should_have_organ(BP_HEART))
		reagents.trans_to_obj(container, amount)
		return 1

	if(vessel.get_reagent_amount(/datum/reagent/blood) < amount)
		return null

	//make sure virus/etc data is up to date
	var/datum/reagent/blood/our = get_blood(vessel)
	our.sync_to(src)
	vessel.trans_to_holder(container.reagents,amount)
	return 1

//Transfers blood from container ot vessels
/mob/living/carbon/proc/inject_blood(var/datum/reagent/blood/injected, var/amount)
	if (!injected || !istype(injected))
		return
	var/list/chems = list()
	chems = injected.data["trace_chem"]
	for(var/C in chems)
		src.reagents.add_reagent(C, (text2num(chems[C]) / species.blood_volume) * amount)//adds trace chemicals to owner's blood

//Transfers blood from reagents to vessel, respecting blood types compatability.
/mob/living/carbon/human/inject_blood(var/datum/reagent/blood/injected, var/amount)
	if(!should_have_organ(BP_HEART))
		reagents.add_reagent(/datum/reagent/blood, amount, injected.data)
		return

	if(blood_incompatible(injected.data["blood_type"], injected.data["species"]))
		reagents.add_reagent(/datum/reagent/toxin, amount * 0.5)
	else
		vessel.add_reagent(/datum/reagent/blood, amount, injected.data)
	..()

//Gets human's own blood.
/mob/living/carbon/proc/get_blood(datum/reagents/container)
	var/datum/reagent/blood/res
	if(container)
		res = locate() in container.reagent_list //Grab some blood
		if(res) // Make sure there's some blood at all
			if(weakref && res.data["donor"] != weakref) //If it's not theirs, then we look for theirs
				for(var/datum/reagent/blood/D in container.reagent_list)
					if(weakref && D.data["donor"] != weakref)
						return D
	return res

/mob/living/carbon/human/get_blood(datum/reagents/container)
	. = ..(container || vessel)

/mob/living/carbon/human/proc/blood_incompatible(blood_type, blood_species)
	if(blood_species && species.name)
		if(blood_species != species.name)
			return 1

	var/donor_antigen = copytext_char(blood_type, 1, length(blood_type))
	var/receiver_antigen = copytext_char(dna.b_type, 1, length(dna.b_type))
	var/donor_rh = (findtext(blood_type, "+") > 0)
	var/receiver_rh = (findtext(dna.b_type, "+") > 0)

	if(donor_rh && !receiver_rh) return 1
	switch(receiver_antigen)
		if("A")
			if(donor_antigen != "A" && donor_antigen != "O") return 1
		if("B")
			if(donor_antigen != "B" && donor_antigen != "O") return 1
		if("O")
			if(donor_antigen != "O") return 1
		//AB is a universal receiver.
	return 0

/mob/living/carbon/human/proc/regenerate_blood(var/amount)
	amount *= (species.blood_volume / SPECIES_BLOOD_DEFAULT)
	var/blood_volume_raw = vessel.get_reagent_amount(/datum/reagent/blood)
	amount = max(0,min(amount, species.blood_volume - blood_volume_raw))
	if(amount)
		vessel.add_reagent(/datum/reagent/blood, amount, get_blood_data())
	return amount

/mob/living/carbon/proc/get_blood_data()
	var/data = list()
	data["donor"] = weakref(src)
	data["blood_DNA"] = dna.unique_enzymes
	data["blood_type"] = dna.b_type
	data["species"] = species.name
	data["has_oxy"] = species.blood_oxy
	var/list/temp_chem = list()
	for(var/datum/reagent/R in reagents.reagent_list)
		temp_chem[R.type] = R.volume
	data["trace_chem"] = temp_chem
	data["dose_chem"] = chem_doses.Copy()
	data["blood_colour"] = species.get_blood_colour(src)
	return data

proc/blood_splatter(var/target,var/datum/reagent/blood/source,var/large,var/spray_dir)

	var/obj/effect/decal/cleanable/blood/B
	var/decal_type = /obj/effect/decal/cleanable/blood/splatter
	var/turf/T = get_turf(target)

	if(istype(source,/mob/living/carbon))
		var/mob/living/carbon/M = source
		source = M.get_blood()
	if(!istype(source))
		source = null

	// Are we dripping or splattering?
	var/list/drips = list()
	// Only a certain number of drips (or one large splatter) can be on a given turf.
	for(var/obj/effect/decal/cleanable/blood/drip/drop in T)
		drips |= drop.drips
		qdel(drop)
	if(!large && drips.len < 3)
		decal_type = /obj/effect/decal/cleanable/blood/drip

	// Find a blood decal or create a new one.
	if(T)
		var/list/existing = filter_list(T.contents, decal_type)
		if(length(existing) > 3)
			B = pick(existing)
	if(!B)
		B = new decal_type(T)

	var/obj/effect/decal/cleanable/blood/drip/drop = B
	if(istype(drop) && drips && drips.len && !large)
		drop.overlays |= drips
		drop.drips |= drips

	// If there's no data to copy, call it quits here.
	if(!source)
		return B

	// Update appearance.
	if(source.data["blood_colour"])
		B.basecolor = source.data["blood_colour"]
		B.update_icon()
	if(spray_dir)
		B.icon_state = "squirt"
		B.dir = spray_dir

	// Update blood information.
	if(source.data["blood_DNA"])
		B.blood_DNA = list()
		if(source.data["blood_type"])
			B.blood_DNA[source.data["blood_DNA"]] = source.data["blood_type"]
		else
			B.blood_DNA[source.data["blood_DNA"]] = "O+"

	B.fluorescent  = 0
	B.set_invisibility(0)
	return B

//Percentage of maximum blood volume.
/mob/living/carbon/human/proc/get_blood_volume()
	return round((vessel.get_reagent_amount(/datum/reagent/blood)/species.blood_volume)*100)

//Percentage of maximum blood volume, affected by the condition of circulation organs
/mob/living/carbon/human/proc/get_blood_circulation()
	var/obj/item/organ/internal/heart/heart = internal_organs_by_name[BP_HEART]
	var/blood_volume = get_blood_volume()
	if(!heart)
		return 0.25 * blood_volume

	var/recent_pump = LAZYACCESS(heart.external_pump, 1) > world.time - (20 SECONDS)
	var/pulse_mod = 1
	if((status_flags & FAKEDEATH) || BP_IS_ROBOTIC(heart))
		pulse_mod = 1
	else
		switch(heart.pulse)
			if(PULSE_NONE)
				if(recent_pump)
					pulse_mod = LAZYACCESS(heart.external_pump, 2)
				else
					pulse_mod *= 0.25
			if(PULSE_SLOW)
				pulse_mod *= 0.9
			if(PULSE_FAST)
				pulse_mod *= 1.1
			if(PULSE_2FAST, PULSE_THREADY)
				pulse_mod *= 1.25
	blood_volume *= pulse_mod

	var/min_efficiency = recent_pump ? 0.5 : 0.3
	blood_volume *= max(min_efficiency, (1-(heart.damage / heart.max_damage)))

	if(!heart.open && chem_effects[CE_BLOCKAGE])
		blood_volume *= max(0, 1-chem_effects[CE_BLOCKAGE])

	return min(blood_volume, 100)

//Whether the species needs blood to carry oxygen. Used in get_blood_oxygenation and may be expanded based on blood rather than species in the future.
/mob/living/carbon/human/proc/blood_carries_oxygen()
	return species.blood_oxy

//Percentage of maximum blood volume, affected by the condition of circulation organs, affected by the oxygen loss. What ultimately matters for brain
/mob/living/carbon/human/proc/get_blood_oxygenation()
	var/blood_volume = get_blood_circulation()
	if(blood_carries_oxygen())
		if(is_asystole()) // Heart is missing or isn't beating and we're not breathing (hardcrit)
			return min(blood_volume, BLOOD_VOLUME_SURVIVE)

		if(!need_breathe())
			return blood_volume
	else
		blood_volume = 100

	var/blood_volume_mod = max(0, 1 - getOxyLoss()/(species.total_health/2))
	var/oxygenated_mult = 0
	if(chem_effects[CE_OXYGENATED] == 1) // Dexalin.
		oxygenated_mult = 0.5
	else if(chem_effects[CE_OXYGENATED] >= 2) // Dexplus.
		oxygenated_mult = 0.8
	blood_volume_mod = blood_volume_mod + oxygenated_mult - (blood_volume_mod * oxygenated_mult)
	blood_volume = blood_volume * blood_volume_mod
	return min(blood_volume, 100)
