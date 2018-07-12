
#define UNSC_ROLES list("ODST Assault Squad Member","ODST Assault Squad Lead","ODST Assault Team Lead")
#define INNIE_ROLES list("Insurrectionist","Insurrectionist Leader")

#define BOMB_ACTIVE -1
#define ROUND_ENDED -2

#define WARN_BOMB 2
#define WARN_GENERAL 1

/datum/game_mode/insurrection
	name = "Insurrection"
	round_description = "The UNSC has located an Insurrection base..."
	config_tag = "Insurrection"
	votable = 1
	var/list/bombs = list("timer" = 0)
	var/list/remaining_pods = list()
	var/prepare_time =  5 MINUTES //The amount of time the insurrectionists have to prepare for the ODST assault, in ticks
	var/last_assault = 0 //This is also set to -1 when a bomb is active.
	var/autolaunchtime = 12 MINUTES //At runtime, this stores the time in ticks after roundstart will launch at.
	var/pods_launched = 0
	var/warned = 0 //To stop bomb detonation warning spam

/datum/game_mode/insurrection/proc/lockdown_bombs()
	for(var/obj/payload/bomb in bombs)
		if(istype(bomb,/obj/payload/innie))
			var/obj/payload/innie/b = bomb
			b.lockdown_bomb()
			b.visible_message("<span class = 'danger'>The [b.name]'s automatic anchoring bolts engage!</span>")

/datum/game_mode/insurrection/proc/get_roles_from_faction(var/faction)
	var/list/allowed_roles = list()
	if(faction == "UNSC")
		allowed_roles = UNSC_ROLES
	else if (faction == "Insurrection")
		allowed_roles = INNIE_ROLES
	return allowed_roles

/datum/game_mode/insurrection/proc/message_faction(var/faction,var/message)
	var/list/allowed_roles = get_roles_from_faction(faction)
	for(var/mob/living/l in GLOB.player_list)
		var/datum/mind/m = l.mind
		if(m.assigned_role in allowed_roles)
			to_chat(l,"[message]")
	for(var/i in GLOB.ghost_mob_list)
		to_chat(i,"[faction]:[message]")

/datum/game_mode/insurrection/proc/obtain_all_pods()
	for(var/obj/vehicles/drop_pod/p in world)
		remaining_pods += p

/datum/game_mode/insurrection/proc/update_pod_status()
	for(var/obj/vehicles/drop_pod/p in remaining_pods)
		if(p.launched)
			remaining_pods -= p

/datum/game_mode/insurrection/proc/modify_pod_launch(var/modify_to)
	for(var/obj/vehicles/drop_pod/p in remaining_pods)
		p.launched = modify_to

/datum/game_mode/insurrection/proc/inform_start_round()
	message_faction("UNSC","<span class='danger'>Insurrection Base Located, time to Assault Pod effective range: [prepare_time/10] seconds</span>")
	message_faction("Insurrection","<span class = 'danger'>UNSC Strike Craft detected on approach vector!</span>")
	message_faction("Insurrection","<span class = 'danger'>Security of nuclear payload is not ensured, relocate payload if possible. Timed locking mechanisms are active.</span>")


/datum/game_mode/insurrection/proc/inform_last_assault()
	message_faction("UNSC","<span class = 'danger'>All assault pods have been launched. Retreating to re-arm and re-fuel.</span>")
	message_faction("Insurrection","<span class = 'danger'>UNSC Strike Craft retreating! Eliminate the remaining UNSC forces.</span>")

/datum/game_mode/insurrection/proc/last_assault()
	last_assault = TRUE
	deny_respawn = 1 //No more respawn
	modify_pod_launch(1)
	warned = WARN_GENERAL

/datum/game_mode/insurrection/proc/check_pods_left()
	return remaining_pods.len

/datum/game_mode/insurrection/proc/check_players_live(var/faction)
	var/list/live_players = list()
	var/list/allowed_roles = get_roles_from_faction(faction)
	for(var/mob/living/player in GLOB.player_list)
		if(player.z in GLOB.using_map.admin_levels)
			continue
		if(player.mind.assigned_role in allowed_roles)
			if(player.stat == CONSCIOUS)
				live_players += player
	return live_players

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
		if(!b.exploding)
			return 0
		if(!b.explode_at)
			return 0
		if((((b.explode_at - world.time)/10) <b.seconds_to_disarm) && (warned != WARN_BOMB))
			message_faction("UNSC","<span class = 'danger'>Insurrectionist self destruct nearing time of detonation. Exfiltration craft arriving at evacuation wing.</span>")
			message_faction("Insurrection","<span class='danger'>Integrated self destruct device reports nearing time of detonation. Relocate all personnel to the evacuation wing.</span>")
			warned = WARN_BOMB

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
	modify_pod_launch(1) //Stop the pods from launching.
	spawn(prepare_time) //After the time elapses, allow the pods to launch
		lockdown_bombs()
		modify_pod_launch(0)
		message_faction("UNSC","<span class='danger'>Strike Craft in effective range. Assault Pods unlocked.</span>")
	spawn(10 SECONDS) //Delay this for a little to allow for people to spawn in.
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
	if(autolaunchtime < world.time && !pods_launched)
		message_faction("UNSC","<span class = 'danger'>Assault pods auto-locked..</span>")
		pods_launched = 1
		for(var/obj/vehicles/drop_pod/p in remaining_pods)
			p.launched = 1
			remaining_pods -= p
			update_pod_status()
	if((check_pods_left() == 0) && (world.time > autolaunchtime) && (warned != WARN_GENERAL))
		inform_last_assault()
		last_assault()

/datum/game_mode/insurrection/handle_mob_death()
	update_pod_status()
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

#undef BOMB_ACTIVE
#undef ROUND_ENDED

#undef WARN_BOMB
#undef WARN_GENERAL

#undef LAUNCH_ABORTED
#undef LAUNCH_UNDERWAY