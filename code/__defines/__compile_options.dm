#define BACKGROUND_ENABLED 0    // The default value for all uses of set background. Set background can cause gradual lag and is recommended you only turn this on if necessary.
								// 1 will enable set background. 0 will disable set background.

// If we are doing the map test build, do not include the main maps, only the submaps.
#if MAP_TEST
	#define USING_MAP_DATUM /datum/map
	#define MAP_OVERRIDE 1
#endif
