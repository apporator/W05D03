class User
    # @@table_name = 'users'
    # include TableHelper

    attr_accessor :id, :fname, :lname, :table_name

    def self.all
        data = PlayDBConnection.instance.execute("SELECT * FROM users")
        data.map {|element| User.new(element)}
    end

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def self.find_by_id(id)
        # debugger

        data = PlayDBConnection.instance.execute(<<-SQL, id)
            SELECT
            *
            FROM users
            WHERE id = ?
        SQL

        User.new(data.first) if result?(data)
    end

    def self.find_by_name(fname, lname)
        data = PlayDBConnection.instance.execute(<<-SQL, fname, lname)
            SELECT
            *
            FROM users
            WHERE fname = ?
            AND lname = ?
        SQL

        User.new(data.first) if result?(data)
    end

    def self.result?(data)
        if data.empty?
            puts "No entry found."
            return false
        else
            return true
        end
    end

    def authored_questions
        Question.find_by_author_id(self.id)
    end

    def authored_replies
        Reply.find_by_user_id(self.id)
    end

    def followed_questions
        QuestionFollow.followed_questions_for_user_id(self.id)
    end

    def liked_questions
        QuestionLike.liked_questions_for_user_id(self.id)
    end

    def average_karma
        # count of likes / #count of questions
        data = PlayDBConnection.instance.execute(<<-SQL, self.id)
            SELECT
                users.fname,
                COUNT(questions.id) as q_ct,
                COUNT(question_likes.id) as l_ct
            FROM users
            LEFT JOIN questions on questions.user_id = users.id
            LEFT JOIN question_likes on question_likes.question_id = questions.id
            GROUP BY users.fname;
        SQL

        # c1 = user id, c2 = number of questions THEY asked, c3 = number of likes their questions have gotten
    end
end
