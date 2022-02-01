
GLOBAL_LIST_EMPTY(exterior_bats)

/datum/event/bat_swarm
	startWhen = 2
	announceWhen = 20
	endWhen = 1800

	///Whether or not bats have entered the ship, affects various announcements
	var/invade = FALSE

	///Whether bats have entered a frenzied state (more aggressive and higher spawn cap)
	var/frenzy = FALSE

	///The speed the ship must maintain to escape the bats
	var/escape_speed = 5.0

	///When exceeding the escape speed, the ship does not immediately escape but makes progress depending on how much it exceeds the threshold
	var/escape_progress = 0

	///Set when the ship has escaped. The event is functionally over at that point but there may still be announcements queued.
	var/escaped = FALSE

	///How many bats have spawned inside? Tracked to keep it from being excessive
	var/interior_bat_count = 0

	///Multiplier on how many bats will spawn inside. Affected by severity.
	var/interior_factor = 1

	///Target number of bats
	var/max_bats = 12

	///Number of additional bats when frenzy occurs. Also the number of extra bats on high severity.
	var/frenzy_additional_bats = 6

	///Tracks if the bats have been slowed by dust (so it can't happen multiple times)
	var/dust = FALSE

	///Flavor text on what exactly happened when announcing hazards
	var/hazard = "hazard"

	///Flavor text on what exactly happened when announcing frenzy
	var/frenzy_reason = "unknown"


	///Cause a bat spawn in the given number of event ticks
	var/trigger_spawn = 0

	///End the event after the given number of event ticks (to allow final announcements to clear)
	var/trigger_end = 0

	///After this many ticks, announce the escape speed
	var/trigger_ann_speed = 0

	///After this many ticks, announce bats have entered the ship
	var/trigger_ann_invasion = 0

	///After this many ticks, announce the ship has escaped
	var/trigger_ann_escape = 0

	///After this many ticks, announce the bats have frenzied
	var/trigger_ann_frenzy = 0

	///After this many ticks, announce the bats have been affected by dust
	var/trigger_ann_dust = 0

	///After this many ticks, announce the bats have been affected by a hazard
	var/trigger_ann_hazard = 0


	///A tuning parameter on how quickly things progress
	var/time_factor = 0.25

	///Block other announcements until the start of the event has been announced
	var/can_announce = FALSE

	///The ship this is happening to
	var/obj/effect/overmap/visitable/ship/victim

	///Where bats spawn relative to the ship. Usually random directions, but only aft if making escape progress
	var/spawn_dir = null

	///A list of vents where bats might spawn. Collected once per event rather than every attempt to spawn.
	var/list/vents = null


/datum/event/bat_swarm/setup()
	log_debug("Bat swarm setting up:")

	if(!victim)
		victim = map_sectors["1"]

	if (!istype(victim))
		log_debug("  Bat event doesn't have a ship. Killing.")
		kill()
		return

	affecting_z = victim.map_z

	if(severity > EVENT_LEVEL_MODERATE)
		endWhen = round(rand(1800, 3600) * time_factor)
		interior_factor = 2
		max_bats += frenzy_additional_bats
	else
		endWhen = round(rand(900, 1800) * time_factor)

	escape_speed = 10.1 + rand(5.0,15.1) * severity / EVENT_LEVEL_MAJOR
	log_debug("  Bat escape speed is [escape_speed].")
	trigger_spawn = 2
	trigger_ann_speed = round(120 * time_factor)




/datum/event/bat_swarm/announce()
	can_announce = TRUE

	var/announcement = ""
	if(severity > EVENT_LEVEL_MODERATE)
		announcement = "A massive migration of unknown biological entities has been detected in the vicinity of \the [location_name()]. Exercise external operations with caution."
	else
		announcement = "A large migration of unknown biological entities has been detected in the vicinity of \the [location_name()]. Caution is advised."

	command_announcement.Announce(announcement, "[location_name()] Sensor Array", zlevels = affecting_z)


/datum/event/bat_swarm/end()
	if(can_announce && !escaped)
		var/announcement = "The bat swarm has dispersed of its own accord. Resume normal activities."
		if (invade > 0)
			announcement = "The bat swarm seems to have lost interest in \the [location_name()]. Stay vigilant for remaining onboard entities."
		command_announcement.Announce(announcement, "[location_name()] Sensor Array", zlevels = affecting_z)


/datum/event/bat_swarm/tick()

	if(can_announce)
		if(trigger_ann_speed > 0)
			trigger_ann_speed -= 1
			if(trigger_ann_speed == 0)
				announce_speed()

		if(trigger_ann_invasion > 0)
			trigger_ann_invasion -= 1
			if(trigger_ann_invasion == 0)
				announce_invasion()

		if(trigger_ann_frenzy > 0)
			trigger_ann_frenzy -= 1
			if(trigger_ann_frenzy == 0)
				announce_frenzy(frenzy_reason)

		if(trigger_ann_hazard > 0)
			trigger_ann_hazard -= 1
			if(trigger_ann_hazard == 0)
				announce_hazard(hazard)
				trigger_end = 2

		if(trigger_ann_escape > 0)
			trigger_ann_escape -= 1
			if(trigger_ann_escape == 0)
				announce_clear()
				trigger_end = 2

		if(trigger_end > 0)
			trigger_end -= 1
			if(trigger_end == 0)
				kill()

	if(escaped)
		return

	if(trigger_spawn > 0)
		trigger_spawn -= 1
		if(trigger_spawn == 0)

			if(frenzy || GLOB.exterior_bats.len > 6 || prob(3))
				if(interior_bat_count < max_bats)
					spawn_interior_bats(rand(1,3) * interior_factor)
				if(interior_bat_count && !invade)
					trigger_ann_invasion = round(10 * time_factor)
					invade = TRUE
					log_debug("Bats are beginning to spawn inside.")
			else
				spawn_exterior_bats(dir=spawn_dir)

	else
		trigger_spawn = round(rand(60, 120) * time_factor)

	var/speed = victim.get_speed() * 1000.0 //using helm console display units
	if(speed > 1.0)
		spawn_dir = GLOB.reverse_dir[victim.fore_dir] //we're running away so all exterior bats are behind
	else
		spawn_dir = null
	escape_progress += (speed - escape_speed) * time_factor
	if(escape_progress < 0)
		escape_progress = 0.0

	if(escape_progress > 10.0 * time_factor)
		escaped = TRUE
		log_debug("Escaped from bats.")
		trigger_ann_escape = round(10 * time_factor)
		cleanup()

	if(overmap_event_handler.is_event_active(victim, /datum/event/electrical_storm, EVENT_ANY_SEVERITY))
		escaped = TRUE
		log_debug("Hazard stopped bats.")
		cleanup()
		trigger_ann_hazard = round(10 * time_factor)
		hazard = "crackling electricity"

	if(overmap_event_handler.is_event_active(victim, /datum/event/meteor_wave, EVENT_ANY_SEVERITY) || overmap_event_handler.is_event_active(victim, /datum/event/meteor_wave/overmap, EVENT_ANY_SEVERITY))
		escaped = TRUE
		log_debug("Hazard stopped bats.")
		cleanup()
		trigger_ann_hazard = round(10 * time_factor)
		hazard = "careening meteors"

	if(overmap_event_handler.is_event_active(victim, /datum/event/carp_migration, EVENT_ANY_SEVERITY) || overmap_event_handler.is_event_active(victim, /datum/event/carp_migration/overmap, EVENT_ANY_SEVERITY))
		escaped = TRUE
		log_debug("Hazard stopped bats.")
		cleanup()
		trigger_ann_hazard = round(10 * time_factor)
		hazard = "space carp, their natural predator"

	if(overmap_event_handler.is_event_active(victim, /datum/event/dust, EVENT_ANY_SEVERITY))
		if(!dust)
			dust = TRUE
			escape_speed *= rand(50.1, 75.0) / 100.0
			announce_dust("interplanetary dust")

	if(overmap_event_handler.is_event_active(victim, /datum/event/ionstorm, EVENT_ANY_SEVERITY))
		if(!dust)
			dust = TRUE
			escape_speed *= rand(50.1, 75.0) / 100.0
			announce_dust("ionization")

	if(overmap_event_handler.is_event_active(victim, /datum/event/gravity, EVENT_ANY_SEVERITY))
		if(!frenzy)
			frenzy = TRUE
			log_debug("Bats are frenzied.")
			max_bats += frenzy_additional_bats
			frenzy_reason = "dark matter"
			trigger_ann_frenzy = round(10 * time_factor)



/datum/event/bat_swarm/proc/cleanup()
	log_debug("Cleaning up exterior bats.")
	for(var/M in GLOB.exterior_bats)
		GLOB.death_event.unregister(M,src,/datum/event/bat_swarm/proc/bat_died)
		GLOB.destroyed_event.unregister(M,src,/datum/event/bat_swarm/proc/bat_died)
		qdel(M)
	GLOB.exterior_bats.Cut()


/datum/event/bat_swarm/proc/announce_speed()
	var/suggestion = pick(
		"activating shielding against xenobiologicals",
		"flying into a space hazard where they can't follow",
		"to prepare to fight")
	if(prob(15))
		suggestion = pick(
			"to live another life on the holodeck",
			"requesting reassignment to an exoplanet",
			"to ignore it and hope it goes away")
	var/announcement = "Biological entities have been identified as space bats with an average speed of [escape_speed] Gm/h. Traveling faster than that rate should move \the [location_name()] clear of the swarm. An alternative course of action is [suggestion]."
	command_announcement.Announce(announcement, "[location_name()] Sensor Array", zlevels = affecting_z)


/datum/event/bat_swarm/proc/announce_invasion()
	var/announcement = "Biological entities have breached exterior access points. Avoid contact."
	command_announcement.Announce(announcement, "[location_name()] Sensor Array", zlevels = affecting_z)


/datum/event/bat_swarm/proc/announce_clear()
	var/announcement = "\The [location_name()] has moved clear of the space bat swarm. Resume normal activities."
	if (invade)
		announcement = "\The [location_name()] has moved clear of the space bat swarm. Stay vigilant for remaining onboard entities."
	command_announcement.Announce(announcement, "[location_name()] Sensor Array", zlevels = affecting_z)

/datum/event/bat_swarm/proc/announce_frenzy(situation)
	var/announcement = "Frenzied squeaking echoes through \the [location_name()] as space bats bask in the esoteric energy of [situation]!"
	for (var/mob/L in GLOB.player_list)
		if (get_z(L) in affecting_z)
			to_chat(L, SPAN_WARNING(announcement))


/datum/event/bat_swarm/proc/announce_hazard(situation)
	var/announcement = "Reacting to [situation], the space bats have broken off pursuit of \the [location_name()]. Resume normal activities."
	if (invade)
		announcement = "Reacting to [situation], the space bats have broken off pursuit of \the [location_name()]. Stay vigilant for remaining onboard entities."
	command_announcement.Announce(announcement, "[location_name()] Sensor Array", zlevels = affecting_z)


/datum/event/bat_swarm/proc/announce_dust(situation)
	var/announcement = "The [situation] is impeding the movement of space bats, reducing their speed to [escape_speed] Gm/h."
	command_announcement.Announce(announcement, "[location_name()] Sensor Array", zlevels = affecting_z)


/datum/event/bat_swarm/proc/spawn_exterior_bats(dir, speed, how_many)
	if(!living_observers_present(affecting_z))
		return
	var/Z = pick(affecting_z)

	if(!dir)
		dir = pick(GLOB.cardinal)

	if(!speed)
		speed = rand(1,3)

	if(!how_many)
		how_many = rand(1,3)


	for (var/I = 1 to how_many)
		var/turf/T = get_random_edge_turf(dir,TRANSITIONEDGE + 4, Z)
		if(istype(T,/turf/space))
			var/mob/living/simple_animal/hostile/M = new /mob/living/simple_animal/hostile/scarybat/wandering(T)
			GLOB.death_event.register(M,src,/datum/event/bat_swarm/proc/bat_died)
			GLOB.destroyed_event.register(M,src,/datum/event/bat_swarm/proc/bat_died)
			LAZYADD(GLOB.exterior_bats, M)
			M.throw_at(get_random_edge_turf(GLOB.reverse_dir[dir],TRANSITIONEDGE + 4, Z), 5, speed)


/datum/event/bat_swarm/proc/spawn_interior_bats(how_many)
	if(!living_observers_present(affecting_z))
		return

	if(!vents)
		vents = list()
		for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in world)
			if(!temp_vent.welded && temp_vent.network && (temp_vent.loc.z in affecting_z))
				if(temp_vent.network.normal_members.len > 20)
					vents += temp_vent

	var/list/shieldz = list()
	for(var/obj/machinery/power/shield_generator/G in SSmachines.machinery)
		if(G.running && (G.z in affecting_z))
			if(G.check_flag(MODEFLAG_NONHUMANS | MODEFLAG_MODULATE))
				var/damage_potential = (1 + 2*frenzy) * severity
				var/damage = G.take_damage(damage_potential, SHIELD_DAMTYPE_PHYSICAL)
				if(damage <= SHIELD_BREACHED_MINOR)
					if(G.check_flag(MODEFLAG_MULTIZ))
						return
					shieldz += G.z

	for (var/I = 1 to how_many)
		var/obj/vent = pick(vents)
		if(vent)
			var/turf/T = get_turf(vent)
			if(T && !(T.z in shieldz))
				if(frenzy)
					new /mob/living/simple_animal/hostile/scarybat/wandering/frenzied(T)
				else
					new /mob/living/simple_animal/hostile/scarybat/wandering(T)
				interior_bat_count += 1


/datum/event/bat_swarm/proc/bat_died(mob/M)
	GLOB.death_event.unregister(M,src,/datum/event/bat_swarm/proc/bat_died)
	GLOB.destroyed_event.unregister(M,src,/datum/event/bat_swarm/proc/bat_died)

	LAZYREMOVE(GLOB.exterior_bats, M)
