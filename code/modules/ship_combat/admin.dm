//Inverse defs.
#define SPACE_MEDIC 0
#define SPACE_RESEARCH 1
#define SPACE_FIRE_CONTROL 2
#define SPACE_MAINTENANCE 3
#define SPACE_SECURITY 4
#define SPACE_ENGINEERING 5
#define SPACE_NAVIGATION 6
#define SPACE_COMMAND 7
#define SPACE_TUBES 8
#define SPACE_COMMON 9
/obj/var/can_pull = 1

proc/is_space(var/turf/T)
	if(istype(T, /turf/space))
		return 1
	return 0

/datum/admins/proc/force_team()
	set category = "Server"
	set name = "Force Team"
	set desc="Forces a team into play."
	if (!usr.client.holder)
		return
	if(ticker)
		var/inp = input(usr, "What team?") in list("Team One", "Team Two", "Team Three", "Team Four")
		ticker.forced_teams.Add(inp)
		message_admins("[key_name_admin(usr)] forced [inp] into play.", 1)

/datum/admins/proc/tele_ship()
	set category = "Debug"
	set name = "Teleport Ship"
	set desc="Teleports a ship to the selected coordinates."
	var/list/ships = list()
	for(var/obj/effect/overmap/ship/S in world)
		ships += S
	if(!ships.len)
		usr << "<span class='warning'>No ships found!</span>"
		return
	var/obj/effect/overmap/ship/selected = input(usr, "What ship?", "Ship Teleportation") in ships
	if(!selected || !istype(selected))
		usr << "<span class='warning'>Invalid!</span>"
		return
	var/x_co = input(usr, "Enter X coordinates", "Ship Teleportation") as num
	x_co = between(1, x_co, OVERMAP_SIZE)
	var/y_co = input(usr, "Enter Y coordinates", "Ship Teleportation") as num
	y_co = between(1, y_co, OVERMAP_SIZE)
	selected.forceMove(locate(x_co, y_co, selected.z))



