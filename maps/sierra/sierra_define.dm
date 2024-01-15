/datum/map/sierra
	name = "\improper Sierra"
	full_name = "\improper NSV Sierra"
	path = "sierra"
	config_path = "config/sierra_config.txt"
	flags = MAP_HAS_BRANCH | MAP_HAS_RANK

	// Authored by CuddleAndTea
	// https://clips.twitch.tv/MildIgnorantJayGivePLZ-CvZlfeclHBx4Ye1l
	welcome_sound = 'maps/sierra/sound/welcome.ogg'

	load_legacy_saves = TRUE

	station_levels = list(1,2,3,4,5)
	admin_levels = list(6,7)
	empty_levels = list(8)
	accessible_z_levels = list("1"=1,"2"=1,"3"=1,"4"=1,"5"=1,"8"=25)
	overmap_size = 40
	overmap_event_areas = 34
	usable_email_tlds = list("freemail.net")

	allowed_spawns = list("Cryogenic Storage", "Cyborg Storage")
	default_spawn = "Cryogenic Storage"

	station_name  = "NSV Sierra"
	station_short = "Sierra"
	dock_name     = "TBD"
	boss_name     = "Central Command"
	boss_short    = "Centcomm"
	company_name  = "NanoTrasen"
	company_short = "NT"

	map_admin_faxes = list("NanoTrasen Central Office")

	evac_controller_type = /datum/evacuation_controller/starship

	default_law_type = /datum/ai_laws/nanotrasen
	use_overmap = 1
	num_exoplanets = 1
	planet_size = list(129,129)

//	minimum_players = 0 its already 0

	away_site_budget = 5.5 // Было 5, увеличили на 10% вместе с уменьешением цены для одноуровневых авеек ~bear1ake
	min_offmap_players = 10

	id_hud_icons = 'maps/sierra/icons/assignment_hud.dmi'

	available_cultural_info = list(
		TAG_HOMEWORLD = list(
			HOME_SYSTEM_EARTH,
			HOME_SYSTEM_LUNA,
			HOME_SYSTEM_MARS,
			HOME_SYSTEM_VENUS,
			HOME_SYSTEM_CERES,
			HOME_SYSTEM_PLUTO,
			HOME_SYSTEM_TAU_CETI,
			HOME_SYSTEM_HELIOS,
			HOME_SYSTEM_TERRA,
			HOME_SYSTEM_GAIA,
			HOME_SYSTEM_MAGNITKA,
			HOME_SYSTEM_OTHER
		),
		TAG_FACTION = list(
			FACTION_SOL_CENTRAL,
			FACTION_INDIE_CONFED,
			FACTION_NANOTRASEN,
			FACTION_HEPHAESTUS,
			FACTION_DAIS,
			FACTION_PCRC,
			FACTION_SAARE,
			FACTION_XYNERGY,
			FACTION_FREETRADE,
			FACTION_OTHER
		),
		TAG_CULTURE = list(
			CULTURE_HUMAN_MARTIAN,
			CULTURE_HUMAN_MARSTUN,
			CULTURE_HUMAN_LUNAPOOR,
			CULTURE_HUMAN_LUNARICH,
			CULTURE_HUMAN_VENUSIAN,
			CULTURE_HUMAN_VENUSLOW,
			CULTURE_HUMAN_BELTER,
			CULTURE_HUMAN_PLUTO,
			CULTURE_HUMAN_EARTH,
			CULTURE_HUMAN_CETIN,
			CULTURE_HUMAN_CETIS,
			CULTURE_HUMAN_CETII,
			CULTURE_HUMAN_FOSTER,
			CULTURE_HUMAN_PIRXL,
			CULTURE_HUMAN_PIRXB,
			CULTURE_HUMAN_PIRXF,
			CULTURE_HUMAN_TADMOR,
			CULTURE_HUMAN_IOLAUS,
			CULTURE_HUMAN_BRAHE,
			CULTURE_HUMAN_EOS,
			CULTURE_HUMAN_SPACER,
			CULTURE_HUMAN_OFFWORLD,
			CULTURE_HUMAN_SOLCOL,
			CULTURE_HUMAN_CONFEDC,
			CULTURE_HUMAN_CONFEDO,
			CULTURE_HUMAN_OTHER
		),
		TAG_RELIGION = list(
			RELIGION_OTHER,
			RELIGION_JUDAISM,
			RELIGION_HINDUISM,
			RELIGION_BUDDHISM,
			RELIGION_SIKHISM,
			RELIGION_JAINISM,
			RELIGION_ISLAM,
			RELIGION_CHRISTIANITY,
			RELIGION_BAHAI_FAITH,
			RELIGION_AGNOSTICISM,
			RELIGION_DEISM,
			RELIGION_ATHEISM,
			RELIGION_THELEMA,
			RELIGION_SPIRITUALISM,
			RELIGION_SHINTO,
			RELIGION_TAOISM
		)
	)

/*
	lobby_tracks = list(
		// Absconditus - Zhay Tee		--,
		/singleton/audio/track/absconditus,

		// Bad Apple!! (slowed down) - Alstroemeria Records		--,
		/singleton/audio/track/ambispace,

		// As Far As It Gets - A Drop A Day		--,
		/singleton/audio/track/asfarasitgets,

		// Business End - Cletus Got Shot		--,
		// /singleton/audio/track/businessend,

		// Chasing Time - Dexter Britain		--,
		/singleton/audio/track/chasing_time,

		// Clouds of Fire - Hector/dMk		--,
		/singleton/audio/track/clouds_of_fire,

		// Comet Halley - Stellardrone		--,
		/singleton/audio/track/comet_haley,

		// Dwarf Fortress Main Theme - Beyond Quality		--,
		// /singleton/audio/track/df_theme,

		// Half-Life 2 - Tracking Device - Kelly Bailey		--,
		// /singleton/audio/track/digit_one,

		// Robocop.mp3 - CBoyardee		--,
		// /singleton/audio/track/dilbert,

		// 80s All Over Again - A Drop A Day		--,
		// /singleton/audio/track/eighties,

		// Local Forecast (Elevator) - Kevin MacLeod		--,
		// /singleton/audio/track/elevator,

		// every light is blinking at once - Earthcrusher		--,
		// /singleton/audio/track/elibao,

		// Endless Space - SolusLunes		--,
		/singleton/audio/track/endless_space,

		// Epic Intro 2015 - Sascha Ende		--,
		// /singleton/audio/track/epicintro2015,

		// Epic Intro 2017 - Sascha Ende		--,
		/singleton/audio/track/epicintro2017,

		// Unknown - Unknown		--,
		/singleton/audio/track/floating,

		// Hull Rupture - Mikazu		--,
		// /singleton/audio/track/hull_rupture,

		// Human - Borrtex		--,
		/singleton/audio/track/human,

		// In Orbit - Chronox		--,
		/singleton/audio/track/inorbit,

		// lasers rip apart the bulkhead - Earthcrusher		--,
		/singleton/audio/track/lasers,

		// Flip-Flap - X-CEED		--,
		// /singleton/audio/track/level3_mod,

		// Memories Of Lysendraa - TALES		--,
		// /singleton/audio/track/lysendraa,

		// Marhaba - Ian Alex Mac		--,
		// /singleton/audio/track/marhaba,

		// Martian Cowboy - Kevin MacLeod		--,
		/singleton/audio/track/martiancowboy,

		// Misanthropic Corridors - Mikazu		--,
		// /singleton/audio/track/misanthropic_corridors,

		// Monument - Six Umbrellas		--,
		// /singleton/audio/track/monument,

		// Nebula - Pulse Emitter		--,
		/singleton/audio/track/nebula,

		// One (abridged loop) - Swedish House Mafia		--,
		// /singleton/audio/track/one_loop,

		// On the Rocks - Mikazu		--,
		// /singleton/audio/track/on_the_rocks,

		// phoron will make us rich - Earthcrusher		--,
		// /singleton/audio/track/pwmur,

		// Rimward Cruise - Mikazu		--,
		// /singleton/audio/track/rimward_cruise,

		// Salut John - Quimorucru		--,
		// /singleton/audio/track/salutjohn,

		// Space Oddity - Chris Hadfield		--,
		/singleton/audio/track/space_oddity,

		// Sektor11 - MashedByMachines		--,
		// /singleton/audio/track/thunderdome,

		// Torch: A Light in the Darkness - L. Luke Leimer/LorenLuke		--,
		// /singleton/audio/track/torch, // ПОКА Я ЖИВОЙ НИКАКОГО ТОРЧА НЕ БУДЕТ

		// Torn - Macamoto		--,
		/singleton/audio/track/torn,

		// Treacherous Voyage - Jon Luc Hefferman		--,
		/singleton/audio/track/treacherous_voyage,

		// Voidsent - Mikazu		--,
		// /singleton/audio/track/voidsent,

		// Wake - Ryan Little		--,
		/singleton/audio/track/wake,

		// Wild Encounters - A Drop A Day		--,
		// /singleton/audio/track/wildencounters
	)
*/
