/obj/effect/wallframe_spawn
	name = "wall frame window grille spawner"
	icon = 'icons/obj/structures.dmi'
	icon_state = "wingrille"
	density = 1
	anchored = 1.0
	var/win_path = /obj/structure/window/basic
	var/frame_path = /obj/structure/wall_frame
	var/activated = FALSE
	var/fulltile = TRUE

/obj/effect/wallframe_spawn/CanPass()
	return 0

/obj/effect/wallframe_spawn/attack_hand()
	attack_generic()

/obj/effect/wallframe_spawn/attack_ghost()
	attack_generic()

/obj/effect/wallframe_spawn/attack_generic()
	activate()

/obj/effect/wallframe_spawn/Initialize(mapload)
	. = ..()
	if(!win_path)
		return
	var/auto_activate = mapload || (ticker && ticker.current_state < GAME_STATE_PLAYING)
	if(auto_activate)
		activate()
		return INITIALIZE_HINT_QDEL

/obj/effect/wallframe_spawn/proc/activate()
	if(activated) return

	if(locate(/obj/structure/wall_frame) in loc)
		warning("Frame Spawner: A frame structure already exists at [loc.x]-[loc.y]-[loc.z]")
	else
		var/obj/structure/wall_frame/F = new frame_path(loc)
		handle_frame_spawn(F)

	if(locate(/obj/structure/window) in loc)
		warning("Frame Spawner: A window structure already exists at [loc.x]-[loc.y]-[loc.z]")

	if(locate(/obj/structure/grille) in loc)
		warning("Frame Spawner: A grille already exists at [loc.x]-[loc.y]-[loc.z]")
	else
		var/obj/structure/grille/G = new /obj/structure/grille(loc)
		handle_grille_spawn(G)

	var/list/neighbours = list()
	if(fulltile)
		var/obj/structure/window/new_win = new win_path(loc)
		handle_window_spawn(new_win)
	else
		for (var/dir in GLOB.cardinal)
			var/turf/T = get_step(src, dir)
			var/obj/effect/wallframe_spawn/other = locate(type) in T
			if(!other)
				var/found_connection
				if(locate(/obj/structure/grille) in T)
					for(var/obj/structure/window/W in T)
						if(W.type == win_path && W.dir == get_dir(T,src))
							found_connection = 1
							qdel(W)
				if(!found_connection)
					var/obj/structure/window/new_win = new win_path(loc)
					new_win.set_dir(dir)
					handle_window_spawn(new_win)
			else
				neighbours |= other
	activated = 1
	for(var/obj/effect/wallframe_spawn/other in neighbours)
		if(!other.activated) other.activate()

/obj/effect/wallframe_spawn/proc/handle_frame_spawn(var/obj/structure/wall_frame/F)
	for(var/direction in GLOB.cardinal)
		var/turf/T = get_step(src, direction)
		for(var/obj/O in T)
			if( istype(O, /obj/machinery/door))
				var/obj/machinery/door/D = O
				D.update_connections()
				D.update_icon()

/obj/effect/wallframe_spawn/proc/handle_window_spawn(var/obj/structure/window/W)
	return

/obj/effect/wallframe_spawn/proc/handle_grille_spawn(var/obj/structure/grille/G)
	return

/obj/effect/wallframe_spawn/reinforced
	name = "reinforced wall frame window spawner"
	icon_state = "r-wingrille"
	win_path = /obj/structure/window/reinforced/full

/obj/effect/wallframe_spawn/reinforced/titanium
	name = "reinforced titanium wall frame window spawner"
	frame_path = /obj/structure/wall_frame/titanium

/obj/effect/wallframe_spawn/reinforced/hull
	name = "reinforced hull wall frame window spawner"
	frame_path = /obj/structure/wall_frame/hull

/obj/effect/wallframe_spawn/phoron
	name = "phoron wall frame window spawner"
	icon_state = "p-wingrille"
	win_path = /obj/structure/window/phoronbasic/full

/obj/effect/wallframe_spawn/reinforced_phoron
	name = "reinforced phoron wall frame window spawner"
	icon_state = "pr-wingrille"
	win_path = /obj/structure/window/phoronreinforced/full

/obj/effect/wallframe_spawn/reinforced/polarized
	name = "polarized wall frame window spawner"
	color = "#444444"
	win_path = /obj/structure/window/reinforced/polarized/full
	var/id

/obj/effect/wallframe_spawn/reinforced/polarized/full
	name = "polarized wall frame window spawner - full tile"
	win_path = /obj/structure/window/reinforced/polarized/full

/obj/effect/wallframe_spawn/reinforced/polarized/handle_window_spawn(var/obj/structure/window/reinforced/polarized/P)
	if(id)
		P.id = id
