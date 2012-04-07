class Story < ActiveRecord::Base
#  belongs_to :user
  attr_accessor :events,:created_at

  def image
    nil
  end

  def save; true; end

  def initialize(*args)
    @events||=[]
    super
  end
  
  def add_event e
    @events << e
  end
  def accepts_event? ev
    if @events.empty? then true
    else
      e=@events[0]
      [:actor_id,:action,:recipient_id].map {|k| e.send(k)==ev.send(k)}.all?
    end
  end
  
  def self.list_books_truncated(events)
    c=events.count
    examples=events[0..3]
    if c<=examples.count then
      examples.map {|b| "[#{b.id}]" }.to_sentence
    else
      names=examples.map {|b| "[#{b.id}]" }.join(", ")
      "#{names} and #{c-examples.count} other books"
    end
  end

  class Join
    def finish
      e=@events[0]
      self.story="#{e.name} joined the community"
      self.save
    end
  end
  
  class New
    def finish
      e=@events[0]
      self.story="#{e.name} added #{list_books_truncated(@events)} to their library"
      self.save
    end
  end
  
  class Review
    def finish
      e=@events[0]
      self.story="#{e.name} added #{list_books_truncated(@events)} to their library"
      self.save
    end
  end

  class Follow
    def finish
      e=@events[0]
      self.story="#{e.name} is now following you"
      self.save
    end
  end

  class Message
    def finish
      e=@events[0]
      self.story=e.story
      self.save
    end
  end      
  
  class Read;end
  class Request;end
  class Lend;end
  class Return;end

end
