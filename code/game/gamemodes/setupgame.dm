/////////////////////////
// (mostly) DNA2 SETUP
/////////////////////////

// Randomize block, assign a reference name, and optionally define difficulty (by making activation zone smaller or bigger)
// The name is used on /vg/ for species with predefined genetic traits,
//  and for the DNA panel in the player panel.
/proc/getAssignedBlock(var/name,var/list/blocksLeft, var/activity_bounds=DNA_DEFAULT_BOUNDS)
	var/assigned = pick(blocksLeft)
	blocksLeft.Remove(assigned)
	assigned_blocks[assigned]=name
	dna_activity_bounds[assigned]=activity_bounds
	//testing("[name] assigned to block #[assigned].")
	return assigned

/proc/setupgenetics()

	if (prob(50))
		// Currently unused.  Will revisit. - N3X
		BLOCKADD = rand(-300,300)
	if (prob(75))
		DIFFMUT = rand(0,20)

	/* Old, for reference (so I don't accidentally activate something) - N3X
	var/list/avnums = new/list()
	var/tempnum

	avnums.Add(2)
	avnums.Add(12)
	avnums.Add(10)
	avnums.Add(8)
	avnums.Add(4)
	avnums.Add(11)
	avnums.Add(13)
	avnums.Add(6)

	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	HULKBLOCK = tempnum
	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	TELEBLOCK = tempnum
	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	FIREBLOCK = tempnum
	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	XRAYBLOCK = tempnum
	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	CLUMSYBLOCK = tempnum
	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	FAKEBLOCK = tempnum
	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	DEAFBLOCK = tempnum
	tempnum = pick(avnums)
	avnums.Remove(tempnum)
	BLINDBLOCK = tempnum
	*/
	var/list/numsToAssign=new()
	for(var/i=1;i<STRUCDNASIZE;i++)
		numsToAssign += i

	//testing("Assigning DNA blocks:")

	// Standard muts, imported from older code above.
	BLINDBLOCK         = getAssignedBlock("BLIND",         numsToAssign)
	DEAFBLOCK          = getAssignedBlock("DEAF",          numsToAssign)
	HULKBLOCK          = getAssignedBlock("HULK",          numsToAssign, DNA_HARD_BOUNDS)
	TELEBLOCK          = getAssignedBlock("TELE",          numsToAssign, DNA_HARD_BOUNDS)
	FIREBLOCK          = getAssignedBlock("FIRE",          numsToAssign, DNA_HARDER_BOUNDS)
	XRAYBLOCK          = getAssignedBlock("XRAY",          numsToAssign, DNA_HARDER_BOUNDS)
	CLUMSYBLOCK        = getAssignedBlock("CLUMSY",        numsToAssign)
	FAKEBLOCK          = getAssignedBlock("FAKE",          numsToAssign)

	// UNUSED!
	//COUGHBLOCK         = getAssignedBlock("COUGH",         numsToAssign)
	//GLASSESBLOCK       = getAssignedBlock("GLASSES",       numsToAssign)
	//EPILEPSYBLOCK      = getAssignedBlock("EPILEPSY",      numsToAssign)
	//TWITCHBLOCK        = getAssignedBlock("TWITCH",        numsToAssign)
	//NERVOUSBLOCK       = getAssignedBlock("NERVOUS",       numsToAssign)

	// Bay muts (UNUSED)
	//HEADACHEBLOCK      = getAssignedBlock("HEADACHE",      numsToAssign)
	//NOBREATHBLOCK      = getAssignedBlock("NOBREATH",      numsToAssign, DNA_HARD_BOUNDS)
	//REMOTEVIEWBLOCK    = getAssignedBlock("REMOTEVIEW",    numsToAssign, DNA_HARDER_BOUNDS)
	//REGENERATEBLOCK    = getAssignedBlock("REGENERATE",    numsToAssign, DNA_HARDER_BOUNDS)
	//INCREASERUNBLOCK   = getAssignedBlock("INCREASERUN",   numsToAssign, DNA_HARDER_BOUNDS)
	//REMOTETALKBLOCK    = getAssignedBlock("REMOTETALK",    numsToAssign, DNA_HARDER_BOUNDS)
	//MORPHBLOCK         = getAssignedBlock("MORPH",         numsToAssign, DNA_HARDER_BOUNDS)
	//COLDBLOCK          = getAssignedBlock("COLD",          numsToAssign)
	//HALLUCINATIONBLOCK = getAssignedBlock("HALLUCINATION", numsToAssign)
	//NOPRINTSBLOCK      = getAssignedBlock("NOPRINTS",      numsToAssign, DNA_HARD_BOUNDS)
	//SHOCKIMMUNITYBLOCK = getAssignedBlock("SHOCKIMMUNITY", numsToAssign)
	//SMALLSIZEBLOCK     = getAssignedBlock("SMALLSIZE",     numsToAssign, DNA_HARD_BOUNDS)

	// And the genes that actually do the work. (domutcheck improvements)
	var/list/blocks_assigned[STRUCDNASIZE]
	for(var/gene_type in typesof(/datum/dna/gene))
		var/datum/dna/gene/G = new gene_type
		if(G.block)
			if(G.block in blocks_assigned)
				warning("DNA2: Gene [G.name] trying to use already-assigned block [G.block] (used by [english_list(blocks_assigned[G.block])])")
			dna_genes.Add(G)
			var/list/assignedToBlock[0]
			if(blocks_assigned[G.block])
				assignedToBlock=blocks_assigned[G.block]
			assignedToBlock.Add(G.name)
			blocks_assigned[G.block]=assignedToBlock
			testing("DNA2: Gene [G.name] assigned to block [G.block].")

	// HIDDEN MUTATIONS / SUPERPOWERS INITIALIZTION

	/*
	for(var/x in typesof(/datum/mutations) - /datum/mutations)
		var/datum/mutations/mut = new x

		for(var/i = 1, i <= mut.required, i++)
			var/datum/mutationreq/require = new/datum/mutationreq
			require.block = rand(1, 13)
			require.subblock = rand(1, 3)

			// Create random requirement identification
			require.reqID = pick("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", \
							 "B", "C", "D", "E", "F")

			mut.requirements += require


		global_mutations += mut// add to global mutations list!
	*/


/proc/setupfactions()

	// Populate the factions list:
	for(var/x in typesof(/datum/faction))
		var/datum/faction/F = new x
		if(!F.name)
			del(F)
			continue
		else
			ticker.factions.Add(F)
			ticker.availablefactions.Add(F)

	// Populate the syndicate coalition:
	for(var/datum/faction/syndicate/S in ticker.factions)
		ticker.syndicate_coalition.Add(S)


/* This was used for something before, I think, but is not worth the effort to process now.
/proc/setupcorpses()
	for (var/obj/effect/landmark/A in landmarks_list)
		if (A.name == "Corpse")
			var/mob/living/carbon/human/M = new /mob/living/carbon/human(A.loc)
			M.real_name = "Corpse"
			M.death()
			del(A)
			continue
		if (A.name == "Corpse-Engineer")
			var/mob/living/carbon/human/M = new /mob/living/carbon/human(A.loc)
			M.real_name = "Corpse"
			M.death()
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_eng(M), slot_l_ear)
			M.equip_to_slot_or_del(new /obj/item/device/pda/engineering(M), slot_belt)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/rank/engineer(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(M), slot_shoes)
		//	M.equip_to_slot_or_del(new /obj/item/weapon/storage/toolbox/mechanical(M), slot_l_hand)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(M), slot_gloves)
			M.equip_to_slot_or_del(new /obj/item/device/t_scanner(M), slot_r_store)
			//M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_l_ear)
			M.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(M), slot_back)
			if (prob(50))
				M.equip_to_slot_or_del(new /obj/item/clothing/mask/gas(M), slot_wear_mask)
			if (prob(50))
				M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/hardhat(M), slot_head)
			else
				if (prob(50))
					M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/welding(M), slot_head)
			del(A)
			continue
		if (A.name == "Corpse-Engineer-Space")
			var/mob/living/carbon/human/M = new /mob/living/carbon/human(A.loc)
			M.real_name = "Corpse"
			M.death()
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_eng(M), slot_l_ear)
			M.equip_to_slot_or_del(new /obj/item/weapon/tank/emergency_oxygen(M), slot_belt)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/rank/engineer(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/space(M), slot_wear_suit)
		//	M.equip_to_slot_or_del(new /obj/item/weapon/storage/toolbox/mechanical(M), slot_l_hand)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(M), slot_gloves)
			M.equip_to_slot_or_del(new /obj/item/device/t_scanner(M), slot_r_store)
			M.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(M), slot_back)
			M.equip_to_slot_or_del(new /obj/item/clothing/mask/gas(M), slot_wear_mask)
			if (prob(50))
				M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/hardhat(M), slot_head)
			else
				if (prob(50))
					M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/welding(M), slot_head)
				else
					M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space(M), slot_head)
			del(A)
			continue
		if (A.name == "Corpse-Engineer-Chief")
			var/mob/living/carbon/human/M = new /mob/living/carbon/human(A.loc)
			M.real_name = "Corpse"
			M.death()
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_eng(M), slot_l_ear)
			M.equip_to_slot_or_del(new /obj/item/weapon/storage/utilitybelt(M), slot_belt)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chief_engineer(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(M), slot_shoes)
		//	M.equip_to_slot_or_del(new /obj/item/weapon/storage/toolbox/mechanical(M), slot_l_hand)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(M), slot_gloves)
			M.equip_to_slot_or_del(new /obj/item/device/t_scanner(M), slot_r_store)
			M.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(M), slot_back)
			if (prob(50))
				M.equip_to_slot_or_del(new /obj/item/clothing/mask/gas(M), slot_wear_mask)
			if (prob(50))
				M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/hardhat(M), slot_head)
			else
				if (prob(50))
					M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/welding(M), slot_head)
			del(A)
			continue
		if (A.name == "Corpse-Syndicate")
			var/mob/living/carbon/human/M = new /mob/living/carbon/human(A.loc)
			M.real_name = "Corpse"
			M.death()
			M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_l_ear)
			//M.equip_to_slot_or_del(new /obj/item/weapon/gun/revolver(M), slot_belt)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/syndicate(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/swat(M), slot_gloves)
			M.equip_to_slot_or_del(new /obj/item/weapon/tank/jetpack(M), slot_back)
			M.equip_to_slot_or_del(new /obj/item/clothing/mask/gas(M), slot_wear_mask)
			if (prob(50))
				M.equip_to_slot_or_del(new /obj/item/clothing/suit/space/syndicate(M), slot_wear_suit)
				if (prob(50))
					M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/swat(M), slot_head)
				else
					M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/syndicate(M), slot_head)
			else
				M.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(M), slot_wear_suit)
				M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/swat(M), slot_head)
			del(A)
			continue
*/
