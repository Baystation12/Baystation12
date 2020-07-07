
//a dual purpose proc to handle load and merge
//sorry i know its confusing but its a nice bit of optimisation
/datum/nano_module/program/experimental_analyzer/proc/browse_file(var/mob/user, var/do_merge = FALSE)
	var/list/options = list()
	for(var/datum/computer_file/C in program.holder.stored_files)
		options["[C.filename].[C.filetype]"] = C

	var/choice_name = input("Please choose which file to [do_merge ? "merge" : "load"]","[do_merge ? "Merge" : "Load"] File")\
		as null|anything in options
	if(choice_name)
		var/datum/computer_file/choice = options[choice_name]

		if(choice != loaded_research)
			if(choice.filetype == "RDB")
				if(do_merge)
					merge_file(choice)
				else
					load_file(choice)
			else
				var/obj/host = nano_host()
				playsound(get_turf(host), 'sound/machines/buzz-sigh.ogg', 100, 1)
				spawn(-1)	alert("Unable to [do_merge ? "merge" : "load"] file \'[choice_name].[choice.filetype]\': \
					invalid file type.","Wrong Filetype")
		else
			var/obj/host = nano_host()
			playsound(get_turf(host), 'sound/machines/buzz-sigh.ogg', 100, 1)
			spawn(-1)	alert("Unable to [do_merge ? "merge" : "load"] file with itself.","Invalid target")
