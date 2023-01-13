/area
	var/gravstat = AREA_GRAVITY_NORMAL

/area/Initialize()
	. = ..()
	switch(gravstat)
		if(AREA_GRAVITY_NEVER)
			has_gravity = 0
		if(AREA_GRAVITY_ALWAYS)
			has_gravity = 1


// /has_gravity(atom/AT)
// 	var/area/A = get_area(AT)
// 	if(istype(A) && A?.has_gravity())
// 		. = TRUE
