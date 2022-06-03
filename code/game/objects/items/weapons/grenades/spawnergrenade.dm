/obj/item/grenade/spawnergrenade
	desc = "It is set to detonate in 5 seconds. It will unleash unleash an unspecified anomaly into the vicinity."
	name = "delivery grenade"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "delivery"
	item_state = "flashbang"
	origin_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 4)

	/// The obj/mob path to be created when the grenade explodes.
	var/spawn_type

	/// The number of spawn_type to be created when the grenade explodes.
	var/spawn_amount = 1

	/// If set, the maximum distance to toss spawned atoms when the grenade explodes.
	var/spawn_throw_range


/obj/item/grenade/spawnergrenade/detonate(mob/living/user)
	var/turf/origin = get_turf(src)
	if (origin)
		playsound(origin, 'sound/effects/phasein.ogg', 100, 1)
		for (var/mob/living/living in viewers(origin))
			if (living.eyecheck() < FLASH_PROTECTION_MODERATE)
				living.flash_eyes()
		var/list/spawned = list()
		var/atom/movable/movable
		var/turf/target
		for (var/i = spawn_amount to 1 step -1)
			movable = new spawn_type (origin)
			spawned += movable
			if (spawn_throw_range)
				target = CircularRandomTurfAround(origin, Frand(1, spawn_throw_range))
				movable.throw_at(target, spawn_throw_range, 3)
		AfterSpawn(user, spawned)
	qdel(src)


/obj/item/grenade/spawnergrenade/proc/AfterSpawn(mob/living/user, list/spawned)
	return




/obj/item/grenade/spawnergrenade/viscerator
	name = "viscerator grenade"
	spawn_type = /mob/living/simple_animal/hostile/viscerator
	spawn_amount = 5
	spawn_throw_range = 3


/obj/item/grenade/spawnergrenade/viscerator/AfterSpawn(mob/living/user, list/spawned)
	if (!istype(user))
		return
	for (var/mob/living/simple_animal/hostile/viscerator/viscerator as anything in spawned)
		viscerator.faction = user.faction




/obj/item/grenade/spawnergrenade/spesscarp
	name = "carp delivery grenade"
	spawn_type = /mob/living/simple_animal/hostile/carp
	spawn_amount = 4
	spawn_throw_range = 3
