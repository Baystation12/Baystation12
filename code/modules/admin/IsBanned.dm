//Blocks an attempt to connect before even creating our client datum thing.
world/IsBanned(key,address,computer_id)
	//Guest Checking
	if(!config.guests_allowed && IsGuestKey(key))
		log_access("Failed Login: [key] - Guests not allowed")
		message_admins("<span class='notice'>Failed Login: [key] - Guests not allowed</span>")
		return list("reason"="guest", "desc"="\nReason: Guests not allowed. Please sign in with a byond account.")

	var/ckeytext = ckey(key)

	var/list/ban = SSdatabase.db.BannedForScope("server", ckeytext, address, computer_id)
	if (ban && ban.len > 0)
		var/expires = ""
		if(ban["expires"])
			expires = " The ban expires on [ban["expires"]] (server time)."

		var/desc = "\nReason: You, or another user of this computer or connection ([key]) is banned from playing here. The ban reason is:\n[ban["reason"]]\nThis ban was applied by [ban["admin"]].[expires]"

		return list("reason"="banned", "desc"=desc)

	return ..()	//default pager ban stuff
