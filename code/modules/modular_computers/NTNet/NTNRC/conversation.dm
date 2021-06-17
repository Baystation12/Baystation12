var/global/ntnrc_uid = 0

/datum/ntnet_conversation/
	var/id = null
	var/title = "Untitled Conversation"
	var/datum/computer_file/program/chatclient/operator // "Administrator" of this channel. Creator starts as channel's operator,
	var/list/messages = list()
	var/list/clients = list()
	var/password
	var/source_z

/datum/ntnet_conversation/New(var/_z)
	source_z = _z
	id = ntnrc_uid
	ntnrc_uid++
	if(ntnet_global)
		ntnet_global.chat_channels.Add(src)
	..()

/datum/ntnet_conversation/proc/add_message(var/message, var/username)
	message = "[stationtime2text()] [username]: [message]"
	messages.Add(message)
	trim_message_list()

/datum/ntnet_conversation/proc/add_status_message(var/message)
	messages.Add("[stationtime2text()] -!- [message]")
	trim_message_list()

/datum/ntnet_conversation/proc/trim_message_list()
	if(messages.len <= 50)
		return
	messages.Cut(1, (messages.len-49))

/datum/ntnet_conversation/proc/add_client(var/datum/computer_file/program/chatclient/C)
	if(!istype(C))
		return
	clients.Add(C)
	add_status_message("[C.username] has joined the channel.")
	// No operator, so we assume the channel was empty. Assign this user as operator.
	if(!operator)
		changeop(C)

/datum/ntnet_conversation/proc/remove_client(var/datum/computer_file/program/chatclient/C)
	if(!istype(C) || !(C in clients))
		return
	clients.Remove(C)
	add_status_message("[C.username] has left the channel.")

	// Channel operator left, pick new operator
	if(C == operator)
		operator = null
		if(clients.len)
			var/datum/computer_file/program/chatclient/newop = pick(clients)
			changeop(newop)


/datum/ntnet_conversation/proc/changeop(var/datum/computer_file/program/chatclient/newop)
	if(istype(newop))
		operator = newop
		add_status_message("Channel operator status transferred to [newop.username].")

/datum/ntnet_conversation/proc/change_title(var/newtitle, var/datum/computer_file/program/chatclient/client)
	if(operator != client)
		return 0 // Not Authorised

	add_status_message("[client.username] has changed channel title from [title] to [newtitle]")
	title = newtitle