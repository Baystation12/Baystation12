var/list/veteran_list = list()

var/global/list/veteran_tiers = list(
	"Veteran",
	)


proc/load_veterans()
	var/text = file2text("data/lists/veterans.txt")
	if (!text)
		diary << "Failed to load data/lists/veterans.txt\n"
	else
		veteran_list = text2list(text, "\n")
		diary << "Vet list activated\n"

/proc/is_veteran(client/C)
	if(!veteran_list)
		return 0
	if(C)
		for(var/s in veteran_list)
			if(s && findtext(s,"[C]"))
				if(C == C.ckey)
					return 1
				return 1

/proc/return_veteran_ckey(client/C)
	if(is_veteran(C))
		return C

/proc/get_vet_tier(client/C)
	if(!veteran_list)
		return 0
	if(C)
		for(var/s in veteran_list)
			if(s)
				if(findtext(s,"[C.ckey] - Veteran"))
					return 1
//			else
//				return 0

/client/verb/CheckVeteran()
	set name = "Check Veteran"
	set desc = "Checks your veteran status."
	set category = "OOC"

	if(is_veteran(src))
		src << "\blue You are a veteran."
		src << "\blue Your veteran tier is [get_don_tier(src)]"
	else
		src << "\blue You are not a veteran."