/**
 * Singleton definitions for fabrication subsystem crafting stages. These define the individual steps for multi-stage
 * crafting of items.
 *
 * To create a new set of crafting steps, define new crafting stage singleton subtypes. The sequence must include at
 * least one crafting stage with a `begins_with_object_type` set, and at least one craftin stage with a `product` set.
 *
 * Additionally, each crafting stage should be reachable through a previous step's `next_stages` list.
 *
 * Each stage will replace the input object with an instance of `/obj/item/crafting_holder` or update the existing
 * crafting holder instance. In the event where `product` is defined, the input object is instead replaced with a new
 * instance of `product`.
 *
 * Premade subtypes are made for ease of use of specific interactions, such as material stacks or welding tools.
 */
/singleton/crafting_stage
	/// String. Visible description for the crafting holder while at this stage.
	var/item_desc = "It's an unfinished item of some sort."
	/// File (`.dmi`). Icon file to use for the crafting holder while at this stage.
	var/item_icon = 'icons/obj/crafting_icons.dmi'
	/// String (icon state). Icon state to use for the crafting holder while at this stage.
	var/item_icon_state = "default"
	/// Typepath (types of `/obj/item`). Desired type of item to be used to reach this stage.
	var/completion_trigger_type = /obj/item
	/// Boolean. If set, the item used to reach this stage is consumed.
	var/consume_completion_trigger = TRUE
	/// Integer. If `completion_trigger_type` is a stack, this is how much to consume if `consume_completion_trigger` is `TRUE`.
	var/stack_consume_amount
	/// String. Message displayed to user when this stage is reached.
	var/progress_message
	/// Typepath (types of `/obj/item`). If set, objects of this type can be interacted with to start a crafting process and complete this stage, in place of a crafting holder. Only set this for the first step.
	var/begins_with_object_type
	/// List (Paths, types of `/singleton/crafting_stage`). Crafting stages this stage can lead into.
	var/list/next_stages
	/// Typepath (types of `/obj/item`). Crafting result. If set, creates an instance of `product` instead of a crafting holder. Only set this for the final step.
	var/product


/singleton/crafting_stage/New()
	var/stages = list()
	for(var/nid in next_stages)
		stages += GET_SINGLETON(nid)
	next_stages = stages
	..()


/**
 * Whether or not this crafting stage can begin with the provided item.
 *
 * By default, passes through to a type check against `begins_with_object_type`.
 *
 * **Parameters**:
 * - `thing` - Item to check.
 *
 * Returns boolean.
 */
/singleton/crafting_stage/proc/can_begin_with(obj/item/thing)
	. = istype(thing, begins_with_object_type)


/**
 * Retrieves the next crafting stage using the provided item.
 *
 * By default, checks all stages in `next_stages` and compares the item
 * through the next stage's `is_appropriate_tool()` check.
 *
 * **Parameters**:
 * - `trigger` - Item to check.
 *
 * Returns path (Types of `/singleton/crafting_stage`).
 */
/singleton/crafting_stage/proc/get_next_stage(obj/item/trigger)
	for(var/singleton/crafting_stage/next_stage in next_stages)
		if(next_stage.is_appropriate_tool(trigger))
			return next_stage


/**
 * Handles checking if progressing to this crafting stage is possible, then performing the progression.
 *
 * By default, checks `is_appropriate_tool()` and `consume()` then, if `TRUE`, calls `on_progress()`.
 *
 * **Parameters**:
 * - `thing` - Item being used to progress the stage.
 * - `user` - User performing the interaction.
 * - `target` - Prior stage's crafting holder (See `/obj/item/crafting_holder`), or base object being interacted with (See `begins_with_object_type`).
 *
 * Returns boolean. If `TRUE`, the stage was able to progress.
 */
/singleton/crafting_stage/proc/progress_to(obj/item/thing, mob/user, obj/item/target)
	. = is_appropriate_tool(thing, user) && consume(user, thing, target)
	if(.)
		on_progress(user)


/**
 * Checks if the item is the appropriate tool to reach this stage.
 *
 * By default, passes through to a type check against `completion_trigger_type`.
 *
 * **Parameters**:
 * - `thing` - Item to check.
 * - `user` (Default `null`) - Mob performing the interaction.
 *
 * Returns boolean.
 */
/singleton/crafting_stage/proc/is_appropriate_tool(obj/item/thing, mob/user = null)
	. = istype(thing, completion_trigger_type)


/**
 * Handles consuming an item or part of a stack to reach this stage.
 *
 * **Parameters**:
 * - `user` - Mob performing the interaction.
 * - `thing` - Item being used.
 * - `target` - Prior stage's crafting holder (See `/obj/item/crafting_holder`), or base object being interacted with (See `begins_with_object_type`).
 *
 * Returns boolean. If `FALSE`, the item could not be consumed or there was not enough in the stack.
 */
/singleton/crafting_stage/proc/consume(mob/user, obj/item/thing, obj/item/target)
	. = !consume_completion_trigger || (user.unEquip(thing) && thing.forceMove(target))
	if(. && stack_consume_amount > 0)
		var/obj/item/stack/stack = thing
		if(!istype(stack) || stack.amount < stack_consume_amount)
			on_insufficient_material(user)
			return FALSE
		stack.use(stack_consume_amount)


/**
 * Handles failure feedback for insufficient materials in a stack. Called by `consume()`.
 *
 * **Parameters**:
 * - `user` - Mob performing the interaction.
 * - `thing` - Stack being used.
 *
 * Has no return value.
 */
/singleton/crafting_stage/proc/on_insufficient_material(mob/user, obj/item/stack/thing)
	if(istype(thing))
		USE_FEEDBACK_STACK_NOT_ENOUGH(thing, stack_consume_amount, "to complete this task.")


/**
 * Handles additional logic to be performed when the crafting stage progresses to this point.
 *
 * By default, displays `progress_message` to the user.
 *
 * **Parameters**:
 * - `user` - The mob performing the interaction.
 *
 * Has no return value.
 */
/singleton/crafting_stage/proc/on_progress(mob/user)
	if(progress_message)
		to_chat(user, SPAN_NOTICE(progress_message))


/**
 * Instantiates and returns the crafting stage's `product`, if set.
 *
 * **Parameters**:
 * - `work` - Prior stage's crafting holder (See `/obj/item/crafting_holder`), or base object being interacted with (See `begins_with_object_type`).
 *
 * Returns instance of `product`.
 */
/singleton/crafting_stage/proc/get_product(obj/item/work)
	. = ispath(product) && new product(get_turf(work))


// Cable Coil/Wiring
/singleton/crafting_stage/wiring
	completion_trigger_type = /obj/item/stack/cable_coil
	stack_consume_amount = 5
	consume_completion_trigger = FALSE


// Materials
/singleton/crafting_stage/material
	completion_trigger_type = /obj/item/stack/material
	stack_consume_amount = 5
	consume_completion_trigger = FALSE
	/// String (One of `MATERIAL_*`). Material type expected from the stack.
	var/stack_material = MATERIAL_STEEL

/singleton/crafting_stage/material/consume(mob/user, obj/item/thing, obj/item/target)
	var/obj/item/stack/material/M = thing
	. = istype(M) && (!stack_material || M.material.name == stack_material) && ..()


// Welding Tools
/singleton/crafting_stage/welding
	consume_completion_trigger = FALSE

/singleton/crafting_stage/welding/is_appropriate_tool(obj/item/thing, mob/user)
	var/obj/item/weldingtool/T = thing
	. = istype(T) && T.remove_fuel(1, user) && T.isOn()

/singleton/crafting_stage/welding/on_progress(mob/user)
	..()
	playsound(user.loc, 'sound/items/Welder2.ogg', 100, 1)


// Screwdrivers
/singleton/crafting_stage/screwdriver
	consume_completion_trigger = FALSE

/singleton/crafting_stage/screwdriver/is_appropriate_tool(obj/item/thing)
	. = isScrewdriver(thing)

/singleton/crafting_stage/screwdriver/on_progress(mob/user)
	..()
	playsound(user.loc, 'sound/items/Screwdriver.ogg', 100, 1)


// Duct Tape
/singleton/crafting_stage/tape
	consume_completion_trigger = FALSE
	completion_trigger_type = /obj/item

/singleton/crafting_stage/tape/is_appropriate_tool(obj/item/thing)
	. = istype(thing, /obj/item/tape_roll) || istype(thing, /obj/item/taperoll) || istype(thing, /obj/item/stack/cable_coil)


// Pipes
/singleton/crafting_stage/pipe
	completion_trigger_type = /obj/item

/singleton/crafting_stage/pipe/is_appropriate_tool(obj/item/thing)
	. = istype(thing, /obj/item/pipe) || istype(thing, /obj/item/makeshift_barrel)


// Health Scanners
/singleton/crafting_stage/scanner
	completion_trigger_type = /obj/item/device/scanner/health


// Proximity Sensors
/singleton/crafting_stage/proximity
	completion_trigger_type = /obj/item/device/assembly/prox_sensor


// Robot Arms
/singleton/crafting_stage/robot_arms
	progress_message = "You add the robotic arm to the assembly."
	completion_trigger_type = /obj/item/robot_parts

/singleton/crafting_stage/robot_arms/is_appropriate_tool(obj/item/thing)
	. = istype(thing, /obj/item/robot_parts/l_arm) || istype(thing, /obj/item/robot_parts/r_arm)

/singleton/crafting_stage/empty_storage/can_begin_with(obj/item/thing)
	. = ..()
	if(. && istype(thing, /obj/item/storage))
		var/obj/item/storage/box = thing
		. = (length(box.contents) == 0)
