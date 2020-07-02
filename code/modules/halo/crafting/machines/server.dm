
/obj/machinery/research/server
	name = "research server"
	icon_state = "server"
	var/datum/computer_file/research_db/loaded_db

/obj/machinery/research/server/New()
	. = ..()
	loaded_db = new(TRUE)
