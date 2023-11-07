/atom/movable/proc/AddParticles(type, create_new = FALSE)
	if (ispath(type))
		if (create_new)
			particles = new type()
			GLOB.all_particles[src.name] = particles
		else
			var/particles/P = type
			var/index = initial(P.name)
			particles = GLOB.all_particles[index]
	else
		if (GLOB.all_particles[type])
			particles = GLOB.all_particles[type]
	return


/atom/movable/proc/MakeParticleEmitter(type, create_new = FALSE)
	var/obj/particle_emitter/pe
	pe = new /obj/particle_emitter(loc)
	pe.AddParticles(type, create_new)


/atom/movable/proc/RemoveParticles(delete = FALSE)
	if (delete)
		QDEL_NULL(particles)
	particles = null
	if (/obj/particle_emitter in vis_contents)
		vis_contents -= /obj/particle_emitter


/atom/movable/proc/ModParticles(target, min, max, type = "circle", random = 1)
	if (particles)
		particles.ModParticles(target, min, max, type = "circle", random = 1)


/particles
	var/name = "particles"


/particles/proc/ModParticles(target, min, max, type = "circle", random = 1)
	if (!(type in list("vector", "box", "circle", "sphere", "square", "cube")))											// Valid types for generator(), sans color
		return

	if (target in list("width", "height", "count", "spawning", "bound1", "bound2", "gravity", "gradient", "transform"))	// These vars cannot be generators, per reference doc, and changing some breaks things anyways
		return

	if (target in vars)
		vars[target] = MakeGenerator(type, min, max, random)


/particles/proc/SetGradient(...)
	var/counter = 0
	var/list/new_gradient = list()
	for (var/i in args)
		new_gradient += counter
		counter += 1/length(args)
		new_gradient += i
	gradient = new_gradient

/particles/fire
	name = "fire"
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


/particles/smoke
	name = "smoke"
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


/particles/mist
	name = "mist"
	icon = 'icons/effects/particles.dmi'
	icon_state = list("steam_1" = 1, "steam_2" = 1, "steam_3" = 1)
	count = 500
	spawning = 4
	lifespan = 5 SECONDS
	fade = 1 SECOND
	fadein = 1 SECOND
	velocity = generator("box", list(-0.5, -0.25, 0), list(0.5, 0.25, 0), NORMAL_RAND)
	position = generator("box", list(-20, -16), list(20, -2), UNIFORM_RAND)
	friction = 0.2
	grow = 0.0015


/particles/mist/back
	name = "mist_back"
	spawning = 7
	position = generator("box", list(-20, -1), list(20, 20), UNIFORM_RAND)
	lifespan = 6 SECONDS
	fadein = 1.5 SECONDS

/particles/fire_sparks
	name = "fire sparks"
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


/particles/drill_sparks
	name = "drill sparks"
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


/particles/flare_sparks
	name = "flare sparks"
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


/particles/dust
	name = "dust"
	width = 124
	height = 124
	count = 256
	spawning = 256
	lifespan = 0.75 SECONDS
	fade = 0.35 SECONDS
	position = generator("box", list(-16, -16), list(16, 16), NORMAL_RAND)
	velocity = generator("circle", -8, 8, NORMAL_RAND)
	friction = 0.125
	color = COLOR_OFF_WHITE


/particles/debris
	name = "debris"
	width = 124
	height = 124
	count = 16
	spawning = 16
	lifespan = 0.75 SECONDS
	fade = 0.35 SECONDS
	position = generator("box", list(-10, -10), list(10, 10), NORMAL_RAND)
	velocity = generator("circle", -15, 15, NORMAL_RAND)
	friction = 0.225
	gravity = list(0, -1)
	icon = 'icons/effects/particles.dmi'
	icon_state = list("rock1", "rock2", "rock3", "rock4", "rock5")
	rotation = generator("num", 0, 360)


/particles/drill_sparks/debris
	name = "drill debris"
	friction = 0.25
	gradient = null
	color = COLOR_WHITE
	transform = list(1/2,0,0,0, 0,1/2,0,0, 0,0,1/2,1/5, 0,0,0,1)
	icon = 'icons/effects/particles.dmi'
	icon_state = list("rock1", "rock2", "rock3", "rock4", "rock5")


/particles/torus
	name = "torus"
	width = 800
	height = 800
	count = 900
	spawning = 45
	lifespan = 1 SECONDS
	fade = 0.5 SECONDS
	position = generator("circle", 8, 16, NORMAL_RAND)
	velocity = generator("circle", -2, 2, NORMAL_RAND)
	friction = 0.15
	gradient = list(0, COLOR_WHITE, 1, COLOR_BLUE_LIGHT)
	color_change = 0.1
	color = 0
	drift = generator("sphere", -1, 1, NORMAL_RAND)


/particles/torus/fusion
	name = "fusion torus"
	count = 3600
	spawning = 180
	position = generator("circle", 2.5 * 32 - 5, 2.5 * 32 + 5, NORMAL_RAND)
	velocity = generator("circle", -6, 6, NORMAL_RAND)


/particles/torus/bluespace
	name = "bluespace torus"
	count = 1800
	spawning = 90
	position = generator("circle", 16, 24, NORMAL_RAND)
	velocity = generator("circle", -4, 4, NORMAL_RAND)


/particles/heat
	name = "heat"
	width = 500
	height = 500
	count = 250
	spawning = 15
	lifespan = 1.85 SECONDS
	fade = 1.25 SECONDS
	position = generator("box", list(-16, -16), list(16, 0), NORMAL_RAND)
	friction = 0.15
	gradient = list(0, COLOR_WHITE, 0.75, COLOR_ORANGE)
	color_change = 0.1
	color = 0
	gravity = list(0, 1)
	drift = generator("circle", 0.4, NORMAL_RAND)
	velocity = generator("circle", 0, 3, NORMAL_RAND)


/particles/heat/high
	name = "high heat"
	count = 600
	spawning = 35


//Spawner object
//Maybe we could pool them in and out

/obj/particle_emitter
	name = ""
	anchored = TRUE
	mouse_opacity = 0
	appearance_flags = PIXEL_SCALE
	var/particle_type = null


/obj/particle_emitter/Initialize(mapload, time, _color)
	. = ..()
	if (particle_type)
		particles = GLOB.all_particles[particle_type]

	if (time > 0)
		QDEL_IN(src, time)
	color = _color


/obj/particle_emitter/sparks
	particle_type = "drill sparks"
	plane = EFFECTS_ABOVE_LIGHTING_PLANE


/obj/particle_emitter/sparks/set_dir(dir)
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

	particles.velocity = generator("box", min, max)


/obj/particle_emitter/sparks/debris
	particle_type = "drill debris"
	plane = DEFAULT_PLANE


/obj/particle_emitter/burst/Initialize(mapload, time)
	. = ..()
	//Burst emitters turn off after 1 tick
	QDEL_IN(src, time)


/obj/particle_emitter/burst/rocks
	particle_type = "debris"


/obj/particle_emitter/burst/dust
	particle_type = "dust"


/obj/particle_emitter/smoke
	layer = FIRE_LAYER
	particle_type = "smoke"


/obj/particle_emitter/smoke/Initialize(mapload, time, _color)
	. = ..()
	filters = filter(type="blur", size=1.5)


/obj/particle_emitter/sparks_flare
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	particle_type = "flare"
	mouse_opacity = 1


/obj/particle_emitter/sparks_flare/Initialize(mapload, time, _color)
	. = ..()
	filters = filter(type="bloom", size=3, offset = 0.5, alpha = 220)


/obj/particle_emitter/heat
	particle_type = "heat"
	render_target = HEAT_EFFECT_TARGET


/obj/particle_emitter/heat/Initialize()
	. = ..()
	filters += filter(type = "blur", size = 1)


/obj/particle_emitter/heat/high
	particle_type = "high heat"


/obj/particle_emitter/mist
	particle_type = "mist"
	layer = FIRE_LAYER

/obj/particle_emitter/mist/back
	particle_type = "mist_back"
	layer = BELOW_OBJ_LAYER


/obj/particle_emitter/mist/back/gas
	render_target = COLD_EFFECT_BACK_TARGET

/obj/particle_emitter/mist/back/gas/Initialize(mapload, time, _color)
	. = ..()
	filters += filter(type="alpha", render_source = COLD_EFFECT_TARGET, flags = MASK_INVERSE)


//for cold gas effect
/obj/particle_emitter/mist/gas
	render_target = COLD_EFFECT_TARGET
	var/obj/particle_emitter/mist/back/b = /obj/particle_emitter/mist/back/gas

/obj/particle_emitter/mist/gas/Initialize(mapload, time, _color)
	. = ..()
	b = new b(null)
	vis_contents += b
