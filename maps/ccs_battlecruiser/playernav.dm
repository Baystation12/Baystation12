GLOBAL_LIST_EMPTY(player_nav_waypoints)

/client/var/obj/effect/landmark/playernav/playernav

/obj/effect/landmark/playernav
	name = "player navigation waypoint (rename me)"
	icon_state = "x3"

/obj/effect/landmark/playernav/New()
	. = ..()
	GLOB.player_nav_waypoints[src.name] = src

/obj/effect/landmark/playernav/Topic()
	//begin navigating

//to be added as player verbs in the gamemode
/client/proc/list_destinations()
	set name = "List player destinations"
	set category = "IC"

	to_chat(src,"<span class='notice'>The following destinations are available:</span>")
	for(var/playernav_id in GLOB.player_nav_waypoints)
		var/obj/effect/landmark/playernav/playernav = GLOB.player_nav_waypoints[playernav_id]
		var/outtext = "[playernav]"
		var/mob/M = src.mob
		if(playernav.z < M.z)
			outtext += " (below [M.z - playernav.z] level/s)"
		else if(playernav.z > M.z)
			outtext += " (above [playernav.z - M.z] level/s)"

		to_chat(src,"	<span class='info'>[outtext]</span>")

/client/proc/pick_destinations()
	set name = "Choose player destination"
	set category = "IC"

	var/dest_id = input("Choose a player navigation destination","Pick destination") in GLOB.player_nav_waypoints
	if(dest_id && dest_id in GLOB.player_nav_waypoints)
		playernav = GLOB.player_nav_waypoints[dest_id]
		to_chat(src,"<span class='notice'>You have selected your desination as: [playernav]</span>")
		direct_destinations()
	else
		playernav = null

/client/proc/direct_destinations()
	set name = "Get player directions"
	set category = "IC"

	if(playernav)
		var/outtext = "Direction to [playernav]: "
		var/mob/M = src.mob
		var/targetdir = get_dir(M, playernav)
		outtext += dir2text(targetdir)
		if(playernav.z < M.z)
			outtext += " and down"
		else if(playernav.z > M.z)
			outtext += " and up"

		var/image/arrow = image('arrow.dmi', src.mob, "arrow", dir = targetdir)
		to_chat(src,"<span class='notice'>[outtext]</span>")
		flick_overlay(arrow, list(src), 25)
		spawn(25)
			qdel(arrow)
	else
		to_chat(src,"<span class='notice'>You must choose a destination first:</span>")



/datum/job/opredflag_cov/equip(var/mob/living/carbon/human/H, var/alt_title, var/datum/mil_branch/branch)
	. = ..()
	//check if we have been assigned this role and arent just previewing the equipment
	if(H.mind && H.mind.assigned_role == src.title)
		give_opredflag_nav_verbs(H)

/datum/antagonist/opredflag_cov/create_antagonist(var/datum/mind/target, var/move, var/gag_announcement, var/preserve_appearance)
	. = ..()
	give_opredflag_nav_verbs(target.current)

/proc/give_opredflag_nav_verbs(var/mob/M)
	var/client/C = M.get_client()
	if(C)
		C.verbs += /client/proc/list_destinations
		C.verbs += /client/proc/pick_destinations
		C.verbs += /client/proc/direct_destinations
