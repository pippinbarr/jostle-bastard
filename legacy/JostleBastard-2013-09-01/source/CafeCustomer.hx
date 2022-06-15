package;

import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxG;
import org.flixel.FlxObject;

import box2D.collision.shapes.B2PolygonShape;
import box2D.collision.shapes.B2MassData;
import box2D.common.math.B2Vec2;
import box2D.common.math.B2Transform;
import box2D.common.math.B2Mat22;

import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2World;


class CafeCustomer extends Other
{
	public var chair:Chair;


	public function new(X:Float,Y:Float,Sprite:String,theChair:Chair)
	{
		super(X,Y,Sprite);

		chair = theChair;
	}


	override public function destroy():Void
	{
		super.destroy();
	}


	override public function update():Void
	{
		super.update();
	}


	override private function followSetPath():Bool
	{
		if (!super.followSetPath()) return false;

		if (pathIndex != -1)
		{
			// We're moving on the path.

			if (pathIndex == 0)
			{
				if (Physics.worldToScreen(body.getPosition().x) > CafeState.customerPath[0] + 5)
				{
					moveLeft();
				}
				else if (Physics.worldToScreen(body.getPosition().x) < CafeState.customerPath[0] - 5)
				{
					moveRight();
				}
				else
				{
					idleX();
					pathIndex++;
				}
			}
			else if (pathIndex == 1)
			{
				if (Physics.worldToScreen(body.getPosition().y) > CafeState.customerPath[1] + 5)
				{
					moveUp();
				}
				else
				{
					idleY();
					pathIndex++;

				}
			}
			else if (pathIndex == 2)
			{
				if (Physics.worldToScreen(body.getPosition().x) < CafeState.customerPath[2])
				{
					moveRight();
				}
				else
				{
					idleX();
					pathIndex++;
				}
			}
			else if (pathIndex == 3)
			{
				if (Physics.worldToScreen(body.getPosition().x) < CafeState.customerPath[3])
				{
					moveRight();
				}
				else
				{
					idleX();
					pathIndex++;

				}
			}
			else if (pathIndex == 4)
			{
				if (Physics.worldToScreen(body.getPosition().y) < chair.y + 40)
				{
					moveDown();
				}
				else
				{
					idleY();
					pathIndex++;

				}
			}
			else if (pathIndex == 5)
			{
				if (Physics.worldToScreen(body.getPosition().x) > Physics.worldToScreen(chair.body.getPosition().x) + 30)
				{
					moveLeft();
				}
				else if (Physics.worldToScreen(body.getPosition().x) < Physics.worldToScreen(chair.body.getPosition().x) - 30)
				{
					moveRight();
				}
				else
				{
					visible = false;
					active = false;
					chair.sit();
					body.setActive(false);

					pathIndex = -1;
				}
			}
		}

		return true;
	}


}