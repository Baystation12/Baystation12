//switch this out to use a database at some point
//list of ckey/ real_name and item paths
//gives item to specific people when they join if it can
//see config/custom_items.txt how to to add things to it (yes crazy idea i know)
//yes, it has to be an item, you can't pick up nonitems

/var/list/custom_items = list()

//parses the config file into the above listlist
/hook/startup/proc/loadCustomItems()
	var/custom_items_file = file2text("config/custom_items.txt")
	var/list/file_list = text2list(custom_items_file, "\n")
	for(var/line in file_list)
		if(findtext(line, "#", 1, 2))
			continue

		var/list/Entry = text2list(line, ":")
		for(var/i = 1 to Entry.len)
			Entry[i] = trim(Entry[i])

		if(Entry.len < 3)
			continue;

		if(!custom_items[Entry[1]])
			custom_items[Entry[1]] = list()
		custom_items[Entry[1]] += Entry

	return 1

//gets the relevant list for the key from the listlist if it exists, check to make sure they are meant to have it and then calls the giving function
/proc/EquipCustomItems(mob/living/carbon/human/M)
	var/list/key_list = custom_items[M.ckey]
	if(!key_list || key_list.len < 1)
		return

	for(var/list/Entry in key_list)
		if(Entry.len < 3)
			continue;

		if(Entry[1] != M.ckey || Entry[2] != "" || Entry[2] != M.real_name)
			continue

		//required access/job
		var/obj/item/weapon/card/id/ID = M.wear_id	//should be an id even though pdas can also be there, due to this being run at spawn, before there is a chance to change it
		if(Entry.len>=4 && length(Entry[4]) > 0)
			var/required_access = 0;
			required_access = text2num(Entry[4])

			if(!required_access)
				var/list/JobTitles = text2list(Entry[4])
				var/ok = 0
				var/CurrentTitle = M.mind.role_alt_title ? M.mind.role_alt_title : M.mind.assigned_role
				for(var/title in JobTitles)
					if(title == CurrentTitle)
						ok = 1
				if(ok == 0)
					continue

			else if(required_access != 0)
				if(!(required_access in ID.access))
					continue

		//the else looks redundant and that it should probably be not an else and just not have the if, but then if there was a name/desc/icon_state set then all the items would get the same one, and i dont want the config file to be wider than it already has to be
		if(findtext(Entry[3], ","))
			var/list/Paths = text2list(Entry[3], ",")
			for(var/P in Paths)
				//ids make the standard id be different, instead of spawning a new one (because clunky as fuck)
				if(P == "/obj/item/weapon/card/id")
					continue
				PlaceCustomItem(M, P)
		else
			var/obj/item/Item
			if(Entry[3] == "/obj/item/weapon/card/id")
				Item = ID
			else
				Item = PlaceCustomItem(M,Entry[3])
			if(!istype(Item))
				continue
			if(Entry.len < 5)
				continue
			if(Entry[5] != "")
				Item.name = Entry[5]
				if(istype(Item, /obj/item/weapon/card/id))
					Item.name += "[M.mind.role_alt_title ? M.mind.role_alt_title : M.mind.assigned_role]"
			if(Entry.len < 6)
				continue
			if(Entry[6] != "")
				Item.desc = Entry[6]

//actually sticks the item on the person
/proc/PlaceCustomItem(mob/living/carbon/human/M, var/path)
	if(!path) return

	var/obj/item/Item = new path()

	if(M.equip_to_appropriate_slot(Item))
		return Item
	if(istype(M.back,/obj/item/weapon/storage) && M.back:contents.len < M.back:storage_slots) // Try to place it in something on the mob's back
		Item.loc = M.back
		return Item
	else
		for(var/obj/item/weapon/storage/S in M.contents) // Try to place it in any item that can store stuff, on the mob.
			if (S.contents.len < S.storage_slots)
				Item.loc = S
				return Item
		Item.loc = get_turf(M.loc)
		return Item