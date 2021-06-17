GLOBAL_LIST_EMPTY(price_cache)
/proc/get_value(atom/A) // A can be either type *or* instance; ie get_value(/obj) is valid, as is get_value(new /obj)
	var/atom/t = ispath(A) ? A : A.type
	while(!(t in worths)) // Find the first parent that is in the list
		t = PARENT(t)
		if(!t)
			return 0
	var/value = worths[t]
	if(value >= 0) // Value zero or greater than zero, all instances have same value
		return value
	else 
		if(ispath(A)) // Build a cache for tricky pricing types
			t = A
			if(!GLOB.price_cache[A])
				A = new A
				GLOB.price_cache[A.type] = A.Value(-value)
				qdel(A)
			return GLOB.price_cache[t]
		else
			return A.Value(-value)