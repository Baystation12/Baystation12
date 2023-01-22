/datum/wires/taperecorder
	holder_type = /obj/item/device/taperecorder
	wire_count = 1
	descriptions = list(
		new /datum/wire_description(TAPE_WIRE_TOGGLE, "This wire runs to the play/stop toggle.", SKILL_ADEPT)
	)

var/global/const/TAPE_WIRE_TOGGLE = 1

/datum/wires/taperecorder/UpdatePulsed(var/index)
	var/obj/item/device/taperecorder/T = holder
	if(T.recording || T.playing)
		T.stop()
	else
		T.play()
	SSnano.update_uis(holder)