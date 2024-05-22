///Maximum distance (on the overmap) a teleporter can target with a less than 100% chance of getting an Interlude.
GLOBAL_VAR_INIT(maximum_safe_teleport_distance, 15)
///Minimum distance (on the overmap) a teleporter can send people to without risking a stop in the Interlude.
GLOBAL_VAR_INIT(minimum_safe_teleport_distance, 5)

/singleton/teleport
	var/static/list/teleport_blacklist = list(/obj/item/disk/nuclear, /obj/item/storage/backpack/holding, /obj/sparks) //Items that cannot be teleported, or be in the contents of someone who is teleporting.

/singleton/teleport/proc/teleport(atom/target, atom/destination, precision = 0)
	if(!can_teleport(target,destination))
		target.visible_message(SPAN_WARNING("\The [target] bounces off the teleporter!"))
		return

	teleport_target(target, destination, precision)

/singleton/teleport/proc/teleport_target(atom/movable/target, atom/destination, precision)
	var/list/possible_turfs = circlerangeturfs(destination, precision)
	destination = DEFAULTPICK(possible_turfs, null)
	if (!destination)
		return

	target.forceMove(destination)
	if(isliving(target))
		var/mob/living/L = target
		if(L.buckled)
			var/atom/movable/buckled = L.buckled
			buckled.forceMove(destination)


/singleton/teleport/proc/can_teleport(atom/movable/target, atom/destination)
	if(!destination || !target || !target.loc || destination.z > max_default_z_level())
		return 0

	if(is_type_in_list(target, teleport_blacklist))
		return 0

	for(var/type in teleport_blacklist)
		if(length(target.search_contents_for(type)))
			return 0
	return 1

/singleton/teleport/sparks
	var/datum/effect/spark_spread/spark = new

/singleton/teleport/sparks/proc/do_spark(atom/target)
	if(!target.simulated)
		return
	var/turf/T = get_turf(target)
	spark.set_up(5,1,target)
	spark.attach(T)
	spark.start()

/singleton/teleport/sparks/teleport_target(atom/target, atom/destination, precision)
	do_spark(target)
	..()
	do_spark(target)

/proc/do_teleport(atom/movable/target, atom/destination, precision = 0, type = /singleton/teleport/sparks)
	var/singleton/teleport/tele = GET_SINGLETON(type)
	tele.teleport(target, destination, precision)


/// Teleport an object randomly within a set of connected zlevels
/proc/do_unstable_teleport_safe(atom/movable/target, list/zlevels = GLOB.using_map.station_levels)
	var/turf/T = pick_area_turf_in_connected_z_levels(
		list(GLOBAL_PROC_REF(is_not_space_area)),
		list(GLOBAL_PROC_REF(not_turf_contains_dense_objects), GLOBAL_PROC_REF(IsTurfAtmosSafe)),
		zlevels[1])
	do_teleport(target, T)
