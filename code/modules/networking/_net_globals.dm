//Range of backup wireless communications between ANCs, in a (currently) circular range.
#define NET_WIRELESS_ANC_TO_ANC 20

//Range of communcation between an ANC and a device, not blocked by walls.
// -1 means the whole area the ANC is in, including bordering doors [TODO]
#define NET_WIRELESS_ANC_TO_DEVICES -1

//State of an ANC's network connection.
// NORMAL if it's directly connnected to a router.
// MESH if it's connecting through another ANC
// NONE if it can't find any way to connect.
#define NET_ANC_STATE_NORMAL 1
#define NET_ANC_STATE_MESH 2
#define NET_ANC_STATE_NONE 3

//States for /obj/machinery network devices.
// WIRELESS if a device is connected to its ANC wirelessly.
// WIRED if a device is connected direcly to its ANC with local network cable.
// NONE if there is no active network connection.
#define NET_MCH_STATE_WIRELESS 1
#define NET_MCH_STATE_WIRED 2
#define NET_MCH_STATE_NONE 3

//List of all ANCs, associative by zlevel.
// e.g. ancs_by_zlevel["2"] contains all ANCs on zlevel 2
/var/global/list/ancs_by_zlevel = list()
