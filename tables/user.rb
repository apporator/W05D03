class User < Table
    @@table_name = 'users'

    attr_accessor :id, :fname, :lname, :table_name

    def self.table_name
        return @@table_name
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
        return nil if self.authored_questions.empty?
        # count of likes / #count of questions
        data = PlayDBConnection.instance.execute(<<-SQL, self.id)
            SELECT
                COUNT(DISTINCT question_likes.id)/ cast ( COUNT(DISTINCT question_likes.question_id) as float) as avg_q  
            FROM users
            LEFT JOIN questions on questions.user_id = users.id
            LEFT JOIN question_likes on question_likes.question_id = questions.id
            WHERE users.id = ?;
        SQL

        data[0]['avg_q']
        # c1 = user id, c2 = number of questions THEY asked, c3 = number of likes their questions have gotten
    end

    def save
        return false if self.id

        data = PlayDBConnection.instance.execute(<<-SQL, self.fname, self.lname)
        INSERT INTO
            users(fname, lname)
        VALUES
            (?,?)
        SQL

        return self
    end

    def update
        return false if self.id.nil?

        data = PlayDBConnection.instance.execute(<<-SQL, self.fname, self.lname, self.id)
            UPDATE
                users
            SET
                fname = ?, lname = ?
            where id = ?
        SQL

        return self
    end
end
