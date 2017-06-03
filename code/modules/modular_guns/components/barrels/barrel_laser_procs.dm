// Laser barrel helpers.
/proc/get_laser_type_from_caliber(var/caliber)
	switch(caliber)
		if(CALIBER_STAFF_FORCE)
			return /obj/item/projectile/forcebolt
		if(CALIBER_STAFF_ANIMATE)
			return /obj/item/projectile/animate
		if(CALIBER_LASER_SHOTGUN)
			return /obj/item/projectile/bullet/pellet/laser
		if(CALIBER_LASER_ION)
			return /obj/item/projectile/ion
		if(CALIBER_LASER_PULSE)
			return /obj/item/projectile/beam/pulse
		if(CALIBER_LASER_PRACTICE)
			return /obj/item/projectile/beam/practice
		if(CALIBER_LASER_MID)
			return /obj/item/projectile/beam/midlaser
		if(CALIBER_LASER_HEAVY)
			return /obj/item/projectile/beam/heavylaser
		if(CALIBER_LASER_XRAY)
			return /obj/item/projectile/beam/xray
		if(CALIBER_LASER_INDUSTRIAL)
			return /obj/item/projectile/beam/emitter
		if(CALIBER_LASER_PRECISION)
			return /obj/item/projectile/beam/sniper
		if(CALIBER_LASER_SHOCK, CALIBER_LASER_TASER)
			return /obj/item/projectile/beam/stun
	return /obj/item/projectile/beam

/proc/get_fire_sound_from_caliber(var/caliber)
	switch(caliber)
		if(CALIBER_LASER_PULSE)
			return 'sound/weapons/pulse.ogg'
		if(CALIBER_LASER_HEAVY)
			return 'sound/weapons/lasercannonfire.ogg'
		if(CALIBER_LASER_XRAY)
			return 'sound/weapons/laser3.ogg'
		if(CALIBER_LASER_INDUSTRIAL, CALIBER_STAFF_ANIMATE, CALIBER_STAFF_CHANGE, CALIBER_STAFF_FORCE)
			return 'sound/weapons/emitter.ogg'
		if(CALIBER_LASER_PRECISION)
			return 'sound/weapons/marauder.ogg'
		if(CALIBER_LASER_SHOCK, CALIBER_LASER_TASER)
			return 'sound/weapons/Taser.ogg'
	return 'sound/weapons/Laser.ogg'

/proc/get_laser_cost_from_caliber(var/caliber)
	switch(caliber)
		if(CALIBER_LASER_PULSE, CALIBER_LASER_INDUSTRIAL)
			return 400
		if(CALIBER_LASER_HEAVY, CALIBER_LASER_PRECISION)
			return 300
		if(CALIBER_LASER_SHOCK, CALIBER_LASER_TASER)
			return 100
	return 200