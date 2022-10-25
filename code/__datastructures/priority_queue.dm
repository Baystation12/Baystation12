
//////////////////////
//datum/PriorityQueue object
//////////////////////

//an ordered list, using the cmp proc to weight the list elements
/datum/PriorityQueue
	var/list/L //the actual queue
	var/cmp //the weight function used to order the queue

/datum/PriorityQueue/New(compare)
	L = new()
	cmp = compare

/datum/PriorityQueue/proc/IsEmpty()
	return !L.len

//add an element in the list,
//immediatly ordering it to its position using dichotomic search
/datum/PriorityQueue/proc/Enqueue(atom/A)
	ADD_SORTED(L, A, cmp)

//removes and returns the first element in the queue
/datum/PriorityQueue/proc/Dequeue()
	if(!L.len)
		return 0
	. = L[1]

	Remove(.)

//removes an element
/datum/PriorityQueue/proc/Remove(atom/A)
	. = L.Remove(A)

//returns a copy of the elements list
/datum/PriorityQueue/proc/List()
	. = L.Copy()

//return the position of an element or 0 if not found
/datum/PriorityQueue/proc/Seek(atom/A)
	. = L.Find(A)

//return the element at the i_th position
/datum/PriorityQueue/proc/Get(i)
	if(i > L.len || i < 1)
		return 0
	return L[i]

//return the length of the queue
/datum/PriorityQueue/proc/Length()
	. = L.len

//replace the passed element at it's right position using the cmp proc
/datum/PriorityQueue/proc/ReSort(atom/A)
	var/i = Seek(A)
	if(i == 0)
		return
	while(i < L.len && call(cmp)(L[i],L[i+1]) > 0)
		L.Swap(i,i+1)
		i++
	while(i > 1 && call(cmp)(L[i],L[i-1]) <= 0) //last inserted element being first in case of ties (optimization)
		L.Swap(i,i-1)
		i--
