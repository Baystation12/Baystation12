/obj/item/weapon/grenade/flashbang
	name = "flashbang"
	icon_state = "flashbang"
	item_state = "flashbang"
	truncated_name = "bang"
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 1)


/obj/item/weapon/grenade/flashbang/detonate()
	..()
	for(var/obj/structure/closet/L in hear(7, get_turf(src)))
		if(locate(/mob/living/carbon/, L))
			for(var/mob/living/carbon/M in L)
				bang(get_turf(src), M)


	for(var/mob/living/carbon/M in hear(7, get_turf(src)))
		bang(get_turf(src), M)

	for(var/obj/effect/blob/B in hear(8,get_turf(src)))       		//Blob damage here
		var/damage = round(30/(get_dist(B,get_turf(src))+1))
		B.health -= damage
		B.update_icon()

	new/obj/effect/sparks(src.loc)
	new/obj/effect/effect/smoke/illumination(src.loc, 5, range=30, power=30, color="#ffffff")
	qdel(src)
	return

/obj/item/weapon/grenade/flashbang/proc/bang(var/turf/T , var/mob/living/carbon/M)					// Added a new proc called 'bang' that takes a location and a person to be banged.
	to_chat(M, "<span class='danger'>BANG</span>")// Called during the loop that bangs people in lockers/containers and when banging
	playsound(src.loc, 'sound/effects/bang.ogg', 50, 1, 30)		// people in normal view.  Could theroetically be called during other explosions.
																// -- Polymorph

//Checking for protections
	var/eye_safety = 0
	var/ear_safety = 0
	if(iscarbon(M))
		eye_safety = M.eyecheck()
		if(ishuman(M))
			if(istype(M:l_ear, /obj/item/clothing/ears/earmuffs) || istype(M:r_ear, /obj/item/clothing/ears/earmuffs))
				ear_safety += 2
			if(HULK in M.mutations)
				ear_safety += 1
			if(istype(M:head, /obj/item/clothing/head/helmet))
				ear_safety += 1

//Flashing everyone
	if(eye_safety < FLASH_PROTECTION_MODERATE)
		M.flash_eyes()
		M.Stun(2)
		M.Weaken(10)



//Now applying sound
	if((get_dist(M, T) <= 2 || src.loc == M.loc || src.loc == M))
		if(ear_safety > 0)
			M.Stun(2)
			M.Weaken(1)
		else
			M.Stun(10)
			M.Weaken(3)
			if ((prob(14) || (M == src.loc && prob(70))))
				M.ear_damage += rand(1, 10)
			else
				M.ear_damage += rand(0, 5)
				M.ear_deaf = max(M.ear_deaf,15)
	else if(get_dist(M, T) <= 5)
		if(!ear_safety)
			M.Stun(8)
			M.ear_damage += rand(0, 3)
			M.ear_deaf = max(M.ear_deaf,10)

	else if(!ear_safety)
		M.Stun(4)
		M.ear_damage += rand(0, 1)
		M.ear_deaf = max(M.ear_deaf,5)

//This really should be in mob not every check
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[BP_EYES]
		if (E && E.damage >= E.min_bruised_damage)
			to_chat(M, "<span class='danger'>Your eyes start to burn badly!</span>")
	if (M.ear_damage >= 15)
		to_chat(M, "<span class='danger'>Your ears start to ring badly!</span>")
	else
		if (M.ear_damage >= 5)
			to_chat(M, "<span class='danger'>Your ears start to ring!</span>")
		M.update_icons()

/obj/item/weapon/grenade/flashbang/Destroy()
	walk(src, 0) // Because we might have called walk_away, we must stop the walk loop or BYOND keeps an internal reference to us forever.
	return ..()
