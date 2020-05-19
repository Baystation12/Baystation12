
/obj/machinery/photocopier/faxmachine/unsc
	name = "Wavespace COM launcher"
	desc = "A long range UNSC text communicator for relaying commands and reports with HIGHCOM"
	icon = 'code/modules/halo/unsc/unsc_fax.dmi'
	icon_state = "computer_wide"
	network_name = "UNSC wavespace communications network"
	department = "UNSC"
	available_departments  = list("UNSC","UEG Colony")
	admin_departments = list("HIGHCOM")
	req_access = list(access_unsc)

/obj/machinery/photocopier/faxmachine/unsc/New()
	. = ..()
	overlays += "comm"
