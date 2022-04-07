/* A series of particle systems. Some are based on F0lak's particle system
*/

//Spawner object
//Maybe we could pool them in and out
/atom/movable/particle_emitter
	name = ""
	anchored = TRUE
	mouse_opacity = 0

/atom/movable/particle_emitter/Initialize(mapload, time)
	. = ..()
	QDEL_IN(src, time)

particles/fire
	width = 500
	height = 500
	count = 3000
	spawning = 3
	lifespan = 10
	fade = 10
	velocity = list(0, 0)
	position = generator("circle", 0, 8, NORMAL_RAND)
	drift = generator("vector", list(0, -0.2), list(0, 0.2))
	gravity = list(0, 0.65)

	color = "white"

particles/smoke
	width = 500
	height = 1000
	count = 3000
	spawning = 5
	lifespan = 40
	fade = 40
	velocity = generator("box", list(-1, 2), list(1, 2), NORMAL_RAND)
	gravity = list(0, 1)

	friction = 0.1
	drift = generator("vector", list(-0.2, -0.3), list(0.2, 0.3))
	color = "white"

particles/fire_sparks
	width = 500
	height = 500
	count = 3000
	spawning = 1
	lifespan = 40
	fade = 20
	position = generator("circle", -10, 10, NORMAL_RAND)
	gravity = list(0, 1)

	friction = 0.25
	drift = generator("sphere", 0, 2)
	gradient = list(0, "yellow", 1, "red")
	color = "yellow"

particles/drill_sparks
	width = 124
	height = 124
	count = 1600
	spawning = 4
	lifespan = 1.5 SECONDS
	fade = 0.25 SECONDS
	position = generator("circle", -3, 3, NORMAL_RAND)
	gravity = list(0, -1)
	velocity = generator("box", list(-3, 2, 0), list(3, 12, 5), NORMAL_RAND)
	friction = 0.25
	gradient = list(0, COLOR_WHITE, 1, COLOR_ORANGE)
	color_change = 0.125
	color = 0
	transform = list(1,0,0,0, 0,1,0,0, 0,0,1,1/5, 0,0,0,1)

particles/flare_sparks
	width = 500
	height = 500
	count = 2000
	spawning = 12
	lifespan = 0.75 SECONDS
	fade = 0.95 SECONDS
	position = generator("circle", -2, 2, NORMAL_RAND)
	velocity = generator("circle", -6, 6, NORMAL_RAND)
	friction = 0.15
	gradient = list(0, COLOR_WHITE, 0.4, COLOR_RED)
	color_change = 0.125

particles/dust
	width = 124
	height = 124
	count = 12
	spawning = 12
	lifespan = 0.6 SECONDS
	fade = 0.15 SECONDS
	position = generator("circle", -6, 6, NORMAL_RAND)
	velocity = generator("circle", -3, 3, NORMAL_RAND)
	friction = 0.1
	color = COLOR_OFF_WHITE

/atom/movable/particle_emitter/sparks
	particles = new/particles/drill_sparks
	plane = EFFECTS_ABOVE_LIGHTING_PLANE

/atom/movable/particle_emitter/sparks/set_dir(dir)
	..()
	var/list/min
	var/list/max
	if(dir == NORTH)
		min = list(-3, 2, -1)
		max = list(3, 12, 0)
	else if(dir == SOUTH)
		min = list(-3, 2, 0)
		max = list(3, 12, 1)
	else if(dir == EAST)
		min = list(1, 3, 0)
		max = list(6, 12, 0)
	else
		min = list(-1, 3, 0)
		max = list(-6, 12, 0)

	particles.velocity = generator("box", min, max, NORMAL_RAND)


/atom/movable/particle_emitter/dust
	particles = new/particles/dust

/atom/movable/particle_emitter/smoke
	layer = FIRE_LAYER
	particles = new/particles/smoke
	filters = filter(type="blur", size=1.5)

/atom/movable/particle_emitter/sparks_flare
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	particles = new/particles/flare_sparks
	filters = filter(type="bloom", size=3, offset = 0.5, alpha = 220)
