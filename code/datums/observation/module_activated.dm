//	Observer Pattern Implementation: Module Activated
//		Registration type: /mob/living/silicon/robot
//
//		Raised when: A robot activates a module.
//
//		Arguments that the called proc should expect:
//			/mob/living/silicon/robot/robot:  The robot that activated the module.
//			/obj/item/module:                 The activated module.

GLOBAL_DATUM_INIT(module_activated_event, /decl/observ/module_activated, new)

/decl/observ/module_activated
	name = "Module Activated"
	expected_type = /mob/living/silicon/robot

/****************************
* Module Activated Handling *
****************************/

// Called from /mob/living/silicon/robot/proc/activate_module
// in code/modules/mob/living/silicon/robot/inventory.dm