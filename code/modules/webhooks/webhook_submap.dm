/singleton/webhook/submap_loaded
	id = WEBHOOK_SUBMAP_LOADED

// Data expects a "name" field containing the name of the submap being announced.
/singleton/webhook/submap_loaded/get_message(list/data)
	. = ..()
	var/submap_name = data && data["name"]
	if (submap_name)
		submap_name = ", [submap_name],"
	var/desc = "A submap[submap_name] is currently available."

	.["embeds"] = list(list(
		"title" = "Submap available.",
		"description" = desc,
		"color" = COLOR_WEBHOOK_DEFAULT
	))
