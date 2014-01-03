/datum/game_mode/meteor
	name = "meteor"
	config_tag = "meteor"
	required_players = 30

	uplink_welcome = "Syndicate Uplink Console:"
	uplink_uses = 10

	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800

/datum/game_mode/announce()
	world << "<B>The current game mode is - Meteor!</B>"
	world << "<B>Just have fun and role-play!</B>"

/datum/game_mode/extended/pre_setup()
	return 1

/datum/game_mode/extended/post_setup()
	spawn (rand(waittime_l, waittime_h)) // To reduce extended meta.
		send_intercept()
	spawn (rand(waittime_l, waittime_h))
		command_alert("Meteors have been detected on collision course with the station.", "Meteor Alert")
		world << sound('sound/AI/meteors.ogg')
		spawn(50)
		spawn_meteors(rand(1, 5))
	..()