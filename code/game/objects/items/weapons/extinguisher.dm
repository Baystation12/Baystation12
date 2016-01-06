/obj/item/weapon/extinguisher
	name = "fire extinguisher"
	desc = "A traditional red fire extinguisher."
	icon = 'icons/obj/items.dmi'
	icon_state = "fire_extinguisher0"
	item_state = "fire_extinguisher"
	hitsound = 'sound/weapons/smash.ogg'
	flags = CONDUCT
	throwforce = 10
	w_class = 3.0
	throw_speed = 2
	throw_range = 10
	force = 10.0
	matter = list(DEFAULT_WALL_MATERIAL = 90)
	attack_verb = list("slammed", "whacked", "bashed", "thunked", "battered", "bludgeoned", "thrashed")

	var/spray_particles = 6
	var/spray_amount = 8	//units of liquid per particle
	var/max_water = 240
	var/last_use = 1.0
	var/safety = 1
	var/sprite_name = "fire_extinguisher"

/obj/item/weapon/extinguisher/mini
	name = "fire extinguisher"
	desc = "A light and compact fibreglass-framed model fire extinguisher."
	icon_state = "miniFE0"
	item_state = "miniFE"
	hitsound = null	//it is much lighter, after all.
	throwforce = 2
	w_class = 2.0
	force = 3.0
	max_water = 120
	spray_particles = 5
	sprite_name = "miniFE"

/obj/item/weapon/extinguisher/New()
	create_reagents(max_water)
	reagents.add_reagent("water", max_water)
	..()

/obj/item/weapon/extinguisher/examine(mob/user)
	if(..(user, 0))
		user << text("\icon[] [] contains [] units of water left!", src, src.name, src.reagents.total_volume)
	return

/obj/item/weapon/extinguisher/attack_self(mob/user as mob)
	safety = !safety
	src.icon_state = "[sprite_name][!safety]"
	src.desc = "The safety is [safety ? "on" : "off"]."
	user << "The safety is [safety ? "on" : "off"]."
	return

/obj/item/weapon/extinguisher/proc/propel_object(var/obj/O, mob/user, movementdirection)
	if(O.anchored) return

	var/obj/structure/bed/chair/C
	if(istype(O, /obj/structure/bed/chair))
		C = O

	var/list/move_speed = list(1, 1, 1, 2, 2, 3)
	for(var/i in 1 to 6)
		if(C) C.propelled = (6-i)
		O.Move(get_step(user,movementdirection), movementdirection)
		sleep(move_speed[i])
	
	//additional movement
	for(var/i in 1 to 3)
		O.Move(get_step(user,movementdirection), movementdirection)
		sleep(3)

/obj/item/weapon/extinguisher/afterattack(var/atom/target, var/mob/user, var/flag)
	//TODO; Add support for reagents in water.

	if( istype(target, /obj/structure/reagent_dispensers/watertank) && flag)
		var/obj/o = target
		var/amount = o.reagents.trans_to_obj(src, 50)
		user << "<span class='notice'>You fill [src] with [amount] units of the contents of [target].</span>"
		playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
		return

	if (!safety)
		if (src.reagents.total_volume < 1)
			usr << "<span class='notice'>\The [src] is empty.</span>"
			return

		if (world.time < src.last_use + 20)
			return

		src.last_use = world.time

		playsound(src.loc, 'sound/effects/extinguish.ogg', 75, 1, -3)

		var/direction = get_dir(src,target)

		if(user.buckled && isobj(user.buckled))
			spawn(0)
				propel_object(user.buckled, user, turn(direction,180))

		var/turf/T = get_turf(target)
		var/turf/T1 = get_step(T,turn(direction, 90))
		var/turf/T2 = get_step(T,turn(direction, -90))

		var/list/the_targets = list(T,T1,T2)

		for(var/a = 1 to spray_particles)
			spawn(0)
				if(!src || !reagents.total_volume) return
			
				var/obj/effect/effect/water/W = PoolOrNew(/obj/effect/effect/water, get_turf(src))
				var/turf/my_target
				if(a <= the_targets.len)
					my_target = the_targets[a]
				else
					my_target = pick(the_targets)
				W.create_reagents(spray_amount)
				reagents.trans_to_obj(W, spray_amount)
				W.set_color()
				W.set_up(my_target)

		if((istype(usr.loc, /turf/space)) || (usr.lastarea.has_gravity == 0))
			user.inertia_dir = get_dir(target, user)
			step(user, user.inertia_dir)
	else
		return ..()
	return
