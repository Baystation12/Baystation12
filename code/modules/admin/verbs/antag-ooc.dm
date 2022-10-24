/client/proc/aooc(msg as text)
	set category = "OOC"
	set name = "AOOC"
	set desc = "Antagonist OOC"

	sanitize_and_communicate(/singleton/communication_channel/aooc, src, msg)
