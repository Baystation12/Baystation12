/datum/event_control/wormholes
	name = "Wormholes"
	typepath = /datum/event/wormholes
	max_occurrences = 3
	weight = 2

/datum/event/wormholes
	announceWhen = 10
	endWhen = 60

	var/list/wormholes = list()
	var/shift_frequency = 3
	var/number_of_wormholes = 1000

/datum/event/wormholes/setup()
	announceWhen = rand(0,20)
	endWhen = rand(40,80)

/datum/event/wormholes/start()
	for(var/i=1, i<=number_of_wormholes, i++)
		var/x = rand(40,world.maxx-40)
		var/y = rand(40,world.maxy-40)
		var/turf/T = locate(x, y, 1)
		wormholes += new /obj/effect/portal/wormhole(T, null, null, -1)

/datum/event/wormholes/announce()
	command_alert("Space-time anomalies detected on the station. There is no additional data.", "Anomaly Alert")
	for(var/mob/M in player_list)
		if(!istype(M,/mob/new_player))
			M << sound('sound/AI/spanomalies.ogg')

/datum/event/wormholes/tick()
	if(activeFor % shift_frequency == 0)
		for(var/obj/effect/portal/wormhole/O in wormholes)
			var/x = rand(20,world.maxx-20)
			var/y = rand(20,world.maxy-20)
			var/turf/T = locate(x, y, 1)
			if(T)	O.loc = T

/datum/event/wormholes/end()
	portals.Remove(wormholes)
	for(var/obj/effect/portal/wormhole/O in wormholes)
		O.loc = null
	wormholes.Cut()

/obj/effect/portal/wormhole
	name = "wormhole"
	desc = "It looks highly unstable; It could close at any moment."
	icon = 'icons/obj/objects.dmi'
	icon_state = "anom"
	failchance = 0

/obj/effect/portal/wormhole/teleport(atom/movable/M as mob|obj)
	if(istype(M, /obj/effect)) //sparks don't teleport
		return
	if(M.anchored&&istype(M, /obj/mecha))
		return

	if(istype(M, /atom/movable))
		var/turf/target
		if(portals.len)
			var/obj/effect/portal/P = pick(portals)
			if(P && isturf(P.loc))
				target = P.loc
		if(!target)	return
		do_teleport(M, target, 1, 1, 0, 0) ///You will appear adjacent to the beacon