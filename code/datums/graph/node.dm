/datum/node
	var/datum/graph/graph

/datum/node/Destroy()
	graph.Disconnect(src)
	return ..()

/datum/node/physical
	var/atom/holder

/datum/node/physical/New(var/atom/holder)
	..()
	if(!istype(holder))
		CRASH("Invalid holder: [log_info_line(holder)]");
	src.holder = holder

/datum/node/physical/Destroy()
	holder = null
	. = ..()
