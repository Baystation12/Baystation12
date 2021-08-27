
/datum/computer_file/report/recipient/medical
	logo = "\[solcrest\]"
	form_name = "SCG-MED-00"

/datum/computer_file/report/recipient/medical/incidentreport
	form_name = "SCG-MED-04"
	title = "Medical Incident Report"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/medical/incidentreport/generate_fields()
	..()
	add_field(/datum/report_field/simple_text, "Vessel", GLOB.using_map.station_name)
	add_field(/datum/report_field/date, "Date of Incident")
	add_field(/datum/report_field/time, "Time of Incident")
	add_field(/datum/report_field/people/from_manifest, "Patient")
	add_field(/datum/report_field/people/from_manifest, "Attending Physician")
	add_field(/datum/report_field/pencode_text, "Details of Injuries")
	add_field(/datum/report_field/pencode_text, "Details of Treatment")
	add_field(/datum/report_field/pencode_text, "Other Notes")
	add_field(/datum/report_field/text_label/instruction, "By signing below, I affirm that all of the above is factually correct to the best of my knowledge.")
	add_field(/datum/report_field/signature, "Attending Physician's Signature")
	set_access(access_surgery)

/datum/computer_file/report/recipient/medical/checkup
	form_name = "SCG-MED-013b"
	title = "Regular Health Checkup Checklist"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/medical/checkup/generate_fields()
	..()
	add_field(/datum/report_field/text_label/instruction, "You would need following equipment for this: stethoscope, health analyzer, penlight.")
	add_field(/datum/report_field/people/from_manifest, "Patient")
	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/time, "Time")
	add_field(/datum/report_field/simple_text, "Take pulse", "NOT CHECKED")
	add_field(/datum/report_field/simple_text, "Check blood pressure", "NOT CHECKED")
	add_field(/datum/report_field/simple_text, "Listen for heart noises", "NOT CHECKED")
	add_field(/datum/report_field/simple_text, "Listen for lung noises", "NOT CHECKED")
	add_field(/datum/report_field/simple_text, "Ask if they exercise", "NOT CHECKED")
	add_field(/datum/report_field/simple_text, "Ask if they smoke, and how much per day", "NOT CHECKED")
	add_field(/datum/report_field/simple_text, "Check eye reaction to penlight", "NOT CHECKED")
	add_field(/datum/report_field/simple_text, "Ask about any recent radiation exposure", "NOT CHECKED")
	add_field(/datum/report_field/simple_text, "Ask about any recent sickness", "NOT CHECKED")
	add_field(/datum/report_field/pencode_text, "Other Notes")
	add_field(/datum/report_field/signature, "Doctor's Signature")
	set_access(access_edit = access_medical_equip)

/datum/computer_file/report/recipient/medical/autopsy
	form_name = "SCG-MED-015"
	title = "Autopsy Report"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/medical/autopsy/generate_fields()
	..()
	add_field(/datum/report_field/simple_text, "Vessel", GLOB.using_map.station_name)
	add_field(/datum/report_field/simple_text, "Patient Name")
	add_field(/datum/report_field/text_label/header, "Death Information")
	add_field(/datum/report_field/date, "Date of Death")
	add_field(/datum/report_field/time, "Time of Death")
	add_field(/datum/report_field/text_label/instruction, "Check yes if the time of death is estimated, no if it is exact.")
	add_field(/datum/report_field/options/yes_no, "Estimated")
	add_field(/datum/report_field/simple_text, "Cause(s) of Death")
	add_field(/datum/report_field/text_label/instruction, "Describe how the patient died.")
	add_field(/datum/report_field/pencode_text, "Death Narrative")
	add_field(/datum/report_field/text_label/instruction, "Describe postmortem handling of the body.")
	add_field(/datum/report_field/pencode_text, "Postmortem Narrative")
	add_field(/datum/report_field/text_label/header, "Doctor Information")
	add_field(/datum/report_field/text_label/instruction, "By signing below, I affirm that all of the above is factually correct to the best of my knowledge.")
	add_field(/datum/report_field/people/from_manifest, "Doctor")
	add_field(/datum/report_field/signature, "Doctor's Signature")
	set_access(access_morgue, access_surgery)

	add_field(/datum/report_field/text_label/instruction, "By signing below, I affirm that I have reviewed all of the above and affirm it is factually correct to the best of my knowledge. If there is no Chief Medical Officer available, this signature may be skipped.")
	var/datum/report_field/cmofield = add_field(/datum/report_field/people/from_manifest, "Chief Medical Officer")
	cmofield.set_access(access_morgue, access_cmo)	
	cmofield = add_field(/datum/report_field/signature, "Chief Medical Officer's Signature")
	cmofield.set_access(access_morgue, access_cmo)
