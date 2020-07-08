
/datum/nano_module/program/experimental_analyzer/proc/unload_file(var/mob/user, var/do_wipe = 0)

	if(do_wipe && alert("You are about to wipe the loaded database from RAM. This action is non-recoverable.",\
		"Warning","I understand the risks","Get me out of here!") != "I understand the risks")
		return

	cur_screen = SCREEN_WORKING
	loaded_research = null

	if(do_wipe)
		load_message = STR_WIPING
	else
		load_message = STR_UNLOADING

	spawn(-1)
		SelectTech(null)

	spawn(-1)
		ui_RebuildTechTree()

/datum/nano_module/program/experimental_analyzer/proc/finish_wiping()
	var/obj/host = nano_host()
	host.visible_message("\icon[host] <span class='info'>Research database successfully wiped.</span>")
	playsound(get_turf(host), 'sound/machines/chime.ogg', 100, 1)
