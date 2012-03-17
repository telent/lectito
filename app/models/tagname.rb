class Tagname
  attr_reader :id,:mycount,:allcount
  def initialize(id,mycount,allcount)
    @id,@mycount,@allcount=[id,mycount,allcount]
  end

  def self.find(name,user=nil)
    user_id=user ? user.id : 0

    h=Tag.connection.select_all("select name as id,count(nullif(user_id="+
                                ActiveRecord::Base.sanitize(user_id)+
                                ",0))  as mycount,count(distinct user_id) as allcount from tags where name="+
                                ActiveRecord::Base.sanitize(name)+
                                "group by name;").first
    self.new h['id'],h['mycount'],h['allcount'] 
  end
  
  def self.all(user=nil)
    user_id=user ? user.id : 0
    Tag.connection.select_all("select name as id,count(nullif(user_id="+
                              ActiveRecord::Base.sanitize(user_id)+
                              ",0))  as mycount,count(distinct user_id) as allcount from tags group by name;").map {|h|
      self.new h['id'],h['mycount'],h['allcount'] 
    }
  end    
end
