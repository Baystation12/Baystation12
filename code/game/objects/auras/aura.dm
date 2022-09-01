/*Auras are simple: They are simple overriders for attackbys, bullet_act, damage procs, etc. They also tick after their respective mob.
They should be used for undeterminate mob effects, like for instance a toggle-able forcefield, or indestructability as long as you don't move.
They should also be used for when you want to effect the ENTIRE mob, like having an armor buff or showering candy everytime you walk.
*/

/obj/aura
	var/mob/living/user

/obj/aura/New(mob/living/target)
	..()
	if(target)
		added_to(target)
		user.add_aura(src)

/obj/aura/Destroy()
	if(user)
		user.remove_aura(src)
		removed()
	return ..()

/obj/aura/proc/added_to(mob/living/target)
	user = target

/obj/aura/proc/removed()
	user = null

/obj/aura/proc/life_tick()
	return 0

/obj/aura/attackby(obj/item/I, mob/user)
	return 0

/obj/aura/bullet_act(obj/item/projectile/P, def_zone)
	return 0

/obj/aura/hitby()
	return 0

/obj/aura/debug
	var/returning = 0

/obj/aura/debug/attackby(obj/item/I, mob/user)
	log_debug("Attackby for \ref[src]: [I], [user]")
	return returning

/obj/aura/debug/bullet_act(obj/item/projectile/P, def_zone)
	log_debug("Bullet Act for \ref[src]: [P], [def_zone]")
	return returning

/obj/aura/debug/life_tick()
	log_debug("Life tick")
	return returning

/obj/aura/debug/hitby(atom/movable/M, datum/thrownthing/TT)
	log_debug("Hit By for \ref[src]: [M], [TT.speed]")
	return returning
