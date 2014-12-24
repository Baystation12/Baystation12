var/global/list/network_accounts = list()

/*
                                        [Server]-----[Profiles, programs, Data]
                                           |
                  +------------------------+------------------------+
                  |                        |                        |
           APC [Router]                 [Router]                 [Router]
                  |
     +------------+------------+
     |            |            |
 [Terminal]   [Terminal]   [Terminal]-----[Local data]
*/


/datum/network_account
	var/name
	var/password
	var/access
	var/account_type

/datum/network_account/New(var/new_name = "GUEST", var/new_pass = "PASSWORD", var/new_permissions = 0, var/new_rank = "User")
	name = new_name
	password = new_pass
	access = new_permissions
	account_type = new_rank