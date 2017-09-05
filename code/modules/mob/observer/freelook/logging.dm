/datum/chunk/proc/log_visualnet(var/message, var/datum/source)
	visualnet.log_visualnet("[src] ([x]-[y]-[z]) - [message]", source)

/datum/visualnet/proc/log_visualnet(var/message, var/datum/source)
	log_debug("[src] - [message]: [istype(source) ? "[source] ([source.type])" : (source ? source : "NULL") ]")
