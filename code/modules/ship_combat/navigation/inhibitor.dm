/obj/machinery/space_battle/engine_inhibitor
	name = "Engine Inhibitor"
	desc = "Applies a short burst of severe gravitational force to all ships within a range of 2 sectors"
	icon_state = "inhibitor"
	anchored = 1
	density = 1
	var/cooldown_time = 0

	New()
		..()
		var/area/ship_battle/A = get_area(src)
		if(A && istype(A))
			req_access = list(A.team*10 - SPACE_NAVIGATION)

	attack_hand(var/mob/user)
		if(cooldown_time >= world.timeofday)
			user << "<span class='warning'>\The [src] cannot activate again for another [round((cooldown_time - world.timeofday)/10)] seconds</span>"
			return
		else if(!circuit_board)
			user << "<span class='warning'>\The [src] does not have a circuit!</span>"
			return
		else if(get_efficiency(1,0) < 50)
			user << "<span class='warning'>The circuit inside \the [src] is not efficient enough to power \the [src]!</span>"
			return
		if(!allowed(user))
			user << "<span class='warning'>You do not have access to use this machinery!</span>"
			return
		else if(alert(user,"Are you sure you want to activate the inhibitor? Do this only when near other ships, or you'll get stuck!", "Engine Inhibitor", "Yes", "No.") == "Yes")
			user.visible_message("<span class='danger'>\The [user] activates \the [src]!</span>")
			var/obj/effect/overmap/ship/linked = map_sectors["[z]"]
			for(var/obj/effect/overmap/ship/S in range(3, linked))
				world << "<span class='notice'>Ship: [S] in distance!</span>"
				S.speed = list(0, 0)
				for(var/obj/machinery/space_battle/computer/engine_control/E in S.eng_controls)
					E.stopped(1)
				for(var/mob/living/M in world)
					if(M.z == S.map_z)
						M << "<span class='danger'>You feel a violent force push against you!</span>"
						var/mob/living/carbon/human/H = M
						if(H && istype(H))
							H.Weaken(10)
			cooldown_time = world.timeofday + 12000 // 10 minutes
			use_power(100000)
			circuit_board.ex_act(1)
			circuit_board.emp_act(1)
			spawn(10)
				src.visible_message("<span class='warning'>\The [src] spits out \the [circuit_board]</span>")
				circuit_board.forceMove(get_turf(src))
				circuit_board = null
