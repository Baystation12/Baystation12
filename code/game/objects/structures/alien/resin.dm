/obj/structure/alien
	name = "alien thing"
	desc = "There's something alien about this."
	icon = 'icons/mob/alien.dmi'

/obj/structure/alien/resin
	name = "resin"
	desc = "Looks like some kind of slimy growth."
	icon_state = "resin"

	density = 1
	opacity = 1
	anchored = 1
	var/health = 200

/obj/structure/alien/resin/wall
	name = "resin wall"
	desc = "Purple slime solidified into a wall."
	icon_state = "resinwall"

/obj/structure/alien/resin/membrane
	name = "resin membrane"
	desc = "Purple slime just thin enough to let light pass through."
	icon_state = "resinmembrane"
	opacity = 0
	health = 120

/obj/structure/alien/resin/New()
	..()
	var/turf/T = get_turf(src)
	T.thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT

/obj/structure/alien/resin/Destroy()
	var/turf/T = get_turf(src)
	T.thermal_conductivity = initial(T.thermal_conductivity)
	..()

/obj/structure/alien/resin/proc/healthcheck()
	if(health <=0)
		density = 0
		qdel(src)
	return

/obj/structure/alien/resin/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	healthcheck()
	return

/obj/structure/alien/resin/ex_act(severity)
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

/obj/structure/alien/resin/blob_act()
	health-=50
	healthcheck()
	return

/obj/structure/alien/resin/meteorhit()
	health-=50
	healthcheck()
	return

/obj/structure/alien/resin/hitby(AM as mob|obj)
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

/obj/structure/alien/resin/attack_generic()
	attack_hand(usr) //todo

/obj/structure/alien/resin/attack_hand(var/mob/user)
	if (HULK in user.mutations)
		visible_message("<span class='danger'>\The [user] destroys \the [name]!</span>")
		health = 0
	else
		// Aliens can get straight through these.
		if(istype(user,/mob/living/carbon))
			var/mob/living/carbon/M = user
			if(locate(/obj/item/organ/xenos/hivenode) in M.internal_organs)
				visible_message("<span class='alium'>\The [user] strokes \the [name] and it melts away!")
				health = 0
				healthcheck()
				return
		visible_message("<span class='danger'>\The [user] claws at \the [src]!</span>")
		// Todo check attack datums.
		health -= rand(5,10)
	healthcheck()
	return

/obj/structure/alien/resin/attackby(var/obj/item/weapon/W, var/mob/user)
	health = max(0, health - W.force)
	playsound(loc, 'sound/effects/attackblob.ogg', 100, 1)
	healthcheck()
	..()
	return

/obj/structure/alien/resin/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group) return 0
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return !opacity
	return !density

