
//////////////////////
//PriorityQueue object
//////////////////////

//an ordered list, using the cmp proc to weight the list elements
/PriorityQueue
	/// List. The actual queue.
	var/list/L
	/// Proc path. The weight function used to order the queue.
	var/cmp

/PriorityQueue/New(compare)
	L = new()
	cmp = compare

/// Checks if the queue is currently empty. Returns boolean. Mirrors to `!length(L)`
/PriorityQueue/proc/IsEmpty()
	SHOULD_BE_PURE(TRUE)
	return !length(L)

/// Adds an element to the queue, immediately ordering it to its position using the function defined in `cmp`.
/PriorityQueue/proc/Enqueue(atom/A)
	ADD_SORTED(L, A, cmp)

/// Removes and returns the first element in the queue, or `FALSE` if the queue is empty.
/PriorityQueue/proc/Dequeue()
	if(!length(L))
		return FALSE
	. = L[1]

	Remove(.)

/// Removes an element from the queue. Returns boolean, indicating whether an item was removed or not. Mirrors to `L.Remove(A)`
/PriorityQueue/proc/Remove(atom/A)
	. = L.Remove(A)

/// Returns a copy of the queue as a list. Mirrors to `L.Copy()`
/PriorityQueue/proc/List()
	RETURN_TYPE(/list)
	SHOULD_BE_PURE(TRUE)
	. = L.Copy()

/// Returns the position of an element or `FALSE` if not found. Mirrors to `L.Find(A)`
/PriorityQueue/proc/Seek(atom/A)
	SHOULD_BE_PURE(TRUE)
	. = L.Find(A)

/// Returns the element at position `i` (1-indexed), or `FALSE` if the position does not exist.
/PriorityQueue/proc/Get(i)
	SHOULD_BE_PURE(TRUE)
	if(i > length(L) || i < 1)
		return FALSE
	return L[i]

/// Returns the length of the queue. Mirrors to `length(L)`
/PriorityQueue/proc/Length()
	SHOULD_BE_PURE(TRUE)
	. = length(L)

/**
 * Repositions the given element to the correct position in the queue using the function defined in `cmp`.
 *
 * The element must already exist in the queue to be resorted.
 *
 * Has no return value.
 */
/PriorityQueue/proc/ReSort(atom/A)
	var/i = Seek(A)
	if(i == 0)
		return
	while(i < length(L) && call(cmp)(L[i],L[i+1]) > 0)
		L.Swap(i,i+1)
		i++
	while(i > 1 && call(cmp)(L[i],L[i-1]) <= 0) //last inserted element being first in case of ties (optimization)
		L.Swap(i,i-1)
		i--
