/obj/item/grenade/flashbang
	name = "flashbang"
	desc = "A grenade designed to blind, stun and disorient by means of an extremely bright flash and loud explosion."
	icon_state = "flashbang"
	item_state = "flashbang"
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 1)
	var/banglet = 0

/obj/item/grenade/flashbang/detonate(mob/living/user)
	..()
	var/list/victims = list()
	var/list/objs = list()
	var/turf/T = get_turf(src)
	get_mobs_and_objs_in_view_fast(T, 7, victims, objs)
	for(var/mob/living/carbon/M in victims)
		bang(T, M)

	for(var/obj/effect/blob/B in objs)       		//Blob damage here
		var/damage = round(30/(get_dist(B,T)+1))
		B.damage_health(damage, DAMAGE_SHOCK)

	new/obj/effect/sparks(src.loc)
	new/obj/effect/effect/smoke/illumination(src.loc, 5, range=30, power=1, color="#ffffff")
	qdel(src)

/obj/item/grenade/flashbang/proc/bang(var/turf/T , var/mob/living/carbon/M)					// Added a new proc called 'bang' that takes a location and a person to be banged.
	to_chat(M, "<span class='danger'>BANG</span>")// Called during the loop that bangs people in lockers/containers and when banging
	playsound(src.loc, 'sound/effects/bang.ogg', 50, 1, 30)		// people in normal view.  Could theroetically be called during other explosions.
																// -- Polymorph

	//Checking for protections
	var/eye_safety = 0
	var/ear_safety = 0
	if(iscarbon(M))
		eye_safety = M.eyecheck()
		if(ishuman(M))
			if(M.get_sound_volume_multiplier() < 0.2)
				ear_safety += 2
			if(MUTATION_HULK in M.mutations)
				ear_safety += 1
			var/mob/living/carbon/human/H = M
			if(istype(H.head, /obj/item/clothing/head/helmet))
				ear_safety += 1

	//Flashing everyone
	M.flash_eyes(FLASH_PROTECTION_MODERATE)
	if(eye_safety < FLASH_PROTECTION_MODERATE)
		M.Stun(2)
		M.confused += 5

	//Now applying sound
	if(ear_safety)
		if(ear_safety < 2 && get_dist(M, T) <= 2)
			M.Stun(1)
			M.confused += 3

	else if(get_dist(M, T) <= 2)
		M.Stun(3)
		M.confused += 8
		M.ear_damage += rand(0, 5)
		M.ear_deaf = max(M.ear_deaf,15)

	else if(get_dist(M, T) <= 5)
		M.Stun(2)
		M.confused += 5
		M.ear_damage += rand(0, 3)
		M.ear_deaf = max(M.ear_deaf,10)

	else
		M.Stun(1)
		M.confused += 3
		M.ear_damage += rand(0, 1)
		M.ear_deaf = max(M.ear_deaf,5)

	//This really should be in mob not every check
	if (M.ear_damage >= 15)
		to_chat(M, "<span class='danger'>Your ears start to ring badly!</span>")
	else
		if (M.ear_damage >= 5)
			to_chat(M, "<span class='danger'>Your ears start to ring!</span>")


/obj/item/grenade/flashbang/instant/Initialize()
	. = ..()
	name = "arcane energy"
	icon_state = null
	item_state = null
	detonate()

/obj/item/grenade/flashbang/clusterbang//Created by Polymorph, fixed by Sieve
	desc = "Use of this weapon may constiute a war crime in your area, consult your local captain."
	name = "clusterbang"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "clusterbang"

/obj/item/grenade/flashbang/clusterbang/detonate(mob/living/user)
	var/numspawned = rand(4,8)
	var/again = 0
	for(var/more = numspawned,more > 0,more--)
		if(prob(35))
			again++
			numspawned --

	for(,numspawned > 0, numspawned--)
		new /obj/item/grenade/flashbang/cluster(src.loc)//Launches flashbangs
		playsound(src.loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)

	for(,again > 0, again--)
		new /obj/item/grenade/flashbang/clusterbang/segment(src.loc)//Creates a 'segment' that launches a few more flashbangs
		playsound(src.loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
	qdel(src)
	return

/obj/item/grenade/flashbang/clusterbang/segment
	desc = "A smaller segment of a clusterbang. Better run."
	name = "clusterbang segment"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "clusterbang_segment"

/obj/item/grenade/flashbang/clusterbang/segment/New()//Segments should never exist except part of the clusterbang, since these immediately 'do their thing' and asplode
	icon_state = "clusterbang_segment_active"
	active = 1
	banglet = 1
	var/stepdist = rand(1,4)//How far to step
	var/temploc = src.loc//Saves the current location to know where to step away from
	walk_away(src,temploc,stepdist)//I must go, my people need me
	var/dettime = rand(15,60)
	spawn(dettime)
		detonate()
	..()

/obj/item/grenade/flashbang/clusterbang/segment/detonate(mob/living/user)
	var/numspawned = rand(4,8)
	for(var/more = numspawned,more > 0,more--)
		if(prob(35))
			numspawned --

	for(,numspawned > 0, numspawned--)
		new /obj/item/grenade/flashbang/cluster(src.loc)
		playsound(src.loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
	qdel(src)
	return

/obj/item/grenade/flashbang/cluster/New()//Same concept as the segments, so that all of the parts don't become reliant on the clusterbang
	icon_state = "flashbang_active"
	active = 1
	banglet = 1
	var/stepdist = rand(1,3)
	var/temploc = src.loc
	walk_away(src,temploc,stepdist)
	var/dettime = rand(15,60)
	spawn(dettime)
		detonate()
	..()
