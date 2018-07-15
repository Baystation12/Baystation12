
/obj/structure/tanktrap
	name = "tanktrap"
	icon = 'maps/desert_outpost/gamemode/desert_outpost.dmi'
	icon_state = "tanktrap"
	density = 1
	anchored = 1
	throwpass = 1
	var/health = 50
	var/list/maneuvring_mobs = list()

/obj/structure/tanktrap/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover))
		if(mover.checkpass(PASSTABLE))
			return 1
		if(mover.throwing)
			return 1
	return !density

/obj/structure/tanktrap/Bumped(atom/movable/AM)
	if(isliving(AM) && AM:a_intent == I_HELP)
		if(istype(AM, /mob/living/simple_animal/))
			return
		if(istype(AM, /mob/living/simple_animal/hostile))
			var/mob/living/simple_animal/hostile/H = AM
			if(!H.assault_target && !H.target_mob)
				return
		var/turf/T = get_step(AM, AM.dir)
		if(T.CanPass(AM, T))
			if(ismob(AM))
				var/mob/moving = AM
				moving.show_message("<span class='notice'>You start maneuvring past [src]...</span>")
			spawn(0)
				if(do_after(AM, 30))
					src.visible_message("<span class='info'>[AM] slips past [src].</span>")
					AM.loc = T
		else if(ismob(AM))
			var/mob/moving = AM
			moving.show_message("<span class='warning'>Something is blocking you from maneuvering past [src].</span>")
	..()

/obj/structure/tanktrap/attack_generic(var/mob/user, var/damage, var/attacktext)
	user.do_attack_animation(src)
	visible_message("<span class='danger'>[user] [attacktext] the [src]!</span>")
	//user.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name]</font>")
	src.health -= damage
	playsound(src.loc, 'sound/weapons/bite.ogg', 50, 0, 0)
	if (src.health <= 0)
		new /obj/structure/tanktrap_dead(src.loc)
		if(prob(50))
			new /obj/item/stack/rods(src.loc)
		if(prob(50))
			new /obj/item/stack/rods(src.loc)
		if(prob(50))
			new /obj/item/stack/material/steel(src.loc)
		if(prob(50))
			new /obj/item/stack/material/steel(src.loc)
		qdel(src)

/obj/structure/tanktrap_dead/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(do_after(user, 20) && WT.remove_fuel(3, user))
			user.visible_message("<span class='info'>You salvage the tank trap.</span>")
			new /obj/item/stack/material/steel(src.loc)
			new /obj/item/stack/material/steel(src.loc)
			new /obj/item/stack/material/steel(src.loc)
			qdel(src)
		else
			to_chat(user, "<span class='warning'>There is not enough fuel to salvage the tank trap!</span>")
	else
		..()

/obj/structure/tanktrap_dead
	name = "tanktrap"
	icon = 'maps/desert_outpost/gamemode/desert_outpost.dmi'
	icon_state = "tanktrap_dead"
	density = 0
	anchored = 1

/obj/structure/tanktrap_dead/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.remove_fuel(1, user))
			user.visible_message("<span class='info'>You salvage the ruined tank trap.</span>")
			new /obj/item/stack/material/steel(src.loc)
			qdel(src)
		else
			to_chat(user, "<span class='warning'>There is not enough fuel to salvage the tank trap!</span>")
	else
		..()

/obj/structure/doorwreckage
	name = "wrecked airlock"
	desc = "An airlock. Something strong pried it open."
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_as_0"
	density = 1
	opacity = 0
	throwpass = 1
	anchored = 1

/obj/structure/doorwreckage/Bumped(atom/movable/AM)
	if(isliving(AM) && AM:a_intent == I_HELP)
		if(istype(AM, /mob/living/simple_animal/))
			return
		if(istype(AM, /mob/living/simple_animal/hostile))
			var/mob/living/simple_animal/hostile/H = AM
			if(!H.assault_target && !H.target_mob)
				return
		var/turf/T = get_step(AM, AM.dir)
		if(T.CanPass(AM, T))
			if(ismob(AM))
				var/mob/moving = AM
				moving.show_message("<span class='notice'>You start maneuvring past [src]...</span>")
			spawn(0)
				if(do_after(AM, 30))
					src.visible_message("<span class='info'>[AM] slips past [src].</span>")
					AM.loc = T
		else if(ismob(AM))
			var/mob/moving = AM
			moving.show_message("<span class='warning'>Something is blocking you from maneuvering past [src].</span>")
	..()

/obj/structure/doorwreckage/attackby(obj/item/W as obj, mob/user as mob)
	user.visible_message("[user] begins cutting through the wrecked airlock.", "You start to slice through the wrecked airlock.")
	playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(do_after(user, 80) && WT.remove_fuel(5, user))
			playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
			user.visible_message("<span class='info'>You slice through the wrecked airlock!</span>")
			new /obj/item/metalscrap(src.loc)
			new /obj/item/metalscrap(src.loc)
			new /obj/item/metalscrap(src.loc)
			new /obj/item/stack/cable_coil/cut(src.loc)
			new /obj/item/stack/cable_coil/cut(src.loc)
			qdel(src)
		else
			to_chat(user, "<span class='warning'>There is not enough fuel to slice through!</span>")
	else
		..()