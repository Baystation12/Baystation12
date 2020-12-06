#define MEMOFILE "data/memo.sav"	//where the memos are saved
#define ENABLE_MEMOS 1				//using a define because screw making a config variable for it. This is more efficient and purty.

//switch verb so we don't spam up the verb lists with like, 3 verbs for this feature.
/client/proc/admin_memo(task in list("write","show","delete"))
	set name = "Memo"
	set category = "Server"
#if ENABLE_MEMOS == 1
	if(!check_rights(0))	return
	switch(task)
		if("write")		admin_memo_write()
		if("show")		admin_memo_show()
		if("delete")	admin_memo_delete()
#endif

//write a message
/client/proc/admin_memo_write()
	var/savefile/F = new(MEMOFILE)
	if(F)
		var/memo = sanitize(input(src,"Type your memo\n(Leaving it blank will delete your current memo):","Write Memo",null) as null|message, extra = 0)
		switch(memo)
			if(null)
				return
			if("")
				F.dir.Remove(ckey)
				to_chat(src, "<b>Memo removed</b>")
				return
		if( findtext(memo,"<script",1,0) )
			return
		to_save(F[ckey], "[key] on [time2text(world.realtime,"(DDD) DD MMM hh:mm")]<br>[memo]")
		message_admins("[key] set an admin memo:<br>[memo]")

//show all memos
/client/proc/admin_memo_show()
#if ENABLE_MEMOS == 1
	var/savefile/F = new(MEMOFILE)
	if(F)
		for(var/ckey in F.dir)
			to_chat(src, "<center><span class='motd'><b>Admin Memo</b><i> by [F[ckey]]</i></span></center>")
#endif

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
			to_chat(src, "<b>Removed Memo created by [ckey].</b>")

#undef MEMOFILE
#undef ENABLE_MEMOS