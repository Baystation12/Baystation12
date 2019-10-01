
/datum/computer_file/data/com
	filetype = "COM"
	do_not_edit = 1
	var/datum/faction/contact_faction

/datum/computer_file/data/com/proc/generate_data(var/datum/faction/F)
	filename = "comms_[(rand(1,100) * world.time) % 9999]"
	contact_faction = F

	//generate some gibberish encrypted data
	/*
	var/datalength = 0
	do
		stored_data += "[pick(pick(GLOB.greek_letters, GLOB.phonetic_alphabet, GLOB.numbers_as_words))] "
		datalength = length(stored_data)
		if(datalength < block_size)
			stored_data += " "
	while(datalength < block_size)
	*/

	original_data = stored_data

/datum/computer_file/data/com/clone()
	var/datum/computer_file/data/com/temp = ..()
	temp.contact_faction = contact_faction
	return temp
