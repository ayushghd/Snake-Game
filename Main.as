
package{	
	import flash.utils.getTimer;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.media.SoundChannel;
	import flash.media.Sound;
	public class Main extends MovieClip
	{
		const speed:int = 5;
		var flag2=0;
		var flag3=0;
		var flag4=0;
		var elapsedtime=0;
		var smiletime=0;
		var bonustime=0;
		var bullet:Bullet;
		var smile:Smile1;
		var backmusic:Playback=new Playback();
		var backmusic_chn:SoundChannel = new SoundChannel();
		var spinc:Number=0;
		var vx:int;
		var vy:int;
		var flag:int=0;
		var bonus:Bonus=new Bonus();
		var score:int;
		var Snake:Array;
		var gfood:Food;
		var highscore = 0;
		var levelno = 1;
		var Snakedirection:String;
		var head:SnakePart;
		
		public function Main(){
			backmusic_chn = backmusic.play(0,int.MAX_VALUE);
			init();
		}
		public function init():void{
			vx = 1;
			vy = 0;
			score=0;
			Snake = new Array();
			Snakedirection = "";
			addfood();
			head = new SnakePart();
			head.x = stage.stageWidth/2;
			head.y = stage.stageHeight/2;
			Snake.push(head);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onkeydown);
			stage.addEventListener(KeyboardEvent.KEY_UP,onkeyup);
			addEventListener(Event.ENTER_FRAME,loop);
		}
		public function addfood()
		{
			gfood = new Food();
			gfood.x = 50 + Math.random()*(stage.stageWidth - 100);
			gfood.y = 50 + Math.random()*(stage.stageHeight - 100);
			addChild(gfood);
		}
		public function addsmile()
		{
			smile = new Smile1();
			smile.x = 50 + Math.random()*(stage.stageWidth - 100);
			smile.y = 50 + Math.random()*(stage.stageHeight - 100);
			addChild(smile);
		}
		public function addbonus()
		{
			bonus.x = 50 + Math.random()*(stage.stageWidth - 100);
			bonus.y = 50 + Math.random()*(stage.stageHeight - 100);
			addChild(bonus);
		}
		public function addbullet()
		{
			bullet=new Bullet();
			bullet.x = 50 + Math.random()*(stage.stageWidth - 100);
			bullet.y = 10;
			addChild(bullet);
		}
		public function reset()
		{
			removeChild(gfood);
			score=0;
			levelno=1;
			addfood();
			head.x = stage.stageWidth/2;
			head.y = stage.stageHeight/2;
			addChild(head);
			vx = 1; vy=0;spinc=0;
			for(var i=Snake.length - 1; i > 1;i--)
			{
				removeChild(Snake[i]);
				Snake.splice(i,1);
			}
			
		}
		public function onkeydown(event:KeyboardEvent)
		{
			if(event.keyCode == Keyboard.UP)
				Snakedirection = "up";
			else if(event.keyCode == Keyboard.RIGHT)
				Snakedirection = "right";
			else if(event.keyCode == Keyboard.LEFT)
				Snakedirection = "left";
			else if(event.keyCode == Keyboard.DOWN)
				Snakedirection = "down";
		}
		public function onkeyup(event:KeyboardEvent)
		{
			if(event.keyCode == Keyboard.UP)
				Snakedirection = "";
			else if(event.keyCode == Keyboard.RIGHT)
				Snakedirection = "";
			else if(event.keyCode == Keyboard.LEFT)
				Snakedirection = "";
			else if(event.keyCode == Keyboard.DOWN)
				Snakedirection = "";
		}
		public function loop(event:Event):void
		{
			elapsedtime = getTimer();
			if(elapsedtime - bonustime >= 2000 && flag2==1){
				removeChild(bonus);
				flag=0;
				flag2=0;
			}
			if(elapsedtime - smiletime >= 2000 && flag4==1){
				removeChild(smile);
				flag4=0;
			}
			if(Snakedirection == "left" && vx!=1)
			{	vx=-1;
				vy=0;
			}
			else if(Snakedirection == "right" && vx!=-1)
				{vx=1;
				vy=0;}
			else if(Snakedirection == "up" && vy!=1)
			{	vx=0;
				vy=-1;
			}
			else if(Snakedirection == "down" && vy!=-1)
			{	vx=0;
				vy=1;
			}
			
			if(head.x <= head.width/2)
			{	score=0;
				reset();
			}
			else if(head.x + head.width/2 > stage.stageWidth)
			{	score=0;
				reset();
			}
			if(head.y <= head.height/2)
			{
				score=0;
				reset();
			}
			else if(head.y + head.height/2 >= stage.stageHeight)
			{	score=0;
				reset();
			}
			for(var i = Snake.length-1; i >0;i--)
			{
				Snake[i].x = Snake[i-1].x;
				Snake[i].y = Snake[i-1].y;
			}
			if(vx<0)
			head.x += (vx)*speed-spinc;
			else if(vx>0)
			head.x += (vx)*speed+spinc;
			else
			head.x += (vx)*speed;
			
			if(vy<0)
			head.y += (vy)*speed-spinc;
			else if(vy>0)
			head.y += (vy)*speed+spinc;
			else
			head.y += vy*speed;
			for(i=Snake.length - 1; i>0;i--)
			{
				if(Snake[0].x == Snake[i].x && Snake[0].y==Snake[i].y)
				{
					reset();
					break;
				}
			}
			if(head.hitTestObject(gfood)){
				spinc+=(0.5);
				score += 1;
				removeChild(gfood);
				addfood();
				if(score%10==0 && score>0){
					addbonus();
					bonustime=getTimer();
					flag=1;
					flag2=1;
				}
				if(score%15==0 && score>0 && flag4==0){
					addsmile();
					smiletime = getTimer();
					flag4=1;
				}
				var nextpart = new SnakePart();
				nextpart.x = Snake[Snake.length-1].x;
				nextpart.y = Snake[Snake.length-1].y;
				Snake.push(nextpart);
				addChild(nextpart);
			}
			if(flag4==1 && head.hitTestObject(smile)){
				spinc-=0.5;
				flag4=0;
				removeChild(smile);
				
					
			}
			if(flag==1 && head.hitTestObject(bonus)){
				flag2=0;
				spinc+=(0.5);
				score += 5;
				removeChild(bonus);
				flag=0;
			}
			if(flag3==1)
			{
				if(bullet.y<400)
					bullet.y += 5; 
				else
				{
					removeChild(bullet);
					flag3=0;
				}
			}
			if(flag3==1)
			{
				for(var j=Snake.length - 1; j>=0;j--)
				{
					if(Snake[j].hitTestObject(bullet))
					{
						removeChild(bullet);
						flag3=0;
						reset();
						break;
					}
				}
			}
			Scoretext.text = score.toString() ;
			level.text = levelno.toString();
			if(score>highscore){
				highscore=score;
				high.text = highscore.toString();
			}
			if(score>=20&&flag3==0&&(score-20)%5==0)
			{
				levelno=score/20+1;
				flag3=1;
				addbullet();
			}
		}
		
		
	}
	
}