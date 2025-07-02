package mikolka.stages.standard;

import mikolka.stages.cutscenes.VideoCutscene;
import mikolka.vslice.StickerSubState;
import flixel.FlxSubState;
import openfl.filters.ShaderFilter;
import shaders.RainShader;
import flixel.addons.display.FlxTiledSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import mikolka.compatibility.VsliceOptions;
using source.mikolka.stages.cutscenes.DarnellStart;
#if !LEGACY_PSYCH
import substates.PauseSubState;
import substates.GameOverSubstate;
import objects.Note;
import cutscenes.CutsceneHandler;
#end

class PhillyStreets extends BaseStage
{
	var rainShader:RainShader;
	var rainShaderStartIntensity:Float = 0;
	var rainShaderEndIntensity:Float = 0;

	var rainSndAmbience:FlxSound;
	var carSndAmbience:FlxSound;

	var scrollingSky:FlxTiledSprite;
	var phillyTraffic:BGSprite;

	var phillyCars:BGSprite;
	var phillyCars2:BGSprite;

	var picoFade:FlxSprite;
	public var spraycan:SpraycanAtlasSprite;
	var spraycanPile:BGSprite;

	var darkenable:Array<FlxSprite> = [];

	override function create()
	{
		if (!VsliceOptions.LOW_QUALITY)
		{
			var skyImage = Paths.image('phillyStreets/phillySkybox');
			scrollingSky = new FlxTiledSprite(skyImage, skyImage.width + 400, skyImage.height, true, false);
			scrollingSky.antialiasing = VsliceOptions.ANTIALIASING;
			scrollingSky.setPosition(-650, -375);
			scrollingSky.scrollFactor.set(0.1, 0.1);
			scrollingSky.scale.set(0.65, 0.65);
			add(scrollingSky);
			darkenable.push(scrollingSky);

			var phillySkyline:BGSprite = new BGSprite('phillyStreets/phillySkyline', -545, -273, 0.2, 0.2);
			add(phillySkyline);
			darkenable.push(phillySkyline);

			var phillyForegroundCity:BGSprite = new BGSprite('phillyStreets/phillyForegroundCity', 625, 94, 0.3, 0.3);
			add(phillyForegroundCity);
			darkenable.push(phillyForegroundCity);
		}

		var phillyConstruction:BGSprite = new BGSprite('phillyStreets/phillyConstruction', 1800, 364, 0.7, 1);
		add(phillyConstruction);
		darkenable.push(phillyConstruction);

		var phillyHighwayLights:BGSprite = new BGSprite('phillyStreets/phillyHighwayLights', 284, 305, 1, 1);
		add(phillyHighwayLights);
		darkenable.push(phillyHighwayLights);

		if (!VsliceOptions.LOW_QUALITY)
		{
			var phillyHighwayLightsLightmap:BGSprite = new BGSprite('phillyStreets/phillyHighwayLights_lightmap', 284, 305, 1, 1);
			phillyHighwayLightsLightmap.blend = ADD;
			phillyHighwayLightsLightmap.alpha = 0.6;
			add(phillyHighwayLightsLightmap);
			darkenable.push(phillyHighwayLightsLightmap);
		}

		var phillyHighway:BGSprite = new BGSprite('phillyStreets/phillyHighway', 139, 209, 1, 1);
		add(phillyHighway);
		darkenable.push(phillyHighway);

		if (!VsliceOptions.LOW_QUALITY)
		{
			var phillySmog:BGSprite = new BGSprite('phillyStreets/phillySmog', -6, 245, 0.8, 1);
			add(phillySmog);
			darkenable.push(phillySmog);

			for (i in 0...2)
			{
				var car:BGSprite = new BGSprite('phillyStreets/phillyCars', 1200, 818, 0.9, 1, ['car1', 'car2', 'car3', 'car4'], false);
				add(car);
				switch (i)
				{
					case 0:
						phillyCars = car;
					case 1:
						phillyCars2 = car;
				}
				darkenable.push(car);
			}
			phillyCars2.flipX = true;

			phillyTraffic = new BGSprite('phillyStreets/phillyTraffic', 1840, 608, 0.9, 1, ['redtogreen', 'greentored'], false);
			add(phillyTraffic);
			darkenable.push(phillyTraffic);

			var phillyTrafficLightmap:BGSprite = new BGSprite('phillyStreets/phillyTraffic_lightmap', 1840, 608, 0.9, 1);
			phillyTrafficLightmap.blend = ADD;
			phillyTrafficLightmap.alpha = 0.6;
			add(phillyTrafficLightmap);
			darkenable.push(phillyTrafficLightmap);
		}

		var phillyForeground:BGSprite = new BGSprite('phillyStreets/phillyForeground', 88, 317, 1, 1);
		add(phillyForeground);
		darkenable.push(phillyForeground);

		if (!VsliceOptions.LOW_QUALITY)
		{
			picoFade = new FlxSprite();
			picoFade.antialiasing = VsliceOptions.ANTIALIASING;
			picoFade.alpha = 0;
			add(picoFade);
			darkenable.push(picoFade);
		}

		if (VsliceOptions.SHADERS)
			setupRainShader();


		var _song = PlayState.SONG;
		if (_song.gameOverSound == null || _song.gameOverSound.trim().length < 1)
			GameOverSubstate.deathSoundName = 'fnf_loss_sfx-pico';
		if (_song.gameOverLoop == null || _song.gameOverLoop.trim().length < 1)
			GameOverSubstate.loopSoundName = 'gameOver-pico';
		if (_song.gameOverEnd == null || _song.gameOverEnd.trim().length < 1)
			GameOverSubstate.endSoundName = 'gameOverEnd-pico';
		if (_song.gameOverChar == null || _song.gameOverChar.trim().length < 1)
			GameOverSubstate.characterName = 'pico-dead';
		setDefaultGF('nene');
		gfGroup.y += 200;
		gfGroup.x += 50;

		if (isStoryMode)
		{
			switch (songName)
			{
				case 'darnell':
					if (!seenCutscene)
						setStartCallback(videoCutscene.bind('darnellCutscene'));
				case '2hot':
					setEndCallback(function()
					{
						game.endingSong = true;
						inCutscene = true;
						canPause = false;
						FlxTransitionableState.skipNextTransIn = true;
						FlxG.camera.visible = false;
						camHUD.visible = false;
						game.startVideo('2hotCutscene');
					});
			}
		}
	}

	var noteTypes:Array<String> = [];

	override function createPost()
	{
		StickerSubState.STICKER_PACK = "weekend";
		var unspawnNotes:Array<Note> = cast game.unspawnNotes;
		for (note in unspawnNotes)
		{
			if (note == null)
				continue;

			// override animations for note types
			switch (note.noteType)
			{
				case 'weekend-1-firegun':
					note.blockHit = true;
			}
			if (!noteTypes.contains(note.noteType))
				noteTypes.push(note.noteType);
		}

		spraycanPile = new BGSprite('SpraycanPile', 920, 1045, 1, 1);
		precache();
		add(spraycanPile);
		darkenable.push(spraycanPile);

		carSndAmbience = new FlxSound().loadEmbedded(Paths.sound("ambience/car"), true);
		FlxG.sound.list.add(carSndAmbience);
		carSndAmbience.volume = 0.01;
		carSndAmbience.play(false, FlxG.random.float(0, carSndAmbience.length));

		if (VsliceOptions.SHADERS)
		{
			// ? ambience
			rainSndAmbience = new FlxSound().loadEmbedded(Paths.sound("ambience/rain"), true);
			FlxG.sound.list.add(rainSndAmbience);
			rainSndAmbience.volume = 0.01;
			rainSndAmbience.play(false, FlxG.random.float(0, rainSndAmbience.length));
		}

		super.createPost();
	}


	var videoEnded:Bool = false;

	function videoCutscene(?videoName:String = null)
	{
		VideoCutscene.playVideo(videoName,() ->{
			game.inCutscene = true;
			if (isStoryMode && PlayState.instance != null)
			{
				switch (songName)
				{
					case 'darnell':
						DarnellStart.darnellCutscene(this);
				}
			}
		});
	}


	override function startSong()
	{
		super.startSong();
		carSndAmbience.volume = 0.1;
	}

	override function openSubState(SubState:FlxSubState) {
		super.openSubState(SubState);
		if(!Std.isOfType(SubState,PauseSubState) || inCutscene) return;
		// Temporarily stop ambiance.
		if (rainSndAmbience != null) {
			rainSndAmbience.pause();
		}
		if (carSndAmbience != null) {
			carSndAmbience.pause();
		}
		PlayState.instance.subStateClosed.addOnce((sub) ->{
			carSndAmbience.volume = 0.1;
			if (carSndAmbience != null) carSndAmbience.resume();
			if (rainSndAmbience != null) rainSndAmbience.resume();
		});
	}
	

	var casingGroup:FlxSpriteGroup;
	var casingFrames:FlxAtlasFrames;
	var bonkSnd:FlxSound;
	public var gunPrepSnd:FlxSound;
	public var lightCanSnd:FlxSound;
	public var kickCanSnd:FlxSound;
	public var kneeCanSnd:FlxSound;

	function precache()
	{
		var didCreateCan = false;
		function createCan()
		{
			if (didCreateCan)
				return;
			spraycan = new SpraycanAtlasSprite(spraycanPile.x + 530, spraycanPile.y - 240);
			add(spraycan);

			lightCanSnd = new FlxSound();
			FlxG.sound.list.add(lightCanSnd);
			lightCanSnd.loadEmbedded(Paths.sound('Darnell_Lighter'));

			kickCanSnd = new FlxSound();
			FlxG.sound.list.add(kickCanSnd);
			kickCanSnd.loadEmbedded(Paths.sound('Kick_Can_UP'));

			kneeCanSnd = new FlxSound();
			FlxG.sound.list.add(kneeCanSnd);
			kneeCanSnd.loadEmbedded(Paths.sound('Kick_Can_FORWARD'));
			didCreateCan = true;
		}

		var didCreateCasing = false;
		function precacheCasing()
		{
			if (didCreateCasing)
				return;
			if (!VsliceOptions.LOW_QUALITY)
			{
				casingFrames = Paths.getSparrowAtlas('PicoBullet'); // precache
				casingGroup = new FlxSpriteGroup();
				add(casingGroup);
			}

			gunPrepSnd = new FlxSound();
			FlxG.sound.list.add(gunPrepSnd);
			gunPrepSnd.loadEmbedded(Paths.sound('Gun_Prep'));
			didCreateCasing = true;
		}

		for (noteType in noteTypes)
		{
			switch (noteType)
			{
				case 'weekend-1-kickcan':
					createCan();
				case 'weekend-1-cockgun':
					precacheCasing();
				case 'weekend-1-firegun':
					bonkSnd = new FlxSound();
					FlxG.sound.list.add(bonkSnd);
					bonkSnd.loadEmbedded(Paths.sound('Pico_Bonk'));
			}
		}

		if (isStoryMode && !seenCutscene)
		{
			switch (songName)
			{
				case 'darnell':
					createCan();
					precacheCasing();
			}
		}

		for (i in 1...5)
			Paths.sound('shots/shot$i');
	}

	function setupRainShader()
	{
		rainShader = new RainShader();
		rainShader.scale = FlxG.height / 200;
		switch (songName)
		{
			case 'darnell':
				rainShaderStartIntensity = 0;
				rainShaderEndIntensity = 0.1;
			case 'lit-up':
				rainShaderStartIntensity = 0.1;
				rainShaderEndIntensity = 0.2;
			case '2hot':
				rainShaderStartIntensity = 0.2;
				rainShaderEndIntensity = 0.4;
		}
		rainShader.intensity = rainShaderStartIntensity;
		#if LEGACY_PSYCH
		FlxG.camera.setFilters([new ShaderFilter(rainShader)]);
		#else
		FlxG.camera.filters = [new ShaderFilter(rainShader)];
		#end
	}

	override function update(elapsed:Float)
	{
		if (scrollingSky != null)
			scrollingSky.scrollX -= elapsed * 22;

		if (rainShader != null)
		{
			var remappedIntensityValue:Float = FlxMath.remapToRange(Conductor.songPosition, 0, (FlxG.sound.music != null ? FlxG.sound.music.length : 0),
				rainShaderStartIntensity, rainShaderEndIntensity);
			rainShader.intensity = remappedIntensityValue;
			rainShader.updateViewInfo(FlxG.width, FlxG.height, FlxG.camera);
			rainShader.update(elapsed);

			if (rainSndAmbience != null && FlxG.sound.volume != 0)
			{
				rainSndAmbience.volume = Math.min(0.3, remappedIntensityValue * 2);
			}
		}

		super.update(elapsed);
	}

	var lightsStop:Bool = false;
	var lastChange:Int = 0;
	var changeInterval:Int = 8;

	var carWaiting:Bool = false;
	var carInterruptable:Bool = true;
	var car2Interruptable:Bool = true;

	override function beatHit()
	{
		// if(curBeat % 2 == 0) abot.beatHit();
		super.beatHit();

		if (VsliceOptions.LOW_QUALITY)
			return;

		if (FlxG.random.bool(10) && curBeat != (lastChange + changeInterval) && carInterruptable == true)
		{
			if (lightsStop == false)
				driveCar(phillyCars);
			else
				driveCarLights(phillyCars);
		}

		if (FlxG.random.bool(10) && curBeat != (lastChange + changeInterval) && car2Interruptable == true && lightsStop == false)
			driveCarBack(phillyCars2);

		if (curBeat == (lastChange + changeInterval))
			changeLights(curBeat);
	}

	function changeLights(beat:Int):Void
	{
		lastChange = beat;
		lightsStop = !lightsStop;

		if (lightsStop)
		{
			phillyTraffic.animation.play('greentored');
			changeInterval = 20;
		}
		else
		{
			phillyTraffic.animation.play('redtogreen');
			changeInterval = 30;

			if (carWaiting == true)
				finishCarLights(phillyCars);
		}
	}

	function finishCarLights(sprite:BGSprite):Void
	{
		carWaiting = false;
		var duration:Float = FlxG.random.float(1.8, 3);
		var rotations:Array<Int> = [-5, 18];
		var offset:Array<Float> = [306.6, 168.3];
		var startdelay:Float = FlxG.random.float(0.2, 1.2);

		var path:Array<FlxPoint> = [
			FlxPoint.get(1950 - offset[0] - 80, 980 - offset[1] + 15),
			FlxPoint.get(2400 - offset[0], 980 - offset[1] - 50),
			FlxPoint.get(3102 - offset[0], 1127 - offset[1] + 40)
		];

		FlxTween.angle(sprite, rotations[0], rotations[1], duration, {ease: FlxEase.sineIn, startDelay: startdelay});
		FlxTween.quadPath(sprite, path, duration, true, {ease: FlxEase.sineIn, startDelay: startdelay, onComplete: function(_) carInterruptable = true});
	}

	function driveCarLights(sprite:BGSprite):Void
	{
		carInterruptable = false;
		FlxTween.cancelTweensOf(sprite);
		var variant:Int = FlxG.random.int(1, 4);
		sprite.animation.play('car' + variant);
		var extraOffset = [0, 0];
		var duration:Float = 2;

		switch (variant)
		{
			case 1:
				duration = FlxG.random.float(1, 1.7);
			case 2:
				extraOffset = [20, -15];
				duration = FlxG.random.float(0.9, 1.5);
			case 3:
				extraOffset = [30, 50];
				duration = FlxG.random.float(1.5, 2.5);
			case 4:
				extraOffset = [10, 60];
				duration = FlxG.random.float(1.5, 2.5);
		}
		var rotations:Array<Int> = [-7, -5];
		var offset:Array<Float> = [306.6, 168.3];
		sprite.offset.set(extraOffset[0], extraOffset[1]);

		var path:Array<FlxPoint> = [
			FlxPoint.get(1500 - offset[0] - 20, 1049 - offset[1] - 20),
			FlxPoint.get(1770 - offset[0] - 80, 994 - offset[1] + 10),
			FlxPoint.get(1950 - offset[0] - 80, 980 - offset[1] + 15)
		];

		FlxTween.angle(sprite, rotations[0], rotations[1], duration, {ease: FlxEase.cubeOut});
		FlxTween.quadPath(sprite, path, duration, true, {
			ease: FlxEase.cubeOut,
			onComplete: function(_)
			{
				carWaiting = true;
				if (lightsStop == false)
					finishCarLights(phillyCars);
			}
		});
	}

	function driveCar(sprite:BGSprite):Void
	{
		carInterruptable = false;
		FlxTween.cancelTweensOf(sprite);
		var variant:Int = FlxG.random.int(1, 4);
		sprite.animation.play('car' + variant);

		var extraOffset = [0, 0];
		var duration:Float = 2;
		switch (variant)
		{
			case 1:
				duration = FlxG.random.float(1, 1.7);
			case 2:
				extraOffset = [20, -15];
				duration = FlxG.random.float(0.6, 1.2);
			case 3:
				extraOffset = [30, 50];
				duration = FlxG.random.float(1.5, 2.5);
			case 4:
				extraOffset = [10, 60];
				duration = FlxG.random.float(1.5, 2.5);
		}

		var offset:Array<Float> = [306.6, 168.3];
		sprite.offset.set(extraOffset[0], extraOffset[1]);

		var rotations:Array<Int> = [-8, 18];
		var path:Array<FlxPoint> = [
			FlxPoint.get(1570 - offset[0], 1049 - offset[1] - 30),
			FlxPoint.get(2400 - offset[0], 980 - offset[1] - 50),
			FlxPoint.get(3102 - offset[0], 1127 - offset[1] + 40)
		];

		FlxTween.angle(sprite, rotations[0], rotations[1], duration);
		FlxTween.quadPath(sprite, path, duration, true, {onComplete: function(_) carInterruptable = true});
	}

	function driveCarBack(sprite:FlxSprite):Void
	{
		car2Interruptable = false;
		FlxTween.cancelTweensOf(sprite);
		var variant:Int = FlxG.random.int(1, 4);
		sprite.animation.play('car' + variant);

		var extraOffset = [0, 0];
		var duration:Float = 2;
		switch (variant)
		{
			case 1:
				duration = FlxG.random.float(1, 1.7);
			case 2:
				extraOffset = [20, -15];
				duration = FlxG.random.float(0.6, 1.2);
			case 3:
				extraOffset = [30, 50];
				duration = FlxG.random.float(1.5, 2.5);
			case 4:
				extraOffset = [10, 60];
				duration = FlxG.random.float(1.5, 2.5);
		}

		var offset:Array<Float> = [306.6, 168.3];
		sprite.offset.set(extraOffset[0], extraOffset[1]);

		var rotations:Array<Int> = [18, -8];
		var path:Array<FlxPoint> = [
			FlxPoint.get(3102 - offset[0], 1127 - offset[1] + 60),
			FlxPoint.get(2400 - offset[0], 980 - offset[1] - 30),
			FlxPoint.get(1570 - offset[0], 1049 - offset[1] - 10)
		];

		FlxTween.angle(sprite, rotations[0], rotations[1], duration);
		FlxTween.quadPath(sprite, path, duration, true, {onComplete: function(_) car2Interruptable = true});
	}

	override function goodNoteHit(note:Note)
	{
		super.goodNoteHit(note);

		switch (note.noteType)
		{
			case 'weekend-1-cockgun': // HE'S PULLING HIS COCK OUT
				boyfriend.holdTimer = 0;
				boyfriend.playAnim('cock', true);
				boyfriend.specialAnim = true;
				gunPrepSnd.play();

				boyfriend.animation.callback = function(name:String, frameNumber:Int, frameIndex:Int)
				{
					switch (name)
					{
						case 'cock':
							if (frameNumber == 3)
							{
								boyfriend.animation.callback = null;
								createCasing();
							}
						default:
							boyfriend.animation.callback = null;
					}
				}

				game.notes.forEachAlive(function(note:Note)
				{
					if (note.noteType == 'weekend-1-firegun')
						note.blockHit = false;
				});
				showPicoFade();

			case 'weekend-1-firegun':
				boyfriend.holdTimer = 0;
				boyfriend.playAnim('shoot', true);
				boyfriend.specialAnim = true;
				FlxG.sound.play(Paths.soundRandom('shots/shot', 1, 4));
				spraycan.playCanShot();

				new FlxTimer().start(1 / 24, function(tmr)
				{
					darkenStageProps();
				});
		}
	}

	public function createCasing()
	{
		if (VsliceOptions.LOW_QUALITY)
			return;

		var casing:FlxSprite = new FlxSprite(boyfriend.x + 250, boyfriend.y + 100);
		casing.frames = casingFrames;
		casing.animation.addByPrefix('pop', 'Pop0', 24, false);
		casing.animation.addByPrefix('idle', 'Bullet0', 24, true);
		casing.animation.play('pop', true);

		casing.animation.callback = function(name:String, frameNumber:Int, frameIndex:Int)
		{
			if (name == 'pop' && frameNumber == 40)
			{
				// Get the end position of the bullet dynamically.
				casing.x = casing.x + casing.frame.offset.x - 1;
				casing.y = casing.y + casing.frame.offset.y + 1;

				casing.angle = 125.1; // Copied from FLA

				// Okay this is the neat part, we can set the velocity and angular acceleration to make it roll without editing update().
				var randomFactorA:Float = FlxG.random.float(3, 10);
				var randomFactorB:Float = FlxG.random.float(1.0, 2.0);
				casing.velocity.x = 20 * randomFactorB;
				casing.drag.x = randomFactorA * randomFactorB;

				casing.angularVelocity = 100;
				// Calculated to ensure angular acceleration is maintained through the whole roll.
				casing.angularDrag = (casing.drag.x / casing.velocity.x) * 100;

				casing.animation.play('idle');
				casing.animation.callback = null; // Save performance.
			}
		};
		casingGroup.add(casing);
	}

	override function opponentNoteHit(note:Note)
	{
		var sndTime:Float = note.strumTime - Conductor.songPosition;
		switch (note.noteType)
		{
			case 'weekend-1-lightcan':
				dad.holdTimer = 0;
				dad.playAnim('lightCan', true);
				dad.specialAnim = true;
				lightCanSnd.play(true, sndTime - 65);
				@:privateAccess
				game.isCameraOnForcedPos = true;
				game.defaultCamZoom += 0.1;
				game.moveCamera(true);
				game.cameraSpeed = 2;
				camFollow.x -= 100;
			case 'weekend-1-kickcan':
				dad.holdTimer = 0;
				dad.playAnim('kickCan', true);
				dad.specialAnim = true;
				kickCanSnd.play(true, sndTime - 50);
				spraycan.playCanStart();
				camFollow.x += 250;
				game.cameraSpeed = 1.5;
				game.defaultCamZoom -= 0.1;

				new FlxTimer().start(1.1, function(_)
				{
					@:privateAccess
					game.isCameraOnForcedPos = false;
					game.moveCameraSection();
					game.cameraSpeed = 1;
				});
			case 'weekend-1-kneecan':
				dad.holdTimer = 0;
				dad.playAnim('kneeCan', true);
				dad.specialAnim = true;
				kneeCanSnd.play(true, sndTime - 22);
		}
	}

	var picoFlicker:FlxTimer = null;

	override function noteMiss(note:Note)
	{
		switch (note.noteType)
		{
			case 'weekend-1-firegun':
				boyfriend.playAnim('shootMISS', true);
				boyfriend.specialAnim = true;
				bonkSnd.play();

				if (picoFlicker != null)
				{
					picoFlicker.cancel();
					picoFlicker.destroy();
				}
				picoFlicker = null;

				boyfriend.animation.finishCallback = function(name:String)
				{
					if (name == 'shootMISS' && game.health > 0.0 && !game.practiceMode && game.gameOverTimer == null)
					{
						// FlxFlicker was crashing so fuck it, FlxTimer all the way
						picoFlicker = new FlxTimer().start(1 / 30, function(tmr:FlxTimer)
						{
							boyfriend.visible = !boyfriend.visible;
							if (tmr.loopsLeft == 0)
							{
								boyfriend.visible = true;
								picoFlicker = new FlxTimer().start(1 / 60, function(tmr2:FlxTimer)
								{
									boyfriend.visible = !boyfriend.visible;
									if (tmr2.loopsLeft == 0)
									{
										boyfriend.visible = true;
										// trace('test 2');
									}
								}, 30);
							}
						}, 30);
						// trace('test');
					}
					boyfriend.animation.finishCallback = null;
				}

				game.health -= 0.4;
				if (game.health <= 0.0 && !game.practiceMode)
				{
					GameOverSubstate.deathSoundName = 'fnf_loss_sfx-pico-explode';
					GameOverSubstate.loopSoundName = 'gameOverStart-pico-explode';
					GameOverSubstate.characterName = 'pico-explosion-dead';
				}
		}
	}

	function showPicoFade()
	{
		if (VsliceOptions.LOW_QUALITY)
			return;

		picoFade.setPosition(boyfriend.x, boyfriend.y);
		picoFade.frames = boyfriend.frames;
		picoFade.frame = boyfriend.frame;
		picoFade.alpha = 0.3;
		picoFade.scale.set(1, 1);
		picoFade.updateHitbox();
		picoFade.visible = true;

		FlxTween.cancelTweensOf(picoFade.scale);
		FlxTween.cancelTweensOf(picoFade);
		FlxTween.tween(picoFade.scale, {x: 1.3, y: 1.3}, 0.4);
		FlxTween.tween(picoFade, {alpha: 0}, 0.4, {onComplete: (_) -> (picoFade.visible = false)});
	}

	public function darkenStageProps()
	{
		// Darken the background, then fade it back.
		for (sprite in darkenable)
		{
			// If not excluded, darken.
			sprite.color = 0xFF111111;
			new FlxTimer().start(1 / 24, (tmr) ->
			{
				sprite.color = 0xFF222222;
				FlxTween.color(sprite, 1.4, 0xFF222222, 0xFFFFFFFF);
			});
		}
	}

	override function destroy()
	{
		super.destroy();
		// Fully stop ambiance.
		if (rainSndAmbience != null)
			rainSndAmbience.stop();
		if (carSndAmbience != null)
			carSndAmbience.stop();
	}
}
