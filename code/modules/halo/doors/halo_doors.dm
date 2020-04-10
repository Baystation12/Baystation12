
/obj/machinery/door/airlock/halo/lifepod
	name = "Lifepod Airlock"
	icon = 'code/modules/halo/doors/airlocklifepod/door.dmi'
	welded_file = 'code/modules/halo/doors/airlocklifepod/welded.dmi'
	opacity = 0

/obj/machinery/door/airlock/halo/maint
	name = "Maintenance Airlock"
	icon = 'code/modules/halo/doors/airlockmaint/door.dmi'
	welded_file = 'code/modules/halo/doors/airlockmaint/welded.dmi'
	opacity = 0


/obj/machinery/door/airlock/halo
	name = "Airlock"
	icon = 'code/modules/halo/doors/airlocksingle/door.dmi'
	welded_file = 'code/modules/halo/doors/airlocksingle/welded.dmi'
	lights_file = null
	fill_file = null
	opacity = 1
	maxhealth = 1500
	paintable = 0

/obj/machinery/door/airlock/multi_tile/halo
	name = "Airlock"
	icon = 'code/modules/halo/doors/airlockdouble/door.dmi'
	welded_file = 'code/modules/halo/doors/airlockdouble/welded.dmi'
	opacity = 1
	lights_file = null
	fill_file = null
	maxhealth = 1500
	paintable = 0

/obj/machinery/door/airlock/multi_tile/halo/ns
	dir = 4

/obj/machinery/door/airlock/multi_tile/halo/blast
	name = "Blast doors"
	icon = 'code/modules/halo/doors/airlockblastdouble/door.dmi'
	welded_file = 'code/modules/halo/doors/airlockblastdouble/welded.dmi'
	opacity = 0
	maxhealth = 2000

/obj/machinery/door/airlock/multi_tile/halo/blast/ns
	dir = 4

obj/machinery/door/airlock/multi_tile/halo/triple
	icon = 'code/modules/halo/doors/blastdoor/door.dmi'
	welded_file = 'code/modules/halo/doors/blastdoor/welded.dmi'
	maxhealth = 2000
	dir = NORTH
	width = 3
	opacity = 1

obj/machinery/door/airlock/multi_tile/halo/quadruple
	icon = 'code/modules/halo/doors/longerblastdoor/door.dmi'
	welded_file = 'code/modules/halo/doors/longerblastdoor/welded.dmi'
	maxhealth = 2500
	dir = NORTH
	width = 4
	opacity = 1

obj/machinery/door/airlock/multi_tile/halo/triplens
	icon = 'code/modules/halo/doors/3xblastdoors/door.dmi'
	welded_file = 'code/modules/halo/doors/3xblastdoors/welded.dmi'
	maxhealth = 2000
	dir = EAST
	width = 3
	opacity = 1

obj/machinery/door/airlock/multi_tile/halo/quadruplens
	icon = 'code/modules/halo/doors/4xblastdoors/door.dmi'
	welded_file = 'code/modules/halo/doors/4xblastdoors/welded.dmi'
	maxhealth = 2500
	dir = EAST
	width = 4
	opacity = 1

/obj/machinery/door/airlock/multi_tile/secure
	name = "Secure Airlock"
	icon = 'code/modules/halo/doors/Secure2x1.dmi'
	assembly_type = /obj/structure/door_assembly/multi_tile

obj/machinery/door/airlock/multi_tile/halo/triple
	icon = 'code/modules/halo/doors/blastdoor/door.dmi'
	welded_file = 'code/modules/halo/doors/blastdoor/welded.dmi'
	maxhealth = 2000
	dir = NORTH
	opacity = 1

obj/machinery/door/blast/regular/triple/New()
	. = ..()

	//only east-west variant for now
	bound_width = 3 * world.icon_size
	bound_height = world.icon_size

	/*switch(dir)
		if(EAST, WEST)
			bound_width = 3 * world.icon_size
			bound_height = world.icon_size
		else
			bound_width = world.icon_size
			bound_height = 3 * world.icon_size*/

obj/machinery/door/blast/regular/quadruple
	icon = 'code/modules/halo/doors/Longer Blastdoor.dmi'
	maxhealth = 2500

obj/machinery/door/blast/regular/quadruple/New()
	. = ..()

	//only east-west variant for now
	bound_width = 4 * world.icon_size
	bound_height = world.icon_size
