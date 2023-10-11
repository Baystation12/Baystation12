/obj/fusion_particle_catcher
	icon = 'icons/effects/effects.dmi'
	density = TRUE
	anchored = TRUE
	invisibility = INVISIBILITY_ABSTRACT
	light_color = COLOR_BLUE
	var/obj/fusion_em_field/parent
	var/mysize = 0

/obj/fusion_particle_catcher/Destroy()
	. =..()
	parent.particle_catchers -= src
	parent = null

/obj/fusion_particle_catcher/proc/SetSize(newsize)
	name = "collector [newsize]"
	mysize = newsize
	UpdateSize()

/obj/fusion_particle_catcher/proc/AddReactants(name, quantity = 1)
	if(parent && parent.size >= mysize)
		parent.AddReactants(name, quantity)
		return 1
	return 0

/obj/fusion_particle_catcher/proc/UpdateSize()
	if(parent.size >= mysize)
		set_density(1)
		SetName("collector [mysize] ON")
	else
		set_density(0)
		SetName("collector [mysize] OFF")

/obj/fusion_particle_catcher/bullet_act(obj/item/projectile/Proj)
	parent.AddEnergy(Proj.damage)
	update_icon()
	return 0

/obj/fusion_particle_catcher/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return ismob(mover)
