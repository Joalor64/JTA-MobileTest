package jta.util;

/**
 * Utility class for handling framerate-related operations.
 */
@:access(Main)
class FramerateUtil
{
	/**
	 * The timing of a single frame.
	 */
	public static final SINGLE_FRAME_TIMING:Float = 1.0 / Main.GAME_FRAMERATE;

	/**
	 * Adjusts the stage framerate to match the display's refresh rate.
	 * If the refresh rate is below 60 Hz, the framerate is set to 60 FPS.
	 * This adjustment does not influence Flixel's `FlxGame` framerate.
	 */
	public static function adjustStageFramerate():Void
	{
		var refreshRate:Int = Lib.application.window.displayMode.refreshRate;

		if (refreshRate < 60)
			refreshRate = 60;

		#if mobile
		// The game itself only updates 60 times a second, so on 90/120 Hz phones
		// rendering faster just draws the same frame twice: extra heat and battery
		// drain for no visible gain. Cap the stage at the game's framerate.
		if (refreshRate > Main.GAME_FRAMERATE)
			refreshRate = Main.GAME_FRAMERATE;
		#end

		if (FlxG.stage.frameRate != refreshRate)
			FlxG.stage.frameRate = refreshRate;
	}
}
