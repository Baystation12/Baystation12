/datum/technomancer/spell/summon_ward
	name = "Summon Ward"
	desc = "Teleports a prefabricated 'ward' drone to the target location, which will alert you and your allies when it sees entities \
	moving around it, or when it is attacked.  They can see for up to five meters.  Wards expire in six minutes."
	enhancement_desc = "Wards can detect invisibile entities, and are more specific in relaying information about what it sees."
	cost = 25
	obj_path = /obj/item/weapon/spell/summon/summon_ward
	ability_icon_state = "tech_ward"
	category = UTILITY_SPELLS

/obj/item/weapon/spell/summon/summon_ward
	name = "summon ward"
	desc = "Finally, someone you can depend on to watch your back."
	icon_state = "ward"
	cast_methods = CAST_RANGED
	summoned_mob_type = /mob/living/simple_animal/ward
	cooldown = 10
	instability_cost = 5
	energy_cost = 500

/obj/item/weapon/spell/summon/summon_ward/on_summon(var/mob/living/simple_animal/ward/ward)
	ward.creator = owner
	if(check_for_scepter())
		ward.true_sight = 1
		ward.see_invisible = SEE_INVISIBLE_LEVEL_TWO

/mob/living/simple_animal/ward
	name = "ward"
	desc = "It's a little flying drone that seems to be watching you..."
	icon = 'icons/mob/critter.dmi'
	icon_state = "ward"
	resistance = 5
	wander = 0
	response_help   = "pets the"
	response_disarm = "swats away"
	response_harm   = "punches"
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	maxbodytemp = 0
	unsuitable_atoms_damage = 0
	heat_damage_per_tick = 0
	cold_damage_per_tick = 0

	var/true_sight = 0 // If true, detects more than what the Technomancer normally can't.
	var/mob/living/carbon/human/creator = null
	var/list/seen_mobs = list()

/mob/living/simple_animal/ward/death()
	if(creator)
		to_chat(creator,"<span class='danger'>Your ward inside [get_area(src)] was killed!</span>")
	..()
	qdel(src)

/mob/living/simple_animal/ward/proc/expire()
	if(creator && src)
		to_chat(creator,"<span class='warning'>Your ward inside [get_area(src)] expired.</span>")
		qdel(src)

/mob/living/simple_animal/ward/Life()
	..()
	detect_mobs()
	update_icons()

/mob/living/simple_animal/ward/proc/detect_mobs()
	var/list/things_in_sight = view(5,src)
	var/list/newly_seen_mobs = list()
	for(var/mob/living/L in things_in_sight)
		if(L == creator) // I really wish is_ally() was usable here.
			continue

		if(istype(L, /mob/living/simple_animal/ward))
			continue

		if(istype(L, /mob/living/simple_animal/hostile))
			var/mob/living/simple_animal/hostile/SA = L
			if(creator in SA.friends)
				continue

		if(!true_sight)
			var/atom/movable/lighting_overlay/light = locate(/atom/movable/lighting_overlay) in get_turf(L)
			var/light_amount = 1 // Unsimulated tiles are pretend-lit, so we need to be pretend too if that somehow happens.
			if(light)
				light_amount = (light.lum_r + light.lum_g + light.lum_b) / 3

			if(light_amount <= 0.5)
				continue // Too dark to see.

			if(L.alpha <= 127)
				continue // Too transparent, as a mercy to camo lings.

		// Warn the Technomancer when it sees a new mob.
		if(!(L in seen_mobs))
			seen_mobs.Add(L)
			newly_seen_mobs.Add(L)
			if(creator)
				if(true_sight)
					to_chat(creator,"<span class='notice'>Your ward at [get_area(src)] detected [english_list(newly_seen_mobs)].</span>")
				else
					to_chat(creator,"<span class='notice'>Your ward at [get_area(src)] detected something.</span>")

	// Now get rid of old mobs that left vision.
	for(var/mob/living/L in seen_mobs)
		if(!(L in things_in_sight))
			seen_mobs.Remove(L)


/mob/living/simple_animal/ward/update_icons()
	if(seen_mobs.len)
		icon_state = "ward_spotted"
		set_light(3, 3, l_color = "FF0000")
	else
		icon_state = "ward"
		set_light(3, 3, l_color = "00FF00")
	if(true_sight)
		overlays.Cut()
		var/image/I = image('icons/mob/critter.dmi',"ward_truesight")
		overlays.Add(I)

/mob/living/simple_animal/ward/invisible_detect
	true_sight = 1
	see_invisible = SEE_INVISIBLE_LEVEL_TWO
