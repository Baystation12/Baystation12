#define CHARGING_POWER 75000

/obj/machinery/recharge_station
	name = "cyborg recharging station"
	icon = 'icons/obj/objects.dmi'
	icon_state = "borgcharger0"
	density = 1
	anchored = 1.0
	use_power = 0
	idle_power_usage = 5000
	active_power_usage = 25000
	var/mob/occupant = null

	var/obj/item/weapon/cell/internal

	var/cooldown = 0
	var/charging = 0


	New()
		..()
		build_icon()
		
		internal = new /obj/item/weapon/cell/super()

	process()
		charging = 0
		
		if(stat & BROKEN)
			return
		
		if (internal.charge && src.occupant && istype(occupant, /mob/living/silicon/robot))
			var/mob/living/silicon/robot/R = occupant
			if (R.cell)
				if (R.cell.fully_charged())
					cooldown = 20 //to avoid flipping between idle and active power when the robot is fully charged
				else
					cooldown--
				
				if (cooldown <= 0)
					charging = 1
		
		//Trickle charge the internal cell.
		if(!internal.fully_charged() && !(stat & NOPOWER))
			if(charging)
				update_use_power(2)
				internal.give(active_power_usage*CELLRATE)
			else
				update_use_power(1)
				internal.give(idle_power_usage*CELLRATE)
		
		if(charging)
			process_occupant()
		
		build_icon()
		
		return 1

	allow_drop()
		return 0


	relaymove(mob/user as mob)
		if(user.stat)
			return
		src.go_out()
		return

	emp_act(severity)
		if(stat & (BROKEN|NOPOWER))
			..(severity)
			return
		if(occupant)
			occupant.emp_act(severity)
			go_out()
		..(severity)
	
	examine()
		..()
		usr << "<span class='notice'>The reserve charge meter reads [round(internal.percent())]%.</span>"

	proc
		build_icon()
			if(charging)
				icon_state = "borgcharger1"
			else
				icon_state = "borgcharger0"

		process_occupant()
			if(src.occupant)
				if (istype(occupant, /mob/living/silicon/robot))
					var/mob/living/silicon/robot/R = occupant
					if(R.module)
						R.module.respawn_consumable(R)
					if(!R.cell)
						return
					if(!R.cell.fully_charged())
						if (internal.use(CHARGING_POWER*CELLRATE))
							R.cell.give(CHARGING_POWER*CELLRATE)
						else
							R.cell.give(internal.charge)
							internal.charge = 0
		
		go_out()
			if(!( src.occupant ))
				return
			//for(var/obj/O in src)
			//	O.loc = src.loc
			if (src.occupant.client)
				src.occupant.client.eye = src.occupant.client.mob
				src.occupant.client.perspective = MOB_PERSPECTIVE
			src.occupant.loc = src.loc
			src.occupant = null
			return


	verb
		move_eject()
			set category = "Object"
			set src in oview(1)
			if (usr.stat != 0)
				return
			src.go_out()
			add_fingerprint(usr)
			return

		move_inside()
			set category = "Object"
			set src in oview(1)
			if (usr.stat == 2)
				//Whoever had it so that a borg with a dead cell can't enter this thing should be shot. --NEO
				return
			if (!(istype(usr, /mob/living/silicon/)))
				usr << "<span class='notice'><B>Only non-organics may enter the recharger!</B></span>"
				return
			if (src.occupant)
				usr << "<span class='notice'><B>The cell is already occupied!</B></span>"
				return
			if (!usr:cell)
				usr<<"<span class='notice'>Without a powercell, you can't be recharged</span>"
				//Make sure they actually HAVE a cell, now that they can get in while powerless. --NEO
				return
			usr.stop_pulling()
			if(usr && usr.client)
				usr.client.perspective = EYE_PERSPECTIVE
				usr.client.eye = src
			usr.loc = src
			src.occupant = usr
			/*for(var/obj/O in src)
				O.loc = src.loc*/
			src.add_fingerprint(usr)
			return