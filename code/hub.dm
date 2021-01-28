/world
/* This page contains info for the hub. To allow your server to be visible on the hub, update the entry in the config.
 * You can also toggle visibility from in-game with toggle-hub-visibility; be aware that it takes a few minutes for the hub go
 */
	hub = "Exadv1.spacestation13"
	name = "Space Station 13 - Baystation 12"

/world/proc/update_hub_visibility(new_status)
	if (isnull(new_status))
		new_status = !config.hub_visible
	config.hub_visible = new_status
	if (config.hub_visible)
		hub_password = "kMZy3U5jJHSiBQjr"
	else
		hub_password = "SORRYNOPASSWORD"
