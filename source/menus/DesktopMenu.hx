package menus;

import flixel.addons.display.FlxBackdrop;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionableState;

class DesktopMenu extends MusicBeatState
{
	var icons:Map<String, Dynamic> = [
		"discord" => "https://discord.gg/ron-874366610918473748",
		"random" => "https://www.facebook.com/",
		"settings" => new options.OptionsState(),
		"freeplay" => new MasterFreeplayState(),
		"story mode" => new StoryMenuState(),
		

		"credits" => new CreditsState()
	];
	public static var curClicked:String = "";
	var clickAmounts:Int = 0;
	var buttons:Array<FlxButton> = [];
	var clicked:Bool = false;
	var time:Float = 0;
	override function create() {
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;
		persistentUpdate = true;
		important.WeekData.loadTheFirstEnabledMod();
		//FlxG.mouse.visible = true;
		var iconI:Int = 0;
		var iconFrames = Paths.getSparrowAtlas("menuIcons");
		var rainbowscreen = new FlxBackdrop(Paths.image('rainbowpcBg'), XY, 0, 0);
		new FlxTimer().start(0.005, function(tmr:FlxTimer)
		{
			rainbowscreen.x += (Math.sin(time)/5)+2;
			rainbowscreen.y += (Math.cos(time)/5)+1;
			tmr.reset(0.005);
		});
		add(rainbowscreen);
		add(new FlxSprite().loadGraphic(Paths.image("pcBg")));
		for (i in icons.keys()) {
			var button:FlxButton;
			button = new FlxButton((iconI > 2 ? 180 : 20), 20 + (150 * (iconI > 2 ? iconI - 3:iconI)), "", function() {
				if (curClicked != i) {
					clickAmounts = 0;
					curClicked = i;
					for (i in buttons)
						i.color = 0xffffff;
				}
				if (curClicked == i) {
					clickAmounts++;
					button.color = 0xFF485EC2;
					if (clickAmounts == 2) {
						if (icons[i].length != 0)
							CoolUtil.browserLoad(icons[i]);
						else
							MusicBeatState.switchState(icons[i]);
					}
						
				}
				clicked = true;
			});
			button.frames = iconFrames;
			button.animation.addByPrefix("normal", i);
			button.animation.addByPrefix("highlight", i);
			button.animation.addByPrefix("pressed", i);
			add(button);
			buttons.push(button);
			iconI++;
		}
		super.create();
	}
	override function update(elapsed:Float) {
		time += elapsed;
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * elapsed;
		}
		super.update(elapsed);
	}
}