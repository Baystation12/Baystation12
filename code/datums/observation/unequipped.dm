//	Observer Pattern Implementation: Unequipped (dropped)
//		Registration type: /mob
//
//		Raised when: A mob unequips/drops an item.
//
//		Arguments that the called proc should expect:
//			/mob/equipped:  The mob that unequipped/dropped the item.
//			/obj/item/item: The unequipped item.

var/decl/observ/unequipped/unequipped_event = new()

/decl/observ/unequipped
	name = "Logged In"
	expected_type = /mob

/**********************
* Unequipped Handling *
**********************/

/obj/item/dropped(var/mob/user)
	..()
	unequipped_event.raise_event(user, src)
