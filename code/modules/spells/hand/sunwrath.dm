/spell/hand/duration/sunwrath
	name = "sun god's wrath"
	desc = "Your hands become a gateway of fire, shooting hot plasma from your fingertips."
	spell_flags = 0
	charge_max = 600
	invocation_type = SpI_SHOUT
	invocation = "Herald! Bless me with your anger!"
	show_message = " erupts fire from their hands"
	school = "Divine"
	hand_duration = 100
	spell_delay = 30
	range = 4

	hud_state = "wiz_immolate"

/spell/hand/duration/sunwrath/cast_hand(var/atom/A, var/mob/user)
	var/turf/T = get_turf(user)
	var/list/turfs = getline(T,A) - T
	for(var/t in turfs)
		var/turf/turf = t
		if(turf.density || istype(turf, /turf/space))
			break
		new /obj/effect/sunwrath(t)
	return 1

/obj/effect/sunwrath
	blend_mode = BLEND_ADD
	icon = 'icons/effects/fire.dmi'
	icon_state = "3"

/obj/effect/sunwrath/New()
	..()
	START_PROCESSING(SSobj,src)
	QDEL_IN(src,100)

/obj/effect/sunwrath/Process()
	for(var/mob/living/L in loc)
		L.FireBurn(2,0,3000,ONE_ATMOSPHERE)