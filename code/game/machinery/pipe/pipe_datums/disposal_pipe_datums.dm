/datum/pipe/disposal_dispenser
	name = "Disposal pipe. You should never see this."
	var/subtype = DISPOSAL_SUB_SORT_NORMAL
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
	build_icon_state = "conpipe-s"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_STRAIGHT
	turn = DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/segment

/datum/pipe/disposal_dispenser/simple/bent
	name = "bent disposal pipe segment"
	desc = "A huge pipe segment used for constructing disposal systems."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "conpipe-c"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_BENT
	turn = DISPOSAL_FLIP_FLIP|DISPOSAL_FLIP_RIGHT
	constructed_path = /obj/structure/disposalpipe/segment

/datum/pipe/disposal_dispenser/simple/junction
	name = "disposal pipe junction"
	desc = "A huge pipe segment used for constructing disposal systems."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "conpipe-j1"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_JUNCTION1
	turn = DISPOSAL_FLIP_RIGHT|DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/junction

/datum/pipe/disposal_dispenser/simple/junctionm
	name = "disposal pipe junction (mirrored)"
	desc = "A huge pipe segment used for constructing disposal systems."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "conpipe-j2"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_JUNCTION2
	turn = DISPOSAL_FLIP_LEFT|DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/junction

/datum/pipe/disposal_dispenser/simple/yjunction
	name = "disposal pipe y-junction"
	desc = "A huge pipe segment used for constructing disposal systems."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "conpipe-y"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_JUNCTION_Y
	turn = DISPOSAL_FLIP_LEFT|DISPOSAL_FLIP_RIGHT
	constructed_path = /obj/structure/disposalpipe/junction

/datum/pipe/disposal_dispenser/simple/trunk
	name = "disposal pipe trunk"
	desc = "A huge pipe segment used for constructing disposal systems."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "conpipe-t"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_TRUNK
	constructed_path = /obj/structure/disposalpipe/trunk

/datum/pipe/disposal_dispenser/simple/up
	name = "disposal pipe upwards segment"
	desc = "A huge pipe segment used for constructing disposal systems."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "pipe-u"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_UP
	constructed_path = /obj/structure/disposalpipe/up

/datum/pipe/disposal_dispenser/simple/down
	name = "disposal pipe downwards segment"
	desc = "A huge pipe segment used for constructing disposal systems."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "pipe-d"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_DOWN
	constructed_path = /obj/structure/disposalpipe/down

/datum/pipe/disposal_dispenser/device/bin
	name = "disposal bin"
	desc = "A bin used to dispose of trash."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "condisposal"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_BIN
	constructed_path = /obj/machinery/disposal

/datum/pipe/disposal_dispenser/device/outlet
	name = "disposal outlet"
	desc = "an outlet that ejects things from a disposal network."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "outlet"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_OUTLET
	constructed_path = /obj/structure/disposaloutlet

/datum/pipe/disposal_dispenser/device/chute
	name = "disposal chute"
	desc = "A chute to put things into a disposal network."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "intake"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_INLET
	constructed_path = /obj/machinery/disposal/deliveryChute

/datum/pipe/disposal_dispenser/device/sorting
	name = "disposal sorter"
	desc = "Sorts things in a disposal system"
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "conpipe-j1s"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_JUNCTION_SORT1
	subtype = DISPOSAL_SUB_SORT_NORMAL
	turn = DISPOSAL_FLIP_RIGHT|DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/sortjunction

/datum/pipe/disposal_dispenser/device/sorting/wildcard
	name = "wildcard disposal sorter"
	desc = "Sorts things in a disposal system"
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "conpipe-j1s"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_JUNCTION_SORT1
	subtype = DISPOSAL_SUB_SORT_WILD
	turn = DISPOSAL_FLIP_RIGHT|DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/sortjunction/wildcard

/datum/pipe/disposal_dispenser/device/sorting/untagged
	name = "untagged disposal sorter"
	desc = "Sorts things in a disposal system"
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "conpipe-j1s"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_JUNCTION_SORT1
	subtype = DISPOSAL_SUB_SORT_UNTAGGED
	turn = DISPOSAL_FLIP_RIGHT|DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/sortjunction/untagged

/datum/pipe/disposal_dispenser/device/sortingm
	name = "disposal sorter (mirrored)"
	desc = "Sorts things in a disposal system"
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "conpipe-j2s"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_JUNCTION_SORT2
	subtype = DISPOSAL_SUB_SORT_NORMAL
	turn = DISPOSAL_FLIP_LEFT|DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/sortjunction/flipped

/datum/pipe/disposal_dispenser/device/sorting/wildcardm
	name = "wildcard disposal sorter (mirrored)"
	desc = "Sorts things in a disposal system"
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "conpipe-j2s"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_JUNCTION_SORT2
	subtype = DISPOSAL_SUB_SORT_WILD
	turn = DISPOSAL_FLIP_LEFT|DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/sortjunction/wildcard/flipped

/datum/pipe/disposal_dispenser/device/sorting/untaggedm
	name = "untagged disposal sorter (mirrored)"
	desc = "Sorts things in a disposal system"
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "conpipe-j2s"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_JUNCTION_SORT2
	subtype = DISPOSAL_SUB_SORT_UNTAGGED
	turn = DISPOSAL_FLIP_LEFT|DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/sortjunction/untagged/flipped

/datum/pipe/disposal_dispenser/device/tagger
	name = "disposal tagger"
	desc = "It tags things."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "pipe-tagger"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_TAGGER
	turn = DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/tagger

/datum/pipe/disposal_dispenser/device/tagger/partial
	name = "disposal partial tagger"
	desc = "It tags things."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "pipe-tagger-partial"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_TAGGER_PARTIAL
	turn = DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/tagger/partial

/datum/pipe/disposal_dispenser/device/diversion
	name = "disposal diverter"
	desc = "A huge pipe segment used for constructing disposal systems."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "conpipe-j1s"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_DIVERSION
	turn = DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/diversion_junction

/datum/pipe/disposal_dispenser/device/diversion/switch
	name = "disposal diverter switch"
	desc = "A huge pipe segment used for constructing disposal systems."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "conpipe-j1s"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_DIVERSION
	turn = DISPOSAL_FLIP_FLIP
	constructed_path = /obj/structure/disposalpipe/diversion_junction