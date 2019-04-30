/client/proc/dsay(msg as text)
	set category = "Special Verbs"
	set name = "Dsay" //Gave this shit a shorter name so you only have to time out "dsay" rather than "dead say" to use it --NeoFite
	set hidden = 1

	if(!check_rights(R_INVESTIGATE, 1))
		return

	sanitize_and_communicate(/decl/communication_channel/dsay, src, msg, /decl/dsay_communication/admin)
	SSstatistics.add_field_details("admin_verb","D") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
