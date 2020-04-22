
/obj/structure/bed/covenant
	name = "Sangheili bed"
	desc = "Not designed for comfort."'
	icon = 'code/modules/halo/covenant/structures_machines/bed.dmi'
	icon_state = "cbed1"

/obj/structure/bed/covenant/update_icon()

/obj/structure/bed/covenant/heirarch
	name = "heirarch's bed"
	desc = "Advanced technology makes this bed extremely comfortable."
	icon_state = "hbed1"

/obj/structure/bed/grunt
	icon = 'code/modules/halo/covenant/structures_machines/bed.dmi'
	icon_state = "cushion1"
/obj/structure/bed/grunt/update_icon()

/obj/structure/bed/grunt/New()
	. = ..()
	icon_state = "cushion[rand(1,3)]"
