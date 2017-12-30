/*Auras are simple: They are simple overriders for attackbys, bullet_act, damage procs, etc. They also tick after their respective mob.
They should be used for undeterminate mob effects, like for instance a toggle-able forcefield, or indestructability as long as you don't move.
They should also be used for when you want to effect the ENTIRE mob, like having an armor buff or showering candy everytime you walk.
*/

/obj/aura
	var/mob/living/user

/obj/aura/New(var/mob/living/target)
	user = target
	user.add_aura(src)

/obj/aura/Destroy()
	user.remove_aura(src)
	user = null
	return ..()

/obj/aura/proc/life_tick()
	return

/obj/aura/proc/attack_type(var/type, var/newargs)
	switch(type)
		if("Life")
			return life_tick()
		if("Item")
			return attackby(arglist(newargs))
		if("Bullet")
			return bullet_act(arglist(newargs))
		if("Thrown")
			return hitby(arglist(newargs))

/obj/aura/attackby(var/obj/item/I, var/mob/user)
	return 0

/obj/aura/bullet_act(var/obj/item/projectile/P, var/def_zone)
	return 0

/obj/aura/hitby(var/atom/movable/M, var/speed)
	return 0

/obj/aura/debug
	var/returning = 0

/obj/aura/debug/attackby(var/obj/item/I, var/mob/user)
	to_world("Attackby for \ref[src]: [I], [user]")
	return returning

/obj/aura/debug/bullet_act(var/obj/item/projectile/P, var/def_zone)
	to_world("Bullet Act for \ref[src]: [P], [def_zone]")
	return returning

/obj/aura/debug/life_tick()
	to_world("Life tick")
	return returning

/obj/aura/debug/hitby(var/atom/movable/M, var/speed)
	to_world("Hit By for \ref[src]: [M], [speed]")
	return returning