datum/dir
	var/name = "dir"
	var/datum/dir/holder
	var/list/contents = list()
	var/list/permissions = list()
	var/datum/user/owned
	var/path

datum/dir/file
	name = "file"
	contents = ""

datum/dir/New(namez,var/datum/dir/H)
	src.name = namez
	src.permissions["root"] = RW
	if(H)
		src.holder = H
		makepath()

datum/dir/proc/makepath()
	var/done = 1
	var/paths = ""
	var/datum/dir/D = src.holder
	if(D.name)
		var/list/x = list()
		if(D.name != "root")
			x += D.name
		while(done)
			if(!D.holder)
				done = 0
				break
			if(!D.name == "root")
				x += D.name
			D = D.holder
		for(var/A in x)
			paths += "/[A]"
		paths += "/[src.name]"
	else
		paths = "/[src.name]"
	src.path = paths
	// << paths



//OS//

datum/os
	var/getnextpacket = 0

datum/os/proc/GetPacket()
	while(getnextpacket)
		if(latepacket)
			var/datum/packet/P = src.latepacket
			latepacket = null
			return P
		else
			sleep(10)

//datum/os/proc/SendPacket(

/*
datum/dir/file/program
	name = "program"
	var/progname = "test" // not really needed
datum/dir/file/program/New(namez)
	src.name = namez // This is the file name
datum/dir/file/program/proc/Run(var/datum/os/client) // this is runned when run is called on it duh..
	return 1
datum/dir/file/program/proc/ForwardPacket(var/datum/packet/P) // when the client recieves a package program needs to be in the clients task list
	return 0


//////////Client//////////////
client.owner == player
client.pwd == current dir
client.GetInput() // returns a string typed in by the user.
FindAny(Name) = Find any files in PWD
FindProg(Name) etc
FindDir(Name)  etc
FindFile(Name) etc //textfiles cannot be runned
//////////////////////////////////

Sending packets
		new /datum/packet(TAG(INFO VAR),TOO,FROM,LIST)
Packets variables
P.info == The tag eg "PING" // Note always lowercase
P.from == sent from ip
P.where == destination ip
P.extrainfo = a list
*/

datum/os/proc/Compile(path)
	var/datum/dir/file/F = FindFile(path)
	if(!F)
		Message("Cannot find [path]")
		return
	var/datum/dir/file/program/P = new(path,src.pwd)
	P.is_script = 1
	P.script = F.contents
	P.holder = src.pwd
	src.pwd.contents += P
	del(F)
	Message("[path] has been compiled..")