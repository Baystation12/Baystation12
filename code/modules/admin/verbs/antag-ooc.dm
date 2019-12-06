/client/proc/aooc(msg as text)
	set category = "OOC"
	set name = "AOOC"
	set desc = "Antagonist OOC"

	sanitize_and_communicate(/decl/communication_channel/aooc, src, msg)