/datum/phenomena
	var/name = "Phenomena"
	var/cost = 0
	var/mob/living/deity/linked
	var/flags = 0
	var/expected_type

/datum/phenomena/New(var/master)
	linked = master
	..()

/datum/phenomena/Destroy()
	linked.remove_phenomena(src)
	return ..()

/datum/phenomena/proc/Click(var/atom/target)
	if(can_activate(target))
		activate(target)

/datum/phenomena/proc/can_activate(var/atom/target)
	if(!linked)
		return 0

	if(!linked.form)
		to_chat(linked, "<span class='warning'>You must choose your form first!</span>")
		return 0

	if(expected_type && !istype(target,expected_type))
		return 0

	if(flags & PHENOMENA_NEAR_STRUCTURE)
		if(!linked.near_structure(target))
			to_chat(linked, "<span class='warning'>\The [target] needs to be near a holy structure for your powers to work!</span>")
			return 0

	if(isliving(target))
		var/mob/living/L = target
		if(!L.mind || !L.client)
			if(!(flags & PHENOMENA_MUNDANE))
				to_chat(linked, "<span class='warning'>\The [L]'s mind is too mundane for you to influence.</span>")
				return 0
		else if(linked.is_follower(target) == !(flags & PHENOMENA_FOLLOWER))
			to_chat(linked, "<span class='warning'>You can only use [name] on [flags & PHENOMENA_FOLLOWER ? "" : "non"]followers!</span>")
			return 0

	if(cost > linked.mob_uplink.uses)
		to_chat(linked, "<span class='warning'>You need more power to use [name]!</span>")
		return 0

	linked.take_cost(cost)
	return 1

/datum/phenomena/proc/activate(var/target)
	return