//##############################################################################
//# This script is BRIX, an Open Source gamemode originally created by
//# ©Bularthip. Please do not remove this credit tag.
//# 
//# Some of the script lines might have been created by other M2MP scripters.
//# 
//# Special thanks to: Rolandd
//# 
//# For instructions, please visit BRIX site.
//# For help and assistance, please visit BRIX site.
//# http://brix.idonteven.tk
//# Enjoy!

// LOCALS
local Vehicle = {};
local Admin = array(MAX_PLAYERS, 0);
local Logged = array(MAX_PLAYERS, 0);
local Login = array(MAX_PLAYERS, 0);
local MsgAccess = array(MAX_PLAYERS, 0);

local cds = 0;
local launch;
local start;

local spamprotect = array(MAX_PLAYERS, 0);

// SCRIPT SETTINGS | CONFIGURE THESE!
local serverName = getServerName();
local serverAdmin = ("")
local serverWebsite = ("http://brix.idonteven.tk");
local serverMsgPrefix = ("CONSOLE");

local adminSerial = ("");
local rconPassword = ("");

local pingLimit = 800; // DEFAULT 800ms

local connectMessage_1 = ("Welcome! " + serverName + " brought you by " + serverAdmin + " from " + serverWebsite + "!");
local connectMessage_2 = ("- - - ");

local spawnMessage_1 = ("Check these commands out! /help, /tutorial and /howto!");
local spawnMessage_2 = ("Happy exploring!");

local spawnHealthAmount = 999.0;
local spawnWeapon_1 = 11;
local spawnWeapon_2 = 6;

local vehicleRespawnTime = 60; // DEFAULT 60 SECONDS

local spawnPosition = [-1551.560181, -169.915466, -18.672523];

local useDefaultPlates = 1; // 1 = YES USE SETTINGS BELOW | 0 = NO DOESN'T USE SETTINGS BELOW
local defaultPlates = "BRIX-"; // MAX. PLATES LENGHT = 6 MARKS (this plus below)
local defaultPlatesExtra = 1; // DEFINES HOW MANY RANDOM LETTERS USED IN PLATES. MAX. PLATES LENGHT = 6 MARKS (this plus above)
    
// OTHER SETTINGS (DO NOT TOUCH!)
function random(min=0, max=RAND_MAX)
{
    srand(getTickCount() * rand());
    return (rand() % ((max + 1) - min)) + min;
}

function isNumeric( string )
{
    try
    {
        string.tointeger()
    }
    catch( string )
    {
        return 0;
    }
	
    return 1;
}

// SCRIPT STARTUP
local script = "BRIX";

function scriptInit()
{
    log( "----- ----- ----- ----- ----- ----- ----- ");
    log( script + " has been loaded and launched!" );
    log( "----- -----       -----       ----- ----- ");
    log( "BRIX by Bularthip, +Rolandd, +M2MP Community  ");
    log( "----- ----- ----- ----- ----- ----- ----- ");
    setGameModeText( "BRIX v0.5.5b" ); //NOTE: CHANGE ME, NOT NECESSARY
	   setMapName( "Empire Bay" );

    timer( autoMsg, 600000, -1 ); // NOTE: CHANGE AUTOMSG TIME. 600000 = 10 minutes, 1000 = 1 second
}
addEventHandler( "onScriptInit", scriptInit );


// PLAYER CONNECT FUNCTION
function playerConnect( playerid, name, ip, serial )
{   
    sendPlayerMessageToAll( serverMsgPrefix + ": " + getPlayerName( playerid ) + " connected.", 100, 200, 170 );
    sendPlayerMessage(playerid, connectMessage_1, 50, 205, 50 );
    sendPlayerMessage(playerid, connectMessage_2, 255, 0, 0 );
    
    Admin[playerid] = 0;
    Logged[playerid] = 0;
    MsgAccess[playerid] = 1;  
}
addEventHandler( "onPlayerConnect", playerConnect );

// PLAYER DISCONNECT FUNCTION
function playerDisconnect( playerid, reason )
{
    sendPlayerMessageToAll( serverMsgPrefix + ": " + getPlayerName( playerid ) + " has " + reason + " from the server.", 255, 255, 0 );
    
    Admin[playerid] = 0;
    Logged[playerid] = 0;
    MsgAccess[playerid] = 0;
}
addEventHandler( "onPlayerDisconnect", playerDisconnect );

// PLAYER SPAWN FUNCTION
function playerSpawn( playerid )
{
    
    timer( function() { triggerClientEvent( playerid, "mousefix" );   }, 1500, 1);
    spamprotect[playerid] = 0;
    
    sendPlayerMessage(playerid, serverMsgPrefix + ": " + spawnMessage_1, 175, 255, 45 );
    sendPlayerMessage(playerid, serverMsgPrefix + ": " + spawnMessage_2, 175, 255, 45 );
    
    setPlayerPosition( playerid, spawnPosition[0], spawnPosition[1], spawnPosition[2] ); //NOTE: THIS IS THE PLAYER SPAWN LOCATION
    
    setPlayerHealth( playerid, spawnHealthAmount );
    givePlayerWeapon(playerid, spawnWeapon_1, 999);
    givePlayerWeapon(playerid, spawnWeapon_2, 999);
    
    if(getPlayerPing(playerid) > pingLimit)
    {
        sendPlayerMessageToAll(serverMsgPrefix + ": " + "Player " +getPlayerName(playerid) + " was automatically removed by the server. (Ping)", 255, 0, 0 );
        kickPlayer(playerid);
        log("Player " +getPlayerName(playerid) + " was removed by server. ( PING )");
    }
    
    if(getPlayerName(playerid) == "banned1" || getPlayerName(playerid) == "banned2" ) // NOTE: REPLACE THE MISHAVED PLAYER NAME WITH banned1 OR banned2. IF YOU WANT TO BAN MORE PEOPLE, ADD ANOTHER LINE LIKE THERE IS FOR banned2.
    {
        togglePlayerControls ( playerid, false );
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "!! BANNED !!", 255, 0, 0 );
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "You will be removed in five seconds.", 255, 0, 0 );
        timer( function() { kickPlayer(playerid); }, 5000, 1); // NOTE: Timer to let the banned player enjoy the message for five seconds before getting kicked
        //kickPlayer(playerid);
        log("Unauthorized connect rejected.");
    }
    
}
addEventHandler( "onPlayerSpawn", playerSpawn );

// PLAYER DEATH FUNCTION
function playerDeath( playerid, killerid )
{
    if( killerid != INVALID_ENTITY_ID )
    {
        sendPlayerMessageToAll( serverMsgPrefix + ": " + getPlayerName( playerid ) + " has been killed by " + getPlayerName( killerid ) + ".", 255, 255, 0 ); 
    }
    else {
        local diePos = getPlayerPosition(playerid);
        sendPlayerMessageToAll(serverMsgPrefix + ": " + getPlayerName( playerid ) + " has died.", 255, 255, 0 );
        timer( function() {  setPlayerPosition(playerid, diePos[0], diePos[1], diePos[2] );   }, 4000, 1);
    }
}
addEventHandler( "onPlayerDeath", playerDeath );

// TUTORIAL FUNCTION, BEFORE TUTORIAL START
addCommandHandler( "tutorial",
function( playerid, ... )
{
    if(vargv.len() != 1){
        sendPlayerMessage(playerid, "TUTORIAL: Hello, " +getPlayerName(playerid)+ ". I'm CONSOLE, and I will show you a quick tutorial.", 175, 255, 45 );      
        sendPlayerMessage(playerid, "TUTORIAL: Before we begin, there are some things I need to warn you about:", 175, 255, 45 );      
        sendPlayerMessage(playerid, "TUTORIAL: While tutorial, you can not move and you will be tested wether you have listened or not!", 175, 255, 45 );      
        sendPlayerMessage(playerid, "TUTORIAL: If you understand and you accept the rules, type /tutorial accept. If not, type /tutorial deny.", 175, 255, 45 );      
        return 1;
    } 
    else {
        local answer = vargv[0].tostring();
        answer = answer.tolower();
        switch(answer){
            case "accept":
            sendPlayerMessage(playerid, "Allright then, give me few seconds to close my zipper and we'll start!", 255, 105, 180 );
            triggerClientEvent( playerid, "start_tutorial" );
            break;
            
            case "deny":
            sendPlayerMessage(playerid, "Oh, okay. Well, catch you later then!", 255, 105, 180 );
            break;
            
            default:
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry.", 255, 0, 0 );
            break;    
        }
    }
}
);

// TUTORIAL FUNCTION
function brix_tutorial( playerid ) // NOTE: THIS TUTORIAL REQUIRES THAT YOU USE THE NEWEST BRIX gui.nut CLIENTSIDE FILE. SEE THE FILE FOR ADDITIONAL INFORMATION
{
    log(getPlayerName(playerid) + " is now watching tutorial.") 
    setPlayerHealth( playerid, 1000.0 );
    togglePlayerControls ( playerid, false );
    
    setPlayerPosition(playerid, -470.899506, 1064.663574, 31.753845);

        sendPlayerMessage(playerid, "--- --- ---", 255, 0, 0 );
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "PLEASE DO NOT PRESS ANY BUTTONS DURING TUTORIAL UNLESS YOU ARE TOLD TO!", 255, 0, 0 );
        sendPlayerMessage(playerid, "--- --- ---", 255, 0, 0 );
        sendPlayerMessage(playerid, "TUTORIAL: First of all we'll check out the Graphical User Interface.", 175, 255, 45 );
        
        timer( function() { triggerClientEvent( playerid, "open_gui" );   }, 10000, 1);
        timer( function() { triggerClientEvent( playerid, "close_gui" );   }, 15000, 1);
        
        timer( function() { sendPlayerMessage(playerid, "TUTORIAL: You can open and close it by pressing button *H* in your keyboard.", 175, 255, 45 );   }, 17000, 1); 
        timer( function() { sendPlayerMessage(playerid, "TUTORIAL: You can use nearly all commands and functions nice and easy with the GUI.", 175, 255, 45 ); }, 22000, 1);
        
        timer( function() { sendPlayerMessage(playerid, "TUTORIAL: You also can use all commands by typing them in chat. All commands begin with backslash /.", 175, 255, 45 ); }, 27000, 1);
        timer( function() { sendPlayerMessage(playerid, "TUTORIAL: Type /help.", 175, 255, 45 ); }, 32000, 1);
        timer( function() { sendPlayerMessage(playerid, "TUTORIAL: Cool, now try /help vehicles.", 175, 255, 45 ); }, 42000, 1);
        timer( function() { sendPlayerMessage(playerid, "TUTORIAL: Allright, looks like you can handle these things so far!", 175, 255, 45 ); }, 52000, 1);
        
        timer( function() { sendPlayerMessage(playerid, "TUTORIAL: Multiplayer basicly is all about commands.", 175, 255, 45 ); }, 57000, 1);
        timer( function() { sendPlayerMessage(playerid, "TUTORIAL: Players can do various with them. Not all servers have the same commands, it depends alot of the server.", 175, 255, 45 ); }, 62000, 1);
        timer( function() { sendPlayerMessage(playerid, "TUTORIAL: In this server, you are able to do quite cool things.", 175, 255, 45 ); }, 67000, 1);
        timer( function() { sendPlayerMessage(playerid, "TUTORIAL: You can go where ever you want by using /warp command.", 175, 255, 45 ); }, 72000, 1);
        timer( function() { sendPlayerMessage(playerid, "TUTORIAL: To know how /warp works, please type /howto warp", 175, 255, 45 ); }, 77000, 1);
        timer( function() { sendPlayerMessage(playerid, "TUTORIAL: You can view the information for all commands by typing first /howto and then the command.", 175, 255, 45 ); }, 87000, 1);
        
        timer( function() { sendPlayerMessage(playerid, "TUTORIAL: Cool, now we'll quickly check some places!", 175, 255, 45 ); }, 92000, 1);
        
        timer( function() { setPlayerPosition(playerid, -379.252045, 654.311584, -11.561144); }, 97000, 1);
        timer( function() { sendPlayerMessage(playerid, "TUTORIAL: Police Station", 175, 255, 45 ); }, 98000, 1);
        
        timer( function() { setPlayerPosition(playerid, -575.157776, 1626.630737, -15.695728); }, 102000, 1);
        timer( function() { sendPlayerMessage(playerid, "TUTORIAL: Train Station", 175, 255, 45 ); }, 103000, 1);
        
        timer( function() { setPlayerPosition( playerid, -1551.560181, -169.915466, -18.672523 ); }, 107000, 1);
        timer( function() { sendPlayerMessage(playerid, "TUTORIAL: Player Spawn Point", 175, 255, 45 ); }, 108000, 1);
        
        timer( function() { sendPlayerMessage(playerid, "TUTORIAL: By default, Mafia 2 Map is quite limited.", 175, 255, 45 ); }, 113000, 1);
        timer( function() { sendPlayerMessage(playerid, "TUTORIAL: I'm happy to show some places where we can go by using /warp command!", 175, 255, 45 ); }, 117000, 1);
        
        timer( function() { setPlayerPosition(playerid, -1551.564209, 1430.306396, 440.276672); }, 119000, 1);
        timer( function() { setPlayerPosition(playerid, 448.435791, 1430.370728, 137.8433698); }, 121000, 1);
        timer( function() { setPlayerPosition(playerid, 2048.435791, 2230.508545, 75.550278); }, 123000, 1);
        timer( function() { setPlayerPosition(playerid, -1151.560303, -468.544769, 158.594345); }, 125000, 1);
        
        timer( function() { sendPlayerMessage(playerid, "TUTORIAL: Sadly, now you'll fall to death. Sorry.", 175, 255, 45 ); }, 126000, 1);
        timer( function() { setPlayerPosition(playerid, -1551.560181, -169.915466, -18.672523); }, 131000, 1);
        
        timer( function() { sendPlayerMessage(playerid, "TUTORIAL: Nah, better not to do that. Hope this helped you a bit!", 175, 255, 45 ); }, 132000, 1);
        timer( function() { triggerClientEvent( playerid, "end_tutorial_client" ); }, 132100, 1);
}
addEventHandler("brix_tutorial", brix_tutorial);

// TUTORIAL ENDING FUNCTION
function end_tutorial( playerid )
{
    togglePlayerControls ( playerid, true );
    setPlayerPosition(playerid, spawnPosition[0], spawnPosition[1], spawnPosition[2]);
}
addEventHandler("end_tutorial", end_tutorial);

// INFORMATION COMMANDS
addCommandHandler( "help", // NOTE: IF YOU ARE PLANNING TO CHANGE COMMAND NAMES, FOR EXAMPLE /help TO /commands, REMEMBER TO CHANGE THE COMMAND NAME FROM: /howto, /help AND /help FUNCTION!
function( playerid, ... )
{
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Correct usage: /help [AREA].", 255, 0, 0 );
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Areas are: general | teleporting | vehicles | weapons | chat", 255, 105, 180 );
        return 1;
    }
    else {
        local area = vargv[0].tostring();
        if( area == "general" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "General Commands:", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/howto", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/model", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/randomize", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/heal", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/health", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/unlock", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/weatherlist", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/money", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/countdown", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/report", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "- - -", 25, 135, 235 );
        }
        else if( area == "teleporting" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Teleporting Commands:", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/warp", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/goto", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/tele", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/mypos", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/topoint", 25, 135, 235 );
             sendPlayerMessage(playerid, serverMsgPrefix + ": " + "- - -", 25, 135, 235 );
        }
        else if( area == "vehicles" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Vehicle Commands:", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/vehicle", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/randomveh", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/tune", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/plates", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/repair", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/color", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/dirt", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/tires", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/vehicleinfo", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "- - -", 25, 135, 235 );        
        }
        else if( area == "weapons" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Weapon Commands:", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/weapon", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/reload", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "- - -", 25, 135, 235 );
        }
        else if( area == "chat" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Chat Commands:", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/pm", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/me", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/s", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/chat hide", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/cc", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "/automsg", 25, 135, 235 );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "- - -", 25, 135, 235 );
        }
        else {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid [AREA]!", 255, 0, 0 );
        }
    }
}
);

addCommandHandler( "howto",
function( playerid, ... )
{
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Correct usage: /howto [COMMAND].", 255, 0, 0 );
        return 1;
    }
    else {
        local cmd = vargv[0].tostring();
        if( cmd == "warp" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /warp x 30. Teleports you 30 points in X axis.", 115, 215, 145 );
        }
        else if( cmd == "model" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /model 59. Changes your character model by defined ID.", 115, 215, 145 );
        }
        else if( cmd == "randomize" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /randomize. Changes your character model by random.", 115, 215, 145 );
        }
        else if( cmd == "heal" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /heal. Sets your total health to 999.0.", 115, 215, 145 );
        }
        else if( cmd == "health" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /health 6000. Sets your total health to defined amount.", 115, 215, 145 );
        }   
        else if( cmd == "unlock" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /unlock. Unlocks your keyboard action keys in case you are stuck somehow.", 115, 215, 145 );
        }
        else if( cmd == "goto" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /goto 4. Teleports you to another player, defined by target player ID.", 115, 215, 145 );
        }
        else if( cmd == "tele" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /tele train. Teleports you to the Train Station. Locations defined in /tele list.", 115, 215, 145 );
        }
        else if( cmd == "weatherlist" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /weatherlist. Lists all weathers available. Use /howto weather for more information.", 115, 215, 145 );
        }
        else if( cmd == "weather" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /weather noon_clear. Changes the weather for all players. Use /weatherlist to list all weathers available.", 115, 215, 145 );
        }
        else if( cmd == "vehicle" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /vehicle 42. Spawns a vehicle defined by ID to your location.", 115, 215, 145 );
        }
        else if( cmd == "tune" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /tune 3. Tunes your car 100%. Using /tune 1 will tune 33%, and /tune 2 77%.", 115, 215, 145 );
        }
        else if( cmd == "plates" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /plates epic. Changes your car license plates.", 115, 215, 145 );
        }
        else if( cmd == "repair" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /repair. Repairs your vehicle 100%.", 115, 215, 145 );
        }
        else if( cmd == "color" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /color 0 0 0 255 255 255. Paints your vehicle, defined by RGB colors. Example usage paints black & white.", 115, 215, 145 );
        }
        else if( cmd == "dirt" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /dirt. Makes your vehicle all dirty and dusty. Rain and water washes it away. Painting and tuning may also change dustyness.", 115, 215, 145 );
        }
        else if( cmd == "tires" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /tires 1 13. /tires 0 9. Changes your vehicle tires. Second parameter ( 0 or 1 ) defines front or rear wheels. Third parameter defines wheel ID.", 115, 215, 145 );
        }
        else if( cmd == "weapon" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /weapon 7. Spawns a weapon to your inventory, defined by weapon ID.", 115, 215, 145 );
        }
        else if( cmd == "reload" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /reload. Resets your ammunition of currently equipped weapon to maximum possible.", 115, 215, 145 );
        }
        else if( cmd == "money" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /money 100. Adds money, amount defined by player.", 115, 215, 145 );
        }
        else if( cmd == "countdown" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /countdown 5. Creates countdown for example for races. Visible for players nearby only.", 115, 215, 145 );
        }
        else if( cmd == "pm" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /pm 9. Sends private message to another player, defined by player ID", 115, 215, 145 );
        }
        else if( cmd == "me" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /me dances. Sends action message. Visible for players nearby only.", 115, 215, 145 );
        }
        else if( cmd == "s" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /s I'm saying stuff. Sends saying message. Visible for players nearby only.", 115, 215, 145 );
        }
        else if( cmd == "chat" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /chat hide. Hides chat. You can also type /chat show to show chat (hard to type without seeing chat).", 115, 215, 145 );
        }
        else if( cmd == "mypos" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /mypos. Lists your coordinates.", 115, 215, 145 );
        }
        else if( cmd == "topoint" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /topoint -379.252045 654.311584 -11.561144. Teleports you to location defined by coordinates.", 115, 215, 145 );
        }
        else if( cmd == "report" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /report Player called player123 is using hacks, also I'm stuck. >Files a report.", 115, 215, 145 );
        }
        else if( cmd == "randomveh" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /randomveh. Spawns random vehicle at your position.", 115, 215, 145 );
        }
        else if( cmd == "vehicleinfo" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /vehicleinfo. Lists your vehicle information.", 115, 215, 145 );
        }
        else if( cmd == "cc" )
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Example usage: /cc. Clears your local chat.", 115, 215, 145 );
        }
        else {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid [COMMAND]!", 255, 0, 0 );
        }
    }   
}
);

// AUTOASSISTANT
function playerChat( playerid, chattext )
{
    if(chattext.tolower() == "help" || (chattext.tolower() == "help me") || (chattext.tolower() == "hlep") || (chattext.tolower() == "help!") || (chattext.tolower() == "help!!"))
    {
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Hello, " + getPlayerName(playerid) + ". I noticed you need help and I'm here to assist you.", 0, 255, 255 );
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "You can type /help to view all our commands. If you are not sure how some specific command works, type /howto [COMMAND].", 0, 255, 255 );
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "In case you are new to M2MP or you would like to take a trip, please type /tutorial.", 0, 255, 255 );
    } 
    else if(chattext.tolower() == "stuck" || (chattext.tolower() == "im stuck") || (chattext.tolower() == "cant move") || (chattext.tolower() == "ah im stuck") || (chattext.tolower() == "oh im stuck") || (chattext.tolower() == "shit im stuck") || (chattext.tolower() == "fuck im stuck") || (chattext.tolower() == "fuck cant move"))
    {
        togglePlayerControls(playerid, true);
        
        local pos = getPlayerPosition(playerid);
        switch(random(0,3))
        {
            case 0:
            setPlayerPosition(playerid, pos[0] + 1, pos[1], pos[2] +0.5);
            break;
            case 1:
            setPlayerPosition(playerid, pos[0], pos[1] + 1, pos[2] +0.5);
            break;
            case 2:
            setPlayerPosition(playerid, pos[0] - 1, pos[1], pos[2] +0.5);
            break;
            case 3:
            setPlayerPosition(playerid, pos[0], pos[1] - 1, pos[2] +0.5);
            break;
        }   
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Hello, " + getPlayerName(playerid) + ". I already have unlocked your controls and changed your position.", 0, 255, 255 );
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "In case this didn't help, you can always type /health 0 and respawn.", 0, 255, 255 );
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Remember, if you die accidentally, fall or do suicide, you will be respawned to your death location.", 0, 255, 255 );
    }
    else if(chattext.tolower() == "admin" || (chattext.tolower() == "admin!") || (chattext.tolower() == "admin?"))
    {
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Hello, " + getPlayerName(playerid) + ". I noticed you want to contact server staff.", 0, 255, 255 );
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Server Administrator is " + serverAdmin + ". If you can't reach him, please type /howto report!", 0, 255, 255 ); // NOTE: YOUR NAME HERE!
    }
    return 1;
}
addEventHandler( "onPlayerChat", playerChat );

// SPAMPROTECT
function playerChat( playerid, chattext )
{
    if ( spamprotect[playerid] > 1 )
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" We refuse to let you spam. This message was not sent.", 255, 0, 0 );  
        return 0;
    }
    else {
        spamprotect[playerid]++;
        timer( function() { spamprotect[playerid] = 0; }, 6000, 1);
        return 1;
    }
}
addEventHandler( "onPlayerChat", playerChat );

// REPORTSYSTEM ©ROLANDD
function report(...)
{
    local playerid = vargv[0];
    for(local j = 0; j < getMaxPlayers(); j++)
    {
        local file = xml("reports/" + getPlayerName(j) + "(" + j + " " + random(0, 9000) + ")" + ".xml");  
        local root = file.getRootNode();  
        
        local playerModel = getPlayerModel( j );
        local playerPos = getPlayerPosition( j );
        local playerName = getPlayerName( j );
        local playerCar = getPlayerVehicle( j );
        local playerSer = getPlayerSerial( j );
        if(vargv.len() > 1)
        {
            local msg = "";
            for (local i = 1; i < vargv.len(); i++)
            {
                msg = msg + " " + vargv[i];
            }
            
            log( "NEW REPORT by " + getPlayerName( j ) + ": " + msg + " | END |");

            root = file.createRootNode("Report"); 
            
            local node = file.createNode(root, "Message");
            file.setNodeValue (node, msg);
            
            local name = file.createNode(root, "Name");
            file.setNodeValue (name, playerName);            
            
            local model = file.createNode(root, "Model");
            file.setNodeValue (model, playerModel.tostring() );
            
            local car = file.createNode(root, "Player Vehicle");
            file.setNodeValue(car,  getVehicleModel( getPlayerVehicle( j ) ).tostring() );
            
            local ping = file.createNode(root, "Player Ping");
            file.setNodeValue(ping, getPlayerPing( j ).tostring() );
            
            local coordsx = file.createNode(root, "Player Pos X");
            file.setNodeValue (coordsx, playerPos[0].tostring() );
            
            local coordsy = file.createNode(root, "Player Pos Y");
            file.setNodeValue (coordsy, playerPos[1].tostring() );
            
            local coordsz = file.createNode(root, "Player Pos Z");
            file.setNodeValue (coordsz, playerPos[2].tostring() );
            
            file.save(); 
            sendPlayerMessage(j, serverMsgPrefix + ": " + "Report was succesfully submitted!", 175, 255, 45 );  
        }    
        else
        {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Correct usage: /report [MESSAGE].", 255, 0, 0 );
        }
        return true;
    }
}
addCommandHandler("report", report);

function vehicleEnter( playerid, veh, seat ) 
{
    if(isPlayerInVehicle(playerid) )
    {
    local model = getVehicleModel ( getPlayerVehicle ( playerid ) );
    if(model == 42 )
    {
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "You can reset this vehicle color scheme by typing /resetcolor!", 175, 255, 45 );  
    }
    else if(model == 51 )
    {
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "You can reset this vehicle color scheme by typing /resetcolor!", 175, 255, 45 );  
    }
}

}
addEventHandler( "onPlayerVehicleEnter", vehicleEnter );

function autoMsg()
{
    for(local i = 0; i < getMaxPlayers(); i++)
    {
        if(isPlayerConnected(i))
        {
            if(MsgAccess[i] == 1)
              {
                  switch(random(0,4))
                  {
                    case 0:
                    sendPlayerMessage(i, serverMsgPrefix + ": " +"These automatic server messages can be disabled and enabled by typing /automsg!", 100, 200, 170 );
                    break;
                   
                    case 1:
                    sendPlayerMessage(i, serverMsgPrefix + ": " +"Play fair and have fun!", 100, 200, 170 );
                    break;
                   
                    case 2:
                    sendPlayerMessage(i, serverMsgPrefix + ": " +"Need help? The server administrator is + " serverAdmin + " and you can find more at " + serverWebsite + ".", 100, 200, 170 );
                    break;
                    
                    case 3:
                    sendPlayerMessage(i, serverMsgPrefix + ": " +"You can view all commands by typing /help. You can view information for all commands by typing /howto. You can also press H to view GUI!", 100, 200, 170 );
                    break;
                    
                    case 4:
                    sendPlayerMessage(i, serverMsgPrefix + ": " +"All hackers and bad players will meet hammer!", 100, 200, 170 );
                    break;
                }
            }
        }
    }
}

// PLAYER COMMANDS
SEC_BETWEEN_CMD1 <- vehicleRespawnTime 

playerCommandDelayed1 <- array(MAX_PLAYERS, 0); // <-

addCommandHandler( "vehicle",
function( playerid, ... )
{
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Correct usage: /vehicle [ID].", 255, 0, 0 );
        return 1;
    }
    else {
        local id = vargv[0].tostring();   
        if(!playerCommandDelayed1[playerid]) // <-
        {
            if( isNumeric(id) )
            {
                if( id.tointeger() < 54 && -1 < id.tointeger() )
                {
                    
                    local pos = getPlayerPosition( playerid );
                    local veh = createVehicle( id.tointeger(), pos[0] + 2.0, pos[1], pos[2] + 1.0, 0.0, 0.0, 0.0 );
                    sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Vehicle (" + id + ") spawned.", 25, 135, 235 );
                    
                    if(useDefaultPlates)
                    {
                        timer( function() { setVehiclePlateText(veh, defaultPlates + str_rand(defaultPlatesExtra) ); }, 3000, 1);
                    }       
                    playerCommandDelayed1[playerid] = 1; // <-
                    timer( function() { playerCommandDelayed1[playerid] = 0; }, SEC_BETWEEN_CMD1*1000, 1); // <-
                }
                else {
                    sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid range! Vehicle ID's: 0-53.", 255, 0, 0 );
                }
            }
        }
        else {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Can not use this command yet.", 255, 0, 0 );
        }
    }   
}
);

SEC_BETWEEN_CMD1 <- vehicleRespawnTime

playerCommandDelayed1 <- array(MAX_PLAYERS, 0); // <-

addCommandHandler( "randomveh",
function( playerid )
{
    if(!playerCommandDelayed1[playerid]) // <-
    {
        local pos = getPlayerPosition( playerid );
        local veh = createVehicle( (rand() % 55), pos[0] + 2.0, pos[1], pos[2] + 1.0, 0.0, 0.0, 0.0 );
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Random vehicle spawned.", 25, 135, 235 );
        
        if(useDefaultPlates)
        {
            timer( function() { setVehiclePlateText(veh, defaultPlates + str_rand(defaultPlatesExtra) ); }, 3000, 1);
        }  
        playerCommandDelayed1[playerid] = 1; // <-
        timer( function() { playerCommandDelayed1[playerid] = 0; }, SEC_BETWEEN_CMD1*1000, 1); // <-
    }
    else {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Can not use this command yet.", 255, 0, 0 );
    }  
}
);

addCommandHandler( "plates",
function( playerid, ... )
{
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Correct usage: /plates [TEXT].", 255, 0, 0 );
        return 1;
    }
    else {
        local plates = vargv[0].tostring();    
        if( isPlayerInVehicle( playerid ) )
        {
            local vehicleid = getPlayerVehicle( playerid );
            setVehiclePlateText( vehicleid, plates );
        }
        else {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" You are not in a vehicle.", 255, 0, 0 );
        }
    }        
	}
);

addCommandHandler( "color",
function( playerid, ... )
{
    if(vargv.len() != 6)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Correct usage: /color [RGB].", 255, 0, 0 );
        return 1;
    }
    else {
        local r1 = vargv[0].tointeger(); 
        local g1 = vargv[1].tointeger(); 
        local b1 = vargv[2].tointeger(); 
        local r2 = vargv[3].tointeger(); 
        local g2 = vargv[4].tointeger(); 
        local b2 = vargv[5].tointeger();   
        if( isPlayerInVehicle( playerid ) )
        {
            if( isNumeric(r1) ||  isNumeric(r2) ||  isNumeric(g1) ||  isNumeric(g2) ||  isNumeric(b1) ||  isNumeric(b2) )
            {
                local vehicleid = getPlayerVehicle( playerid );
                setVehicleColour(vehicleid, r1.tointeger(), g1.tointeger(), b1.tointeger(), r2.tointeger(), g2.tointeger(), b2.tointeger());
            }
        }
        else {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" You are not in a vehicle.", 255, 0, 0 );
        }
    }
}
);

addCommandHandler( "dirt",
function( playerid )
{
    if( isPlayerInVehicle( playerid ) )
    {
        local vehicleid = getPlayerVehicle( playerid );
        setVehicleDirtLevel( vehicleid, 1.0 );
    }
    else {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" You are not in a vehicle.", 255, 0, 0 );
    }
}
);

addCommandHandler( "tune",
function( playerid, ... )
{
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Correct usage: /tune [1-3].", 255, 0, 0 );
        return 1;
    }
    else {
        local amount = vargv[0].tostring(); 
        if( isPlayerInVehicle( playerid ) )
        {
            if(isNumeric(amount))
            {
                if( amount.tointeger() < 4 && 0 < amount.tointeger() )
                {	
                    local vehicleid = getPlayerVehicle( playerid );
                    setVehicleTuningTable( vehicleid, amount.tointeger() );
                    setVehicleWheelTexture( vehicleid, 0, 11 );
                    setVehicleWheelTexture( vehicleid, 1, 11 );
                }
                else {
                    sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid range! Tune ID's: 1-3.", 255, 0, 0 );
                }
            }
        }
        else {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" You are not in a vehicle.", 255, 0, 0 );
        }
    }
}
);

addCommandHandler( "repair",
function( playerid )
{
    if( isPlayerInVehicle( playerid ) )
    {
        local vehicleid = getPlayerVehicle( playerid );
        repairVehicle( vehicleid );
    }
    else {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" You are not in a vehicle.", 255, 0, 0 );
    }
}
);

addCommandHandler( "tires",
function( playerid, ... )
{
    if(vargv.len() != 2)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Correct usage: /tires [0-1] [ID].", 255, 0, 0 );
        return 1;
    }
    else {
        local whe = vargv[0].tostring(); 
        local id = vargv[1].tostring();
        if( isPlayerInVehicle( playerid ) )
        {
            if( isNumeric(whe) || isNumeric(id) )
            {
                if( whe.tointeger() < 2 && -1 < whe.tointeger() )
                {
                    if( id.tointeger() < 15 && -1 < id.tointeger() )
                    {
                        local vehicleid = getPlayerVehicle( playerid );
                        setVehicleWheelTexture( vehicleid, whe.tointeger(), id.tointeger() );
                    }
                    else {
                        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid range! Wheel ID's: 0-14.", 255, 0, 0 );
                    }
                }
                else {
                    sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid range! First parameter defines front or rear wheels, 1 or 0.", 255, 0, 0 );
                }
            }
        }
        else {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" You are not in a vehicle.", 255, 0, 0 );
        }
    }
}
);

addCommandHandler( "heal",
function( playerid )
{
    setPlayerHealth( playerid, 999.0 );
    sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Your total health is now 999.", 25, 135, 235 );
}
);

addCommandHandler( "health",
function( playerid, ... )
{
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Correct usage: /health [AMOUNT].", 255, 0, 0 );
        return 1;
    }
    else {
        local amount = vargv[0].tostring(); 
        if( isNumeric(amount) )
        {
            setPlayerHealth( playerid, amount.tofloat() );
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Your total health is now " + amount.tofloat() + ".", 25, 135, 235 );
        }
    }
}
);

addCommandHandler( "model",
function( playerid, ... )
{
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Correct usage: /model [ID].", 255, 0, 0 );
        return 1;
    }
    else {
        local id = vargv[0].tostring(); 
        if( isNumeric(id) )
        {
            if( id.tointeger() < 155 && -1 < id.tointeger() )
            {
                setPlayerModel( playerid, id.tointeger() );
            }
            else {
                sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid range! Character ID's: 0-154.", 255, 0, 0 );
            }
        }
    }
}
);

addCommandHandler( "randomize",
function( playerid )
{
    setPlayerModel( playerid, (rand() % 155) );
}
);

addCommandHandler( "unlock",
function( playerid )
{
    togglePlayerControls ( playerid, true );
    sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Your controls has been restored.", 25, 135, 235 );
}
);

addCommandHandler( "goto",
function( playerid, ... )
{
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Correct usage: /goto [ID].", 255, 0, 0 );
        return 1;
    }
    else {
        local other = vargv[0].tostring(); 
        if( isNumeric(other) )
        {
            if(isPlayerInVehicle(other.tointeger() ) )
            {
                local vehicleid = getPlayerVehicle(other.tointeger() );
                local pos = getVehiclePosition( vehicleid );
                setPlayerPosition( playerid, pos[0] + 2.0, pos[1], pos[2] );
                sendPlayerMessage(other.tointeger(), serverMsgPrefix + ": " + getPlayerName(playerid) + " teleported to your location.", 25, 135, 235 );
            }
            else
            {
                local pos = getPlayerPosition( other.tointeger() );
                setPlayerPosition( playerid, pos[0] + 2.0, pos[1], pos[2] );
                sendPlayerMessage(other.tointeger(), serverMsgPrefix + ": " + getPlayerName(playerid) + " teleported to your location.", 25, 135, 235 );
            }
        }
    }
}
);

addCommandHandler( "tele",
function( playerid, ... )
{
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Correct usage: /tele [LOCATION].", 255, 0, 0 );
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Locations are: police | train | hotel | kirche | warehouse | clemente", 255, 105, 180 );
        return 1;
    }
    else {
        local place = vargv[0].tostring();
        if( place == "police" )
        {
            if  ( isPlayerInVehicle ( playerid ) )
            {
                sendPlayerMessage(playerid,serverMsgPrefix + ": " + "Please leave your vehicle!", 25, 135, 235 );
            }
            else {
                setPlayerPosition(playerid, -379.252045, 654.311584, -11.561144);
                sendPlayerMessage(playerid,serverMsgPrefix + ": " + "You are now at Police Department!", 25, 135, 235 );
            }	
        }
        else if( place == "train" )
        {
            if  ( isPlayerInVehicle ( playerid ) )
            {
                sendPlayerMessage(playerid,serverMsgPrefix + ": " + "Please leave your vehicle!", 25, 135, 235 );
            }
            else {
                setPlayerPosition(playerid, -575.157776, 1626.630737, -15.695728);
                sendPlayerMessage(playerid,serverMsgPrefix + ": " + "You are now at Train Station!", 25, 135, 235 );
            }	
        }
        else if( place == "hotel" )
        {
            if  ( isPlayerInVehicle ( playerid ) )
            {
                sendPlayerMessage(playerid,serverMsgPrefix + ": " + "Please leave your vehicle!", 25, 135, 235 );
            }
            else {
                setPlayerPosition(playerid, -578.208801, -237.975876, -4.486568);
                sendPlayerMessage(playerid,serverMsgPrefix + ": " + "You are now at Hotel!", 25, 135, 235 );
            }	
        }
        else if( place == "kirche" )
        {
            if  ( isPlayerInVehicle ( playerid ) )
            {
                sendPlayerMessage(playerid,serverMsgPrefix + ": " + "Please leave your vehicle!", 25, 135, 235 );
            }
            else {
                setPlayerPosition(playerid, -28.127775, -214.620178, -12.192836);
                sendPlayerMessage(playerid,serverMsgPrefix + ": " + "You are now at Kirche!", 25, 135, 235 );
            }	
        }
        else if( place == "warehouse" )
        {
            if  ( isPlayerInVehicle ( playerid ) )
            {
                sendPlayerMessage(playerid,serverMsgPrefix + ": " + "Please leave your vehicle!", 25, 135, 235 );
            }
            else {
                setPlayerPosition(playerid, -1316.604248, 790.945984, -15.194283);
                sendPlayerMessage(playerid,serverMsgPrefix + ": " + "You are now at Warehouse!", 25, 135, 235 );
            }
        }
        else if( place == "clemente" )
        {
            if  ( isPlayerInVehicle ( playerid ) )
            {
                sendPlayerMessage(playerid,serverMsgPrefix + ": " + "Please leave your vehicle!", 25, 135, 235 );
            }
            else {
                setPlayerPosition(playerid, -307.577789, 1210.057129, 55.787807);
                sendPlayerMessage(playerid,serverMsgPrefix + ": " + "You are now at Clemente Mansion!", 25, 135, 235 );
            }
        }
        else {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid [LOCATION]!", 255, 0, 0 );
        }
    }
}
);

addCommandHandler( "warp",
function( playerid, ... )
{
    if(vargv.len() != 2)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Correct usage: /warp [X,Y,Z] [AMOUNT].", 255, 0, 0 );
        return 1;
    }
    else {
        local point = vargv[0].tostring(); 
        local amount = vargv[1].tostring(); 
        if(isNumeric(amount))
        {   
            if( amount.tointeger() < 10000 && -10000 < amount.tointeger() )
            {
                local pos = getPlayerPosition( playerid );
                if( point == "x" )
                {
                    setPlayerPosition(playerid, pos[0] + amount.tointeger(), pos[1], pos[2] );
                }
                if( point == "y" )
                {
                    setPlayerPosition(playerid, pos[0], pos[1] + amount.tointeger(), pos[2] );
                }
                if( point == "z" )
                {
                    setPlayerPosition(playerid, pos[0], pos[1], pos[2] + amount.tointeger() );
                }
            }
            else {
                sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid range. Maximum warping range per time is 10 000 for security reasons.", 255, 0, 0 );
            }
        }
    }
}
);

addCommandHandler( "weatherlist",
function( playerid )
{
    sendPlayerMessage(playerid, " CONSOLE: Weather list:", 25, 135, 235 );
    sendPlayerMessage(playerid, " CONSOLE: Weather command example usage: /weather night_foggy", 25, 135, 235 );
    sendPlayerMessage(playerid, " CONSOLE: morning_clear/foggy/rainy", 25, 135, 235 );
    sendPlayerMessage(playerid, " CONSOLE: noon_clear/foggy/rainy", 25, 135, 235 );
    sendPlayerMessage(playerid, " CONSOLE: even_clear/foggy/rainy", 25, 135, 235 );
    sendPlayerMessage(playerid, " CONSOLE: night_clear/foggy/rainy", 25, 135, 235 );
}
);

// NOTE: WEATHER COMMAND MIGHT CONFUSE BOTH SERVER AND PLAYERS - YOU MIGHT WANT TO EITHER ERASE THIS COMMAND OR MAKE IT ONLY AVAILABLE FOR ADMINISTRATORS!
SEC_BETWEEN_CMD2 <- 300;

playerCommandDelayed2 <- array(MAX_PLAYERS, 0); // <-

addCommandHandler( "weather",
function( playerid, ... )
{
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Correct usage: /weather [WEATHER].", 255, 0, 0 );
        return 1;
    }
    else {
        local weather = vargv[0].tostring();     
        if(!playerCommandDelayed2[playerid]) // <-
        {
            if( weather == "morning_clear" )
            {
                setWeather ( "DT_RTRclear_day_early_morn1" );
            }
            else if( weather == "morning_foggy" )
            {
                setWeather ( "DT_RTRfoggy_day_early_morn1" );
            }
            else if( weather == "morning_rainy" )
            {
                setWeather ( "DT_RTRrainy_day_morning" );
            }
            else if( weather == "noon_clear" )
            {
                setWeather ( "DT_RTRclear_day_noon" );
            }
            else if( weather == "noon_foggy" )
            {
                setWeather ( "DT_RTRfoggy_day_noon" );
            }
            else if( weather == "noon_rainy" )
            {
                setWeather ( "DT_RTRrainy_day_noon" );
            }
            else if( weather == "even_clear" )
            {
                setWeather ( "DT_RTRclear_day_evening" );
            }
            else if( weather == "even_foggy" )
            {
                setWeather ( "DT_RTRfoggy_day_evening" );
            }
            else if( weather == "even_rainy" )
            {
                setWeather ( "DT_RTRrainy_day_evening" );
            }
            else if( weather == "night_clear" )
            {
                setWeather ( "DT_RTRclear_day_night" );
            }
            else if( weather == "night_foggy" )
            {
                setWeather ( "DT_RTRfoggy_day_night" );
            }
            else if( weather == "night_rainy" )
            {
                setWeather ( "DT_RTRrainy_day_night" );
            }
            else {
                sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid [WEATHER]!", 255, 0, 0 );
            }
            playerCommandDelayed2[playerid] = 1; // <-
            timer( function() { playerCommandDelayed2[playerid] = 0; }, SEC_BETWEEN_CMD2*1000, 1); // <-  
        }
        else {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Can not use this command yet.", 255, 0, 0 );
        }
    }
}
);

addCommandHandler( "weapon",
function( playerid, ... )
{
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Correct usage: /weapon [ID].", 255, 0, 0 );
        return 1;
    }
    else {
        local id = vargv[0].tostring();   
        if(isNumeric(id))
        if( id.tointeger() < 22 && 1 < id.tointeger() )
        {
            givePlayerWeapon(playerid, id.tointeger(), 999 );
        }
        else {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid range! Weapon ID's: 2-21.", 255, 0, 0 );
        }
    }
}
);

addCommandHandler( "reload",
function( playerid )
{
    local id = getPlayerWeapon(playerid);
    givePlayerWeapon(playerid, id.tointeger(), 999 );
    sendPlayerMessage(playerid,serverMsgPrefix + ": " + "The ammunition of your currently equipped weapon has been reset!", 25, 135, 235 );
}
);

addCommandHandler( "money",
function( playerid, ... )
{
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Correct usage: /money [AMOUNT].", 255, 0, 0 );
        return 1;
    }
    else {
        local amount = vargv[0].tostring();   
        if(isNumeric(amount))
        givePlayerMoney(playerid, amount.tointeger() );
        sendPlayerMessage(playerid,serverMsgPrefix + ": " + "You received $" + amount.tointeger() + ".", 25, 135, 235 );
    }
}
);

addCommandHandler( "countdown",
function(playerid, ...)
{
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Correct usage: /countdown [SECONDS].", 255, 0, 0 );
        return 1;
    }
    else {
        local sec = vargv[0].tostring();   
        if(isNumeric(sec))
        {
            if( sec.tointeger() < 6 && 0 < sec.tointeger() )
            {
                if( cds == 0 )
                {
                    start = timer( launcher, 1000, sec.tointeger() + 1, playerid );
                    launch = sec.tointeger() + 1;
                    sendPlayerMessageToAll(serverMsgPrefix + ": " + getPlayerName(playerid) + " launched " + sec.tointeger() + " second countdown timer! ", 255, 255, 0 );
                    cds = 1;
                }
                else if( cds == 1 )
                {
                    sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Another timer already counting!", 25, 135, 235 );
                }
            }
            else {
                sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid range! Allowed range: 1-5 seconds.", 255, 0, 0 );
            }            
        }
    }
}
);

function launcher(playerid)
{ 
    launch--;
    for(local i = 0; i < getMaxPlayers(); i++){
        if(isPlayerConnected(i)){
            local mypos = getPlayerPosition(playerid);
            local idpos = getPlayerPosition(i);

            local dist = getDistanceBetweenPoints3D( idpos[0], idpos[1], idpos[2], mypos[0], mypos[1], mypos[2] );
            if( dist < 51 ){
                if( launch > 0 )
                {
                    triggerClientEvent(i, "countDown", launch.tostring());                    
                }
                else if( launch == 0 )
                {
                    local text = "!! GO !!";
                    triggerClientEvent(i, "countDown", text.tostring());
                    timer(function(i){
                        cds = 0;
                        text = "";
                        triggerClientEvent(i, "countDown", text.tostring());
                    }, 3500, 1, i);
                }
            }
        }
    }
}

function pm(...)
{
    local playerid = vargv[0];
    if(vargv.len() > 2)
    {
        local targetid = vargv[1];
        if(isPlayerConnected(targetid.tointeger()))
        {
            if(isNumeric(targetid))
            {
                local toplayer = targetid.tointeger();
                local msg = "";
                for (local i = 2; i < vargv.len(); i++)
                {
                    msg = msg + " " + vargv[i];
                }
                sendPlayerMessage(toplayer, "PM from (" + playerid + ") " + getPlayerName(playerid) + ": " + msg, 140, 0, 200);
                sendPlayerMessage(playerid, "PM sent to (" + toplayer + ") " + getPlayerName(toplayer) + ": " + msg, 140, 0, 200);
            }
        }
        else
        {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid ID.", 255, 0, 0 );
        }
    }
    else
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Correct usage: /pm [ID] [MESSAGE].", 255, 0, 0 );
    }
    return true;
}
addCommandHandler("pm", pm);

function me(...)
{
    local playerid = vargv[0].tointeger();
    if(vargv.len() == 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Correct usage: /me [ACTION].", 255, 0, 0 );
        return 1;
    }
    if(isPlayerConnected(playerid))
    {
        local msg = "";
        local i;
        local plypos, userpos, distance;
        plypos = getPlayerPosition(playerid);
			     for(i = 1; i < vargv.len(); i++) msg = msg+" "+vargv[i];
			     for(i = 0; i < getMaxPlayers(); i++)
    {
        if(isPlayerConnected(i))
        {
            userpos = getPlayerPosition(i);
            distance = getDistanceBetweenPoints3D( userpos[0], userpos[1], userpos[2], plypos[0], plypos[1], plypos[2] );
            if(distance < 15)
            {
                sendPlayerMessage(i,getPlayerName(playerid) + msg + " (action)" , 255, 204, 229);
            }
        }
    }
}
}
addCommandHandler("me", me);

function s(...)
{
    local playerid = vargv[0].tointeger();
    if(vargv.len() == 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Correct usage: /s [MESSAGE].", 255, 0, 0 ); 
        return 1;
    }
    if(isPlayerConnected(playerid))
    {
        local msg = "";
        local i;
        local plypos, userpos, distance;
        plypos = getPlayerPosition(playerid);
			     for(i = 1; i < vargv.len(); i++) msg = msg+" "+vargv[i];
			     for(i = 0; i < getMaxPlayers(); i++)
    {
        if(isPlayerConnected(i))
        {
            userpos = getPlayerPosition(i);
            distance = getDistanceBetweenPoints3D( userpos[0], userpos[1], userpos[2], plypos[0], plypos[1], plypos[2] );
            if(distance < 15)
            {
                sendPlayerMessage(i,getPlayerName(playerid) + " said: " + msg, 185, 200, 250 );
            }
        }
    }
}
}
addCommandHandler("s", s);

addCommandHandler( "chat",
function( playerid, ... )
{
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Correct usage: /chat [SHOW / HIDE].", 255, 0, 0 );
        return 1;
    }
    else {
        local cmd = vargv[0].tostring();
        if( cmd == "hide" )
        {
            triggerClientEvent(playerid, "chat_hide");
        }
        else if( cmd == "show" )
        {
            triggerClientEvent(playerid, "chat_show");   
        }
        else {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid [COMMAND]!", 255, 0, 0 );
        }
    }
}
);

addCommandHandler( "mypos",
function( playerid )
{
    local ppos = getPlayerPosition(playerid);
    sendPlayerMessage(playerid,serverMsgPrefix + ": " + "Your current position: " + ppos[0] +" " + ppos[1] + " " + ppos[2] + ".", 25, 135, 235 );
    sendPlayerMessage(playerid,serverMsgPrefix + ": " + "Remember that you can save your position with command /savepos.", 255, 0, 0 );
    sendPlayerMessage(playerid,serverMsgPrefix + ": " + "Your position will be saved into a text file in your /M2MP/Data folder!", 255, 0, 0 );
}
);


addCommandHandler( "topoint",
function( playerid, ... )
{
    if(vargv.len() != 3)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Correct usage: /topoint [COORDINATE X ] [COORDINATE Y ] [COORDINATE Z ] .", 255, 0, 0 );
        return 1;
    }
    else {
        if( isNumeric( vargv[0] ) && isNumeric( vargv[1] ) && isNumeric( vargv[2] ) )
        {
            local x = vargv[0].tofloat(); 
            local y = vargv[1].tofloat(); 
            local z = vargv[2].tofloat();
            {
                setPlayerPosition(playerid, x.tofloat(), y.tofloat(), z.tofloat() );
            }
        }
    }
}
);

addCommandHandler( "resetcolor",
function ( playerid )
{
    if  ( isPlayerInVehicle ( playerid ) )
    {
        local model = getVehicleModel ( getPlayerVehicle ( playerid ) );
        if(model == 42 )
        {
            setVehicleColour ( getPlayerVehicle ( playerid ), 255, 255, 255, 0, 0, 0 );
        }
        if(model == 51 )
        {
            setVehicleColour ( getPlayerVehicle ( playerid ), 0, 0, 0, 100, 100, 100 );
        }
    }
}
);

addCommandHandler( "vehicleinfo",
function( playerid )
{
    if  ( isPlayerInVehicle ( playerid ) )
    {
        local id = getPlayerVehicle(playerid);
        local col = getVehicleColour(id);

        sendPlayerMessage( playerid, serverMsgPrefix + ": " + "VEHICLE INFORMATION:", 25, 135, 235 );
        sendPlayerMessage( playerid, serverMsgPrefix + ": " + "ID: " + id, 25, 135, 235 );
        sendPlayerMessage( playerid, serverMsgPrefix + ": " + "MODEL: " + getVehicleModel(id), 25, 135, 235 );
        sendPlayerMessage( playerid, serverMsgPrefix + ": " + "PLATES: " + getVehiclePlateText(id), 25, 135, 235 );
        sendPlayerMessage( playerid, serverMsgPrefix + ": " + "TUNINGLEVEL: " + getVehicleTuningTable(id), 25, 135, 235 );
        sendPlayerMessage( playerid, serverMsgPrefix + ": " + "TIRES REAR: <NO DATA AVAILABLE>" , 25, 135, 235 );
        sendPlayerMessage( playerid, serverMsgPrefix + ": " + "COLOR 1 R: " + col[0], 25, 135, 235 );
        sendPlayerMessage( playerid, serverMsgPrefix + ": " + "COLOR 1 G: " + col[1], 25, 135, 235 );
        sendPlayerMessage( playerid, serverMsgPrefix + ": " + "COLOR 1 B: " + col[2], 25, 135, 235 );
        sendPlayerMessage( playerid, serverMsgPrefix + ": " + "COLOR 2 R: " + col[3], 25, 135, 235 );
        sendPlayerMessage( playerid, serverMsgPrefix + ": " + "COLOR 2 G: " + col[4], 25, 135, 235 );
        sendPlayerMessage( playerid, serverMsgPrefix + ": " + "COLOR 2 B: " + col[5], 25, 135, 235 );
    }
    else {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" You are not in a vehicle.", 255, 0, 0 );
    }
}
);

addCommandHandler("cc",
function( playerid ) 
{
    for( local i = 0; i <= 10; ++i )
    sendPlayerMessage(playerid, " " );
}
);

addCommandHandler( "automsg",
function( playerid, ... )
{
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Correct usage: /automsg [OPTION].", 255, 0, 0 );
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Options are: enable | disable", 255, 105, 180 );
        return 1;
    }
    else {
        local area = vargv[0].tostring();
        if( area == "enable" )
        {
            MsgAccess[playerid] = 1;
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Automatic messages enabled!", 175, 255, 45 ); 
            log( getPlayerName(playerid) + " enabled AutoMsg!");
        }
        else if( area == "disable" )
        {
            MsgAccess[playerid] = 0;
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Automatic messages disabled!", 175, 255, 45 ); 
            log( getPlayerName(playerid) + " disabled AutoMsg!");

        }
        else {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid [OPTION]!", 255, 0, 0 );
        }
    }
}
);

// GRAPHICAL COMMAND SYSTEM
SEC_BETWEEN_CMD1 <- vehicleRespawnTime 

playerCommandDelayed1 <- array(MAX_PLAYERS, 0); // <-

function gui_veh_spa(playerid, text)
{
    if(!playerCommandDelayed1[playerid]) // <-
    {
        if( isNumeric(text) )
        {
            if( text.tointeger() < 54 && -1 < text.tointeger() )
            {
                
                local pos = getPlayerPosition( playerid );
                local veh = createVehicle( text.tointeger(), pos[0] + 2.0, pos[1], pos[2] + 1.0, 0.0, 0.0, 0.0 );
                sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Vehicle (" + text + ") spawned.", 25, 135, 235 );
                
                if(useDefaultPlates)
                {
                    timer( function() { setVehiclePlateText(veh, defaultPlates + str_rand(defaultPlatesExtra) ); }, 3000, 1);
                }       
                playerCommandDelayed1[playerid] = 1; // <-
                timer( function() { playerCommandDelayed1[playerid] = 0; }, SEC_BETWEEN_CMD1*1000, 1); // <-
            }
            else {
                sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid range! Vehicle ID's: 0-53.", 255, 0, 0 );
            }
        }
    }
    else {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Can not use this command yet.", 255, 0, 0 );
    }  
}
addEventHandler("gui_veh_spa", gui_veh_spa);

function gui_veh_dir( playerid )
{
    if( isPlayerInVehicle( playerid ) )
    {
        local vehicleid = getPlayerVehicle( playerid );
        if( getVehicleDirtLevel( vehicleid ) == 0.0 )
        {
            local vehicleid = getPlayerVehicle( playerid );
            setVehicleDirtLevel( vehicleid, 1.0 );
        }
        else {
            setVehicleDirtLevel( vehicleid, 0.0 );
        }
    }
    else {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" You are not in a vehicle.", 255, 0, 0 );
    }
}
addEventHandler("gui_veh_dir", gui_veh_dir);

function gui_veh_tun( playerid )
{
    if( isPlayerInVehicle( playerid ) )
    {
        local vehicleid = getPlayerVehicle( playerid );
        if( getVehicleTuningTable( vehicleid ) == 1 )
        {
            local vehicleid = getPlayerVehicle( playerid );
            setVehicleTuningTable( vehicleid, 3 );
            setVehicleWheelTexture( vehicleid, 0, 11 );
            setVehicleWheelTexture( vehicleid, 1, 11 );
        }
        else {
            setVehicleTuningTable( vehicleid, 1 );
        }
    }
    else {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" You are not in a vehicle.", 255, 0, 0 );
    }
}
addEventHandler("gui_veh_tun", gui_veh_tun);

function gui_veh_rep( playerid )
{
    if( isPlayerInVehicle( playerid ) )
    {
        local vehicleid = getPlayerVehicle( playerid );
        repairVehicle( vehicleid );
    }
    else {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" You are not in a vehicle.", 255, 0, 0 );
    }
}
addEventHandler("gui_veh_rep", gui_veh_rep);

function gui_veh_pla( playerid, text )
{
    if( isPlayerInVehicle( playerid ) )
    {
        local vehicleid = getPlayerVehicle( playerid );
        setVehiclePlateText( vehicleid, text );
    }
    else {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" You are not in a vehicle.", 255, 0, 0 );
    }        
	}
addEventHandler("gui_veh_pla", gui_veh_pla);

function gui_veh_tir( playerid, text )
{
    if( isNumeric(text) )
    {
        if( isPlayerInVehicle( playerid ) )
        {
            if( text.tointeger() < 15 && -1 < text.tointeger() )
            {
                local vehicleid = getPlayerVehicle( playerid );
                setVehicleWheelTexture( vehicleid, 0, text.tointeger() );
                setVehicleWheelTexture( vehicleid, 1, text.tointeger() );
            }
            else {
                sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid range! Wheel ID's: 0-14.", 255, 0, 0 );
            }
        }
        else {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" You are not in a vehicle.", 255, 0, 0 );
        }
    }
}
addEventHandler("gui_veh_tir", gui_veh_tir);

function gui_wep_spa( playerid, text )
{
    if( isNumeric(text) )
    {
        if( text.tointeger() < 22 && 1 < text.tointeger() )
        {
            givePlayerWeapon(playerid, text.tointeger(), 999 );
        }
    }
    else {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid range! Weapon ID's: 2-21.", 255, 0, 0 );
    }
}
addEventHandler("gui_wep_spa", gui_wep_spa);

function gui_wep_rel( playerid )
{
    local id = getPlayerWeapon(playerid);
    givePlayerWeapon(playerid, id.tointeger(), 999 );
    sendPlayerMessage(playerid,serverMsgPrefix + ": " + "The ammunition of your currently equipped weapon has been reset!", 25, 135, 235 );
}
addEventHandler("gui_wep_rel", gui_wep_rel);

function gui_gen_mod( playerid, text )
{
    if( isNumeric(text) )
    {
        setPlayerModel( playerid, text.tointeger() );
    }
}
addEventHandler("gui_gen_mod", gui_gen_mod);

function gui_gen_ran( playerid )
{
    setPlayerModel( playerid, (rand() % 155) );
}
addEventHandler("gui_gen_ran", gui_gen_ran);

function gui_gen_unl( playerid )
{
    togglePlayerControls ( playerid, true );
    sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Your controls has been restored.", 25, 135, 235 );
}
addEventHandler("gui_gen_unl", gui_gen_unl);

function gui_gen_hea( playerid )
{
    setPlayerHealth( playerid, 999.0 );
    sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Your total health is now 999.", 25, 135, 235 );
}
addEventHandler("gui_gen_hea", gui_gen_hea);

function gui_gen_pid( playerid, text )
{
    if( isNumeric(text) )
    {
        if(isPlayerInVehicle(text.tointeger() ) )
        {
            local vehicleid = getPlayerVehicle(text.tointeger() );
            local pos = getVehiclePosition( vehicleid );
            setPlayerPosition( playerid, pos[0] + 2.0, pos[1], pos[2] );
            sendPlayerMessage(text.tointeger(), serverMsgPrefix + ": " + getPlayerName(playerid) + " teleported to your location.", 25, 135, 235 );
        }
        else
        {
            local pos = getPlayerPosition( text.tointeger() );
            setPlayerPosition( playerid, pos[0] + 2.0, pos[1], pos[2] );
            sendPlayerMessage(text.tointeger(), serverMsgPrefix + ": " + getPlayerName(playerid) + " teleported to your location.", 25, 135, 235 );
        }
    }
}
addEventHandler("gui_gen_pid", gui_gen_pid);

function gui_gen_loc( playerid, text )
{
    if( text == "police" )
    {
        if  ( isPlayerInVehicle ( playerid ) )
        {
            sendPlayerMessage(playerid,serverMsgPrefix + ": " + "Please leave your vehicle!", 25, 135, 235 );
        }
        else {
            setPlayerPosition(playerid, -379.252045, 654.311584, -11.561144);
            sendPlayerMessage(playerid,serverMsgPrefix + ": " + "You are now at Police Department!", 25, 135, 235 );
        }	
    }
    if( text == "train" )
    {
        if  ( isPlayerInVehicle ( playerid ) )
        {
            sendPlayerMessage(playerid,serverMsgPrefix + ": " + "Please leave your vehicle!", 25, 135, 235 );
        }
        else {
            setPlayerPosition(playerid, -575.157776, 1626.630737, -15.695728);
            sendPlayerMessage(playerid,serverMsgPrefix + ": " + "You are now at Train Station!", 25, 135, 235 );
        }	
    }
    if( text == "hotel" )
    {
        if  ( isPlayerInVehicle ( playerid ) )
        {
            sendPlayerMessage(playerid,serverMsgPrefix + ": " + "Please leave your vehicle!", 25, 135, 235 );
        }
        else {
            setPlayerPosition(playerid, -578.208801, -237.975876, -4.486568);
            sendPlayerMessage(playerid,serverMsgPrefix + ": " + "You are now at Hotel!", 25, 135, 235 );
        }	
    }
    if( text == "kirche" )
    {
        if  ( isPlayerInVehicle ( playerid ) )
        {
            sendPlayerMessage(playerid,serverMsgPrefix + ": " + "Please leave your vehicle!", 25, 135, 235 );
        }
        else {
            setPlayerPosition(playerid, -28.127775, -214.620178, -12.192836);
            sendPlayerMessage(playerid,serverMsgPrefix + ": " + "You are now at Kirche!", 25, 135, 235 );
        }	
    }
    if( text == "warehouse" )
    {
        if  ( isPlayerInVehicle ( playerid ) )
        {
            sendPlayerMessage(playerid,serverMsgPrefix + ": " + "Please leave your vehicle!", 25, 135, 235 );
        }
        else {
            setPlayerPosition(playerid, -1316.604248, 790.945984, -15.194283);
            sendPlayerMessage(playerid,serverMsgPrefix + ": " + "You are now at Warehouse!", 25, 135, 235 );
        }
    }
    if( text == "clemente" )
    {
        if  ( isPlayerInVehicle ( playerid ) )
        {
            sendPlayerMessage(playerid,serverMsgPrefix + ": " + "Please leave your vehicle!", 25, 135, 235 );
        }
        else {
            setPlayerPosition(playerid, -307.577789, 1210.057129, 55.787807);
            sendPlayerMessage(playerid,serverMsgPrefix + ": " + "You are now at Clemente Mansion!", 25, 135, 235 );
        }
    }
}
addEventHandler("gui_gen_loc", gui_gen_loc);

// NOTE: WEATHER COMMAND MIGHT CONFUSE BOTH SERVER AND PLAYERS - YOU MIGHT WANT TO EITHER ERASE THIS COMMAND OR MAKE IT ONLY AVAILABLE FOR ADMINISTRATORS!
SEC_BETWEEN_CMD3 <- 300;

playerCommandDelayed3 <- array(MAX_PLAYERS, 0); // <-

function gui_gen_wea( playerid, text )
{       
    if(!playerCommandDelayed3[playerid]) // <-
    {
        if( text == "morning_clear" )
        {
            setWeather ( "DT_RTRclear_day_early_morn1" );
        }
        if( text == "morning_foggy" )
        {
            setWeather ( "DT_RTRfoggy_day_early_morn1" );
        }
        if( text == "morning_rainy" )
        {
            setWeather ( "DT_RTRrainy_day_morning" );
        }
        if( text == "noon_clear" )
        {
            setWeather ( "DT_RTRclear_day_noon" );
        }
        if( text == "noon_foggy" )
        {
            setWeather ( "DT_RTRfoggy_day_noon" );
        }
        if( text == "noon_rainy" )
        {
            setWeather ( "DT_RTRrainy_day_noon" );
        }
        if( text == "even_clear" )
        {
            setWeather ( "DT_RTRclear_day_evening" );
        }
        if( text == "even_foggy" )
        {
            setWeather ( "DT_RTRfoggy_day_evening" );
        }
        if( text == "even_rainy" )
        {
            setWeather ( "DT_RTRrainy_day_evening" );
        }
        if( text == "night_clear" )
        {
            setWeather ( "DT_RTRclear_day_night" );
        }
        if( text == "night_foggy" )
        {
            setWeather ( "DT_RTRfoggy_day_night" );
        }
        if( text == "night_rainy" )
        {
            setWeather ( "DT_RTRrainy_day_night" );
        }
        playerCommandDelayed3[playerid] = 1; // <-
        timer( function() { playerCommandDelayed3[playerid] = 0; }, SEC_BETWEEN_CMD3*1000, 1); // <- <-
        }
        else {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Can not use this command yet.", 255, 0, 0 );
        }
    }
addEventHandler("gui_gen_wea", gui_gen_wea);

function gui_war_x( playerid, text )
{
    if( isNumeric(text) )
    {
        if( text.tointeger() < 10000 && -10000 < text.tointeger() )
        {
            local pos = getPlayerPosition( playerid );
            setPlayerPosition(playerid, pos[0] + text.tointeger(), pos[1], pos[2] );
        }
        else {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid range. Maximum warping range per time is 10 000 for security reasons.", 255, 0, 0 );
        }
    }
}
addEventHandler("gui_war_x", gui_war_x);

function gui_war_y( playerid, text )
{
    if( isNumeric(text) )
        {
        if( text.tointeger() < 10000 && -10000 < text.tointeger() )
        {
            local pos = getPlayerPosition( playerid );
            setPlayerPosition(playerid, pos[0], pos[1] + text.tointeger(), pos[2] );
        }
        else {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid range. Maximum warping range per time is 10 000 for security reasons.", 255, 0, 0 );
        }
    }
}
addEventHandler("gui_war_y", gui_war_y);

function gui_war_z( playerid, text )
{
    if( isNumeric(text) )
    {
        if( text.tointeger() < 10000 && -10000 < text.tointeger() )
        {
            local pos = getPlayerPosition( playerid );
            setPlayerPosition(playerid, pos[0], pos[1], pos[2] + text.tointeger() );
        }
        else {
            sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry, invalid range. Maximum warping range per time is 10 000 for security reasons.", 255, 0, 0 );
        }
    }
}
addEventHandler("gui_war_z", gui_war_z);

addCommandHandler( "getserial", // NOTE: THIS IS USED TO GET YOUR SERIAL FOR RCON FUNCTION!
function( playerid )
{
    local getserial = sendPlayerMessage(playerid, "RCON: Your serial is: " + getPlayerSerial(playerid) + ".", 255, 255, 0 );
    log("serial: " + getPlayerSerial(playerid));
}
);

// ADMIN REMOTE CONSOLE
addCommandHandler( "rcon", // NOTE: PLEASE SEE THE COMMENT FOR COMMAND getserial JUST ABOVE!
function( playerid, ... )
{
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Correct usage: /rcon [PASSWORD].", 255, 0, 0 );
        return 1;
    }
    else {
        local password = vargv[0].tostring();   
        if(Logged[playerid] == 0)
        {
            if( password == rconPassword) // NOTE: CHOOSE PASSWORD YOU CAN REMEMBER, BUT NOT TOO EASY TO BE QUESSED!
            {
                if( getPlayerSerial( playerid ) == adminSerial) // NOTE: THIS SERIALS ARE INSERTED ON TOP OF YOUR SCRIPT UNDER //LOCALS
                {
                    Admin[playerid] = 1;
                    Logged[playerid] = 1;
                    sendPlayerMessageToAll(serverMsgPrefix + ": " + getPlayerName(playerid) + " has logged into Administrators Remote Console!", 255, 0, 0 );
                    sendPlayerMessage(playerid, "RCON: You now have access to Admin Commands.", 25, 135, 235 );
                    log( "RCON: " + getPlayerName(playerid) + " has logged into RCON");
                }
                else {
                    sendPlayerMessage( playerid, serverMsgPrefix + ": " + "You are not authorized to do this.", 255, 0, 0 );
                }
            }
            else
            {
                sendPlayerMessage(playerid, serverMsgPrefix + ": " + "Invalid entry.", 25, 135, 235 );
            }
        }
        else
        {
            sendPlayerMessage(playerid, serverMsgPrefix + ": " + "You are already logged in!", 255, 0, 0 );
        }
    }
}
);

addCommandHandler( "rcon0",
function( playerid )
{
    if(Logged[playerid] == 1)
    {
            Admin[playerid] = 0;
            Logged[playerid] = 0;
            sendPlayerMessageToAll(serverMsgPrefix + ": " + getPlayerName(playerid) + " logged out of Administrators Remote Console.", 255, 0, 0 );
            sendPlayerMessage(playerid, "RCON: You no longer have access to Admin Commands.", 25, 135, 235 );
            log( "RCON: " + getPlayerName(playerid) + " is no longer using RCON.");
        }
    else
    {
        sendPlayerMessage(playerid, serverMsgPrefix + ": " + "You even haven't logged in!", 255, 0, 0 );
    }
}
);

addCommandHandler( "ahelp",
function( playerid )
{
    if(Logged[playerid] == 1)
    {
        sendPlayerMessage(playerid, "/rcon0", 255, 204, 229);
        sendPlayerMessage(playerid, "/kick ID", 255, 204, 229);
        sendPlayerMessage(playerid, "/ban ID ", 255, 204, 229);
        sendPlayerMessage(playerid, "/summon ID", 255, 204, 229);
        sendPlayerMessage(playerid, "/kill ID", 255, 204, 229);
        sendPlayerMessage(playerid, "/apm MESSAGE", 255, 204, 229);
        sendPlayerMessage(playerid, "/acc", 255, 204, 229);
    }
    else
    {
        sendPlayerMessage( playerid, serverMsgPrefix + ": " + "You are not authorized to do this.", 255, 0, 0 );
    }
}
);

addCommandHandler( "kick",
function( playerid, ... )
{
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Correct usage: /kick [ID].", 255, 0, 0 );
        return 1;
    }
    else {
        local other = vargv[0].tostring();   
        if( isNumeric(other) )
        {
            if(Logged[playerid] == 1)
            {
                sendPlayerMessageToAll(serverMsgPrefix + ": " + "Player: '" + getPlayerName(other.tointeger()) + "'was removed by " + getPlayerName(playerid) + ".", 25, 135, 235 );
                local kick = kickPlayer(other.tointeger());
            }
            else
            {
                sendPlayerMessage( playerid, serverMsgPrefix + ": " + "You are not authorized to do this.", 255, 0, 0 );
            }
        }
    }
}
);

addCommandHandler( "ban", // NOTE: BANNING IN M2MP NOT YET WORKS PROPERLY! SEE BRIX SITE OR M2MP FORUMS FOR OTHER BANNING METHODS!
function( playerid, other )
{
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Correct usage: /ban [ID].", 255, 0, 0 );
        return 1;
    }
    else {
        local other = vargv[0].tostring();   
        if( isNumeric(other) )
        {
            if(Logged[playerid] == 1)
            {
                sendPlayerMessageToAll(serverMsgPrefix + ": " + getPlayerName(other.tointeger()) + " was banned by " + getPlayerName(playerid) + " for misbehavior!", 25, 135, 235 );
                
                banPlayer(other.tointeger());      
            }
            else
            {
                sendPlayerMessage( playerid, serverMsgPrefix + ": " + "You are not authorized to do this.", 255, 0, 0 );
            }
        }
    }
}
);

addCommandHandler( "summon",
function( playerid, other )
{
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Correct usage: /summon [ID].", 255, 0, 0 );
        return 1;
    }
    else {
        local other = vargv[0].tostring();   
        if( isNumeric(other) )
        {
            if(Logged[playerid] == 1)
            {
                if(isPlayerInVehicle(other.tointeger() ) )
                {
                    local pos = getPlayerPosition( playerid );
                    local vehicleid = getPlayerVehicle(other.tointeger() );
                    setVehiclePosition(vehicleid, pos[0] + 2.0, pos[1], pos[2]);
                    sendPlayerMessage(other.tointeger(), serverMsgPrefix + ": " + getPlayerName(playerid) + "(Admin) is trying to summon you to their location.", 25, 135, 235 );
                    sendPlayerMessage(playerid, "RCON: You have summoned player " + getPlayerName(other.tointeger()) + " to your location.", 25, 135, 235 );
                }
                else
                {
                    local pos = getPlayerPosition( playerid );
                    setPlayerPosition( other.tointeger(), pos[0] + 2.0, pos[1], pos[2] );
                    sendPlayerMessage(other.tointeger(), serverMsgPrefix + ": " + getPlayerName(playerid) + "(Admin) is trying to summon you to their location.", 25, 135, 235 );
                    sendPlayerMessage(playerid, "RCON: You have summoned player " + getPlayerName(other.tointeger()) + " to your location.", 25, 135, 235 );
                }
            }
            else
            {
                sendPlayerMessage( playerid, serverMsgPrefix + ": " + "You are not authorized to do this.", 255, 0, 0 );
            }
        }
    }
}
);

addCommandHandler( "kill",
function( playerid, ... )
{
    if(vargv.len() != 1)
    {
        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Correct usage: /kill [ID].", 255, 0, 0 );
        return 1;
    }
    else {
        local other = vargv[0].tostring();   
        if( isNumeric(other) )
        {
            if(Logged[playerid] == 1)
            {
                setPlayerHealth(other.tointeger(), 0.0 );
                sendPlayerMessage(other.tointeger(), serverMsgPrefix + ": " + getPlayerName(playerid) + " has killed you with a privileged command.", 25, 135, 235 );
                sendPlayerMessage(playerid, "RCON: You killed " + getPlayerName(other.tointeger()) + "with a privileged command.", 25, 135, 235 );
            }
            else
            {
                sendPlayerMessage( playerid, serverMsgPrefix + ": " + "You are not authorized to do this.", 255, 0, 0 );
            }
        }
    }
}
);

addCommandHandler( "apm",
    function(...)
    {
        local playerid = vargv[0];
        if(Admin[playerid] > 0)
        {
            for(local j = 0; j < Admin[j]; j++)
            {
                if(isPlayerConnected( j ) )
                {
                    if(vargv.len() > 1)
                    {
                        local toplayer = Admin[j].tointeger();
                        local msg = "";
                        for(local i = 1; i < vargv.len(); i++)
                        {
                            msg = msg + " " + vargv[i];
                        }
                        sendPlayerMessage(j, "APM from " + getPlayerName(playerid) + "(" + getPlayerIdFromName( getPlayerName(playerid) ) + "): " + msg, 148, 0, 211);
                    }
                    else
                    {
                        sendPlayerMessage(playerid, serverMsgPrefix + " ERROR: " +" Invalid entry. Correct usage: /apm [MESSAGE].", 255, 0, 0 );
                    }
                }
            }   
        }
        else
        {
            sendPlayerMessage( playerid, serverMsgPrefix + ": " + "You are not authorized to do this.", 255, 0, 0 );
        }  
    }
);

addCommandHandler("acc",
function( playerid ) 
{
    if(Logged[playerid] == 1)
    {
        for( local i = 0; i <= 10; ++i )
        sendPlayerMessageToAll( " " );
    }
    else {
        sendPlayerMessage( playerid, serverMsgPrefix + ": " + "You are not authorized to do this.", 255, 0, 0 );
    }
}
);
