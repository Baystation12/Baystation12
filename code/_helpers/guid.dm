// I'm tired of seeing everyone litter their UIDs everywhere. That's fine for round-based play where everything is reset,
// but for any sort of persistent play, it's absolutely fucking hell. It'll also one day just break catastrophically.
//
// do better.
//
// Use GUIDs like people fucking expect in sane environments.

//#define NEW_GUID() "[num2hex(rand(1,255))][num2hex(rand(1,255))][num2hex(rand(1,255))][num2hex(rand(1,255))]-[num2hex(rand(1,255))][num2hex(rand(1,255))]-[num2hex(rand(1,255))][num2hex(rand(1,255))]-[num2hex(rand(1,255))][num2hex(rand(1,255))]-[num2hex(rand(1,255))][num2hex(rand(1,255))][num2hex(rand(1,255))][num2hex(rand(1,255))][num2hex(rand(1,255))][num2hex(rand(1,255))]";
/proc/new_guid()
	return "[num2hex(rand(1,255))][num2hex(rand(1,255))][num2hex(rand(1,255))][num2hex(rand(1,255))]-[num2hex(rand(1,255))][num2hex(rand(1,255))]-[num2hex(rand(1,255))][num2hex(rand(1,255))]-[num2hex(rand(1,255))][num2hex(rand(1,255))]-[num2hex(rand(1,255))][num2hex(rand(1,255))][num2hex(rand(1,255))][num2hex(rand(1,255))][num2hex(rand(1,255))][num2hex(rand(1,255))]"