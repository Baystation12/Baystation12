//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

var/global/list/ALL_ANTIGENS = list(
		"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
	)

/hook/startup/proc/randomise_antigens_order()
	ALL_ANTIGENS = shuffle(ALL_ANTIGENS)
	return 1

// iterate over the list of antigens and see what matches
/proc/antigens2string(list/antigens, none="None")
	if(!istype(antigens))
		CRASH("Illegal type!")
	if(!antigens.len)
		return none

	var/code = ""
	for(var/V in ALL_ANTIGENS)
		if(V in antigens)
			code += V

	if(!code)
		return none

	return code
