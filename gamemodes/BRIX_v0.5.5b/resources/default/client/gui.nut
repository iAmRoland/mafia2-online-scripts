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


// SCRIPT SETTINGS
local serverAdmin = ("")
local serverWebsite = ("http://brix.idonteven.tk");
local adminEmail = ("admin@idonteven.tk");

// OTHER SETTINGS
local cdText; // NOTE: THIS IS FOR COUNTDOWN COMMAND

// DEFINES WINDOWSES
local window = guiCreateElement( 0, "Graphical User Interface", 5, 20.0, 700.0, 650.0 ); // MAIN WINDOW
local window_veh = guiCreateElement( 0, "Graphical User Interface - VEHICLE WINDOW", 5.0, 20.0, 550.0, 750.0 ); // VEHICLE WINDOW
local window_gen = guiCreateElement( 0, "Graphical User Interface - GENERAL WINDOW", 5.0, 20.0, 650.0, 650.0 ); // GENERAL WINDOW
local window_wep = guiCreateElement( 0, "Graphical User Interface - WEAPON WINDOW", 5.0, 20.0, 300.0, 650.0 ); // WEAPON WINDOW
local window_war = guiCreateElement( 0, "Graphical User Interface - WARP CONTROL WINDOW", 5.0, 20.0, 350.0, 350.0 ); // WARP CONTROL WINDOW

// MAIN WINDOW
local open_window_veh = guiCreateElement( 2, "Open Vehicle Window", 20.0, 20.0, 100.0, 35.0, false, window );
local open_window_gen = guiCreateElement( 2, "Open General Window", 125.0, 20.0, 100.0, 35.0, false, window );
local open_window_wep = guiCreateElement( 2, "Open Weapon Window", 231.0, 20.0, 100.0, 35.0, false, window );
local open_window_war = guiCreateElement( 2, "Open Warp Control Window", 340.0, 20.0, 100.0, 35.0, false, window );

local label = guiCreateElement( 6, "ATTENTION:", 20.0, 60.0, 500.0, 25.0, false, window );
local label = guiCreateElement( 6, "You can either use this GUI to complete function or you can complete them by using chat. ", 20.0, 80.0, 500.0, 25.0, false, window );
local label = guiCreateElement( 6, "To view all commands please type /help. To view all command information type /howto [COMMAND].", 20.0, 95.0, 500.0, 25.0, false, window );

local label = guiCreateElement( 6, "SERVER STAFF:", 20.0, 150.0, 500.0, 25.0, false, window );
local label = guiCreateElement( 6, "Owner: " + serverAdmin, 20.0, 165.0, 500.0, 25.0, false, window ); // NOTE: ADD YOUR NAME HERE
local label = guiCreateElement( 6, "Moderator: " + serverAdmin, 20.0, 180.0, 500.0, 25.0, false, window ); // NOTE: ADD OTHER NAME HERE

local label = guiCreateElement( 6, "INFORMATION: ", 20.0, 230.0, 500.0, 25.0, false, window );
local label = guiCreateElement( 6, "Website: " + serverWebsite, 20.0, 245.0, 500.0, 25.0, false, window ); // NOTE: ADD YOUR WEBSITE HERE
local label = guiCreateElement( 6, "Email: " + adminEmail, 20.0, 260.0, 500.0, 25.0, false, window ); // NOTE: ADD YOUR MAIL HERE

local label = guiCreateElement( 6, "Server powered by BRIX - Open Source M2MP Script", 20.0, 280.0, 500.0, 25.0, false, window ); // NOTE: CHANGE / REMOVE ME
local label = guiCreateElement( 6, "This server is hosted only to preview BRIX -script.", 20.0, 295.0, 500.0, 25.0, false, window ); // NOTE: CHANGE / REMOVE ME
local label = guiCreateElement( 6, "Want it? Take it! Visit our website for the whole script!", 20.0, 310.0, 500.0, 25.0, false, window ); // NOTE: CHANGE / REMOVE ME

// VEHICLE WINDOW
local box_veh = guiCreateElement( ELEMENT_TYPE_EDIT, "Vehicle ID", 20.0, 20.0, 100.0, 35.0, false, window_veh );
local complete_veh = guiCreateElement( 2, "Spawn", 20.0, 70.0, 100.0, 35.0, false, window_veh );
local back_veh = guiCreateElement( 2, "Back", 20.0, 700.0, 100.0, 35.0, false, window_veh );

local box_pla = guiCreateElement( ELEMENT_TYPE_EDIT, "Plates", 120.0, 20.0, 100.0, 35.0, false, window_veh );
local complete_pla = guiCreateElement( 2, "Set plates", 120.0, 70.0, 100.0, 35.0, false, window_veh );

local box_tir = guiCreateElement( ELEMENT_TYPE_EDIT, "Tires", 220.0, 20.0, 100.0, 35.0, false, window_veh );
local complete_tir = guiCreateElement( 2, "Set tires", 220.0, 70.0, 100.0, 35.0, false, window_veh );

local complete_tun = guiCreateElement( 2, "Tune", 320.0, 70.0, 100.0, 35.0, false, window_veh );
local complete_rep = guiCreateElement( 2, "Repair", 320.0, 20.0, 100.0, 35.0, false, window_veh );
local complete_dir = guiCreateElement( 2, "Dirt", 420.0, 20.0, 100.0, 35.0, false, window_veh );

local label = guiCreateElement( 6, "0, Ascot Bailey", 20.0, 120.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "1, Berkley Kingfisher", 20.0, 140.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "2, Fuel Tank", 20.0, 160.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "3, Military Truck", 20.0, 180.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "4, Hank B, Truck", 20.0, 200.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "5, Hank Fueltank", 20.0, 220.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "6, Hot Rod 1", 20.0, 240.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "7, Hot Rod 2", 20.0, 260.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "8, Hot Rod 3", 20.0, 280.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "9, Houston Wasp", 20.0, 300.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "10, ISW 508", 20.0, 320.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "11, Army Jeep", 20.0, 340.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "12, Civil Jeep", 20.0, 360.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "13, Jefferson Futura", 20.0, 380.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "14, Jefferson Provincial", 20.0, 400.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "15, Lassiter 69", 20.0, 420.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "16, Lassiter 69 2", 20.0, 440.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "17, Lassiter 75", 20.0, 460.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "18, Lassiter 75 2,", 20.0, 480.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "19, Milk Truck", 20.0, 500.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "20, Prry Bus", 20.0, 520.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "21, Prison Bus", 20.0, 540.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "22, Potomac Indian", 20.0, 560.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "23, Quicksilver Windsor", 20.0, 580.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "24, Quicksilver Windsor Taxi", 20.0, 600.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "25, Shubert 23", 20.0, 620.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "26, Shubert 23 Destr", 20.0, 640.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "27, Shubert Armoured", 20.0, 660.0, 500.0, 25.0, false, window_veh );

local label = guiCreateElement( 6, "28, Shubert Beverly", 250.0, 120.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "29, Shubert Frigate", 250.0, 140.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "30, Shubert Hearse", 250.0, 160.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "31, Shubert Panel", 250.0, 180.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "32, Shubert Panel 2", 250.0, 200.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "33, Shubert Taxi", 250.0, 220.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "34-39 Shubert Trucks", 250.0, 240.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "40, Sicily Military Truck", 250.0, 260.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "41, Smith 200", 250.0, 280.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "42, Smith 200 Police", 250.0, 300.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "43, Smith Coupe", 250.0, 320.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "44, Smith Mainline", 250.0, 340.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "45, Smith Stingray", 250.0, 360.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "46, Smith Truck", 250.0, 380.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "47, Smith v8", 250.0, 400.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "48, Smith Wagon", 250.0, 420.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "49, Trailer", 250.0, 440.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "50, Ulver Newyorker", 250.0, 460.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "51, Ulver Newyorker Police", 250.0, 480.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "52, Walker Rocket", 250.0, 500.0, 500.0, 25.0, false, window_veh );
local label = guiCreateElement( 6, "53, Walter Coupe", 250.0, 520.0, 500.0, 25.0, false, window_veh );

// GENERAL WINDOW
local box_mod = guiCreateElement( ELEMENT_TYPE_EDIT, "Model ID", 20.0, 20.0, 100.0, 35.0, false, window_gen );
local complete_mod = guiCreateElement( 2, "Complete", 20.0, 70.0, 100.0, 35.0, false, window_gen );
local back_gen = guiCreateElement( 2, "Back", 20.0, 600.0, 100.0, 35.0, false, window_gen );

local box_pid = guiCreateElement( ELEMENT_TYPE_EDIT, "Player ID", 120.0, 20.0, 100.0, 35.0, false, window_gen );
local complete_pid = guiCreateElement( 2, "Go to player", 120.0, 70.0, 100.0, 35.0, false, window_gen );

local box_loc = guiCreateElement( ELEMENT_TYPE_EDIT, "Location", 220.0, 20.0, 100.0, 35.0, false, window_gen );
local complete_loc = guiCreateElement( 2, "Teleport to location", 220.0, 70.0, 100.0, 35.0, false, window_gen );

local box_wea = guiCreateElement( ELEMENT_TYPE_EDIT, "Weather", 320.0, 20.0, 100.0, 35.0, false, window_gen );
local complete_wea = guiCreateElement( 2, "Set weather", 320.0, 70.0, 100.0, 35.0, false, window_gen );

local complete_ran = guiCreateElement( 2, "Randomize", 420.0, 70.0, 100.0, 35.0, false, window_gen );
local complete_unl = guiCreateElement( 2, "Unlock", 420.0, 20.0, 100.0, 35.0, false, window_gen );
local complete_hea = guiCreateElement( 2, "Heal", 520.0, 20.0, 100.0, 35.0, false, window_gen );

local label = guiCreateElement( 6, "Weather list:", 20.0, 120.0, 500.0, 25.0, false, window_gen );
local label = guiCreateElement( 6, "morning_clear", 20.0, 140.0, 500.0, 25.0, false, window_gen );
local label = guiCreateElement( 6, "morning_foggy", 20.0, 160.0, 500.0, 25.0, false, window_gen );
local label = guiCreateElement( 6, "morning_rainy", 20.0, 180.0, 500.0, 25.0, false, window_gen );
local label = guiCreateElement( 6, "noon_clear", 20.0, 200.0, 500.0, 25.0, false, window_gen );
local label = guiCreateElement( 6, "noon_foggy", 20.0, 220.0, 500.0, 25.0, false, window_gen );
local label = guiCreateElement( 6, "noon_rainy", 20.0, 240.0, 500.0, 25.0, false, window_gen );
local label = guiCreateElement( 6, "night_clear", 20.0, 260.0, 500.0, 25.0, false, window_gen );
local label = guiCreateElement( 6, "night_foggy", 20.0, 280.0, 500.0, 25.0, false, window_gen );
local label = guiCreateElement( 6, "night_rainy", 20.0, 300.0, 500.0, 25.0, false, window_gen );

local label = guiCreateElement( 6, "Teleport Locations:", 300.0, 120.0, 500.0, 25.0, false, window_gen );
local label = guiCreateElement( 6, "police", 300.0, 140.0, 500.0, 25.0, false, window_gen );
local label = guiCreateElement( 6, "train", 300.0, 160.0, 500.0, 25.0, false, window_gen );
local label = guiCreateElement( 6, "hotel", 300.0, 180.0, 500.0, 25.0, false, window_gen );
local label = guiCreateElement( 6, "kirche", 300.0, 200.0, 500.0, 25.0, false, window_gen );
local label = guiCreateElement( 6, "warehouse", 300.0, 220.0, 500.0, 25.0, false, window_gen );
local label = guiCreateElement( 6, "clemente", 300.0, 240.0, 500.0, 25.0, false, window_gen );

// WEAPON WINDOW
local box_wep = guiCreateElement( ELEMENT_TYPE_EDIT, "Weapon ID", 20.0, 20.0, 100.0, 35.0, false, window_wep );
local complete_wep = guiCreateElement( 2, "Complete", 20.0, 70.0, 100.0, 35.0, false, window_wep );
local complete_rel = guiCreateElement( 2, "Refill", 120.0, 70.0, 100.0, 35.0, false, window_wep );
local back_wep = guiCreateElement( 2, "Back", 20.0, 600.0, 100.0, 35.0, false, window_wep );

local label = guiCreateElement( 6, "2, Model 12 Revolver", 20.0, 120.0, 500.0, 25.0, false, window_wep );
local label = guiCreateElement( 6, "3, Mauser C96", 20.0, 140.0, 500.0, 25.0, false, window_wep );
local label = guiCreateElement( 6, "4, Colt M1911A1", 20.0, 160.0, 500.0, 25.0, false, window_wep );
local label = guiCreateElement( 6, "5, Colt M1911 Special", 20.0, 180.0, 500.0, 25.0, false, window_wep );
local label = guiCreateElement( 6, "6, Model 19 Revolver", 20.0, 200.0, 500.0, 25.0, false, window_wep );
local label = guiCreateElement( 6, "7, MK2 Frag Grenade", 20.0, 220.0, 500.0, 25.0, false, window_wep );
local label = guiCreateElement( 6, "8, Remington Model 870 Field gun", 20.0, 240.0, 500.0, 25.0, false, window_wep );
local label = guiCreateElement( 6, "9, M3 Grease Gun", 20.0, 260.0, 500.0, 25.0, false, window_wep );
local label = guiCreateElement( 6, "10, MP40", 20.0, 280.0, 500.0, 25.0, false, window_wep );
local label = guiCreateElement( 6, "11, Thompson 1928", 20.0, 300.0, 500.0, 25.0, false, window_wep );
local label = guiCreateElement( 6, "12, M1A1 Thompson", 20.0, 320.0, 500.0, 25.0, false, window_wep );
local label = guiCreateElement( 6, "13, Beretta Model 38A", 20.0, 340.0, 500.0, 25.0, false, window_wep );
local label = guiCreateElement( 6, "14, MG42 <UNAVAILABLE>", 20.0, 360.0, 500.0, 25.0, false, window_wep );
local label = guiCreateElement( 6, "15, M1 Garand", 20.0, 380.0, 500.0, 25.0, false, window_wep );
local label = guiCreateElement( 6, "17, Kar98k", 20.0, 400.0, 500.0, 25.0, false, window_wep );
local label = guiCreateElement( 6, "21, Molotov Cocktail", 20.0, 420.0, 500.0, 25.0, false, window_wep );

// WARP CONTROL WINDOW
local box_war = guiCreateElement( ELEMENT_TYPE_EDIT, "Amount", 120.0, 20.0, 100.0, 35.0, false, window_war );
local complete_warx = guiCreateElement( 2, "Warp X", 20.0, 70.0, 100.0, 35.0, false, window_war );
local complete_wary = guiCreateElement( 2, "Warp Y", 120.0, 70.0, 100.0, 35.0, false, window_war );
local complete_warz = guiCreateElement( 2, "Warp Z", 220.0, 70.0, 100.0, 35.0, false, window_war );
local back_war = guiCreateElement( 2, "Back", 20.0, 300.0, 100.0, 35.0, false, window_war );

local label = guiCreateElement( 6, "Note: You can also use neural amounts.", 20.0, 100.0, 500.0, 25.0, false, window_war );
local label = guiCreateElement( 6, "Note: Maximum: 10 000, Minimum: -10 000", 20.0, 115.0, 500.0, 25.0, false, window_war );

// DEFAULT WINDOW VISIBILITY SETTINGS
guiSetVisible( window, false );
guiSetVisible( window_veh, false );
guiSetVisible( window_gen, false );
guiSetVisible( window_wep, false );
guiSetVisible( window_war, false );

// BINDING FUNCTION SETTINGS
bindKey( "h", "down",
function()
{
    if( !guiIsVisible( window ))
    {
        guiSetVisible( window, true );
        guiSetVisible( window_war, false );
        showChat( false );
        showCursor( !isCursorShowing() );
    }
    else if( guiIsVisible( window ) )
    {
        guiSetVisible( window, false );
        guiSetVisible( window_veh, false );
        guiSetVisible( window_gen, false );
        guiSetVisible( window_wep, false );
        showChat( true );
        showCursor( false );
    }
}
);
// BUTTON SETTINGS
addEventHandler( "onGuiElementClick",
function(element)
{
    if(element == open_window_veh)
    {
        if( !guiIsVisible( window_veh ) )
        {
            guiSetVisible( window_veh, true );
            guiSetVisible( window, false );
        }
        else if ( guiIsVisible( window_veh ) )
        {
            guiSetVisible( window_veh, false );
        }
        if( guiIsVisible( window_gen ) || guiIsVisible( window_wep ) || guiIsVisible( window_war ) )
        {
            guiSetVisible( window_gen, false );
            guiSetVisible( window_wep, false );
            guiSetVisible( window_war, false );
            guiSetVisible( window, false );
        }
    }
    if(element == open_window_wep)
    {
        if( !guiIsVisible( window_wep ) )
        {
            guiSetVisible( window_wep, true );
            guiSetVisible( window, false );
        }
        else if ( guiIsVisible( window_wep ) )
        {
            guiSetVisible( window_wep, false );
        }
        if( guiIsVisible( window_gen ) || guiIsVisible( window_veh ) || guiIsVisible( window_war ))
        {
            guiSetVisible( window_gen, false );
            guiSetVisible( window_veh, false );
            guiSetVisible( window_war, false );
            guiSetVisible( window, false );
        }
    }
    if(element == open_window_gen)
    {
        if( !guiIsVisible( window_gen ) )
        {
            guiSetVisible( window_gen, true );  
            guiSetVisible( window, false );
        }
        else if ( guiIsVisible( window_gen ) )
        {
            guiSetVisible( window_gen, false );
        }
        if( guiIsVisible( window_veh ) || guiIsVisible( window_wep ) || guiIsVisible( window_war ))
        {
            guiSetVisible( window_veh, false );
            guiSetVisible( window_wep, false );
            guiSetVisible( window_war, false );
            guiSetVisible( window, false );
        }
    }        
    if(element == open_window_war)
    {
        if( !guiIsVisible( window_war ) )
        {
            guiSetVisible( window_war, true );  
            guiSetVisible( window, false );
        }
        else if ( guiIsVisible( window_war ) )
        {
            guiSetVisible( window_war, false );
        }
        if( guiIsVisible( window_veh ) || guiIsVisible( window_wep ) || guiIsVisible( window_gen ) || guiIsVisible( window ))
        {
            guiSetVisible( window_veh, false );
            guiSetVisible( window_wep, false );
            guiSetVisible( window_gen, false );
            guiSetVisible( window, false );
            showChat( true );
        }
    }
    if(element == back_veh) 
    {
        guiSetVisible( window_veh, false );
        guiSetVisible( window, true );
    }
    if(element == back_gen) 
    {
        guiSetVisible( window_gen, false );
        guiSetVisible( window, true );
    }
    if(element == back_wep) 
    {
        guiSetVisible( window_wep, false );
        guiSetVisible( window, true );
    }
    if(element == back_war) 
    {
        guiSetVisible( window_war, false );
        guiSetVisible( window, true );
    }
    if(element == complete_veh) 
    {
        local text = guiGetText(box_veh);
        triggerServerEvent("gui_veh_spa", text); 
    }
    if(element == complete_pla) 
    {
        local text = guiGetText(box_pla);
        triggerServerEvent("gui_veh_pla", text); 
    }
    if(element == complete_tir) 
    {
        local text = guiGetText(box_tir);
        triggerServerEvent("gui_veh_tir", text); 
    }
    if(element == complete_dir) 
    {
        triggerServerEvent("gui_veh_dir"); 
    }
    if(element == complete_tun) 
    {
        triggerServerEvent("gui_veh_tun"); 
    }
    if(element == complete_rep) 
    {
        triggerServerEvent("gui_veh_rep"); 
    }
    if(element == complete_wep) 
    {
        local text = guiGetText(box_wep);
        triggerServerEvent("gui_wep_spa", text); 
    }
    if(element == complete_rel) 
    {
        triggerServerEvent("gui_wep_rel"); 
    }
    if(element == complete_mod) 
    {
        local text = guiGetText(box_mod);
        triggerServerEvent("gui_gen_mod", text); 
    }
    if(element == complete_pid) 
    {
        local text = guiGetText(box_pid);
        triggerServerEvent("gui_gen_pid", text); 
    }
    if(element == complete_loc) 
    {
        local text = guiGetText(box_loc);
        triggerServerEvent("gui_gen_loc", text); 
    }
    if(element == complete_wea) 
    {
        local text = guiGetText(box_wea);
        triggerServerEvent("gui_gen_wea", text); 
    }
    if(element == complete_ran) 
    {
        triggerServerEvent("gui_gen_ran"); 
    }
    if(element == complete_unl) 
    {
        triggerServerEvent("gui_gen_unl"); 
    }
    if(element == complete_warx) 
    {
        local text = guiGetText(box_war);
        triggerServerEvent("gui_war_x", text);  
    }
    if(element == complete_wary) 
    {
        local text = guiGetText(box_war);
        triggerServerEvent("gui_war_y", text); 
    }
    if(element == complete_warz) 
    {
        local text = guiGetText(box_war);
        triggerServerEvent("gui_war_z", text); 
    }
}
);

// NOTE: THESE ARE FOR BRIX TUTORIAL FUNCTION. SERVERSIDE FUNCTION CALLED "callEvent" DOES NOT WORK, SO WE HAVE TO TRIGGER CLIENTSIDE EVENT, THAT TRIGGERS SERVER SIDE EVENT. BIT WICKED METHOD BUT IT'S WORKING!
addEventHandler( "start_tutorial",
function()
{
    triggerServerEvent( "brix_tutorial" );
}
);

addEventHandler( "open_gui",
function()
{
    guiSetVisible( window, true );
}
);

addEventHandler( "close_gui",
function()
{
    guiSetVisible( window, false );
}
);

addEventHandler( "end_tutorial_client",
function()
{
    triggerServerEvent( "end_tutorial" );
}
);

// NOTE: THESE ARE FOR COUNTDOWN COMMAND
addEventHandler( "countDown", 
function(sec)
{
    cdText = sec.tostring();
}
);

addEventHandler( "onClientFrameRender",
function( post )
{
    if( post )
    {
        local screen = getScreenSize( );
        dxDrawText( cdText.tostring(), screen[0] / 2, screen[1] / 2 - 200.0, 0xFFFF3333, true, "arial", 4.0);   
    }
}
);

// NOTE: THESE ARE FOR CHAT COMMAND
addEventHandler( "chat_hide",
function()
{
    showChat( false );
}
);

addEventHandler( "chat_show",
function()
{
    showChat( true );
}
);

// NOTE: THESE ARE FOR FIXING MOUSE FUNCTION
addEventHandler( "mousefix",
function()
{
    if(showCursor(true))
    {
        showCursor( false );
    } 
}
);
