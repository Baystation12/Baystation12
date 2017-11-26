
#define UNSC_ROLES list("ODST Assault Squad Member","ODST Assault Squad Lead","ODST Assault Team Lead")
#define INNIE_ROLES list("Insurrectionist")

#define LAUNCH_ABORTED -1
#define LAUNCH_UNDERWAY -2

#define BOMB_ACTIVE -1
#define ROUND_ENDED -2

/datum/game_mode/insurrection
	name = "Insurrection"
	round_description = "The UNSC has located an Insurrection base..."
	config_tag = "Insurrection"
	votable = 1
	var/obj/payload/bombs = list("timer" = 0)
	var/list/remaining_pods = list()
	var/prepare_time =  5 MINUTES //The amount of time the insurrectionists have to prepare for the ODST assault, in ticks
	var/last_assault = 0 //This is also set to -1 when a bomb is active.
	var/autolaunchtime = 12 MINUTES //At runtime, this stores the time in ticks after roundstart will launch at.
	var/warned = 0 //To stop bomb detonation warning spam

/datum/game_mode/insurrection/proc/message_faction(var/faction,var/message)
	var/list/allowed_roles
	if(faction == "UNSC")
		allowed_roles = UNSC_ROLES
	else if (faction == "Insurrection")
		allowed_roles = INNIE_ROLES
	for(var/mob/living/l in GLOB.player_list)
		var/datum/mind/m = l.mind
		if(m.assigned_role in allowed_roles)
			to_chat(l,"[message]")
	for(var/i in GLOB.ghost_mob_list)
		to_chat(i,"[faction]:[message]")

/datum/game_mode/insurrection/proc/obtain_all_pods()
	for(var/obj/machinery/podcontrol/p in world)
		remaining_pods += p

/datum/game_mode/insurrection/proc/modify_pod_launch(var/launch_state)
	for(var/obj/machinery/podcontrol/p in remaining_pods)
		p.launching = launch_state

/datum/game_mode/insurrection/proc/update_pod_status()
	for(var/obj/machinery/podcontrol/p in remaining_pods)
		if(!p.land_point)
			remaining_pods -= p

/datum/game_mode/insurrection/proc/inform_start_round()
	message_faction("UNSC","<span class='danger'>Insurrection Base Located, time to Assault Pod effective range: [prepare_time/10] seconds</span>")
	message_faction("Insurrection","<span class = 'danger'>UNSC Strike Craft detected on approach vector!</span>")


/datum/game_mode/insurrection/proc/inform_last_assault()
	message_faction("UNSC","<span class = 'danger'>All assault pods have been launched. Retreating to re-arm and re-fuel.</span>")
	message_faction("Insurrection","<span class = 'danger'>UNSC Strike Craft retreating! Eliminate the remaining UNSC forces.</span>")

/datum/game_mode/insurrection/proc/last_assault()
	var/area/staging_area
	for(var/area/UNSC_Staging/s in world)
		staging_area = s
		break
	if(!staging_area)
		return
	for(var/obj/machinery/door/airlock/a in staging_area.contents)
		a.close()
		a.locked = TRUE
	last_assault = TRUE
	deny_respawn = 1 //No more respawn

/datum/game_mode/insurrection/proc/check_pods_left()
	return remaining_pods.len

/datum/game_mode/insurrection/proc/check_players_live(var/faction)
	var/living_players = list()
	for(var/i in GLOB.player_list)
		var/mob/l = i
		var/datum/mind/m = l.mind
		if(m.assigned_role == faction)
			if(l.stat != DEAD)
				living_players += l
	return living_players

/datum/game_mode/insurrection/proc/announce_win(var/faction)
	if(faction == "Insurrection")
		message_faction("UNSC","<span class='danger'>All friendly transmitters have ceased operation aboard the asteroid. Asteroid defence systems have obtained a lock.</span>")
		message_faction("Insurrection","<span class='danger'>No signs of UNSC intruders aboard the base. Defence systems have a lock on their strike craft.</span>")
		return 1
	if(faction == "UNSC")
		message_faction("UNSC","<span class='danger'>Assault Team Leader reports Insurrection supression success. Awaiting extraction and medical care.</span>")
		message_faction("Insurrection","<span class='danger'>Defence System Report: System intrusion detected. Manual System Override detec- </span>")
		return 1
	if(faction == "UNSC2") //Used for UNSC success via nuclear device.
		message_faction("UNSC","<span class='danger'>Insurrectionist base rendered inoperative via onboard nuclear device. Strike craft undergoing extraction and medical care.</span>")
		message_faction("Insurrection","<span class='danger'>Subspace Probe #\[ERROR] Report: Onboard nuclear device activated. Immediate relocation of assets recommended.</span>")
		return 1
	return 0

/datum/game_mode/insurrection/proc/update_bomb_timer()
	bombs[1] = world.time + 30 SECONDS

/datum/game_mode/insurrection/proc/update_bomb_status()
	update_bomb_timer()
	for(var/obj/payload/b in bombs)
		if(b.exploding == 1)
			last_assault = BOMB_ACTIVE
		if((((b.explode_at - world.time)/10) <b.seconds_to_disarm) && (!warned))
			message_faction("UNSC","<span class = 'danger'>Insurrectionist self destruct nearing time of detonation. Exfiltration craft arriving at evacuation wing.</span>")
			message_faction("Insurrection","<span class='danger'>Integrated self destruct device reports nearing time of detonation. Relocate all personnel to the evacuation wing.</span>")
			warned = TRUE

/datum/game_mode/insurrection/proc/bomb_exploded()
	if(last_assault == BOMB_ACTIVE)
		for(var/obj/payload/b in bombs)
			if(world.time >= (b.explode_at - 1) && (b.exploding))
				announce_win("UNSC2")
				return 1
	else
		return 0

/datum/game_mode/insurrection/pre_setup()
	..()
	for(var/obj/effect/landmark/innie_bomb/b in world)
		new /obj/effect/bomblocation (b.loc)
		var/inniebomb = new /obj/payload/innie (b.loc)
		bombs += inniebomb
		qdel(b)
	update_bomb_timer()
	autolaunchtime = world.time + autolaunchtime

/datum/game_mode/insurrection/post_setup()
	..()
	obtain_all_pods()
	update_bomb_status()
	modify_pod_launch(LAUNCH_UNDERWAY) //Stop the pods from launching.
	spawn(prepare_time) //After the time elapses, allow the pods to launch
		modify_pod_launch(LAUNCH_ABORTED)
		message_faction("UNSC","<span class='danger'>Strike Craft in effective range. Assault Pods unlocked.</span>")
	spawn(200) //Delay this for a little to allow for people to spawn in.
		inform_start_round()

/datum/game_mode/insurrection/process()
	..()
	if(last_assault == BOMB_ACTIVE) //When the bomb's active, check much more frequently.
		update_bomb_status()
		update_bomb_timer()
		return
	if(bombs[1] < world.time)
		update_bomb_status()
		update_bomb_timer()
	if(autolaunchtime < world.time)
		for(var/obj/machinery/podcontrol/control in remaining_pods)
			message_faction("UNSC","<span class = 'danger'>Assault pods autolaunched.</span>")
			modify_pod_launch(0)
			remaining_pods -= control
			update_pod_status()

/datum/game_mode/insurrection/handle_mob_death()
	update_pod_status()
	if(check_pods_left() == 0)
		inform_last_assault()
		last_assault()
	update_bomb_status() //Placement of this is important, if passes successfully after last_assault, it will override the usual last assault measures.
	return 1

/datum/game_mode/insurrection/check_finished()
	if(bomb_exploded())
		last_assault = ROUND_ENDED
		return 1
	if(last_assault == 1)
		var/list/living_players_unsc = check_players_live("UNSC")
		var/list/living_players_innie = check_players_live("Insurrection")
		if(living_players_unsc.len == 0)
			announce_win("Insurrection")
			return 1
		if(living_players_innie.len == 0)
			announce_win("UNSC")
			return 1
	else
		return 0

#undef LAUNCH_ABORTED
#undef LAUNCH_UNDERWAY