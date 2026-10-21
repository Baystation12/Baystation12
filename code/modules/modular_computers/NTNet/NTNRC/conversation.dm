var/global/ntnrc_uid = 0

/datum/ntnet_conversation
	var/id = null
	var/title = "Untitled Conversation"
	var/datum/computer_file/program/chatclient/operator // "Administrator" of this channel. Creator starts as channel's operator,
	var/list/messages = list()
	var/message_count = 0
	var/list/clients = list()
	var/password
	var/source_z

/datum/ntnet_conversation/New(_z)
	source_z = _z
	id = ntnrc_uid
	ntnrc_uid++
	if(ntnet_global)
		ntnet_global.chat_channels.Add(src)
	..()

/datum/ntnet_conversation/Destroy()
	if(ntnet_global)
		ntnet_global.chat_channels -= src
	for(var/datum/computer_file/program/chatclient/C as anything in clients)
		C.forget_conversation(src)
	clients.Cut()
	operator = null
	return ..()

// [10:59] <User> Hello there
/datum/ntnet_conversation/proc/add_message(message, username)
	message = "\[[stationtime2text()]\] &lt;[username]&gt; [message]"
	messages.Add(message)
	message_count++
	trim_message_list()

// [10:55] -!- User has joined the channel.
/datum/ntnet_conversation/proc/add_status_message(message)
	messages.Add("\[[stationtime2text()]\] -!- [message]")
	message_count++
	trim_message_list()

/datum/ntnet_conversation/proc/trim_message_list()
	if(length(messages) <= 50)
		return
	messages.Cut(1, (length(messages)-49))

/datum/ntnet_conversation/proc/add_client(datum/computer_file/program/chatclient/C)
	if(!istype(C))
		return
	clients.Add(C)
	add_status_message("[C.username] has joined the channel.")
	// No operator, so we assume the channel was empty. Assign this user as operator.
	if(!operator)
		changeop(C)

/datum/ntnet_conversation/proc/remove_client(datum/computer_file/program/chatclient/C)
	if(!istype(C) || !(C in clients))
		return
	clients.Remove(C)
	add_status_message("[C.username] has left the channel.")

	// Channel operator left, pick new operator
	if(C == operator)
		operator = null
		if(length(clients))
			var/datum/computer_file/program/chatclient/newop = pick(clients)
			changeop(newop)


/datum/ntnet_conversation/proc/changeop(datum/computer_file/program/chatclient/newop)
	if(istype(newop))
		operator = newop
		add_status_message("Channel operator status transferred to [newop.username].")

/datum/ntnet_conversation/proc/change_title(newtitle, datum/computer_file/program/chatclient/client)
	if(operator != client)
		return 0 // Not Authorised

	add_status_message("[client.username] has changed channel title from [title] to [newtitle]")
	title = newtitle

/proc/ntnrc_channel_name(name)
	var/static/regex/valid = regex(@"^#?([A-Za-z0-9_-]{1,49})$")
	if(valid.Find(trimtext(name)))
		return "#[valid.group[1]]"

/proc/ntnrc_find_channel(name, z)
	var/list/connected_zs = GetConnectedZlevels(z)
	for(var/datum/ntnet_conversation/channel as anything in ntnet_global.chat_channels)
		if(cmptext(channel.title, name) && (channel.source_z in connected_zs))
			return channel
