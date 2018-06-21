// Temporary ingame species whitelist created for test purposes

/proc/SpeciesIngameWhitelist_GetPlayerPannelButton(var/datum/admins/source, var/client/player)
	if (!config.useingamealienwhitelist)
		return
	var/result = {"<br><b>Species whitelisted:</b>  
		[player.species_ingame_whitelisted ? "<A href='?src=\ref[source];removefromspeciesingamewhitelist=\ref[player]'>Yes</A>" : "<A href='?src=\ref[source];addtospeciesingamewhitelist=\ref[player]'>No</A>"]
		"}
	return result

/proc/SpeciesIngameWhitelist_AdminTopicProcess(var/datum/admins/source, var/list/href_list)
	var/client/player = null
	if (href_list["addtospeciesingamewhitelist"])
		player = locate(href_list["addtospeciesingamewhitelist"])
		player.species_ingame_whitelisted = TRUE
	else if (href_list["removefromspeciesingamewhitelist"])
		player = locate(href_list["removefromspeciesingamewhitelist"])
		player.species_ingame_whitelisted = FALSE
	else
		return
	
	source.show_player_panel(player.mob) // update panel

/proc/SpeciesIngameWhitelist_CheckPlayer(var/client/player)
	if (!config.useingamealienwhitelist)
		return
	return player.species_ingame_whitelisted