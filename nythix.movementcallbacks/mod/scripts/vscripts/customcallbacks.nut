//=========================================================
//  Custom Callback System
//=========================================================

global function customcallbacks_Init

global function AddCallback_OnJump
global function AddCallback_OnCrouch
global function AddCallback_OnWallrunStart
global function AddCallback_OnWallrunStop


//---------------------------------------------------------
// storage
//---------------------------------------------------------

struct
{
    array<void functionref()> onJumpCallbacks
    array<void functionref()> onCrouchCallbacks
    array<void functionref()> onWallrunStartCallbacks
    array<void functionref()> onWallrunStopCallbacks
} file


//---------------------------------------------------------
// vars
//---------------------------------------------------------

bool wasWallRunning = false


//---------------------------------------------------------
// INIT
//---------------------------------------------------------

void function customcallbacks_Init()
{
    registerCallbacks()
    thread WallrunWatcher()
}


//---------------------------------------------------------
// KEY REGISTRATION
//---------------------------------------------------------

void function registerCallbacks()
{
    printt("Registering custom callbacks...")

    for ( int key = 0; key < 132; key++ )
    {
        string bind = GetKeyBinding( key )

        if ( bind == "+ability 3" ) //ability 3 is jump||dash
        {
            RegisterButtonPressedCallback( key, Internal_OnJump )
            printt("Registered key " + key + " as jump bind") //DEBUG
        }
        else if ( bind == "+duck" )
        {
            RegisterButtonPressedCallback( key, Internal_OnCrouch )
            printt("Registered key " + key + " as crouch bind") //DEBUG
        }
    }
}


//---------------------------------------------------------
// CALLBACK REGISTRATION FUNCTIONS
//---------------------------------------------------------

void function AddCallback_OnJump( void functionref() callback )
{
    Assert( !file.onJumpCallbacks.contains( callback ), "Already added " + string( callback ) )
    file.onJumpCallbacks.append( callback )
}


void function AddCallback_OnCrouch( void functionref() callback )
{
    Assert( !file.onCrouchCallbacks.contains( callback ), "Already added " + string( callback ) )
    file.onCrouchCallbacks.append( callback )
}


void function AddCallback_OnWallrunStart( void functionref() callback )
{
    Assert( !file.onWallrunStartCallbacks.contains( callback ), "Already added " + string( callback ) )
    file.onWallrunStartCallbacks.append( callback )
}


void function AddCallback_OnWallrunStop( void functionref() callback )
{
    Assert( !file.onWallrunStopCallbacks.contains( callback ), "Already added " + string( callback ) )
    file.onWallrunStopCallbacks.append( callback )
}


//---------------------------------------------------------
// CALLBACK DEREGISTRATION FUNCTIONS
//---------------------------------------------------------

void function RemoveCallback_OnJump( void functionref() callback )
{
    if ( file.onJumpCallbacks.contains( callback ) )
    {
        file.onJumpCallbacks.removebyvalue( callback )
    }
    else
    {
        printt( "Tried to remove non-existent OnJump callback: " + string( callback ) )
    }
}


void function RemoveCallback_OnCrouch( void functionref() callback )
{
    if ( file.onCrouchCallbacks.contains( callback ) )
    {
        file.onCrouchCallbacks.removebyvalue( callback )
    }
    else
    {
        printt( "Tried to remove non-existent OnCrouch callback: " + string( callback ) )
    }
}


void function RemoveCallback_OnWallrunStart( void functionref() callback )
{
    if ( file.onWallrunStartCallbacks.contains( callback ) )
    {
        file.onWallrunStartCallbacks.removebyvalue( callback )
    }
    else
    {
        printt( "Tried to remove non-existent OnWallrunStart callback: " + string( callback ) )
    }
}


void function RemoveCallback_OnWallrunStop( void functionref() callback )
{
    if ( file.onWallrunStopCallbacks.contains( callback ) )
    {
        file.onWallrunStopCallbacks.removebyvalue( callback )
    }
    else
    {
        printt( "Tried to remove non-existent OnWallrunStop callback: " + string( callback ) )
    }
}


//---------------------------------------------------------
// INTERNAL INPUT CALLBACKS
//---------------------------------------------------------


void function Internal_OnJump(var button)
{
    foreach ( callback in file.onJumpCallbacks )
        callback()
}


void function Internal_OnCrouch(var button)
{
    foreach ( callback in file.onCrouchCallbacks )
        callback()
}


//---------------------------------------------------------
// WALLRUN WATCHER
//---------------------------------------------------------
void function WallrunWatcher()
{
    while ( true )
    {
        entity player = GetLocalClientPlayer()

        if ( player == null )
        {
            WaitFrame()
            continue
        }

        bool isWallRunning = player.IsWallRunning()

        if ( isWallRunning && !wasWallRunning )
        {
            printt("customcallbacks-debug: Start WR callback")
            foreach ( callback in file.onWallrunStartCallbacks )
                callback()
        }
        else if ( !isWallRunning && wasWallRunning )
        {
            foreach ( callback in file.onWallrunStopCallbacks )
                callback()
        }

        wasWallRunning = isWallRunning

        WaitFrame()
    }
}


//---------------------------------------------------------
// UTILITY
//---------------------------------------------------------
