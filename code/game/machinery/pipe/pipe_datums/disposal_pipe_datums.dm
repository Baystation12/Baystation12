/datum/pipe/disposal_dispenser
	name = "Disposal pipe. You should never see this."
	var/subtype = DISPOSAL_SUB_SORT_NORMAL
	pipe_type = null
	pipe_color = null
	connect_types = null
	colorable = FALSE
	constructed_path = /obj/machinery/disposal

/datum/pipe/disposal_dispenser/simple/straight
	name = "disposal pipe segment"
	desc = "A huge pipe segment used for constructing disposal systems."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "conpipe-s"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_STRAIGHT

/datum/pipe/disposal_dispenser/simple/bent
	name = "bent disposal pipe segment"
	desc = "A huge pipe segment used for constructing disposal systems."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "conpipe-c"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_BENT

/datum/pipe/disposal_dispenser/simple/junction
	name = "disposal pipe junction"
	desc = "A huge pipe segment used for constructing disposal systems."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "conpipe-j1"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_JUNCTION1

/datum/pipe/disposal_dispenser/simple/yjunction
	name = "disposal pipe y-junction"
	desc = "A huge pipe segment used for constructing disposal systems."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "conpipe-y"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_JUNCTION_Y

/datum/pipe/disposal_dispenser/simple/trunk
	name = "disposal pipe trunk"
	desc = "A huge pipe segment used for constructing disposal systems."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "conpipe-t"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_TRUNK

/datum/pipe/disposal_dispenser/simple/up
	name = "disposal pipe upwards segment"
	desc = "A huge pipe segment used for constructing disposal systems."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "pipe-u"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_UP

/datum/pipe/disposal_dispenser/simple/down
	name = "disposal pipe downwards segment"
	desc = "A huge pipe segment used for constructing disposal systems."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "pipe-d"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_DOWN

/datum/pipe/disposal_dispenser/device/bin
	name = "disposal bin"
	desc = "A bin used to dispose of trash."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "condisposal"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_BIN

/datum/pipe/disposal_dispenser/device/outlet
	name = "disposal outlet"
	desc = "an outlet that ejects things from a disposal network."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "outlet"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_OUTLET

/datum/pipe/disposal_dispenser/device/chute
	name = "disposal chute"
	desc = "A chute to put things into a disposal network."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "intake"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_INLET

/datum/pipe/disposal_dispenser/device/sorting
	name = "disposal sorter"
	desc = "Sorts things in a disposal system"
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "conpipe-j1s"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_JUNCTION_SORT1
	subtype = DISPOSAL_SUB_SORT_NORMAL

/datum/pipe/disposal_dispenser/device/sorting/wildcard
	name = "wildcard disposal sorter"
	desc = "Sorts things in a disposal system"
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "conpipe-j1s"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_JUNCTION_SORT1
	subtype = DISPOSAL_SUB_SORT_WILD

/datum/pipe/disposal_dispenser/device/sorting/untagged
	name = "untagged disposal sorter"
	desc = "Sorts things in a disposal system"
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "conpipe-j1s"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_JUNCTION_SORT1
	subtype = DISPOSAL_SUB_SORT_UNTAGGED

/datum/pipe/disposal_dispenser/device/tagger
	name = "disposal tagger"
	desc = "It tags things."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "pipe-tagger"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_TAGGER

/datum/pipe/disposal_dispenser/device/tagger/partial
	name = "disposal partial tagger"
	desc = "It tags things."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "pipe-tagger-partial"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_TAGGER_PARTIAL

/datum/pipe/disposal_dispenser/device/diversion
	name = "disposal diverter"
	desc = "A huge pipe segment used for constructing disposal systems."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "conpipe-j1s"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_DIVERSION

/datum/pipe/disposal_dispenser/device/diversion/switch
	name = "disposal diverter switch"
	desc = "A huge pipe segment used for constructing disposal systems."
	build_icon = 'icons/obj/pipes/disposal.dmi'
	build_icon_state = "conpipe-j1s"
	build_path = /obj/structure/disposalconstruct
	pipe_type = DISPOSAL_DIVERSION