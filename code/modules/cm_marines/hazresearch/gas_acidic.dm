/obj/effect/biohazard/gas/acidic
	name = "gas"
	desc = "That doesn't look pleasant to breathe."
	icon_state = ""

	density = 0
	opacity = 0
	anchored = 1

	strength = 0.4
	health = 100
	property = "acid"

/obj/effect/biohazard/gas/acidic/process()
	lifespancheck()

	var/turf/T = src.loc

	if(!T) //No turf found, abort!
		return

	for(var/mob/living/carbon/human/L in T)
		if(L && L.head)
			if(!istype(L.head, /obj/item/clothing/head/helmet/bio/marine))
				L.adjustFireLoss(-strength)
		if(L && L.wear_suit)
			if(!istype(L.wear_suit, /obj/item/clothing/suit/bio/marine))
				L.adjustFireLoss(-strength)

	health -= 0.4