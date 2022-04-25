#define COMPASS_INTERVAL       3
#define COMPASS_PERIOD        15
#define COMPASS_LABEL_OFFSET 150

/*
  This folder contains an abstract type (/obj/compass_holder) which contains a set of 
  waypoints (/datum/compass_waypoint) and generates a circular compass with markers for 
  mobs that have the object in their screen list. See GPS for an example implementation.
*/

/image/compass_marker
	maptext_height = 64
	maptext_width = 128
	maptext_x = -48
	maptext_y = -32
