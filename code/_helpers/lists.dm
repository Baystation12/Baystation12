/*
 * Holds procs to help with list operations
 * Contains groups:
 *			Misc
 *			Sorting
 */

/*
 * Misc
 */

//Returns a list in plain english as a string
/proc/english_list(list/input, nothing_text = "nothing", and_text = " and ", comma_text = ", ", final_comma_text = "," )
	switch(length(input))
		if(0) return nothing_text
		if(1) return "[input[1]]"
		if(2) return "[input[1]][and_text][input[2]]"
		else  return "[jointext(input, comma_text, 1, -1)][final_comma_text][and_text][input[length(input)]]"

/**
 * Converts a list to an HTML formatted list, i.e.:
 *
 * ```dm
 * list(
 *     "Value1",
 *     "Value2"
 * )
 * ```
 *
 * Becomes:
 *
 * ```html
 * <ul>
 *     <li>Value1</li>
 *     <li>Value2</li>
 * </ul>
 * ```
 *
 * **Parameters**:
 * - `input` - The list to convert to an HTML formatted list. Values must be convertable to string. List keys from associative lists are not used.
 * - `numbered_list` (Boolean, default `FALSE`) - If set, the list will use `<ol>` instead of `<ul>` tags, generating a numbered list instead of bullets.
 *
 * Returns string, or null if `input` is empty.
 */
/proc/html_list(list/input, numbered_list = FALSE)
	if (!length(input))
		return
	var/html_tag = numbered_list ? "ol" : "ul"
	. = "<[html_tag]>"
	for (var/key in input)
		. += "<li>[input[key]]</li>"
	. += "</[html_tag]>"

/**
 * Converts an associative list to an HTML formatted definition list, i.e.:
 *
 * ```dm
 * list(
 *     "Key1" = "Value1",
 *     "Key2" = "Value2"
 * )
 * ```
 *
 * Becomes:
 *
 * ```html
 * <dl>
 *     <dt>Key1</dt>
 *     <dd>Value1</dd>
 *     <dt>Key2</dt>
 *     <dd>Value2</dd>
 *     ...
 * </dl>
 * ```
 *
 * **Parameters**:
 * - `input` - The list to convert to an HTML formatted list. Both the key and value must be convertable to string.
 *
 * Returns string, or null if `input` is empty.
 */
/proc/html_list_dl(list/input)
	if (!length(input))
		return
	. = "<dl>"
	for (var/key in input)
		. += "<dt>[key]</dt><dd>[input[key]]</dd>"
	. += "</dl>"

//Checks for specific types in a list
/proc/is_type_in_list(atom/A, list/L)
	for(var/type in L)
		if(istype(A, type))
			return 1
	return 0

//Checks for specific paths in a list
/proc/is_path_in_list(path, list/L)
	for(var/type in L)
		if(ispath(path, type))
			return 1
	return 0

/proc/instances_of_type_in_list(atom/A, list/L)
	var/instances = 0
	for(var/type in L)
		if(istype(A, type))
			instances++
	return instances

//Removes any null entries from the list
/proc/listclearnulls(list/list)
	if(istype(list))
		while(null in list)
			list -= null
	return

/*
 * Returns list containing all the entries from first list that are not present in second.
 * If skiprep = 1, repeated elements are treated as one.
 * If either of arguments is not a list, returns null
 */
/proc/difflist(list/first, list/second, skiprep=0)
	RETURN_TYPE(/list)
	if(!islist(first) || !islist(second))
		return
	var/list/result = new
	if(skiprep)
		for(var/e in first)
			if(!(e in result) && !(e in second))
				result += e
	else
		result = first - second
	return result

/*
Two lists may be different (A!=B) even if they have the same elements.
This actually tests if they have the same entries and values.
*/
/proc/same_entries(list/first, list/second)
	if(!islist(first) || !islist(second))
		return 0
	if(length(first) != length(second))
		return 0
	for(var/entry in first)
		if(!(entry in second) || (first[entry] != second[entry]))
			return 0
	return 1
/*
Checks if a list has the same entries and values as an element of big.
*/
/proc/in_as_list(list/little, list/big)
	if(!islist(big))
		return 0
	for(var/element in big)
		if(same_entries(little, element))
			return 1
	return 0
/*
 * Returns list containing entries that are in either list but not both.
 * If skipref = 1, repeated elements are treated as one.
 * If either of arguments is not a list, returns null
 */
/proc/uniquemergelist(list/first, list/second, skiprep=0)
	RETURN_TYPE(/list)
	if(!islist(first) || !islist(second))
		return
	var/list/result = new
	if(skiprep)
		result = difflist(first, second, skiprep)+difflist(second, first, skiprep)
	else
		result = first ^ second
	return result

/proc/assoc_merge_add(value_a, value_b)
	RETURN_TYPE(/list)
	return value_a + value_b

// This proc merges two associative lists
/proc/merge_assoc_lists(list/a, list/b, merge_method, default_if_null_value = null)
	RETURN_TYPE(/list)
	. = list()
	for(var/key in a)
		var/a_value = a[key]
		a_value = isnull(a_value) ? default_if_null_value : a_value
		.[key] = a_value
	for(var/key in b)
		var/b_value = b[key]
		b_value = isnull(b_value) ? default_if_null_value : b_value
		if(!(key in .))
			.[key] = b_value
		else
			.[key] = call(merge_method)(.[key], b_value)

/* pickweight
	given an associative list of (key = weight, key = weight, ...), returns a random key biased by weights
	if the argument is a list that does not appear associative by its first key, returns pick(list)
	if the argument is empty or not a list, returns null
*/
/proc/pickweight(list/L)
	var/len = length(L)
	if (len && islist(L))
		for (var/key in L)
			if (isnull(L[key]))
				return pick(L)
			break
		var/sum = 0
		for (var/key in L)
			sum += L[key]
		sum *= rand()
		for (var/key in L)
			sum -= L[key]
			if (sum <= 0)
				return key
		return L[len]
	return null

/* pickweight_index
	given an indexed list of (index = weight, index + 1 = weight, ...), returns a random index biased by weights. Higher weight = more chance
	if the argument is not an indexed list of weights, returns pick(list)
	if the argument is empty or not a list, returns null
*/
/proc/pickweight_index(list/L)
	var/len = length(L)
	if (len && islist(L))
		for(var/index = 1 to len)
			if (isnull(L[index]))
				return pick(L)
			break
		var/sum = 0
		for(var/index = 1 to len)
			sum += L[index]
		sum *= rand()
		for(var/index = 1 to len)
			sum -= L[index]
			if (sum <= 0)
				return index
		return len
	return null

//Pick a random element from the list and remove it from the list.
/proc/pick_n_take(list/listfrom)
	if (length(listfrom) > 0)
		var/picked = pick(listfrom)
		listfrom -= picked
		return picked
	return null


/// Remove and return the last element of the list, or null.
/proc/pop(list/list)
	var/last_index = length(list)
	if (last_index)
		. = list[last_index]
		LIST_DEC(list)

/// Returns the first element from the list and removes it from the list
/proc/popleft(list/L)
	if (length(L))
		. = L[1]
		L.Cut(1,2)

//Returns the next element in parameter list after first appearance of parameter element. If it is the last element of the list or not present in list, returns first element.
/proc/next_in_list(element, list/L)
	for(var/i=1, i<length(L), i++)
		if(L[i] == element)
			return L[i+1]
	return L[1]

/*
 * Sorting
 */

//Reverses the order of items in the list
/proc/reverselist(list/L)
	RETURN_TYPE(/list)
	var/list/output = list()
	if(L)
		for(var/i = length(L); i >= 1; i--)
			output += L[i]
	return output


/// Returns a Fisher-Yates shuffled copy of list, or list itself if in_place.
/proc/shuffle(list/list, in_place)
	RETURN_TYPE(/list)
	if (!islist(list))
		return
	if (!in_place)
		list = list.Copy()
	var/size = length(list)
	for (var/i = 1 to size)
		list.Swap(i, rand(i, size))
	return list


//Return a list with no duplicate entries
/proc/uniquelist(list/L)
	RETURN_TYPE(/list)
	. = list()
	for(var/i in L)
		. |= i

// Return a list of the values in an assoc list (including null)
/proc/list_values(list/L)
	RETURN_TYPE(/list)
	. = list()
	for(var/e in L)
		. += L[e]

//Mergesort: divides up the list into halves to begin the sort
/proc/sortKey(list/client/L, order = 1)
	RETURN_TYPE(/list)
	if(isnull(L) || length(L) < 2)
		return L
	var/middle = length(L) / 2 + 1
	return mergeKey(sortKey(L.Copy(0,middle)), sortKey(L.Copy(middle)), order)

//Mergsort: does the actual sorting and returns the results back to sortAtom
/proc/mergeKey(list/client/L, list/client/R, order = 1)
	RETURN_TYPE(/list)
	var/Li=1
	var/Ri=1
	var/list/result = new()
	while(Li <= length(L) && Ri <= length(R))
		var/client/rL = L[Li]
		var/client/rR = R[Ri]
		if(sorttext(rL.ckey, rR.ckey) == order)
			result += L[Li++]
		else
			result += R[Ri++]

	if(Li <= length(L))
		return (result + L.Copy(Li, 0))
	return (result + R.Copy(Ri, 0))

//Mergesort: divides up the list into halves to begin the sort
/proc/sortAtom(list/atom/L, order = 1)
	RETURN_TYPE(/list)
	if(isnull(L) || length(L) < 2)
		return L
	if(null in L)	// Cannot sort lists containing null entries.
		return L
	var/middle = length(L) / 2 + 1
	return mergeAtoms(sortAtom(L.Copy(0,middle)), sortAtom(L.Copy(middle)), order)

//Mergsort: does the actual sorting and returns the results back to sortAtom
/proc/mergeAtoms(list/atom/L, list/atom/R, order = 1)
	RETURN_TYPE(/list)
	var/Li=1
	var/Ri=1
	var/list/result = new()

	while(Li <= length(L) && Ri <= length(R))
		var/atom/rL = L[Li]
		var/atom/rR = R[Ri]
		if(sorttext(rL.name, rR.name) == order)
			result += L[Li++]
		else
			result += R[Ri++]

	if(Li <= length(L))
		return (result + L.Copy(Li, 0))
	return (result + R.Copy(Ri, 0))

//Mergesort: any value in a list
/proc/sortList(list/L)
	RETURN_TYPE(/list)
	if(length(L) < 2)
		return L
	var/middle = length(L) / 2 + 1 // Copy is first,second-1
	return mergeLists(sortList(L.Copy(0,middle)), sortList(L.Copy(middle))) //second parameter null = to end of list

//Mergsorge: uses sortList() but uses the var's name specifically. This should probably be using mergeAtom() instead
/proc/sortNames(list/L)
	RETURN_TYPE(/list)
	var/list/Q = new()
	for(var/atom/x in L)
		Q[x.name] = x
	return sortList(Q)

/proc/mergeLists(list/L, list/R)
	RETURN_TYPE(/list)
	var/Li=1
	var/Ri=1
	var/list/result = new()
	while(Li <= length(L) && Ri <= length(R))
		if(sorttext(L[Li], R[Ri]) < 1)
			result += R[Ri++]
		else
			result += L[Li++]

	if(Li <= length(L))
		return (result + L.Copy(Li, 0))
	return (result + R.Copy(Ri, 0))


// List of lists, sorts by element[key] - for things like crew monitoring computer sorting records by name.
/proc/sortByKey(list/L, key)
	RETURN_TYPE(/list)
	if(length(L) < 2)
		return L
	var/middle = length(L) / 2 + 1
	return mergeKeyedLists(sortByKey(L.Copy(0, middle), key), sortByKey(L.Copy(middle), key), key)

/proc/mergeKeyedLists(list/L, list/R, key)
	RETURN_TYPE(/list)
	var/Li=1
	var/Ri=1
	var/list/result = new()
	while(Li <= length(L) && Ri <= length(R))
		if(sorttext(L[Li][key], R[Ri][key]) < 1)
			// Works around list += list2 merging lists; it's not pretty but it works
			result += "temp item"
			result[length(result)] = R[Ri++]
		else
			result += "temp item"
			result[length(result)] = L[Li++]

	if(Li <= length(L))
		return (result + L.Copy(Li, 0))
	return (result + R.Copy(Ri, 0))


//Mergesort: any value in a list, preserves key=value structure
/proc/sortAssoc(list/L)
	RETURN_TYPE(/list)
	if(length(L) < 2)
		return L
	var/middle = length(L) / 2 + 1 // Copy is first,second-1
	return mergeAssoc(sortAssoc(L.Copy(0,middle)), sortAssoc(L.Copy(middle))) //second parameter null = to end of list

/proc/mergeAssoc(list/L, list/R)
	RETURN_TYPE(/list)
	var/Li=1
	var/Ri=1
	var/list/result = new()
	while(Li <= length(L) && Ri <= length(R))
		if(sorttext(L[Li], R[Ri]) < 1)
			result += R&R[Ri++]
		else
			result += L&L[Li++]

	if(Li <= length(L))
		return (result + L.Copy(Li, 0))
	return (result + R.Copy(Ri, 0))

//Converts a bitfield to a list of numbers (or words if a wordlist is provided)
/proc/bitfield2list(bitfield = 0, list/wordlist)
	RETURN_TYPE(/list)
	var/list/r = list()
	if(istype(wordlist,/list))
		var/max = min(length(wordlist),16)
		var/bit = 1
		for(var/i=1, i<=max, i++)
			if(bitfield & bit)
				r += wordlist[i]
			bit = SHIFTL(bit, 1)
	else
		for(var/bit=1, bit<=65535, bit = SHIFTL(bit, 1))
			if(bitfield & bit)
				r += bit

	return r

// Returns the key based on the index
/proc/get_key_by_index(list/L, index)
	var/i = 1
	for(var/key in L)
		if(index == i)
			return key
		i++
	return null

// Returns the key based on the index
/proc/get_key_by_value(list/L, value)
	for(var/key in L)
		if(L[key] == value)
			return key

/proc/count_by_type(list/L, type)
	var/i = 0
	for(var/T in L)
		if(istype(T, type))
			i++
	return i

//Don't use this on lists larger than half a dozen or so
/proc/insertion_sort_numeric_list_ascending(list/L)
	RETURN_TYPE(/list)
	//to_world_log("ascending len input: [length(L)]")
	var/list/out = list(pop(L))
	for(var/entry in L)
		if(isnum(entry))
			var/success = 0
			for(var/i=1, i<=length(out), i++)
				if(entry <= out[i])
					success = 1
					out.Insert(i, entry)
					break
			if(!success)
				out.Add(entry)

	//to_world_log("output: [length(out)]")
	return out

/proc/insertion_sort_numeric_list_descending(list/L)
	RETURN_TYPE(/list)
	//to_world_log("descending len input: [length(L)]")
	var/list/out = insertion_sort_numeric_list_ascending(L)
	//to_world_log("output: [length(out)]")
	return reverselist(out)


// Insert an object A into a sorted list using cmp_proc (/code/_helpers/cmp.dm) for comparison.
// Use ADD_SORTED(list, A, cmp_proc)

// Return the index using dichotomic search
/proc/FindElementIndex(atom/A, list/L, cmp)
	var/i = 1
	var/j = length(L)
	var/mid

	while(i < j)
		mid = round((i+j)/2)

		if(call(cmp)(L[mid],A) < 0)
			i = mid + 1
		else
			j = mid

	if(i == 1 || i ==  length(L)) // Edge cases
		return (call(cmp)(L[i],A) > 0) ? i : i+1
	else
		return i


/proc/dd_sortedObjectList(list/L, cache=list())
	RETURN_TYPE(/list)
	if(length(L) < 2)
		return L
	var/middle = length(L) / 2 + 1 // Copy is first,second-1
	return dd_mergeObjectList(dd_sortedObjectList(L.Copy(0,middle), cache), dd_sortedObjectList(L.Copy(middle), cache), cache) //second parameter null = to end of list

/proc/dd_mergeObjectList(list/L, list/R, list/cache)
	RETURN_TYPE(/list)
	var/Li=1
	var/Ri=1
	var/list/result = new()
	while(Li <= length(L) && Ri <= length(R))
		var/LLi = L[Li]
		var/RRi = R[Ri]
		var/LLiV = cache[LLi]
		var/RRiV = cache[RRi]
		if(!LLiV)
			LLiV = LLi:dd_SortValue()
			cache[LLi] = LLiV
		if(!RRiV)
			RRiV = RRi:dd_SortValue()
			cache[RRi] = RRiV
		if(LLiV < RRiV)
			result += L[Li++]
		else
			result += R[Ri++]

	if(Li <= length(L))
		return (result + L.Copy(Li, 0))
	return (result + R.Copy(Ri, 0))

// Insert an object into a sorted list, preserving sortedness
/proc/dd_insertObjectList(list/L, O)
	RETURN_TYPE(/list)
	var/min = 1
	var/max = length(L) + 1
	var/Oval = O:dd_SortValue()

	while(1)
		var/mid = min+round((max-min)/2)

		if(mid == max)
			L.Insert(mid, O)
			return

		var/Lmid = L[mid]
		var/midval = Lmid:dd_SortValue()
		if(Oval == midval)
			L.Insert(mid, O)
			return
		else if(Oval < midval)
			max = mid
		else
			min = mid+1

/proc/dd_sortedtextlist(list/incoming, case_sensitive = 0)
	RETURN_TYPE(/list)
	// Returns a new list with the text values sorted.
	// Use binary search to order by sortValue.
	// This works by going to the half-point of the list, seeing if the node in question is higher or lower cost,
	// then going halfway up or down the list and checking again.
	// This is a very fast way to sort an item into a list.
	var/list/sorted_text = new()
	var/low_index
	var/high_index
	var/insert_index
	var/midway_calc
	var/current_index
	var/current_item
	var/list/list_bottom
	var/sort_result

	var/current_sort_text
	for (current_sort_text in incoming)
		low_index = 1
		high_index = length(sorted_text)
		while (low_index <= high_index)
			// Figure out the midpoint, rounding up for fractions.  (BYOND rounds down, so add 1 if necessary.)
			midway_calc = (low_index + high_index) / 2
			current_index = round(midway_calc)
			if (midway_calc > current_index)
				current_index++
			current_item = sorted_text[current_index]

			if (case_sensitive)
				sort_result = sorttextEx(current_sort_text, current_item)
			else
				sort_result = sorttext(current_sort_text, current_item)

			switch(sort_result)
				if (1)
					high_index = current_index - 1	// current_sort_text < current_item
				if (-1)
					low_index = current_index + 1	// current_sort_text > current_item
				if (0)
					low_index = current_index		// current_sort_text == current_item
					break

		// Insert before low_index.
		insert_index = low_index

		// Special case adding to end of list.
		if (insert_index > length(sorted_text))
			sorted_text += current_sort_text
			continue

		// Because BYOND lists don't support insert, have to do it by:
		// 1) taking out bottom of list, 2) adding item, 3) putting back bottom of list.
		list_bottom = sorted_text.Copy(insert_index)
		sorted_text.Cut(insert_index)
		sorted_text += current_sort_text
		sorted_text += list_bottom
	return sorted_text


/proc/dd_sortedTextList(list/incoming)
	RETURN_TYPE(/list)
	var/case_sensitive = 1
	return dd_sortedtextlist(incoming, case_sensitive)


/datum/proc/dd_SortValue()
	return "[src]"

/obj/machinery/dd_SortValue()
	return "[sanitize_old(name)]"

/obj/machinery/camera/dd_SortValue()
	return "[c_tag]"

/datum/alarm/dd_SortValue()
	return "[sanitize_old(last_name)]"

//creates every subtype of prototype (excluding prototype) and adds it to list L.
//if no list/L is provided, one is created.
/proc/init_subtypes(prototype, list/L)
	RETURN_TYPE(/list)
	if(!istype(L))	L = list()
	for(var/path in subtypesof(prototype))
		L += new path()
	return L

//creates every subtype of prototype (excluding prototype) and adds it to list L as a type/instance pair.
//if no list/L is provided, one is created.
/proc/init_subtypes_assoc(prototype, list/L)
	RETURN_TYPE(/list)
	if(!istype(L))	L = list()
	for(var/path in subtypesof(prototype))
		L[path] = new path()
	return L

#define listequal(A, B) (length(A) == length(B) && !length(A^B))

/proc/filter_list(list/L, type)
	RETURN_TYPE(/list)
	. = list()
	for(var/entry in L)
		if(istype(entry, type))
			. += entry

/proc/group_by(list/group_list, key, value)
	var/values = group_list[key]
	if(!values)
		values = list()
		group_list[key] = values

	values += value

/proc/duplicates(list/L)
	RETURN_TYPE(/list)
	. = list()
	var/list/checked = list()
	for(var/value in L)
		if(value in checked)
			. |= value
		else
			checked += value


/proc/get_initial_name(atom/atom_type)
	var/atom/A = atom_type
	return initial(A.name)

//Move a single element from position fromIndex within a list, to position toIndex
//All elements in the range [1,toIndex) before the move will be before the pivot afterwards
//All elements in the range [toIndex, length(L)+1) before the move will be after the pivot afterwards
//In other words, it's as if the range [fromIndex,toIndex) have been rotated using an unsigned shift operation common to other languages.
//fromIndex and toIndex must be in the range [1,length(L)+1]
//This will preserve associations ~Carnie
/proc/moveElement(list/L, fromIndex, toIndex)
	if(fromIndex == toIndex || fromIndex+1 == toIndex)	//no need to move
		return
	if(fromIndex > toIndex)
		++fromIndex	//since a null will be inserted before fromIndex, the index needs to be nudged right by one

	L.Insert(toIndex, null)
	L.Swap(fromIndex, toIndex)
	L.Cut(fromIndex, fromIndex+1)

//Move elements [fromIndex,fromIndex+len) to [toIndex-len, toIndex)
//Same as moveElement but for ranges of elements
//This will preserve associations ~Carnie
/proc/moveRange(list/L, fromIndex, toIndex, len=1)
	var/distance = abs(toIndex - fromIndex)
	if(len >= distance)	//there are more elements to be moved than the distance to be moved. Therefore the same result can be achieved (with fewer operations) by moving elements between where we are and where we are going. The result being, our range we are moving is shifted left or right by dist elements
		if(fromIndex <= toIndex)
			return	//no need to move
		fromIndex += len	//we want to shift left instead of right

		for(var/i=0, i<distance, ++i)
			L.Insert(fromIndex, null)
			L.Swap(fromIndex, toIndex)
			L.Cut(toIndex, toIndex+1)
	else
		if(fromIndex > toIndex)
			fromIndex += len

		for(var/i=0, i<len, ++i)
			L.Insert(toIndex, null)
			L.Swap(fromIndex, toIndex)
			L.Cut(fromIndex, fromIndex+1)

//replaces reverseList ~Carnie
/proc/reverseRange(list/L, start=1, end=0)
	RETURN_TYPE(/list)
	if(length(L))
		start = start % length(L)
		end = end % (length(L)+1)
		if(start <= 0)
			start += length(L)
		if(end <= 0)
			end += length(L) + 1

		--end
		while(start < end)
			L.Swap(start++,end--)

	return L

//Copies a list, and all lists inside it recusively
//Does not copy any other reference type
/proc/deepCopyList(list/l)
	RETURN_TYPE(/list)
	if(!islist(l))
		return l
	. = l.Copy()
	for(var/i = 1 to length(l))
		if(islist(.[i]))
			.[i] = .(.[i])

#define IS_VALID_INDEX(list, index) (length(list) && index > 0 && index <= length(list))

// Returns the first key where T fulfills ispath
/proc/get_ispath_key(list/L, T)
	for(var/key in L)
		if(ispath(T, key))
			return key

// Gets the first instance that is of the given type (strictly)
/proc/get_instance_of_strict_type(list/L, T)
	RETURN_TYPE(/atom)
	for(var/key in L)
		var/atom/A = key
		if(A.type == T)
			return A

/**
 * Returns a new list with only atoms that are in typecache L
 *
 */
/proc/typecache_filter_list(list/atoms, list/typecache)
	RETURN_TYPE(/list)
	. = list()
	for(var/thing in atoms)
		var/atom/A = thing
		if(typecache[A.type])
			. += A

/**
 * Like typesof() or subtypesof(), but returns a typecache instead of a list
 */
/proc/typecacheof(path, ignore_root_path, only_root_path = FALSE)
	RETURN_TYPE(/list)
	if(ispath(path))
		var/list/types = list()
		if(only_root_path)
			types = list(path)
		else
			types = ignore_root_path ? subtypesof(path) : typesof(path)
		var/list/L = list()
		for(var/T in types)
			L[T] = TRUE
		return L
	else if(islist(path))
		var/list/pathlist = path
		var/list/L = list()
		if(ignore_root_path)
			for(var/P in pathlist)
				for(var/T in subtypesof(P))
					L[T] = TRUE
		else
			for(var/P in pathlist)
				if(only_root_path)
					L[P] = TRUE
				else
					for(var/T in typesof(P))
						L[T] = TRUE
		return L


/// Convert list to a map by calling handler per entry. Map may be supplied as a reference. Handlers should implement a no-params clear.
/proc/list_to_map(list/list, handler, list/map)
	RETURN_TYPE(/list)
	call(handler)()
	if (!islist(map))
		map = list()
	for (var/entry in list)
		call(handler)(map, entry)
	call(handler)()
	return map


/// Entry handler for list_to_map. Produces a "name"=ref map, overwriting duplicate names in encounter order.
/proc/ltm_by_atom_name(list/map, atom/entry)
	if (!map)
		return
	map[entry.name] = entry


/// Entry handler for list_to_map. Produces a "name"=ref map, suffixing a count to name for duplicate names.
/proc/ltm_by_atom_name_numbered(list/map, atom/entry)
	var/static/list/names_seen
	if (!map)
		names_seen = null
		return
	if (!names_seen)
		names_seen = list()
	var/index = ++names_seen[entry.name]
	if (index > 1)
		map["[entry.name] [index]"] = entry
	else
		map[entry.name] = entry
