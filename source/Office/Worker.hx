package;

class Worker extends Other
{
	private var desk:PhysicsSprite;
	private var distanceFromDesk:Float;

	public function new(X:Float,Y:Float,theBastard:Bastard,theDesk:PhysicsSprite):Void
	{
		super(X,Y,GameAssets.PERSON_STANDING_PNG,null,theBastard,STILL);

		desk = theDesk;
		distanceFromDesk = Math.sqrt(Math.pow(this.x - desk.x,2) + Math.pow(this.y - desk.y,2));
	}

	override public function update():Void
	{
		super.update();

		// Check if too far from desk
		if (Math.sqrt(Math.pow(this.x - desk.x,2) + Math.pow(this.y - desk.y,2)) > distanceFromDesk + 1)
		{
			desk.pauseAnimation();
		}
	}

	override private function handleImpact(impulse:Float,other:PhysicsSprite):Void
	{
		super.handleImpact(impulse,other);

		
		if (impulse > 1 || mood != NORMAL) 
		{
			// trace("Pausing work animation.");
			desk.pauseAnimation();
		}
	}
}