//TODO: Flash range does nothing currently

//A very crude linear approximatiaon of pythagoras theorem.
/proc/cheap_pythag(var/dx, var/dy)
	dx = abs(dx); dy = abs(dy);
	if(dx>=dy)	return dx + (0.5*dy)	//The longest side add half the shortest side approximates the hypotenuse
	else		return dy + (0.5*dx)

//Moved this implementation of explosions in -- seems to do a very nice job.
proc/explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog = 1)
	spawn(0)
		var/start = world.timeofday
		epicenter = get_turf(epicenter)
		if(!epicenter) return

		if(adminlog)
			message_admins("Explosion with size ([devastation_range], [heavy_impact_range], [light_impact_range]) in area [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[epicenter.x];Y=[epicenter.y];Z=[epicenter.z]'>JMP</a>)")
			log_game("Explosion with size ([devastation_range], [heavy_impact_range], [light_impact_range]) in area [epicenter.loc.name] ")

		playsound(epicenter, 'sound/effects/explosionfar.ogg', 100, 1, round(devastation_range*2,1) )
		playsound(epicenter, "explosion", 100, 1, round(devastation_range,1) )

		if(defer_powernet_rebuild != 2)
			defer_powernet_rebuild = 1

		if(heavy_impact_range > 1)
			var/datum/effect/system/explosion/E = new/datum/effect/system/explosion()
			E.set_up(epicenter)
			E.start()

		var/x = epicenter.x
		var/y = epicenter.y
		var/z = epicenter.z

		if(devastation_range > 0)
			explosion_turf(x,y,z,1)
		else
			devastation_range = 0
			if(heavy_impact_range > 0)
				explosion_turf(x,y,z,2)
			else
				heavy_impact_range = 0
				if(light_impact_range > 0)
					explosion_turf(x,y,z,3)
				else
					return

		//Diamond 'splosions (looks more round than square version)
		for(var/i=0, i<devastation_range, i++)
			for(var/j=0, j<i, j++)
				explosion_turf((x-i)+j, y+j, z, 1)
				explosion_turf(x+j, (y+i)-j, z, 1)
				explosion_turf((x+i)-j, y-j, z, 1)
				explosion_turf(x-j, (y-i)+j, z, 1)

		for(var/i=devastation_range, i<heavy_impact_range, i++)
			for(var/j=0, j<i, j++)
				explosion_turf((x-i)+j, y+j, z, 2)
				explosion_turf(x+j, (y+i)-j, z, 2)
				explosion_turf((x+i)-j, y-j, z, 2)
				explosion_turf(x-j, (y-i)+j, z, 2)

		for(var/i=heavy_impact_range, i<light_impact_range, i++)
			for(var/j=0, j<i, j++)
				explosion_turf((x-i)+j, y+j, z, 3)
				explosion_turf(x+j, (y+i)-j, z, 3)
				explosion_turf((x+i)-j, y-j, z, 3)
				explosion_turf(x-j, (y-i)+j, z, 3)

		if(defer_powernet_rebuild != 2)
			defer_powernet_rebuild = 0

		diary << "## Explosion([x],[y],[z])(d[devastation_range],h[heavy_impact_range],l[light_impact_range]): Took [(world.timeofday-start)/10] seconds."
	return 1

proc/explosion_turf(var/x,var/y,var/z,var/force)
	var/turf/T = locate(x,y,z)
	if(T)
		T.ex_act(force)
		if(T)
			for(var/atom/movable/AM in T.contents)
				AM.ex_act(force)

	return

proc/secondaryexplosion(turf/epicenter, range)
	for(var/turf/tile in trange(range, epicenter))
		tile.ex_act(2)