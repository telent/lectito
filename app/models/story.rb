class Story 
  def self.for_events events
    story=nil
    s=[]
    if events then
      events.each do |e|
        if story && story.accepts_event?(e) then
          story.add_event e
        else
          if story then 
            s << story
          end
          story=Story.new
          story.add_event e
          story.created_at=e.created_at
        end
      end
      s << story
    end
    s
  end

  attr_accessor :events,:created_at

  def image
    nil
  end

  def initialize(*args)
    @events||=[]
    super
  end
  
  def books 
    @events.map(&:book).uniq
  end
  
  [:action,:actor,:recipient].each do |m|
    define_method m do
      @events[0].send(m)
    end
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
  def to_partial_path
    self.action.to_s
  end

  def book_names_truncated
    c=self.books.count
    examples=self.books[0..3]
    if c<=examples.count then
      examples.map {|b| "#{b.title} by #{b.author}" }.to_sentence
    else
      names=examples.map {|b| "#{b.title} by #{b.author}"  }.join(", ")
      "#{names} and #{c-examples.count} other books"
    end
  end
end
