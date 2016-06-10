/obj/structure
	var/item_worth = 30

/obj/structure/proc/get_worth()
	return item_worth

/obj/structure/Destroy()
	station_damage_score += get_worth()
	..()

/obj/structure/barricade/get_worth()
	return material.material_worth

/obj/structure/ore_box
	item_worth = 12

/obj/structure/constructshell
	item_worth = 100

/obj/structure/cable
	item_worth = 0 //Cause they don't really /die/ persay and aren't worth a lot to begin with.

/obj/structure/particle_accelerator
	item_worth = 2000

/obj/structure/droppod_door
	item_worth = 65

/obj/structure/disposalconstruct
	item_worth = 0 //Similar to cables, they are assembled into something else.

/obj/structure/disposalpipe
	item_worth = 35

/obj/structure/disposalpipe/tagger
	item_worth = 70

/obj/structure/disposalpipe/sortjunction
	item_worth = 65

/obj/structure/disposaloutlet
	item_worth = 65

/obj/structure/boulder
	item_worth = 0 //just a dumb boulder

/obj/structure/showcase
	item_worth = 400

/obj/structure/shuttle
	item_worth = 150

/obj/structure/plasticflaps
	item_worth = 15

/obj/structure/cult
	item_worth = 160

/obj/structure/cult/pylon
	item_worth = 700

/obj/structure/cryofeed
	item_worth = 450

/obj/structure/AIcore
	item_worth = 6000

/obj/structure/AIcore/deactivated
	item_worth = 7000

/obj/structure/computerframe
	item_worth = 50

/obj/structure/plushie
	item_worth = 7

/obj/structure/bedsheetbin
	item_worth = 25

/obj/structure/coatrack
	item_worth = 10

/obj/structure/displaycase
	item_worth = 86

/obj/structure/door_assembly
	item_worth = 35

/obj/structure/girder
	item_worth = 15

/obj/structure/grille
	item_worth = 5

/obj/structure/inflatable
	item_worth = 1

/obj/structure/janitorialcart
	item_worth = 120

/obj/structure/kitchenspike
	item_worth = 35

/obj/structure/lattice
	item_worth = 1

/obj/structure/morgue
	item_worth = 100

/obj/structure/crematorium
	item_worth = 600

/obj/structure/device/piano
	item_worth = 1200 //pianos are expensive

/obj/structure/noticeboard
	item_worth = 15

/obj/structure/safe
	item_worth = 200

/obj/structure/safe/floor
	item_worth = 180

/obj/structure/sign
	item_worth = 25

/obj/structure/dispenser
	item_worth = 500

/obj/structure/transit_tube
	item_worth = 80

/obj/structure/transit_tube_pod
	item_worth = 100

/obj/structure/toilet
	item_worth = 50

/obj/structure/alien
	item_worth = 300

/obj/structure/closet
	item_worth = 15

/obj/structure/bed
	item_worth = 7

/obj/structure/bed/get_worth()
	return item_worth * material.material_worth

/obj/structure/holostool
	item_worth = 0

/obj/structure/holohoop
	item_worth = 0

/obj/structure/bookcase
	item_worth = 50