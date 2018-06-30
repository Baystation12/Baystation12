// Something to remember when setting priorities: SS_TICKER runs before Normal, which runs before SS_BACKGROUND.
// Each group has its own priority bracket.
// SS_BACKGROUND handles high server load differently than Normal and SS_TICKER do.
// Higher priority also means a larger share of a given tick before sleep checks.

#define SS_PRIORITY_DEFAULT 50          // Default priority for all processes levels

// SS_TICKER
#define SS_PRIORITY_ICON_UPDATE    20	// Queued icon updates. Mostly used by APCs and tables.

// Normal
#define SS_PRIORITY_MOB            100	// Mob Life().
#define SS_PRIORITY_MACHINERY      100	// Machinery + powernet ticks.
#define SS_PRIORITY_AIR            80	// ZAS processing.
#define SS_PRIORITY_ALARM          20   // Alarm processing.
#define SS_PRIORITY_EVENT          20   // Event processing and queue handling.
#define SS_PRIORITY_SHUTTLE        20   // Shuttle movement.
#define SS_PRIORITY_RADIATION      20   // Radiation processing and cache updates.
#define SS_PRIORITY_AIRFLOW        15	// Object movement from ZAS airflow.
#define SS_PRIORITY_INACTIVITY     10	// Idle kicking.
#define SS_PRIORITY_SUPPLY         10   // Supply point accumulation.
#define SS_PRIORITY_TRADE          10   // Adds/removes traders.

// SS_BACKGROUND
#define SS_PRIORITY_OBJECTS       60	// processing_objects processing.
#define SS_PRIORITY_PROCESSING    30	// Generic datum processor. Replaces objects processor.
#define SS_PRIORITY_GARBAGE       25	// Garbage collection.
#define SS_PRIORITY_VINES         25	// Spreading vine effects.
#define SS_PRIORITY_TURF          20    // Radioactive walls/blob.
#define SS_PRIORITY_EVAC          20    // Processes the evac controller.
#define SS_PRIORITY_WIRELESS      10	// Wireless connection setup.


// Subsystem fire priority, from lowest to highest priority
// If the subsystem isn't listed here it's either DEFAULT or PROCESS (if it's a processing subsystem child)
