/****************************************************
				BLOOD SYSTEM
****************************************************/

/mob/living/carbon/human/var/datum/reagents/vessel // Container for blood and BLOOD ONLY. Do not transfer other chems here.
/mob/living/carbon/human/var/var/pale = 0          // Should affect how mob sprite is drawn, but currently doesn't.

//Initializes blood vessels
/mob/living/carbon/human/proc/make_blood()

	if(vessel)
		return

	vessel = new/datum/reagents(species.blood_volume)
	vessel.my_atom = src

	if(!should_have_organ(BP_HEART)) //We want the var for safety but we can do without the actual blood.
		return

	vessel.add_reagent("blood",species.blood_volume)
	spawn(1)
		fixblood()

//Resets blood data
/mob/living/carbon/human/proc/fixblood()
	for(var/datum/reagent/blood/B in vessel.reagent_list)
		if(B.id == "blood")
			B.data = list("donor" = src, "species" = species.name, "blood_DNA" = dna.unique_enzymes, "blood_colour" = species.get_blood_colour(src), "blood_type" = dna.b_type, "trace_chem" = null, "virus2" = list(), "antibodies" = list())
			B.color = B.data["blood_colour"]

// Takes care blood loss and regeneration
/mob/living/carbon/human/var/next_blood_squirt = 0
/mob/living/carbon/human/handle_blood()
	if(in_stasis)
		return

	if(!should_have_organ(BP_HEART))
		return

	var/obj/item/organ/internal/heart/heart = internal_organs_by_name["heart"]
	if(!heart)	//not having a heart is bad for health
		setOxyLoss(max(getOxyLoss(), maxHealth))
		adjustOxyLoss(10)

	//Bleeding out
	var/blood_max = 0
	var/list/do_spray = list()
	for(var/obj/item/organ/external/temp in organs)

		if(temp.robotic >= ORGAN_ROBOT)
			continue

		var/open_wound
		if(temp.status & ORGAN_BLEEDING)

			if (temp.open)
				blood_max += 2  //Yer stomach is cut open

			for(var/datum/wound/W in temp.wounds)
				if(!open_wound && (W.damage_type == CUT || W.damage_type == PIERCE) && W.damage && !W.is_treated())
					open_wound = TRUE

				if(W.bleeding())
					if(temp.applied_pressure)
						if(ishuman(temp.applied_pressure))
							var/mob/living/carbon/human/H = temp.applied_pressure
							H.bloody_hands(src, 0)
						//somehow you can apply pressure to every wound on the organ at the same time
						//you're basically forced to do nothing at all, so let's make it pretty effective
						var/min_eff_damage = max(0, W.damage - 10) / 6 //still want a little bit to drip out, for effect
						blood_max += max(min_eff_damage, W.damage - 30) / 40
					else
						blood_max += W.damage / 40

		if(temp.status & ORGAN_ARTERY_CUT)
			var/bleed_amount = Floor(vessel.total_volume / (temp.applied_pressure ? 400 : 250))
			if(bleed_amount)
				if(open_wound)
					blood_max += bleed_amount
					do_spray += temp.artery_name
				else
					vessel.remove_reagent("blood", bleed_amount)

	if(world.time >= next_blood_squirt && istype(loc, /turf) && do_spray.len)
		visible_message("<span class='danger'>Blood squirts from \the [src]'s [pick(do_spray)]!</span>")
		// It becomes very spammy otherwise. Arterial bleeding will still happen outside of this block, just not the squirt effect.
		next_blood_squirt = world.time + 100
		var/turf/sprayloc = get_turf(src)
		blood_max -= drip(ceil(blood_max/3), sprayloc)
		if(blood_max > 0)
			blood_max -= blood_squirt(blood_max, sprayloc)
			if(blood_max > 0)
				drip(blood_max, get_turf(src))
	else
		drip(blood_max)

//Makes a blood drop, leaking amt units of blood from the mob
/mob/living/carbon/human/proc/drip(var/amt, var/tar = src, var/ddir)
	if(remove_blood(amt))
		blood_splatter(tar,src,ddir)
		return amt
	return 0

#define BLOOD_SPRAY_DISTANCE 2
/mob/living/carbon/human/proc/blood_squirt(var/amt, var/turf/sprayloc)
	if(amt <= 0 || !istype(sprayloc))
		return
	var/spraydir = pick(alldirs)
	amt = ceil(amt/BLOOD_SPRAY_DISTANCE)
	var/bled = 0
	spawn(0)
		for(var/i = 1 to BLOOD_SPRAY_DISTANCE)
			sprayloc = get_step(sprayloc, spraydir)
			if(!istype(sprayloc) || sprayloc.density)
				break
			drip(amt, sprayloc, spraydir)
			bled += amt
			sleep(1)
	return bled
#undef BLOOD_SPRAY_DISTANCE

/mob/living/carbon/human/proc/remove_blood(var/amt)
	if(!should_have_organ(BP_HEART)) //TODO: Make drips come from the reagents instead.
		return 0
	if(!amt)
		return 0
	return vessel.remove_reagent("blood", amt * (src.mob_size/MOB_MEDIUM))

/****************************************************
				BLOOD TRANSFERS
****************************************************/

//Gets blood from mob to the container, preserving all data in it.
/mob/living/carbon/proc/take_blood(obj/item/weapon/reagent_containers/container, var/amount)
	var/datum/reagent/blood/B = get_blood(container.reagents)
	if(!B)
		B = new /datum/reagent/blood
		B.sync_to(src)
		container.reagents.add_reagent("blood", amount, B.data)
	else
		B.sync_to(src)
		B.volume += amount
	return 1

//For humans, blood does not appear from blue, it comes from vessels.
/mob/living/carbon/human/take_blood(obj/item/weapon/reagent_containers/container, var/amount)

	if(!should_have_organ(BP_HEART))
		reagents.trans_to_obj(container, amount)
		return 1

	if(vessel.get_reagent_amount("blood") < amount)
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
	var/list/sniffles = virus_copylist(injected.data["virus2"])
	for(var/ID in sniffles)
		var/datum/disease2/disease/sniffle = sniffles[ID]
		infect_virus2(src,sniffle,1)
	if (injected.data["antibodies"] && prob(5))
		antibodies |= injected.data["antibodies"]
	var/list/chems = list()
	chems = params2list(injected.data["trace_chem"])
	for(var/C in chems)
		src.reagents.add_reagent(C, (text2num(chems[C]) / species.blood_volume) * amount)//adds trace chemicals to owner's blood
	reagents.update_total()

//Transfers blood from reagents to vessel, respecting blood types compatability.
/mob/living/carbon/human/inject_blood(var/datum/reagent/blood/injected, var/amount)

	if(!should_have_organ(BP_HEART))
		reagents.add_reagent("blood", amount, injected.data)
		reagents.update_total()
		return

	var/datum/reagent/blood/our = get_blood(vessel)

	if (!injected || !our)
		return
	if(blood_incompatible(injected.data["blood_type"],our.data["blood_type"],injected.data["species"],our.data["species"]) )
		reagents.add_reagent("toxin",amount * 0.5)
		reagents.update_total()
	else
		vessel.add_reagent("blood", amount, injected.data)
		vessel.update_total()
	..()

//Gets human's own blood.
/mob/living/carbon/proc/get_blood(datum/reagents/container)
	var/datum/reagent/blood/res = locate() in container.reagent_list //Grab some blood
	if(res) // Make sure there's some blood at all
		if(res.data["donor"] != src) //If it's not theirs, then we look for theirs
			for(var/datum/reagent/blood/D in container.reagent_list)
				if(D.data["donor"] == src)
					return D
	return res

proc/blood_incompatible(donor,receiver,donor_species,receiver_species)
	if(!donor || !receiver) return 0

	if(donor_species && receiver_species)
		if(donor_species != receiver_species)
			return 1

	var/donor_antigen = copytext(donor,1,lentext(donor))
	var/receiver_antigen = copytext(receiver,1,lentext(receiver))
	var/donor_rh = (findtext(donor,"+")>0)
	var/receiver_rh = (findtext(receiver,"+")>0)

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

proc/blood_splatter(var/target,var/datum/reagent/blood/source,var/large,var/spray_dir)

	var/obj/effect/decal/cleanable/blood/B
	var/decal_type = /obj/effect/decal/cleanable/blood/splatter
	var/turf/T = get_turf(target)

	if(istype(source,/mob/living/carbon/human))
		var/mob/living/carbon/human/M = source
		source = M.get_blood(M.vessel)

	// Are we dripping or splattering?
	var/list/drips = list()
	// Only a certain number of drips (or one large splatter) can be on a given turf.
	for(var/obj/effect/decal/cleanable/blood/drip/drop in T)
		drips |= drop.drips
		qdel(drop)
	if(!large && drips.len < 3)
		decal_type = /obj/effect/decal/cleanable/blood/drip

	// Find a blood decal or create a new one.
	B = locate(decal_type) in T
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

	// Update virus information.
	if(source.data["virus2"])
		B.virus2 = virus_copylist(source.data["virus2"])

	B.fluorescent  = 0
	B.invisibility = 0
	return B
