package sinco.mc.chat;

class ChatMessage extends FlxSpriteGroup
{
    public var messageBox:ChatBox;
	public var textField:FlxText = new FlxText(0, 0, (FlxG.width / 2), "Hello World", 16);

    public var textFieldPadding:Float = 4.0;

	public var timerManager:FlxTimerManager = new FlxTimerManager();
	public var timer:FlxTimer;

	override public function new(text:String = "Hello World")
	{
		super();

		messageBox = new ChatBox(0, FlxG.height - 120);
		messageBox.alpha = 0.5;
		messageBox.scrollFactor.set(0,0);

		textField.text = text;
		textField.setFormat(Paths.font('mc.ttf'), 16, FlxColor.WHITE);
		textField.alignment = LEFT;
		textField.setPosition(messageBox.x - textFieldPadding, messageBox.y - textFieldPadding);
		textField.scrollFactor.set(0, 0);

		messageBox.makeGraphic(640, Math.round(20 + (textField.height - 24)), FlxColor.BLACK);

		add(messageBox);
		add(textField);

		timer = new FlxTimer(timerManager);
	}

    public function moveUp()
    {
		messageBox.y -= messageBox.height;
		textField.setPosition(messageBox.x - textFieldPadding, messageBox.y - textFieldPadding);
	}

}