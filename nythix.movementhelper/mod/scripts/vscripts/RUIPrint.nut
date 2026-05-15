untyped
global function RuiPrint_Init
global function RuiPrintTech
global function RuiPrintInfo

//---------------------------------------------------------
// storage
//---------------------------------------------------------
var TouchingSurfaceRUI
var CanLurchRUI
var TechNameRUI
var TechInfoRUI
var TechSpeedRUI

//---------------------------------------------------------
// INIT
//---------------------------------------------------------
void function RuiPrint_Init()
{
    createRuis()
}

void function createRuis()
{
    TouchingSurfaceRUI = RuiCreate( $"ui/cockpit_console_text_top_right.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0 )
    RuiSetFloat( TouchingSurfaceRUI,  "msgFontSize", 20.0 )
    RuiSetFloat( TouchingSurfaceRUI,  "msgAlpha",    1.0 )
    RuiSetFloat( TouchingSurfaceRUI,  "thicken",     0.0 )
    RuiSetFloat2( TouchingSurfaceRUI, "msgPos",      <0.43, 0.97, 0> )
    RuiSetFloat3( TouchingSurfaceRUI, "msgColor",    <0.2, 0.2, 0.6> )
    RuiSetString( TouchingSurfaceRUI, "msgText",     "" )

    CanLurchRUI = RuiCreate( $"ui/cockpit_console_text_top_right.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0 )
    RuiSetFloat( CanLurchRUI,  "msgFontSize", 20.0 )
    RuiSetFloat( CanLurchRUI,  "msgAlpha",    1.0 )
    RuiSetFloat( CanLurchRUI,  "thicken",     0.0 )
    RuiSetFloat2( CanLurchRUI, "msgPos",      <0.58, 0.97, 0> )
    RuiSetFloat3( CanLurchRUI, "msgColor",    <0.2, 0.2, 0.6> )
    RuiSetString( CanLurchRUI, "msgText",     "" )

    TechNameRUI = RuiCreate( $"ui/cockpit_console_text_top_right.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0 )
    RuiSetFloat( TechNameRUI,  "msgFontSize", 40.0 )
    RuiSetFloat( TechNameRUI,  "msgAlpha",    1.0 )
    RuiSetFloat( TechNameRUI,  "thicken",     0.0 )
    RuiSetFloat2( TechNameRUI, "msgPos",      <0.95, 0.45, 0> )
    RuiSetFloat3( TechNameRUI, "msgColor",    <0.2, 0.2, 0.6> )
    RuiSetString( TechNameRUI, "msgText",     "" )

    TechInfoRUI = RuiCreate( $"ui/cockpit_console_text_top_right.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0 )
    RuiSetFloat( TechInfoRUI,  "msgFontSize", 30.0 )
    RuiSetFloat( TechInfoRUI,  "msgAlpha",    1.0 )
    RuiSetFloat( TechInfoRUI,  "thicken",     0.0 )
    RuiSetFloat2( TechInfoRUI, "msgPos",      <0.95, 0.5, 0> )
    RuiSetFloat3( TechInfoRUI, "msgColor",    <0.3, 0.2, 0.6> )
    RuiSetString( TechInfoRUI, "msgText",     "" )

    TechSpeedRUI = RuiCreate( $"ui/cockpit_console_text_top_right.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0 )
    RuiSetFloat( TechSpeedRUI,  "msgFontSize", 29.0 )
    RuiSetFloat( TechSpeedRUI,  "msgAlpha",    1.0 )
    RuiSetFloat( TechSpeedRUI,  "thicken",     0.0 )
    RuiSetFloat2( TechSpeedRUI, "msgPos",      <0.95, 0.52, 0> )
    RuiSetFloat3( TechSpeedRUI, "msgColor",    <0.3, 0.2, 0.6> )
    RuiSetString( TechSpeedRUI, "msgText",     "" )
}

//---------------------------------------------------------
// UPDATE
//---------------------------------------------------------
void function RuiPrintTech( string name, string info, int infoval, float speed )
{
    string infoText = info

    if ( infoval != -1 )
        infoText += ": " + string( infoval )

    RuiSetString( TechNameRUI, "msgText", name )
    RuiSetString( TechInfoRUI, "msgText", infoText )
    RuiSetString( TechSpeedRUI, "msgText", string(speed* (0.091392)))

    thread ClearTechRuiAfterDelay( 2.5 )
}

void function RuiPrintInfo( string name, bool show )
{
    if ( name == "canlurch" )
        RuiSetString( CanLurchRUI,        "msgText", show ? "Lurch"    : "" )
    else if ( name == "grounded" )
        RuiSetString( TouchingSurfaceRUI, "msgText", show ? "Grounded" : "" )
}

//---------------------------------------------------------
// UTIL
//---------------------------------------------------------

void function ClearTechRuiAfterDelay( float delay )
{
    float clearTime = Time() + delay
    Wait( delay )
    if ( Time() >= clearTime )
    {
        RuiSetString( TechNameRUI, "msgText", "" )
        RuiSetString( TechInfoRUI, "msgText", "" )
        RuiSetString( TechSpeedRUI, "msgText", "" )
    }
}