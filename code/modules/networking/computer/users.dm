datum/user
	var/name = "root"
	var/password = "test"

datum/user/New(names,pass)
	if(names)name = names
	if(pass)password = pass