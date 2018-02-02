/area
	luminosity           = TRUE
	var/dynamic_lighting = TRUE

/area/Initialize()
	.=..()
	if(dynamic_lighting)
		luminosity = FALSE