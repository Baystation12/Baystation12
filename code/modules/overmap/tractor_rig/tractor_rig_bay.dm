/*
 * The landing bay: where a tractor rig's haul materialises.
 *
 * Map a bay by painting /area/tractor_bay (or a subtype) over open floor. The
 * console finds it with `bay_area_type`. Payloads only land on clear floor: no
 * walls, nothing dense, nobody standing there. Last haul's rock and wreckage
 * take up room and will block additional hauls
 *
 * Rock , since it turns the floor into a mineral wall until it's mined
 * out: never lands on wiring, pipes or machinery, beside a door, or on a
 * delivery chute's intake.
 *
 */

/area/tractor_bay
	name = "\improper Tractor Landing Bay"
	icon_state = "quartstorage"


/**
 * A snapshot of the bay's clear floor, handed out one turf or one cluster at a time
 * while a haul is placed.
 */
/datum/tractor_bay
	/// Clear floor not yet used by this haul.
	var/list/turf/free = list()


/datum/tractor_bay/New(area/bay_area)
	..()
	if (!bay_area)
		return
	for (var/turf/T as anything in get_area_turfs(bay_area))
		if (is_clear(T))
			free += T


/// Whether a turf can take a payload: plain floor, nothing dense, no living thing on it.
/proc/tractor_bay_turf_clear(turf/T)
	if (!istype(T, /turf/simulated/floor) || T.density)
		return FALSE
	for (var/atom/movable/thing as anything in T)
		if (thing.density || isliving(thing))
			return FALSE
	return TRUE


/**
 * Whether rock can replace this turf without burying anything: clear, with no
 * cables, pipes or machinery on it, not beside a door, and not a chute's intake.
 */
/proc/tractor_bay_turf_takes_rock(turf/T)
	if (!tractor_bay_turf_clear(T))
		return FALSE
	for (var/atom/movable/thing as anything in T)
		if (istype(thing, /obj/machinery) || istype(thing, /obj/structure/cable) || istype(thing, /obj/structure/disposalpipe))
			return FALSE
	for (var/direction in GLOB.cardinal)
		var/turf/next = get_step(T, direction)
		if (!next)
			continue
		if (locate(/obj/machinery/door) in next)
			return FALSE
		for (var/obj/machinery/disposal/deliveryChute/chute in next)
			if (get_step(chute, chute.dir) == T)
				return FALSE
	return TRUE


/datum/tractor_bay/proc/is_clear(turf/T, for_rock = FALSE)
	return for_rock ? tractor_bay_turf_takes_rock(T) : tractor_bay_turf_clear(T)


/// Takes one clear turf at random, or null if the bay is full. With `for_rock`, only turfs rock (ie, wall change) can safely replace.
//  We also update free here!
/datum/tractor_bay/proc/take_turf(for_rock = FALSE)
	var/list/candidates = free.Copy()
	while (length(candidates))
		var/turf/T = pick(candidates)
		candidates -= T
		if (!is_clear(T, for_rock))
			if (!is_clear(T))
				free -= T
			continue
		free -= T
		return T
	return null


/// Takes up to `size` clear turfs that touch each other, grown from a random start.
/datum/tractor_bay/proc/take_cluster(size, for_rock = FALSE)
	var/turf/start = take_turf(for_rock)
	if (!start)
		return list()
	var/list/cluster = list(start)
	var/list/edge = list(start)
	while (length(cluster) < size && length(edge))
		var/turf/from = pick(edge)
		var/list/options = list()
		for (var/direction in GLOB.cardinal)
			var/turf/next = get_step(from, direction)
			if ((next in free) && is_clear(next, for_rock))
				options += next
		if (!length(options))
			edge -= from
			continue
		var/turf/chosen = pick(options)
		free -= chosen
		cluster += chosen
		edge += chosen
	return cluster


/// A ring of field energy flaring on a turf where something has just landed.
/obj/effect/tractor_arrival
	name = ""
	icon = 'icons/effects/tractor_bay.dmi'
	icon_state = "land"
	layer = ABOVE_HUMAN_LAYER
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE


/obj/effect/tractor_arrival/Initialize()
	. = ..()
	var/matrix/big = matrix()
	big.Scale(2)
	animate(src, transform = big, alpha = 0, time = 8)
	QDEL_IN(src, 9)


/**
 * What a caught contact turns into in the bay. One singleton per kind of payload;
 * contacts point at theirs with `payload_type`.
 */
/singleton/tractor_payload
	abstract_type = /singleton/tractor_payload


/**
 * Reserves the bay turfs this payload will land on, without placing anything yet.
 * Returns the turfs; an empty list means it doesn't fit.
 */
/singleton/tractor_payload/proc/claim(datum/tractor_bay/bay)
	return list()


/// Makes the payload on turfs from `claim()`. Returns what it made that sits on a turf (not things inside containers).
/singleton/tractor_payload/proc/materialise(list/turf/turfs)
	return list()


/// Whether the payload's things are made when they launch and fly in themselves. Otherwise a stand-in flies and they appear on landing.
/singleton/tractor_payload/proc/flies_itself()
	return FALSE


/// Icon and state for the stand-in that flies in for this payload: list(icon, icon_state), or null for none.
/singleton/tractor_payload/proc/ghost_appearance()
	return null


/// Claims and materialises in one go. Returns the turfs used.
/singleton/tractor_payload/proc/deliver(datum/tractor_bay/bay)
	var/list/turfs = claim(bay)
	if (length(turfs))
		materialise(turfs)
	return turfs


/// A clump of rock walls, minable back to floor. `rock_type` picks plain rock based on how rich the ore is.
/singleton/tractor_payload/ore_cluster
	abstract_type = /singleton/tractor_payload/ore_cluster
	var/rock_type = /turf/simulated/mineral/random
	var/min_size = 4
	var/max_size = 6


/singleton/tractor_payload/ore_cluster/claim(datum/tractor_bay/bay)
	return bay.take_cluster(rand(min_size, max_size), TRUE)


/singleton/tractor_payload/ore_cluster/ghost_appearance()
	var/turf/rock = rock_type
	return list(initial(rock.icon), initial(rock.icon_state))


/singleton/tractor_payload/ore_cluster/materialise(list/turf/turfs)
	. = list()
	for (var/turf/T as anything in turfs)
		// Someone may have stepped in while it was on its way.
		if (!tractor_bay_turf_takes_rock(T))
			continue
		var/floor_type = T.type
		var/turf/simulated/mineral/rock = T.ChangeTurf(rock_type)
		if (istype(rock))
			// Mining it out gives the bay its floor back.
			rock.mined_turf = floor_type


/singleton/tractor_payload/ore_cluster/sparse
	rock_type = /turf/simulated/mineral/random
	min_size = 4
	max_size = 6

/singleton/tractor_payload/ore_cluster/rich
	rock_type = /turf/simulated/mineral/random/high_chance
	min_size = 7
	max_size = 10

/singleton/tractor_payload/ore_cluster/plain
	rock_type = /turf/simulated/mineral
	min_size = 3
	max_size = 4

/singleton/tractor_payload/ore_cluster/planetary
	rock_type = /turf/simulated/mineral/random
	min_size = 5
	max_size = 7


/**
 * Objects. With a `container_type`, everything goes inside one container on one turf (salvage crates). Without,
 * each `contents` entry gets its own turf and the rolled extras join the first.
 *
 * Counts can be a number or list(low, high). For stacks the count is the stack's amount; for
 * anything else it's how many to make. On top of `contents`, a payload can roll `extras` from
 * the shared pools below, so the same catch isn't the same haul twice.
 */
/singleton/tractor_payload/items
	abstract_type = /singleton/tractor_payload/items
	var/container_type
	/// Type = count. Always included.
	var/list/contents = list()
	/// Pool name (see tractor_loot_pool()) = number of rolls, or list(low, high).
	var/list/extras = list()
	/// Boxes of salvaged machine components, and the chance each part in them is a better one.
	var/parts_boxes = 0
	var/advanced_parts = 0


/singleton/tractor_payload/items/claim(datum/tractor_bay/bay)
	. = list()
	var/wanted = container_type ? 1 : max(1, length(contents))
	for (var/i = 1 to wanted)
		var/turf/T = bay.take_turf()
		if (!T)
			break
		. += T


/singleton/tractor_payload/items/flies_itself()
	return TRUE


/singleton/tractor_payload/items/materialise(list/turf/turfs)
	. = list()
	if (container_type)
		var/atom/container = new container_type(turfs[1])
		for (var/path in contents)
			make(path, contents[path], container)
		add_extras(container)
		. += container
		return
	var/i = 0
	for (var/path in contents)
		i++
		if (i > length(turfs))
			break
		var/turf/T = turfs[i]
		// Compare before and after, so things random spawners leave behind are caught too.
		var/list/before = T.contents.Copy()
		make(path, contents[path], T)
		for (var/atom/movable/thing in T.contents - before)
			if (!QDELETED(thing))
				. += thing
	if (length(turfs))
		var/turf/first = turfs[1]
		var/list/before = first.contents.Copy()
		add_extras(first)
		for (var/atom/movable/thing in first.contents - before)
			if (!QDELETED(thing))
				. += thing


/// Rolls the payload's extras and component boxes
/singleton/tractor_payload/items/proc/add_extras(atom/where)
	for (var/pool_name in extras)
		var/list/pool = tractor_loot_pool(pool_name)
		var/rolls = tractor_roll_count(extras[pool_name])
		for (var/i = 1 to rolls)
			var/path = pickweight(pool)
			make(path, tractor_loot_count(path), where)
	for (var/i = 1 to parts_boxes)
		tractor_parts_box(where, advanced_parts)

/// Setup stacks or items generically
/singleton/tractor_payload/items/proc/make(path, count, atom/where)
	count = tractor_roll_count(count)
	if (ispath(path, /obj/item/stack))
		new path(where, count)
		return
	for (var/i = 1 to count)
		new path(where)


/// A count that may be a number or list(low, high).
/proc/tractor_roll_count(count)
	if (islist(count))
		return rand(count[1], count[2])
	return count || 1


/**
 * Shared loot pools for tractor hauls, as type = weight NOT COUNT tractor_loot_count() says how many of each.
 */
/proc/tractor_loot_pool(name)
	var/static/list/pools = list(
		"common materials" = list(
			/obj/item/stack/material/steel = 6,
			/obj/item/stack/material/glass = 4,
			/obj/item/stack/material/rods = 4,
			/obj/item/stack/material/plastic = 3,
			/obj/item/stack/material/aluminium = 3,
			/obj/item/stack/material/glass/reinforced = 2,
			/obj/item/stack/material/plasteel = 1,
			/obj/item/stack/material/titanium = 1
		),
		"rare materials" = list(
			/obj/item/stack/material/silver = 4,
			/obj/item/stack/material/gold = 3,
			/obj/item/stack/material/uranium = 3,
			/obj/item/stack/material/phoron = 3,
			/obj/item/stack/material/platinum = 2,
			/obj/item/stack/material/glass/boron = 2,
			/obj/item/stack/material/osmium = 1,
			/obj/item/stack/material/diamond = 1
		),
		"gear" = list(
			/obj/item/device/flashlight = 3,
			/obj/item/crowbar = 2,
			/obj/item/stack/cable_coil = 3,
			/obj/item/tank/oxygen_emergency = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/device/flashlight/flare = 2,
			/obj/item/storage/box/glowsticks = 1,
			/obj/item/weldingtool = 1,
			/obj/item/device/radio = 1,
			/obj/item/device/gps = 1,
			/obj/random/tool = 3,
			/obj/random/powercell = 2,
			/obj/random/firstaid = 1,
			/obj/item/storage/toolbox/emergency = 1
		),
		"tech" = list(
			/obj/random/tech_supply = 5,
			/obj/random/powercell = 2,
			/obj/random/technology_scanner = 2,
			/obj/random/assembly = 2,
			/obj/random/advdevice = 1
		)
	)
	return pools[name]


/// How many of a pool's item come in one roll (if relevant, only stacks for now)
/proc/tractor_loot_count(path)
	var/static/list/counts = list(
		/obj/item/stack/material/steel = list(5, 12),
		/obj/item/stack/material/glass = list(4, 10),
		/obj/item/stack/material/rods = list(5, 10),
		/obj/item/stack/material/plastic = list(4, 8),
		/obj/item/stack/material/aluminium = list(3, 8),
		/obj/item/stack/material/glass/reinforced = list(3, 6),
		/obj/item/stack/material/plasteel = list(2, 5),
		/obj/item/stack/material/titanium = list(2, 4),
		/obj/item/stack/material/silver = list(2, 5),
		/obj/item/stack/material/gold = list(1, 4),
		/obj/item/stack/material/uranium = list(1, 4),
		/obj/item/stack/material/phoron = list(1, 4),
		/obj/item/stack/material/platinum = list(1, 3),
		/obj/item/stack/material/glass/boron = list(2, 5),
		/obj/item/stack/material/osmium = list(1, 2),
		/obj/item/stack/material/diamond = list(1, 2),
		/obj/item/stack/cable_coil = list(10, 30)
	)
	return counts[path] || 1


/// A box of salvaged machine components. Each part has `advanced` chance to be a better grade.
/proc/tractor_parts_box(atom/where, advanced = 0)
	var/static/list/basic = list(
		/obj/item/stock_parts/capacitor,
		/obj/item/stock_parts/scanning_module,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/micro_laser,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/console_screen,
		/obj/item/stock_parts/keyboard
	)
	var/static/list/better = list(
		/obj/item/stock_parts/capacitor = /obj/item/stock_parts/capacitor/adv,
		/obj/item/stock_parts/scanning_module = /obj/item/stock_parts/scanning_module/adv,
		/obj/item/stock_parts/manipulator = /obj/item/stock_parts/manipulator/nano,
		/obj/item/stock_parts/micro_laser = /obj/item/stock_parts/micro_laser/high,
		/obj/item/stock_parts/matter_bin = /obj/item/stock_parts/matter_bin/adv
	)
	var/obj/item/storage/box/box = new(where)
	box.SetName("salvaged components box")
	box.desc = "A battered box of machine components, pulled from a wreck."
	for (var/i = 1 to rand(3, 6))
		var/path = pick(basic)
		if (better[path] && prob(advanced * 100))
			path = better[path]
		new path(box)
	return box


/singleton/tractor_payload/items/scrap
	contents = list(/obj/item/stack/material/steel = list(4, 10))
	extras = list("common materials" = list(0, 1))

/singleton/tractor_payload/items/crate
	container_type = /obj/structure/closet/crate
	contents = list(/obj/random/maintenance = 2)
	extras = list("common materials" = list(1, 2), "gear" = list(1, 2))

/singleton/tractor_payload/items/charged_salvage
	contents = list(/obj/random/powercell = 1, /obj/item/excavation_sample/wreck = 1)
	extras = list("tech" = list(1, 2))
	parts_boxes = 1
	advanced_parts = 0.1

/singleton/tractor_payload/items/tech_crate
	container_type = /obj/structure/closet/crate
	extras = list("tech" = list(2, 3), "common materials" = 1)
	parts_boxes = 2
	advanced_parts = 0.25

/singleton/tractor_payload/items/hull_section
	contents = list(/obj/item/stack/material/plasteel = list(2, 5), /obj/structure/girder = 1)
	extras = list("common materials" = list(1, 2))

/singleton/tractor_payload/items/machine_frame
	contents = list(/obj/machinery/constructable_frame/machine_frame = 1)
	extras = list("tech" = 1)
	parts_boxes = 1
	advanced_parts = 0.15

/singleton/tractor_payload/items/locker
	container_type = /obj/structure/closet
	contents = list(/obj/random/loot = 2)
	extras = list("rare materials" = list(1, 2), "gear" = 1)

/singleton/tractor_payload/items/carp_remains
	contents = list(/obj/item/reagent_containers/food/snacks/fish/carp = list(1, 3))

/singleton/tractor_payload/items/anomaly
	contents = list(/obj/machinery/artifact = 1)


/**
 * A lost cargo pod: one of the supply catalogue's own crates, sealed and intact. Picked from the
 * engineering, materials, science, medical and atmospherics catalogues, priced from `min_cost` to
 * `max_cost`, so it's the good stuff without being the very best. Nothing locked, hidden or contraband. (Maybe if emagging?)
 */
/singleton/tractor_payload/supply_crate
	var/min_cost = 20
	var/max_cost = 80
	var/list/categories = list(
		/singleton/hierarchy/supply_pack/engineering,
		/singleton/hierarchy/supply_pack/materials,
		/singleton/hierarchy/supply_pack/science,
		/singleton/hierarchy/supply_pack/medical,
		/singleton/hierarchy/supply_pack/atmospherics
	)


/singleton/tractor_payload/supply_crate/claim(datum/tractor_bay/bay)
	var/turf/T = bay.take_turf()
	return T ? list(T) : list()


/singleton/tractor_payload/supply_crate/flies_itself()
	return TRUE


/singleton/tractor_payload/supply_crate/materialise(list/turf/turfs)
	var/turf/T = turfs[1]
	var/list/options = list()
	for (var/singleton/hierarchy/supply_pack/pack as anything in SSsupply.master_supply_list)
		if (pack.hidden || pack.contraband || pack.access || !length(pack.contains))
			continue
		if (isnull(pack.cost) || pack.cost < min_cost || pack.cost > max_cost)
			continue
		if (!is_type_in_list(pack, categories))
			continue
		options += pack
	var/singleton/hierarchy/supply_pack/pack = length(options) ? pick(options) : null
	var/obj/container
	if (pack)
		container = new pack.containertype(T)
		pack.spawn_contents(container)
		var/label = pack.containername || pack.name || "cargo pod"
		container.SetName("[label] (salvaged)")
		var/obj/item/paper/manifest = new(container)
		manifest.SetName("salvaged cargo manifest")
		manifest.info = "<b>Lost cargo pod, recovered by tractor rig</b><br>Contents: [pack.name]<hr>[pack.manifest]"
		container = null
	if (!container)
		if (!pack)
			log_and_message_admins("tractor rig: no supply packs fit a cargo pod; sending a parts crate instead. Report this", null, T)
		var/obj/structure/closet/crate/fallback = new(T)
		fallback.SetName("battered cargo pod")
		for (var/i = 1 to 3)
			tractor_parts_box(fallback, 0.3)
		container = fallback
	return list(container)


/**
 * A cluster of rock that's mostly one mineral: the specific veins a better scanner can pick out.
 * share of its tiles carry mineral, the rest are plain rock.
 */
/singleton/tractor_payload/ore_cluster/vein
	abstract_type = /singleton/tractor_payload/ore_cluster/vein
	rock_type = /turf/simulated/mineral
	min_size = 4
	max_size = 7
	var/mineral
	var/share = 0.75


/singleton/tractor_payload/ore_cluster/vein/materialise(list/turf/turfs)
	. = ..()
	var/material/ore = SSmaterials.get_material_by_name(mineral)
	if (!istype(ore))
		return
	for (var/turf/simulated/mineral/rock in turfs)
		if (!prob(share * 100))
			continue
		rock.mineral = ore
		rock.UpdateMineral()
		rock.update_icon()

/singleton/tractor_payload/ore_cluster/vein/iron
	mineral = MATERIAL_HEMATITE

/singleton/tractor_payload/ore_cluster/vein/carbon
	mineral = MATERIAL_GRAPHITE

/singleton/tractor_payload/ore_cluster/vein/silver
	mineral = MATERIAL_SILVER
	min_size = 3
	max_size = 5

/singleton/tractor_payload/ore_cluster/vein/gold
	mineral = MATERIAL_GOLD
	min_size = 3
	max_size = 5

/singleton/tractor_payload/ore_cluster/vein/platinum
	mineral = MATERIAL_PLATINUM
	min_size = 3
	max_size = 5

/singleton/tractor_payload/ore_cluster/vein/uranium
	mineral = MATERIAL_PITCHBLENDE
	min_size = 3
	max_size = 5

/singleton/tractor_payload/ore_cluster/vein/phoron
	mineral = MATERIAL_PHORON
	min_size = 4
	max_size = 6

/singleton/tractor_payload/ore_cluster/vein/diamond
	mineral = MATERIAL_DIAMOND
	min_size = 2
	max_size = 3
	share = 0.6


/// Hostile mobs, each on its own turf.
/singleton/tractor_payload/mobs
	abstract_type = /singleton/tractor_payload/mobs
	var/mob_type
	var/min_count = 1
	var/max_count = 1


/singleton/tractor_payload/mobs/claim(datum/tractor_bay/bay)
	. = list()
	for (var/i = 1 to rand(min_count, max_count))
		var/turf/T = bay.take_turf()
		if (!T)
			break
		. += T


/singleton/tractor_payload/mobs/ghost_appearance()
	var/mob/living/mob = mob_type
	return list(initial(mob.icon), initial(mob.icon_state))


/singleton/tractor_payload/mobs/materialise(list/turf/turfs)
	. = list()
	for (var/turf/T as anything in turfs)
		. += new mob_type(T)


/singleton/tractor_payload/mobs/carp
	mob_type = /mob/living/simple_animal/hostile/carp

/singleton/tractor_payload/mobs/hivebot
	mob_type = /mob/living/simple_animal/hostile/hivebot

/singleton/tractor_payload/mobs/rogue_drone
	mob_type = /mob/living/simple_animal/hostile/rogue_drone

/singleton/tractor_payload/mobs/lifeform
	mob_type = /mob/living/simple_animal/hostile/giant_spider
