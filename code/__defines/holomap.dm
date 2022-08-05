//
// Constants and standard colors for the holomap
//

#define HOLOMAP_ICON 'icons/480x480.dmi' // Icon file to start with when drawing holomaps (to get a 480x480 canvas).
#define HOLOMAP_ICON_SIZE 480 // Pixel width & height of the holomap icon.  Used for auto-centering etc.
#define HOLOMAP_MARGIN 100 // minimum marging on sides when combining maps
#define UI_HOLOMAP "CENTER-7, CENTER-7" // Screen location of the holomap "hud"

// Holomap colors
#define HOLOMAP_OBSTACLE "#ffffffdd"	// Color of walls and barriers
#define HOLOMAP_PATH     "#66666699"	// Color of floors
#define HOLOMAP_HOLOFIER "#79ff79"	// Whole map is multiplied by this to give it a green holoish look

#define HOLOMAP_AREACOLOR_BASE        "#ffffffff"
#define HOLOMAP_AREACOLOR_COMMAND     "#386d8099"
#define HOLOMAP_AREACOLOR_SECURITY    "#ae121299"
#define HOLOMAP_AREACOLOR_MEDICAL     "#ffffffa5"
#define HOLOMAP_AREACOLOR_SCIENCE     "#f45dff99"
#define HOLOMAP_AREACOLOR_EXPLORATION "#a154a699"
#define HOLOMAP_AREACOLOR_ENGINEERING "#f1c23199"
#define HOLOMAP_AREACOLOR_CARGO       "#e06f0099"
#define HOLOMAP_AREACOLOR_HALLWAYS    "#ffffff66"
#define HOLOMAP_AREACOLOR_AIRLOCK     "#0000ffcc"
#define HOLOMAP_AREACOLOR_ESCAPE      "#ff0000cc"
#define HOLOMAP_AREACOLOR_CREW        "#5bc1c199"
// If someone can come up with a non-conflicting color for the lifts, please update this.
#define HOLOMAP_AREACOLOR_LIFTS       null

// Handy defines to lookup the pixel offsets for holomap
// Currently set to 0, left here in case of need for per map offsets
#define HOLOMAP_PIXEL_OFFSET_X (0)
#define HOLOMAP_PIXEL_OFFSET_Y (0)

#define HOLOMAP_LEGEND_X 96
#define HOLOMAP_LEGEND_Y 156
