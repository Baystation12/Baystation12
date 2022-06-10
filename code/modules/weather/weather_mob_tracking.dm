
var/global/list/current_mob_ambience = list()
/obj/abstract/weather_system

	// Weakref lists used to track mobs within our weather 
	// system; alternative to keeping big lists of actual mobs or 
	// having mobs constantly poked by weather systems.

	var/tmp/list/mobs_on_cooldown =   list() // Has this mob recently been messed with by the weather?
	var/tmp/list/mob_shown_weather =  list() // Has this mob been sent the summary message about the current weather?
	var/tmp/list/mob_shown_wind =     list() // Has this mob been sent the summary message about the current wind?

// 'cooldown' in this context refers to weather effects like hail damage or being shown cosmetic messages.
/obj/abstract/weather_system/proc/set_cooldown(var/mob/living/M, var/delay = 5 SECONDS)
	var/mobref = weakref(M)
	if(!(mobref in mobs_on_cooldown))
		mobs_on_cooldown[mobref] = TRUE
		addtimer(CALLBACK(src, .proc/clear_cooldown, mobref), delay)
		return TRUE
	return FALSE

/obj/abstract/weather_system/proc/clear_cooldown(var/mobref)
	mobs_on_cooldown -= mobref
