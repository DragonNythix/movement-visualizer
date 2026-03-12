//=========================================================
//  Custom Callback System
//=========================================================

global function customcallbacks_Init

global function AddCallback_OnForwardInput
global function AddCallback_OnBackInput
global function AddCallback_OnLeftInput
global function AddCallback_OnRightInput
global function AddCallback_OnJumpInput
global function AddCallback_OnJump
global function AddCallback_OnCrouchInput
global function AddCallback_OnCrouch 
global function AddCallback_OnSlide 
global function AddCallback_OnWallrunStart
global function AddCallback_OnWallrunStop


//---------------------------------------------------------
// storage
//---------------------------------------------------------

struct
{
    array<void functionref()> onForwardInputCallbacks
    array<void functionref()> onBackInputCallbacks
    array<void functionref()> onLeftInputCallbacks
    array<void functionref()> onRightInputCallbacks
    array<void functionref()> onJumpInputCallbacks
    array<void functionref()> onJumpCallbacks
    array<void functionref()> onCrouchInputCallbacks
    array<void functionref()> onCrouchCallbacks
    array<void functionref()> onSlideCallbacks
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

// Only works
void function registerCallbacks()
{
    printt("Registering custom callbacks...")

    for ( int key = 0; key < 132; key++ )
    {
        string bind = GetKeyBinding( key )
        if (bind == "+forward")
        {
            RegisterButtonPressedCallback( key, Internal_OnForwardInput )
            printt("Registered key " + key + " as Forward bind") //DEBUG
        }
        else if (bind == "+back")
        {
            RegisterButtonPressedCallback( key, Internal_OnBackInput )
            printt("Registered key " + key + " as Back bind") //DEBUG
        }
        else if (bind == "+left")
        {
            RegisterButtonPressedCallback( key, Internal_OnLeftInput )
            printt("Registered key " + key + " as Left bind") //DEBUG
        }
        else if (bind == "+right")
        {
            RegisterButtonPressedCallback( key, Internal_OnRightInput )
            printt("Registered key " + key + " as Right bind") //DEBUG
        }
        else if ( bind == "+ability 3" ) // ability 3 is jump||dash (refered to as #JUMP_PILOT_DASH_TITAN)
        {
            RegisterButtonPressedCallback( key, Internal_OnJumpInput )
            RegisterButtonPressedCallback( key, Internal_OnJump )
            printt("Registered key " + key + " as jump bind") //DEBUG
        }
        else if ( bind == "+jump" ) // there really isn't a reason why we should do this, +jump should never be bound and can't be without commands, but idk
        {
            RegisterButtonPressedCallback( key, Internal_OnJumpInput )
            RegisterButtonPressedCallback( key, Internal_OnJump )
            printt("Registered key " + key + " as jump bind") //DEBUG
        }
        else if ( bind == "+duck" )
        {
            RegisterButtonPressedCallback( key, Internal_OnCrouchInput )
            RegisterButtonPressedCallback( key, Internal_OnCrouch )
            RegisterButtonPressedCallback( key, Internal_OnSlide )
            printt("Registered key " + key + " as crouch bind") //DEBUG
        }
        else if ( bind == "+toggle_duck" )
        {
            RegisterButtonPressedCallback( key, Internal_OnCrouchInput )
            RegisterButtonPressedCallback( key, Internal_OnCrouch )
            RegisterButtonPressedCallback( key, Internal_OnSlide )
            printt("Registered key " + key + " as crouch bind") //DEBUG
        }
    }
}


//---------------------------------------------------------
// CALLBACK REGISTRATION FUNCTIONS
//---------------------------------------------------------

void function AddCallback_OnForwardInput( void functionref() callback )
{
    Assert( !file.onForwardInputCallbacks.contains( callback ), "Already added " + string( callback ) )
    file.onForwardInputCallbacks.append( callback )
}

void function AddCallback_OnBackInput( void functionref() callback )
{
    Assert( !file.onBackInputCallbacks.contains( callback ), "Already added " + string( callback ) )
    file.onBackInputCallbacks.append( callback )
}

void function AddCallback_OnLeftInput( void functionref() callback )
{
    Assert( !file.onLeftInputCallbacks.contains( callback ), "Already added " + string( callback ) )
    file.onLeftInputCallbacks.append( callback )
}

void function AddCallback_OnRightInput( void functionref() callback )
{
    Assert( !file.onRightInputCallbacks.contains( callback ), "Already added " + string( callback ) )
    file.onRightInputCallbacks.append( callback )
}

void function AddCallback_OnJumpInput( void functionref() callback )
{
    Assert( !file.onJumpInputCallbacks.contains( callback ), "Already added " + string( callback ) )
    file.onJumpInputCallbacks.append( callback )
}

void function AddCallback_OnJump( void functionref() callback )
{
    Assert( !file.onJumpCallbacks.contains( callback ), "Already added " + string( callback ) )
    file.onJumpCallbacks.append( callback )
}

void function AddCallback_OnCrouchInput( void functionref() callback )
{
    Assert( !file.onCrouchInputCallbacks.contains( callback ), "Already added " + string( callback ) )
    file.onCrouchInputCallbacks.append( callback )
}

void function AddCallback_OnCrouch( void functionref() callback )
{
    Assert( !file.onCrouchCallbacks.contains( callback ), "Already added " + string( callback ) )
    file.onCrouchCallbacks.append( callback )
}

void function AddCallback_OnSlide( void functionref() callback )
{
    Assert( !file.onSlideCallbacks.contains( callback ), "Already added " + string( callback ) )
    file.onSlideCallbacks.append( callback )
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

void function RemoveCallback_OnForwardInput( void functionref() callback )
{
    if ( file.onForwardInputCallbacks.contains( callback ) )
    {
        file.onForwardInputCallbacks.removebyvalue( callback )
    }
    else
    {
        printt( "Tried to remove non-existent OnForwardInput callback: " + string( callback ) )
    }
}

void function RemoveCallback_OnBackInput( void functionref() callback )
{
    if ( file.onBackInputCallbacks.contains( callback ) )
    {
        file.onBackInputCallbacks.removebyvalue( callback )
    }
    else
    {
        printt( "Tried to remove non-existent OnBackInput callback: " + string( callback ) )
    }
}

void function RemoveCallback_OnLeftInput( void functionref() callback )
{
    if ( file.onLeftInputCallbacks.contains( callback ) )
    {
        file.onLeftInputCallbacks.removebyvalue( callback )
    }
    else
    {
        printt( "Tried to remove non-existent OnLeftInput callback: " + string( callback ) )
    }
}

void function RemoveCallback_OnRightInput( void functionref() callback )
{
    if ( file.onRightInputCallbacks.contains( callback ) )
    {
        file.onRightInputCallbacks.removebyvalue( callback )
    }
    else
    {
        printt( "Tried to remove non-existent OnRightInput callback: " + string( callback ) )
    }
}

void function RemoveCallback_OnJumpInput( void functionref() callback )
{
    if ( file.onJumpInputCallbacks.contains( callback ) )
    {
        file.onJumpInputCallbacks.removebyvalue( callback )
    }
    else
    {
        printt( "Tried to remove non-existent OnJumpInput callback: " + string( callback ) )
    }
}

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

void function RemoveCallback_OnCrouchInput( void functionref() callback )
{
    if ( file.onCrouchInputCallbacks.contains( callback ) )
    {
        file.onCrouchInputCallbacks.removebyvalue( callback )
    }
    else
    {
        printt( "Tried to remove non-existent OnCrouchInput callback: " + string( callback ) )
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

void function RemoveCallback_OnSlide( void functionref() callback )
{
    if ( file.onSlideCallbacks.contains( callback ) )
    {
        file.onSlideCallbacks.removebyvalue( callback )
    }
    else
    {
        printt( "Tried to remove non-existent OnSlide callback: " + string( callback ) )
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

void function Internal_OnForwardInput( var button )
{
    foreach ( callback in file.onForwardInputCallbacks )
        callback()
}

void function Internal_OnBackInput( var button )
{
    foreach ( callback in file.onBackInputCallbacks )
        callback()
}

void function Internal_OnLeftInput( var button )
{
    foreach ( callback in file.onLeftInputCallbacks )
        callback()
}

void function Internal_OnRightInput( var button )
{
    foreach ( callback in file.onRightInputCallbacks )
        callback()
}

void function Internal_OnJumpInput( var button )
{
    foreach ( callback in file.onJumpInputCallbacks )
        callback()
}

void function Internal_OnJump( var button ) // it is planned to also add input less detection that is togglable with settings/convars but thats low prio
{
    if ( GetLocalClientPlayer().IsOnGround() )
        return
    foreach ( callback in file.onJumpCallbacks )
        callback()
}

void function Internal_OnCrouchInput( var button )
{
    foreach ( callback in file.onCrouchInputCallbacks )
        callback()
}

void function Internal_OnCrouch( var button )
{   
    if( GetLocalClientPlayer().IsCrouched() )
        return
    foreach ( callback in file.onCrouchCallbacks )
        callback()
}

void function Internal_OnSlide( var button )
{   
    entity player = GetLocalClientPlayer()

    if ( !player.IsOnGround() && player.IsWallRunning() && ( GetPlayerVelocityAsFloat() < 16 ) )
        return
    
    foreach ( callback in file.onCrouchInputCallbacks )
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

float function GetPlayerVelocityAsFloat(){
    //code shamelessly stolen from S2.speedometer (https://thunderstore.io/c/northstar/p/S2Mods/SpeedometerV2/)
    entity player = GetLocalClientPlayer()
    vector playerVelV = player.GetVelocity()
    float playerVel
    playerVel = sqrt(playerVelV.x * playerVelV.x + playerVelV.y * playerVelV.y)
    return playerVel
}