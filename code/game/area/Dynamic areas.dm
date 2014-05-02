/area/dynamic // Do not use.
	name = "dynamic area"
	icon_state = "purple"
	var/match_tag = "none"
	var/width = -1
	var/height = -1

/area/dynamic/destination // Do not use.
	name = "dynamic area destination"

/area/dynamic/destination/lobby
	name = "Arrivals Lobby"
	match_tag = "arrivals"
	width = 5
	height = 4

/area/dynamic/source // Do not use.
	name = "dynamic area source"
	var/lights_initially_on = 0

/area/dynamic/source/lobby_bar
	name = "\improper Bar"
	match_tag = "arrivals"
	width = 5
	height = 4

/area/dynamic/source/lobby_russian
	name = "\improper Russian Lounge"
	match_tag = "arrivals"
	width = 5
	height = 4

/area/dynamic/source/lobby_disco
	name = "\improper Disco Lounge"
	match_tag = "arrivals"
	width = 5
	height = 4