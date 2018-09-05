require 'byebug'
require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton
  
  def initialize 
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end 
end 

class User
  attr_accessor :fname, :lname
  
  def self.all 
    data = QuestionsDatabase.instance.execute("SELECT * FROM users")
    data.map { |datum| User.new(datum) }
  end 
  
  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute("SELECT * FROM users WHERE users.id = ?", id)
    User.new(data.first)
  end
  
  def self.find_by_name(fname, lname)
    data = QuestionsDatabase.instance.execute("SELECT * FROM users WHERE users.fname = ? AND users.lname = ?", fname, lname)
    User.new(data.first)
  end 
  
  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end
  
  def authored_questions
    Question.find_by_user_id(@id)
  end
  
  def authored_replies
    Reply.find_by_user_id(@id)
  end
end 

class Question 
  attr_accessor :title, :body, :user_id
  
  def self.all 
    data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
    data.map { |datum| Question.new(datum) }
  end 
  
  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute("SELECT * FROM questions WHERE questions.id = ?", id)
    Question.new(data.first)
  end
  
  def self.find_by_user_id(user_id)
    data = QuestionsDatabase.instance.execute("SELECT * FROM questions WHERE questions.user_id = ?", user_id)
    Question.new(data.first)
  end
  
  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end
  
  def author
    QuestionsDatabase.instance.execute("SELECT fname, lname FROM users WHERE ? = users.id", @user_id)
  end
  
  def replies 
    Reply.find_by_question_id(@id)
  end
  
end 

class QuestionFollow 
  attr_accessor :user_id, :question_id
  
  def self.all 
    data = QuestionsDatabase.instance.execute("SELECT * FROM question_follows")
    data.map { |datum| QuestionFollow.new(datum) }
  end 
  
  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute("SELECT * FROM question_follows WHERE question_follows.id = ?", id)
    QuestionFollow.new(data.first)
  end
  
  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end
  
end

class Reply
  attr_accessor :user_id, :question_id, :parent_id, :body
  
  def self.all 
    data = QuestionsDatabase.instance.execute("SELECT * FROM replies")
    data.map { |datum| Reply.new(datum) }
  end 
  
  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute("SELECT * FROM replies WHERE replies.id = ?", id)
    Reply.new(data.first)
  end
  
  def self.find_by_user_id(user_id)
    data = QuestionsDatabase.instance.execute("SELECT * FROM replies WHERE replies.user_id = ?", user_id)
    Reply.new(data.first)
  end
  
  def self.find_by_question_id(question_id)
    data = QuestionsDatabase.instance.execute("SELECT * FROM replies WHERE replies.question_id = ?", question_id)
    Reply.new(data.first)
  end
  
  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @body = options['body']
  end
  
  def author
    QuestionsDatabase.instance.execute("SELECT fname, lname FROM users WHERE ? = users.id", @user_id)
  end
end 

class QuestionLike
  attr_accessor :user_id, :question_id
  
  def self.all 
    data = QuestionsDatabase.instance.execute("SELECT * FROM question_likes")
    data.map { |datum| QuestionLike.new(datum) }
  end 
  
  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute("SELECT * FROM question_likes WHERE question_likes.id = ?", id)
    QuestionLike.new(data.first)
  end
  
  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
  end
end