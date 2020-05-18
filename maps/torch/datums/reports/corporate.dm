

/datum/computer_file/report/recipient/corp
	logo = "\[logo\]"

/datum/computer_file/report/recipient/corp/generate_fields()
	..()
	add_field(/datum/report_field/simple_text, "Vessel", GLOB.using_map.station_name)
	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/time, "Time")
	add_field(/datum/report_field/simple_text, "Index")


/datum/computer_file/report/recipient/corp/memo/generate_fields()
	..()
	add_field(/datum/report_field/simple_text, "Subject")
	add_field(/datum/report_field/pencode_text, "Body")
	add_field(/datum/report_field/signature, "Authorizing Signature")
	add_field(/datum/report_field/options/yes_no, "Approved")

/datum/computer_file/report/recipient/corp/memo/internal
	form_name = "C-0003"
	title = "Internal Memorandum"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/corp/memo/internal/New()
	..()
	set_access(access_nanotrasen, access_nanotrasen)

/datum/computer_file/report/recipient/corp/memo/external
	form_name = "C-0005"
	title = "External Memorandum"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/corp/memo/external/New()
	..()
	set_access(access_edit = access_nanotrasen)

//No access restrictions for easier use.
/datum/computer_file/report/recipient/corp/sales
	form_name = "C-2192"
	title = "Corporate Sales Contract and Receipt"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/corp/sales/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "Product Information")
	add_field(/datum/report_field/simple_text, "Product Name")
	add_field(/datum/report_field/simple_text, "Product Type")
	add_field(/datum/report_field/number, "Product Unit Cost (T)")
	add_field(/datum/report_field/number, "Product Units Requested")
	add_field(/datum/report_field/number, "Total Cost (T)")
	add_field(/datum/report_field/text_label/header, "Seller Information")
	add_field(/datum/report_field/text_label/instruction, "The 'Purchaser' may not return any sold product units for re-compensation in [GLOB.using_map.local_currency_name], but may return the item for an identical item, or item of equal material (not [GLOB.using_map.local_currency_name_singular]) value. The 'Seller' agrees to make their best effort to repair, or replace any items that fail to accomplish their designed purpose, due to malfunction or manufacturing error - but not user-caused damage.")
	add_field(/datum/report_field/people/from_manifest, "Name")
	add_field(/datum/report_field/signature, "Signature")
	add_field(/datum/report_field/options/yes_no, "Approved")

/datum/computer_file/report/recipient/corp/payout
	form_name = "C-3310"
	title = "Next of Kin Payout Authorization"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/corp/payout/generate_fields()
	..()
	add_field(/datum/report_field/people/from_manifest, "This document hereby authorizes the payout of the remaining salary of")
	add_field(/datum/report_field/pencode_text, "As well as the net-worth of any remaining personal assets: (Asset, [GLOB.using_map.local_currency_name_singular] Amount)")
	add_field(/datum/report_field/pencode_text, "Including personal effects")
	add_field(/datum/report_field/text_label, "To be shipped and delivered directly to the employee's next of kin without delay.")
	add_field(/datum/report_field/signature, "Signature")
	add_field(/datum/report_field/options/yes_no, "Approved")
	set_access(access_edit = access_nanotrasen)

/datum/computer_file/report/recipient/corp/fire
	form_name = "C-0102"
	title = "Corporate Employment Termination Form"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/corp/fire/New()
	..()
	set_access(access_heads, access_heads)
	set_access(access_nanotrasen, override = 0)

/datum/computer_file/report/recipient/corp/fire/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "Notice of Termination of Employment")
	add_field(/datum/report_field/people/from_manifest, "Name")
	add_field(/datum/report_field/number, "Age")
	add_field(/datum/report_field/simple_text, "Position")
	add_field(/datum/report_field/pencode_text, "Reason for Termination")
	add_field(/datum/report_field/signature, "Authorized by")
	add_field(/datum/report_field/text_label/instruction, "Please attach employment records alongside notice of termination.")

/datum/computer_file/report/recipient/corp/incident/New()
	..()
	set_access(access_edit = access_nanotrasen)

/datum/computer_file/report/recipient/corp/incident/generate_fields()
	..()
	add_field(/datum/report_field/pencode_text, "Summary of Incident")
	add_field(/datum/report_field/pencode_text, "Details of Incident")

/datum/computer_file/report/recipient/corp/incident/proc/add_signatures()
	add_field(/datum/report_field/signature, "Signature")
	add_field(/datum/report_field/signature, "Witness Signature")
	add_field(/datum/report_field/options/yes_no, "Approved")

/datum/computer_file/report/recipient/corp/incident/ship
	form_name = "C-3203"
	title = "Corporate Ship Incident Report"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/corp/incident/ship/generate_fields()
	..()
	add_field(/datum/report_field/pencode_text, "Departments Involved")
	add_signatures()

/datum/computer_file/report/recipient/corp/volunteer
	form_name = "C-1443"
	title = "Corporate Test Subject Volunteer Form"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/corp/volunteer/generate_fields()
	..()
	var/list/temp_fields = list()
	add_field(/datum/report_field/people/from_manifest, "Name of Volunteer")
	add_field(/datum/report_field/simple_text, "Intended Procedure(s)")
	add_field(/datum/report_field/simple_text, "Compensation for Volunteer: (if any)")
	add_field(/datum/report_field/people/list_from_manifest, "Handling Researcher(s)")
	add_field(/datum/report_field/text_label/instruction, "By signing, the \"Volunteer\" agrees to absolve the Corporation, and its employees, of any liability or responsibility for injuries, damages, property loss or side-effects that may result from the intended procedure. If signed by an authorized representative, this form is deemed reviewed, but is only approved if so marked.")
	add_field(/datum/report_field/signature, "Volunteer's Signature:")
	temp_fields += add_field(/datum/report_field/signature, "Corporate Representative's Signature")
	temp_fields += add_field(/datum/report_field/options/yes_no, "Approved")
	for(var/datum/report_field/temp_field in temp_fields)
		temp_field.set_access(access_edit = access_nanotrasen)

/datum/computer_file/report/recipient/corp/deny
	form_name = "C-1443D"
	title = "Rejection of Test Subject Volunteer Notice"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/corp/deny/generate_fields()
	..()
	add_field(/datum/report_field/text_label, "Dear Sir/Madam, we regret to inform you that your volunteer application for service as a test subject with the Corporation has been rejected. We thank you for your interest in our company and the progression of research. Attached, you will find a copy of your original volunteer form for your records. Regards,")
	add_field(/datum/report_field/signature, "Corporate Representative's Signature")
	add_field(/datum/report_field/people/from_manifest, "Name of Volunteer")
	add_field(/datum/report_field/text_label/header, "Reason for Rejection")
	add_field(/datum/report_field/options/yes_no, "Physically Unfit")
	add_field(/datum/report_field/options/yes_no, "Mentally Unfit")
	add_field(/datum/report_field/options/yes_no, "Project Cancellation")
	add_field(/datum/report_field/simple_text, "Other")
	add_field(/datum/report_field/options/yes_no, "Report Approved")
	set_access(access_edit = access_nanotrasen)