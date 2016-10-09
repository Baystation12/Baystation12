
/client/verb/ooc(msg as text)
	set name = "OOC"
	set category = "OOC"

	sanitize_and_communicate(/decl/communication_channel/ooc, mob, msg)

/client/verb/looc(msg as text)
	set name = "LOOC"
	set desc = "Local OOC, seen only by those in view."
	set category = "OOC"

	sanitize_and_communicate(/decl/communication_channel/ooc/looc, mob, msg)
