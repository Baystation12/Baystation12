// Helper macros to aid in optimizing lazy instantiation of lists.
// All of these are null-safe, you can use them without knowing if the list var is initialized yet

//Picks from the list, with some safeties, and returns the "default" arg if it fails
#define DEFAULTPICK(L, default) ((islist(L) && length(L)) ? pick(L) : default)
// Ensures L is initailized after this point
#define LAZYINITLIST(L) if (!L) L = list()
// Sets a L back to null iff it is empty
#define UNSETEMPTY(L) if (L && !length(L)) L = null
// Removes I from list L, and sets I to null if it is now empty
#define LAZYREMOVE(L, I) if(L) { L -= I; if(!length(L)) { L = null; } }
// Adds I to L, initalizing L if necessary
#define LAZYADD(L, I) if(!L) { L = list(); } L += I;
// Insert I into L at position X, initalizing L if necessary
#define LAZYINSERT(L, I, X) if(!L) { L = list(); } L.Insert(X, I);
// Adds I to L, initalizing L if necessary, if I is not already in L
#define LAZYDISTINCTADD(L, I) if(!L) { L = list(); } L |= I;
// Sets L[A] to I, initalizing L if necessary
#define LAZYSET(L, A, I) if(!L) { L = list(); } L[A] = I;
// Reads I from L safely - Works with both associative and traditional lists.
#define LAZYACCESS(L, I) (L ? (isnum(I) ? (I > 0 && I <= length(L) ? L[I] : null) : L[I]) : null)
// Reads the length of L, returning 0 if null
#define LAZYLEN(L) length(L)
// Safely checks if I is in L
#define LAZYISIN(L, I) (L ? (I in L) : FALSE)
// Null-safe List.Cut() and discard.
#define LAZYCLEARLIST(L) if(L) { L.len = 0; L = null; }
// Safely merges L2 into L1 as lazy lists, initializing L1 if necessary.
#define LAZYMERGELIST(L1, L2) if (length(L2)) { if (!L1) { L1 = list() } L1 |= L2 }
// Reads L or an empty list if L is not a list.  Note: Does NOT assign, L may be an expression.
#define SANITIZE_LIST(L) ( islist(L) ? L : list() )


// Helper macros for funny pseudo-list vars that can be a single value or a list of multiple values. These only work for sequential one-dimensional lists.
/// Checks if `L` contains only 1 item and reduces it to a value if so.
#define PSEUDO_LAZY_REDUCE_CHECK(L) if (islist(L) && length(L) == 1) { L = L[1]; }

/// Removes I from list L, converts L to I if there's only 1 item left, or to null if empty.
#define PSEUDO_LAZY_REMOVE(L, I) if (islist(L)) { L -= I; PSEUDO_LAZY_REDUCE_CHECK(L); } else if (L == I) { L = null; }

/// Adds I to L, converting to list format if necessary.
#define PSEUDO_LAZY_ADD(L, I) if (isnull(L)) { L = I; } else if (islist(L)) { L += I; } else { L = list(L, I); }

/// Adds I to L, converting to list format if necessary, if I is not already in L.
#define PSEUDO_LAZY_DISTINCT_ADD(L, I) if (isnull(L)) { L = I; } else if (islist(L)) { L |= I; } else if (L != I) { L = list(L, I); }

/// Reads the length of L, understanding a non-list value as a count of 1.
#define PSUEDO_LAZY_LENGTH(L) (islist(L) ? length(L) : (isnull(L) ? 0 : 1))

/// Safely checks if I is in L.
#define PSEUDO_LAZY_IS_IN(L, I) (islist(L) ? (I in L) : (L == I ? TRUE : FALSE))

/// Safely checks if I is a valid type or subtype of entries in L.
#define PSEUDO_LAZY_IS_TYPE(L, I) (islist(L) ? is_type_in_list(I, L) : istype(I, L))

/// Pseudo-list safe List.Cut() and discard.
#define PSEUDO_LAZY_CLEAR_LIST(L) if (islist(L)) { L.len = 0; } L = null;

/// Reads L as a list, regardless of actual value, even if null. NOTE: Does NOT assign.
#define PSEUDO_LIST_SANITIZE(L) (islist(L) ? L : (isnull(L) ? list() : list(L)))


/****
* Binary search sorted insert
* INPUT: Object to be inserted
* LIST: List to insert object into
* TYPECONT: The typepath of the contents of the list
* COMPARE: The object to compare against, usualy the same as INPUT
* COMPARISON: The variable on the objects to compare
* COMPTYPE: How should the values be compared? Either COMPARE_KEY or COMPARE_VALUE.
****/
#define BINARY_INSERT(INPUT, LIST, TYPECONT, COMPARE, COMPARISON, COMPTYPE) \
	do {\
		var/list/__BIN_LIST = LIST;\
		var/__BIN_CTTL = length(__BIN_LIST);\
		if(!__BIN_CTTL) {\
			__BIN_LIST += INPUT;\
		} else {\
			var/__BIN_LEFT = 1;\
			var/__BIN_RIGHT = __BIN_CTTL;\
			var/__BIN_MID = SHIFTR((__BIN_LEFT + __BIN_RIGHT), 1);\
			var ##TYPECONT/__BIN_ITEM;\
			while(__BIN_LEFT < __BIN_RIGHT) {\
				__BIN_ITEM = COMPTYPE;\
				if(__BIN_ITEM.##COMPARISON <= COMPARE.##COMPARISON) {\
					__BIN_LEFT = __BIN_MID + 1;\
				} else {\
					__BIN_RIGHT = __BIN_MID;\
				};\
				__BIN_MID = SHIFTR((__BIN_LEFT + __BIN_RIGHT), 1);\
			};\
			__BIN_ITEM = COMPTYPE;\
			__BIN_MID = __BIN_ITEM.##COMPARISON > COMPARE.##COMPARISON ? __BIN_MID : __BIN_MID + 1;\
			__BIN_LIST.Insert(__BIN_MID, INPUT);\
		};\
	} while(FALSE)

/// Passed into BINARY_INSERT to compare keys
#define COMPARE_KEY __BIN_LIST[__BIN_MID]

/// Passed into BINARY_INSERT to compare values
#define COMPARE_VALUE __BIN_LIST[__BIN_LIST[__BIN_MID]]
