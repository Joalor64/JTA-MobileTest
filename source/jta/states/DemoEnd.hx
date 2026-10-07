package jta.states;

import jta.Paths;
import jta.input.Input;
import jta.states.MainMenu;
import jta.states.BaseState;
#if mobile
import jta.mobile.MobileInput;
import flixel.input.FlxInput.FlxInputState;
#end

class DemoEnd extends BaseState
{
	var soundPlayed:Bool = false;

	override public function create():Void
	{
		var text:FlxText = new FlxText(0, 340, FlxG.width, 'END OF DEMO\nThanks for playing!', 12);
		text.setFormat(Paths.font('main'), 40, FlxColor.WHITE, CENTER);
		text.screenCenter(X);
		add(text);

		super.create();

		FlxG.sound.play(Paths.sound('end'), function():Void
		{
			new FlxTimer().start(1, function(tmr:FlxTimer):Void
			{
				text.text += #if mobile '\n\nTAP TO CONTINUE' #else '\n\nPRESS ANYTHING TO CONTINUE' #end;
				soundPlayed = true;
			});
		});
	}

	override public function update(elapsed:Float):Void
	{
		if (soundPlayed && (Input.justPressed('any') #if mobile || MobileInput.checkAnyTouch(JUST_PRESSED) #end))
		{
			FlxG.sound.play(Paths.sound('select'));
			transitionState(new MainMenu());
		}

		super.update(elapsed);
	}
}
