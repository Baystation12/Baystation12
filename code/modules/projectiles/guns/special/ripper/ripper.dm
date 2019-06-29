
/obj/item/weapon/gun/projectile/ripper
	name = "RC-DS Remote Control Disc Ripper"
	desc = "Suspends a spinning sawblade in the air with a mini gravity tether"
	w_class = ITEM_SIZE_HUGE
	obj_flags =  OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BACK
	icon_state = "oldlaser"
	max_shells = 8
	caliber = "saw"
	handle_casings = CLEAR_CASINGS
	fire_delay = 10
	fire_sound = 'sound/weapons/tablehit1.ogg'
	load_sound = 'sound/weapons/guns/interaction/shotgun_instert.ogg'

	firemodes = list(
		list(mode_name="remote control", mode_type = /datum/firemode/remote),
		list(mode_name="saw launcher",       burst=1, fire_delay=10,    move_delay=null, one_hand_penalty=0, burst_accuracy=null, dispersion=null)
		)



	//Maximum distance, in pixels, that the blade is allowed to be from the gun/user.
	var/max_range = 100

	//Holds a reference to the currently projected sawblade we have out, if any.
	var/obj/item/projectile/sawblade/blade = null

	//The gravity tether, a visual laser which connects gun and blade
	var/obj/effect/projectile/sustained/tether = null

	//World pixel coords of where a user last clicked to fire this gun
	var/vector2/last_clickpoint = new /vector2(0,0)


/obj/item/weapon/gun/projectile/ripper/loaded
	ammo_type = /obj/item/ammo_casing/sawblade

/obj/item/weapon/gun/projectile/ripper/loaded/diamond
	ammo_type = /obj/item/ammo_casing/sawblade/diamond

//Sawblade statuses
#define STATE_STABLE	0
#define STATE_MOVING	1
#define STATE_GRINDING	2


//Whenever afterattack is called on the ripper...
/obj/item/weapon/gun/projectile/ripper/afterattack(atom/A, mob/living/user, adjacent, params, var/vector2/global_clickpoint)

	if (global_clickpoint)
		last_clickpoint = global_clickpoint
	if (blade)

		//Now first of all, we need to check if the targeted point is within range of user
		var/vector2/user_loc = user.get_global_pixel_loc()
		var/vector2/userdiff = last_clickpoint - user_loc
		//If its farther than the max distance from the user
		if (userdiff.Magnitude() > max_range)
			userdiff = userdiff.ToMagnitude(max_range)//We rescale the magnitude of the diff
			last_clickpoint = user_loc + userdiff //And change clickpoint to the rescaled

		tether.set_ends(user_loc, last_clickpoint) //The tether points to the cursor, the blade catches up with it

		//If we already have a blade out then we'll update its location
		blade.pixel_click = last_clickpoint
		blade.status = STATE_MOVING //And set it to moving state so that it attempts to go towards the new destination
		return

	//If there's no blade out, then call parent which will launch a new blade
	return ..()

/obj/item/weapon/gun/projectile/ripper/user_moved()
	update_tether()

/obj/item/weapon/gun/projectile/ripper/proc/update_tether()
	if (blade && tether)
		var/mob/living/user = loc
		if (istype(user))
			var/vector2/user_loc = user.get_global_pixel_loc()
			tether.set_ends(user_loc, last_clickpoint) //The tether points to the cursor, the blade catches up with it



//Called either when the sawblade breaks, or the user releases the fire button
/obj/item/weapon/gun/projectile/ripper/stop_firing()
	if (!firing)
		return
	firing = FALSE //Prevents recursion
	if (blade && !QDELETED(blade))
		blade.drop() 	//The sawblade will drop on the ground where it hovers, possibly in a reuseable state, possibly not
		blade = null	//Lose our reference to it anyways, its no longer our concern
	QDEL_NULL(tether) //The tether belongs to us, clean it up
	var/datum/firemode/remote/R = get_firemode()
	if (R && R.CH)
		R.CH.firing = FALSE
	next_fire_time = world.time + fire_delay
	..()



//Don't fire another blade if there's one out
/obj/item/weapon/gun/projectile/ripper/can_fire(atom/target, mob/living/user, clickparams, var/silent = FALSE)
	if (blade)
		return FALSE

	return ..()


//Set the health of the projectile to the health of the ammo version
/obj/item/weapon/gun/projectile/ripper/consume_next_projectile()
	.=..()
	if (.)
		var/obj/item/projectile/P = .
		var/obj/item/ammo_casing/sawblade/ammo = chambered
		if (istype(ammo))
			P.health = ammo.health

//This is the proc where the projectile is launched from the gun. We override it here because we don't want the blade to necessarily go flying
/obj/item/weapon/gun/projectile/ripper/process_projectile(obj/projectile, mob/user, atom/target, var/target_zone, var/params=null)

	//If we're in remote control mode, we place the projectile in the world manually
	var/datum/firemode/current_mode = firemodes[sel_mode]
	if (istype(current_mode, /datum/firemode/remote))
		firing = TRUE
		var/turf/T = get_step(user, user.dir)
		blade = projectile
		//If theres a clear space infront of you, it goes there
		if (turf_clear(T))
			blade.forceMove(T)
		else
			//If you're standing up against a wall, you saw yourself, ya dumb idiot
			blade.forceMove(get_turf(user))

		blade.user = user
		//Tell the blade that it was launched in the special remote control mode
		blade.control_launched(src)

		//At this point we also spawn the gravity tether beam
		tether = new(get_turf(user))
		tether.set_ends(user.get_global_pixel_loc(), blade.get_global_pixel_loc())

		//And start the blade ticking

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

	//Ok now lets set the desired state
	if (!enable)
		if (!CH)
			//If we're turning it off, but the click handler doesn't exist, then we have nothing to do
			return

		//Todo: make client click handlers into a list
		if (CH.user) //Remove our handler from the client
			CH.user.RemoveClickHandler(CH)
			CH = null
		return

	else
		//We're trying to turn things on
		if (CH)
			return //The click handler exists, we dont need to do anything


		//Create and assign the click handler
		//A click handler intercepts mouseup/drag/down events which allow fullauto firing
		CH = L.PushClickHandler(/datum/click_handler/sustained)
		CH.reciever = gun //Reciever is the gun that gets the fire events
		CH.user = L //And tell it where it is