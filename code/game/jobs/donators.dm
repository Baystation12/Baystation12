var/list/donator_list = list()

var/global/list/donator_tiers = list(
	"Tier 1",
	"Tier 2",
	"Tier 3",
	"Tier 4"
	)


proc/load_donators()
	var/text = file2text("data/lists/donators.txt")
	if (!text)
		diary << "Failed to load data/lists/donators.txt\n"
	else
		donator_list = text2list(text, "\n")
		diary << "Don list activated\n"

/proc/is_donator(client/C)
	if(!donator_list)
		return 0
	if(C)
		for(var/s in donator_list)
			if(s && findtext(s,"[C]"))
				if(C == C.ckey)
					return 1
				return 1

/proc/return_donator_ckey(client/C)
	if(is_donator(C))
		return C

/proc/get_don_tier(client/C)
	if(!donator_list)
		return 0
	if(C)
		for(var/s in donator_list)
			if(s)
				if(findtext(s,"[C.ckey] - Tier 1"))
					return 1
				else if(findtext(s,"[C.ckey] - Tier 2"))
					return 2
				else if(findtext(s,"[C.ckey] - Tier 3"))
					return 3
				else if(findtext(s,"[C.ckey] - Tier 4"))
					return 4
//			else
//				return 0

/client/verb/CheckDonator()
	set name = "Check Donator"
	set desc = "Checks your donator status."
	set category = "OOC"

	if(is_donator(src))
		src << "\blue You are a donator."
		src << "\blue Your donator tier is [get_don_tier(src)]"
	else
		src << "\blue You are not a donator."

/client/verb/cmd_don_say(msg as text)
	set category = "OOC"
	set name = "Donsay"
	set hidden = 1

	if(!msg)
		return

	if(!is_donator(src))
		if(!check_rights(R_ADMIN|R_MOD))
			usr << "Only donators and staff can use this command."
			return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)

	log_admin("DON: [key_name(src)] : [msg]")
	msg = "<span class='donatornobold'><span class='prefix'>DON:</span> [src]: <span class='message'>[msg]</span></span>"
	for(var/client/C in clients)
		if((C.holder && (C.holder.rights & R_ADMIN || C.holder.rights & R_MOD)) || is_donator(C))
			C << msg
