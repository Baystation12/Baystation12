//	Observer Pattern Implementation: Death
//		Registration type: /mob
//
//		Raised when: A mob is added to the dead_mob_list
//
//		Arguments that the called proc should expect:
//			/mob/dead: The mob that was added to the dead_mob_list

GLOBAL_DATUM_INIT(death_event, /decl/observ/death, new)

/decl/observ/death
	name = "Death"
	expected_type = /mob

/*****************
* Death Handling *
*****************/

/mob/living/add_to_dead_mob_list()
	. = ..()
	if(.)
		GLOB.death_event.raise_event(src)
