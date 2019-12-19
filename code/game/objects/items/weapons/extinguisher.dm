/obj/item/weapon/extinguisher
	name = "fire extinguisher"
	desc = "A traditional red fire extinguisher."
	icon = 'icons/obj/items.dmi'
	icon_state = "fire_extinguisher0"
	item_state = "fire_extinguisher"
	hitsound = 'sound/weapons/smash.ogg'
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	throwforce = 10
	w_class = ITEM_SIZE_NORMAL
	throw_speed = 2
	throw_range = 10
	force = 10.0
	matter = list(MATERIAL_STEEL = 90)
	attack_verb = list("slammed", "whacked", "bashed", "thunked", "battered", "bludgeoned", "thrashed")

	var/spray_particles = 3
	var/spray_amount = 120	//units of liquid per spray - 120 -> same as splashing them with a bucket per spray
	var/starting_water = 2000
	var/max_water = 2000
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
	w_class = ITEM_SIZE_SMALL
	force = 3.0
	spray_amount = 80
	starting_water = 1000
	max_water = 1000
	sprite_name = "miniFE"

/obj/item/weapon/extinguisher/Initialize()
	. = ..()
	create_reagents(max_water)
	if(starting_water > 0)
		reagents.add_reagent(/datum/reagent/water, starting_water)

/obj/item/weapon/extinguisher/empty
	starting_water = 0

/obj/item/weapon/extinguisher/examine(mob/user, distance)
	. = ..()
	if(distance <= 0)
		to_chat(user, text("\icon[] [] contains [] units of water left!", src, src.name, src.reagents.total_volume))

/obj/item/weapon/extinguisher/attack_self(mob/user as mob)
	safety = !safety
	src.icon_state = "[sprite_name][!safety]"
	src.desc = "The safety is [safety ? "on" : "off"]."
	to_chat(user, "The safety is [safety ? "on" : "off"].")
	return

/obj/item/weapon/extinguisher/attack(var/mob/living/M, var/mob/user)
	if(user.a_intent == I_HELP)
		if(src.safety || (world.time < src.last_use + 20)) // We still catch help intent to not randomly attack people
			return
		if(src.reagents.total_volume < 1)
			to_chat(user, SPAN_NOTICE("\The [src] is empty."))
			return

		src.last_use = world.time
		reagents.splash(M, min(reagents.total_volume, spray_amount))

		user.visible_message(SPAN_NOTICE("\The [user] sprays \the [M] with \the [src]."))
		playsound(src.loc, 'sound/effects/extinguish.ogg', 75, 1, -3)

		return 1 // No afterattack
	return ..()

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

/obj/item/weapon/extinguisher/resolve_attackby(var/atom/target, var/mob/user, var/flag)
	if (istype(target, /obj/structure/hygiene/sink) && reagents.get_free_space() > 0) // fill first, wash if full
		return FALSE
	return ..()


/obj/item/weapon/extinguisher/afterattack(var/atom/target, var/mob/user, var/flag)
	var/issink = istype(target, /obj/structure/hygiene/sink)

	if (flag && (issink || istype(target, /obj/structure/reagent_dispensers)))
		var/obj/dispenser = target
		var/amount = reagents.get_free_space()
		if (amount <= 0)
			to_chat(user, SPAN_NOTICE("\The [src] is full."))
			return
		if (!issink) // sinks create reagents, they don't "contain" them
			if (dispenser.reagents.total_volume <= 0)
				to_chat(user, SPAN_NOTICE("\The [dispenser] is empty."))
				return
			amount = dispenser.reagents.trans_to_obj(src, max_water)
		else
			reagents.add_reagent(/datum/reagent/water, amount)
		to_chat(user, SPAN_NOTICE("You fill \the [src] with [amount] units from \the [dispenser]."))
		playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
		if (istype(target, /obj/structure/reagent_dispensers/acid))
			to_chat(user, SPAN_WARNING("The acid violently eats away at \the [src]!"))
			if (prob(50))
				reagents.splash(user, 5)
			qdel(src)
		return

	if (!safety)
		if (src.reagents.total_volume < 1)
			to_chat(usr, SPAN_NOTICE("\The [src] is empty."))
			return

		if (world.time < src.last_use + 20)
			return

		src.last_use = world.time

		playsound(src.loc, 'sound/effects/extinguish.ogg', 75, 1, -3)

		var/direction = get_dir(src,target)

		if(user.buckled && isobj(user.buckled))
			addtimer(CALLBACK(src, .proc/propel_object, user.buckled, user, turn(direction,180)), 0)

		addtimer(CALLBACK(src, .proc/do_spray, target), 0)

		if((istype(usr.loc, /turf/space)) || (usr.lastarea.has_gravity == 0))
			user.inertia_dir = get_dir(target, user)
			step(user, user.inertia_dir)
	else
		return ..()
	return

/obj/item/weapon/extinguisher/proc/do_spray(var/atom/Target)
	var/turf/T = get_turf(Target)
	var/per_particle = min(spray_amount, reagents.total_volume)/spray_particles
	for(var/a = 1 to spray_particles)
		if(!src || !reagents.total_volume) return

		var/obj/effect/effect/water/W = new /obj/effect/effect/water(get_turf(src))
		W.create_reagents(per_particle)
		reagents.trans_to_obj(W, per_particle)
		W.set_color()
		W.set_up(T)