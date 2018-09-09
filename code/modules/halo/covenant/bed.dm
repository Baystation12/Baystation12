
/obj/structure/bed/covenant
	name = "Sangheili bed"
	desc = "Not designed for comfort."
	icon = 'bed.dmi'

/obj/structure/bed/grunt
	icon = 'bed.dmi'
	icon_state = "cushion1"

/obj/structure/bed/grunt/New()
	. = ..()
	icon_state = "cushion[rand(1,3)]"
