package sinco.mc.chat;

class ChatBox extends FlxSprite
{

    override public function new(x:Float = 0.0, y:Float = 0.0)
    {
        super(x,y);

        makeGraphic(320, 20, FlxColor.BLACK);
    }
}