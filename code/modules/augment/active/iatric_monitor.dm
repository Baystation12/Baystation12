/obj/item/organ/internal/augment/active/iatric_monitor
	name = "iatric monitor"
	augment_slots = AUGMENT_HEAD
	icon_state = "iatric_monitor"
	desc = "A small computer system constantly tracks your physiological state and vital signs. A muscle gesture can be used to receive a simple diagnostic report, not unlike that from a handheld scanner."
	augment_flags = AUGMENT_BIOLOGICAL | AUGMENT_SCANNABLE
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 2)


/obj/item/organ/internal/augment/active/iatric_monitor/emp_act(severity)
	. = ..()
	if (severity)
		var/scan_results = medical_scan_results(owner, TRUE, SKILL_NONE)
		owner.playsound_local(null, 'sound/effects/fastbeep.ogg', 20, is_global = TRUE)
		to_chat(owner, "<br>[scan_results]<br>")
		to_chat(owner, SPAN_WARNING("Your [name] cheerily outputs a bogus report as it malfunctions."))


/obj/item/organ/internal/augment/active/iatric_monitor/activate()
	var/scan_results = medical_scan_results(owner, TRUE, SKILL_PROF)
	owner.playsound_local(null, 'sound/effects/fastbeep.ogg', 20, is_global = TRUE)
	to_chat(owner, "<br>[scan_results]<br>")


/obj/item/organ/internal/augment/active/iatric_monitor/hidden
	augment_flags = AUGMENT_BIOLOGICAL
