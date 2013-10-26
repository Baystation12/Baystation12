var/datum/visibility_network/cameras/cameraNetwork = new /datum/visibility_network/cameras()
var/datum/visibility_network/list/visibility_networks = list("ALL_CAMERAS"=cameraNetwork)

// used by turfs and objects to update all visibility networks
/proc/updateVisibilityNetworks(atom/A, var/opacity_check = 1)
	for (var/datum/visibility_network/currentNetwork in visibility_networks)
		currentNetwork.updateVisibility(A, opacity_check)