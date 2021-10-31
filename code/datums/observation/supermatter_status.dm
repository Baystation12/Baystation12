//	Observer Pattern Implementation: Supermatter status changed
//		Registration type: /datum/supermatter (register for the global event only)
//
//		Raised when: After a supermatter shard changes status
//
//		Arguments that the called proc should expect:
//			/obj/machinery/power/supermatter: the shard
//          danger : True or false depending on if shard has crossed warning treshold (or if it is being removed and no longer matters)

GLOBAL_DATUM_INIT(supermatter_status, /decl/observ/supermatter_status, new)

/decl/observ/supermatter_status
	name = "Supermatter status changed"
	expected_type = /obj/machinery/power/supermatter
