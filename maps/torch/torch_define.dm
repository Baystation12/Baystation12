/datum/map/torch
	name = "\improper Torch"
	full_name = "\improper SEV Torch"
	path = "torch"
	flags = MAP_HAS_BRANCH | MAP_HAS_RANK
	config_path = "config/torch_config.txt"

	admin_levels  = list(7)
	escape_levels = list(8)
	empty_levels  = list(9)
	accessible_z_levels = list("1"=1,"2"=3,"3"=1,"4"=1,"5"=1,"6"=1,"9"=30)
	overmap_size = 35
	overmap_event_areas = 34
	usable_email_tlds = list("torch.ec.scg", "torch.fleet.mil", "army.mil", "freemail.net", "torch.scg", "torch.exo.cot")

	allowed_spawns = list("Cryogenic Storage", "Cyborg Storage")
	default_spawn = "Cryogenic Storage"

	station_name  = "\improper SEV Torch"
	station_short = "\improper Torch"
	dock_name     = "TBD"
	boss_name     = "Expeditionary Command"
	boss_name_ru  = "Экспедиционное Командование" //PRX
	boss_short    = "Command"
	company_name  = "Sol Central Government"
	company_short = "SolGov"
	company_name_ru = "Центрального Правительства Солнечной Системы" //PRX
	station_ru = "\improper ГЭК Факел" //PRX

	map_admin_faxes = list(
		"Expeditionary Corps Command",
		"Expeditionary Corps Logistics",
		"EXO Head Office",
		"EXO Internal Affairs",
		"SFP Territory Support",
		"SFP Special Investigations",
		"SFP Fugitive Recovery",
		"Sol Fleet Mars Commmand",
		"Sol Army Commmand",
		"Bureau of Diplomatic Affairs",
		"Emergency Management Bureau",
		"Secure Routing Service"
	)

	//These should probably be moved into the evac controller...
	shuttle_docked_message = "Внимание всему персоналу: подготовка к подпространственному прыжку завершена. Начата процедура безопасной активации генератора подпространства. Расчетное время до начала прыжка: %ETD%."
	shuttle_leaving_dock = "Внимание всему персоналу: прыжок начат. Примерное время окончания прыжка: %ETA%. Сохраняйте спокойствие и трезвость мышления."
	shuttle_called_message = "Внимание всему персоналу: запущена процедура подготовки к подпространственному прыжку в следующий сектор. Расчетное время окончания зарядки генератора блюспейса: %ETA%."
	shuttle_recall_message = "Внимание всему персоналу: процедура подготовки к подпространственному прыжку отменена. Возвращайтесь к исполнению своих рабочих обязанностей."

	evac_controller_type = /datum/evacuation_controller/starship

	default_law_type = /datum/ai_laws/solgov
	use_overmap = 1
	num_exoplanets = 1

	away_site_budget = 4
	min_offmap_players = 12

	id_hud_icons = 'maps/torch/icons/assignment_hud.dmi'
