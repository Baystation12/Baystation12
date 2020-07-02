
/datum/nano_module/program/experimental_analyzer/proc/load_file(var/datum/computer_file/research_db/new_file)
	cur_screen = SCREEN_WORKING
	load_message = STR_LOADING
	if(istype(new_file))
		loaded_research = new_file
	else
		loaded_research = null

	spawn(-1)
		SelectTech(null)

	spawn(-1)
		ui_RebuildTechTree()

/datum/nano_module/program/experimental_analyzer/proc/autofind_database()
	var/datum/computer_file/research_db/new_file = locate() in program.holder.stored_files
	if(new_file)
		load_file(new_file)
	else
		var/obj/host = nano_host()
		host.visible_message("\icon[host] <span class='notice'>Unable to autoload research database. Ensure one exists on the drive</span>")
		playsound(get_turf(host), 'sound/machines/buzz-two.ogg', 100, 1)

/datum/nano_module/program/experimental_analyzer/proc/finish_loading()
	var/obj/host = nano_host()
	if(loaded_research)
		host.visible_message("\icon[host] <span class='info'>Research database \
			\'user@home:~/root/[loaded_research.filename].[loaded_research.filetype]\' successfully loaded.</span>")
		playsound(get_turf(host), 'sound/machines/chime.ogg', 100, 1)
	else
		host.visible_message("\icon[host] <span class='notice'>Unable to load research database.</span>")
		playsound(get_turf(host), 'sound/machines/buzz-sigh.ogg', 100, 1)
