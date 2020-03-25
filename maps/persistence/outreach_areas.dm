/area/outreach/outpost/maint
	name = "\improper Maintenance"
	icon_state = "maintcentral"

/area/outreach/outpost/sleeproom
	name = "\improper Cyrogenic Storage"

/area/outreach/outpost/medical
	name = "\improper Medical Wing"
	icon_state = "surgery"

/area/outreach/outpost/hallway
	icon_state = "hallA"
	name = "\improper Hallways"

/area/outreach/outpost/engineering
	icon_state = "engine_smes"
	name = "\improper Engineering"

/area/outreach/outpost/solar_array
	name = "\improper Solar Maintenance"
	icon_state = "SolarcontrolS"

/area/outreach/outpost/atmospherics
	icon_state = "atmos"
	name = "\improper Atmospherics"

/area/outreach/outpost/storage
	name = "\improper Storage"

/area/outreach/mines
	name = "\improper Deep Underground"
	var/do_autogenerate = FALSE
	var/depth = 0
	icon_state = "M"

/area/outreach/mines/depth_1
	do_autogenerate = TRUE
	depth = 1
	icon_state = "MD1"

/area/outreach/mines/depth_2
	do_autogenerate = TRUE
	depth = 2
	icon_state = "MD2"