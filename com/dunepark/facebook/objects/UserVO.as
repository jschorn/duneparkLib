package com.dunepark.facebook.objects
{
	public class UserVO
	{
		public var name:String;
		public var firstName:String;
		public var lastName:String;
		public var gender:String;
		public var birthday:String;
		public var link:String;
		public var age:int;
		public var id:String;
		public var imageURLSmall:String;
		public var imageURLLarge:String;
		public var relationshipStatus:String;
	
		public function UserVO( userObject:Object )
		{
			this.name = userObject.name;
			this.firstName = userObject.first_name;
			this.lastName = userObject.last_name;
			this.gender = userObject.gender;
			this.link = userObject.link;
			this.id = userObject.id;
			
			if(userObject.birthday)
				this.birthday = userObject.birthday;

			if (userObject.relationship_status)
				this.relationshipStatus = userObject.relationship_status;
			
			if (this.birthday != "" && this.birthday != null)
			{
				var dateArray:Array = this.birthday.split("/");
				var birthYear:int = int(dateArray[2]);
				this.age = new Date().getFullYear() - birthYear;
			}
		}
	}
}