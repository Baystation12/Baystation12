/obj/item/weapon/tank/jetpack/verb/moveup()
	set name = "Move Upwards"
	set category = "Object"
	if(allow_thrust(0.01, usr))
		var/turf/controllerlocation = locate(1, 1, usr.z)
		var/legal = 0
		for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
			legal = controller.up
			if (controller.up)
				var/turf/T = locate(usr.x, usr.y, controller.up_target)
				if(T && (istype(T, /turf/space) || istype(T, /turf/simulated/floor/open)))
					var/blocked = 0
					for(var/atom/A in T.contents)
						if(A.density)
							blocked = 1
							usr << "\red You bump into [A.name]."
							break
					if(!blocked)
						usr.Move(T)
						usr << "You move upwards."
				else
					usr << "\red There is something in your way."
		if (legal == 0)
			usr << "There is nothing of interest in this direction."
	return 1

/obj/item/weapon/tank/jetpack/verb/movedown()
	set name = "Move Downwards"
	set category = "Object"
	if(allow_thrust(0.01, usr))
		var/turf/controllerlocation = locate(1, 1, usr.z)
		var/legal = 0
		for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
			legal = controller.down
			if (controller.down == 1)
				var/turf/T = locate(usr.x, usr.y, controller.down_target)
				var/turf/S = locate(usr.x, usr.y, usr.z)
				if(T && (istype(S, /turf/space) || istype(S, /turf/simulated/floor/open)))
					var/blocked = 0
					for(var/atom/A in T.contents)
						if(A.density)
							blocked = 1
							usr << "\red You bump into [A.name]."
							break
					if(!blocked)
						usr.Move(T)
						usr << "You move downwards."
				else
					usr << "\red You cant move through the floor."
		if (legal == 0)
			usr << "There is nothing of interest in this direction."
	return 1
