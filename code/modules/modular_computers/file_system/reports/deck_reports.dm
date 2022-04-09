//Reports for the deck management program.

/datum/computer_file/report/flight_plan
	form_name = "DC109"
	title = "Flight Plan"
	var/datum/report_field/people/leader     //Give these a special name for easier access.
	var/datum/report_field/people/manifest
	var/datum/report_field/planned_depart

/datum/computer_file/report/flight_plan/New()
	..()
	set_access(null, access_bridge)

/datum/computer_file/report/flight_plan/Destroy()
	leader = null
	manifest = null
	planned_depart = null
	return ..()

/datum/computer_file/report/flight_plan/generate_fields()
	add_field(/datum/report_field/text_label/instruction, "These fields are required:")
	leader = add_field(/datum/report_field/people/from_manifest, "Leader", required = 1)
	planned_depart = add_field(/datum/report_field/time, "Planned Departure", required = 1)
	add_field(/datum/report_field/text_label/instruction, "These fields are optional:")
	manifest = add_field(/datum/report_field/people/list_from_manifest, "Manifest")
	add_field(/datum/report_field/pencode_text, "Objective")
	add_field(/datum/report_field/time, "Expected Return/Contact Time")
	add_field(/datum/report_field/simple_text, "Fuel Status")

//These fields will be auto-set.
/datum/computer_file/report/recipient/shuttle
	var/datum/report_field/shuttle
	var/datum/report_field/mission
	var/access_shuttle = 0 //Set to 1 to give the shuttle's logging access as an access_edit pattern.

/datum/computer_file/report/recipient/shuttle/New()
	..()
	set_access(null, access_bridge)

/datum/computer_file/report/recipient/shuttle/Destroy()
	shuttle = null
	mission = null
	return ..()

/datum/computer_file/report/recipient/shuttle/generate_fields()
	..()
	shuttle = add_field(/datum/report_field/simple_text, "Shuttle", required = 1)
	shuttle.can_edit = 0
	mission = add_field(/datum/report_field/simple_text, "Mission", required = 1)
	mission.can_edit = 0

/datum/computer_file/report/recipient/shuttle/damage
	form_name = "DC243"
	title = "Post-flight Damage Assessment"

/datum/computer_file/report/recipient/shuttle/damage/New()
	..()
	set_access(null, access_cargo, override = 0)

/datum/computer_file/report/recipient/shuttle/damage/generate_fields()
	..()
	add_field(/datum/report_field/text_label/instruction, "Assess the damage sustained by the shuttle and its flight readiness.")
	add_field(/datum/report_field/pencode_text, "Shuttle state on arrival")
	add_field(/datum/report_field/simple_text, "Flight readiness")
	add_field(/datum/report_field/pencode_text, "Repairs required")
	add_field(/datum/report_field/time, "Estimated completion time")

/datum/computer_file/report/recipient/shuttle/fuel
	form_name = "DC12"
	title = "Post-flight Refueling Report"

/datum/computer_file/report/recipient/shuttle/fuel/New()
	..()
	set_access(null, access_cargo, override = 0)

/datum/computer_file/report/recipient/shuttle/fuel/generate_fields()
	..()
	add_field(/datum/report_field/simple_text, "Prior fuel level")
	add_field(/datum/report_field/simple_text, "Current fuel level")
	add_field(/datum/report_field/time, "Time of refueling")
	add_field(/datum/report_field/pencode_text, "Additional notes")

/datum/computer_file/report/recipient/shuttle/atmos
	form_name = "DC245"
	title = "Post-flight Atmospherics Assessment"

/datum/computer_file/report/recipient/shuttle/atmos/New()
	..()
	set_access(null, access_cargo, override = 0)

/datum/computer_file/report/recipient/shuttle/atmos/generate_fields()
	..()
	add_field(/datum/report_field/text_label/instruction, "Assess the state of the shuttle's atmospherics system.")
	add_field(/datum/report_field/pencode_text, "State of atmospherics supplies")
	add_field(/datum/report_field/time, "Estimated time of exhaustion")
	add_field(/datum/report_field/simple_text, "Supplies required")

/datum/computer_file/report/recipient/shuttle/gear
	form_name = "DC248b"
	title = "Post-flight Emergency Supply Inventory; Summary Version"

/datum/computer_file/report/recipient/shuttle/gear/New()
	..()
	set_access(null, access_cargo, override = 0)

/datum/computer_file/report/recipient/shuttle/gear/generate_fields()
	..()
	add_field(/datum/report_field/text_label/instruction, "Summarize the state of the shuttle's critical emergency supplies.")
	add_field(/datum/report_field/pencode_text, "State of supplies on arrival")
	add_field(/datum/report_field/pencode_text, "Supplies restocked")
	add_field(/datum/report_field/time, "Time of restocking")
	add_field(/datum/report_field/simple_text, "Flight readiness")
	add_field(/datum/report_field/pencode_text, "Additional Notes")

/datum/computer_file/report/recipient/shuttle/post_flight
	form_name = "DC102"
	title = "Standard Expedition Summary"
	access_shuttle = 1

/datum/computer_file/report/recipient/shuttle/post_flight/generate_fields()
	..()
	add_field(/datum/report_field/text_label/instruction, "Report on the expedition's findings, results, or outcomes.")
	add_field(/datum/report_field/simple_text, "Locations visited")
	add_field(/datum/report_field/simple_text, "General purpose of mission")
	add_field(/datum/report_field/pencode_text, "Brief summary of activities")
	add_field(/datum/report_field/pencode_text, "Crew status and casualties")
	add_field(/datum/report_field/pencode_text, "Objects or materials returned")
	add_field(/datum/report_field/pencode_text, "Recommended follow-up activities")
	add_field(/datum/report_field/pencode_text, "Additional Notes")
