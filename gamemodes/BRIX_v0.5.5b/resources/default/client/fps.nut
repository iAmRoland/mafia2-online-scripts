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

local cx = "120.0";
local cy = "20.0";
local screen = getScreenSize( );

local picture = guiCreateElement(13,"logo.png", screen[0] - 250.0, 20.0, 205.0, 75.0);
guiSetVisible( picture, true );

addEventHandler( "onClientFrameRender", 
function( post )
{
    if( post )
    dxDrawText( "FPS: " + getFPS() + ", Ping: " + getPlayerPing(getLocalPlayer()).tostring() + ", pID: " + getLocalPlayer(), 7.0, 5.0, 0xFFFFFFFF, true, "tahoma-bold" );
}
);

