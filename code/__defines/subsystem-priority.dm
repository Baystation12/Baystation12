// Something to remember when setting priorities: SS_TICKER runs before Normal, which runs before SS_BACKGROUND.
// Each group has its own priority bracket.
// SS_BACKGROUND handles high server load differently than Normal and SS_TICKER do.
// Higher priority also means a larger share of a given tick before sleep checks.

// SS_TICKER
// < none >

#define SS_PRIORITY_DEFAULT 50          // Default priority for both normal and background processes

// Normal
#define SS_PRIORITY_MOB            100	// Mob Life().
#define SS_PRIORITY_MACHINERY      100	// Machinery + powernet ticks.
#define SS_PRIORITY_AIR            80	// ZAS processing.
#define SS_PRIORITY_AIRFLOW        15	// Object movement from ZAS airflow.

// SS_BACKGROUND
#define SS_PRIORITY_OBJECTS       60	// processing_objects processing.
#define SS_PRIORITY_PROCESSING    30	// Generic datum processor. Replaces objects processor.
#define SS_PRIORITY_GARBAGE       25	// Garbage collection.
#define SS_PRIORITY_VINES         25	// Spreading vine effects.
#define SS_PRIORITY_WIRELESS      10	// Wireless connection setup.
