package;

import org.flixel.FlxSound;

class GameAssets
{
	public static var JOSTLE_MP3:FlxSound;

	public static var STANDING_FRAME:UInt = 0;
	public static var SITTING_FRAME:UInt = 1;
	public static var FALLEN_FRAME:UInt = 2;


	// SOUND //

	public static var KICK1:String = "assets/mp3/kick1.mp3";
	public static var KICK2:String = "assets/mp3/kick2.mp3";

	public static var SNARE1:String = "assets/mp3/snare1.mp3";
	public static var SNARE2:String = "assets/mp3/snare2.mp3";

	public static var HIHAT1:String = "assets/mp3/hihat1.mp3";
	public static var HIHAT2:String = "assets/mp3/hihat2.mp3";

	public static var BASS1:String = "assets/mp3/bass0.mp3";
	public static var BASS2:String = "assets/mp3/bass2.mp3";
	public static var BASS3:String = "assets/mp3/bass3.mp3";





	// SHARED //
	
	public static var BASTARD_STANDING_PNG:String = "assets/png/shared/bastard_standing.png";
	public static var PERSON_FRAMES_PNG:String = "assets/png/shared/person_frames.png";
	public static var CHILD_FRAMES_PNG:String = "assets/png/shared/child_frames.png";
	public static var PERSON_STANDING_PNG:String = "assets/png/shared/person_standing.png";
	public static var COP_STANDING_PNG:String = "assets/png/shared/cop_standing.png";

	public static var WALL_TOP_PNG:String = "assets/png/shared/wall_top.png";
	public static var CHAIR_LEFT_PNG:String = "assets/png/shared/chair_left.png";
	public static var CHAIR_RIGHT_PNG:String = "assets/png/shared/chair_right.png";
	public static var TABLE_PNG:String = "assets/png/shared/table.png";


	// CAFE //

	public static var CAFE_COUNTER_PNG:String = "assets/png/cafe/cafe_counter.png";

	// APARTMENT //

	public static var TOILET_PNG:String = "assets/png/apartment/toilet.png";
	public static var ARMCHAIR_PNG:String = "assets/png/apartment/armchair.png";
	public static var SHOWER_PNG:String = "assets/png/apartment/shower.png";
	public static var STOVE_PNG:String = "assets/png/apartment/stove.png";
	public static var FRIDGE_PNG:String = "assets/png/apartment/fridge.png";
	public static var TV_PNG:String = "assets/png/apartment/tv.png";
	public static var BED_PNG:String = "assets/png/apartment/bed.png";
	public static var DRESSER_PNG:String = "assets/png/apartment/dresser.png";
	public static var SINK_PNG:String = "assets/png/apartment/sink.png";

	// ALLEY //

	public static var TRASH_1_PNG:String = "assets/png/alley/trash1.png";
	public static var TRASH_2_PNG:String = "assets/png/alley/trash2.png";
	public static var TRASH_3_PNG:String = "assets/png/alley/trash3.png";
	public static var TRASH_4_PNG:String = "assets/png/alley/trash4.png";

	// JAIL //

	public static var CELL_CLOSED_PNG:String = "assets/png/jail/cell_closed.png";
	public static var CELL_OPEN_PNG:String = "assets/png/jail/cell_open.png";


	// PARK //
	
	public static var FENCE_PNG:String = "assets/png/park/fence.png";
	public static var TREE_PNG:String = "assets/png/park/tree.png";
	public static var BENCH_LEFT:String = "assets/png/park/bench_left.png";
	public static var BENCH_RIGHT:String = "assets/png/park/bench_right.png";

	// OFFICE //
	
	public static var DESK_PNG:String = "assets/png/office/desk.png";

	// CINEMA //
	
	public static var CINEMA_SEAT_PNG:String = "assets/png/cinema/cinema_seat.png";
	public static var CINEMA_SCREEN_PNG:String = "assets/png/cinema/cinema_screen.png";
	public static var CINEMA_SCREEN_BG_PNG:String = "assets/png/cinema/cinema_screen_bg.png";

	// CHURCH //
	
	public static var CHURCH_PEW_PNG:String = "assets/png/church/pew.png";
	public static var CHURCH_ALTAR_PNG:String = "assets/png/church/altar.png";
	public static var CHURCH_WINDOWS_PNG:String = "assets/png/church/windows.png";


	// CLASSROOM //
	
	public static var STUDENT_CHAIR_PNG:String = "assets/png/classroom/student_chair.png";
	public static var STUDENT_DESK_PNG:String = "assets/png/classroom/student_desk.png";
	public static var TEACHER_DESK_PNG:String = "assets/png/classroom/teacher_desk.png";
	// public static var BLACKBOARD_PNG:String = "assets/png/classroom/blackboard.png";
	public static var BLACKBOARD_ANIM_PNG:String = "assets/png/classroom/blackboard_anim.png";

	// FOODCOURT //
	
	public static var CART_1_PNG:String = "assets/png/foodcourt/cart_1.png";
	public static var CART_2_PNG:String = "assets/png/foodcourt/cart_2.png";
	public static var CART_3_PNG:String = "assets/png/foodcourt/cart_3.png";

	// STORE //
	
	public static var SHELVES_PNG:String = "assets/png/store/shelves.png";
	public static var BOOKSHELVES_PNG:String = "assets/png/store/bookshelves.png";
	public static var CASH_REGISTER_PNG:String = "assets/png/store/cash_register.png";

	// GYM //
	
	public static var BOOMBOX_PNG:String = "assets/png/gym/boombox.png";

	// DISCO //
	
	public static var DANCEFLOOR_PNG:String = "assets/png/disco/dancefloor.png";


	// COLOURING //

	public static var BASTARD:Int = 0xffffffff; // BASTARD [WHITE]
	public static var OTHER:Int = 0xff36ff07; // OTHERS [GREEN]
	public static var FURNITURE:Int = 0xff0000ff; // FURNITURE "WOOD" [BLUE]
	public static var WALL:Int = 0xff000000; // WALL [BLACK]
	public static var HIGHLIGHT:Int = 0xfffb0007; // HIGHLIGHT [RED]

	public static var BASTARD_REPLACEMENT:Int = 0xffffffff;
	public static var WALL_REPLACEMENT:Int = 0xff000000;
	public static var FURNITURE_REPLACEMENT:Int = 0xff0000ff;
	public static var OTHER_REPLACEMENT:Int = 0xff36ff07;
	public static var HIGHLIGHT_REPLACEMENT:Int = 0xfffb0007;

	public static var COLOURS:Array<Int> = [
	0xffff6666, // pink -> bastard
	0xff66ffff, // cyan -> other
	0xffffff66, // yellow -> furniture
	0xff66ff66, // green -> walls
	0xff6666ff, // purple -> highlight
	0xffffcc66, // orange -> bg
	];

	// public static var BASTARD_COLOURS:Array<Int> = [
	// 0xffff6666, // pink -> bastard
	// 0xff66ffff, // cyan -> other
	// 0xffffff66, // yellow -> furniture
	// 0xff66ff66, // green -> walls
	// 0xff6666ff, // purple -> highlight
	// 0xffffcc66, // orange -> bg
	// ];

	// public static var OTHER_COLOURS:Array<Int> = [
	// 0xffff6665, // pink -> bastard
	// 0xff66fffe, // cyan -> other
	// 0xffffff65, // yellow -> furniture
	// 0xff66ff65, // green -> walls
	// 0xff6666fe, // purple -> highlight
	// 0xffffcc65, // orange -> bg
	// ];

	// public static var FURNITURE_COLOURS:Array<Int> = [
	// 0xffff6656, // pink -> bastard
	// 0xff66ffef, // cyan -> other
	// 0xffffff56, // yellow -> furniture
	// 0xff66ff56, // green -> walls
	// 0xff6666ef, // purple -> highlight
	// 0xffffcc56, // orange -> bg
	// ];

	// public static var WALL_COLOURS:Array<Int> = [
	// 0xffff6566, // pink -> bastard
	// 0xff66feff, // cyan -> other
	// 0xfffffe66, // yellow -> furniture
	// 0xff66fe66, // green -> walls
	// 0xff6665ff, // purple -> highlight
	// 0xffffcb66, // orange -> bg
	// ];

	// public static var HIGHLIGHT_COLOURS:Array<Int> = [
	// 0xffff5666, // pink -> bastard
	// 0xff66efff, // cyan -> other
	// 0xffffef66, // yellow -> furniture
	// 0xff66ef66, // green -> walls
	// 0xff6656ff, // purple -> highlight
	// 0xffffbc66, // orange -> bg
	// ];
}




