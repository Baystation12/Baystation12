// Shamelessly stolen from Urist McStation. Thanks!

/obj/structure/stool/bed/chair/couch
	name = "couch"
	desc = "A couch. Looks pretty comfortable."
	icon = 'icons/obj/Nienplants&Couch.dmi'
	icon_state = "chair"
	color = rgb(255,255,255)
	var/image/armrest = null
	var/couchpart = 0 //0 = middle, 1 = left, 2 = right

/obj/structure/stool/bed/chair/couch/New()
	if(couchpart == 1)
		armrest = image("icons/urist/structures&machinery/Nienplants&Couch.dmi", "armrest_left")
		armrest.layer = MOB_LAYER + 0.1
	else if(couchpart == 2)
		armrest = image("icons/urist/structures&machinery/Nienplants&Couch.dmi", "armrest_right")
		armrest.layer = MOB_LAYER + 0.1

	return ..()

/obj/structure/stool/bed/chair/couch/afterbuckle()
	if(buckled_mob)
		overlays += armrest
	else
		overlays -= armrest

/obj/structure/stool/bed/chair/couch/left
	couchpart = 1
	icon_state = "couch_left"

/obj/structure/stool/bed/chair/couch/right
	couchpart = 2
	icon_state = "couch_right"

/obj/structure/stool/bed/chair/couch/middle
	icon_state = "couch_middle"

/obj/structure/stool/bed/chair/couch/left/black
	color = rgb(167,164,153)

/obj/structure/stool/bed/chair/couch/right/black
	color = rgb(167,164,153)

/obj/structure/stool/bed/chair/couch/middle/black
	color = rgb(167,164,153)

/obj/structure/stool/bed/chair/couch/left/teal
	color = rgb(0,255,255)

/obj/structure/stool/bed/chair/couch/right/teal
	color = rgb(0,255,255)

/obj/structure/stool/bed/chair/couch/middle/teal
	color = rgb(0,255,255)

/obj/structure/stool/bed/chair/couch/left/beige
	color = rgb(255,253,195)

/obj/structure/stool/bed/chair/couch/right/beige
	color = rgb(255,253,195)

/obj/structure/stool/bed/chair/couch/middle/beige
	color = rgb(255,253,195)

/obj/structure/stool/bed/chair/couch/left/brown
	color = rgb(255,113,0)

/obj/structure/stool/bed/chair/couch/right/brown
	color = rgb(255,113,0)

/obj/structure/stool/bed/chair/couch/middle/brown
	color = rgb(255,113,0)


/obj/structure/stool/bed/chair/couch/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		new /obj/item/stack/sheet/metal(src.loc)
		del(src)
	else
		..()


//UMcS Flora, because /tg/.dm's.
//Nienhaus plants/UMcS Shit

/obj/structure/flora/pottedplant/Nienplants
	name = "Pot"
	icon = 'icons/obj/Nienplants&Couch.dmi'
	icon_state = "pot"
	anchored = 1

/obj/structure/flora/pottedplant/Nienplants/daisies
	name = "Daisies"
	icon_state = "daisies"

/obj/structure/flora/pottedplant/Nienplants/roses
	name = "Roses"
	icon_state = "roses"

/obj/structure/flora/pottedplant/Nienplants/fern1
	name = "Brush Fern"
	icon_state = "fern1"

/obj/structure/flora/pottedplant/Nienplants/fern2
	name = "Smapy Fern"
	icon_state = "fern2"

/obj/structure/flora/pottedplant/Nienplants/fern3
	name = "Tall Fern"
	icon_state = "fern3"

/obj/structure/flora/pottedplant/Nienplants/violets
	name = "Violets"
	icon_state = "violets"

/obj/structure/flora/pottedplant/Nienplants/lilies
	name = "Lilies"
	icon_state = "lilies"

/obj/structure/flora/pottedplant/Nienplants/violets2
	name = "Violets2"
	icon_state = "violets2"

//tree
/obj/structure/flora/pottedplant/Nienplants/Glloydtree
	name = "tree"
	icon = 'icons/obj/Glloydtrees.dmi'
	icon_state = "tree"
	anchored = 1
	layer = 9

//Putting this here because of stupid flora code -Glloyd
/obj/structure/flora/pottedplant/Nienplants/plant
	name = "bush"
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "firstbush_1"
	anchored = 1
