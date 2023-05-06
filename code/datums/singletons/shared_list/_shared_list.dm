/singleton/shared_list
	abstract_type = /singleton/shared_list
	var/max_pick = 8
	VAR_PRIVATE/list/list
	var/mutable

#if DM_VERSION >= 515
/singleton/shared_list/proc/operator""()
	return {"{"type":"[type]","mutable":"[mutable]","list":[json_encode(list)]}"}
#endif


/singleton/shared_list/proc/operator[](index)
	return list[index]


/singleton/shared_list/proc/operator[]=(index, value)
	if (!mutable)
		throw EXCEPTION("[type] is not mutable.")
		return
	list[index] = value


/singleton/shared_list/proc/operator+(value)
	return list + value


/singleton/shared_list/proc/operator+=(value)
	if (!mutable)
		throw EXCEPTION("[type] is not mutable.")
		return
	list += value


/singleton/shared_list/proc/operator-(value)
	return list - value


/singleton/shared_list/proc/operator-=(value)
	if (!mutable)
		throw EXCEPTION("[type] is not mutable.")
		return
	list -= value


/singleton/shared_list/proc/operator|(value)
	return list | value


/singleton/shared_list/proc/operator|=(value)
	if (!mutable)
		throw EXCEPTION("[type] is not mutable.")
		return
	list |= value


/singleton/shared_list/proc/operator&(value)
	return list & value


/singleton/shared_list/proc/operator&=(value)
	if (!mutable)
		throw EXCEPTION("[type] is not mutable.")
		return
	list &= value


/singleton/shared_list/proc/operator^(value)
	return list ^ value


/singleton/shared_list/proc/operator^=(value)
	if (!mutable)
		throw EXCEPTION("[type] is not mutable.")
		return
	list ^= value


/singleton/shared_list/proc/Add(/*Item1, Item2, ...*/)
	if (!mutable)
		throw EXCEPTION("[type] is not mutable.")
		return
	list.Add(arglist(args))


/singleton/shared_list/proc/Copy(Start = 1, End = 0)
	return list.Copy(Start, End)


/singleton/shared_list/proc/Cut(Start = 1, End = 0)
	if (!mutable)
		throw EXCEPTION("[type] is not mutable.")
		return
	list.Cut(Start, End)


/singleton/shared_list/proc/Find(Elem, Start = 1, End = 0)
	return list.Find(Elem, Start, End)


/singleton/shared_list/proc/Insert(/*Index, Item1, Item2, ...*/)
	if (!mutable)
		throw EXCEPTION("[type] is not mutable.")
		return
	return list.Insert(arglist(args))


/singleton/shared_list/proc/Join(Glue, Start = 1, End = 0)
	return list.Join(Glue, Start, End)


/singleton/shared_list/proc/Remove(/*Item1, Item2, ...*/)
	if (!mutable)
		throw EXCEPTION("[type] is not mutable.")
		return
	return list.Remove(arglist(args))


#if DM_VERSION >= 515
/singleton/shared_list/proc/RemoveAll(/*Item1, Item2, ...*/)
	if (!mutable)
		throw EXCEPTION("[type] is not mutable.")
		return
	return list.RemoveAll(arglist(args))
#endif


/singleton/shared_list/proc/Splice(/*Start = 1, End = 0, Item1, Item2, ...*/)
	if (!mutable)
		throw EXCEPTION("[type] is not mutable.")
		return
	list.Splice(arglist(args))



/singleton/shared_list/proc/Swap(Index1, Index2)
	if (!mutable)
		throw EXCEPTION("[type] is not mutable.")
		return
	list.Swap(Index1, Index2)


/// The length of the backing list.
/singleton/shared_list/proc/Len()
	return length(list)


/// TRUE if entry is in the backing list as a value or key.
/singleton/shared_list/proc/Has(entry)
	return (entry in list)


/// Returns a result, or list of results, randomly selected from the backing list by pick().
/singleton/shared_list/proc/Pick(count = 1)
	count = clamp(floor(count), 1, max_pick)
	if (count == 1)
		return pick(list)
	var/list/result[count]
	for (var/i = 1 to count)
		result[i] = pick(list)
	return result


/// Returns a result, or list of results, randomly selected from the backing map by pickweight().
/singleton/shared_list/proc/PickWeight(count = 1)
	count = clamp(floor(count), 1, max_pick)
	if (count == 1)
		return pickweight(list)
	var/list/result[count]
	for (var/i = 1 to count)
		result[i] = pickweight(list)
	return result
