////
// Fluid controller!
////

#define FLUID_PROCESSING_OFFSET 3          // Ticks for various non-cycle-locked behaviors
#define FLUID_SCHEDULE_INTERVAL 5          // Ticks per cycle
#define FLUID_PUSH_THRESHOLD 30            // Depth that will shove a mob when flowing
#define FLUID_EVAPORATION_POINT 10         // Depth a fluid begins self-deleting
#define FLUID_DELETING -1                  // Depth a fluid counts as qdel'd
#define FLUID_DROWN_LEVEL_RESTING 30       // Depth a resting mob drowns
#define FLUID_DROWN_LEVEL_STANDING 70      // Depth a standing mob drowns
#define FLUID_SHALLOW 15                   // Depth shallow icon is used
#define FLUID_DEEP 80                      // Depth deep icon is used
#define FLUID_PROCESSING_CUTOFF 1000       // Max number of fluids to check per list per cycle.

var/global/fluid_controller_exists         // Todo make this a better check for an existing fluid controller datum.
var/global/list/fluid_images =      list() // Shared overlays for all fluid turfs (to sync animation)
var/global/list/new_fluids =        list() // Fluids spawned this processor cycle.
var/global/list/processing_fluids = list() // Fluids that need to spread next processor cycle.
var/global/list/updating_fluids =   list() // Fluids that have been updated this processor cycle and need an icon refresh.
