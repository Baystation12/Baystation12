/datum/computer_hardware/tesla_link
	name = "Tesla Link"
	desc = "An advanced tesla link that wirelessly recharges connected device from nearby area power controller."
	critical = 0
	enabled = 0 // Starts turned off

/datum/computer_hardware/tesla_link/Destroy()
	if(holder && (holder.tesla_link == src))
		holder.tesla_link = null
	..()