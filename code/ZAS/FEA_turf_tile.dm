atom/var/pressure_resistance = ONE_ATMOSPHERE
turf
	assume_air(datum/gas_mixture/giver) //use this for machines to adjust air
		del(giver)
		return 0

	return_air()
		//Create gas mixture to hold data for passing
		var/datum/gas_mixture/GM = new

		GM.oxygen = oxygen
		GM.carbon_dioxide = carbon_dioxide
		GM.nitrogen = nitrogen
		GM.toxins = toxins

		GM.temperature = temperature
		GM.update_values()

		return GM

	remove_air(amount as num)
		var/datum/gas_mixture/GM = new

		var/sum = oxygen + carbon_dioxide + nitrogen + toxins
		if(sum>0)
			GM.oxygen = (oxygen/sum)*amount
			GM.carbon_dioxide = (carbon_dioxide/sum)*amount
			GM.nitrogen = (nitrogen/sum)*amount
			GM.toxins = (toxins/sum)*amount

		GM.temperature = temperature
		GM.update_values()

		return GM

turf
	simulated

		var/current_graphic = null

		var/tmp
			datum/gas_mixture/air

			processing = 1
//			group_border = 0
//			length_space_border = 0

			air_check_directions = 0 //Do not modify this, just add turf to air_master.tiles_to_update

//			archived_cycle = 0
//			current_cycle = 0

			obj/fire/active_hotspot

//			temperature_archived //USED ONLY FOR SOLIDS
//			being_superconductive = 0


		proc
			process_cell()
			update_air_properties()
			archive()

			mimic_air_with_tile(turf/model)
			share_air_with_tile(turf/simulated/sharer)

			mimic_temperature_with_tile(turf/model)
			share_temperature_with_tile(turf/simulated/sharer)


			super_conduct()

			update_visuals()
				overlays = null

				var/siding_icon_state = return_siding_icon_state()
				if(siding_icon_state)
					overlays += image('floors.dmi',siding_icon_state)
				var/datum/gas_mixture/model = return_air()
				switch(model.graphic)
					if(1)
						overlays.Add(plmaster) //TODO: Make invisible plasma an option
					if(2)
						overlays.Add(slmaster)



		New()
			..()

			if(!blocks_air)
				air = new

				air.oxygen = oxygen
				air.carbon_dioxide = carbon_dioxide
				air.nitrogen = nitrogen
				air.toxins = toxins

				air.temperature = temperature
				air.update_values()

				if(air_master)
					air_master.tiles_to_update.Add(src)

//				air.parent = src //TODO DEBUG REMOVE

			else
				if(air_master)
					for(var/direction in cardinal)
						var/turf/simulated/floor/target = get_step(src,direction)
						if(istype(target))
							air_master.tiles_to_update.Add(target)

		Del()
			if(active_hotspot)
				del(active_hotspot)
			if(blocks_air)
				for(var/direction in list(NORTH, SOUTH, EAST, WEST))
					var/turf/simulated/tile = get_step(src,direction)
					if(istype(tile) && !tile.blocks_air)
						air_master.tiles_to_update.Add(tile)
			..()

		assume_air(datum/gas_mixture/giver)
			if(!giver)	return 0
			if(zone)
				zone.air.merge(giver)
				return 1
			else
				return ..()

//		archive()
//			if(air) //For open space like floors
//				air.archive()

//			temperature_archived = temperature
//			archived_cycle = air_master.current_cycle

		share_air_with_tile(turf/simulated/T)
			return air.share(T.air)

		mimic_air_with_tile(turf/T)
			return air.mimic(T)

		return_air()
			if(zone)
				return zone.air
			else if(air)
				return air

			else
				return ..()

		remove_air(amount as num)
			if(zone)
				var/datum/gas_mixture/removed = null
				removed = zone.air.remove(amount)
				return removed
			else if(air)
				var/datum/gas_mixture/removed = null
				removed = air.remove(amount)

				if(air.check_tile_graphic())
					update_visuals(air)
				return removed

			else
				return ..()

		update_air_properties()//OPTIMIZE
			air_check_directions = 0

			for(var/direction in cardinal)
				if(CanPass(null, get_step(src,direction), 0, 0))
					air_check_directions |= direction
			var/has_door = HasDoor(src)

			if(!zone && CanPass(null, src, 1.5, 1)) //No zone and not a wall, lets add ourself to a zone.
				for(var/direction in cardinal)
					if(has_door && !(direction in DoorDirections))
						continue
					if(air_check_directions&direction)
						var/turf/simulated/T = get_step(src,direction)
						if(T.zone && T.CanPass(null, src, 1.5, 1))
							T.zone.AddTurf(src)
							break
						else if(T.zone && get_dir(T,src) in DoorDirections)
							T.zone.AddTurf(src)
							break
				if(!zone) //No zone found, new zone!
					new/zone(src)

			if(air_master.tiles_with_connections["\ref[src]"]) //Check pass sanity of the connections.
				var/list/connections = air_master.tiles_with_connections["\ref[src]"]
				for(var/connection/C in connections)
					air_master.connections_checked += C

			update_zone_properties(has_door) //Update self zone and adjacent zones.

			if(air_check_directions)
				processing = 1
			else
				processing = 0


		proc/update_zone_properties(var/has_door = 0)
			for(var/direction in cardinal)
				var/turf/simulated/T = get_step(src,direction)
				if(air_check_directions&direction) //I can connect air in this direction
					if(!istype(T)) //Space
						if(!CanPass(null, T, 1.5, 1) && CanPass(src, T, 0, 0)) //Normally would block it, instead lets make a connection to it.
							if(zone)
								zone.AddSpace(T)
						else if(!CanPass(src, T, 0, 0) || !CanPass(T, src, 0, 0)) //I block the air or it blocks air, disconnect from it if connected.
							if(zone && T in zone.space_tiles)
								zone.RemoveSpace(T)
						else if(zone)
							zone.rebuild = 1
							continue

					else if(!T.CanPass(null, src, 1.5, 1) && !T.CanPass(null, src, 0, 0)) //If I block air, we must look to see if the adjacent turfs need rebuilt.
						if(T.zone && !T.zone.rebuild)
							for(var/direction2 in cardinal - direction) //Check all other directions for air that might be connected.
								var/turf/simulated/NT = get_step(src, direction2)
								if(NT && NT.zone && NT.zone == T.zone)
									T.zone.rebuild = 1

					else if(T.CanPass(null, src, 0, 0) && (!has_door || direction in DoorDirections))
						if(T.zone != zone)
							ZConnect(src,T)

				else if(zone && !zone.rebuild)
					for(var/direction2 in cardinal - reverse_direction(direction)) //Check all other directions for air that might be connected.
						var/turf/simulated/NT = get_step(T, direction2)
						if(NT && NT.zone && NT.zone == zone)
							zone.rebuild = 1