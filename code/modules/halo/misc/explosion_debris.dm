#define EXPLOSION_DEBRIS_CHANCE 35

/obj/structure/destructible/explosion_debris
	name = "explosion debris"
	desc = "Cover created by an explosion. Doesn't block your movement much, but can be useful."
	flags = ON_BORDER
	maxHealth = 250 //This might seem a bit high but remember that the cover will be taking damage anyway from the explosion.
	health = 250
	cover_rating = 45
	explosion_damage_mult = 5
	deconstruct_tools = list()
	loot_types = list()
	scrap_types = list()
	bump_climb = 1
	mob_climb_time = 1.5 SECONDS

//Debris Creation Code//
/turf/simulated/floor
	var/explosion_debris_file = null
	var/explosion_debris_state = "generic"

/turf/simulated/floor/proc/create_cover(var/dir_create)
	if(!explosion_debris_file)
		return
	if(!(dir_create in GLOB.cardinal))
		//If we're on a diagonal, pick one
		dir_create = pick(list(turn(dir_create,-45),turn(dir_create,45)))
	var/obj/new_cover = new /obj/structure/destructible/explosion_debris (src)
	new_cover.icon = explosion_debris_file
	new_cover.icon_state = explosion_debris_state
	new_cover.dir = dir_create

/turf/simulated/floor/proc/create_cover_precheck(var/severity,var/turf/epi)
	if(epi != src)
		var/mult = 4 - severity
		if(!prob(EXPLOSION_DEBRIS_CHANCE * mult))
			return
		create_cover(get_dir(epi,src))

/turf/simulated/floor/ex_act(var/severity,var/turf/epi)
	. = ..()
	create_cover_precheck(severity,epi)

//Relevant turf overrides//
/turf/simulated/floor/asteroid
	explosion_debris_file = 'code/modules/halo/icons/explosion_debris.dmi'

/turf/simulated/floor/exoplanet
	explosion_debris_file = 'code/modules/halo/icons/explosion_debris.dmi'

/turf/simulated/floor/pavement
	explosion_debris_file = 'code/modules/halo/icons/explosion_debris.dmi'

/turf/simulated/floor/road
	explosion_debris_file = 'code/modules/halo/icons/explosion_debris.dmi'

#undef EXPLOSION_DEBRIS_CHANCE