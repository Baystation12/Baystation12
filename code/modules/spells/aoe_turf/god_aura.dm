/spell/aoe_turf/god_aura
	name = "Converting Aura"
	desc = "Convert nearby flooring into a more palatable environment for your master."

	charge_max = 30
	spell_flags = Z2NOCAST|IGNORESPACE|IGNOREDENSE
	invocation = "none"
	invocation_type = SpI_NONE
	range = 3

	number_of_channels = 0 //Infinite
	time_between_channels = 30 //3 seconds
	hud_state = "const_floor"
	cast_sound = 'sound/effects/bang.ogg'

/spell/aoe_turf/god_aura/cast_check(skipcharge = 0,mob/user = usr, var/list/targets)
	if(!..(skipcharge, user, targets))
		return 0
	if(skipcharge)
		return 1

	if(connected_god && connected_god.near_structure(user))
		return 1

	to_chat(user,"<span class='warning'>You need to be near one of your master's important structures to do that!</span>")
	return 0

/spell/aoe_turf/god_aura/cast(var/list/targets, var/mob/user)
	while(targets.len)
		var/turf/T = pick(targets)
		targets -= T
		if(istype(T, /turf/simulated/floor/deity))
			var/turf/simulated/floor/deity/D = T
			if(D.linked_god == connected_god)
				continue
		var/turf/simulated/floor/deity/D = T.ChangeTurf(/turf/simulated/floor/deity)
		D.sync_god(connected_god)
		return