class QuestionLike

    attr_accessor :id, :user_id, :question_id

    def self.all
        data = PlayDBConnection.instance.execute("SELECT * FROM question_likes")
        data.map {|element| QuestionLike.new(element)}
    end

    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end

    def self.likers_for_question_id(q_id)
        data = PlayDBConnection.instance.execute(<<-SQL, q_id)
            SELECT
                users.*
            FROM
                question_likes
            JOIN users ON users.id = question_likes.user_id
            WHERE question_likes.question_id = ?
        SQL

        data.map { |ele| User.new(ele) }
    end

    def self.num_likes_for_question_id(q_id)
        data = PlayDBConnection.instance.execute(<<-SQL, q_id)
            SELECT
                count(*) AS ct
            FROM question_likes
            WHERE question_id = ?
        SQL

        data[0]['ct']
    end

    def self.liked_questions_for_user_id(u_id)
        data = PlayDBConnection.instance.execute(<<-SQL, u_id)
            SELECT
                questions.*
            from question_likes
            JOIN questions ON questions.id = question_likes.question_id
            WHERE question_likes.user_id = ?
        SQL

        data.map {|ele| Question.new(ele)}
    end

    def self.most_liked_questions(n)
        data = PlayDBConnection.instance.execute(<<-SQL, n)
            SELECT
                questions.id, questions.title, questions.body, questions.user_id
            FROM question_likes
            JOIN questions ON questions.id = question_likes.question_id
            GROUP BY questions.id, questions.title, questions.body, questions.user_id
            ORDER BY count(*) DESC
            LIMIT ?;
        SQL

        data.map { |ele| Question.new(ele) }
    end


end
