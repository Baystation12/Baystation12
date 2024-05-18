//TimSort interface
/proc/sortTim(list/L, cmp=GLOBAL_PROC_REF(cmp_numeric_asc), associative, fromIndex=1, toIndex=0)
	RETURN_TYPE(/list)
	if(L && length(L) >= 2)
		fromIndex = fromIndex % length(L)
		toIndex = toIndex % (length(L)+1)
		if(fromIndex <= 0)
			fromIndex += length(L)
		if(toIndex <= 0)
			toIndex += length(L) + 1

		sortInstance.L = L
		sortInstance.cmp = cmp
		sortInstance.associative = associative

		sortInstance.timSort(fromIndex, toIndex)

	return L
