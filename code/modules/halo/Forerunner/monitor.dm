//monitor death beam

/obj/item/weapon/gun/energy/charged/spartanlaser/monitor
	name = "Monitor beam"
	one_hand_penalty = 0
	self_recharge = 1
	recharge_time = 0

//frenly monitor

/mob/living/simple_animal/monitor
	name = "monitor"
	desc = "An incredibly advanced AI made from ancient alien technology."
	icon = 'code/modules/halo/Forerunner/Monitor.dmi'
	icon_state = "monitor"
	icon_living = "monitor"
	icon_dead = "monitor_dead"
	speak_chance = 5
	health = 9999999999
	maxHealth = 9999999999
	resistance = 1000
	speak = list("Let's see now...","Hmm, ah!","Oh dear","Oh, that's a good idea","Hah I am a genius","I am a genius hahahaha","Ah!")
	var/obj/item/weapon/gun/energy/charged/spartanlaser/monitor/monitorbeam

/mob/living/simple_animal/monitor/New()
	. = ..()
	monitorbeam = new

/mob/living/simple_animal/monitor/IsAdvancedToolUser()
	return 1

/mob/living/simple_animal/monitor/death(gibbed, deathmessage = "explodes!", show_dead_message = 1)
	var/turf/T = get_turf(src)
	. = ..(gibbed, deathmessage, show_dead_message)
	explosion(T, 2, 4, 6, 8, adminlog = 0)
	new /obj/effect/gibspawner/robot(T)

//angery monitor

/mob/living/simple_animal/hostile/monitor
	name = "Monitor"
	desc = "An incredibly advanced AI made from ancient alien technology."
	icon = 'code/modules/halo/Forerunner/Monitor.dmi'
	icon_state = "monitor"
	icon_living = "monitor"
	icon_dead = "monitor_dead"
	speak_chance = 5
	health = 9999999999
	maxHealth = 9999999999
	resistance = 1000
	speak = list("Let's see now...","Hmm, ah!","Oh dear","Oh, that's a good idea","Hah I am a genius","I am a genius hahahaha","Ah!",\
		"You have endangered my installation!",\
		"Your recklessness threatens us all!",\
		"I cannot believe my makers let you live.",\
		"The installation... it is mine!",\
		"We must enact containment protocols! No more delay!")
	var/obj/item/weapon/gun/energy/charged/spartanlaser/monitor/monitorbeam

/mob/living/simple_animal/hostile/monitor/New()
	. = ..()
	monitorbeam = new

/mob/living/simple_animal/hostile/monitor/IsAdvancedToolUser()
	return 1

/mob/living/simple_animal/hostile/monitor/death(gibbed, deathmessage = "explodes!", show_dead_message = 1)
	var/turf/T = get_turf(src)
	. = ..(gibbed, deathmessage, show_dead_message)
	explosion(T, 2, 4, 6, 8, adminlog = 0)
	new /obj/effect/gibspawner/robot(T)
