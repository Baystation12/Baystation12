/obj/item/weapon/forensics
	icon = 'icons/obj/forensics.dmi'
	w_class = ITEM_SIZE_TINY

//This is the output of the stringpercent(print) proc, and means about 80% of
//the print must be there for it to be complete.  (Prints are 32 digits)
var/const/FINGERPRINT_COMPLETE = 6
proc/is_complete_print(var/print)
	return stringpercent(print) <= FINGERPRINT_COMPLETE

atom/var/list/suit_fibers
atom/var/var/list/fingerprints
atom/var/var/list/fingerprintshidden
atom/var/var/fingerprintslast = null

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

/atom/proc/add_fingerprint(mob/M, ignoregloves)
	if(isnull(M)) return
	if(isAI(M)) return
	if(!M || !M.key)
		return

	add_hiddenprint(M)
	add_fibers(M)

	if(!fingerprints)
		fingerprints = list()

	//Hash this shit.
	var/full_print = M.get_full_print(ignoregloves)
	if(!full_print)
		return

	var/obj/item/organ/external/E = M.get_active_hand()
	if(src != E && istype(E) && E.get_fingerprint())
		full_print = E.get_fingerprint()
		ignoregloves = 1

	if(!ignoregloves && ishuman(M))
		var/mob/living/carbon/human/H = M
		if (H.gloves && H.gloves.body_parts_covered & HANDS && H.gloves != src)
			H.gloves.add_fingerprint(M)
			if(!istype(H.gloves, /obj/item/clothing/gloves/latex))
				return 0
			else if(prob(75))
				return 0

	// Add the fingerprints
	add_partial_print(full_print)
	return 1

/atom/proc/add_partial_print(full_print)
	if(!fingerprints[full_print])
		fingerprints[full_print] = stars(full_print, rand(0, 20))	//Initial touch, not leaving much evidence the first time.
	else
		switch(stringpercent(fingerprints[full_print]))		//tells us how many stars are in the current prints.
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
		if(!A.fingerprints)
			A.fingerprints = list()
		A.fingerprints |= fingerprints.Copy()            //detective
	if(fingerprintshidden)
		if(!A.fingerprintshidden)
			A.fingerprintshidden = list()
		A.fingerprintshidden |= fingerprintshidden.Copy()    //admin
		A.fingerprintslast = fingerprintslast

atom/proc/add_fibers(mob/living/carbon/human/M)
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

	if(!suit_fibers) suit_fibers = list()
	var/fibertext
	var/item_multiplier = istype(src,/obj/item)?1.2:1
	var/suit_coverage = 0
	if(M.wear_suit)
		fibertext = "Material from \a [M.wear_suit]."
		if(prob(10*item_multiplier) && !(fibertext in suit_fibers))
			suit_fibers += fibertext
		suit_coverage = M.wear_suit.body_parts_covered

	if(M.w_uniform && (M.w_uniform.body_parts_covered & ~suit_coverage))
		fibertext = "Fibers from \a [M.w_uniform]."
		if(prob(15*item_multiplier) && !(fibertext in suit_fibers))
			suit_fibers += fibertext

	if(M.gloves && (M.gloves.body_parts_covered & ~suit_coverage))
		fibertext = "Material from a pair of [M.gloves.name]."
		if(prob(20*item_multiplier) && !(fibertext in suit_fibers))
			suit_fibers += fibertext

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

/obj/item/organ/external/proc/get_fingerprint()
	return

/obj/item/organ/external/arm/get_fingerprint()
	for(var/obj/item/organ/external/hand/H in children)
		return H.get_fingerprint()

/obj/item/organ/external/hand/get_fingerprint()
	if(dna && !is_stump())
		return md5(dna.uni_identity)

/obj/item/organ/external/afterattack(atom/A, mob/user, proximity)
	..()
	if(proximity && get_fingerprint())
		A.add_partial_print(get_fingerprint())