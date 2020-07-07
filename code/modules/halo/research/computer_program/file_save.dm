
//a dual purpose proc to handle database duplication and new database creation
//sorry i know its confusing but its a nice bit of optimisation
/datum/nano_module/program/experimental_analyzer/proc/save_file_as(var/mob/user, var/empty_file = FALSE)
	var/newname = input("Please enter the filename","[empty_file ? "Create" : "Save"] new file as...") as null|text
	if(newname)
		var/existing = program.holder.find_file_by_name(newname)
		if(existing)
			//dont overwrite existing files
			var/obj/host = nano_host()
			playsound(get_turf(host), 'sound/machines/buzz-sigh.ogg', 100, 1)
			spawn(-1)	alert("Unable to [empty_file ? "create" : "save"] file: \
				existing file with the same name already exists.","File conflict")
		else
			//create the new file
			var/datum/computer_file/F
			if(empty_file)
				F = new/datum/computer_file/research_db(TRUE)
			else
				F = loaded_research.clone()
			F.filename = newname

			//attempt to save it on the hard drive
			var/obj/host = nano_host()
			if(program.holder.store_file(F))
				//success
				loaded_research = F
				ui_RebuildTechTree()
				playsound(get_turf(host), 'sound/machines/chime.ogg', 100, 1)
				host.visible_message("\icon[host] <span class='info'>New research database \
					\'[F.filename].[F.filetype]\' successfully [empty_file ? "created" : "saved"] at \
						user@home:~/root/.</span>")
			else
				//failure
				playsound(get_turf(host), 'sound/machines/buzz-sigh.ogg', 100, 1)
				spawn(-1)	alert("Unable to save file to user@home:~/root/: operating system returned error code 0.\
					Check there is enough room on your hard drive ([F.size]GQ needed).","[empty_file ? "Create" : "Save"] fail")
				qdel(F)
