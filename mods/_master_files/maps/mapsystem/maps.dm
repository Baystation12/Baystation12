/datum/map
	var/shuttle_docked_sound
	var/shuttle_leaving_dock_sound
	var/shuttle_called_sound
	var/shuttle_recall_sound

/datum/map/New()
	. = ..()
	base_lobby_html = file2text('mods/lobbyscreen/html/lobby.html')

// Hard overwrite - doesn't call parent
/datum/map/show_titlescreen(client/C)
	set waitfor = FALSE

	winset(C, "lobbybrowser", "is-disabled=false;is-visible=true")

	if(isnewplayer(C.mob))
		var/datum/asset/lobby_assets = get_asset_datum(/datum/asset/simple/mod_lobby) // Sending fonts+png+mp4 assets to the client
		var/datum/asset/fa_assets = get_asset_datum(/datum/asset/simple/fontawesome)  // Sending font awesome to the client
		lobby_assets.send(C)
		fa_assets.send(C)

		if (!Master.current_runlevel)
			// Sending big video only if it's needed
			var/datum/asset/loop = get_asset_datum(/datum/asset/simple/mod_lobby_loop)
			loop.send(C)

		var/mob/new_player/player = C.mob
		show_browser(C, replacetext_char(base_lobby_html, "\[player-ref]", "\ref[player]"), "window=lobbybrowser")
		update_titlescreen(C)
