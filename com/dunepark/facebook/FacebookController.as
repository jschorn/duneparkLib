package com.dunepark.facebook
{
	import com.dunepark.facebook.events.FacebookEvent;
	import com.dunepark.facebook.objects.LikeVO;
	import com.dunepark.facebook.objects.PostVO;
	import com.dunepark.facebook.objects.UserVO;
	import com.facebook.graph.Facebook;
	
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	
	[Event(name="com.dunepark.facebook.events.FacebookEvent.LOGIN_FAIL", type="com.dunepark.facebook.events.FacebookEvent")]
	
	public class FacebookController extends EventDispatcher
	{
		public var isAuthenticated:Boolean = false;

		private var _token:String;
		private var _secret:String;
		private var _sessionKey:String;
		private var _sig:String;
		private var _appId:String;
		private var _permissions:String;
		private var _user:UserVO;				
		private var _likes:Vector.<LikeVO>;
		private var _friends:Vector.<UserVO>;
		private var _posts:Vector.<PostVO>;

		public function get posts():Vector.<PostVO>
		{
			return _posts;
		}

		public function set posts(value:Vector.<PostVO>):void
		{
			_posts = value;
		}

		public function get friends():Vector.<UserVO>
		{
			return _friends;
		}

		public function set friends(value:Vector.<UserVO>):void
		{
			_friends = value;
		}

		public function get user():UserVO
		{
			return _user;
		}
		
		public function set user(value:UserVO):void
		{
			_user = value;
		}
		
		public function get likes():Vector.<LikeVO>
		{
			return _likes;
		}
		
		public function set likes(value:Vector.<LikeVO>):void
		{
			_likes = value;
		}
		
		/////////////// CONSTRUCTOR /////////////// 
		
		public function FacebookController( appId:String, permissions:String )
		{
			_appId = appId;
			_permissions = permissions;
			init();
		}
		
		//////////////// PUBLIC METHODS /////////////
		
		public function login(event:MouseEvent = null, authenticateInPopup:Boolean = true, redirectURL:String = ""):void
		{
			if (authenticateInPopup)
				Facebook.login(loginHandler,{perms:_permissions});
			else
				ExternalInterface.call("redirect", _appId, _permissions, redirectURL);
		}

		public function getLikes():void
		{
			Facebook.api("/me/likes",getLikesHandler);
		}
		
		public function getFriends():void
		{
			Facebook.api("/me/friends", getFriendsHandler);
		}	
		
		public function getPosts():void
		{
			Facebook.api("/me/posts", getPostsHandler);
		}
		
		public function postImageToPhotos(bitmapData:BitmapData, caption:String):void
		{
			var values:Object = {message:caption, fileName:'FILE_NAME', image:bitmapData};
			Facebook.api('/me/photos', handleUploadComplete, values, 'POST');
		}
		
		public function postToFeed(message:String, name:String, description:String, link:String="", picture:String="", caption:String = ""):void
		{
			var values:Object = {message:message, name:name, description:description, picture:picture, caption:caption, link:link}; 				
			Facebook.api('/me/feed', handleUploadComplete, values, 'POST');
		}
		
		public function updateProfilePicture( photoID:String ):void
		{
			navigateToURL(new URLRequest( "http://www.facebook.com/photo.php?fbid=" + photoID + "&makeprofile=1" ) );				
		}
		
		//////////////// PRIVATE METHODS ////////////
		
		private function init():void
		{
			ExternalInterface.addCallback("onLoginStatusChange", onLoginStatusChange);
			Facebook.init(_appId,loginHandler);
		} 
		
		private function parseFriends( data:Object ):Vector.<UserVO>
		{
			var friendsCollection:Vector.<UserVO> = new Vector.<UserVO>;
			for each (var friendObject:Object in data)
			{
				var friend:UserVO = new UserVO( friendObject);
				friend.imageURLSmall = Facebook.getImageUrl( friend.id, "square");
				friend.imageURLLarge = Facebook.getImageUrl( friend.id, "large");
				friendsCollection.push( friend );
			}			
			return friendsCollection;
		}
		
		////////// EVENT HANDLERS //////////////// 
		
		
		protected function handleUploadComplete(response:Object, fail:Object):void 
		{
			if (response!=null)
				dispatchEvent( new FacebookEvent(FacebookEvent.POST_PHOTO_SUCCESS, response) );
			
			else 
				dispatchEvent( new FacebookEvent(FacebookEvent.POST_PHOTO_FAIL, fail) );
		}

		private function onLoginStatusChange(status:String = null):void
		{
			trace("FacebookController.onLoginStatusChange :: " + status);
		}
		
		protected function loginHandler(success:Object,fail:Object):void
		{
			if(success)
			{    
				trace("FacebookController.loginHandler :: SUCCESS");
				_token = success.accessToken;
				_secret = success.secret;
				_sessionKey = success.sessionKey;
				_sig = success.sig;
				this.isAuthenticated = true;
				Facebook.api("/me",getMeHandler);				
				dispatchEvent( new FacebookEvent(FacebookEvent.LOGIN_SUCCESS) );
			}
			else
			{
				trace("FacebookController.loginHandler :: FAIL");
				dispatchEvent( new FacebookEvent(FacebookEvent.LOGIN_FAIL) );
			}
		}
		
		protected function getFriendsHandler(result:Object,fail:Object):void
		{
			trace("FacebookController.getFriendsHandler");
			if (fail == null)
			{
				this.friends = parseFriends( result );
				dispatchEvent( new FacebookEvent(FacebookEvent.GET_FRIENDS_SUCCESS) );	
			}
			else
			{
				dispatchEvent( new FacebookEvent(FacebookEvent.GET_FRIENDS_FAIL) );				
			}
		}
		
		protected function getMeHandler(result:Object,fail:Object):void
		{
			trace("FacebookController.getMeHandler");
			if (fail == null)
			{
				user = new UserVO( result );
				user.imageURLSmall = Facebook.getImageUrl( user.id, "square");
				user.imageURLLarge = Facebook.getImageUrl( user.id, "large");
				dispatchEvent( new FacebookEvent(FacebookEvent.GET_USER_SUCCESS) );				
			}
			else
			{
				dispatchEvent( new FacebookEvent(FacebookEvent.GET_USER_FAIL) );				
			}
		}
		
		private function getLikesHandler(result:Object, fail:Object):void
		{
			trace("FacebookController.getLikesHandler");
			if (fail == null)
			{
				likes = new Vector.<LikeVO>;
				for each (var likeObject:Object in result)
				{
					var like:LikeVO = new LikeVO ( likeObject );
					likes.push( like );
				}
				dispatchEvent( new FacebookEvent(FacebookEvent.GET_LIKES_SUCCESS) );
			}
			else
			{
				dispatchEvent( new FacebookEvent(FacebookEvent.GET_LIKES_FAIL) );				
			}			
			
		}
		
		private function getPostsHandler(result:Object, fail:Object):void
		{
			posts = new Vector.<PostVO>;
			if (fail == null)
			{
				for each (var postObject:Object in result)
				{
					var post:PostVO = new PostVO( postObject );
					posts.push( post );	
				}
				dispatchEvent( new FacebookEvent(FacebookEvent.GET_USER_POSTS_SUCCESS) );	
			}
			else
			{
				dispatchEvent( new FacebookEvent(FacebookEvent.GET_USER_POSTS_FAIL) );	
			}
				
		}
	}
}