/**
 * One thing drifting in the playfield.
 *
 * Its position is a pure function of time, so the server always knows where it
 * is without ticking, and the client can animate the same motion on its own.
 */
/datum/tractor_field_contact
	/// What it is.
	var/singleton/tractor_contact/info
	/// Which source put it here.
	var/singleton/tractor_theme/source
	/// The overmap object it came from, or null for open space. Hauling it drains that object's yield.
	var/obj/overmap/source_object
	/// The probe that put that object in reach, if it was out of the ship's own scanner range.
	var/obj/overmap/via_probe
	/// Depth below the hull, in pixels.
	var/depth_px
	/// Centre x at `start_time`, in pixels.
	var/start_x
	/// world.time its motion is measured from.
	var/start_time
	/// Signed drift speed in pixels per decisecond. Positive drifts right.
	var/speed


/datum/tractor_field_contact/New(singleton/tractor_contact/info, singleton/tractor_theme/source, obj/overmap/source_object, obj/overmap/via_probe)
	..()
	src.info = info
	src.source = source
	src.source_object = source_object
	src.via_probe = via_probe
	var/depth_m = rand(round(info.min_depth * 10), round(min(info.max_depth, TRACTOR_MAX_DEPTH_M) * 10)) / 10
	depth_px = round(depth_m * TRACTOR_PX_PER_M)
	start_x = rand(0, TRACTOR_FIELD_WIDTH)
	start_time = world.time
	speed = rand(round(info.min_speed * 10), round(info.max_speed * 10)) / 10 * pick(-1, 1)


/// Centre x at `time`. Contacts wrap from one side of the field to the other.
/datum/tractor_field_contact/proc/x_at(time)
	var/half = info.hit_width() / 2
	var/span = TRACTOR_FIELD_WIDTH + info.hit_width()
	var/travelled = abs(speed) * (time - start_time)
	if (speed >= 0)
		return -half + tractor_rig_mod(start_x + half + travelled, span)
	return TRACTOR_FIELD_WIDTH + half - tractor_rig_mod(TRACTOR_FIELD_WIDTH + half - start_x + travelled, span)


/// How far around a launched sensor probe the rig can reach, in overmap tiles.
#define TRACTOR_PROBE_REACH 1


/**
 * A mix of every overmap source in scanner range around the ship, and
 * in the tiles right around any sensor probe the ship has out.
 *
 * Each source is one overmap object (or open space). Hauling things out of a source
 * uses up its yield: see tractor_drain_source().
 */
/datum/tractor_field
	/// Every contact currently drifting.
	var/list/datum/tractor_field_contact/contacts = list()
	/// Theme = combined weight, after distance falloff.
	var/list/theme_weights = list()
	/// Theme = label for the field mix panel, like "carp shoal, 1 tile east".
	var/list/theme_labels = list()
	/// Source = weight. A source is an overmap object, or the open space theme itself.
	var/list/source_weights = list()
	/// Source = its theme.
	var/list/source_themes = list()
	/// Source = the probe that reaches it, for sources only a probe brings in range.
	var/list/source_probes = list()
	/// The ship the field is around.
	var/obj/overmap/visitable/ship/ship


/datum/tractor_field/New(obj/overmap/visitable/ship/ship, scan_range)
	..()
	src.ship = ship
	collect_sources(ship, scan_range)
	var/total = 0
	for (var/theme in theme_weights)
		total += theme_weights[theme]
	var/count = clamp(round(10 + total * 3), 10, 22)
	for (var/i = 1 to count)
		add_random_contact()


/datum/tractor_field/Destroy()
	QDEL_NULL_LIST(contacts)
	ship = null
	source_weights.Cut()
	source_themes.Cut()
	source_probes.Cut()
	return ..()


/// The sensor probes this ship has out and still talking to its sensors.
/// May need to subscribe if this is expensive to lookup
/proc/tractor_ship_probes(obj/overmap/visitable/ship/ship)
	. = list()
	if (!ship)
		return
	for (var/obj/machinery/shipsensors/sensor in ship.sensors)
		for (var/obj/overmap/probe as anything in sensor.external_sources)
			if (!QDELETED(probe) && probe.z == ship.z)
				. |= probe


/datum/tractor_field/proc/collect_sources(obj/overmap/visitable/ship/ship, scan_range)
	var/singleton/tractor_theme/open = GET_SINGLETON(/singleton/tractor_theme/open_space)
	source_weights[open] = open.weight
	source_themes[open] = open
	theme_weights[open] = open.weight
	theme_labels[open] = "open space"
	var/turf/centre = get_turf(ship)
	if (!centre)
		return
	// Thing = list(effective distance, probe or null, label). The closest way of reaching each one wins.
	var/list/reached = list()
	// Theme = distance of the source its label describes.
	var/list/label_distance = list()
	for (var/turf/T in range(scan_range, centre))
		var/distance = get_dist(centre, T)
		for (var/obj/overmap/thing in T)
			var/label = distance ? "[distance] tile[distance > 1 ? "s" : ""] [dir2text(get_dir(centre, T))]" : "this tile"
			reached[thing] = list(distance, null, label)
	// A probe reaches the tiles right around it. It's a relay, so it counts as a tile further off than it is.
	for (var/obj/overmap/probe as anything in tractor_ship_probes(ship))
		var/turf/probe_turf = get_turf(probe)
		if (!probe_turf)
			continue
		for (var/turf/T in range(TRACTOR_PROBE_REACH, probe_turf))
			var/distance = get_dist(probe_turf, T) + 1
			for (var/obj/overmap/thing in T)
				var/list/best = reached[thing]
				if (best && best[1] <= distance)
					continue
				reached[thing] = list(distance, probe, "via [probe.name], [get_dist(centre, T)] tiles [dir2text(get_dir(centre, T))]")
	for (var/obj/overmap/thing as anything in reached)
		// Ships and probes aren't sources, and a temporary sector is just empty space someone drifted into so ignore them
		if (thing == ship || istype(thing, /obj/overmap/visitable/ship) || istype(thing, /obj/overmap/projectile) || istype(thing, /obj/overmap/visitable/sector/temporary))
			continue
		var/singleton/tractor_theme/theme = get_tractor_theme(thing)
		if (!theme)
			continue
		var/list/how = reached[thing]
		var/distance = how[1]
		var/weight = theme.weight / (1 + distance) * tractor_source_richness(thing, theme)
		if (weight <= 0)
			continue
		source_weights[thing] = weight
		source_themes[thing] = theme
		if (how[2])
			source_probes[thing] = how[2]
		theme_weights[theme] = (theme_weights[theme] || 0) + weight
		var/label = "[theme.name], [how[3]][tractor_source_state(thing, theme)]"
		// Keep the label of the closest occurrence.
		if (!theme_labels[theme] || isnull(label_distance[theme]) || distance < label_distance[theme])
			theme_labels[theme] = label
			label_distance[theme] = distance


/// Adds one contact, picking a source by weight and then a contact type from its theme.
/datum/tractor_field/proc/add_random_contact()
	var/source = pickweight(source_weights)
	var/singleton/tractor_theme/theme = source_themes[source]
	var/list/weights = theme?.contact_weights()
	if (!length(weights))
		return
	var/obj/overmap/source_object = isobj(source) ? source : null
	if (source_object && QDELETED(source_object))
		source_weights -= source
		return add_random_contact()
	var/contact_path = pickweight(weights)
	var/singleton/tractor_contact/info = GET_SINGLETON(contact_path)
	// Keep ship threats rare: at most two in the field.
	if (info.kind == TRACTOR_CONTACT_THREAT && count_kind(TRACTOR_CONTACT_THREAT) >= 2)
		return add_random_contact()
	if (!info.can_appear(src))
		return add_random_contact()
	var/datum/tractor_field_contact/contact = new(info, theme, source_object, source_probes[source])
	contacts += contact
	return contact


/// How many contacts in the field are `path` or a subtype of it.
/datum/tractor_field/proc/count_type(path)
	. = 0
	for (var/datum/tractor_field_contact/contact as anything in contacts)
		if (istype(contact.info, path))
			.++


/datum/tractor_field/proc/count_kind(kind)
	. = 0
	for (var/datum/tractor_field_contact/contact as anything in contacts)
		if (contact.info.kind == kind)
			.++


/// Field mix as list(list(label, percent)), biggest share first.
/datum/tractor_field/proc/mix_summary()
	var/total = 0
	for (var/theme in theme_weights)
		total += theme_weights[theme]
	var/list/rows = list()
	for (var/singleton/tractor_theme/theme in theme_weights)
		var/percent = total ? round(100 * theme_weights[theme] / total) : 0
		var/inserted = FALSE
		for (var/i = 1 to length(rows))
			var/list/row = rows[i]
			if (percent > row[2])
				rows.Insert(i, list(list(theme_labels[theme], percent)))
				inserted = TRUE
				break
		if (!inserted)
			rows += list(list(theme_labels[theme], percent))
	return rows


/obj/overmap
	/// Mass the tractor rig has hauled out of this, against its theme's yield.
	var/tractor_yield_used = 0


/// How much of a source's yield is left, from 0 to 1. Endless sources are always 1.
/proc/tractor_source_left(obj/overmap/source, singleton/tractor_theme/theme)
	if (!source || !theme?.yield)
		return 1
	return clamp(1 - source.tractor_yield_used / theme.yield, 0, 1)


/// How much a source adds to the field: it thins as it's exploited, and a picked-clean sector still gives a little.
/proc/tractor_source_richness(obj/overmap/source, singleton/tractor_theme/theme)
	var/left = tractor_source_left(source, theme)
	if (left <= 0)
		return theme.exhausts_away ? 0 : 0.15
	return 0.4 + 0.6 * left


/// A note for the field mix panel on how worked a source is.
/proc/tractor_source_state(obj/overmap/source, singleton/tractor_theme/theme)
	if (!theme?.yield)
		return ""
	var/left = tractor_source_left(source, theme)
	if (left <= 0)
		return " (picked clean)"
	if (left < 0.4)
		return " (thinning)"
	return ""


/**
 * Takes `mass` out of a source's yield. When it runs out, an overmap event is
 * replaced by its theme's `exhausted_type` (or removed);
 * Returns what to tell the operator if it ran out, or null.
 */
/proc/tractor_drain_source(obj/overmap/source, singleton/tractor_theme/theme, mass)
	if (QDELETED(source) || !theme?.yield || mass <= 0)
		return
	var/was_left = tractor_source_left(source, theme)
	source.tractor_yield_used += mass
	if (was_left <= 0 || tractor_source_left(source, theme) > 0)
		return
	var/message = "The [theme.name] at [source.x],[source.y] has been [theme.exhausted_message]."
	if (theme.exhausts_away)
		var/turf/T = get_turf(source)
		new /obj/effect/tractor_overmap_puff(T)
		var/atom/next_type = theme.exhausted_type
		log_and_message_admins("tractor rig: exhausted \a [source] at [source.x],[source.y][next_type ? ", leaving \a [initial(next_type.name)]" : ""].", null)
		qdel(source)
		if (T && theme.exhausted_type)
			new theme.exhausted_type(T)
	return message


/**
 * The rig at work, seen on the overmap: a tractor line from the ship to the source a haul
 * is coming from, relayed through the probe if one is in the way.
 */
/obj/ebeam/tractor_overmap
	color = TRACTOR_COLOUR_FIELD
	alpha = 200
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE


/obj/ebeam/tractor_overmap/Initialize()
	. = ..()
	animate(src, alpha = 110, time = 4, loop = -1, easing = SINE_EASING)
	animate(alpha = 220, time = 4, easing = SINE_EASING)


/// Draws the overmap tractor line from `ship` to `target` (through `probe`) for `time`.
/proc/tractor_overmap_beam(obj/overmap/ship, obj/overmap/target, obj/overmap/probe, time)
	if (QDELETED(ship) || QDELETED(target) || time <= 0)
		return
	if (probe && !QDELETED(probe))
		ship.Beam(probe, "b_beam", 'icons/effects/beam.dmi', time, 20, /obj/ebeam/tractor_overmap)
		probe.Beam(target, "b_beam", 'icons/effects/beam.dmi', time, 20, /obj/ebeam/tractor_overmap)
	else
		ship.Beam(target, "b_beam", 'icons/effects/beam.dmi', time, 20, /obj/ebeam/tractor_overmap)
	new /obj/effect/tractor_overmap_ring(get_turf(target), time)


/// A ring pulsing on a source's overmap tile while the rig hauls from it.
/obj/effect/tractor_overmap_ring
	icon = 'icons/effects/tractor_bay.dmi'
	icon_state = "field"
	color = TRACTOR_COLOUR_FIELD
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	layer = ABOVE_OBJ_LAYER


/obj/effect/tractor_overmap_ring/Initialize(mapload, time = 3 SECONDS)
	. = ..()
	alpha = 0
	transform = matrix() * 0.5
	animate(src, alpha = 160, transform = matrix() * 1.1, time = 6, loop = -1, easing = SINE_EASING)
	animate(alpha = 0, transform = matrix() * 0.5, time = 0)
	QDEL_IN(src, max(time, 1 SECOND))


/// A burst on the overmap where a source was used up.
/obj/effect/tractor_overmap_puff
	icon = 'icons/effects/tractor_bay.dmi'
	icon_state = "field"
	color = "#d8d8d8"
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	layer = ABOVE_OBJ_LAYER


/obj/effect/tractor_overmap_puff/Initialize()
	. = ..()
	animate(src, alpha = 0, transform = matrix() * 2, time = 2 SECONDS, easing = QUAD_EASING | EASE_OUT)
	QDEL_IN(src, 2 SECONDS)


#undef TRACTOR_PROBE_REACH
