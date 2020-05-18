GLOBAL_DATUM_INIT(cinematic, /datum/cinematic, new)
//Was moved from the gameticker to here. Could use further improvement.

/datum/cinematic
	//station_explosion used to be a variable for every mob's hud. Which was a waste!
	//Now we have a general cinematic centrally held within the gameticker....far more efficient!
	var/obj/screen/cinematic_screen = null

//Plus it provides an easy way to make cinematics for other events. Just use this as a template :)
/datum/cinematic/proc/station_explosion_cinematic(var/station_missed=0, var/datum/game_mode/override)
	set waitfor = FALSE

	if(cinematic_screen)	
		return	//already a cinematic in progress!

	if(!override)
		override = SSticker.mode
	if(!override)
		override = gamemode_cache["extended"]
	if(!override)
		return

	//initialise our cinematic screen object
	cinematic_screen = new(src)
	cinematic_screen.icon = 'icons/effects/station_explosion.dmi'
	cinematic_screen.icon_state = "station_intact"
	cinematic_screen.plane = HUD_PLANE
	cinematic_screen.layer = HUD_ABOVE_ITEM_LAYER
	cinematic_screen.mouse_opacity = 0
	cinematic_screen.screen_loc = "1,0"

	//Let's not discuss how this worked previously.
	var/list/viewers = list()
	for(var/mob/living/M in GLOB.living_mob_list_)
		if(M.client)
			M.client.screen += cinematic_screen //show every client the cinematic
			viewers[M.client] = M.stunned
			M.stunned = 8000

	override.nuke_act(cinematic_screen, station_missed) //cinematic happens here, as does mob death.
	//If its actually the end of the round, wait for it to end.
	//Otherwise if its a verb it will continue on afterwards.
	sleep(30 SECONDS)

	for(var/client/C in viewers)
		if(C.mob)
			C.mob.stunned = viewers[C]
		C.screen -= cinematic_screen
	QDEL_NULL(cinematic_screen)