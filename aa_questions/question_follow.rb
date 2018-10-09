require_relative 'requires'
require 'byebug'

class QuestionFollow

  attr_accessor :id, :question_id, :user_id

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM question_follows")
    data.map { |datum| QuestionFollow.new(datum) }
  end

  def self.find_by_id(id)
    follower = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL
    return nil unless follower.length > 0
    QuestionFollow.new(follower.first)
  end

  def self.followers_for_question_id(question_id)
    followers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        user_id
      FROM
        question_follows
      JOIN
        users ON question_follows.user_id = users.id
      WHERE
        question_id = ?
    SQL
    return nil if followers.empty?
    followers.map { |follower| User.find_by_id(follower['user_id']) }
  end

  def self.followed_questions_for_user_id(user_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        question_id
      FROM
        question_follows
      JOIN
        users ON question_follows.user_id = users.id
      WHERE
        user_id = ?
    SQL
    return nil if questions.empty?
    questions.map { |question| Question.find_by_id(question['question_id']) }
  end

  def self.most_followed_questions(n = 1)
    questions = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        *, COUNT(question_id)
      FROM
        question_follows
      JOIN
        questions ON question_follows.question_id = questions.id
      GROUP BY
        question_id
      LIMIT
        1
      OFFSET
        ? - 1;
    SQL
    return nil if questions.empty?
    byebug
    Question.find_by_id(questions.first['question_id'])
  end

  def initialize(options)
    @id, @user_id, @question_id = options.values_at('id', 'user_id', 'question_id')
  end
end
