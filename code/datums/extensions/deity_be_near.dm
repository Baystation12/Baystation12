/datum/extension/deity_be_near
	expected_type = /obj/item
	var/keep_away_instead = FALSE
	var/mob/living/deity/connected_deity
	var/threshold_base = 6

/datum/extension/deity_be_near/New(var/datum/holder, var/mob/living/deity/connect)
	..()
	GLOB.moved_event.register(holder,src, .proc/check_movement)
	connected_deity = connect
	GLOB.destroyed_event.register(holder, src, .proc/dead_deity)

/datum/extension/deity_be_near/Destroy()
	GLOB.moved_event.unregister(holder,src)
	GLOB.destroyed_event.unregister(holder, src)
	. = ..()

/datum/extension/deity_be_near/proc/check_movement()
	var/obj/item/I = holder
	if(!istype(I.loc, /mob/living))
		return
	var/min_dist = INFINITY
	for(var/s in connected_deity.structures)
		var/dist = get_dist(holder,s)
		if(dist < min_dist)
			min_dist = dist
	if(min_dist)
		deal_damage(round(min_dist/threshold_base))
	else if(keep_away_instead)
		deal_damage(round(threshold_base/(min_dist*2)))


/datum/extension/deity_be_near/proc/deal_damage(var/mult)
	return

/datum/extension/deity_be_near/proc/dead_deity()
	var/obj/item/I = holder
	I.visible_message("<span class='warning'>\The [holder]'s power fades!</span>")
	qdel(src)