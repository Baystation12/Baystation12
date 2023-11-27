//	Observer Pattern Implementation: EMPd
//		Registration type: /atom
//
//		Raised when: A /atom instance is EMPd.
//
//		Arguments that the called proc should expect:
//			/atom/empd_instance: The instance that was EMPd.
//			severity: The EMP severity

GLOBAL_DATUM_INIT(empd_event, /singleton/observ/empd, new)

/singleton/observ/empd
	name = "EMPd"
