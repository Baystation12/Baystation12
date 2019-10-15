
/datum/computer_file/data/coord
	filetype = "COORD"
	do_not_edit = 1
	var/datum/npc_quest/quest

/datum/computer_file/data/coord/proc/generate_data(var/datum/npc_quest/new_quest)
	filename = "coords_[(rand(1,100) * world.time) % 9999]"
	quest = new_quest

	//generate some gibberish encrypted data
	/*
	var/datalength = 0
	do
		stored_data += "[rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)]"
		datalength = length(stored_data)
		if(datalength < block_size)
			stored_data += "."
	while(datalength < block_size)
	*/

	original_data = stored_data

/datum/computer_file/data/coord/clone()
	var/datum/computer_file/data/coord/temp = ..()
	temp.quest = quest
	return temp
