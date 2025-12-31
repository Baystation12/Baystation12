
/obj/item/stock_parts/computer/hard_drive/super/sensors
	name = "super hard drive (sensors)"
	desc = "A small hard drive with 512GQ of storage capacity for use in cluster storage solutions where capacity is more important than power efficiency. This one is pre-loaded with a sensors suite program."

/obj/item/stock_parts/computer/hard_drive/super/helm/install_default_programs()
	..()
	create_file(new/datum/computer_file/program/ship/sensors(src))
