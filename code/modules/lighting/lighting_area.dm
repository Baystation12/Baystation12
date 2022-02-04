/area/luminosity = TRUE
/area/var/dynamic_lighting = TRUE
/// The light tone selection mode used for the area
/area/var/lighting_tone = AREA_LIGHTING_DEFAULT

/area/New()
	..()
	if(dynamic_lighting)
		luminosity = FALSE
