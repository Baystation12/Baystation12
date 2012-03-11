/datum/os/proc/FindDir(var/N)
	for(var/datum/dir/D in src.pwd.contents)
		if(D.name == N && D.type == /datum/dir)
			return D
	return 0

/datum/os/proc/FindFile(var/N)
	for(var/datum/dir/file/F in src.pwd.contents)
		if(F.name == N && F.type == /datum/dir/file)
			return F
	return 0

/datum/os/proc/FindAny(var/N)
	for(var/datum/dir/D in src.pwd.contents)
		if(D.name == N)
			return D
	return 0

/datum/os/proc/FindProg(var/N)
	for(var/datum/dir/file/program/D in src.pwd.contents)
		if(D.name == N)
			return D
	return 0

/datum/os/proc/MkDir(var/path)
	if(FindAny(path))
		src.owner << "There is already a directory/file with the same name"
		return
	var/perm = src.pwd.CheckPermissions(src)
	if(perm != RW && perm != W)
		Message("No")
		return
	var/datum/dir/D = new(path,src.pwd)
	D.holder = src.pwd
	D.owned = src.user
	src.pwd.contents += D

/datum/os/proc/Dir()
	var/count = 1
	var/text
	for(var/datum/dir/D in src.pwd.contents)
		if(count == 3)
			text += " [D.name]\n"
			count = 1
			continue
		else if(count == 1)
			text += "[D.name]"
			count++
		else
			text += " [D.name]"
			count++
	Message(text)

/datum/dir/Del()
	if(!istext(src.contents))
		for(var/A in src.contents)
			del(A)
	..()

/datum/os/proc/Mv(path1,path2)
	if(!path1 || !path2)
		Message("Missing argument")
		return
	var/datum/dir/X = FindAny(path1)
	var/datum/dir/Y = FindDir(path2)
	if(!X || !Y)
		Message("Cannot find file/dir")
		return
	X.holder.contents -= X
	X.holder = Y
	Y.contents += X
	Message("Moved [X] into [Y]")
	return

datum/os/proc/reboot()
	boot = 0
	for(var/datum/praser/P in src.process)
		del(P)
	Boot()

datum/os/proc/config(var/N,var/A)
	if(N == "name")
		src.name = A
		Message("Changed network name to [A]")

/datum/os/proc/Pwd()
	var/list/dirs = list()
	if(!connected)
		var/datum/dir/cur = pwd
		for(var/x,x<=10,x++)
			dirs += cur
			if(cur.holder)
				cur = cur.holder
			else
				break
		//var/list/dirs2 = reverselist(dirs)
		var/string
		for(var/x=dirs.len,x>0,x--)
		//	world << x
			var/datum/dir/dir2 = dirs[x]
			if(!string)
				string = "/[dir2.name]"
			else
				string = "[string]/[dir2.name]"
		Message(string)
		return
	else
		var/datum/dir/cur = src.pwd
		for(var/x,x<=10,x++)
			dirs += cur
			if(cur.holder)
				cur = cur.holder
			else
				break
		//var/list/dirs2 = reverselist(dirs)
		var/string
		for(var/x=dirs.len,x>0,x--)
			//world << x
			var/datum/dir/dir2 = dirs[x]
			if(!string)
				string = "/[dir2.name]"
			else
				string = "[string]/[dir2.name]"
		Message(string)
		return

/datum/os/proc/Run(path)
	var/N = path
	if(findtext(N,"/",1,0)) // ITS A PATH
		var/datum/dir/start
		var/done = 1
		var/list/D = list()
		if(findtext(N,"/",1,2))
			start = root
			N = copytext(N,2,0)
		else
			start = src.pwd
		while(done)
			var/loc1 = findtext(N,"/",1,0)
			if(!loc1)
				var/Y = copytext(N,1,0)
				D += Y
				done = 0
				break
			var/X = copytext(N,1,loc1)
			N = copytext(N,loc1+1,0)
			D += X
		for(var/A in D)
			src.pwd = start
			start = FindDir(A)
			if(!start)
				path = A
				break
		src.pwd = start
	var/datum/dir/file/program/P = FindProg(path)
	if(!P)
		if(FindDir(path))
			Message("[path] is a directory")
			return
		if(FindFile(path))
			Message("[path] is a text file")
			return
		Message("Cannot find file [path]")
		return
	P.Run(src)

/datum/os/proc/cd(var/N)
	if(N == ".." && src.pwd.holder)
		src.pwd = src.pwd.holder
	else if(findtext(N,"/",1,0)) // ITS A PATH
		var/datum/dir/start
		var/done = 1
		var/list/D = list()
		if(findtext(N,"/",1,2))
			start = root
			N = copytext(N,2,0)
		else
			start = src.pwd
		while(done)
			var/loc1 = findtext(N,"/",1,0)
			if(!loc1)
				var/Y = copytext(N,1,0)
				D += Y
				done = 0
				break
			var/X = copytext(N,1,loc1)
			N = copytext(N,loc1+1,0)
			D += X
		for(var/A in D)
			src.pwd = start
			start = FindDir(A)
			Message("moved into [start.name]")
		src.pwd = start
	else
		var/datum/dir/X = FindDir(N)
		if(X)
			src.pwd = X
			Message("moved into [src.pwd.name]")
			return
		else
			Message("either not a directory or it dosent exists")

/datum/os/proc/showhtml(var/datum/dir/file/F)
	if(!F)
		return
	var/perm = F.CheckPermissions(src)
	if(perm < W)
		Message("You are not authorized to do that..")
		return
	var/x = htmlpraser(F)
	Message(x)

/datum/os/proc/htmlpraser(var/datum/dir/file/F)
	var/list/lines = list()
	var/done = 0
	var/text = F.contents
	var/newtext
	while (done!=1)
		var/X = findtext(text,"\n",1,0)
		if(!X)
			done = 1
			lines += text
		//	// "DONE"
			break
		else
			var/Y = copytext(text,1,X)
			text = copytext(
			text,X+1,0)
			lines += Y
		sleep(1)
	for(var/A in lines)
		var/NA = A
		if(findtext(A,"<href=",1,0))
			var/loc = findtext(A,"=",1,0)
			if(!findtext(A,">",1,0))
				continue
			var/loc1 = findtext(A,"\"",loc,0)
			var/loc2 = findtext(A,"\"",loc1+1,0)
			var/X = copytext(A,loc1+1,loc2)
			if(findtext(A,"name="))
				var/locA = findtext(A,"name=")
				var/locB = findtext(A,"\"",locA,0)
				var/locC = findtext(A,"\"",locB+1,0)
				var/Y = copytext(A,locB+1,locC)
				NA = "<a href=?src=\ref[src];redir=[X]>[Y]</a>!"
			else
				NA = "<a href=?src=\ref[src];redir=[X]>[X]</a>!"
		newtext += NA
	return newtext

datum/os/proc/testpraser(var/N)
	var/datum/dir/file/X = FindFile(N)
	showhtml(X)

/datum/os/Topic(href,href_list[],hsrc)
	if(1)
		if(!usr)
			return
		if(href_list["redir"])
			var/datum/os/C = usr.comp
			var/datum/dir/file/X = FindFile(href_list["redir"])
			if(!X)
				return
			C.showhtml(X)

/datum/os/proc/cat(var/N)
	var/datum/dir/file/X = FindFile(N)
	if(X)
		var/perm = X.CheckPermissions(src)
		if(perm < R)
			Message("You are not authorized to do that..")
			return
		Message("Type the line to append")
		var/text = GetInput()
		text = copytext(text,1,0)
		X.contents += "\n[text]"
	else
		Message("Error no file named [N]")

/datum/os/proc/vi(var/N,mob/user)
	var/datum/dir/file/X = FindFile(N)
	if(X)
		var/perm = X.CheckPermissions(src)
		if(perm < W)
			Message("You are not authorized to do that..")
			return
		var/text = X.contents
		X.contents = input(user,"VI","VI",text) as message
	else
		if(FindDir(N))
			Message("[N] is a directory")
			return
		else if(FindProg(N))
			Message("[N] is a program")
			return
		else
			Message("File does not exist")

/datum/os/proc/read(var/N)
	var/datum/dir/file/X = FindFile(N)
	if(X)
		var/perm = X.CheckPermissions(src)
		if(perm != R && perm != RW )
			Message("You are not authorized to do that..")
			return
		Message(X.contents)
	else
		Message("Error no file named [N]")

/datum/os/proc/rm(var/B)
	var/datum/dir/current = src.pwd
	var/N = B
	if(findtext(N,"/",1,0)) // ITS A PATH
		var/datum/dir/start
		var/done = 1
		var/list/D = list()
		if(findtext(N,"/",1,2))
			start = root
			N = copytext(N,2,0)
		else
			start = src.pwd
		while(done)
			var/loc1 = findtext(N,"/",1,0)
			if(!loc1)
				var/Y = copytext(N,1,0)
				D += Y
				done = 0
				break
			var/V = copytext(N,1,loc1)
			N = copytext(N,loc1+1,0)
			D += V
		var/count = 0
		for(var/A in D)
			count++
			src.pwd = start
			if(count == D.len)
				B = A
				break
			start = FindDir(A)
		src.pwd = start
	if(B == "*")
		for(var/datum/dir/A in pwd.contents)
			var/perm = A.CheckPermissions(src)
			if(perm != RW)
				Message("You are not authorized to do that..")
				return
			Message("Deleted [A.name]..")
			del(A)
		src.pwd = current
		return
	var/datum/dir/X = FindAny(B)
	if(X)
		var/perm = X.CheckPermissions(src)
		if(perm != RW)
			Message("You are not authorized to do that..")
			return
		Message("Deleted [X.name]..")
		del(X)
		src.pwd = current
		return

/datum/os/proc/Make(var/X)
	var/datum/dir/current = src.pwd
	var/N = X
	if(findtext(N,"/",1,0)) // ITS A PATH
		var/datum/dir/start
		var/done = 1
		var/list/D = list()
		if(findtext(N,"/",1,2))
			start = root
			N = copytext(N,2,0)
		else
			start = src.pwd
		while(done)
			var/loc1 = findtext(N,"/",1,0)
			if(!loc1)
				var/Y = copytext(N,1,0)
				D += Y
				done = 0
				break
			var/V = copytext(N,1,loc1)
			N = copytext(N,loc1+1,0)
			D += V
		var/count = 0
		for(var/A in D)
			count++
			src.pwd = start
			if(count == D.len)
				X = A
				break
			start = FindDir(A)
		src.pwd = start
	if(FindAny(X))
		Message("There is already a directory/file with the same name")
		return
	var/datum/dir/file/F = new(X,src.pwd)
	src.pwd = current
	F.owned = src.user
	F.permissions[src.user.name] = RW
	F.holder.contents += F

/datum/os/proc/FTP(var/N)
	var/datum/dir/D = FindDir(N)
	if(!D)
		return
	var/datum/dir/X = new D.type ()
	for(var/A in X.vars)
		X.vars[A] = D.vars[A]
	X.holder = src.root
	X.owned = src.user
	X.permissions[src.user.name] = RW
	X.holder.contents += X

/datum/os/proc/IpConfig(var/force = 0)
	if(force && istype(device,/obj/item/weapon/laptop))
		device:updateip()
	if(connected)
		Message("IP:[ip2text(connected.ip)]")
		if(connected.hostnames.len >= 1)
			for(var/A in connected.hostnames)
				src.owner << "HOSTNAME:[A]"
	else
		Message("IP:[ip2text(src.ip)]")
		if(hostnames.len >= 1)
			for(var/A in hostnames)
				Message("HOSTNAME:[A]")

/datum/os/proc/UserAdd(N,P)
	if(!N || !P)
		return
	var/datum/user/X = new(N,P)
	if(!connected && src.user.name == "root")
		if(GetUser(N))
			del(X)
			Message("already a account named this")
			return
		src.users += X
		Message("Created [X.name]")
	else if(src.connectedas.name == "root")
		if(connected.GetUser(N))
			del(X)
			Message("already a account named this")
			return
		src.connected.users += X
		Message("Created [X.name]")
	else
		del(X)

/datum/os/proc/UserModify(N,OP,NP)
	if(!N || !OP || !NP)
		return
	if(!connected && IsRoot())
		var/datum/user/X = GetUser(N)
		if(!X)
			Message("No user by this name")
			return
		if(X.password != OP)
			return
		X.password = NP
		Message("[N] password has been changed...")

/datum/os/proc/UserRemove(N,P)
	if(!connected)
		if(N == "root")
			Message("Cannot remove root account")
			return
		for(var/datum/user/A in users)
			if(A.name == N)
				del(A)
				Message("Deleted [N]")
				return
	else if(connectedas.name == "root")
		for(var/datum/user/A in connected.users)
			if(A.name == N)
				del(A)
				Message("Deleted [N]")
				return

/datum/os/proc/ListUsers()
	if(!connected)
		if(src.user.name != "root")
			return
		for(var/datum/user/A in users)
			Message(A.name)
	else
		if(src.connectedas.name != "root")
			return
		for(var/datum/user/A in connected.users)
			Message(A.name)

/datum/os/proc/Passwd(var/A)
	if(!A)
		return
	if(!connected)
		src.user.password = A
		src.owner << "Password changed..."

datum/os/proc/Chmod(X,UN,DN)
	if(!IsRoot())
		src.owner << "You need to be root"
		return
	var/datum/dir/D = FindAny(DN)
	if(!D)
		src.owner << "Can't find a file named [DN]"
		return
	var/Y = Right2Num(X)
	D.permissions[UN] = Y
	src.owner << "[UN] has been given [X] rights to [DN]"

datum/os/proc/Right2Num(X)
	if(X == "R")
		return 1
	if(X == "W")
		return 2
	if(X == "RW")
		return 3

datum/os/proc/IsRoot()
	if(!connected)
		if(src.user.name != "root")
			return 0
		return 1
	else
		if(src.connectedas.name != "root")
			return 0
		return 1

datum/os/proc/Copy(Y)
	if(Y == "*")
		for(var/datum/dir/X in pwd.contents)
			copy += X
			src.owner << "Added [X.name] into the copy list"
		return
	var/datum/dir/X = FindAny(Y)
	if(X)
		copy += X
		src.owner << "Added [X.name] into the copy list"

datum/os/proc/Paste()
	if(copy.len <= 0)
		src.owner << "Nothing to paste.."
		return
	var/pasted = 0
	var/notpasted = 0
	var/total = copy.len
	for(var/datum/dir/A in copy)
		if(FindAny(A.name))
			Message("[A.name] already exists..")
			notpasted++
			continue
		if(A.type == /datum/dir)
			var/datum/dir/D = new(A.name,src.pwd)
			for(var/datum/dir/AX in A.contents)
				CopyFile(AX,D)
			D.permissions.Copy(A.permissions,1,0)
			src.pwd.contents += D
			pasted++
		else if(A.type == /datum/dir/file)
			var/datum/dir/file/D = new(A.name,src.pwd)
			D.contents = A.contents
			D.permissions.Copy(A.permissions,1,0)
			src.pwd.contents += D
			pasted++
		else if(istype(A,/datum/dir/file/program))
			var/datum/dir/X = new A.type (A.name,src.pwd)
			X.permissions.Copy(A.permissions,1,0)
			src.pwd.contents += X
			pasted++
	copy = list()
	Message("[pasted]/[total] were pasted, [notpasted] already existed..")

datum/os/proc/CopyFile(var/datum/dir/A,var/datum/dir/B)
	if(A)
		if(A.type == /datum/dir)
			var/datum/dir/D = new(A.name,src.pwd)
			for(var/datum/dir/AX in A.contents)
				CopyFile(AX,D)
			D.permissions.Copy(A.permissions,1,0)
			D.holder = B
			B.contents += D
		else if(A.type == /datum/dir/file)
			var/datum/dir/file/D = new(A.name,src.pwd)
			D.contents = A.contents
			D.permissions.Copy(A.permissions,1,0)
			D.holder = B
			B.contents += D
		else if(istype(A,/datum/dir/file/program))
			var/datum/dir/X = new A.type (A.name,src.pwd)
			X.permissions.Copy(A.permissions,1,0)
			X.holder = B
			B.contents += X

datum/os/proc/Connect(ip,user,pass)
	if(user && pass)
		www.ConnectTo_s(ip,src,user,pass)
	else
		www.ConnectTo(ip,src)

datum/os/proc/BG(path)
	var/datum/dir/file/program/X = FindProg(path)
	if(!X)
		Message("Cannot find file")
		return
	if(connected)
		connected.tasks += X
	else
		tasks += X
	Message("[path] is now being run in the background")

datum/os/proc/Kill(path)
	if(connected)
		for(var/datum/dir/file/program/X in connected.tasks)
			if(X.name == path)
				X.Stop(connected)
				connected.tasks -= X
				Message("Killed [path]")
				return
	else
		for(var/datum/dir/file/program/X in src.tasks)
			if(X.name == path)
				X.Stop(src)
				src.tasks -= X
				Message("Killed [path]")
				return

datum/os/proc/BGLIST()
	if(connected)
		if(connected.tasks.len <= 0)
			return
		for(var/datum/dir/file/program/X in connected.tasks)
			Message(X.name)
	else
		if(tasks.len <= 0)
			return
		for(var/datum/dir/file/program/X in src.tasks)
			src.owner << X.name

datum/os/proc/process()
	for(var/datum/dir/file/program/X in src.tasks)
		if(!X.running)
			X.Run(src)

datum/os/proc/Remote(var/address,var/command,var/list/args)
	var/datum/function/F = new
	F.name = command
	var/run = 1
	var/count = 0
	while(run)
		count++
		if(count > args.len)
			break
		var/K = args[count]
		if(findtext(K,"{",1,0))
			//world << "Found a '"
			for(var/A in args)
				if(K == A)
					continue
				if(findtext(A,"}",1,0))
					//world << "Found the other"
					var/Z = K + A
					Z = copytext(Z,1,0)
					var/x = findtext(Z,"{",1,0)
					var/y = findtext(Z,"}",x+1,0)
					K = copytext(Z,x+1,y)
					//world << "breaking"
					break
		//world << "[count]:[K]"
		switch(count)
			if(1)
				F.arg1 = K
			if(2)
				F.arg2 = K
			if(3)
				F.arg3 = K
			if(4)
				F.arg4 = K
			if(5)
				F.arg5 = K
	if(address == "localhost")
		address = ip
	else
		address = text2ip(address)
	if(address == -1)
		Message("Invalid IP supplied.")
		return
	Message(send_packet(src.device,address, F))