
/obj/item/weapon/gun/projectile/ripper
	name = "RC-DS Remote Control Disc Ripper"
	desc = "Suspends a spinning sawblade in the air with a mini gravity tether"
	w_class = ITEM_SIZE_HUGE
	obj_flags =  OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BACK
	icon_state = "oldlaser"
	max_shells = 8
	caliber = "saw"
	ammo_type = /obj/item/ammo_casing/sawblade

	firemodes = list(
		list(mode_name="remote control", mode_type = /datum/firemode/remote),
		list(mode_name="saw launcher",       burst=1, fire_delay=0,    move_delay=null, one_hand_penalty=0, burst_accuracy=null, dispersion=null)
		)


	//Holds a reference to the currently projected sawblade we have out, if any.
	var/obj/item/projectile/sawblade/blade = null


//Sawblade statuses
#define STATE_STABLE	0
#define STATE_MOVING	1
#define STATE_GRINDING	2


//Whenever afterattack is called on the ripper...
/obj/item/weapon/gun/projectile/ripper/afterattack(atom/A, mob/living/user, adjacent, params)
	world << "Afterattack called"
	if (blade)
		//If we already have a blade out then we'll update its location
		blade.set_global_clickpoint(params)
		blade.status = STATE_MOVING //And set it to moving state so that it attempts to go towards the new destination
		return

	//If there's no blade out, then call parent which will launch a new blade
	return ..()

//Don't fire another blade if there's one out
/obj/item/weapon/gun/projectile/ripper/can_fire(atom/target, mob/living/user, clickparams, var/silent = FALSE)
	if (blade)
		return FALSE

	return ..()


//When we fire a blade,grab a reference to it and start controlling it
/obj/item/weapon/gun/projectile/ripper/consume_next_projectile(user)
	.=..()

	//Only if we're in remote control mode. We don't care about blades if we're launching them
	var/datum/firemode/current_mode = firemodes[sel_mode]
	if (istype(current_mode, /datum/firemode/remote))
		if (.)
			blade = .


//This is the proc where the projectile is launched from the gun. We override it here because we don't want the blade to necessarily go flying
/obj/item/weapon/gun/projectile/ripper/process_projectile(obj/projectile, mob/user, atom/target, var/target_zone, var/params=null)

	//If we're in remote control mode, we place the projectile in the world manually
	var/datum/firemode/current_mode = firemodes[sel_mode]
	if (istype(current_mode, /datum/firemode/remote))
		var/turf/T = get_step(user, user.dir)

		//If theres a clear space infront of you, it goes there
		if (turf_clear(T))
			projectile.forceMove(T)
		else
			//If you're standing up against a wall, you saw yourself, ya dumb idiot
			projectile.forceMove(get_turf(user))
		if (blade)
			world << "Starting blade tick"
			blade.tick()
		return TRUE

	//If we're not in remote mode, we return parent, which will launch the projectile as normal
	return ..()



//Sustained remote control
/datum/firemode/remote
	settings = list(burst = 1, suppress_delay_warning = TRUE, dispersion=list(0.0))
	//The full auto clickhandler we have
	var/datum/click_handler/sustained/CH = null

/datum/firemode/remote/update(var/force_state = null)
	var/mob/living/L

	if (gun && gun.is_held())
		L = gun.loc

	var/enable = FALSE
	//Force state is used for forcing it to be disabled in circumstances where it'd normally be valid
	if (!isnull(force_state))
		enable = force_state
	else if (L && L.client)

		//First of all, lets determine whether we're enabling or disabling the click handler


		//We enable it if the gun is held in the user's active hand and the safety is off
		if (L.get_active_hand() == gun)
			//Lets also make sure it can fire
			var/can_fire = TRUE

			//Possible TODO here: Check the ripper has enough power in a cell?

			//TODO: Centralise all this into some can_fire proc
			if (can_fire)
				enable = TRUE
		else
			enable = FALSE

	world << "updating firemode. Enable: [enable]"
	//Ok now lets set the desired state
	if (!enable)
		if (!CH)
			//If we're turning it off, but the click handler doesn't exist, then we have nothing to do
			world << "Turning off, handler doesnt exist, do nothing"
			return

		//Todo: make client click handlers into a list
		if (CH.user) //Remove our handler from the client
			world << "Turning off, handler exists, removing it"
			CH.user.RemoveClickHandler(CH)
			CH = null
		return

	else
		//We're trying to turn things on
		if (CH)
			world << "Turning on, handler exists, do nothing"
			return //The click handler exists, we dont need to do anything


		//Create and assign the click handler
		//A click handler intercepts mouseup/drag/down events which allow fullauto firing
		world << "Turning on, handler doesnt exist, creating it"
		CH = L.PushClickHandler(/datum/click_handler/sustained)
		CH.reciever = gun //Reciever is the gun that gets the fire events
		CH.user = L //And tell it where it is