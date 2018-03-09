
/obj/structure/tree/palm
	name = "palm tree"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "palm1"
	woodleft = 2

/obj/structure/tree/palm/New()
	..()
	icon_state = "palm[rand(1,2)]"

/obj/structure/tree/palm_giant
	name = "palm tree"
	icon = 'code/modules/halo/icons/doodads/trees.dmi'
	icon_state = "palm1"
	woodleft = 5

/obj/structure/tree/palm_giant/New()
	..()
	if(prob(50))
		icon_state = "palm2"
