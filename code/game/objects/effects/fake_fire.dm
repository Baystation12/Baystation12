/obj/effect/fake_fire
	blend_mode = BLEND_ADD
	icon = 'icons/effects/fire.dmi'
	icon_state = "3"
	layer = FIRE_LAYER
	var/lifetime = 10 SECONDS //0 for infinite
	//See Fire.dm (the real one), but in a nutshell:
	var/firelevel = 0 //Larger the number, worse burns.
	var/last_temperature = 0 //People with heat protection above this temp will be immune.
	var/pressure = 0 //Larger the number, worse burns.

/obj/effect/fake_fire/New()
	..()
	set_light(0.5, 1, 3, l_color = color)
	START_PROCESSING(SSobj,src)
	if(lifetime)
		QDEL_IN(src,lifetime)

/obj/effect/fake_fire/Process()
	for(var/mob/living/L in loc)
		L.FireBurn(firelevel,last_temperature,pressure)
	loc.fire_act(firelevel,last_temperature,pressure)
	for(var/atom/A in loc)
		A.fire_act(firelevel,last_temperature,pressure)

/obj/effect/fake_fire/Destroy()
	STOP_PROCESSING(SSobj,src)
	..()