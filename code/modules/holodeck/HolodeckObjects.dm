// Holographic Items!

// Holographic tables are in code/modules/tables/presets.dm
// Holographic racks are in code/modules/tables/rack.dm

/turf/simulated/floor/holofloor
	thermal_conductivity = 0

// the new Diona Death Prevention Feature: gives an average amount of lumination
/turf/simulated/floor/holofloor/get_lumcount(var/minlum = 0, var/maxlum = 1)
	return 0.8

/turf/simulated/floor/holofloor/attackby(obj/item/W as obj, mob/user as mob)
	return
	// HOLOFLOOR DOES NOT GIVE A FUCK

/turf/simulated/floor/holofloor/set_flooring()
	return

/turf/simulated/floor/holofloor/carpet
	name = "brown carpet"
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_state = "brown"
	initial_flooring = /decl/flooring/carpet

/turf/simulated/floor/holofloor/concrete
	name = "brown carpet"
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_state = "brown"
	initial_flooring = /decl/flooring/carpet

/turf/simulated/floor/holofloor/concrete
	name = "floor"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "concrete"
	initial_flooring = null

/turf/simulated/floor/holofloor/tiled
	name = "floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "steel"
	initial_flooring = /decl/flooring/tiling

/turf/simulated/floor/holofloor/tiled/dark
	name = "dark floor"
	icon_state = "dark"
	initial_flooring = /decl/flooring/tiling/dark

/turf/simulated/floor/holofloor/tiled/stone
	name = "stone floor"
	icon_state = "stone"
	initial_flooring = /decl/flooring/tiling/stone

/turf/simulated/floor/holofloor/lino
	name = "lino"
	icon = 'icons/turf/flooring/linoleum.dmi'
	icon_state = "lino"
	initial_flooring = /decl/flooring/linoleum

/turf/simulated/floor/holofloor/wood
	name = "wooden floor"
	icon = 'icons/turf/flooring/wood.dmi'
	icon_state = "wood"
	color = WOOD_COLOR_CHOCOLATE
	initial_flooring = /decl/flooring/wood

/turf/simulated/floor/holofloor/grass
	name = "lush grass"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_state = "grass0"
	initial_flooring = /decl/flooring/grass

/turf/simulated/floor/holofloor/snow
	name = "snow"
	base_name = "snow"
	icon = 'icons/turf/floors.dmi'
	base_icon = 'icons/turf/floors.dmi'
	icon_state = "snow"
	base_icon_state = "snow"

/turf/simulated/floor/holofloor/space
	icon = 'icons/turf/space.dmi'
	name = "\proper space"
	icon_state = "0"

/turf/simulated/floor/holofloor/reinforced
	icon = 'icons/turf/flooring/tiles.dmi'
	initial_flooring = /decl/flooring/reinforced
	name = "reinforced holofloor"
	icon_state = "reinforced"

/turf/simulated/floor/holofloor/space/New()
	icon_state = "[((x + y) ^ ~(x * y) + z) % 25]"

/turf/simulated/floor/holofloor/beach
	desc = "Uncomfortably gritty for a hologram."
	base_desc = "Uncomfortably gritty for a hologram."
	icon = 'icons/misc/beach.dmi'
	base_icon = 'icons/misc/beach.dmi'
	initial_flooring = null

/turf/simulated/floor/holofloor/beach/sand
	name = "sand"
	icon_state = "desert0"
	base_icon_state = "desert0"

/turf/simulated/floor/holofloor/beach/coastline
	name = "coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"
	base_icon_state = "sandwater"

/turf/simulated/floor/holofloor/beach/water
	name = "water"
	icon_state = "seashallow"
	base_icon_state = "seashallow"

/turf/simulated/floor/holofloor/desert
	name = "desert sand"
	base_name = "desert sand"
	desc = "Uncomfortably gritty for a hologram."
	base_desc = "Uncomfortably gritty for a hologram."
	icon_state = "asteroid"
	base_icon_state = "asteroid"
	icon = 'icons/turf/flooring/asteroid.dmi'
	base_icon = 'icons/turf/flooring/asteroid.dmi'
	initial_flooring = null

/turf/simulated/floor/holofloor/desert/New()
	..()
	if(prob(10))
		overlays += "asteroid[rand(0,9)]"

/obj/structure/holostool
	name = "stool"
	desc = "Apply butt."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "stool_padded_preview"
	anchored = TRUE

/obj/item/clothing/gloves/boxing/hologlove
	name = "boxing gloves"
	desc = "Because you really needed another excuse to punch your crewmates."
	icon_state = "boxing"
	item_state = "boxing"

/obj/structure/window/holowindow/full
	dir = 5
	icon_state = "window_full"

/obj/structure/window/holowindow/full/Destroy()
	..()

/obj/structure/window/reinforced/holowindow/Destroy()
	..()

/obj/structure/window/reinforced/holowindow/attackby(obj/item/W as obj, mob/user as mob)

	if(!istype(W) || W.item_flags & ITEM_FLAG_NO_BLUDGEON) return

	if(isScrewdriver(W) || isCrowbar(W) || isWrench(W))
		to_chat(user, ("<span class='notice'>It's a holowindow, you can't dismantle it!</span>"))
	else
		if(W.damtype == BRUTE || W.damtype == BURN)
			hit(W.force, user, W)
		else
			playsound(loc, 'sound/effects/Glasshit.ogg', 75, 1)
		..()
	return

/obj/structure/window/reinforced/holowindow/shatter(var/display_message = 1)
	playsound(src, "shatter", 70, 1)
	if(display_message)
		visible_message("[src] fades away as it shatters!")
	qdel(src)
	return

/obj/structure/window/reinforced/holowindow/disappearing/Destroy()
	..()

/obj/machinery/door/window/holowindoor/Destroy()
	..()

/obj/machinery/door/window/holowindoor/attackby(obj/item/I as obj, mob/user as mob)

	if (src.operating == 1)
		return

	if (check_force(I, user))
		return

	src.add_fingerprint(user)
	if (!src.requiresID())
		user = null

	if (src.allowed(user))
		if (src.density)
			open()
		else
			close()

	else if (src.density)
		flick(text("[]deny", src.base_state), src)

	return

/obj/machinery/door/window/holowindoor/shatter(var/display_message = 1)
	src.set_density(0)
	playsound(src, "shatter", 70, 1)
	if(display_message)
		visible_message("[src] fades away as it shatters!")
	qdel(src)

/obj/structure/bed/chair/holochair/Destroy()
	..()

/obj/structure/bed/chair/holochair/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/wrench))
		to_chat(user, ("<span class='notice'>It's a holochair, you can't dismantle it!</span>"))
	return

/obj/item/holo
	damtype = PAIN
	no_attack_log = TRUE

/obj/item/holo/esword
	icon = 'icons/obj/weapons/melee_energy.dmi'
	name = "holosword"
	desc = "May the force be within you. Sorta."
	icon_state = "sword0"
	force = 3.0
	throw_speed = 1
	throw_range = 5
	throwforce = 0
	w_class = ITEM_SIZE_SMALL
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_BLOOD
	base_parry_chance = 50
	var/active = 0
	var/item_color

/obj/item/holo/esword/green
	item_color = "green"

/obj/item/holo/esword/red
	item_color = "red"

/obj/item/holo/esword/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	. = ..()
	if(.)
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, user.loc)
		spark_system.start()
		playsound(user.loc, 'sound/weapons/blade1.ogg', 50, 1)

/obj/item/holo/esword/get_parry_chance(mob/user)
	return active ? ..() : 0

/obj/item/holo/esword/New()
	item_color = pick("red","blue","green","purple")

/obj/item/holo/esword/attack_self(mob/living/user as mob)
	active = !active
	if (active)
		force = 30
		icon_state = "sword[item_color]"
		w_class = ITEM_SIZE_HUGE
		playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
		to_chat(user, "<span class='notice'>[src] is now active.</span>")
	else
		force = 3
		icon_state = "sword0"
		w_class = ITEM_SIZE_SMALL
		playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
		to_chat(user, "<span class='notice'>[src] can now be concealed.</span>")

	update_held_icon()

	add_fingerprint(user)
	return

//BASKETBALL OBJECTS

/obj/item/beach_ball/holoball
	icon = 'icons/obj/basketball.dmi'
	icon_state = "basketball"
	name = "basketball"
	item_state = "basketball"
	desc = "Here's your chance, do your dance at the Space Jam."
	w_class = ITEM_SIZE_LARGE //Stops people from hiding it in their pockets

/obj/structure/holohoop
	name = "basketball hoop"
	desc = "Boom, Shakalaka!"
	icon = 'icons/obj/basketball.dmi'
	icon_state = "hoop"
	anchored = TRUE
	density = TRUE
	throwpass = 1

/obj/structure/holohoop/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (istype(mover,/obj/item) && mover.throwing)
		var/obj/item/I = mover
		if(istype(I, /obj/item/projectile))
			return
		if(prob(50))
			I.dropInto(loc)
			visible_message("<span class='notice'>Swish! \the [I] lands in \the [src].</span>", range = 3)
		else
			visible_message("<span class='warning'>\The [I] bounces off of \the [src]'s rim!</span>", range = 3)
		return 0
	else
		return ..(mover, target, height, air_group)

//VOLLEYBALL OBJECTS

/obj/item/beach_ball/holovolleyball
	icon = 'icons/obj/basketball.dmi'
	icon_state = "volleyball"
	name = "volleyball"
	item_state = "volleyball"
	desc = "You can be my wingman anytime."
	w_class = ITEM_SIZE_LARGE //Stops people from hiding it in their pockets

/obj/structure/holonet
	name = "net"
	desc = "Bullshit, you can be mine!"
	icon = 'icons/obj/basketball.dmi'
	icon_state = "volleynet_mid"
	density = TRUE
	anchored = TRUE
	layer = TABLE_LAYER
	throwpass = 1
	dir = 4

/obj/structure/holonet/end
	icon_state = "volleynet_end"

/obj/structure/holonet/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (istype(mover,/obj/item) && mover.throwing)
		var/obj/item/I = mover
		if(istype(I, /obj/item/projectile))
			return
		if(prob(10))
			I.dropInto(loc)
			visible_message("<span class='notice'>Swish! \the [I] gets caught in \the [src].</span>", range = 3)
			return 0
		else
			return 1
	else
		return ..(mover, target, height, air_group)

/obj/machinery/readybutton
	name = "Ready Declaration Device"
	desc = "This device is used to declare ready. If all devices in an area are ready, the event will begin!"
	icon = 'icons/obj/monitors.dmi'
	icon_state = "auth_off"
	var/ready = 0
	var/area/currentarea = null
	var/eventstarted = 0

	anchored = TRUE
	idle_power_usage = 2
	active_power_usage = 6
	power_channel = ENVIRON

/obj/machinery/readybutton/attack_ai(mob/user as mob)
	to_chat(user, "The AI is not to interact with these devices!")
	return

/obj/machinery/readybutton/New()
	..()


/obj/machinery/readybutton/attackby(obj/item/W as obj, mob/user as mob)
	to_chat(user, "The device is a solid button, there's nothing you can do with it!")

/obj/machinery/readybutton/physical_attack_hand(mob/user)
	currentarea = get_area(src)
	if(!currentarea)
		qdel(src)
		return TRUE

	if(eventstarted)
		to_chat(user, "The event has already begun!")
		return TRUE

	ready = !ready

	update_icon()

	var/numbuttons = 0
	var/numready = 0
	for(var/obj/machinery/readybutton/button in currentarea)
		numbuttons++
		if (button.ready)
			numready++

	if(numbuttons == numready)
		begin_event()
	return TRUE

/obj/machinery/readybutton/on_update_icon()
	if(ready)
		icon_state = "auth_on"
	else
		icon_state = "auth_off"

/obj/machinery/readybutton/proc/begin_event()

	eventstarted = 1

	for(var/obj/structure/window/reinforced/holowindow/disappearing/W in currentarea)
		qdel(W)

	for(var/mob/M in currentarea)
		to_chat(M, "FIGHT!")

//Holocarp

/mob/living/simple_animal/hostile/carp/holodeck
	icon = 'icons/mob/hologram.dmi'
	icon_state = "Carp"
	icon_living = "Carp"
	icon_dead = "Carp"
	alpha = 127
	icon_gib = null
	meat_amount = 0
	meat_type = null

/mob/living/simple_animal/hostile/carp/holodeck/carp_randomify()
	return

/mob/living/simple_animal/hostile/carp/holodeck/on_update_icon()
	return

/mob/living/simple_animal/hostile/carp/holodeck/New()
	..()
	set_light(0.5, 0.1, 2) //hologram lighting

/mob/living/simple_animal/hostile/carp/holodeck/proc/set_safety(var/safe)
	var/obj/item/NW = get_natural_weapon()
	if (safe)
		faction = MOB_FACTION_NEUTRAL
		if(NW)
			NW.force = 0
		environment_smash = 0
		destroy_surroundings = 0
	else
		faction = "carp"
		if(NW)
			NW.force = initial(NW.force)
		environment_smash = initial(environment_smash)
		destroy_surroundings = initial(destroy_surroundings)

/mob/living/simple_animal/hostile/carp/holodeck/gib()
	death()

/mob/living/simple_animal/hostile/carp/holodeck/death()
	..(null, "fades away!", "You have been destroyed.")
	qdel(src)
