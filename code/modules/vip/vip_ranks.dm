var/list/vip_ranks = list()								//list of all ranks with associated rights

//load our rank - > rights associations
/proc/load_vip_ranks()
	vip_ranks.Cut()


	//load text from file
	var/list/Lines = file2list("config/vip_ranks.txt")

	//process each line seperately
	for(var/line in Lines)
		if(!length(line))				continue
		if(copytext(line,1,2) == "#")	continue

		var/list/List = text2list(line,"+")
		if(!List.len)					continue

		var/rank = ckeyEx(List[1])
		switch(rank)
			if(null,"")		continue
			if("Removed")	continue				//Reserved

		var/rights = 0
		for(var/i=2, i<=List.len, i++)
			switch(ckey(List[i]))
				if("event")						rights |= V_EVENT
				if("donate")				rights |= V_DONATE


		vip_ranks[rank] = rights

	#ifdef TESTING
	var/msg = "Permission Sets Built:\n"
	for(var/rank in vip_ranks)
		msg += "\t[rank] - [vip_ranks[rank]]\n"
	testing(msg)
	#endif

/hook/startup/proc/loadvips()
	load_vips()
	return 1

/proc/load_vips()
	//clear the datums references
	vip_datums.Cut()
	for(var/client/C in vips)
		C.remove_vip_verbs()
		C.vipholder = null
	vips.Cut()

	if(config.vip_legacy_system)
		load_vip_ranks()

		//load text from file
		var/list/Lines = file2list("config/vips.txt")

		//process each line seperately
		for(var/line in Lines)
			if(!length(line))				continue
			if(copytext(line,1,2) == "#")	continue

			//Split the line at every "-"
			var/list/List = text2list(line, "-")
			if(!List.len)					continue

			//ckey is before the first "-"
			var/ckey = ckey(List[1])
			if(!ckey)						continue

			//rank follows the first "-"
			var/rank = ""
			if(List.len >= 2)
				rank = ckeyEx(List[2])

			//load permissions associated with this rank
			var/rights = vip_ranks[rank]

			//create the vip datum and store it for later use
			var/datum/vips/D = new /datum/vips(rank, rights, ckey)

			//find the client for a ckey if they are connected and associate them with the new vip datum
			D.associate(directory[ckey])

	else
		//The current vip system uses SQL

		//establish_db_connection()
		//if(!dbcon.IsConnected())
		world.log << "Failed to connect to database in load_vips(). Reverting to legacy system."
		diary << "Failed to connect to database in load_vips(). Reverting to legacy system."
		config.vip_legacy_system = 1
		load_vips()
		return

		//var/DBQuery/query = dbcon.NewQuery("SELECT ckey, rank, level, flags FROM erro_vip")
		//query.Execute()
	//	while(query.NextRow())
		//	var/ckey = query.item[1]
		//	var/rank = query.item[2]
		//	if(rank == "Removed")	continue	//This person was de-vip-ed. They are only in the vip list for archive purposes.

		//	var/rights = query.item[4]
		//	if(istext(rights))	rights = text2num(rights)
		//	var/datum/vips/D = new /datum/vips(rank, rights, ckey)

			//find the client for a ckey if they are connected and associate them with the new vip datum
		//	D.associate(directory[ckey])
		//if(!vip_datums)
		//	world.log << "The database query in load_vips() resulted in no vips being added to the list. Reverting to legacy system."
		//	diary << "The database query in load_vips() resulted in no vips being added to the list. Reverting to legacy system."
		//	config.vip_legacy_system = 1
		//	load_vips()
		//	return

	#ifdef TESTING
	var/msg = "Vips Built:\n"
	for(var/ckey in vip_datums)
		var/rank
		var/datum/vips/D = vip_datums[ckey]
		if(D)	rank = D.rank
		msg += "\t[ckey] - [rank]\n"
	testing(msg)
	#endif


#ifdef TESTING
/client/verb/vipchangerank(newrank in vip_ranks)
	if(vipholder)
		vipholder.rank = newrank
		vipholder.rights = vip_ranks[newrank]
	else
		vipholder = new /datum/vips(newrank,vip_ranks[newrank],ckey)
	remove_vip_verbs()
	vipholder.associate(src)

/client/verb/vipchangerights(newrights as num)
	if(vipholder)
		vipholder.rights = newrights
	else
		vipholder = new /datum/vips("testing",newrights,ckey)
	remove_vip_verbs()
	vipholder.associate(src)

#endif
