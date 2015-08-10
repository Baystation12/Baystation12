
//list(ckey = real_name,)
//Since the ckey is used as the icon_state, the current system will only permit a single custom robot sprite per ckey.
//While it might be possible for a ckey to use that custom sprite for several real_names, it seems rather pointless to support it.
var/list/robot_custom_icons

/hook/startup/proc/load_robot_custom_sprites()
	var/config_file = file2text("config/custom_sprites.txt")
	var/list/lines = text2list(config_file, "\n")

	robot_custom_icons = list()
	for(var/line in lines)
		//split entry into ckey and real_name
		var/split_idx = findtext(line, "-") //this works if ckey cannot contain dashes, and findtext starts from the beginning
		if(!split_idx || split_idx == length(line))
			continue //bad entry

		var/ckey = copytext(line, 1, split_idx)
		var/real_name = copytext(line, split_idx+1)

		robot_custom_icons[ckey] = real_name
	return 1

/mob/living/silicon/robot/proc/set_custom_sprite()
	var/rname = robot_custom_icons[ckey]
	if(rname && rname == real_name)
		custom_sprite = 1
		icon = CUSTOM_ITEM_SYNTH
		if(icon_state == "robot")
			icon_state = "[ckey]-Standard"
