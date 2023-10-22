/* Stack type objects!
 * Contains:
 * 		Stacks
 * 		Recipe datum
 * 		Recipe list datum
 */

/*
 * Stacks
 */

/obj/item/stack
	gender = PLURAL
	origin_tech = list(TECH_MATERIAL = 1)
	var/list/datum/stack_recipe/recipes
	var/singular_name
	var/plural_name
	/// String. The stack's base icon state. Used when the amount is 2 or lower.
	var/base_state
	/// String. The stack's icon state when amount is greater than 2.
	var/plural_icon_state
	/// String. The stack's icon state at the maximum amount.
	var/max_icon_state
	var/amount = 1
	var/max_amount //also see stack recipes initialisation, param "max_res_amount" must be equal to this max_amount
	var/stacktype //determines whether different stack types can merge
	var/build_type = null //used when directly applied to a turf
	var/uses_charge = 0
	var/list/charge_costs = null
	var/list/datum/matter_synth/synths = null

/obj/item/stack/New(loc, amount=null)
	if (!stacktype)
		stacktype = type
	if (amount >= 1)
		src.amount = amount
	..()

/obj/item/stack/Initialize()
	. = ..()
	if(!plural_name)
		plural_name = "[singular_name]s"


/obj/item/stack/Destroy()
	if(uses_charge)
		return 1
	if (src && usr && usr.machine == src)
		close_browser(usr, "window=stack")
	return ..()

/obj/item/stack/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		if(!uses_charge)
			to_chat(user, "There [amount == 1 ? "is 1 [singular_name]" : "are [amount] [plural_name]"] in the stack.")
		else
			to_chat(user, "There is enough charge for [get_amount() == 1 ? "1 [singular_name]" : "[amount] [plural_name]"].")

/obj/item/stack/attack_self(mob/user as mob)
	list_recipes(user)

/obj/item/stack/proc/list_recipes(mob/user as mob, recipes_sublist)
	if (!recipes)
		return
	if (!src || get_amount() <= 0)
		close_browser(user, "window=stack")
	user.set_machine(src) //for correct work of onclose
	var/list/recipe_list = recipes
	if (recipes_sublist && recipe_list[recipes_sublist] && istype(recipe_list[recipes_sublist], /datum/stack_recipe_list))
		var/datum/stack_recipe_list/srl = recipe_list[recipes_sublist]
		recipe_list = srl.recipes
	var/t1 = list()
	t1 += "<HTML><HEAD><title>Constructions from [src]</title></HEAD><body><TT>Amount Left: [src.get_amount()]<br>"
	for(var/i=1;i<=length(recipe_list),i++)
		var/E = recipe_list[i]
		if (isnull(E))
			continue

		if (istype(E, /datum/stack_recipe_list))
			t1+="<br>"
			var/datum/stack_recipe_list/srl = E
			t1 += "\[Sub-menu] <a href='?src=\ref[src];sublist=[i]'>[srl.title]</a>"

		if (istype(E, /datum/stack_recipe))
			var/datum/stack_recipe/R = E
			t1+="<br>"
			var/max_multiplier = round(src.get_amount() / R.req_amount)
			var/title
			var/can_build = 1
			can_build = can_build && (max_multiplier>0)
			if (R.res_amount>1)
				title+= "[R.res_amount]x [R.display_name()]\s"
			else
				title+= "[R.display_name()]"
			title+= " ([R.req_amount] [src.singular_name]\s)"
			var/skill_label = ""
			if(!user.skill_check(SKILL_CONSTRUCTION, R.difficulty))
				var/singleton/hierarchy/skill/S = GET_SINGLETON(SKILL_CONSTRUCTION)
				skill_label = SPAN_COLOR("red", "\[[S.levels[R.difficulty]]\]")
			if (can_build)
				t1 +="[skill_label]<A href='?src=\ref[src];sublist=[recipes_sublist];make=[i];multiplier=1'>[title]</A>"
			else
				t1 += "[skill_label][title]"
			if (R.max_res_amount>1 && max_multiplier>1)
				max_multiplier = min(max_multiplier, round(R.max_res_amount/R.res_amount))
				t1 += " |"
				var/list/multipliers = list(5,10,25)
				for (var/n in multipliers)
					if (max_multiplier>=n)
						t1 += " <A href='?src=\ref[src];make=[i];multiplier=[n]'>[n*R.res_amount]x</A>"
				if (!(max_multiplier in multipliers))
					t1 += " <A href='?src=\ref[src];make=[i];multiplier=[max_multiplier]'>[max_multiplier*R.res_amount]x</A>"

	t1 += "</TT></body></HTML>"
	show_browser(user, JOINTEXT(t1), "window=stack")
	onclose(user, "stack")

/obj/item/stack/proc/produce_recipe(datum/stack_recipe/recipe, quantity, mob/user)
	var/required = quantity*recipe.req_amount
	var/produced = min(quantity*recipe.res_amount, recipe.max_res_amount)

	var/area/A = get_area(user)
	if (!A.can_modify_area())
		to_chat(user, SPAN_WARNING("You can't seem to make anything with \the [src] here."))
		return

	if (!can_use(required))
		if (produced>1)
			to_chat(user, SPAN_WARNING("You haven't got enough [src] to build \the [produced] [recipe.display_name()]\s!"))
		else
			to_chat(user, SPAN_WARNING("You haven't got enough [src] to build \the [recipe.display_name()]!"))
		return

	if(!recipe.can_make(user))
		return

	if (recipe.time)
		to_chat(user, SPAN_NOTICE("Building [recipe.display_name()] ..."))
		if (!user.do_skilled(recipe.time, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT | DO_BAR_OVER_USER))
			return

	if (use(required))
		if(user.skill_fail_prob(SKILL_CONSTRUCTION, 90, recipe.difficulty))
			to_chat(user, SPAN_WARNING("You waste some [name] and fail to build \the [recipe.display_name()]!"))
			return
		var/atom/O = recipe.spawn_result(user, user.loc, produced)
		// Stack recipes will delete the created item if it merges with a stack already in hand.
		if (!QDELETED(O))
			O.add_fingerprint(user)
			user.put_in_hands(O)

/obj/item/stack/Topic(href, href_list)
	..()
	if ((usr.restrained() || usr.stat || usr.get_active_hand() != src))
		return

	if (href_list["sublist"] && !href_list["make"])
		list_recipes(usr, text2num(href_list["sublist"]))

	if (href_list["make"])
		if (src.get_amount() < 1) qdel(src) //Never should happen

		var/list/recipes_list = recipes
		if (href_list["sublist"])
			var/datum/stack_recipe_list/srl = recipes_list[text2num(href_list["sublist"])]
			recipes_list = srl.recipes

		var/datum/stack_recipe/R = recipes_list[text2num(href_list["make"])]
		var/multiplier = text2num(href_list["multiplier"])
		if (!multiplier || (multiplier <= 0)) //href exploit protection
			return

		src.produce_recipe(R, multiplier, usr)

	if (src && usr.machine==src) //do not reopen closed window
		spawn( 0 )
			src.interact(usr)
			return
	return

//Return 1 if an immediate subsequent call to use() would succeed.
//Ensures that code dealing with stacks uses the same logic
/obj/item/stack/proc/can_use(used)
	if (get_amount() < used)
		return 0
	return 1

/obj/item/stack/proc/use(used)
	if (!can_use(used))
		return 0
	if(!uses_charge)
		amount -= used
		if (amount <= 0)
			qdel(src) //should be safe to qdel immediately since if someone is still using this stack it will persist for a little while longer
		else
			update_icon()
		return 1
	else
		if(get_amount() < used)
			return 0
		for(var/i = 1 to length(charge_costs))
			var/datum/matter_synth/S = synths[i]
			S.use_charge(charge_costs[i] * used) // Doesn't need to be deleted
		return 1

/obj/item/stack/proc/add(extra)
	if(!uses_charge)
		if(amount + extra > get_max_amount())
			return 0
		else
			amount += extra
			update_icon()
		return 1
	else if(!synths || length(synths) < uses_charge)
		return 0
	else
		for(var/i = 1 to uses_charge)
			var/datum/matter_synth/S = synths[i]
			S.add_charge(charge_costs[i] * extra)

/*
	The transfer and split procs work differently than use() and add().
	Whereas those procs take no action if the desired amount cannot be added or removed these procs will try to transfer whatever they can.
	They also remove an equal amount from the source stack.
*/

//attempts to transfer amount to S, and returns the amount actually transferred
/obj/item/stack/proc/transfer_to(obj/item/stack/S, tamount=null, type_verified)
	if (!get_amount())
		return 0
	if ((stacktype != S.stacktype) && !type_verified)
		return 0
	if (isnull(tamount))
		tamount = src.get_amount()

	var/transfer = max(min(tamount, src.get_amount(), (S.get_max_amount() - S.get_amount())), 0)

	var/orig_amount = src.get_amount()
	if (transfer && src.use(transfer))
		S.add(transfer)
		if (prob(transfer/orig_amount * 100))
			transfer_fingerprints_to(S)
		return transfer
	return 0

//creates a new stack with the specified amount
/obj/item/stack/proc/split(tamount)
	if (!amount)
		return null

	var/transfer = max(min(tamount, src.amount, initial(max_amount)), 0)

	var/orig_amount = src.amount
	if (transfer && src.use(transfer))
		var/obj/item/stack/newstack
		if(uses_charge)
			newstack = new src.stacktype(loc, transfer)
		else
			newstack = new src.type(loc, transfer)
		newstack.copy_from(src)
		if (prob(transfer/orig_amount * 100))
			transfer_fingerprints_to(newstack)
		return newstack
	return null

/obj/item/stack/proc/copy_from(obj/item/stack/other)
	color = other.color

/obj/item/stack/proc/get_amount()
	if(uses_charge)
		if(!synths || length(synths) < uses_charge)
			return 0
		var/datum/matter_synth/S = synths[1]
		. = round(S.get_charge() / charge_costs[1])
		if(length(charge_costs) > 1)
			for(var/i = 2 to length(charge_costs))
				S = synths[i]
				. = min(., round(S.get_charge() / charge_costs[i]))
		return
	return amount

/obj/item/stack/proc/get_max_amount()
	if(uses_charge)
		if(!synths || length(synths) < uses_charge)
			return 0
		var/datum/matter_synth/S = synths[1]
		. = round(S.max_energy / charge_costs[1])
		if(uses_charge > 1)
			for(var/i = 2 to uses_charge)
				S = synths[i]
				. = min(., round(S.max_energy / charge_costs[i]))
		return
	return max_amount

/obj/item/stack/proc/add_to_stacks(mob/user, check_hands)
	var/list/stacks = list()
	if(check_hands)
		for (var/obj/item/stack/stack as anything in user.GetAllHeld(/obj/item/stack))
			stacks += stack
	for (var/obj/item/stack/item in user.loc)
		stacks |= item
	for (var/obj/item/stack/item in stacks)
		if (item==src)
			continue
		var/transfer = src.transfer_to(item)
		if (transfer)
			to_chat(user, SPAN_NOTICE("You add a new [item.singular_name] to the stack. It now contains [item.get_exact_name(item.amount)]."))
		if(!amount)
			break

/obj/item/stack/get_storage_cost()	//Scales storage cost to stack size
	. = ..()
	if (amount < max_amount)
		. = ceil(. * amount / max_amount)

/obj/item/stack/attack_hand(mob/user as mob)
	if (user.get_inactive_hand() == src)
		var/N = input("How many [plural_name] of \the [src] would you like to split off?", "Split stacks", 1) as num|null
		if(N)
			var/obj/item/stack/F = src.split(N)
			if (F)
				user.put_in_hands(F)
				src.add_fingerprint(user)
				F.add_fingerprint(user)
				spawn(0)
					if (src && usr.machine==src)
						src.interact(usr)
	else
		..()
	return

/obj/item/stack/use_tool(obj/item/tool, mob/living/user, list/click_params)
	if (istype(tool, /obj/item/stack))
		var/obj/item/stack/new_stack = tool
		transfer_to(new_stack)

		spawn(0) //give the stacks a chance to delete themselves if necessary
			if (new_stack && user.machine == new_stack)
				new_stack.interact(usr)
			if (src && user.machine == src)
				interact(user)
		return TRUE
	return ..()

/**
 * Returns a string forming a basic name of the stack. By default, this is `name`.
 *
 * Has no parameters.
 */
/obj/item/stack/proc/get_stack_name()
	return name


/**
 * Generates a name usable in messages without a specific number attached, i.e. `a sheet of paper` or `some paper sheets`.
 *
 * **Parameters**:
 * - `plural` (Boolean, default `(src.amount == 1)`) - Whether the message uses `plural_name` or `singular_name`, and the proper grammatical rules.
 *
 * Returns string.
 */
/obj/item/stack/proc/get_vague_name(plural)
	if (isnull(plural))
		plural = (src.amount == 1)
	if (plural)
		return "some [get_stack_name()] [plural_name]"
	else
		return "\a [singular_name] of [get_stack_name()]"


/**
 * Generates a name usable in messages with a specific number attached, i.e. `1 sheet of paper` or `5 paper sheets`.
 *
 * **Parameters**:
 * - `amount` (Integer, default `src.amount`) - The number of items for the message. Also determines whether `plural_name` or `singular_name` are used.
 *
 * Returns string.
 */
/obj/item/stack/proc/get_exact_name(amount)
	if (isnull(amount))
		amount = src.amount
	if (amount == 1)
		return "[amount] [singular_name] of [get_stack_name()]"
	return "[amount] [get_stack_name()] [plural_name]"


/*
 * Recipe datum
 */
/datum/stack_recipe
	var/title = "ERROR"
	var/result_type
	var/req_amount = 1 //amount of material needed for this recipe
	var/res_amount = 1 //amount of stuff that is produced in one batch (e.g. 4 for floor tiles)
	var/max_res_amount = 1
	var/time = 0
	var/one_per_turf = 0
	var/on_floor = 0
	var/use_material
	var/use_reinf_material
	var/difficulty = 1 // higher difficulty requires higher skill level to make.
	var/send_material_data = 0 //Whether the recipe will send the material name as an argument when creating product.
	var/apply_material_name = 1 //Whether the recipe will prepend a material name to the title - 'steel clipboard' vs 'clipboard'

/datum/stack_recipe/New(material/material, reinforce_material)
	if(material)
		use_material = material.name
		difficulty += material.construction_difficulty
		difficulty = clamp(difficulty, MATERIAL_EASY_DIY, MATERIAL_VERY_HARD_DIY)
	if(reinforce_material)
		use_reinf_material = reinforce_material

/datum/stack_recipe/proc/display_name()
	if(!use_material || !apply_material_name)
		return title
	. = "[material_display_name(use_material)] [title]"
	if(use_reinf_material)
		. = "[material_display_name(use_reinf_material)]-reinforced [.]"

/datum/stack_recipe/proc/spawn_result(mob/user, location, amount)
	var/atom/O
	if(send_material_data && use_material)
		O = new result_type(location, use_material, use_reinf_material)
	else
		O = new result_type(location)
	O.set_dir(user.dir)
	return O

/datum/stack_recipe/proc/can_make(mob/user)
	if (one_per_turf && (locate(result_type) in user.loc))
		to_chat(user, SPAN_WARNING("There is another [display_name()] here!"))
		return FALSE

	var/turf/T = get_turf(user.loc)
	if (on_floor && !T.is_floor())
		to_chat(user, SPAN_WARNING("\The [display_name()] must be constructed on the floor!"))
		return FALSE

	return TRUE

/*
 * Recipe list datum
 */
/datum/stack_recipe_list
	var/title = "ERROR"
	var/list/recipes = null

/datum/stack_recipe_list/New(title, recipes)
	src.title = title
	src.recipes = recipes
