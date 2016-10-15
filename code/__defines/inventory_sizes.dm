// The below should be used to define an item's w_class variable.
// Example: w_class = ITENSIZE_LARGE
// This allows the addition of future w_classes without needing to change every file.
#define ITEMSIZE_TINY           1
#define ITEMSIZE_SMALL          2
#define ITEMSIZE_NORMAL         3
#define ITEMSIZE_LARGE          4
#define ITEMSIZE_HUGE           5
#define ITEMSIZE_GARGANTUAN     6
#define ITEMSIZE_NO_CONTAINER 100 // Use this to forbid item from being placed in a container.


/*
	The values below are not yet i use.
*/

// Tweak these to determine how much space an item takes in a container.
// Look in storage.dm for get_storage_cost(), which uses these.  Containers also use these as a reference for size.
// ITEMSIZE_COST_NORMAL is equivalent to one slot using the old inventory system.  As such, it is a nice reference to use for
// defining how much space there is in a container.
#define ITEMSIZE_COST_TINY            1
#define ITEMSIZE_COST_SMALL	          2
#define ITEMSIZE_COST_NORMAL          4
#define ITEMSIZE_COST_LARGE           8
#define ITEMSIZE_COST_HUGE           16
#define ITEMSIZE_GARGANTUAN          32
#define ITEMSIZE_COST_NO_CONTAINER 1000

// Container sizes.  Note that different containers can hold a maximum ITEMSIZE.
#define INVENTORY_STANDARD_SPACE	ITEMSIZE_COST_NORMAL * 7 // 28
#define INVENTORY_DUFFLEBAG_SPACE	ITEMSIZE_COST_NORMAL * 9 // 36
#define INVENTORY_BOX_SPACE			ITEMSIZE_COST_SMALL * 4 // 8
