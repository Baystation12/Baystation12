var/list/teleport_blacklist = list(/obj/item/weapon/disk/nuclear, /obj/item/weapon/storage/backpack/holding) //Items that cannot be teleported, or be in the contents of someone who is teleporting.

/decl/teleport/proc/teleport(var/atom/target, var/atom/destination, var/precision = 0)
	if(!can_teleport(target,destination))
		target.visible_message("<span class='warning'>\The [target] bounces off the teleporter!</span>")
		return

	teleport_target(target, destination, precision)

/decl/teleport/proc/teleport_target(var/atom/movable/target, var/atom/destination, var/precision)
	var/list/possible_turfs = circlerangeturfs(destination, precision)
	destination = safepick(possible_turfs)

	target.forceMove(destination)
	if(isliving(target))
		var/mob/living/L = target
		if(L.buckled)
			var/atom/movable/buckled = L.buckled
			buckled.forceMove(destination)


/decl/teleport/proc/can_teleport(var/atom/movable/target, var/atom/destination)
	if(!destination || !target || !target.loc || destination.z > max_default_z_level())
		return 0

	if(istype(target, /obj/mecha))
		if(destination.z in GLOB.using_map.admin_levels)
			var/obj/mecha/mech = target
			to_chat(mech.occupant, "<span class='danger'>\The [target] would not survive the jump to a location so far away!</span>")
			return 0

	if(is_type_in_list(target, teleport_blacklist))
		return 0

	for(var/type in teleport_blacklist)
		if(!isemptylist(target.search_contents_for(type)))
			return 0
	return 1

/decl/teleport/sparks
	var/datum/effect/effect/system/spark_spread/spark = new

/decl/teleport/sparks/proc/do_spark(var/atom/target)
	if(!target.simulated)
		return
	var/turf/T = get_turf(target)
	spark.set_up(5,1,target)
	spark.attach(T)
	spark.start()

/decl/teleport/sparks/teleport_target(var/atom/target, var/atom/destination, var/precision)
	do_spark(target)
	..()
	do_spark(target)

/proc/do_teleport(var/atom/movable/target, var/atom/destination, var/precision = 0, var/type = /decl/teleport/sparks)
	var/decl/teleport/tele = decls_repository.get_decl(type)
	tele.teleport(target, destination, precision)
