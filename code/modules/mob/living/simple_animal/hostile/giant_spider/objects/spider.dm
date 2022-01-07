/// Mundane spider type.
/obj/item/spider
	name = "spider"
	desc = "It never stays still for long."
	icon = 'icons/spider.dmi'
	icon_state = "spiderling"
	health_max = 4
	w_class = ITEM_SIZE_TINY
	layer = BELOW_OBJ_LAYER

	/// null | number. The time at which the spider will stop moving. If null, the spider can never start.
	var/active_until = 0

	/// number. The overall maximum time from "now" that spiders can be active for.
	var/static/const/ACTIVE_MAX = 60 SECONDS

	/// number. The maximum time that environmental effects can cause activity for.
	var/static/const/ACTIVE_AIR = 15 SECONDS

	/// null | weakref. The pipe_network the spider has entered, it if has.
	var/weakref/entered_network

	/// null | weakref. The vent the spider used to enter entered_network.
	var/weakref/entered_vent

	/// The kind of remains this spider will leave if it dies.
	var/remains = /obj/item/spider_remains


/obj/item/spider/Destroy()
	entered_network =  null
	entered_vent = null
	SSspiders.spiders -= src
	return ..()


/obj/item/spider/Initialize(mapload, atom/parent)
	. = ..()
	UpdateOffset()
	get_light_and_color(parent)
	SSspiders.spiders += src


/obj/item/spider/VV_static()
	return ..() + list(
		"ACTIVE_MAX",
		"ACTIVE_AIR",
		"PASSABLE_STRUCTURES"
	)


/obj/item/spider/Crossed(atom/movable/movable)
	if (isnull(active_until))
		return
	if (!isliving(movable))
		return
	var/mob/living/living = movable
	if (living.mob_size < MOB_SMALL)
		return
	MakeActive()


/obj/item/spider/Bump(atom/atom)
	if (atom.spider_passable)
		forceMove(atom.loc)
	else
		..()

/// Determines whether the atom should be passable by spiders, even if dense.
/atom/var/spider_passable = FALSE

/mob/spider_passable = TRUE

/obj/item/spider_passable = TRUE

/obj/machinery/spider_passable = TRUE

/obj/structure/table/spider_passable = TRUE

/obj/structure/railing/spider_passable = TRUE

/obj/structure/barricade/spider_passable = TRUE

/obj/structure/closet/spider_passable = TRUE


/obj/item/spider/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if (exposed_temperature > T50C)
		damage_health(health_max, DAMAGE_FIRE)


/obj/item/spider/post_health_change(health_mod, damage_type)
	switch (damage_type)
		if (DAMAGE_BRUTE)
			remains = /obj/effect/decal/cleanable/spider_remains
		if (DAMAGE_FIRE, DAMAGE_BURN)
			remains = /obj/effect/decal/cleanable/ash
		else
			remains = /obj/item/spider_remains


/obj/item/spider/handle_death_change(is_dead)
	if (!is_dead)
		return
	var/is_turf = isturf(loc)
	if (remains && (is_turf || isobj(loc)))
		new remains (loc)
	if (is_turf)
		visible_message(SPAN_ITALIC("\The [src] dies."), range = 2)
	else if (ismob(loc))
		to_chat(loc, SPAN_WARNING("Your \improper [src] dies."))
	qdel(src)


/obj/item/spider/Process(at_uptime)
	if (!loc)
		return
	var/datum/gas_mixture/air = loc.return_air()
	if (!air)
		damage_health(Frand(0.1, 0.2), DAMAGE_OXY)
		MakeActive(null, at_uptime, ACTIVE_AIR)
	else
		var/damage = 0
		if (air.temperature > T0C + 50)
			damage += damage_health(Frand(0.1, 0.2), DAMAGE_BURN)
		if (air.gas[GAS_METHYL_BROMIDE] > 0)
			damage += damage_health(Frand(0.2, 1.0), DAMAGE_TOXIN)
		if (damage)
			MakeActive(null, at_uptime, ACTIVE_AIR)
	else if (prob(5))
		MakeActive(null, at_uptime)
	if (active_until > at_uptime)
		BeActive(at_uptime)


/obj/item/spider/proc/BeActive(at_uptime)
	var/exited_network
	if (entered_network)
		if (prob(20))
			exited_network = TRUE
			ExitNetwork()
			if (QDELETED(src))
				return
	if (isturf(loc))
		if (prob(33) || exited_network)
			var/list/nearby = trange(5, loc) - loc
			if (!length(nearby))
				return
			walk_to(src, pick(nearby), speed = 4)
			UpdateOffset()
			nearby = oview(1, loc)
			for (var/atom/movable in nearby)
			return
	else if (ismob(loc))
		if (prob(2))
			var/mob/living/living = loc
			if (!living.unEquip(src, living.loc))
				return
			to_chat(living, SPAN_WARNING("\The [src] struggles away from you!"))
	else if (isorgan(loc))
		var/obj/item/organ/external/O = loc






else if (isorgan(loc))
		if (!amount_grown)
			amount_grown = 1

		if (amount_grown > 80 || !O.owner || O.owner.stat == DEAD)
			amount_grown = 20
			O.implants -= src
			forceMove(O.owner ? O.owner.loc : O.loc)
			visible_message(
				SPAN_WARNING("\A [src] emerges from inside [O.owner ? "[O.owner]'s [O.name]" : "\the [O]"]!")
			)
			if (O.owner)
				O.owner.apply_damage(5, BRUTE, O.organ_tag)
				O.owner.apply_damage(3, TOX, O.organ_tag)
		else if (prob(1))
			O.owner.apply_damage(1, TOX, O.organ_tag)
			if (world.time > last_itch + 30 SECONDS)
				last_itch = world.time
				to_chat(O.owner, SPAN_WARNING("Your [O.name] itches..."))









/// If we are in a pipe network, make a best attempt at leaving it.
/obj/item/spider/proc/ExitNetwork()
	if (!entered_network && !entered_vent)
		return
	var/obj/machinery/atmospherics/unary/vent_pump/vent
	var/datum/pipe_network/network = entered_network.resolve()
	if (!network)
		vent = entered_vent.resolve()
		if (vent)
			ExitVent(vent)
			return
		qdel(src)
		return
	var/list/exits = list()
	for (vent in network.normal_members)
		if (!vent.welded)
			exits += vent
	vent = entered_vent.resolve()
	if (vent)
		exits -= vent
	if (length(exits))
		ExitVent(pick(exits))
	else if (vent)
		ExitVent(vent)
	else
		qdel(src)


/obj/item/spider/proc/ExitVent(obj/machinery/atmospherics/unary/vent_pump/vent)
	dropInto(vent.loc)
	visible_message(SPAN_WARNING("\A [src] drops out of \the [vent]!"), range = 2)
	entered_network = null
	entered_vent = null


/obj/item/spider/proc/MakeActive(duration, at_uptime = Uptime(), active_limit)
	if (isnull(active_until))
		return
	if (duration < 1)
		duration = Frand(5, 10) SECONDS
	if (active_until < at_uptime)
		active_until = at_uptime
	if (active_limit)
		active_until = min(active_until + duration, active_until + active_limit)
	else
		active_until += duration
	active_until = min(at_uptime + ACTIVE_MAX, active_until)


/obj/item/spider/proc/MakeInactive(permanent)
	active_until = permanent ? null : 0


/obj/item/spider/proc/UpdateOffset()
	pixel_x = Round((rand(1, 7) + rand(1, 7)) * 0.5 - 4)
	pixel_y = Round((rand(1, 7) + rand(1, 7)) * 0.5 - 4)
