
/datum/computer_file/program/experimental_analyzer
	filename = "exp_analyzer"
	filedesc = "Experimental Analyzer program"
	program_icon_state = "research"
	nanomodule_path = /datum/nano_module/program/experimental_analyzer
	extended_desc = "A program to review and activate researching of techprints"
	size = 30
	available_on_ntnet = 1

/datum/nano_module/program/experimental_analyzer
	name = "Experimental Analyzer program"
	var/cur_screen = SCREEN_TECH
	var/datum/computer_file/research_db/loaded_research
	var/datum/techprint/selected_techprint
	var/datum/techprint/analyzing_techprint
	var/load_progress = 0
	var/load_message = STR_LOADING
	var/list/techprint_queue = list()
