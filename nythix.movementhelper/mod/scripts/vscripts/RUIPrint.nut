untyped 
global function RuiPrint_Init
global function RuiPrintTech
global function RuiPrintInfo

//---------------------------------------------------------
// storage
//---------------------------------------------------------

var TouchingSurfaceRUI
var CanLurchRUI

//---------------------------------------------------------
// INIT
//---------------------------------------------------------

void function RuiPrint_Init()
{
    createRuis()

}

void function readConVars()
{
    //wont be used for ahile, but the ruis should be configurable
    return
}

void function createRuis()
{
    TouchingSurfaceRUI = RuiCreate( $"ui/cockpit_console_text_top_right.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0 )
    RuiSetFloat( TouchingSurfaceRUI, "msgFontSize", 20.0 )
    RuiSetFloat( TouchingSurfaceRUI, "msgAlpha", 1.0 )
    RuiSetFloat( TouchingSurfaceRUI, "thicken", 0.0 )
    RuiSetFloat2( TouchingSurfaceRUI, "msgPos", <0.43, 0.97, 0> )
    RuiSetFloat3( TouchingSurfaceRUI, "msgColor", <0.2, 0.2, 0.6> )
    RuiSetString( TouchingSurfaceRUI, "msgText", "Grounded" )

    CanLurchRUI = RuiCreate( $"ui/cockpit_console_text_top_right.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0 )
    RuiSetFloat( CanLurchRUI, "msgFontSize", 20.0 )
    RuiSetFloat( CanLurchRUI, "msgAlpha", 1.0 )
    RuiSetFloat( CanLurchRUI, "thicken", 0.0 )
    RuiSetFloat2( CanLurchRUI, "msgPos", <0.58, 0.97, 0> )
    RuiSetFloat3( CanLurchRUI, "msgColor", <0.2, 0.2, 0.6> )
    RuiSetString( CanLurchRUI, "msgText", "Lurch" )
}


//---------------------------------------------------------
// UPDATE
//---------------------------------------------------------

void function RuiPrintTech( string name, string info, int infoval, float speed )
{

}

void function RuiPrintInfo( string name, bool show )
{
    //update the status thingy on the bottom of the screen
    if( name == "lurch" )
    {
        RuiSetString( CanLurchRUI, "msgText", show ? "Lurch" : "" )
    }
    else if( name == "grounded" )
    {
        RuiSetString( TouchingSurfaceRUI, "msgText", show ? "Grounded" : "" )
    }
}


//---------------------------------------------------------
// UTILITY
//---------------------------------------------------------


