/obj/structure/droppod_door
	name = "pod door"
	desc = "A drop pod door. Opens rapidly using explosive bolts."
	icon = 'icons/obj/structures.dmi'
	icon_state = "droppod_door_closed"
	anchored = TRUE
	density = TRUE
	opacity = 1
	layer = ABOVE_DOOR_LAYER
	var/deploying
	var/deployed

/obj/structure/droppod_door/New(var/newloc, var/autoopen)
	..(newloc)
	if(autoopen)
		spawn(10 SECONDS)
			deploy()

/obj/structure/droppod_door/attack_ai(var/mob/user)
	if(!user.Adjacent(src))
		return
	attack_hand(user)

/obj/structure/droppod_door/attack_generic(var/mob/user)
	if(istype(user))
		attack_hand(user)

/obj/structure/droppod_door/attack_hand(var/mob/user)
	if(deploying) return
	to_chat(user, "<span class='danger'>You prime the explosive bolts. Better get clear!</span>")
	sleep(30)
	deploy()

/obj/structure/droppod_door/proc/deploy()
	if(deployed)
		return

	deployed = 1
	visible_message("<span class='danger'>The explosive bolts on \the [src] detonate, throwing it open!</span>")
	playsound(src.loc, 'sound/effects/bang.ogg', 50, 1, 5)

	// This is shit but it will do for the sake of testing.
	for(var/obj/structure/droppod_door/D in orange(1,src))
		if(D.deployed)
			continue
		D.deploy()

	// Overwrite turfs.
	var/turf/origin = get_turf(src)
	origin.ChangeTurf(/turf/simulated/floor/reinforced)
	origin.set_light(0) // Forcing updates
	var/turf/T = get_step(origin, src.dir)
	T.ChangeTurf(/turf/simulated/floor/reinforced)
	T.set_light(0) // Forcing updates

	// Destroy turf contents.
	for(var/obj/O in origin)
		if(!O.simulated)
			continue
		qdel(O) //crunch
	for(var/obj/O in T)
		if(!O.simulated)
			continue
		qdel(O) //crunch

	// Hurl the mobs away.
	for(var/mob/living/M in T)
		M.throw_at(get_edge_target_turf(T,src.dir),rand(0,3),50)
	for(var/mob/living/M in origin)
		M.throw_at(get_edge_target_turf(origin,src.dir),rand(0,3),50)

	// Create a decorative ramp bottom and flatten out our current ramp.
	set_density(0)
	set_opacity(0)
	icon_state = "ramptop"
	var/obj/structure/droppod_door/door_bottom = new(T)
	door_bottom.deployed = 1
	door_bottom.set_density(0)
	door_bottom.set_opacity(0)
	door_bottom.set_dir(src.dir)
	door_bottom.icon_state = "rampbottom"