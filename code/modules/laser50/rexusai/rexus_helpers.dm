/proc/RecursiveListLoop(var/list/L) //This proc loops through a list of lists, unsure if BYOND supports this, I made it myself.
	if(L)
		. = list
		for(var/list/M in L)
			for(var/listitem in M)
				. += listitem
		return .