/datum/pipe/disposal_dispenser
	name = "Disposal pipe. You should never see this."
	pipe_type = null
	pipe_color = null
	connect_types = null
	colorable = FALSE
	constructed_path = /obj/structure/disposalpipe/segment
	var/turn = DISPOSAL_FLIP_NONE

/datum/pipe/disposal_dispenser/simple/straight
	name = "disposal pipe segment"
	desc = "A huge pipe segment used for constructing disposal systems."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "pipe-s"
	build_path = /obj/structure/disposalconstruct
	turn = DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/segment

/datum/pipe/disposal_dispenser/simple/bent
	name = "bent disposal pipe segment"
	desc = "A huge pipe segment used for constructing disposal systems."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "pipe-c"
	build_path = /obj/structure/disposalconstruct
	turn = DISPOSAL_FLIP_RIGHT
	constructed_path = /obj/structure/disposalpipe/segment/bent

/datum/pipe/disposal_dispenser/simple/junction
	name = "disposal pipe junction"
	desc = "A huge pipe segment used for constructing disposal systems."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "pipe-j1"
	build_path = /obj/structure/disposalconstruct
	turn = DISPOSAL_FLIP_RIGHT|DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/junction

/datum/pipe/disposal_dispenser/simple/junctionm
	name = "disposal pipe junction (mirrored)"
	desc = "A huge pipe segment used for constructing disposal systems."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "pipe-j2"
	build_path = /obj/structure/disposalconstruct
	turn = DISPOSAL_FLIP_LEFT|DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/junction/mirrored

/datum/pipe/disposal_dispenser/simple/yjunction
	name = "disposal pipe y-junction"
	desc = "A huge pipe segment used for constructing disposal systems."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "pipe-y"
	build_path = /obj/structure/disposalconstruct
	turn = DISPOSAL_FLIP_LEFT|DISPOSAL_FLIP_RIGHT
	constructed_path = /obj/structure/disposalpipe/junction

/datum/pipe/disposal_dispenser/simple/trunk
	name = "disposal pipe trunk"
	desc = "A huge pipe segment used for constructing disposal systems."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "pipe-t"
	build_path = /obj/structure/disposalconstruct
	constructed_path = /obj/structure/disposalpipe/trunk

/datum/pipe/disposal_dispenser/simple/up
	name = "disposal pipe upwards segment"
	desc = "A huge pipe segment used for constructing disposal systems."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "pipe-u"
	build_path = /obj/structure/disposalconstruct
	constructed_path = /obj/structure/disposalpipe/up

/datum/pipe/disposal_dispenser/simple/down
	name = "disposal pipe downwards segment"
	desc = "A huge pipe segment used for constructing disposal systems."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "pipe-d"
	build_path = /obj/structure/disposalconstruct
	constructed_path = /obj/structure/disposalpipe/down

/datum/pipe/disposal_dispenser/device/bin
	name = "disposal bin"
	desc = "A bin used to dispose of trash."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "disposal"
	build_path = /obj/structure/disposalconstruct/machine
	constructed_path = /obj/machinery/disposal

/datum/pipe/disposal_dispenser/device/outlet
	name = "disposal outlet"
	desc = "an outlet that ejects things from a disposal network."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "outlet"
	build_path = /obj/structure/disposalconstruct/machine/outlet
	constructed_path = /obj/structure/disposaloutlet

/datum/pipe/disposal_dispenser/device/chute
	name = "disposal chute"
	desc = "A chute to put things into a disposal network."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "intake"
	build_path = /obj/structure/disposalconstruct
	constructed_path = /obj/machinery/disposal/deliveryChute

/datum/pipe/disposal_dispenser/device/sorting
	name = "disposal sorter"
	desc = "Sorts things in a disposal system"
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "pipe-j1s"
	build_path = /obj/structure/disposalconstruct
	turn = DISPOSAL_FLIP_RIGHT|DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/sortjunction

/datum/pipe/disposal_dispenser/device/sorting/wildcard
	name = "wildcard disposal sorter"
	desc = "Sorts things in a disposal system"
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "pipe-j1s"
	build_path = /obj/structure/disposalconstruct
	turn = DISPOSAL_FLIP_RIGHT|DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/sortjunction/wildcard

/datum/pipe/disposal_dispenser/device/sorting/untagged
	name = "untagged disposal sorter"
	desc = "Sorts things in a disposal system"
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "pipe-j1s"
	build_path = /obj/structure/disposalconstruct
	turn = DISPOSAL_FLIP_RIGHT|DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/sortjunction/untagged

/datum/pipe/disposal_dispenser/device/sortingm
	name = "disposal sorter (mirrored)"
	desc = "Sorts things in a disposal system"
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "pipe-j2s"
	build_path = /obj/structure/disposalconstruct
	turn = DISPOSAL_FLIP_LEFT|DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/sortjunction/flipped

/datum/pipe/disposal_dispenser/device/sorting/wildcardm
	name = "wildcard disposal sorter (mirrored)"
	desc = "Sorts things in a disposal system"
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "pipe-j2s"
	build_path = /obj/structure/disposalconstruct
	turn = DISPOSAL_FLIP_LEFT|DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/sortjunction/wildcard/flipped

/datum/pipe/disposal_dispenser/device/sorting/untaggedm
	name = "untagged disposal sorter (mirrored)"
	desc = "Sorts things in a disposal system"
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "pipe-j2s"
	build_path = /obj/structure/disposalconstruct
	turn = DISPOSAL_FLIP_LEFT|DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/sortjunction/untagged/flipped

/datum/pipe/disposal_dispenser/device/tagger
	name = "disposal tagger"
	desc = "It tags things."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "pipe-tagger"
	build_path = /obj/structure/disposalconstruct
	turn = DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/tagger

/datum/pipe/disposal_dispenser/device/tagger/partial
	name = "disposal partial tagger"
	desc = "It tags things."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "pipe-tagger-partial"
	build_path = /obj/structure/disposalconstruct
	turn = DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/tagger/partial

/datum/pipe/disposal_dispenser/device/diversion
	name = "disposal diverter"
	desc = "A huge pipe segment used for constructing disposal systems."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "pipe-j1s"
	build_path = /obj/structure/disposalconstruct
	turn = DISPOSAL_FLIP_FLIP | DISPOSAL_FLIP_RIGHT
	constructed_path = /obj/structure/disposalpipe/diversion_junction