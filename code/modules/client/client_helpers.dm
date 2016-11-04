/datum/proc/get_client()
	return null

/client/get_client()
	return src

/mob/get_client()
	return client

/mob/observer/eye/get_client()
	. = client || (owner && owner.get_client())

/mob/observer/virtual/get_client()
	return host.get_client()
