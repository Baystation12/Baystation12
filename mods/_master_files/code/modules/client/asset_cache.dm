/datum/asset/nanoui
	var/list/mod_dirs = list(
		"nano/templates/mods/"
	)

/datum/asset/nanoui/register()
	. = ..()
	for (var/path as anything in mod_dirs)
		var/list/filenames = flist(path)
		for(var/filename as anything in filenames)
			if(copytext(filename, -1) != "/") // Ignore directories.
				if(fexists(path + filename))
					register_asset("mods-[filename]", fcopy_rsc(path + filename))
