package jta.mobile;

import jta.Paths;
import jta.Assets;

class VirtualButton extends FlxSprite
{
    public var action:String;

    public function new(x:Float, y:Float, action:String, ?type:String = 'default'):Void
    {
        super(x, y);

        this.action = action;

        var folder:String = (type == 'default) ? '' : '/$type';
        var path:String = 'buttons$folder/$action';

        if (Assets.exists(Paths.image(path)))
            loadGraphic(Paths.image(path));
        else
            loadGraphic(Paths.image('buttons/default'));

        scrollFactor.set();
        alpha = 0.7;
    }

    public function isPressed():Bool
    {
        for (touch in FlxG.touches.list)
            if (overlapsPoint(touch.screenX, touch.screenY))
                return true;
        return false;
    }
}