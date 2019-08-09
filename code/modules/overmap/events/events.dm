/obj/effect/overmap_event/meteor
	name = "asteroid field"
	events = list(/datum/event/meteor_wave/overmap)
	count = 15
	radius = 4
	continuous = FALSE
	icon_states = list("meteor1", "meteor2", "meteor3", "meteor4")
	difficulty = EVENT_LEVEL_MAJOR
	weaknesses = BSA_MINING | BSA_EXPLOSIVE

/obj/effect/overmap_event/meteor/enter(var/obj/effect/overmap/ship/victim)
	..()
	if(victims[victim])
		var/datum/event/meteor_wave/overmap/E = locate() in victims[victim]
		E.victim = victim

/obj/effect/overmap_event/electric
	name = "electrical storm"
	events = list(/datum/event/electrical_storm)
	count = 11
	radius = 3
	opacity = 0
	icon_states = list("electrical1", "electrical2", "electrical3", "electrical4")
	difficulty = EVENT_LEVEL_MAJOR
	weaknesses = BSA_EMP

/obj/effect/overmap_event/dust
	name = "dust cloud"
	events = list(/datum/event/dust)
	count = 16
	radius = 4
	icon_states = list("dust1", "dust2", "dust3", "dust4")
	weaknesses = BSA_MINING | BSA_EXPLOSIVE | BSA_FIRE

/obj/effect/overmap_event/ion
	name = "ion cloud"
	events = list(/datum/event/ionstorm, /datum/event/computer_damage)
	count = 8
	radius = 3
	opacity = 0
	icon_states = list("ion1", "ion2", "ion3", "ion4")
	difficulty = EVENT_LEVEL_MAJOR
	weaknesses = BSA_EMP

/obj/effect/overmap_event/carp
	name = "carp shoal"
	events = list(/datum/event/carp_migration)
	count = 8
	radius = 3
	opacity = 0
	difficulty = EVENT_LEVEL_MODERATE
	continuous = FALSE
	icon_states = list("carp1", "carp2")
	weaknesses = BSA_EXPLOSIVE | BSA_FIRE

/obj/effect/overmap_event/carp/major
	name = "carp school"
	count = 5
	radius = 4
	difficulty = EVENT_LEVEL_MAJOR
	icon_states = list("carp3", "carp4")
