#define FLUID_PUSH_THRESHOLD 30
#define FLUID_PROCESSING_OFFSET 1
#define FLUID_SCHEDULE_INTERVAL 2
#define FLUID_EVAPORATION_POINT 10
#define FLUID_DROWN_LEVEL_RESTING 30
#define FLUID_DROWN_LEVEL_STANDING 70
#define FLUID_DELETING -1

var/global/fluid_controller_exists         // Todo make this a better check for an existing fluid controller datum.
var/global/image/fluid_image               // Shared overlay for all fluid turfs (to sync animation)
var/global/list/new_fluids =        list() // Fluids spawned this processor cycle.
var/global/list/processing_fluids = list() // Fluids that need to spread next processor cycle.
var/global/list/updating_fluids =   list() // Fluids that have been updated this processor cycle and need an icon refresh.
