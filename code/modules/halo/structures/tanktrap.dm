/obj/structure/tanktrap_dead
	name = "tanktrap"
	icon = 'code/modules/halo/icons/machinery/structures.dmi'
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

/obj/structure/tanktrap
	name = "tanktrap"
	desc = "This space is blocked off by a barricade."
	icon = 'code/modules/halo/icons/machinery/structures.dmi'
	icon_state = "tanktrap"
	anchored = 1.0
	density = 1
	var/health = 150
	var/maxhealth = 150
	var/material/material
	var/list/maneuvring_mobs = list()

/obj/structure/tanktrap/New(var/newloc, var/material_name)
	..(newloc)
	if(!material_name)
		material_name = "steel"
	material = get_material_by_name("[material_name]")
	if(!material)
		qdel(src)
		return
	name = "[material.display_name] barricade"
	desc = "This space is blocked off by a tank trap made of [material.display_name]."
	color = material.icon_colour
	maxhealth = material.integrity
	health = maxhealth

/obj/structure/tanktrap/get_material()
	return material

/obj/structure/tanktrap/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/stack))
		var/obj/item/stack/D = W
		if(D.get_material_name() != material.name)
			return //hitting things with the wrong type of stack usually doesn't produce messages, and probably doesn't need to.
		if (health < maxhealth)
			if (D.get_amount() < 1)
				to_chat(user, "<span class='warning'>You need one sheet of [material.display_name] to repair \the [src].</span>")
				return
			visible_message("<span class='notice'>[user] begins to repair \the [src].</span>")
			if(do_after(user,20,src) && health < maxhealth)
				if (D.use(1))
					health = maxhealth
					visible_message("<span class='notice'>[user] repairs \the [src].</span>")
				return
		return
	else
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		switch(W.damtype)
			if("fire")
				src.health -= W.force * 1
			if("brute")
				src.health -= W.force * 0.75
			else
		if (src.health <= 0)
			visible_message("<span class='danger'>The tank trap is wrecked!</span>")
			new /obj/structure/tanktrap_dead(src.loc)
			qdel(src)
			return
		..()

/obj/structure/tanktrap/proc/dismantle()
	material.place_dismantled_product(get_turf(src))
	qdel(src)
	return

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

/obj/structure/tanktrap/ex_act(severity)
	switch(severity)
		if(1.0)
			visible_message("<span class='danger'>\The [src] is blown apart!</span>")
			qdel(src)
			return
		if(2.0)
			src.health -= 25
			if (src.health <= 0)
				visible_message("<span class='danger'>\The [src] is blown apart!</span>")
				dismantle()
			return

/obj/structure/tanktrap/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)//So bullets will fly over and stuff.
	if(air_group || (height==0))
		return 1
	if(istype(mover) && (mover.checkpass(PASSTABLE) || mover.elevation != elevation))
		return 1
	else
		return 0
