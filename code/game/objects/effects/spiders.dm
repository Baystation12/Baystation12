//generic procs copied from obj/alien
/obj/spider
	name = "web"
	desc = "It's stringy and sticky."
	icon = 'icons/effects/effects.dmi'
	anchored = TRUE
	density = FALSE
	health_max = 15

/obj/spider/on_death()
	visible_message(SPAN_WARNING("\The [src] breaks apart!"))
	qdel(src)

/obj/spider/stickyweb
	icon_state = "stickyweb1"

/obj/spider/stickyweb/Initialize()
	. = ..()
	if(prob(50))
		icon_state = "stickyweb2"

/obj/spider/stickyweb/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(istype(mover, /mob/living/simple_animal/hostile/giant_spider))
		return 1
	else if(istype(mover, /mob/living))
		if(prob(50))
			to_chat(mover, SPAN_WARNING("You get stuck in \the [src] for a moment."))
			return 0
	else if(istype(mover, /obj/item/projectile))
		return prob(30)
	return 1

/obj/spider/eggcluster
	name = "egg cluster"
	desc = "They seem to pulse slightly with an inner life."
	icon_state = "eggs"
	var/amount_grown = 0
	var/spiders_min = 6
	var/spiders_max = 12
	var/spider_type = /obj/spider/spiderling

/obj/spider/eggcluster/Initialize(mapload, atom/parent)
	. = ..()
	get_light_and_color(parent)
	pixel_x = rand(3,-3)
	pixel_y = rand(3,-3)
	START_PROCESSING(SSobj, src)

/obj/spider/eggcluster/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(istype(loc, /obj/item/organ/external))
		var/obj/item/organ/external/O = loc
		O.implants -= src
	. = ..()

/obj/spider/eggcluster/on_death()
	if (isturf(loc))
		var/amount_to_spawn = round(spiders_max * amount_grown / 100)
		for (var/count = 1 to amount_to_spawn)
			new spider_type(loc, src)
	. = ..()

/obj/spider/eggcluster/Process()
	if(prob(70))
		amount_grown += rand(0,2)
	if(amount_grown >= 100)
		var/num = rand(spiders_min, spiders_max)
		var/obj/item/organ/external/O = null
		if(istype(loc, /obj/item/organ/external))
			O = loc

		for(var/i=0, i<num, i++)
			var/spiderling = new spider_type(src.loc, src)
			if(O)
				O.implants += spiderling
		qdel(src)

/obj/spider/eggcluster/small
	spiders_min = 1
	spiders_max = 3

/obj/spider/eggcluster/small/frost
	spider_type = /obj/spider/spiderling/frost

/obj/spider/spiderling
	name = "spiderling"
	desc = "It never stays still for long."
	icon_state = "green"
	anchored = FALSE
	layer = BELOW_OBJ_LAYER
	health_max = 3
	health_resistances = DAMAGE_RESIST_BIOLOGICAL
	var/mob/living/simple_animal/hostile/giant_spider/greater_form
	var/last_itch = 0
	var/amount_grown = -1
	var/obj/machinery/atmospherics/unary/vent_pump/entry_vent
	var/travelling_in_vent = 0
	var/dormant = FALSE    // If dormant, does not add the spiderling to the process list unless it's also growing
	var/growth_chance = 50 // % chance of beginning growth, and eventually become a beautiful death machine

	var/shift_range = 6
	var/castes = list(/mob/living/simple_animal/hostile/giant_spider/lurker = 0.1,
						/mob/living/simple_animal/hostile/giant_spider/tunneler = 0.2,
						/mob/living/simple_animal/hostile/giant_spider/pepper = 0.5,
						/mob/living/simple_animal/hostile/giant_spider/webslinger = 1,
						/mob/living/simple_animal/hostile/giant_spider/electric = 0.5,
						/mob/living/simple_animal/hostile/giant_spider/thermic = 0.5,
						/mob/living/simple_animal/hostile/giant_spider/frost = 0.5,
						/mob/living/simple_animal/hostile/giant_spider/carrier = 2,
						/mob/living/simple_animal/hostile/giant_spider/phorogenic = 0.4,
						/mob/living/simple_animal/hostile/giant_spider = 2,
						/mob/living/simple_animal/hostile/giant_spider/guard = 2,
						/mob/living/simple_animal/hostile/giant_spider/nurse = 2,
						/mob/living/simple_animal/hostile/giant_spider/spitter = 2,
						/mob/living/simple_animal/hostile/giant_spider/hunter = 1)


/obj/spider/spiderling/frost
	castes = list(/mob/living/simple_animal/hostile/giant_spider/frost = 1)

/obj/spider/spiderling/Initialize(mapload, atom/parent)
	greater_form = pickweight(castes)
	pixel_x = rand(-shift_range, shift_range)
	pixel_y = rand(-shift_range, shift_range)

	if(prob(growth_chance))
		amount_grown = 1
		dormant = FALSE

	if(dormant)
		GLOB.moved_event.register(src, src, /obj/spider/spiderling/proc/disturbed)
	else
		START_PROCESSING(SSobj, src)

	get_light_and_color(parent)
	. = ..()

/obj/spider/spiderling/mundane
	growth_chance = 0 // Just a simple, non-mutant spider

/obj/spider/spiderling/mundane/dormant
	dormant = TRUE    // It lies in wait, hoping you will walk face first into its web

/obj/spider/spiderling/growing
	growth_chance = 100

/obj/spider/spiderling/Destroy()
	if(dormant)
		GLOB.moved_event.unregister(src, src, /obj/spider/spiderling/proc/disturbed)
	STOP_PROCESSING(SSobj, src)
	. = ..()


/obj/spider/spiderling/post_use_item(obj/item/tool, mob/user, interaction_handled, use_call, click_params)
	. = ..()
	if (interaction_handled && !health_dead())
		disturbed()


/obj/spider/spiderling/Crossed(mob/living/L)
	if(dormant && istype(L) && L.mob_size > MOB_TINY)
		disturbed()

/obj/spider/spiderling/proc/disturbed()
	if(!dormant)
		return
	dormant = FALSE

	GLOB.moved_event.unregister(src, src, /obj/spider/spiderling/proc/disturbed)
	START_PROCESSING(SSobj, src)

/obj/spider/spiderling/Bump(atom/user)
	if(istype(user, /obj/structure/table))
		forceMove(user.loc)
	else
		..()

/obj/spider/spiderling/on_death()
	visible_message(SPAN_WARNING("\The [src] dies!"))
	new /obj/decal/cleanable/spiderling_remains(loc)
	qdel(src)

/obj/spider/spiderling/proc/check_vent(obj/machinery/atmospherics/unary/vent_pump/exit_vent)
	if(QDELETED(exit_vent) || exit_vent.welded) // If it's qdeleted we probably were too, but in that case we won't be making this call due to timer cleanup.
		forceMove(get_turf(entry_vent))
		entry_vent = null
		return TRUE

/obj/spider/spiderling/proc/start_vent_moving(obj/machinery/atmospherics/unary/vent_pump/exit_vent, travel_time)
	if(check_vent(exit_vent))
		return
	if(prob(50))
		audible_message(SPAN_NOTICE("You hear something squeezing through the ventilation ducts."))
	forceMove(exit_vent)
	addtimer(new Callback(src, .proc/end_vent_moving, exit_vent), travel_time)

/obj/spider/spiderling/proc/end_vent_moving(obj/machinery/atmospherics/unary/vent_pump/exit_vent)
	if(check_vent(exit_vent))
		return
	forceMove(get_turf(exit_vent))
	travelling_in_vent = FALSE
	entry_vent = null

/obj/spider/spiderling/Process()

	if(loc)
		var/datum/gas_mixture/environment = loc.return_air()
		if(environment && environment.gas[GAS_METHYL_BROMIDE] > 0)
			kill_health()
			return

	if(travelling_in_vent)
		if(istype(src.loc, /turf))
			travelling_in_vent = 0
			entry_vent = null
	else if(entry_vent)
		if(get_dist(src, entry_vent) <= 1)
			if(entry_vent.network && length(entry_vent.network.normal_members))
				var/list/vents = list()
				for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in entry_vent.network.normal_members)
					vents.Add(temp_vent)
				if(!length(vents))
					entry_vent = null
					return
				var/obj/machinery/atmospherics/unary/vent_pump/exit_vent = pick(vents)

				forceMove(entry_vent)
				var/travel_time = round(get_dist(loc, exit_vent.loc) / 2)
				addtimer(new Callback(src, .proc/start_vent_moving, exit_vent, travel_time), travel_time + rand(20,60))
				travelling_in_vent = TRUE
				return
			else
				entry_vent = null
	//=================

	if(isturf(loc))
		if(prob(25))
			var/list/nearby = trange(5, src) - loc
			if(length(nearby))
				var/target_atom = pick(nearby)
				walk_to(src, target_atom, 5)
				if(prob(10))
					src.visible_message(SPAN_NOTICE("\The [src] skitters[pick(" away"," around","")]."))
					// Reduces the risk of spiderlings hanging out at the extreme ranges of the shift range.
					var/min_x = pixel_x <= -shift_range ? 0 : -2
					var/max_x = pixel_x >=  shift_range ? 0 :  2
					var/min_y = pixel_y <= -shift_range ? 0 : -2
					var/max_y = pixel_y >=  shift_range ? 0 :  2

					pixel_x = clamp(pixel_x + rand(min_x, max_x), -shift_range, shift_range)
					pixel_y = clamp(pixel_y + rand(min_y, max_y), -shift_range, shift_range)
		else if(prob(5))
			//vent crawl!
			for(var/obj/machinery/atmospherics/unary/vent_pump/v in view(7,src))
				if(!v.welded)
					entry_vent = v
					walk_to(src, entry_vent, 5)
					break

		if(amount_grown >= 100)
			if (GLOB.SPIDER_COUNT >= GLOB.MAX_SPIDER_COUNT)
				amount_grown = 1
				return
			new greater_form(src.loc, src)
			qdel(src)
	else if(isorgan(loc))
		if(!amount_grown) amount_grown = 1
		var/obj/item/organ/external/O = loc
		if(!O.owner || O.owner.stat == DEAD || amount_grown > 80)
			amount_grown = 20 //reset amount_grown so that people have some time to react to spiderlings before they grow big
			O.implants -= src
			forceMove(O.owner ? O.owner.loc : O.loc)
			src.visible_message(SPAN_WARNING("\A [src] emerges from inside [O.owner ? "[O.owner]'s [O.name]" : "\the [O]"]!"))
			if(O.owner)
				O.owner.apply_damage(5, DAMAGE_BRUTE, O.organ_tag)
				O.owner.apply_damage(3, DAMAGE_TOXIN, O.organ_tag)
		else if(prob(1))
			O.owner.apply_damage(1, DAMAGE_TOXIN, O.organ_tag)
			if(world.time > last_itch + 30 SECONDS)
				last_itch = world.time
				to_chat(O.owner, SPAN_NOTICE("Your [O.name] itches..."))
	else if(prob(1))
		src.visible_message(SPAN_NOTICE("\The [src] skitters."))

	if (istype(loc, /turf) || istype(loc, /obj/item/organ/external) && amount_grown > 0)
		amount_grown += rand(0,2)

/obj/decal/cleanable/spiderling_remains
	name = "spiderling remains"
	desc = "Green squishy mess."
	icon = 'icons/effects/effects.dmi'
	icon_state = "greenshatter"
	anchored = TRUE
	layer = BLOOD_LAYER

/obj/spider/cocoon
	name = "cocoon"
	desc = "Something wrapped in silky spider web."
	icon_state = "cocoon1"
	health_max = 60

/obj/spider/cocoon/Initialize()
	. = ..()
	icon_state = pick("cocoon1","cocoon2","cocoon3")


	for(var/atom/movable/O in loc)
		if(!O.anchored)
			O.forceMove(src)

			if (istype(O, /mob/living))
				var/mob/living/L = O
				if (!(L.status_flags & NOTARGET))
					L.status_flags ^= NOTARGET

/obj/spider/cocoon/Destroy()
	src.visible_message(SPAN_WARNING("\The [src] splits open."))
	for(var/atom/movable/A in contents)
		A.dropInto(loc)
		if (istype(A, /mob/living))
			var/mob/living/L = A
			if (L.status_flags & NOTARGET)
				L.status_flags ^= NOTARGET
	return ..()
