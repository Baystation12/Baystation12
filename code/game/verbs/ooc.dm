/client/verb/ooc(message as text)
	set name = "OOC"
	set category = "OOC"

	sanitize_and_communicate(/decl/communication_channel/ooc, mob, message)

/client/verb/looc(message as text)
	set name = "LOOC"
	set desc = "Local OOC, seen only by those in view. Remember: Just because you see someone that doesn't mean they see you."
	set category = "OOC"

	mob.looc(message)

/mob/proc/looc(var/message)
	return sanitize_and_communicate(/decl/communication_channel/ooc/looc, eyeobj || src, message)
