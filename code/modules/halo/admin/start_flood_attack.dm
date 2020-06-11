#define FLOOD_INVASION_ATTACK_DELAY 0.1 SECONDS
#define FLOOD_INVASION_START 'code/modules/halo/misc/flood_inv_start.ogg'
#define FLOOD_INVASION_END 'code/modules/halo/misc/flood_inv_end.ogg'

/datum/admin_secret_item/fun_secret/flood_invasion
	name = "Toggle Flood Invasion"

	var/datum/flood_invasion/current_invasion

/datum/admin_secret_item/fun_secret/flood_invasion/can_execute(var/mob/user)
	if(!ticker) return 0
	return ..()

/datum/admin_secret_item/fun_secret/flood_invasion/proc/make_sound(var/sound)
	for(var/mob/M in GLOB.player_list)
		sound_to(M, sound)

/datum/admin_secret_item/fun_secret/flood_invasion/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	if(!GLOB.using_map.use_overmap)
		to_chat(user,"This map isn't using the overmap!")
		return
	var/file_to_play
	if(current_invasion)
		to_chat(user,"Flood invasion halted")
		file_to_play = FLOOD_INVASION_END
		qdel(current_invasion)
		current_invasion = null
	else
		to_chat(user,"Flood invasion started")
		file_to_play = FLOOD_INVASION_START
		current_invasion = new /datum/flood_invasion(locate(1,1,1))

	make_sound(sound(file_to_play, repeat = 0, wait = 1, channel = 777))

/datum/flood_invasion

	var/next_attack_at = 0

/datum/flood_invasion/New()
	. = ..()
	GLOB.processing_objects += src

/datum/flood_invasion/Destroy()
	GLOB.processing_objects -= src
	. = ..()

/datum/flood_invasion/proc/do_attack()
	var/turf/spawn_on = locate(rand(2, GLOB.using_map.overmap_size - 2),rand(2, GLOB.using_map.overmap_size - 2),GLOB.using_map.overmap_z)
	var/obj/item/projectile/new_proj = new /obj/item/projectile/overmap/flood_pod (spawn_on)
	var/list/overmap_objs = list()
	for(var/obj/effect/overmap/O in world)
		overmap_objs += O
	if(overmap_objs.len == 0)
		new_proj.launch(pick(view(7,new_proj)))
	else
		new_proj.launch(pick(overmap_objs))

/datum/flood_invasion/proc/process()
	if(world.time > next_attack_at)
		do_attack()
		next_attack_at = world.time + FLOOD_INVASION_ATTACK_DELAY