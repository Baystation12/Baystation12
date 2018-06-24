/mob/living/carbon/proc/obsession()
	var/obsession_time = 30 SECONDS

	Sleeping(5)
	spawn(3 SECOND)
		set_fullscreen(TRUE, "red", /obj/screen/fullscreen/red)
		sleep(2 SECONDS)

		var/list/images = list()

		var/list/possible_positions = list()
		for (var/turf/simulated/floor/F in view(src, 3))
			possible_positions += F

		for (var/i = 0; i < min(possible_positions.len, 10); i++)
			var/turf/L = pick(possible_positions)
			possible_positions -= L

			var/image/I = image('icons/effects/blood.dmi', pick("mfloor1", "mfloor2", "mfloor3", "mfloor4", "mfloor5", "mfloor6", "mfloor7"))
			I.loc = L
			I.color = COLOR_BLOOD_HUMAN

			client.images += I
			images += I

		while (obsession_time)
			obsession_time = max(0, obsession_time - 1 SECOND)
			sleep(1 SECOND)

		Sleeping(5)
		sleep(3 SECOND)
		clear_fullscreen("red")
		client.images -= images
