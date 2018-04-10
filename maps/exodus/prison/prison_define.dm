
/datum/map/exodus/prison
	name = "Avalon"
	full_name = "NSS Avalon"
	path = "exodus/prison"

	station_levels = list(1)
	admin_levels = list(3)
	contact_levels = list(1,4,6)
	player_levels = list(1,4,5,6,7)
	sealed_levels = list(6)
	empty_levels = list(6)
	accessible_z_levels = list("1" = 10, "4" = 10, "5" = 15, "7" = 60)
	base_turf_by_z = list("6" = /turf/simulated/floor/asteroid) // Moonbase
	dynamic_z_levels = list("1" = 'prison-1.dmm', "3" = 'prison-3.dmm', "6" = 'prison-6.dmm')

	station_name  = "NSS Avalon"
	station_short = "Avalon"
	dock_name     = "NAS Kekscent"
	boss_name     = "Central Command"
	boss_short    = "Centcomm"
	company_name  = "NanoTrasen"
	company_short = "NT"
	system_name   = "Pegasus"