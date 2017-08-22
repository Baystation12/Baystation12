
/obj/machinery/door/airlock/halo_lifepod
	name = "Lifepod Airlock"
	icon = 'code/modules/halo/doors/airlocklifepod.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_com

/obj/machinery/door/airlock/halo_maint
	name = "Maintenance Airlock"
	icon = 'code/modules/halo/doors/airlockmaint.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_com

/obj/machinery/door/airlock/halo
	name = "Airlock"
	icon = 'code/modules/halo/doors/Airlocksingle.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_com

/obj/machinery/door/airlock/multi_tile/halo
	name = "Airlock"
	icon = 'code/modules/halo/doors/Airlockdouble.dmi'
	assembly_type = /obj/structure/door_assembly/multi_tile

/obj/machinery/door/airlock/multi_tile/halo/blast
	name = "Blast doors"
	icon = 'code/modules/halo/doors/Airlockblastdouble.dmi'
	opacity = 0
	glass = 1
	assembly_type = /obj/structure/door_assembly/multi_tile

/obj/machinery/door/airlock/multi_tile/secure
	name = "Secure Airlock"
	icon = 'code/modules/halo/doors/Secure2x1.dmi'
	assembly_type = /obj/structure/door_assembly/multi_tile

obj/machinery/door/blast/regular/triple
	icon = 'code/modules/halo/doors/blastdoor.dmi'
	maxhealth = 1800

obj/machinery/door/blast/regular/triple/New()
	..()

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
	maxhealth = 2400

obj/machinery/door/blast/regular/quadruple/New()
	..()

	//only east-west variant for now
	bound_width = 4 * world.icon_size
	bound_height = world.icon_size
