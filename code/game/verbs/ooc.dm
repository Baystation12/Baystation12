/client/verb/ooc(message as text)
	set name = "OOC"
	set category = "OOC"

	sanitize_and_communicate(/decl/communication_channel/ooc, src, message)

	if(src.mob)
		if(jobban_isbanned(src.mob, "OOC"))
			src << "<span class='danger'>You have been banned from OOC.</span>"
			return

/client/verb/looc(message as text)
	set name = "LOOC"
	set desc = "Local OOC, seen only by those in view. Remember: Just because you see someone that doesn't mean they see you."
	set category = "OOC"

	if(jobban_isbanned(src.mob, "LOOC"))
		src << "<span class='danger'>You have been banned from LOOC.</span>"
		return

	sanitize_and_communicate(/decl/communication_channel/ooc/looc, src, message)

/client/verb/bot_token(token as text)
	set name = "Bot token"
	set category = "OOC"
	set desc = "Sends specific token to bot through webhook"

	webhook_send_token(key, token)

/client/verb/stop_all_sounds()
	set name = "Stop all sounds"
	set desc = "Stop all sounds that are currently playing."
	set category = "OOC"

	if(!mob)
		return

	mob << sound(null)