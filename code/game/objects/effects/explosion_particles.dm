/obj/expl_particles
	name = "explosive particles"
	icon = 'icons/effects/effects.dmi'
	icon_state = "explosion_particle"
	opacity = 1
	anchored = TRUE
	mouse_opacity = 0

/obj/expl_particles/New()
	..()
	QDEL_IN(src, 1 SECOND)

/datum/effect/expl_particles
	number = 10
	var/total_particles = 0

/datum/effect/expl_particles/set_up(n = 10, loca)
	number = n
	if(isturf(loca)) location = loca
	else location = get_turf(loca)

/datum/effect/expl_particles/start()
	var/i = 0
	for(i=0, i<src.number, i++)
		spawn(0)
			var/obj/expl_particles/expl = new /obj/expl_particles(src.location)
			var/direct = pick(GLOB.alldirs)
			for(i=0, i<pick(1;25,2;50,3,4;200), i++)
				sleep(1)
				step(expl,direct)

/obj/explosion
	name = "explosive particles"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "explosion"
	opacity = 1
	anchored = TRUE
	mouse_opacity = 0
	pixel_x = -32
	pixel_y = -32

/obj/explosion/New()
	..()
	QDEL_IN(src, 1 SECOND)


/datum/effect/explosion/set_up(loca)
	if(isturf(loca)) location = loca
	else location = get_turf(loca)

/datum/effect/explosion/start()
	new/obj/explosion( location )
	var/datum/effect/expl_particles/P = new
	P.set_up(10,location)
	P.start()
	addtimer(new Callback(src, PROC_REF(make_smoke)), 5)

/datum/effect/explosion/proc/make_smoke()
	var/datum/effect/smoke_spread/S = new
	S.set_up(5,0,location,null)
	S.start()
