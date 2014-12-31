/obj/effect/biohazard/gas
	name = "gas"
	desc = "That doesn't look pleasant to breathe."
	icon_state = ""
	icon = ""
	density = 0
	opacity = 0
	anchored = 1

	var/strength = 0.8
	var/health = 100
	var/property = ""


/obj/effect/biohazard/gas/New()
	..()
	processing_objects.Add(src)


/obj/effect/biohazard/gas/Del()
	processing_objects.Remove(src)
	..()

/obj/effect/biohazard/gas/proc/lifespancheck()
	if(health <= 0)
		del(src)
