
/obj/item/stock_parts/computer/hard_drive/super/helm
	name = "super hard drive (helm)"
	desc = "A small hard drive with 512GQ of storage capacity for use in cluster storage solutions where capacity is more important than power efficiency. This one is pre-loaded with everything you need to fly a ship."

/obj/item/stock_parts/computer/hard_drive/super/helm/install_default_programs()
	..()
	create_file(new/datum/computer_file/program/ship/engine_control(src))
