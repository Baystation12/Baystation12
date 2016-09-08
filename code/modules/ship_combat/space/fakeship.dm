/datum/fake_ship
	var/health = 100 // Once this reaches 0, its destroyed
	var/maxhealth = 100 // Cannot be repaired beyond this point.
	var/team = 0 // Certain actions like firing will not target this team.

	var/hostile = 0 // Whether it has guns.
	var/obj/effect/overmap/linked // Its linked overmap object.
	var/totally_destroyed = 1 // Whether it deletes itself once it runs out of health.

/datum/fake_ship/New(var/obj/effect/overmap/creator)
	..()
	linked = creator
	team = creator.team

/datum/fake_ship/proc/damaged(var/damage)
	health = max(0, health-damage)
	if(health == 0 && totally_destroyed)
		qdel(src)

/datum/fake_ship/Destroy()
	qdel(linked)
	linked = null
	return ..()
