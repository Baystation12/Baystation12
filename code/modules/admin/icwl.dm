//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

var/icwl_keylist[]		//to store the keys & ranks


/hook/startup/proc/loadICWL()
	icwl_loadWhitelist()
	return 1

/proc/icwl_saveWhitelist()
	for(var/p in icwl_keylist)
		if(!p)
			icwl_remove(p)
	fdel("data/icwl.list")
	text2file(list2text(icwl_keylist, "\n"), "data/icwl.list")

/proc/icwl_loadWhitelist()
	icwl_keylist = file2list("data/icwl.list")
	if (!length(icwl_keylist))
		icwl_keylist=list()

/proc/icwl_addList(ckey)
	if (!ckey) return
	icwl_keylist.Add(ckey)
	icwl_saveWhitelist()

/proc/icwl_remList(ckey)
	if (!ckey) return
	icwl_remove(ckey)
	icwl_saveWhitelist()

/proc/icwl_remove(X)
	for (var/i = 1; i <= length(icwl_keylist); i++)
		if( findtext(icwl_keylist[i], "[X]") )
			icwl_keylist.Remove(icwl_keylist[i])
			icwl_saveWhitelist()
			return 1
	return 0

/proc/icwl_isWhitelisted(ckey)
	if(ckey)
		for (var/s in icwl_keylist)
			if(findtext(s, ckey) == 1)
				return 1
	return 0

/proc/icwl_ageCheck(job, age)
	var/minage = 99
	// These checks are per department
	if(job in civilian_positions)
		minage = 18
	if(job in engineering_positions)
		minage = 21
	if(job in security_positions)
		minage = 21
	if(job in medical_positions)
		minage = 25
	if(job in science_positions)
		minage = 25
	if(job in command_positions)
		minage = 30
	if(job in nonhuman_positions) // AI and Cyborg
		minage = 18

	// These checks are for specific jobs and will override the department limit
	switch(job)
		// DO NOT REMOVE - This is a failsafe to ensure everyone gets a job
		if("Assistant")
			minage = 0
		if("Medical Doctor")
			minage = 18
		if("Internal Affairs Agent")
			minage = 25

	if(age >= minage)
		return 1
	return 0

/proc/icwl_raceCheck(job, species)
	if(job in command_positions)
		if(species != "Human")
			return 0
	return 1


/proc/icwl_canHaveJob(var/mob/M, job)
	if(icwl_isWhitelisted(M.client.ckey) || check_rights(R_MOD) || check_rights(R_ADMIN))
		return 1
	if(icwl_raceCheck(job, M.client.prefs.species) && icwl_ageCheck(job, M.client.prefs.age))
		return 1
	return 0