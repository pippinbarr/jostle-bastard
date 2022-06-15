package;

class Exercizer extends Other
{
	private var mat:PhysicsSprite;
	private var distanceFromMat:Float;

	private var exercizing:Bool = true;


	public function new(X:Float,Y:Float,theBastard:Bastard,theMat:PhysicsSprite):Void
	{
		super(X,Y,GameAssets.PERSON_STANDING_PNG,null,theBastard,EXERCISE);

		exercizing = true;
		mat = theMat;
		distanceFromMat = Math.sqrt(Math.pow(this.hit.getMidpoint().x - mat.getMidpoint().x,2) + Math.pow(this.hit.getMidpoint().y - mat.getMidpoint().y,2));
		moveLeft();
	}


	override public function update():Void
	{
		super.update();

		// Check if too far from mat
		if (Math.sqrt(Math.pow(this.hit.getMidpoint().x - mat.getMidpoint().x,2) + 
			Math.pow(this.hit.getMidpoint().y - mat.getMidpoint().y,2)) > 
		distanceFromMat + mat.width)
		{
			exercizing = false;
			changeMode(WANDER);
		}

		if (exercizing)
		{			
			if (body.getLinearVelocity().x < 0)
			{
				if (hit.x < mat.x + 10) 
				{
					// trace("Moving left, changing to right...");
					moveRight();
				}
				else 
				{
					// trace("Moving left, continuing left...");
					moveLeft();
				}
			}
			else if (body.getLinearVelocity().x > 0)
			{
				if (hit.x + hit.width > mat.x + mat.width - 10) moveLeft();
				else moveRight();
			}
			else
			{
				moveLeft();
			}
		}
		else
		{

		}
	}

	override private function handleImpact(impulse:Float,other:PhysicsSprite):Void
	{
		super.handleImpact(impulse,other);

		
		if (impulse > 1 || mood != NORMAL) 
		{
			exercizing = false;
		}
	}
}