var/const/GHOST_IMAGE_NONE = 0
var/const/GHOST_IMAGE_DARKNESS = 1
var/const/GHOST_IMAGE_SIGHTLESS = 2
var/const/GHOST_IMAGE_ALL = ~GHOST_IMAGE_NONE

/mob/observer
	density = 0
	alpha = 127
	plane = OBSERVER_PLANE
	invisibility = INVISIBILITY_OBSERVER
	see_invisible = SEE_INVISIBLE_OBSERVER
	sight = SEE_TURFS|SEE_MOBS|SEE_OBJS|SEE_SELF
	simulated = FALSE
	stat = DEAD
	status_flags = GODMODE
	var/ghost_image_flag = GHOST_IMAGE_DARKNESS
	var/image/ghost_image = null //this mobs ghost image, for deleting and stuff

/mob/observer/New()
	..()
	ghost_image = image(src.icon,src)
	ghost_image.plane = plane
	ghost_image.layer = layer
	ghost_image.appearance = src
	ghost_image.appearance_flags = RESET_ALPHA
	if(ghost_image_flag & GHOST_IMAGE_DARKNESS)
		ghost_darkness_images |= ghost_image //so ghosts can see the eye when they disable darkness
	if(ghost_image_flag & GHOST_IMAGE_SIGHTLESS)
		ghost_sightless_images |= ghost_image //so ghosts can see the eye when they disable ghost sight
	SSghost_images.queue_global_image_update()

/mob/observer/Destroy()
	if (ghost_image)
		ghost_darkness_images -= ghost_image
		ghost_sightless_images -= ghost_image
		qdel(ghost_image)
		ghost_image = null
		SSghost_images.queue_global_image_update()
	. = ..()

mob/observer/check_airflow_movable()
	return FALSE

/mob/observer/CanPass()
	return TRUE

/mob/observer/dust()	//observers can't be vaporised.
	return

/mob/observer/gib()		//observers can't be gibbed.
	return

/mob/observer/is_blind()	//Not blind either.
	return

/mob/observer/is_deaf() 	//Nor deaf.
	return

/mob/observer/set_stat()
	stat = DEAD // They are also always dead

/mob/observer/touch_map_edge()
	if(z in GLOB.using_map.sealed_levels)
		return

	var/new_x = x
	var/new_y = y

	if(x <= TRANSITIONEDGE)
		new_x = TRANSITIONEDGE + 1
	else if (x >= (world.maxx - TRANSITIONEDGE + 1))
		new_x = world.maxx - TRANSITIONEDGE
	else if (y <= TRANSITIONEDGE)
		new_y = TRANSITIONEDGE + 1
	else if (y >= (world.maxy - TRANSITIONEDGE + 1))
		new_y = world.maxy - TRANSITIONEDGE

	var/turf/T = locate(new_x, new_y, z)
	if(T)
		forceMove(T)
		inertia_dir = 0
		throwing = 0
		to_chat(src, "<span class='notice'>You cannot move further in this direction.</span>")


//Turns a mob into an observer, deleting their old mob
/proc/make_observer(var/mob/M)
	if(!M || !M.client)
		return 1

	var/mob/new_player/N
	if (istype(M, /mob/new_player))
		N = M //Some procs are only for this subtype

	var/mob/observer/ghost/observer = new()

	if (N)
		N.spawning = 1
	sound_to(src, sound(null, repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel))// MAD JAMS cant last forever yo


	observer.started_as_observer = 1
	if (N)
		N.close_spawn_windows()
	var/obj/O = locate("landmark*Observer-Start")
	if(istype(O))
		observer.forceMove(O.loc)
	else
		to_chat(M, "<span class='danger'>Could not locate an observer spawn point. Use the Teleport verb to jump to the map.</span>")
	observer.timeofdeath = world.time // Set the time of death so that the respawn timer works correctly.

	if(isnull(M.client.holder))
		announce_ghost_joinleave(M)

	var/mob/living/carbon/human/dummy/mannequin = new()
	M.client.prefs.dress_preview_mob(mannequin)
	observer.set_appearance(mannequin)
	qdel(mannequin)

	if(M.client.prefs.be_random_name)
		M.client.prefs.real_name = random_name(M.client.prefs.gender)
	observer.real_name = M.client.prefs.real_name
	observer.SetName(observer.real_name)
	if(!M.client.holder && !config.antag_hud_allowed)           // For new ghosts we remove the verb from even showing up if it's not allowed.
		observer.verbs -= /mob/observer/ghost/verb/toggle_antagHUD        // Poor guys, don't know what they are missing!
	observer.key = M.key
	qdel(M)

	return observer