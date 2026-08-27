package jta.mobile;

import flixel.FlxCamera;
import flixel.group.FlxGroup.FlxTypedGroup;
import jta.mobile.VirtualButton;

/**
 * Handles virtual touchscreen controls.
 */
class MobileInput extends FlxTypedGroup<VirtualButton>
{
	/**
	 * Currently active mobile input manager.
	 *
	 * Input.hx uses this to query touchscreen controls without requiring
	 * every gameplay class to know about MobileInput.
	 */
	public static var active:Null<MobileInput>;

	/**
	 * The previously active manager.
	 *
	 * This is useful for substates such as PauseMenu. When the substate
	 * disappears, the previous manager can become active again.
	 */
	private var previous:Null<MobileInput>;

	/**
	 * Default distance from the edges of the screen.
	 */
	public static var margin:Float = 32;

	/**
	 * Creates a mobile input manager.
	 */
	public function new(?camera:FlxCamera):Void
	{
		super();

		previous = active;
		active = this;

		if (camera != null)
			cameras = [camera];
	}

	/**
	 * Adds a virtual button to this control layout.
	 */
	public function addButton(x:Float, y:Float, action:String, ?type:String = 'default', ?imageName:String = null):VirtualButton
	{
		var button = new VirtualButton(x, y, action, type, imageName);
		add(button);

		return button;
	}

	/**
	 * Removes all currently displayed buttons.
	 */
	public function clearButtons():Void
	{
		clear();
	}

	/**
	 * Enables or disables every button.
	 */
	public function setEnabled(value:Bool):Void
	{
		forEach(function(button:VirtualButton):Void
		{
			if (button != null)
				button.enabled = value;
		});
	}

	/**
	 * Shows the standard gameplay layout.
	 */
	public function setupGameplay():Void
	{
		clearButtons();

		addButton(margin, FlxG.height - margin - 64, 'left', 'navigation');
		addButton(margin + 76, FlxG.height - margin - 64, 'right', 'navigation');

		addButton(FlxG.width - margin - 140, FlxG.height - margin - 64, 'run');
		addButton(FlxG.width - margin - 64, FlxG.height - margin - 140, 'jump');

		addButton(FlxG.width - margin - 48, margin, 'pause', 'util');
	}

	/**
	 * Sets up a normal vertical menu layout.
	 */
	public function setupMenuVertical():Void
	{
		clearButtons();

		addButton(margin, FlxG.height - margin - 140, 'up', 'navigation');
		addButton(margin, Flx.height - margin - 64, 'down', 'navigation');

		addButton(FlxG.width - margin - 140, FlxG.height - margin - 64, 'cancel');
		addButton(FlxG.width - margin - 64, FlxG.height - margin - 140, 'confirm');
	}

	/**
	 * Sets up a horizontal menu layout.
	 */
	public function setupMenuHorizontal():Void
	{
		clearButtons();

		addButton(margin, FlxG.height - margin - 64, 'left', 'navigation');
		addButton(margin + 76, FlxG.height - margin - 64, 'right', 'navigation');

		addButton(FlxG.width - margin - 140, FlxG.height - margin - 64, 'cancel');
		addButton(FlxG.width - margin - 64, FlxG.height - margin - 140, 'confirm');
	}

	/**
	 * Sets up the utility buttons used by a screen.
	 */
	public function setupUtility(?showBack:Bool = false, ?showSkip:Bool = false, ?showPause:Bool = false):Void
	{
		if (showBack)
			addButton(margin, margin, 'cancel', 'util', 'back');

		if (showSkip)
			addButton(FlxG.width - margin - 48, margin, 'skip', 'util');

		if (showPause)
			addButton(FlxG.width - margin - 48, margin, 'pause', 'util');
	}

	/**
	 * Updates the visual state of every button.
	 *
	 * Touch input itself is read directly from FlxTouch, so this method
	 * does not need to maintain a second pressed-state buffer.
	 */
	public function updateInput():Void
	{
		forEach(function(button:VirtualButton):Void
		{
			if (button != null)
				button.updateVisual();
		});
	}

	/**
	 * Checks a mobile button for the requested input state.
	 */
	public static function checkInput(action:String, state:FlxInputState):Bool
	{
		if (active == null)
			return false;

		for (button in active.members)
		{
			if (button == null || button.action != action)
				continue;

			switch (state)
			{
				case JUST_PRESSED:
					if (button.justPressed())
						return true;

				case PRESSED:
					if (button.isPressed())
						return true;

				case JUST_RELEASED:
					if (button.justReleased())
						return true;

				default:
			}
		}

		return false;
	}

	/**
	 * Checks whether any mobile button is in a given state.
	 */
	public static function checkAnyInput(state:FlxInputState):Bool
	{
		if (active == null)
			return false;

		for (button in active.members)
		{
			if (button == null || !button.enabled || !button.visible)
				continue;

			switch (state)
			{
				case JUST_PRESSED:
					if (button.justPressed())
						return true;

				case PRESSED:
					if (button.isPressed())
						return true;

				case JUST_RELEASED:
					if (button.justReleased())
						return true;

				default:
			}
		}

		return false;
	}

	override public function destroy():Void
	{
		if (active == this)
			active = previous;

		previous = null;

		super.destroy();
	}
}