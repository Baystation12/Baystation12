var/global/const/R = 1
var/global/const/W = 2
var/global/const/RW = 3

mob
	var/datum/os/comp
	var/obj/console_device

mob/verb/cmd(msg as text)
	set hidden = 1
	if(!(src.console_device in view(src,1)) && !(src.console_device in src))
		src.hide_console()
		return
	src.comp.command(msg,src)

/datum/os/
	var/name = "ThinkThank"
	var/datum/dir/pwd
	var/datum/dir/root = new("root")
	var/datum/dir/dldir
	var/datum/os/connected
	var/list/users = list()
	var/stopprog = 0
//	var/motd = "Welcome to the server"
	var/list/owner = list()
	var/cmdoverride = 0
	var/input = null
	var/network = 0
	var/list/clients = list()
	var/list/copy = list()
	var/auth = 1
	var/boot = 0
	var/obj/device // device that this OS runs on
	var/ip = null
	var/list/packets = list()
	var/list/process = list()
	var/datum/packet/latepacket
	var/datum/user/connectedas
	var/list/hostnames = list()
	var/datum/user/user = new("root","password")
	var/list/tasks = list()
	var/list/config = list("webserver" = 0,motd = "Welcome to the server")
	var/helptext = {"
	Commands:
	mkdir,Create directories,mkdir dirname
	dir,display current dir conents
	cd,move into a directiory,cd filename
	pwd,show current directory"
	make,make a file,make filename"
	cat,add to a file,cat filename"
	read,read a file ,read filename"
	rm,delete file/dir,rm dir/filename
	mv,move file/dir,mv file where
	connect,connect to a server,connect ip
	disconnect,disconnect...
	run,run a program
	prase,prase a program
	chmod RW username file/dirname
	user list
	user add name pass
	user remove name
	user modify name old password new password
	passwd, change your password, passwd newpass
	Copy,Adds a file into the copy buffer
	Paste,Pastes all the files in the copy buffer and clears it
	vi, Text editor , vi filename
	"}

/datum/os/Del()
	for(var/datum/praser/P in process)
		del(P)
	for(var/mob/A in owner)
		owner -= A
	..()

/datum/os/New(var/obj/OBJ)
	pwd = root
	var/datum/dir/X = new("downloads",src.pwd)
//	var/datum/dir/file/program/test/T = new("testapp",src.pwd)
//	pwd.contents += T
//	T.holder = pwd
//	T.owned = user
//	T.permissions[user.name] = RW
	pwd.contents += X
	X.holder = pwd
	dldir = X
	users += user
	X.permissions[user.name] = RW
	root.permissions[user.name] = RW
	X.owned = user
	src.device = OBJ
	ASSERT(istype(src.device))

/datum/os/proc/GetInput()
	set background=1
	src.cmdoverride = 1
	while(!src.input)
		sleep(1)
	var/xy = src.input
	src.input = null
	src.cmdoverride = 0
	return xy

/datum/os/proc/receive_message(message)
	Message(message)

/datum/dir/proc/CheckPermissions(var/datum/os/client)
	if(!client.connected)
		var/Y = src.permissions[client.user.name]
		if(!Y)
			return 0
		else
			return Y
	else
		var/Y = src.permissions[client.connectedas.name]
		if(!Y)
			return 0
		else
			return Y

/datum/os/proc/Message(var/msg)
	for(var/mob/A in src.owner)
		A << output(msg,"console_output")