#define METEOR_DELAY 6000

/datum/game_mode/meteor
	name = "Meteor"
	round_description = "The space station has been stuck in a major meteor shower."
	extended_round_description = "The station is on an unavoidable collision course with an asteroid field. The station will be continuously slammed with meteors, venting hallways, rooms, and ultimately destroying a majority of the basic life functions of the entire structure. Coordinate with your fellow crew members to survive the inevitable destruction of the station and get back home in one piece!"
	config_tag = "meteor"
	required_players = 0
	votable = 0
	deny_respawn = 1
	var/next_wave = METEOR_DELAY

/datum/game_mode/meteor/post_setup()
	defer_powernet_rebuild = 2//Might help with the lag
	..()

/datum/game_mode/meteor/process()
	if(world.time >= next_wave)
		next_wave = world.time + meteor_wave_delay
		spawn() spawn_meteors(6, meteors_normal)

/datum/game_mode/meteor/declare_completion()
	var/text
	var/survivors = 0
	for(var/mob/living/player in player_list)
		if(player.stat != DEAD)
			var/area/A = get_area(player)
			if(!A)
				continue
			if(is_type_in_list(A, using_map.post_round_safe_areas))
				text += "<br><b><font size=2>[player.real_name] escaped in an emergenchy vehicle.</font></b>"
			else
				text += "<br><font size=1>[player.real_name] survived but is stranded without any hope of rescue.</font>"
			survivors++

	if(survivors)
		world << "<span class='notice'><B>The following survived the meteor storm</B></span>:[text]"
	else
		world << "<span class='notice'><B>Nobody survived the meteor storm!</B></span>"

	feedback_set_details("round_end_result","end - evacuation")
	feedback_set("round_end_result",survivors)

	..()
	return 1

#undef METEOR_DELAY

