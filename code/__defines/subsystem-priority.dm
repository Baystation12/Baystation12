// Something to remember when setting priorities: SS_TICKER runs before Normal, which runs before SS_BACKGROUND.
// Each group has its own priority bracket.
// SS_BACKGROUND handles high server load differently than Normal and SS_TICKER do.

// SS_TICKER
// < none >

// Normal
#define SS_PRIORITY_MOB            100	// Mob Life().
#define SS_PRIORITY_MACHINERY      100	// Machinery + powernet ticks.
#define SS_PRIORITY_AIR            80	// ZAS processing.
#define SS_PRIORITY_AIRFLOW        15	// Object movement from ZAS airflow.

// SS_BACKGROUND
#define SS_PRIORITY_PROCESSING    25	// Generic datum processor. Replaces objects processor.
#define SS_PRIORITY_OBJECTS       15	// processing_objects processing.
#define SS_PRIORITY_GARBAGE       15	// Garbage collection.
