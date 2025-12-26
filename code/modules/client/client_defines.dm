/client
	// Allow client instances to be treated like regular datums
	parent_type = /datum

	/** At compile time, should be TRUE if serving the rsc from DD or FALSE if using other
		http server(s) to spread load. Defaults FALSE as /client/New() handles setting either
		a url from config.resource_urls, or TRUE if none exist
		Refer to http://www.byond.com/forum/post/1906517?page=2#comment23727144
	*/
	preload_rsc = FALSE

	/// When some kind of staff member, the client's permissions and behaviors
	var/datum/admins/holder

	/// When not currently wanting to see buttons, holder lives here instead
	var/datum/admins/deadmin_holder

	/// The client's preferences object, populated from save data and runtime changes
	var/datum/preferences/prefs

	/// Controls the display of tooltips to this client
	var/datum/tooltip/tooltips

	/// When starting an ahelp conversation, whether the client gets a reply button
	var/adminhelped

	/// A message to show to online staff when joining, if any
	var/staffwarn

	/// Whether or not the client is currently playing the "ship hum" ambience sound
	var/playing_vent_ambience = FALSE

	/// The next threshold time for the client to be able to play basic ambience sounds
	var/next_ambience_time = 0

	/// The last time this client was messaged from IRC. Prevents responses after 10 minutes
	var/received_irc_pm = -99999

	/// Prevents people from being spammed about multikeying every time their mob changes
	var/warned_about_multikeying = FALSE

	/// If the database is available, how old the account is in days
	var/player_age = "Requires database"

	/// If the database is available, what other accounts previously logged in from this IP
	var/related_accounts_ip = "Requires database"

	/// If the database is available, what other accounts previously logged in from this CID
	var/related_accounts_cid = "Requires database"

	/// The current fullscreen state for /client/toggle_fullscreen()
	var/fullscreen = FALSE

	/// When the client has atom outlines enabled and hovers something applicable, that thing's outline
	var/image/atom_outline

	/// A resolvable to the current atom outline target, if any
	var/weakref/outline_atom

	/// True while an atom outline update is in-flight
	var/outline_updating

	/// Mirror of the truthiness of the atom_outlines preference
	var/outline_enabled
