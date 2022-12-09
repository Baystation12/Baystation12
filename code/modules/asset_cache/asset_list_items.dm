/datum/asset/nanoui
	var/list/common = list()

	var/list/common_dirs = list(
		"nano/css/",
		"nano/images/",
		"nano/images/status_icons/",
		"nano/images/modular_computers/",
		"nano/js/"
	)
	var/list/uncommon_dirs = list(
		"nano/templates/"
	)

/datum/asset/nanoui/register()
	// Crawl the directories to find files.
	for (var/path in common_dirs)
		var/list/filenames = flist(path)
		for(var/filename in filenames)
			if(copytext(filename, length(filename)) != "/") // Ignore directories.
				if(fexists(path + filename))
					common[filename] = fcopy_rsc(path + filename)
					register_asset(filename, common[filename])

	for (var/path in uncommon_dirs)
		var/list/filenames = flist(path)
		for(var/filename in filenames)
			if(copytext(filename, length(filename)) != "/") // Ignore directories.
				if(fexists(path + filename))
					register_asset(filename, fcopy_rsc(path + filename))

	var/list/mapnames = list()
	for(var/z in GLOB.using_map.map_levels)
		mapnames += map_image_file_name(z)

	var/list/filenames = flist(MAP_IMAGE_PATH)
	for(var/filename in filenames)
		if(copytext(filename, length(filename)) != "/") // Ignore directories.
			var/file_path = MAP_IMAGE_PATH + filename
			if((filename in mapnames) && fexists(file_path))
				common[filename] = fcopy_rsc(file_path)
				register_asset(filename, common[filename])

/datum/asset/nanoui/send(client, uncommon)
	if(!islist(uncommon))
		uncommon = list(uncommon)

	send_asset_list(client, uncommon)
	send_asset_list(client, common)




/datum/asset/group/goonchat
	children = list(
		/datum/asset/simple/jquery,
		/datum/asset/simple/goonchat,
		/datum/asset/simple/fontawesome
	)

/datum/asset/simple/jquery
	assets = list(
		"jquery.min.js"            = file("code/modules/goonchat/browserassets/js/jquery.min.js")
	)

/datum/asset/simple/goonchat
	assets = list(
		"json2.min.js"             = file("code/modules/goonchat/browserassets/js/json2.min.js"),
		"browserOutput.js"         = file("code/modules/goonchat/browserassets/js/browserOutput.js"),
		"browserOutput.css"	       = file("code/modules/goonchat/browserassets/css/browserOutput.css"),
		"browserOutput_white.css"  = file("code/modules/goonchat/browserassets/css/browserOutput_white.css")
	)

/datum/asset/simple/fontawesome
	assets = list(
		"fa-regular-400.eot"  = file("html/font-awesome/webfonts/fa-regular-400.eot"),
		"fa-regular-400.woff" = file("html/font-awesome/webfonts/fa-regular-400.woff"),
		"fa-solid-900.eot"    = file("html/font-awesome/webfonts/fa-solid-900.eot"),
		"fa-solid-900.woff"   = file("html/font-awesome/webfonts/fa-solid-900.woff"),
		"font-awesome.css"    = file("html/font-awesome/css/all.min.css"),
		"v4shim.css"          = file("html/font-awesome/css/v4-shims.min.css")
	)
