/client/verb/ooc(message as text)
	set name = "OOC"
	set category = "OOC"

	sanitize_and_communicate(/decl/communication_channel/ooc, src, message)

/client/verb/looc(message as text)
	set name = "LOOC"
	set desc = "Local OOC, seen only by those in view. Remember: Just because you see someone that doesn't mean they see you."
	set category = "OOC"

	sanitize_and_communicate(/decl/communication_channel/ooc/looc, src, message)

/client/verb/bot_token(token as text)
	set name = "Bot token"
	set category = "OOC"
	set desc = "Sends specific token to bot through webhook"

	webhook_send_token(key, token)