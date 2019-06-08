/datum/computer_file/report/recipient/sci/anomaly
	form_name = "SCG-SCI-1546"
	title = "Anomalistic Object Report"
	logo = "\[eclogo\]\[logo\]"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/sci/anomaly/New()
	..()
	set_access(access_research, access_research)

/datum/computer_file/report/recipient/sci/anomaly/generate_fields()
	..()
	add_field(/datum/report_field/simple_text, "Vessel", GLOB.using_map.station_name)
	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/time, "Time")
	add_field(/datum/report_field/simple_text, "Index")
	add_field(/datum/report_field/simple_text, "AO Codename")
	add_field(/datum/report_field/people/from_manifest, "Reporting Scientist")
	add_field(/datum/report_field/people/from_manifest, "Overviewing Chief Science Officer")
	add_field(/datum/report_field/pencode_text, "Containment Procedures")
	add_field(/datum/report_field/pencode_text, "Generalized Overview")
	add_field(/datum/report_field/simple_text, "Approximate Age of AO")
	add_field(/datum/report_field/simple_text, "Threat Level of AO")

