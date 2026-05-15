global function movementhelper_Init

float lastSpaceTime  = -1.0
float lastAltTime    = -1.0
const float INPUT_WINDOW   = 0.2
const float SUCCESS_WINDOW = 0.008
int   frameRate        = 0
int   wallrunFrameTime = -1
float speedDiff        = 0.0
float WRspeed = 0.0

void function movementhelper_Init()
{
    #if HAS_uCKF
    #else
    #endif

    AddCallback_OnJump( OnJump )
    AddCallback_OnCrouch( OnCrouch )
    AddCallback_OnWallrunStart( OnWallrunStart )

    thread measureFrame()
    thread HudUpdateLoop()
}

//---------------------------------------------------------
// HUD UPDATE
//---------------------------------------------------------
void function HudUpdateLoop()
{
    entity player    = GetLocalClientPlayer()
    bool wasGrounded = false
    bool couldLurch  = false

    while ( true )
    {
        if ( player != null )
        {
            bool grounded = player.IsOnGround()
            bool canLurch = ( Time() - 0.4 ) < lastSpaceTime

            if ( grounded != wasGrounded )
            {
                RuiPrintInfo( "grounded", grounded )
                wasGrounded = grounded
            }

            if ( canLurch != couldLurch )
            {
                RuiPrintInfo( "canlurch", canLurch )
                couldLurch = canLurch
            }
        }
        else
        {
            player = GetLocalClientPlayer()
        }

        WaitFrame()
    }
}

//---------------------------------------------------------
// WALLJUMP-TECH
//---------------------------------------------------------
void function OnJump()
{
    lastSpaceTime = Time()
    CheckInputTiming()
}

void function OnCrouch()
{
    lastAltTime = Time()
    CheckInputTiming()
}

void function CheckInputTiming()
{
    if ( wallrunFrameTime == -1 )
        return

    float delta = fabs( lastSpaceTime - lastAltTime )

    if ( delta <= SUCCESS_WINDOW )
    {
        if ( wallrunFrameTime < 6 )
            RuiPrintTech( "CK",   "Walltime", wallrunFrameTime, GetPlayerVelocityAsFloat() - WRspeed )
        else if ( wallrunFrameTime < 15)
            RuiPrintTech( "cFEB", "Waltime", wallrunFrameTime, GetPlayerVelocityAsFloat() - WRspeed )
        else
            RuiPrintTech( "cFEB", "0", -1, GetPlayerVelocityAsFloat() - WRspeed )
    }
    else if ( wallrunFrameTime < 6 )
    {
        RuiPrintTech( "WK", "Walltime", wallrunFrameTime, GetPlayerVelocityAsFloat() - WRspeed )
    }
}

void function OnWallrunStart()
{
    entity player    = GetLocalClientPlayer()
    wallrunFrameTime = 0
    WRspeed = GetPlayerVelocityAsFloat()
    thread TrackWallrunFrames( player )
}

void function TrackWallrunFrames( entity player )
{
    while ( player.IsWallRunning() )
    {
        wallrunFrameTime++
        WaitFrame()
    }
    wallrunFrameTime = -1
}

//---------------------------------------------------------
// UTILITY
//---------------------------------------------------------
void function measureFrame()
{
    while ( true )
    {
        if ( FrameTime() > 0.0 )
            frameRate = int( 1.0 / FrameTime() )
        WaitFrame()
    }
}