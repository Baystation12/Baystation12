#include "_flora.dm"
#include "_tree.dm"

/obj/structure/tree/palm
	name = "palm tree"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "palm1"
	woodleft = 2

/obj/structure/tree/palm/New()
	..()
	if(prob(50))
		icon_state = "palm2"

/obj/effect/flora/desert/pick_icon_state()
	name = pick(\
		"yellow flowers",\
		"sunny bush",\
		"sparse grass")
	switch(name)
		if("yellow flowers")
			icon_state = "ywflowers_[rand(1,4)]"
		if("sunny bush")
			icon_state = "sunnybush_[rand(1,3)]"
		if("sparse grass")
			icon_state = "sparsegrass_[rand(1,3)]"
