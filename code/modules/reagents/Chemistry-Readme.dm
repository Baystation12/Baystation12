/*
NOTE: IF YOU UPDATE THE REAGENT-SYSTEM, ALSO UPDATE THIS README.

Structure: ///////////////////          //////////////////////////
		   // Mob or object // -------> // Reagents var (datum) // 	    Is a reference to the datum that holds the reagents.
		   ///////////////////          //////////////////////////
		   			|				    			 |
	The object that holds everything.   			 V
		   							      reagent_list var (list)   	A List of datums, each datum is a reagent.

		   							      |          |          |
		   							      V          V          V

		   							         reagents (datums)	    	Reagents. I.e. Water , antitoxins or mercury.


Random important notes:

	An objects on_reagent_change will be called every time the objects reagents change.
	Useful if you want to update the objects icon etc.

About the Holder:

	The holder (reagents datum) is the datum that holds a list of all reagents
	currently in the object.It also has all the procs needed to manipulate reagents

	Vars:
		list/datum/reagent/reagent_list
			List of reagent datums.

		total_volume
			Total volume of all reagents.

		maximum_volume
			Maximum volume.

		atom/my_atom
			Reference to the object that contains this.

	Procs:

		get_free_space()
			Returns the remaining free volume in the holder.

		get_master_reagent()
			Returns the reference to the reagent with the largest volume

		get_master_reagent_name()
			Ditto, but returns the name.

		get_master_reagent_id()
			Ditto, but returns ID.

		update_total()
			Updates total volume, called automatically.

		handle_reactions()
			Checks reagents and triggers any reactions that happen. Usually called automatically.

		add_reagent(var/id, var/amount, var/data = null, var/safety = 0)
			Adds [amount] units of [id] reagent. [data] will be passed to reagent's mix_data() or initialize_data(). If [safety] is 0, handle_reactions() will be called. Returns 1 if successful, 0 otherwise.

		remove_reagent(var/id, var/amount, var/safety = 0)
			Ditto, but removes reagent. Returns 1 if successful, 0 otherwise.

		del_reagent(var/id)
			Removes all of the reagent.

		has_reagent(var/id, var/amount = 0)
			Checks if holder has at least [amount] of [id] reagent. Returns 1 if the reagent is found and volume is above [amount]. Returns 0 otherwise.

		clear_reagents()
			Removes all reagents.

		get_reagent_amount(var/id)
			Returns reagent volume. Returns 0 if reagent is not found.

		get_data(var/id)
			Returns get_data() of the reagent.

		get_reagents()
			Returns a string containing all reagent ids and volumes, e.g. "carbon(4),nittrogen(5)".

		remove_any(var/amount = 1)
			Removes up to [amount] of reagents from [src]. Returns actual amount removed.

		trans_to_holder(var/datum/reagents/target, var/amount = 1, var/multiplier = 1, var/copy = 0)
			Transfers [amount] reagents from [src] to [target], multiplying them by [multiplier]. Returns actual amount removed from [src] (not amount transferred to [target]). If [copy] is 1, copies reagents instead.

		touch(var/atom/target)
			When applying reagents to an atom externally, touch() is called to trigger any on-touch effects of the reagent.
			This does not handle transferring reagents to things.
			For example, splashing someone with water will get them wet and extinguish them if they are on fire,
			even if they are wearing an impermeable suit that prevents the reagents from contacting the skin.
			Basically just defers to touch_mob(target), touch_turf(target), or touch_obj(target), depending on target's type.
			Not recommended to use this directly, since trans_to() calls it before attempting to transfer.

		touch_mob(var/mob/target)
			Calls each reagent's touch_mob(target).

		touch_turf(var/turf/target)
			Calls each reagent's touch_turf(target).

		touch_obj(var/obj/target)
			Calls each reagent's touch_obj(target).

		trans_to(var/atom/target, var/amount = 1, var/multiplier = 1, var/copy = 0)
			The general proc for applying reagents to things externally (as opposed to directly injected into the contents). 
			It first calls touch, then the appropriate trans_to_*() or splash_mob().
			If for some reason you want touch effects to be bypassed (e.g. injecting stuff directly into a reagent container or person), call the appropriate trans_to_*() proc.
			
			Calls touch() before checking the type of [target], calling splash_mob(target, amount), trans_to_turf(target, amount, multiplier, copy), or trans_to_obj(target, amount, multiplier, copy).

		trans_id_to(var/atom/target, var/id, var/amount = 1)
			Transfers [amount] of [id] to [target]. Returns amount transferred.

		splash_mob(var/mob/target, var/amount = 1, var/clothes = 1)
			Checks mob's clothing if [clothes] is 1 and transfers [amount] reagents to mob's skin.
			Don't call this directly. Call apply_to() instead.

		trans_to_mob(var/mob/target, var/amount = 1, var/type = CHEM_BLOOD, var/multiplier = 1, var/copy = 0)
			Transfers [amount] reagents to the mob's appropriate holder, depending on [type]. Ignores protection.

		trans_to_turf(var/turf/target, var/amount = 1, var/multiplier = 1, var/copy = 0)
			Turfs don't currently have any reagents. Puts [amount] reagents into a temporary holder, calls touch_turf(target) from it, and deletes it.

		trans_to_obj(var/turf/target, var/amount = 1, var/multiplier = 1, var/copy = 0)
			If target has reagents, transfers [amount] to it. Otherwise, same as trans_to_turf().

		atom/proc/create_reagents(var/max_vol)
			Creates a new reagent datum.

About Reagents:

	Reagents are all the things you can mix and fille in bottles etc. This can be anything from
	rejuvs over water to... iron.

	Vars:

		name
			Name that shows up in-game.

		id
			ID that is used for internal tracking. MUST BE UNIQUE.

		description
			Description that shows up in-game.

		datum/reagents/holder
			Reference to holder.

		reagent_state
			Could be GAS, LIQUID, or SOLID. Affects nothing. Reserved for future use.

		list/data
			Use varies by reagent. Custom variable. For example, blood stores blood group and viruses.

		volume
			Current volume.

		metabolism
			How quickly reagent is processed in mob's bloodstream; by default aslo affects ingest and touch metabolism.

		ingest_met
			How quickly reagent is processed when ingested; [metabolism] is used if zero.

		touch_met
			Ditto when touching.

		dose
			How much of the reagent has been processed, limited by [max_dose]. Used for reagents with varying effects (e.g. ethanol or rezadone) and overdosing.

		max_dose
			Maximum amount of reagent that has ever been in a mob. Exists so dose won't grow infinitely when small amounts of reagent are added over time.

		overdose
			If [dose] is bigger than [overdose], overdose() proc is called every tick.

		scannable
			If set to 1, will show up on health analyzers by name.

		glass_icon_state
			Used by drinks. icon_state of the glass when this reagent is the master reagent.

		glass_name
			Ditto for glass name.

		glass_desc
			Ditto for glass desciption.

		glass_center_of_mass
			Used for glass placement on tables.

		color
			"#RRGGBB" or "#RRGGBBAA" where A is alpha channel.

		color_weight
			How much reagent affects color of holder. Used by paint.

	Procs:

		remove_self(var/amount)
			Removes [amount] of itself.

		touch_mob(var/mob/M)
			Called when reagent is in another holder and not splashing the mob. Can be used with noncarbons.

		touch_obj(var/obj/O)
			How reagent reacts with objects.

		touch_turf(var/turf/T)
			How reagent reacts with turfs.

		on_mob_life(var/mob/living/carbon/M, var/alien, var/location)
			Makes necessary checks and calls one of affect procs.

		affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
			How reagent affects mob when injected. [removed] is the amount of reagent that has been removed this tick. [alien] is the mob's reagent flag.

		affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
			Ditto, ingested. Defaults to affect_blood with halved dose.

		affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
			Ditto, touching.

		overdose(var/mob/living/carbon/M, var/alien)
			Called when dose is above overdose. Defaults to M.adjustToxLoss(REM).

		initialize_data(var/newdata)
			Called when reagent is created. Defaults to setting [data] to [newdata].

		mix_data(var/newdata, var/newamount)
			Called when [newamount] of reagent with [newdata] data is added to the current reagent. Used by paint.

		get_data()
			Returns data. Can be overriden.

About Recipes:

	Recipes are simple datums that contain a list of required reagents and a result.
	They also have a proc that is called when the recipe is matched.

	Vars:

		name
			Name of the reaction, currently unused.

		id
			ID of the reaction, must be unique.

		result
			ID of the resulting reagent. Can be null.

		list/required_reagents
			Reagents that are required for the reaction and are used up during it.

		list/catalysts
			Ditto, but not used up.

		list/inhibitors
			Opposite, prevent the reaction from happening.

		result_amount
			Amount of resulting reagent.

		mix_message
			Message that is shown to mobs when reaction happens.

	Procs:

		can_happen(var/datum/reagents/holder)
			Customizable. If it returns 0, reaction will not happen. Defaults to always returning 1. Used by slime core reactions.

		on_reaction(var/datum/reagents/holder, var/created_volume)
			Called when reaction happens. Used by explosives.

		send_data(var/datum/reagents/T)
			Sets resulting reagent's data. Used by blood paint.

About the Tools:

	By default, all atom have a reagents var - but its empty. if you want to use an object for the chem.
	system you'll need to add something like this in its new proc:

		atom/proc/create_reagents(var/max_volume)

	Other important stuff:

		amount_per_transfer_from_this var
			This var is mostly used by beakers and bottles.
			It simply tells us how much to transfer when
			'pouring' our reagents into something else.

		atom/proc/is_open_container()
			Checks atom/var/obj_flags & OBJ_FLAG_OPEN_CONTAINER.
			If this returns 1 , you can use syringes, beakers etc
			to manipulate the contents of this object.
			If it's 0, you'll need to write your own custom reagent
			transfer code since you will not be able to use the standard
			tools to manipulate it.

*/
