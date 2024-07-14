/datum/stack
	/**
	 * List. Items within the stack. Initially defined during `New()`.
	 *
	 * Not intended to reference directly. Instead, see the various procs under `/datum/stack`.
	 */
	var/list/stack

	/// Integer. Maximum number of elements the stack can contain. If `0`, has no limit. Defined during `New()`.
	var/max_elements = 0

/datum/stack/New(list/elements, max)
	..()
	stack = elements ? elements.Copy() : list()
	if (max)
		max_elements = max

/datum/stack/Destroy()
	Clear()
	. = ..()

/**
 * Returns then removes the rightmost/last element in the stack.
 */
/datum/stack/proc/Pop()
	if (is_empty())
		return
	. = stack[length(stack)]
	stack.Cut(length(stack), 0)

/**
 * Adds `element` to the stack, unless the stack is already at the limit defined by `max_elements`.
 */
/datum/stack/proc/Push(element)
	if (max_elements && length(stack) >= max_elements)
		return
	stack += element

/**
 * Returns the rightmost/last element in the stack.
 */
/datum/stack/proc/Top()
	if(is_empty())
		return null
	. = stack[length(stack)]

/**
 * Removes `element` from the stack, if present.
 */
/datum/stack/proc/Remove(element)
	stack -= element

/**
 * Checks if the stack is currently empty. Returns boolean.
 */
/datum/stack/proc/is_empty()
	. = length(stack) ? FALSE : TRUE

/**
 * Rotates the entire stack left/backward with the leftmost/first element looping around to the right/end.
 *
 * Returns `FALSE` is the stack is empty.
 */
/datum/stack/proc/RotateLeft()
	if (is_empty())
		return FALSE
	. = stack[1]
	stack.Cut(1, 2)
	Push(.)

/**
 * Rotates the entire stack right/forward with the rightmost/last element looping around to the left/beginning.
 *
 * Returns `FALSE` is the stack is empty.
 */
/datum/stack/proc/RotateRight()
	if (is_empty())
		return FALSE
	. = stack[length(stack)]
	stack.Cut(length(stack), 0)
	stack.Insert(1, .)


/**
 * Returns a copy of the stack as a new instance of `/datum/stack`.
 */
/datum/stack/proc/Copy()
	return new /datum/stack(stack.Copy(), max_elements)

/**
 * Clears the stack of all entries.
 */
/datum/stack/proc/Clear()
	stack.Cut()

/**
 * `qdel()`s every entry in the stack, then clears the stack.
 */
/datum/stack/proc/QdelClear()
	for(var/entry in stack)
		qdel(entry)
	stack.Cut()
