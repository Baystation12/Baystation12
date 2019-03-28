#define SLIPSPACE_ENGINE_JUMP_DELAY 10 SECONDS
#define SLIPSPACE_ENGINE_JUMP_COOLDOWN 30 SECONDS
#define SLIPSPACE_ENGINE_BASE_INTERACTION_DELAY 5 SECONDS

/obj/machinery/slipspace_engine
	name = "Slipspace Engine"
	desc = "Fear ye who dare to touch these controls, for infinite destructive power is contained within."

	var/obj/effect/overmap/om_obj
	var/core_to_spawn = null //The /obj/payload/ subtype to spawn when the engine is overloaded. null = disabled.
	var/jump_delay = SLIPSPACE_ENGINE_JUMP_DELAY
	var/jump_cooldown = SLIPSPACE_ENGINE_JUMP_COOLDOWN
	var/jump_charging = 0 // 0 = not charging, 1 = charging, =1 = disabled (usually due to lack of overmap object or core-overloading/removal)
	var/next_jump_at = null
	var/precise_jump = 0 //Makes the slipspace jump arrive precisely. Also allows an exit-jump to occur when within grav-field of objects.

/obj/machinery/slipspace_engine/LateInitialize()
	. = ..()
	om_obj = map_sectors["[z]"]
	if(isnull(om_obj))
		jump_charging = -1

/obj/machinery/slipspace_engine/proc/allow_user_operate(var/mob/user)
	return 1

/obj/machinery/slipspace_engine/proc/overload_engine(var/mob/user)

/obj/machinery/slipspace_engine/proc/user_overload_engine(var/mob/user)
	if(isnull(core_to_spawn))
		to_chat(user,"<span class = 'notice'>Physical limiters disallow core overloading on [src]</span>")
		return
	//PUT A DO_AFTER HERE PLS
	jump_charging = -1
	//TODO, FINISH OFF THE PAYLOAD SPAWNING CODE.

/obj/machinery/slipspace_engine/proc/set_next_jump_allowed(var/to_add)
	next_jump_at = world.time + to_add

/obj/machinery/slipspace_engine/proc/check_jump_allowed(var/turf/location) //Used to check validity of both jump exit-locatio and start-loc.
	if(jump_charging == -1)
		return 0
	for(var/obj/effect/overmap/om in range(4,location))
		if(istype(om,/obj/effect/overmap/sector) || istype(om,/obj/effect/overmap/ship/faction_base))
			return 0
	return 1

/obj/machinery/slipspace_engine/proc/do_slipspace_enter_effects()
	var/obj/effect/overmap/ship/om_ship = om_obj
	if(!istype(om_ship))
		return
	//BELOW CODE STOLEN FROM CAEL'S IMPLEMENTATION OF THE SLIPSPACE EFFECTS//
	om_ship.speed = list(0,0)
	//animate the slipspacejump
	var/headingdir = om_ship.get_heading()
	if(!headingdir)
		headingdir = om_ship.dir
	var/turf/T = om_ship.loc
	for(var/i=0, i<6, i++)
		T = get_step(T,headingdir)
	new /obj/effect/slipspace_rupture(T)
	//rapidly move into the portal
	walk_to(om_ship,T,0,1,0)

/obj/machinery/slipspace_engine/proc/do_slipspace_exit_effects(var/exit_loc)
	var/obj/effect/overmap/ship/om_ship = om_obj
	if(!istype(om_ship))
		return
	om_ship.speed = list(0,0)
	var/headingdir = om_ship.dir
	var/turf/T = exit_loc
	//Below code should flip the dirs.
	T = get_step(T,headingdir)
	headingdir = get_dir(T,exit_loc)
	T = exit_loc
	for(var/i=0, i<6, i++)
		T = get_step(T,headingdir)
	new /obj/effect/slipspace_rupture(T)
	om_ship.loc = T
	walk_to(om_ship,exit_loc,0,1,0)

/obj/machinery/slipspace_engine/proc/slipspace_to_location(var/turf/location)
	do_slipspace_exit_effects(location)

/obj/machinery/slipspace_engine/proc/slipspace_to_nullspace()
	do_slipspace_enter_effects()
	om_obj.loc = null

/obj/machinery/slipspace_engine/proc/user_slipspace_to_maploc(var/mob/user)
	var/targ_x = input(user,"Enter the target location's X value.(0 or null to cancel.)")
	var/targ_y = input(user,"Enter the target location's Y value.(0 or null to cancel.)")
	if(targ_x == 0 || isnull(targ_x) || targ_y == 0 || isnull(targ_y))
		to_chat(user,"<span class = 'notice'>Cancelled.</span>")
		return

	var/input_loc = locate(targ_x,targ_y,GLOB.using_map.overmap_z)

	if(isnull(input_loc))
		to_chat(user,"<span class = 'notice'>Invalid Input.</span>")
		return
	if(!precise_jump && !check_jump_allowed(input_loc))
		to_chat(user,"<span class = 'notice'>Automatic slipspace exit calculations detect interference from nearby gravitational wells at target location. Jump aborted.</span>")
		return
	visible_message("<span class = 'notice'>[user] starts prepping [src] for a jump to realspace...</span>")
	if(!do_after(user, SLIPSPACE_ENGINE_BASE_INTERACTION_DELAY, src, same_direction = 1))
		return
	visible_message("<span class = 'notice'>[user] preps [src] for a jump to realspace.</span>")
	spawn(jump_delay)
		visible_message("<span class = 'notice'>[src] momentarily glows bright, then activates!</span>")
		slipspace_to_location(input_loc)

/obj/machinery/slipspace_engine/proc/user_slipspace_to_nullspace(var/mob/user)
	if(!precise_jump && !check_jump_allowed(om_obj.loc))
		to_chat(user,"<span class = 'notice'>A nearby gravity well is disrupting [src]'s automated calculation algorithms. Move further away from nearby planets and large objects.</span>")
		return
	visible_message("<span class = 'notice'>[user] starts prepping [src] for a jump to slipspace...</span>")
	if(!do_after(user, SLIPSPACE_ENGINE_BASE_INTERACTION_DELAY, src, same_direction = 1))
		return
	visible_message("<span class = 'notice'>[user] preps [src] for a jump to slipspace.</span>")
	log_admin("[user] the [user.mind.assigned_role] (CKEY: [user.ckey]) activated a slipspace engine, transporting [om_obj] to nullspace. Jump timer: [jump_delay / 10] seconds.")
	spawn(jump_delay)
		visible_message("<span class = 'notice'>[src] momentarily glows bright, then activates!</span>")
		slipspace_to_nullspace()

/obj/machinery/slipspace_engine/attack_hand(var/mob/user)
	if(!allow_user_operate(user))
		to_chat(user,"<span class = 'notice'>You are unable to decipher the controls.</span>")
		return
	if(user.a_intent == "harm")
		user_overload_engine(user)
		return
	if(om_obj.loc == null)
		user_slipspace_to_maploc(user)
	else
		user_slipspace_to_nullspace(user)

//SLIPSPACE RUPTURE EFFECT//
/obj/effect/slipspace_rupture
	name = "slipspace rupture"
	icon = 'code/modules/halo/covenant/slipspace.dmi'
	icon_state = "slipspace_effect"
	pixel_x = -16
	pixel_y = -16
	var/time_to_die = 0

/obj/effect/slipspace_rupture/New()
	time_to_die = world.time + 6
	GLOB.processing_objects += src

/obj/effect/slipspace_rupture/process()
	if(world.time > time_to_die)
		GLOB.processing_objects -= src
		qdel(src)
