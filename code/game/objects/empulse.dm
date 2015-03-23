proc/empulse(turf/epicenter, heavy_range, medium_range, light_range, log=0)
	if(!epicenter) return

	if(!istype(epicenter, /turf))
		epicenter = get_turf(epicenter.loc)

	if(log)
		message_admins("EMP with size ([heavy_range], [light_range]) in area [epicenter.loc.name] ")
		log_game("EMP with size ([heavy_range], [light_range]) in area [epicenter.loc.name] ")

	if(heavy_range > 1 || (medium_range > 1 && prob(75)) || (light_range > 1 && prob(25)))
		var/obj/effect/overlay/pulse = new/obj/effect/overlay ( epicenter )
		pulse.icon = 'icons/effects/effects.dmi'
		pulse.icon_state = "emppulse"
		pulse.name = "emp pulse"
		pulse.anchored = 1
		spawn(20)
			pulse.delete()

	if(heavy_range > medium_range)
		medium_range = heavy_range
	if(medium_range > light_range)
		light_range = medium_range

	for(var/mob/M in range(heavy_range, epicenter))
		M << 'sound/effects/EMPulse.ogg'

	for(var/atom/T in range(light_range, epicenter))
		var/distance = get_dist(epicenter, T)
		if(distance < 0)
			distance = 0
		if(distance < heavy_range)
			T.emp_act(1)
		else if(distance == heavy_range)
			T.emp_act(rand(1,2))
		else if(distance < medium_range)
			T.emp_act(2)
		else if(distance == medium_range)
			T.emp_act(rand(2,3))
		else if(distance <= light_range)
			T.emp_act(3)
	return 1