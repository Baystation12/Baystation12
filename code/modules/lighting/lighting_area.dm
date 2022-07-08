/area/luminosity = TRUE
/// Boolean. Whether or not the area should process dynamic lighting. Affects the value of `luminosity` during init and the lighting effects on turfs in the area.
/area/var/dynamic_lighting = TRUE
/// String (One of `AREA_LIGHTING_*`). The light tone selection mode used for the area. See `code\__defines\lighting.dm` for possible values.
/area/var/lighting_tone = AREA_LIGHTING_DEFAULT

/area/New()
	..()
	if(dynamic_lighting)
		luminosity = FALSE
