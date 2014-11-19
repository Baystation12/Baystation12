#define MEMOFILE "data/memo.sav"	//where the memos are saved
#define ENABLE_MEMOS 1				//using a define because screw making a config variable for it. This is more efficient and purty.
#define VIPMEMOFILE "data/vipmemo.sav"
//switch verb so we don't spam up the verb lists with like, 3 verbs for this feature.
/client/proc/admin_memo(task in list("write","show","delete"))
	set name = "Memo"
	set category = "Server"
	if(!ENABLE_MEMOS)		return
	if(!check_rights(0))	return
	switch(task)
		if("write")		admin_memo_write()
		if("show")		admin_memo_show()
		if("delete")	admin_memo_delete()

//write a message
/client/proc/admin_memo_write()
	var/savefile/F = new(MEMOFILE)
	if(F)
		var/memo = input(src,"Type your memo\n(Leaving it blank will delete your current memo):","Write Memo",null) as null|message
		switch(memo)
			if(null)
				return
			if("")
				F.dir.Remove(ckey)
				src << "<b>Memo removed</b>"
				return
		if( findtext(memo,"<script",1,0) )
			return
		F[ckey] << "[key] on [time2text(world.realtime,"(DDD) DD MMM hh:mm")]<br>[memo]"
		message_admins("[key] set an admin memo:<br>[memo]")

//show all memos
/client/proc/admin_memo_show()
	if(ENABLE_MEMOS)
		var/savefile/F = new(MEMOFILE)
		if(F)
			for(var/ckey in F.dir)
				src << "<center><span class='motd'><b>Admin Memo</b><i> by [F[ckey]]</i></span></center>"

//delete your own or somebody else's memo
/client/proc/admin_memo_delete()
	var/savefile/F = new(MEMOFILE)
	if(F)
		var/ckey
		if(check_rights(R_SERVER,0))	//high ranking admins can delete other admin's memos
			ckey = input(src,"Whose memo shall we remove?","Remove Memo",null) as null|anything in F.dir
		else
			ckey = src.ckey
		if(ckey)
			F.dir.Remove(ckey)
			src << "<b>Removed Memo created by [ckey].</b>"



////////
//VIP///
////////



//switch verb so we don't spam up the verb lists with like, 3 verbs for this feature.
/client/proc/vip_memo(task in list("write","show","delete"))
	set name = "Event Memo"
	set category = "Server"
	if(!ENABLE_MEMOS)		return
	if(!check_rights(0))	return
	switch(task)
		if("write")		vip_memo_write()
		if("show")		vip_memo_show()
		if("delete")	vip_memo_delete()

//write a message
/client/proc/vip_memo_write()
	var/savefile/F = new(VIPMEMOFILE)
	if(F)
		var/memo = input(src,"Type your memo\n(Leaving it blank will delete your current memo):","Write Memo",null) as null|message
		switch(memo)
			if(null)
				return
			if("")
				F.dir.Remove(ckey)
				src << "<b>Memo removed</b>"
				return
		if( findtext(memo,"<script",1,0) )
			return
		F[ckey] << "[key] on [time2text(world.realtime,"(DDD) DD MMM hh:mm")]<br>[memo]"
		message_admins("[key] set an event memo:<br>[memo]")

//show all memos
/client/proc/vip_memo_show()
	if(ENABLE_MEMOS)
		var/savefile/F = new(VIPMEMOFILE)
		if(F)
			for(var/ckey in F.dir)
				src << "<center><span class='motd'><b>Event Memo</b><i> by [F[ckey]]</i></span></center>"

//delete your own or somebody else's memo
/client/proc/vip_memo_delete()
	var/savefile/F = new(VIPMEMOFILE)
	if(F)
		var/ckey
		if(check_rights(R_SERVER,0))	//high ranking admins can delete other admin's memos
			ckey = input(src,"Whose memo shall we remove?","Remove Memo",null) as null|anything in F.dir
		else
			ckey = src.ckey
		if(ckey)
			F.dir.Remove(ckey)
			src << "<b>Removed Memo created by [ckey].</b>"

#undef VIPMEMOFILE
#undef MEMOFILE
#undef ENABLE_MEMOS