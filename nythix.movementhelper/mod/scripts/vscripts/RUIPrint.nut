global function RuiPrint

struct {
    array<var> ruis = []
    vector origin = <0.06, 0.39, 0.0>
    float spacing = 0.04
} ruiPrinter


void function RuiPrint( string text, int line = 0, float size = 30.0, vector color = <1,1,1> )
{
    while( ruiPrinter.ruis.len() <= line )
        ruiPrinter.ruis.append( null )

    if( ruiPrinter.ruis[line] == null )
    {
        var rui = RuiCreate( $"ui/cockpit_console_text_top_right.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0 )

        RuiSetFloat( rui, "msgFontSize", size )
        RuiSetFloat( rui, "msgAlpha", 1.0 )
        RuiSetFloat( rui, "thicken", 0.0 )
        RuiSetFloat3( rui, "msgColor", color )

        vector pos = < ruiPrinter.origin.x+0.9, ruiPrinter.origin.y + (ruiPrinter.spacing * line), 0 >
        RuiSetFloat2( rui, "msgPos", pos )

        ruiPrinter.ruis[line] = rui
    }

    RuiSetString( ruiPrinter.ruis[line], "msgText", text )

    // destroy after 0.5 seconds
    thread DestroyRuiAfterDelay( line, 0.5 )
}


void function DestroyRuiAfterDelay( int line, float delay )
{
    wait delay

    if( line < ruiPrinter.ruis.len() && ruiPrinter.ruis[line] != null )
    {
        RuiDestroy( ruiPrinter.ruis[line] )
        ruiPrinter.ruis[line] = null
    }
}