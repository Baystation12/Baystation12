/obj/effect/fusion_particle_catcher
	icon = 'icons/effects/effects.dmi'
	density = 1
	anchored = 1
	invisibility = 101
	var/obj/effect/fusion_em_field/parent
	var/mysize = 0

	light_color = COLOR_BLUE

/obj/effect/fusion_particle_catcher/Destroy()
	. =..()
	parent.particle_catchers -= src
	parent = null

/obj/effect/fusion_particle_catcher/proc/SetSize(var/newsize)
	name = "collector [newsize]"
	mysize = newsize
	UpdateSize()

/obj/effect/fusion_particle_catcher/proc/AddParticles(var/name, var/quantity = 1)
	if(parent && parent.size >= mysize)
		parent.AddParticles(name, quantity)
		return 1
	return 0

/obj/effect/fusion_particle_catcher/proc/UpdateSize()
	if(parent.size >= mysize)
		density = 1
		name = "collector [mysize] ON"
	else
		density = 0
		name = "collector [mysize] OFF"

/obj/effect/fusion_particle_catcher/bullet_act(var/obj/item/projectile/Proj)
	parent.AddEnergy(Proj.damage)
	update_icon()
	return 0

/obj/effect/fusion_particle_catcher/CanPass(var/atom/movable/mover, var/turf/target, var/height=0, var/air_group=0)
	return ismob(mover)
