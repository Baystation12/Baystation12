/*
 * Tractor rig content: what can drift through the playfield, and which overmap
 * objects put it there. THIS IS THE ACTUAL MINIGAME
 *
 * A contact type describes one kind of thing in the field. A theme describes a
 * source (an overmap event or sector type) as a weighted list of contact types.
 * The field mixes every theme in scanner range, weighted by distance.
 */

/singleton/tractor_contact
	abstract_type = /singleton/tractor_contact
	/// Name shown on the playfield and in the haul report.
	var/name = "contact"
	/// Icon state in 'icons/effects/tractor_rig.dmi'.
	var/icon_state = "unknown"
	/// One of TRACTOR_CONTACT_*.
	var/kind = TRACTOR_CONTACT_RESOURCE
	/// Sprite size in pixels before scale : the opaque part of its icon state. Used as its hit box,
	/// so keep these matching the sprite if you redraw it.
	var/width = 24
	var/height = 16
	/// Sprite scale.
	var/scale = 1
	/// Whether the sprite faces left, so it's flipped when drifting right (couldn't get movement states to work)
	var/faces_left = FALSE
	/// Load it adds to the claw when latched.
	var/mass = 1
	/// Depth band, in metres below the hull.
	var/min_depth = 2
	var/max_depth = 28
	/// Drift speed range, in pixels per decisecond.
	var/min_speed = 1
	var/max_speed = 2.5
	/// Whether touching it latches it onto the claw. Hazards that don't latch only fire their effect.
	var/latches = TRUE
	/// One of TRACTOR_EFFECT_*, for hazards and threats.
	var/effect = TRACTOR_EFFECT_NONE
	/// What it puts in the landing bay, in words, for the haul report.
	var/payload = "nothing"
	/// The /singleton/tractor_payload that puts it there. Null for things that never come aboard.
	var/payload_type
	/// Scanner tier needed to tell exactly what it is. Below that it shows as `vague_name`.
	var/identify_tier = 0
	var/vague_name
	/// Tints the sprite once it's identified, such as a vein showing its mineral's colour.
	var/tint
	/// The claw anchors on it instead of hauling it in: the drop stops there and on_anchor() runs. For things too big to haul.
	var/anchors = FALSE
	/**
	 * Theme type = weight: source themes this contact also turns up in, on top of their own
	 * contact lists. Lets other modules add contacts to the rig without editing its themes.
	 */
	var/list/appears_in


/singleton/tractor_contact/scrap
	name = "scrap plating"
	icon_state = "scrap"
	width = 25
	height = 11
	min_depth = 1
	max_depth = 14
	min_speed = 1.5
	max_speed = 3.5
	payload = "a few sheets of steel"
	payload_type = /singleton/tractor_payload/items/scrap

/singleton/tractor_contact/crate
	name = "lost crate"
	icon_state = "crate"
	width = 20
	height = 18
	mass = 2
	min_depth = 4
	max_depth = 22
	payload = "a crate of maintenance loot"
	payload_type = /singleton/tractor_payload/items/crate

/singleton/tractor_contact/ore
	name = "ore rock"
	vague_name = "mineral rock"
	identify_tier = 2
	icon_state = "ore"
	width = 26
	height = 19
	mass = 2
	min_depth = 4
	max_depth = 24
	payload = "a small cluster of mineral rock (sparse ores)"
	payload_type = /singleton/tractor_payload/ore_cluster/sparse

/singleton/tractor_contact/ore_rich
	name = "rich vein"
	vague_name = "mineral rock"
	identify_tier = 2
	icon_state = "ore_rich"
	width = 30
	height = 23
	mass = 3
	min_depth = 18
	max_depth = 30
	min_speed = 0.7
	max_speed = 1.5
	payload = "a large cluster of mineral rock (rich ores)"
	payload_type = /singleton/tractor_payload/ore_cluster/rich

/singleton/tractor_contact/ore_poor
	name = "dusty rock"
	vague_name = "mineral rock"
	identify_tier = 2
	icon_state = "ore_poor"
	width = 19
	height = 15
	min_depth = 2
	max_depth = 20
	payload = "a few tiles of plain rock"
	payload_type = /singleton/tractor_payload/ore_cluster/plain

/**
 * A rock that's mostly one mineral. A basic scanner only sees mineral rock; with the scanner
 * upgraded (two scanning modules in the projector) it names the mineral and shows its colour, so
 * the operator can go after what the ship needs.
 */
/singleton/tractor_contact/vein
	abstract_type = /singleton/tractor_contact/vein
	icon_state = "ore"
	vague_name = "mineral rock"
	identify_tier = 2
	width = 26
	height = 19
	mass = 2
	min_depth = 6
	max_depth = 26

/singleton/tractor_contact/vein/iron
	name = "hematite vein"
	tint = "#c98a74"
	payload = "rock rich in hematite (iron)"
	payload_type = /singleton/tractor_payload/ore_cluster/vein/iron

/singleton/tractor_contact/vein/carbon
	name = "graphite vein"
	tint = "#8a8a8a"
	payload = "rock rich in graphite (carbon)"
	payload_type = /singleton/tractor_payload/ore_cluster/vein/carbon

/singleton/tractor_contact/vein/silver
	name = "silver vein"
	tint = "#e3e8f0"
	min_depth = 12
	payload = "rock rich in silver"
	payload_type = /singleton/tractor_payload/ore_cluster/vein/silver

/singleton/tractor_contact/vein/gold
	name = "gold vein"
	tint = "#f5cf5a"
	min_depth = 14
	payload = "rock rich in gold"
	payload_type = /singleton/tractor_payload/ore_cluster/vein/gold

/singleton/tractor_contact/vein/platinum
	name = "platinum vein"
	tint = "#cfe0e6"
	min_depth = 16
	payload = "rock rich in platinum"
	payload_type = /singleton/tractor_payload/ore_cluster/vein/platinum

/singleton/tractor_contact/vein/uranium
	name = "pitchblende vein"
	tint = "#8fdc68"
	min_depth = 16
	payload = "rock rich in pitchblende (uranium)"
	payload_type = /singleton/tractor_payload/ore_cluster/vein/uranium

/singleton/tractor_contact/vein/phoron
	name = "phoron vein"
	icon_state = "ore_rich"
	tint = "#d47cff"
	width = 30
	height = 23
	mass = 3
	min_depth = 18
	max_depth = 30
	min_speed = 0.7
	max_speed = 1.5
	payload = "rock rich in phoron"
	payload_type = /singleton/tractor_payload/ore_cluster/vein/phoron

/singleton/tractor_contact/vein/diamond
	name = "diamond seam"
	icon_state = "ore_rich"
	tint = "#9cf4ff"
	width = 30
	height = 23
	mass = 3
	min_depth = 22
	max_depth = 30
	min_speed = 0.6
	max_speed = 1.2
	payload = "rock with diamonds in it"
	payload_type = /singleton/tractor_payload/ore_cluster/vein/diamond

/singleton/tractor_contact/cargo_pod
	name = "lost cargo pod"
	icon_state = "tech_crate"
	tint = "#9fc3ff"
	width = 20
	height = 16
	mass = 3
	min_depth = 18
	max_depth = 30
	min_speed = 0.6
	max_speed = 1.4
	payload = "a sealed supply crate from the cargo catalogue"
	payload_type = /singleton/tractor_payload/supply_crate

/singleton/tractor_contact/salvage_charged
	name = "charged salvage"
	icon_state = "salvage_charged"
	width = 23
	height = 18
	mass = 2
	min_depth = 6
	max_depth = 26
	payload = "salvaged electronics and a power cell"
	payload_type = /singleton/tractor_payload/items/charged_salvage

/singleton/tractor_contact/tech_crate
	name = "intact tech crate"
	icon_state = "tech_crate"
	width = 20
	height = 16
	mass = 2
	min_depth = 14
	max_depth = 30
	min_speed = 0.8
	max_speed = 1.8
	payload = "a crate of tech supplies and a machine board"
	payload_type = /singleton/tractor_payload/items/tech_crate

/singleton/tractor_contact/hull_plate
	name = "hull section"
	icon_state = "hull_plate"
	width = 26
	height = 11
	mass = 2
	min_depth = 2
	max_depth = 20
	payload = "reinforced plating and girders"
	payload_type = /singleton/tractor_payload/items/hull_section

/singleton/tractor_contact/machine_frame
	name = "machine frame"
	icon_state = "machine_frame"
	width = 19
	height = 22
	mass = 2
	min_depth = 6
	max_depth = 26
	payload = "a machine frame with random parts"
	payload_type = /singleton/tractor_payload/items/machine_frame

/singleton/tractor_contact/loot_crate
	name = "sealed locker"
	icon_state = "loot_crate"
	width = 20
	height = 16
	mass = 2
	min_depth = 16
	max_depth = 30
	min_speed = 0.7
	max_speed = 1.6
	payload = "a locker of salvage-grade loot"
	payload_type = /singleton/tractor_payload/items/locker

/singleton/tractor_contact/carp_remains
	name = "carp remains"
	icon_state = "carp_remains"
	width = 22
	height = 9
	min_depth = 2
	max_depth = 20
	payload = "carp meat and teeth"
	payload_type = /singleton/tractor_payload/items/carp_remains

/singleton/tractor_contact/anomaly
	name = "anomalous object"
	icon_state = "anomaly"
	width = 23
	height = 25
	mass = 1
	min_depth = 20
	max_depth = 30
	min_speed = 2.5
	max_speed = 4
	payload = "a rare anomalous find"
	payload_type = /singleton/tractor_payload/items/anomaly

/singleton/tractor_contact/planet_rock
	name = "planetary rock"
	icon_state = "planet_rock"
	width = 24
	height = 18
	mass = 2
	min_depth = 4
	max_depth = 26
	payload = "rock and minerals from the planet below"
	payload_type = /singleton/tractor_payload/ore_cluster/planetary


// Hazards: they hurt the haul or the claw, and some come aboard.

/singleton/tractor_contact/carp
	name = "space carp"
	icon_state = "carp"
	width = 27
	height = 15
	kind = TRACTOR_CONTACT_HAZARD
	faces_left = TRUE
	mass = 1
	min_depth = 2
	max_depth = 26
	min_speed = 2
	max_speed = 4
	payload = "a live, angry space carp"
	payload_type = /singleton/tractor_payload/mobs/carp

/singleton/tractor_contact/rock
	name = "fast debris"
	icon_state = "rock"
	width = 24
	height = 13
	kind = TRACTOR_CONTACT_HAZARD
	latches = FALSE
	effect = TRACTOR_EFFECT_SHAKE
	min_speed = 3.5
	max_speed = 5.5

/singleton/tractor_contact/ion_knot
	name = "ion knot"
	icon_state = "ion_knot"
	width = 20
	height = 20
	kind = TRACTOR_CONTACT_HAZARD
	latches = FALSE
	effect = TRACTOR_EFFECT_DRAIN
	min_depth = 4
	max_depth = 28

/singleton/tractor_contact/grav_eddy
	name = "gravity eddy"
	icon_state = "grav_eddy"
	width = 21
	height = 24
	kind = TRACTOR_CONTACT_HAZARD
	latches = FALSE
	effect = TRACTOR_EFFECT_SNAP
	min_depth = 8
	max_depth = 30
	min_speed = 0.5
	max_speed = 1.5

/singleton/tractor_contact/hivebot
	name = "dormant hivebot"
	icon_state = "hivebot"
	width = 14
	height = 21
	kind = TRACTOR_CONTACT_HAZARD
	mass = 2
	min_depth = 6
	max_depth = 28
	payload = "a hivebot that wakes up in the bay"
	payload_type = /singleton/tractor_payload/mobs/hivebot

/singleton/tractor_contact/rogue_drone
	name = "rogue drone"
	icon_state = "rogue_drone"
	width = 23
	height = 18
	kind = TRACTOR_CONTACT_HAZARD
	min_depth = 4
	max_depth = 24
	min_speed = 2.5
	max_speed = 4.5
	payload = "a hostile rogue drone"
	payload_type = /singleton/tractor_payload/mobs/rogue_drone

// Planet lifeforms die so for now this is just spiders, to be followed up
/singleton/tractor_contact/fauna
	name = "drifting lifeform"
	icon_state = "fauna"
	width = 20
	height = 18
	kind = TRACTOR_CONTACT_HAZARD
	mass = 2
	min_depth = 6
	max_depth = 26
	payload = "a creature from the world below. Better hope it's a cow"
	payload_type = /singleton/tractor_payload/mobs/lifeform


// Ship threats: big, slow and easy to avoid. Touching one ends the cast and may hit ship

/singleton/tractor_contact/meteor_big
	name = "large meteor"
	icon_state = "meteor_big"
	width = 27
	height = 24
	kind = TRACTOR_CONTACT_THREAT
	scale = 1.8
	latches = FALSE
	effect = TRACTOR_EFFECT_THREAT
	min_depth = 10
	max_depth = 28
	min_speed = 0.6
	max_speed = 1.2
	payload = "a meteor strike on the hull near the rig. You are about to learn why people in glass cabins shouldn't pick rocks."

/singleton/tractor_contact/ion_core
	name = "charged ion core"
	icon_state = "ion_core"
	width = 26
	height = 26
	kind = TRACTOR_CONTACT_THREAT
	scale = 1.6
	latches = FALSE
	effect = TRACTOR_EFFECT_THREAT
	min_depth = 12
	max_depth = 28
	min_speed = 0.5
	max_speed = 1
	payload = "an ion pulse through the ship"

/singleton/tractor_contact/carp_leader
	name = "carp school leader"
	icon_state = "carp_leader"
	width = 31
	height = 21
	kind = TRACTOR_CONTACT_THREAT
	faces_left = TRUE
	scale = 1.7
	latches = FALSE
	effect = TRACTOR_EFFECT_THREAT
	min_depth = 10
	max_depth = 26
	min_speed = 0.8
	max_speed = 1.4
	payload = "a carp swarm at the hull"


/// Hit box width in pixels, after scaling.
/singleton/tractor_contact/proc/hit_width()
	return width * scale


/// Hit box height in pixels, after scaling.
/singleton/tractor_contact/proc/hit_height()
	return height * scale


/// Whether this contact can turn up in `field` right now. Checked each time one is picked.
/singleton/tractor_contact/proc/can_appear(datum/tractor_field/field)
	return TRUE


/// Called when the claw anchors on an `anchors` contact. It's already gone from the field.
/singleton/tractor_contact/proc/on_anchor(datum/tractor_rig_session/session, datum/tractor_field_contact/contact)
	return


/// Themes associate overmap objects to contacts. We could just add this to overmap objects themselves but this is easier to pull out and only 1 machine in game uses this
/singleton/tractor_theme
	abstract_type = /singleton/tractor_theme
	/// Shown in the field mix panel.
	var/name = "open space"
	/// Overmap object types this theme describes. Checked with istype, most specific theme wins.
	var/list/source_types = list()
	/// How much this source contributes before distance falloff.
	var/weight = 1
	/// Contact type = weight.
	var/list/contacts = list()
	/// Total mass that can be hauled out of one source before it's used up. 0 never runs out.
	var/yield = 0
	/// When a source runs out: the overmap object type it becomes (an asteroid field turns to dust), or null for nothing.
	var/exhausted_type
	/// Whether running out removes or replaces the overmap object. Sectors and planets stay, just picked clean.
	var/exhausts_away = FALSE
	/// What the operator is told when a source runs out.
	var/exhausted_message = "picked clean"
	/// `contacts` plus every contact that says it appears_in this theme, worked out on first use.
	var/list/merged_contacts


/// Contact type = weight for this theme, including contacts other modules add with appears_in.
/singleton/tractor_theme/proc/contact_weights()
	if (merged_contacts)
		return merged_contacts
	merged_contacts = contacts.Copy()
	for (var/singleton/tractor_contact/info as anything in GET_SINGLETON_SUBTYPE_LIST(/singleton/tractor_contact))
		var/weight = length(info.appears_in) ? info.appears_in[type] : 0
		if (weight)
			merged_contacts[info.type] = (merged_contacts[info.type] || 0) + weight
	return merged_contacts


/singleton/tractor_theme/open_space
	name = "open space"
	weight = 0.6
	contacts = list(
		/singleton/tractor_contact/scrap = 12,
		/singleton/tractor_contact/crate = 2,
		/singleton/tractor_contact/cargo_pod = 1,
		/singleton/tractor_contact/rock = 2
	)

/singleton/tractor_theme/asteroid_field
	name = "asteroid field"
	source_types = list(/obj/overmap/event/meteor)
	weight = 3
	yield = 30
	exhausted_type = /obj/overmap/event/dust
	exhausts_away = TRUE
	exhausted_message = "broken down to a dust cloud"
	contacts = list(
		/singleton/tractor_contact/ore = 8,
		/singleton/tractor_contact/ore_rich = 3,
		/singleton/tractor_contact/vein/iron = 4,
		/singleton/tractor_contact/vein/carbon = 4,
		/singleton/tractor_contact/vein/silver = 2,
		/singleton/tractor_contact/vein/gold = 1,
		/singleton/tractor_contact/vein/platinum = 1,
		/singleton/tractor_contact/vein/uranium = 2,
		/singleton/tractor_contact/vein/phoron = 2,
		/singleton/tractor_contact/vein/diamond = 1,
		/singleton/tractor_contact/rock = 5,
		/singleton/tractor_contact/meteor_big = 2
	)

/singleton/tractor_theme/dust_cloud
	name = "dust cloud"
	source_types = list(/obj/overmap/event/dust)
	weight = 2
	yield = 12
	exhausts_away = TRUE
	exhausted_message = "swept clean: nothing left but empty space"
	contacts = list(
		/singleton/tractor_contact/ore_poor = 6,
		/singleton/tractor_contact/ore = 1,
		/singleton/tractor_contact/vein/carbon = 1,
		/singleton/tractor_contact/rock = 2
	)

/singleton/tractor_theme/charged_storm
	name = "charged storm"
	source_types = list(/obj/overmap/event/electric, /obj/overmap/event/ion)
	weight = 2.5
	contacts = list(
		/singleton/tractor_contact/salvage_charged = 5,
		/singleton/tractor_contact/tech_crate = 2,
		/singleton/tractor_contact/ion_knot = 3,
		/singleton/tractor_contact/ion_core = 1
	)

/singleton/tractor_theme/carp_shoal
	name = "carp shoal"
	source_types = list(/obj/overmap/event/carp)
	weight = 2.5
	yield = 12
	exhausts_away = TRUE
	exhausted_message = "fished out: the rest of the shoal has scattered"
	contacts = list(
		/singleton/tractor_contact/carp = 6,
		/singleton/tractor_contact/carp_remains = 3,
		/singleton/tractor_contact/carp_leader = 1
	)

/singleton/tractor_theme/dark_matter
	name = "dark matter influx"
	source_types = list(/obj/overmap/event/gravity)
	weight = 2
	contacts = list(
		/singleton/tractor_contact/anomaly = 2,
		/singleton/tractor_contact/grav_eddy = 4,
		/singleton/tractor_contact/scrap = 2
	)

/singleton/tractor_theme/wreckage
	name = "wreckage"
	source_types = list(/obj/overmap/visitable/sector)
	weight = 2
	yield = 30
	contacts = list(
		/singleton/tractor_contact/hull_plate = 5,
		/singleton/tractor_contact/machine_frame = 3,
		/singleton/tractor_contact/loot_crate = 2,
		/singleton/tractor_contact/cargo_pod = 1,
		/singleton/tractor_contact/hivebot = 2,
		/singleton/tractor_contact/rogue_drone = 1
	)

/singleton/tractor_theme/planet_orbit
	name = "planetary orbit"
	source_types = list(/obj/overmap/visitable/sector/exoplanet)
	weight = 2.5
	contacts = list(
		/singleton/tractor_contact/planet_rock = 6,
		/singleton/tractor_contact/fauna = 2,
		/singleton/tractor_contact/rock = 1
	)


/// Returns the most specific theme for an overmap object, or null if nothing matches.
/// Idea is to use it when we expand themes further (ie wreck vs specific race wreck. Not much use atm)
/proc/get_tractor_theme(obj/overmap/source)
	var/singleton/tractor_theme/best
	var/best_depth = -1
	for (var/singleton/tractor_theme/theme as anything in GET_SINGLETON_SUBTYPE_LIST(/singleton/tractor_theme))
		for (var/source_type in theme.source_types)
			if (!istype(source, source_type))
				continue
			// Deeper (more specific) types beat their parents: exoplanet over generic sector.
			var/depth = length(splittext("[source_type]", "/"))
			if (depth > best_depth)
				best = theme
				best_depth = depth
	return best
