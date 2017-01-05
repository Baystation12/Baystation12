/obj/structure/alien
	name = "alien thing"
	desc = "There's something alien about this."
	icon = 'icons/mob/alien.dmi'
	layer = ABOVE_OBJ_LAYER
	var/health = 50

/obj/structure/alien/proc/healthcheck()
	if(health <=0)
		set_density(0)
		qdel(src)
	return

/obj/structure/alien/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	healthcheck()
	return

/obj/structure/alien/ex_act(severity)
	switch(severity)
		if(1.0)
			health-=50
		if(2.0)
			health-=50
		if(3.0)
			if (prob(50))
				health-=50
			else
				health-=25
	healthcheck()
	return

/obj/structure/alien/hitby(AM as mob|obj)
	..()
	visible_message("<span class='danger'>\The [src] was hit by \the [AM].</span>")
	var/tforce = 0
	if(ismob(AM))
		tforce = 10
	else
		tforce = AM:throwforce
	playsound(loc, 'sound/effects/attackblob.ogg', 100, 1)
	health = max(0, health - tforce)
	healthcheck()
	..()
	return

/obj/structure/alien/attack_generic()
	attack_hand(usr)

/obj/structure/alien/attackby(var/obj/item/weapon/W, var/mob/user)
	health = max(0, health - W.force)
	playsound(loc, 'sound/effects/attackblob.ogg', 100, 1)
	healthcheck()
	..()
	return

/obj/structure/alien/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group) return 0
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return !opacity
	return !density
