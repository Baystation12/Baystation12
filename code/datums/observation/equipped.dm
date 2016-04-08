//	Observer Pattern Implementation: Equipped
//		Registration type: /mob
//
//		Raised when: A mob equips an item.
//
//		Arguments that the called proc should expect:
//			/mob/equipper:  The mob that equipped the item.
//			/obj/item/item: The equipped item.
//			slot:           The slot equipped to.

var/decl/observ/equipped/equipped_event = new()

/decl/observ/equipped
	name = "Equipped"
	expected_type = /mob

/********************
* Equipped Handling *
********************/

/obj/item/equipped(var/mob/user, var/slot)
	. = ..()
	equipped_event.raise_event(user, src, slot)
