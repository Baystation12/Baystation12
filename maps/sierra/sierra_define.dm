/datum/map/sierra
	name = "Sierra"
	full_name = "NSV Sierra"
	path = "sierra"
	flags = MAP_HAS_BRANCH | MAP_HAS_RANK

	load_legacy_saves = TRUE

	station_levels = list(1,2,3)
	admin_levels = list(4,5)
	empty_levels = list(6)
	accessible_z_levels = list("1"=1,"2"=1,"3"=1,"6"=30)
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

	evac_controller_type = /datum/evacuation_controller/starship/fast

	lockdown_support = TRUE

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
			HOME_SYSTEM_TERSTEN,
			HOME_SYSTEM_LORRIMAN,
			HOME_SYSTEM_CINU,
			HOME_SYSTEM_YUKLID,
			HOME_SYSTEM_LORDANIA,
			HOME_SYSTEM_KINGSTON,
			HOME_SYSTEM_GAIA,
			HOME_SYSTEM_MAGNITKA,
			HOME_SYSTEM_AVALON,
			HOME_SYSTEM_MIRANIA,
			HOME_SYSTEM_NYX_BRINKBURN,
			HOME_SYSTEM_NYX_KALDARK,
			HOME_SYSTEM_NYX_ROANOK,
			HOME_SYSTEM_NYX_YUKLIT,
			HOME_SYSTEM_NYX_CASSER,
			HOME_SYSTEM_OTHER
		),
		TAG_FACTION = list(
			FACTION_SOL_CENTRAL,
			FACTION_INDIE_CONFED,
			FACTION_NANOTRASEN,
			FACTION_HEPHAESTUS,
			FACTION_WARD_TAKAHASHI,
			FACTION_SEPTENERGO,
			FACTION_FOCAL_POINT,
			FACTION_AERTHER,
			FACTION_DAIS,
			FACTION_XION,
			FACTION_GRAYSON,
			FACTION_MAJOR_BILL,
			FACTION_BISHOP,
			FACTION_MORPHEUS,
			FACTION_VEY_MED,
			FACTION_ZENG_HU,
			FACTION_ZPCI,
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
			CULTURE_HUMAN_CETI,
			CULTURE_HUMAN_SPACER,
			CULTURE_HUMAN_SPAFRO,
			CULTURE_HUMAN_CONFED,
			CULTURE_HUMAN_OTHER,
			CULTURE_HUMAN_LORRIMAN,
			CULTURE_HUMAN_AVANOBLE,
			CULTURE_HUMAN_AVACOMMON,
			CULTURE_OTHER
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

	high_secure_areas = list(
	//	"First Deck - Security - Armory",			WikiPedia's
	//	"First Deck - Security - Armory Lobby",		Lie
	//	"First Deck - Vault",
	//	"AI Chamber",
		"Second Deck - AI Upload",
		"Second Deck - AI Upload Access")

	secure_areas = list(
		"Second Deck - Engine - Supermatter",
		"Second Deck - Engineering - Technical Storage",
		"Second Deck - Teleporter",
		"First Deck - Telecoms - Storage",
		"First Deck - Telecoms - Monitoring",
		"First Deck - Telecoms",
		"Security - Brig",
		"Security - Prison Wing",
		"Third Deck - Hangar",
		"Third Deck - Hangar - Atmospherics Storage",
		"Third Deck - Water Cistern"
		)
