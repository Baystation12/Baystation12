#define SLIPSPACE_ENGINE_JUMP_DELAY 10 SECONDS
#define SLIPSPACE_ENGINE_JUMP_COOLDOWN 5 MINUTES
#define SLIPSPACE_ENGINE_BASE_INTERACTION_DELAY 5 SECONDS
#define SLIPSPACE_ENGINE_INACCURACY 4 //Inaccuracy in tiles.
#define SLIPSPACE_ENGINE_POWER_LOAD 200000
#define SLIPSPACE_PORTAL_DIST 6 //The distance the slipspace portal is generated from the start/end location. For aesthetics.
#define SLIPSPACE_GRAV_WELL_RANGE 7 //The range of large-object's gravity well. Blocks jumps in/out of said tiles.
#define SLIPSPACE_JUMPSOUND_RANGE 7 //Recommended to at least be larger than the portal_dist
#define SLIPSPACE_JUMP_ALERT_RANGE 14 //Range in overmap tiles.

/obj/machinery/slipspace_engine
	name = "Slipspace Engine"
	desc = "Fear ye who dare to touch these controls, for infinite destructive power is contained within."
	anchored = 1
	density = 1

	var/obj/effect/overmap/om_obj

	var/core_to_spawn = null //The /obj/payload/ subtype to spawn when the engine is overloaded. null = disabled.

	var/jump_delay = SLIPSPACE_ENGINE_JUMP_DELAY
	var/jump_cooldown = SLIPSPACE_ENGINE_JUMP_COOLDOWN
	var/jump_charging = 0 // 0 = not charging, 1 = charging, =1 = disabled (usually due to lack of overmap object or core-overloading/removal)

	var/next_jump_at = null

	var/precise_jump = 0 //Makes the slipspace jump arrive precisely. Also allows exit and entrance jumps to occur when within grav-field of objects.
	var/drive_inaccuracy = SLIPSPACE_ENGINE_INACCURACY //If precise_jump is set to 1, this is ignored.
	var/jump_sound = 'code/modules/halo/sounds/slipspace_jump.ogg'

	var/slipspace_target_status = 1		//1 = nullspace and back to realspace, 2 = nullspace permanently to despawn the ship ("leave the system")
	ai_access_level = 4

/obj/machinery/slipspace_engine/Initialize()
	. = ..()
	om_obj = map_sectors["[z]"]
	if(isnull(om_obj))
		jump_charging = -1

/obj/machinery/slipspace_engine/proc/allow_user_operate(var/mob/user)
	return 1

/obj/machinery/slipspace_engine/proc/play_jump_sound(var/sound_loc_origin)
	if(jump_sound == null)
		return
	var/list/mobs_to_sendsound = list()
	mobs_to_sendsound += GLOB.mobs_in_sectors[om_obj]
	for(var/obj/effect/overmap/om in range(SLIPSPACE_JUMPSOUND_RANGE,sound_loc_origin))
		mobs_to_sendsound |= GLOB.mobs_in_sectors[om]
	for(var/mob/m in mobs_to_sendsound)
		playsound(m,jump_sound,100)

/obj/machinery/slipspace_engine/proc/send_jump_alert(var/alert_origin)
	var/list/mobs_to_alert = list()
	mobs_to_alert += GLOB.mobs_in_sectors[om_obj]
	for(var/obj/effect/overmap/om in range(SLIPSPACE_JUMP_ALERT_RANGE,alert_origin))
		mobs_to_alert |= GLOB.mobs_in_sectors[om]
	var/list/dirlist = list("north","south","n/a","east","northeast","southeast","n/a","west","northwest","southwest")
	for(var/mob/m in mobs_to_alert)
		to_chat(m,"<span class = 'danger'>ALERT: Slipspace rupture detected to the [dirlist[get_dir(map_sectors["[m.z]"],alert_origin)]]</span>")

/obj/machinery/slipspace_engine/proc/overload_engine(var/mob/user)
	jump_charging = -1
	src.density = 0
	var/obj/core = new core_to_spawn(loc)
	icon_state = "[initial(icon_state)]_coreremoved"
	core.attack_hand(user)

/obj/machinery/slipspace_engine/proc/user_overload_engine(var/mob/user)
	if(isnull(core_to_spawn))
		to_chat(user,"<span class = 'notice'>Physical limiters disallow core overloading on [src]</span>")
		return
	visible_message("<span class = 'danger'>[user] starts prepping [src] for mobile core detonation...</span>")
	if(!do_after(user, SLIPSPACE_ENGINE_BASE_INTERACTION_DELAY * 3, src, same_direction = 1))
		return
	visible_message("<span class = 'danger'>[user] preps [src] for mobile core detonation..</span>")
	message2discord(config.oni_discord, "Alert: [user.real_name] ([user.ckey]) has overloaded the slipspace engine @ ([loc.x],[loc.y],[loc.z])")
	overload_engine(user)

/obj/machinery/slipspace_engine/proc/set_next_jump_allowed(var/to_add)
	next_jump_at = world.time + to_add

/obj/machinery/slipspace_engine/proc/check_jump_allowed(var/turf/location) //Used to check validity of both jump exit-locatio and start-loc.
	if(jump_charging == -1)
		return 0
	for(var/obj/effect/overmap/om in range(SLIPSPACE_GRAV_WELL_RANGE,location))
		if(om.block_slipspace)
			return 0
	return 1

/obj/machinery/slipspace_engine/proc/do_slipspace_enter_effects()
	//BELOW CODE STOLEN FROM CAEL'S IMPLEMENTATION OF THE SLIPSPACE EFFECTS, MODIFIED.//
	var/obj/effect/overmap/ship/om_ship = om_obj
	if(istype(om_ship))
		om_ship.speed = list(0,0)
		om_ship.break_umbilicals()
	//animate the slipspacejump
	var/headingdir = om_obj.dir
	var/turf/T = om_obj.loc
	for(var/i=0, i<SLIPSPACE_PORTAL_DIST, i++)
		T = get_step(T,headingdir)
	new /obj/effect/slipspace_rupture(T)
	play_jump_sound(T)
	//rapidly move into the portal
	walk_to(om_obj,T,0,1,0)
	spawn(SLIPSPACE_PORTAL_DIST)
		om_obj.loc = null
		walk_to(om_obj,null)

/obj/machinery/slipspace_engine/proc/do_slipspace_exit_effects(var/exit_loc)
	var/obj/effect/overmap/ship/om_ship = om_obj
	if(istype(om_ship))
		om_ship.speed = list(0,0)

	var/headingdir = om_obj.dir
	var/turf/T = exit_loc
	//Below code should flip the dirs.
	T = get_step(T,headingdir)
	headingdir = get_dir(T,exit_loc)
	T = exit_loc
	for(var/i=0, i<SLIPSPACE_PORTAL_DIST, i++)
		T = get_step(T,headingdir)
	new /obj/effect/slipspace_rupture(T)
	play_jump_sound(T)
	send_jump_alert(T)
	om_obj.loc = T
	walk_to(om_obj,exit_loc,0,1,0)
	spawn(SLIPSPACE_PORTAL_DIST)
		walk_to(om_obj,null)

/obj/machinery/slipspace_engine/proc/slipspace_to_location(var/turf/location)
	do_slipspace_exit_effects(location)
	var/obj/effect/overmap/ship = map_sectors["[src.z]"]
	ship.slipspace_status = 0

/obj/machinery/slipspace_engine/proc/slipspace_to_nullspace()
	do_slipspace_enter_effects()
	var/obj/effect/overmap/ship = map_sectors["[src.z]"]
	ship.slipspace_status = slipspace_target_status

/obj/machinery/slipspace_engine/proc/user_slipspace_to_maploc(var/mob/user)
	var/targ_x = text2num(input(user,"Enter the target location's X value.(0 or null to cancel.)"))
	var/targ_y = text2num(input(user,"Enter the target location's Y value.(0 or null to cancel.)"))
	if(targ_x == 0 || isnull(targ_x) || targ_y == 0 || isnull(targ_y))
		to_chat(user,"<span class = 'notice'>Cancelled.</span>")
		return

	var/input_loc = locate(targ_x,targ_y,GLOB.using_map.overmap_z)

	var/target_loc = input_loc
	if(!precise_jump)
		target_loc = pick(range(drive_inaccuracy,om_obj))

	if(isnull(target_loc))
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
	set_next_jump_allowed(jump_cooldown/4) //Smaller delay when jumping to nullspace than when jumping back to realspace.
	jump_charging = 2
	visible_message("<span class = 'notice'>[user] preps [src] for a jump to slipspace.</span>")
	log_admin("[user] the [user.mind.assigned_role] (CKEY: [user.ckey]) activated a slipspace engine, transporting [om_obj] to nullspace. Jump timer: [jump_delay / 10] seconds.")
	spawn(jump_delay)
		visible_message("<span class = 'notice'>[src] momentarily glows bright, then activates!</span>")
		slipspace_to_nullspace()

/obj/machinery/slipspace_engine/process()
	if(jump_charging == 2)
		var/obj/effect/overmap/ship/om_ship = om_obj
		if(istype(om_ship))
			om_ship.speed = list(0,0)
	if(jump_charging == (1 || 2))
		var/area/area_contained = loc.loc
		if(!istype(area_contained))
			return
		var/datum/powernet/area_powernet = area_contained.apc.terminal.powernet
		if(isnull(area_powernet))
			return
		if(area_powernet.avail-area_powernet.load < SLIPSPACE_ENGINE_POWER_LOAD)
			set_next_jump_allowed(jump_cooldown)//Reset the cooldown if we can't pull enough power.
			return
		area_powernet.draw_power(SLIPSPACE_ENGINE_POWER_LOAD)
	if(world.time > next_jump_at && jump_charging != -1)
		jump_charging = 0

/obj/machinery/slipspace_engine/ex_act(var/severity)
	return

/obj/machinery/slipspace_engine/Destroy()
	if(om_obj && om_obj.loc == null)
		slipspace_to_location(pick(block(locate(1,1,GLOB.using_map.overmap_z),locate(GLOB.using_map.overmap_size,GLOB.using_map.overmap_size,GLOB.using_map.overmap_z))))
	. = ..()

/obj/machinery/slipspace_engine/examine(var/mob/user)
	. = ..()
	if(jump_charging == -1)
		to_chat(user,"<span class = 'notice'>[src] is disabled.</span>")
	if(jump_charging == 1)
		to_chat(user,"<span class = 'notice'>[src] is charging.</span>")

/obj/machinery/slipspace_engine/attack_hand(var/mob/user)
	if(jump_charging == -1)
		to_chat(user,"<span class = 'notice'>[src] is non-functional.</span>")
		return
	if(!allow_user_operate(user))
		to_chat(user,"<span class = 'notice'>You are unable to decipher the controls.</span>")
		return
	if(user.a_intent == "harm")
		user_overload_engine(user)
		return
	if(world.time < next_jump_at)
		to_chat(user,"<span class = 'notice'>[src] is still charging.</span>")
		return
	if(om_obj.loc == null)
		user_slipspace_to_maploc(user)
	else
		user_slipspace_to_nullspace(user)

//FACTION SUBTYPES//
/obj/machinery/slipspace_engine/covenant
	name = "\improper Slipspace Traversal Drive"
	desc = "A self-contained device allowing for traversal of slipspace, providing methods of quick travel across large distances without sacrificing accuracy. Can perform slipspace jumps within the gravity wells of large objects."
	icon = 'code/modules/halo/icons/machinery/covenant/slipspace_drive.dmi'
	icon_state = "slipspace"
	bounds = "64,64"
	core_to_spawn = /obj/payload/slipspace_core/cov
	precise_jump = 1

/*
/obj/machinery/slipspace_engine/covenant/allow_user_operate(var/mob/user)
	var/mob/living/carbon/human/h = user
	if(istype(h) && h.species.type in COVENANT_SPECIES_AND_MOBS)
		return 1
	if(user && user.type in COVENANT_SPECIES_AND_MOBS)
		return 1
	return 0
*/

/obj/machinery/slipspace_engine/human
	name = "\improper Shaw-Fujikawa Translight Engine"
	desc = "A self-contained device allowing for traversal of slipspace, providing methods of quick travel across large distances. Calculation inaccuracies lead to endpoints being offset from the targeted position. Gravity wells of large objects halt the drive's ability to function."
	icon = 'code/modules/halo/icons/machinery/slipspace_drive.dmi'
	icon_state = "slipspace"
	bounds = "64,64"
	core_to_spawn = /obj/payload/slipspace_core/human

//CORE PAYLOADS//
/obj/payload/slipspace_core
	name = "Slipspace Core"
	desc = "The core of a slipspace device, detached and armed."
	w_class = ITEM_SIZE_HUGE
	free_explode = 1
	explodetype = /datum/explosion/slipspace_core
	seconds_to_explode = 300 //5 minutes to explode.
	seconds_to_disarm = 30 // 30 sesconds to disarm.

/obj/payload/slipspace_core/attack_hand(var/mob/living/carbon/human/user)
	. = ..()
	if(exploding && !disarming)
		for(var/mob/player in GLOB.mobs_in_sectors[map_sectors["[z]"]])
			to_chat(player,"<span class = 'danger'>UNSTABLE SLIPSPACE SIGNATURE DETECTED AT [loc.loc] ([x],[y],[z]). STABALISE SIGNATURE OR SUPERSTRUCTURE FAILURE WILL BE IMMINENT.</span>")

/datum/explosion/slipspace_core/New(var/obj/payload/b)
	if(config.oni_discord)
		message2discord(config.oni_discord, "Alert: slipspace core detonation detected. [b.name] @ ([b.loc.x],[b.loc.y],[b.loc.z])")
	var/obj/effect/overmap/om = map_sectors["[b.z]"]
	if(isnull(om))
		return
	om.pre_superstructure_failing()

/obj/payload/slipspace_core/cov
	icon = 'code/modules/halo/icons/machinery/covenant/slipspace_drive.dmi'
	icon_state = "core"

/obj/payload/slipspace_core/human
	icon = 'code/modules/halo/icons/machinery/slipspace_drive.dmi'
	icon_state = "core"

//SLIPSPACE RUPTURE EFFECT//
/obj/effect/slipspace_rupture
	name = "slipspace rupture"
	icon = 'code/modules/halo/icons/machinery/slipspace_jump_effects.dmi'
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
