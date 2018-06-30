/obj/structure/deity/gateway
	name = "gateway"
	desc = "A gateway into the unknown."
	power_adjustment = 0
	var/weakref/target_ref
	var/start_time = 0
	var/active_souls = 0
	var/power_drain = 15

/obj/structure/deity/gateway/New()
	..()
	if(linked_god)
		linked_god.power_per_regen -= power_drain
	START_PROCESSING(SSobj, src)

/obj/structure/deity/gateway/Process()
	var/mob/living/carbon/human/target = target_ref.resolve()
	if(target)
		if(get_turf(target) != get_turf(src))
			target = null
			start_time = 0
		else if(prob(5))
			to_chat(target,"<span class='danger'>\The [src] sucks at your lifeforce!</span>")
	if(start_time && world.time > start_time + 3000)
		start_time = 0
		to_chat(target,"<span class='danger'>You have been sucked into \the [src], your soul used to fuel \the [linked_god]'s minions.</span>")
		target.dust()
		active_souls++
		if(linked_god && power_drain < 5)
			linked_god.power_per_regen += 3
			power_drain += 3
	else
		//Get new target
		var/mob/living/carbon/human/T = locate() in get_turf(src)
		if(T)
			target_ref = weakref(T)
			start_time = world.time
			to_chat(T, "<span class='danger'>You feel your lifeforce begin to drain into \the [src]!</span>")

/obj/structure/deity/gateway/Destroy()
	linked_god.power_per_regen += power_drain
	. = ..()

/obj/structure/deity/radiant_statue
	name = "radiant statue"
	build_cost = 750
	power_adjustment = 1
	deity_flags = DEITY_STRUCTURE_NEAR_IMPORTANT|DEITY_STRUCTURE_ALONE
	var/charge = 0
	var/charging = 0 //Charging, dispersing, etc.

/obj/structure/deity/radiant_statue/Destroy()
	if(charging)
		STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/structure/deity/radiant_statue/proc/get_followers_nearby()
	. = list()
	if(linked_god)
		for(var/m in linked_god.minions)
			var/datum/mind/M = m
			if(get_dist(M.current, src) <= 3)
				. += M.current

/obj/structure/deity/radiant_statue/attack_deity(var/mob/living/deity/deity)
	if(activate_charging())
		to_chat(deity,"<span class='notice'>You activate \the [src], and it begins to charge as long as at least one of your followers is nearby.</span>")
	else
		to_chat(deity,"<span class='warning'>\The [src] is either already activated, or there are no followers nearby to charge it.</span>")

/obj/structure/deity/radiant_statue/proc/activate_charging()
	var/list/followers = get_followers_nearby()
	if(is_processing || !followers.len)
		return 0
	charging = 1
	START_PROCESSING(SSobj, src)
	src.visible_message("<span class='notice'><b>\The [src]</b> hums, activating.</span>")
	return 1

/obj/structure/deity/radiant_statue/Process()
	if(charging)
		charge++
		var/list/followers = get_followers_nearby()
		if(followers.len == 0)
			stop_charging()
			return

		if(charge == 40)
			src.visible_message("<span class='notice'><b>\The [src]</b> lights up, pulsing with energy.</span>")
			charging = 0
	else
		charge -= 0.5
		var/list/followers = get_followers_nearby()
		if(followers.len)
			for(var/m in followers)
				var/mob/living/L = m
				L.adjustFireLoss(-5)
				if(prob(50))
					to_chat(L, "<span class='notice'>You feel a pleasant warmth spread throughout your body...</span>")
				for(var/s in L.mind.learned_spells)
					var/spell/spell = s
					spell.charge_counter = spell.charge_max
		if(charge == 0)
			stop_charging()

/obj/structure/deity/radiant_statue/proc/stop_charging()
	STOP_PROCESSING(SSobj, src)
	src.visible_message("<span class='notice'><b>\The [src]</b> powers down, returning to it's dormant form.</span>")

/obj/structure/deity/blood_forge/starlight
	name = "radiant forge"
	desc = "a swath of heat and fire permeats from this forge."
	recipe_feat_list = "Fire Crafting"
	text_modifications = list("Cost" = "Burn",
								"Dip" = "fire. Pain envelopes you as dark burns mar your hands and you begin to shape it into something more useful",
								"Shape" = "You shape the fire, ignoring the painful burns it gives you in the process.",
								"Out" = "flames")
