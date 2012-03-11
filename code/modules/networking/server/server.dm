datum/os/server
	name = "SERVER OS"
	auth = 1

datum/os/server/New(ips,names,hostnamex)
	pwd = root
	var/datum/dir/X = new("bajs",src.pwd)
	pwd.contents += X
	X.holder = pwd
	X.permissions["root"] = RW
	root.permissions["root"] = RW
	Boot()
	src.ip = ips
	www.RegisterDomain(src,hostnamex)
	www.nodes[ip] = src
	name = names
	var/datum/dir/file/V = new("testhtml",pwd)
	V.contents += "Welcome to the server \n<href=\"testhtml2\"name=\">Continue\""
	var/datum/dir/file/C = new("testhtml2",pwd)
	C.contents << "Welcome to the other server html \n<href=\"testhtml1\"name=\">Go back\""
	pwd.contents += V
	pwd.contents += C
	user = new("root","password")
	var/datum/user/F = new("anon","derp")
	users += user
	users += F
datum/os/server/Boot()
	..()
/datum/os/CanConnect(var/datum/os/client,user,pass)
	if(src.auth == 1)
		var/X = Login(client,user,pass)
		if(X)
			clients += client
			client.connected = src
			client.connectedas = src.GetUser(X)
			return 1
		else
			return 0
			client.command("disconnect")
	else
		clients += client
		client.connected = src
		client.connectedas = src.GetUser("root")
		return 1
/datum/os/proc/OnConnect(var/datum/os/client,user,pass)
	client.Message(src.name)
	client.Message(src.config["motd"])
	client.pwd = src.root
/datum/os/proc/Login(var/datum/os/client,user,pass)
	if(user && pass)
		var/username = user
		var/password = pass
		for(var/datum/user/C in users)
			if(C.name == username)
				if(C.password == password)
				//	client.owner << "Aceepted.."
					return C.name
		return 0
	Message("Username:")
	var/username = client.GetInput()
	Message("Password:")
	var/password = client.GetInput()
	if(!username)
		return
	for(var/datum/user/C in users)
		if(C.name == username)
			if(C.password == password)
			//	client.owner << "Aceepted.."
				return C.name
	return 0

