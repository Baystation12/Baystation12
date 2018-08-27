/client/verb/ooc(message as text)
	set name = "OOC"
	set category = "OOC"

	sanitize_and_communicate(/decl/communication_channel/ooc, src, message)

/client/verb/help_verb(message as text)
	set name = "HelpSay"
	set desc = "Local assistance channel, seen only by those in view and staff online."
	set category = "OOC"

	sanitize_and_communicate(/decl/communication_channel/ooc/help, src, message)
