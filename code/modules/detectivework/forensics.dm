/obj/item/forensics
	icon = 'icons/obj/forensics.dmi'
	w_class = ITEM_SIZE_TINY

//This is the output of the stringpercent(print) proc, and means about 80% of
//the print must be there for it to be complete.  (Prints are 32 digits)
var/global/const/FINGERPRINT_COMPLETE = 6
/proc/is_complete_print(var/print)
	return stringpercent(print) <= FINGERPRINT_COMPLETE

/atom/var/list/fingerprintshidden
/atom/var/fingerprintslast

/atom/var/list/suit_fibers
/atom/var/list/fingerprints
/atom/var/list/gunshot_residue
/obj/item/var/list/trace_DNA

/atom/proc/add_hiddenprint(mob/M)
	if(!M || !M.key)
		return
	if(fingerprintslast == M.key)
		return
	fingerprintslast = M.key
	if(!fingerprintshidden)
		fingerprintshidden = list()
	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		if (H.gloves)
			src.fingerprintshidden += "\[[time_stamp()]\] (Wearing gloves). Real name: [H.real_name], Key: [H.key]"
			return 0

	src.fingerprintshidden += "\[[time_stamp()]\] Real name: [M.real_name], Key: [M.key]"
	return 1

/atom/proc/add_fingerprint(mob/M, ignoregloves, obj/item/tool)
	if(isnull(M)) return
	if(isAI(M)) return
	if(!M || !M.key)
		return
	if(istype(tool) && (tool.item_flags & ITEM_FLAG_NO_PRINT))
		return

	add_hiddenprint(M)
	add_fibers(M)

	if(!fingerprints)
		fingerprints = list()

	//Hash this shit.
	var/full_print = M.get_full_print(ignoregloves)
	if(!full_print)
		return

	//Using prints from severed hand items!
	var/obj/item/organ/external/E = M.get_active_hand()
	if(src != E && istype(E) && E.get_fingerprint())
		full_print = E.get_fingerprint()
		ignoregloves = 1

	if(!ignoregloves && ishuman(M))
		var/mob/living/carbon/human/H = M
		if (H.gloves && H.gloves.body_parts_covered & HANDS && H.gloves != src)
			if(istype(H.gloves, /obj/item/clothing/gloves)) //Don't add prints if you are wearing gloves.
				var/obj/item/clothing/gloves/G = H.gloves
				if(!G.clipped) //Fingerless gloves leave prints.
					return 0
			else if(prob(75))
				return 0
			H.gloves.add_fingerprint(M)
	var/additional_chance = 0
	if(!M.skill_check(SKILL_FORENSICS, SKILL_BASIC))
		additional_chance = 10
	// Add the fingerprints
	add_partial_print(full_print, additional_chance)
	return 1

/atom/proc/add_partial_print(full_print, bonus)
	LAZYINITLIST(fingerprints)
	if(!fingerprints[full_print])
		fingerprints[full_print] = stars(full_print, rand(0 + bonus, 20 + bonus))	//Initial touch, not leaving much evidence the first time.
	else
		switch(max(stringpercent(fingerprints[full_print]) - bonus,0))		//tells us how many stars are in the current prints.
			if(28 to 32)
				if(prob(1))
					fingerprints[full_print] = full_print 		// You rolled a one buddy.
				else
					fingerprints[full_print] = stars(full_print, rand(0,40)) // 24 to 32

			if(24 to 27)
				if(prob(3))
					fingerprints[full_print] = full_print     	//Sucks to be you.
				else
					fingerprints[full_print] = stars(full_print, rand(15, 55)) // 20 to 29

			if(20 to 23)
				if(prob(5))
					fingerprints[full_print] = full_print		//Had a good run didn't ya.
				else
					fingerprints[full_print] = stars(full_print, rand(30, 70)) // 15 to 25

			if(16 to 19)
				if(prob(5))
					fingerprints[full_print] = full_print		//Welp.
				else
					fingerprints[full_print]  = stars(full_print, rand(40, 100))  // 0 to 21

			if(0 to 15)
				if(prob(5))
					fingerprints[full_print] = stars(full_print, rand(0,50)) 	// small chance you can smudge.
				else
					fingerprints[full_print] = full_print

/atom/proc/transfer_fingerprints_to(var/atom/A)
	if(fingerprints)
		LAZYDISTINCTADD(A.fingerprints, fingerprints)
	if(fingerprintshidden)
		LAZYDISTINCTADD(A.fingerprintshidden, fingerprintshidden)
		A.fingerprintslast = fingerprintslast
	if(suit_fibers)
		LAZYDISTINCTADD(A.suit_fibers, suit_fibers)
	if(blood_DNA)
		LAZYDISTINCTADD(A.blood_DNA, blood_DNA)
	if(gunshot_residue)
		var/obj/item/clothing/C = A
		LAZYDISTINCTADD(C.gunshot_residue, gunshot_residue)

/obj/item/transfer_fingerprints_to(var/atom/A)
	..()
	if(istype(A,/obj/item) && trace_DNA)
		var/obj/item/I = A
		LAZYDISTINCTADD(I.trace_DNA, trace_DNA)

/atom/proc/add_fibers(mob/living/carbon/human/M)
	if(!istype(M))
		return
	if(M.gloves && istype(M.gloves,/obj/item/clothing/gloves))
		var/obj/item/clothing/gloves/G = M.gloves
		if(G.transfer_blood) //bloodied gloves transfer blood to touched objects
			if(add_blood(G.bloody_hands_mob)) //only reduces the bloodiness of our gloves if the item wasn't already bloody
				G.transfer_blood--
	else if(M.bloody_hands)
		if(add_blood(M.bloody_hands_mob))
			M.bloody_hands--

	var/fibertext
	var/item_multiplier = istype(src,/obj/item)?1.2:1
	var/suit_coverage = 0
	if(istype(M.wear_suit, /obj/item/clothing))
		var/obj/item/clothing/C = M.wear_suit
		fibertext = C.get_fibers()
		if(fibertext && prob(10*item_multiplier))
			LAZYDISTINCTADD(suit_fibers, fibertext)
		suit_coverage = C.body_parts_covered

	if(istype(M.w_uniform, /obj/item/clothing) && (M.w_uniform.body_parts_covered & ~suit_coverage))
		var/obj/item/clothing/C = M.w_uniform
		fibertext = C.get_fibers()
		if(fibertext && prob(15*item_multiplier))
			LAZYDISTINCTADD(suit_fibers, fibertext)

	if(istype(M.gloves, /obj/item/clothing) && (M.gloves.body_parts_covered & ~suit_coverage))
		var/obj/item/clothing/C = M.gloves
		fibertext = C.get_fibers()
		if(fibertext && prob(20*item_multiplier))
			LAZYDISTINCTADD(suit_fibers, fibertext)

/obj/item/proc/add_trace_DNA(mob/living/carbon/M)
	if(!istype(M))
		return
	if(M.isSynthetic())
		return
	if(istype(M.dna))
		LAZYDISTINCTADD(trace_DNA, M.dna.unique_enzymes)

/mob/proc/get_full_print()
	return FALSE

/mob/living/carbon/get_full_print()
	if (!dna || (mFingerprints in mutations))
		return FALSE
	return md5(dna.uni_identity)

/mob/living/carbon/human/get_full_print(ignoregloves)
	if(!..())
		return FALSE

	var/obj/item/organ/external/E = organs_by_name[hand ? BP_L_HAND : BP_R_HAND]
	if(E)
		return E.get_fingerprint()



//on examination get hints of evidence
/mob/examinate(atom/A as mob|obj|turf in view())
	if(UNLINT(..()))
		return 1 //I'll admit I am just imitating examine.dm


	//Detective is on the case
	if(get_skill_value(SKILL_FORENSICS) >= SKILL_EXPERT && get_dist(src, A) <= (get_skill_value(SKILL_FORENSICS) - SKILL_ADEPT))
		var/clue
		if(LAZYLEN(A.suit_fibers))
			to_chat(src, SPAN_NOTICE("You notice some fibers embedded in \the [A]."))
			clue = 1
		if(LAZYLEN(A.fingerprints))
			to_chat(src, SPAN_NOTICE("You notice a partial print on \the [A]."))
			clue = 1
		if(LAZYLEN(A.gunshot_residue))
			if(isliving(src))
				var/mob/living/M = src
				if(M.isSynthetic())
					to_chat(src, SPAN_NOTICE("You notice faint black residue on \the [A]."))
				else
					to_chat(src, SPAN_NOTICE("You notice a faint acrid smell coming from \the [A]."))
			else if(isrobot(src))
				to_chat(src, SPAN_NOTICE("You notice faint black residue on \the [A]."))
			else
				to_chat(src, SPAN_NOTICE("You notice a faint acrid smell coming from \the [A]."))
			clue = 1
		//Noticing wiped blood is a bit harder
		if((get_skill_value(SKILL_FORENSICS) >= SKILL_PROF) && LAZYLEN(A.blood_DNA))
			to_chat(src, SPAN_WARNING("You notice faint blood traces on \The [A]."))
			clue = 1
		if(clue && has_client_color(/datum/client_color/noir))
			playsound_local(null, pick('sound/effects/clue1.ogg','sound/effects/clue2.ogg'), 60, is_global = TRUE)
