package jta.objects.level;

/**
 * Represents an object in a level.
 */
class Object extends FlxSprite
{
	/**
	 * The ID of the object.
	 */
	public var objectID:String;

	/**
	 * Whether or not the object can be interacted with.
	 */
	public var objectInteractable:Bool;

	/**
	 * Whether the object has an `interact()` action (e.g. signs), as opposed to
	 * only reacting to being touched (e.g. coins).
	 * Used to decide when to show the mobile interact button.
	 */
	public var objectHasInteraction:Bool = false;

	/**
	 * Initializes the object with a specified ID.
	 * @param objectID The ID of the object.
	 */
	public function new(objectID:String):Void
	{
		super();

		this.objectID = objectID;
	}

	/**
	 * Function called when the object is interacted with, if it is interactable.
	 */
	public function interact():Void {}

	/**
	 * Function called when the player overlaps the object.
	 */
	public function overlap():Void {}
}
