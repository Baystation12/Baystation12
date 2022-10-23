//	Observer Pattern Implementation: Instrument started playing
//
//		Raised when: Instrument starts playing
//
//		Arguments that the called proc should expect:
//          /obj/other : reference to instrument that started playing a song

GLOBAL_DATUM_INIT(instrument_synchronizer, /singleton/observ/instrument_synchronizer, new)

/singleton/observ/instrument_synchronizer
	name = "Instrument synchronizer"
	expected_type = /datum
