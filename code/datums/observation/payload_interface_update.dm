//	Observer Pattern Implementation: Payload Interface Updated
//		Registration type: /atom
//
//		Raised when: A payload interface in an overmap site updates.

GLOBAL_TYPED_NEW(payload_interface_updated, /singleton/observ/payload_interface_updated)

/singleton/observ/payload_interface_updated
	name = "Payload Interface Updated"
	expected_type = /atom

/****************************
* Payload Interface Updated Handling *
****************************/

// Called from /obj/machinery/payload_interface
// in code\modules\overmap\projectiles\missiles\machinery\payload_interface.dm
