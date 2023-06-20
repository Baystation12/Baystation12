#define TGS_EXTERNAL_CONFIGURATION

// SHOULD BE DEFINED BEFORE TGS ITSELF

// Comment this out once you've filled in the below.
// #error TGS API unconfigured

// Uncomment this if you wish to allow the game to interact with TGS 3.
// This will raise the minimum required security level of your game to TGS_SECURITY_TRUSTED due to it utilizing call()()
//#define TGS_V3_API

// Required interfaces (fill in with your codebase equivalent):

/// Create a global variable named `Name` and set it to `Value`.
#define TGS_DEFINE_AND_SET_GLOBAL(Name, Value) var/global/_tgs_##Name = ##Value

/// Read the value in the global variable `Name`.
#define TGS_READ_GLOBAL(Name) global._tgs_##Name

/// Set the value in the global variable `Name` to `Value`.
#define TGS_WRITE_GLOBAL(Name, Value) global._tgs_##Name = ##Value

/// Disallow ANYONE from reflecting a given `path`, security measure to prevent in-game use of DD -> TGS capabilities.
#define TGS_PROTECT_DATUM(Path) // Nope. But close GLOBAL_PROTECT(Path)

/// Display an announcement `message` from the server to all players.
#define TGS_WORLD_ANNOUNCE(message) to_world(html_encode(message))

/// Notify current in-game administrators of a string `event`.
#define TGS_NOTIFY_ADMINS(event) message_admins(##event)

/// Write an info `message` to a server log.
#define TGS_INFO_LOG(message) log_debug("[##message]")

/// Write an warning `message` to a server log.
#define TGS_WARNING_LOG(message) log_error("TGS warning: [##message]")

/// Write an error `message` to a server log.
#define TGS_ERROR_LOG(message) log_error("TGS error: [##message]")

/// Get the number of connected /clients.
#define TGS_CLIENT_COUNT global.clients.len
