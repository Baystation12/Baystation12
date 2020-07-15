
/**
* Torch fax machine overrides. Cleaner than map stuff.
**/

/obj/machinery/photocopier/faxmachine
  send_access = list()

/obj/machinery/photocopier/faxmachine/torch
	send_access = list(access_torch_fax)
