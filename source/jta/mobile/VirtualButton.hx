package jta.mobile;

import jta.Paths;
import jta.Assets;
import flixel.FlxCamera;
import flixel.input.touch.FlxTouch;

/**
 * A virtual touchscreen button.
 *
 * The button's `action` is the logical input action it represents,
 * while `imageName` controls which button graphic is displayed.
 *
 * This allows the same A graphic to represent both `jump` in gameplay
 * and `confirm` in menus.
 */
class VirtualButton extends FlxSprite
{
	/**
	 * Logical input action represented by this button.
	 */
	public var action:String;

	/**
	 * Asset name used to display this button.
	 */
	public var imageName:String;

	/**
	 * Whether this button can currently receive touch input.
	 */
	public var enabled:Bool = true;

	/**
	 * Whether the button should be visible.
	 */
	public var visibleWhenEnabled:Bool = true;

	/**
	 * Normal button opacity.
	 */
	public var normalAlpha:Float = 0.7;

	/**
	 * Opacity while being pressed.
	 */
	public var pressedAlpha:Float = 1.0;

	public function new(x:Float, y:Float, action:String, ?type:String = 'default', ?imageName:String = null):Void
	{
		super(x, y);

		this.action = action;

		if (imageName == null)
		{
			imageName = switch (action)
			{
				case 'jump', 'confirm':
					'a';

				case 'run', 'cancel':
					'b';

				default:
					action;
			};
		}

		this.imageName = imageName;

		var folder:String = (type == null || type == '' || type == 'default') ? '' : '/$type';
		var path:String = 'buttons$folder/$imageName';

		if (Assets.exists(Paths.image(path)))
			loadGraphic(Paths.image(path));
		else if (Assets.exists(Paths.image('buttons/default')))
			loadGraphic(Paths.image('buttons/default'));

		// Make the buttons slightly larger to increase the touchable area.
		scale.set(6, 6);
		updateHitbox();

		scrollFactor.set();

		alpha = normalAlpha;
		antialiasing = false;
	}

	private function getTouchCamera():FlxCamera
	{
		if (cameras != null && cameras.length > 0 && cameras[0] != null)
			return cameras[0];

		return FlxG.camera;
	}

	/**
	 * Returns whether a touch is currently pressing this button.
	 * Multitouch is supported because every active touch is checked.
	 */
	public function isPressed():Bool
	{
		if (!enabled || !visible)
			return false;

		#if FLX_TOUCH
		for (touch in FlxG.touches.list)
		{
			if (touch.pressed && touch.overlaps(this, getTouchCamera()))
				return true;
		}
		#end

		return false;
	}

	/**
	 * Returns whether this button was just pressed this frame.
	 */
	public function justPressed():Bool
	{
		if (!enabled || !visible)
			return false;

		#if FLX_TOUCH
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed && touch.overlaps(this, getTouchCamera()))
				return true;
		}
		#end

		return false;
	}

	/**
	 * Returns whether this button was just released this frame.
	 */
	public function justReleased():Bool
	{
		if (!enabled || !visible)
			return false;

		#if FLX_TOUCH
		for (touch in FlxG.touches.list)
		{
			if (touch.justReleased && touch.overlaps(this, getTouchCamera()))
				return true;
		}
		#end

		return false;
	}

	/**
	 * Updates the visual appearance of the button.
	 */
	public function updateVisual():Void
	{
		if (!enabled)
		{
			alpha = 0;
			return;
		}

		alpha = isPressed() ? pressedAlpha : normalAlpha;
	}

	override public function update(elapsed:Float):Void
	{
		updateVisual();

		super.update(elapsed);
	}
}
