
//list(ckey = real_name,)
//Since the ckey is used as the icon_state, the current system will only permit a single custom robot sprite per ckey.
//While it might be possible for a ckey to use that custom sprite for several real_names, it seems rather pointless to support it.
var/list/robot_custom_icons

/hook/startup/proc/load_robot_custom_sprites()
	var/config_file = file2text(CUSTOM_ITEM_SYNTH_CONFIG)
	var/list/lines = splittext(config_file, "\n")

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
		custom_sprite = TRUE
		icon = CUSTOM_ITEM_SYNTH
		var/list/valid_states = icon_states(icon)
		if(icon_state == "robot")
			if("[ckey]-Standard" in valid_states)
				icon_state = "[ckey]-Standard"
			else
				to_chat(src, "<span class='warning'>Could not locate [ckey]-Standard sprite.</span>")
				icon =  'icons/mob/robots.dmi'
