/singleton/webhook/discord/submap
	config_key = "discord_submap"
	var/submap_name


/singleton/webhook/discord/submap/CreateBody(_submap_name)
	return ..(list(
		"embeds" = list(list(
			"title" = "Submap available.",
			"description" = {"The submap "[_submap_name || submap_name]" is now available."},
			"color" = 0x8bbbd5
		))
	))
