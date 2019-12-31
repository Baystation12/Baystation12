/decl/webhook/roundend
	id = WEBHOOK_ROUNDEND

// Data expects three numerical fields: "survivors", "escaped", "ghosts"
/decl/webhook/roundend/get_message(var/list/data)
	. = ..()
	var/desc = "A round of **[SSticker.mode ? SSticker.mode.name : "Unknown"]** has ended.\n"
	if(data)

		if(data["survivors"] > 0)

			var/s_was =      "was"
			var/s_survivor = "survivor"
			var/s_escaped =  "escaped"

			if(data["survivors"] != 1)
				s_was = "were"
				s_survivor = "survivors"

			if(!evacuation_controller.emergency_evacuation)
				s_escaped = "transferred"

			desc += "There [s_was] **[data["survivors"]] [s_survivor] ([data["escaped"]] [s_escaped])** and **[data["ghosts"]] ghosts.**"
		else
			desc += "There were **no survivors** ([data["ghosts"]] ghosts)."

	.["embeds"] = list(list(
		"title" = "Round [game_id] is ending.",
		"description" = desc,
		"color" = COLOR_WEBHOOK_DEFAULT
	))
