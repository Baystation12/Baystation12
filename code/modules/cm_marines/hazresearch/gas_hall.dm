/obj/effect/biohazard/gas/hallucigen
	name = "gas"
	desc = "That doesn't look pleasant to breathe."
	icon_state = ""

	density = 0
	opacity = 0
	anchored = 1

	strength = 15
	health = 100
	property = "hallucigen"

/obj/effect/biohazard/gas/hallucigen/process()
	lifespancheck()

	var/turf/T = src.loc

	if(!T) //No turf found, abort!
		return

	for(var/mob/living/carbon/human/L in T)
		if(L && L.head)
			if(!istype(L.head, /obj/item/clothing/head/helmet/bio/marine))
				L.hallucination += strength

	health -= 0.4