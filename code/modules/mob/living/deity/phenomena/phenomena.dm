/datum/phenomena
	var/name = "Phenomena"
	var/desc = "This has no desc."
	var/cost = 0
	var/mob/living/deity/linked
	var/flags = 0
	var/cooldown = 10
	var/refresh_time = 0
	var/expected_type

/datum/phenomena/New(var/master)
	linked = master
	..()

/datum/phenomena/Destroy()
	linked.remove_phenomena(src)
	return ..()

/datum/phenomena/proc/Click(var/atom/target)
	if(can_activate(target))
		linked.adjust_power(-cost)
		refresh_time = world.time + cooldown
		activate(target)

/datum/phenomena/proc/can_activate(var/atom/target)
	if(!linked)
		return 0
	if(refresh_time > world.time)
		to_chat(linked, "<span class='warning'>\The [src] is still on cooldown for [round((refresh_time - world.time)/10)] more seconds!</span>")
		return 0

	if(!linked.form)
		to_chat(linked, "<span class='warning'>You must choose your form first!</span>")
		return 0

	if(expected_type && !istype(target,expected_type))
		return 0

	if(flags & PHENOMENA_NEAR_STRUCTURE)
		if(!linked.near_structure(target, 1))
			to_chat(linked, "<span class='warning'>\The [target] needs to be near a holy structure for your powers to work!</span>")
			return 0

	if(isliving(target))
		var/mob/living/L = target
		if(!L.mind || !L.client)
			if(!(flags & PHENOMENA_MUNDANE))
				to_chat(linked, "<span class='warning'>\The [L]'s mind is too mundane for you to influence.</span>")
				return 0
		else
			if(linked.is_follower(target, silent = 1))
				if(!(flags & PHENOMENA_FOLLOWER))
					to_chat(linked, "<span class='warning'>You can't use [name] on the flock!</span>")
					return 0
			else if(!(flags & PHENOMENA_NONFOLLOWER))
				to_chat(linked, "<span class='warning'>You can't use [name] on non-believers.</span>")
				return 0

	if(cost > linked.power)
		to_chat(linked, "<span class='warning'>You need more power to use [name] (Need [cost] power, have [linked.power])!</span>")
		return 0

	return 1

/datum/phenomena/proc/activate(var/target)
	to_chat(linked, "<span class='notice'>You use the phenomena [name] on \the [target]</span>")
	log_and_message_admins("uses the phenomena [name] on \the [target]", linked, get_turf(target))
	return

/datum/phenomena/proc/get_desc()
	. = desc
	if(cooldown)
		. = "<b>Cooldown: [cooldown/10] seconds.</b> [.]"
	if(cost)
		. = "<b>Cost: [cost] power.</b> [.]"