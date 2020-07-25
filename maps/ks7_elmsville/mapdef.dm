
/datum/map/ks7_elmsville
	name = "111 Tauri \"Elmsville\""
	full_name = "111 Tauri System, Human Colony \"Emsville\""
	system_name = "111 Tauri"
	path = "ks7_elmsville"
	station_levels = list()
	admin_levels = list()
	accessible_z_levels = list()
	//lobby_icon = 'maps/example/example_lobby.dmi'
	lobby_icon = 'code/modules/halo/splashworks/title6.jpg'
	id_hud_icons = 'maps/ks7_elmsville/hud_icons.dmi'
	station_networks = list("Exodus")
	station_name  = "111 Tauri \"Emsville\""
	station_short = "111 Tauri"
	dock_name     = "Space Elevator"
	boss_name     = "United Nations Space Command"
	boss_short    = "UNSC HIGHCOM"
	company_name  = "United Nations Space Command"
	company_short = "UNSC"

	use_overmap = 1
	overmap_size= 125
	overmap_event_tokens = 20

	allowed_gamemodes = list("reclamation")
	map_admin_faxes = list("Ministry of Tranquility (General)","Ministry of Resolution (War Matters)","Ministry of Fervent Intercession (Internal Affairs)")

/datum/map/geminus_city/area_usage_test_exempted_areas = list(
		/area/shuttle/offsite_berth_transport,\
		/area/shuttle/innie_berth_transport,\
		/area/shuttle/innie_shuttle_transport,\
		/area/exo_ice_facility/exterior,
		/area/beach,
		/area/centcom,
		/area/centcom/holding,
		/area/centcom/specops,
		/area/chapel,
		/area/hallway,
		/area/maintenance,
		/area/medical,
		/area/medical/virology,
		/area/medical/virologyaccess,
		/area/overmap,
		/area/rnd,
		/area/rnd/xenobiology,
		/area/rnd/xenobiology/xenoflora,
		/area/rnd/xenobiology/xenoflora_storage,
		/area/security,
		/area/security/prison,
		/area/security/brig,
		/area/skipjack_station,
		/area/skipjack_station/start,
		/area/shuttle,
		/area/shuttle/escape,
		/area/shuttle/escape/centcom,
		/area/shuttle/specops,
		/area/shuttle/specops/centcom,
		/area/shuttle/syndicate_elite,
		/area/shuttle/syndicate_elite/mothership,
		/area/shuttle/syndicate_elite/station,
		/area/turbolift,
		/area/supply,
		/area/syndicate_mothership,
		/area/syndicate_mothership/elite_squad,
		/area/wizard_station,
		/area/exoplanet,
		/area/exoplanet/desert,
		/area/exoplanet/grass,
		/area/exoplanet/snow
	)
