/obj/item/grenade/anti_photon
	desc = "An experimental device for temporarily removing light in a limited area."
	name = "photon disruption grenade"
	icon_state = "emp"
	item_state = "emp"
	det_time = 20
	origin_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 4)

/obj/item/grenade/anti_photon/detonate(mob/living/user)
	playsound(src.loc, 'sound/effects/phasein.ogg', 50, 1, 5)
	set_light(10, -10, "#ffffff")
	addtimer(new Callback(src, PROC_REF(finish)), rand(20 SECONDS, 29 SECONDS))

/obj/item/grenade/anti_photon/proc/finish()
	set_light(10, 10, "#[num2hex(rand(64,255))][num2hex(rand(64,255))][num2hex(rand(64,255))]")
	playsound(loc, 'sound/effects/bang.ogg', 50, 1, 5)
	sleep(1 SECOND)
	qdel(src)
