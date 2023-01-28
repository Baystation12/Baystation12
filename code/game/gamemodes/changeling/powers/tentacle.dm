/proc/get_steps_with_obstacles(turf/Turf1,turf/Turf2)
	var/list/steps = list()
	while(Turf1 != Turf2)
		var/turf/next_tile = get_step_towards(Turf1,Turf2)
		steps.Add(next_tile)
		Turf1 = next_tile
	return steps
/proc/find_tentacle_hit(list/tentacle_obstacles)
	for(var/turf/check_turf in tentacle_obstacles)
		if(check_turf.density)
			return check_turf
		for(var/obj/item in check_turf)
			if(!item.throwpass && item.density)
				return item
//commented out until sprite gets added
/*
/datum/power/changeling/tentacle
	name = "Tentacle"
	desc = "We reform our arm into a tentacle capable of grabbing objects or victims at a distance. Victims grabbed by the tentacle will have their stamina drained, and struggle to run away."
	helptext = "Items grabbed by the tentacle will be pulled directly into our hand."
	enhancedtext = "The range is extended to five tiles."
	ability_icon_state = "ling_sting_boost_range"
	genomecost = 2
	allowduringlesserform = 1
	verbpath = /mob/proc/changeling_tentacle
*/
/obj/item/tentacle
	name = "tentacle"
	desc = "A quivering tentacle of flesh that shudders with anticipation."
	icon = 'icons/obj/guns/confuseray.dmi'
	icon_state = "confuseray"
	canremove = FALSE
	throw_speed = 0
	throwforce = 0
	throw_range = 0
	var/default_range = 5
	var/last_tentacle = null
	var/cooldown = 4 SECONDS
/obj/item/tentacle/enhanced
	default_range = 7
/obj/ebeam/ling
	pass_flags = PASS_FLAG_TABLE

/obj/item/tentacle/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if ((last_tentacle + cooldown > world.time))
		to_chat(user, SPAN_WARNING("We are still recovering from our last tentacle attack."))
		return
	if(get_dist(user, target) >= default_range)
		to_chat(user,SPAN_WARNING("Our tentacle cannot extend to that distance!"))
		return
	var/list/tentacle_obstacles = get_steps_with_obstacles(get_turf(user),get_turf(target))
	if(find_tentacle_hit(tentacle_obstacles))
		target = find_tentacle_hit(tentacle_obstacles)
	user.Beam(BeamTarget = target, icon_state = "r_beam", time = 3, maxdistance = INFINITY, beam_type = /obj/ebeam/ling)

	user.visible_message(SPAN_DANGER("\the [user] lashes at \the [target] with their tentacle!"))
	playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
	last_tentacle = world.time
	if(isobj(target))
		var/obj/grabbed_object = target
		if(grabbed_object.anchored)
			to_chat(user,SPAN_WARNING("\the [grabbed_object] is too secured in place for our tentacle to get a good grip!"))
			return FALSE
		user.throw_mode_on()
		grabbed_object.throw_at(user, 5,3)
		qdel(src)
	if(ismob(target))
		var/mob/victim = target
		var/turf/tile = get_step_towards(user,victim)
		victim.throw_at(tile, 5,1)
		if(victim.get_active_hand())
			victim.unequip_item()
		if(istype(victim,/mob/living/carbon/human))
			var/mob/living/carbon/human/V = victim
			V.stamina = 0
	return TRUE
/mob/proc/changeling_tentacle()
	set category = "Changeling"
	set name = "Tentacle (20)"
	set desc="We transform one of our arms into a tentacle that can pull distant targets towards us."

	var/datum/changeling/changeling = changeling_power(10,0,100)
	if(!changeling)
		return TRUE

	var/holding = src.get_active_hand()
	if (istype(holding, /obj/item/tentacle))
		to_chat(src,SPAN_WARNING("We reform our arm from a tentacle back into its normal form."))
		playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
		qdel(holding)
		return 0

	changeling.chem_charges -= 10

	if(src.mind.changeling.recursive_enhancement)
		if(changeling_generic_weapon(/obj/item/tentacle/enhanced, 10))
			src.mind.changeling.recursive_enhancement = FALSE
			return 1

	else
		if(changeling_generic_weapon(/obj/item/tentacle, 10))
			return 1
		return 0
