//simple insertion sort - generally faster than merge for runs of 7 or smaller
/proc/sortInsert(list/L, cmp=/proc/cmp_numeric_asc, associative, fromIndex=1, toIndex=0)
	if(L && L.len >= 2)
		fromIndex = fromIndex % L.len
		toIndex = toIndex % (L.len+1)
		if(fromIndex <= 0)
			fromIndex += L.len
		if(toIndex <= 0)
			toIndex += L.len + 1

		sortInstance.L = L
		sortInstance.cmp = cmp
		sortInstance.associative = associative

		sortInstance.binarySort(fromIndex, toIndex, fromIndex)
	return L
