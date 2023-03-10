class Question < Table
    attr_accessor :id, :title, :body, :user_id

    def self.table_name
        return @@table_name
    end

    @@table_name = 'questions'
    # include TableHelper

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @user_id = options['user_id']
    end

    def self.find_by_id(id)
        data = PlayDBConnection.instance.execute(<<-SQL, id)
            SELECT
            *
            FROM questions
            WHERE id = ?
        SQL

        Question.new(data.first) if result?(data)
    end

    def self.find_by_author_id(user_id)
        data = PlayDBConnection.instance.execute(<<-SQL, user_id)
            SELECT
            *
            FROM questions
            WHERE user_id = ?
        SQL

        data.map {|element| Question.new(element)} if result?(data)
    end

    def self.result?(data)
        if data.empty?
            puts "No entry found."
            return false
        else
            return true
        end
    end

    def author
        data = PlayDBConnection.instance.execute(<<-SQL,self.id)
        SELECT
            *
        FROM questions
        WHERE user_id = ?
        SQL

        data.map {|ele| Question.new(ele)} if result?(data)
    end

    def replies
        Reply.find_by_question_id(self.id)
    end

    def followers
        QuestionFollow.followers_for_question_id(self.id)
    end

    def self.most_followed(n)
        QuestionFollow.most_followed_questions(n)
    end

    def likers
        QuestionLike.likers_for_question_id(self.id)
    end

    def num_likes
        QuestionLike.num_likes_for_question_id(self.id)
    end
# update these
    def save
        return false if self.id

        data = PlayDBConnection.instance.execute(<<-SQL, self.title, self.body, self.user_id)
        INSERT INTO
            questions(title, body, user_id)
        VALUES
            (?,?,?)
        SQL

        return self
    end

    def update
        return false if self.id.nil?

        data = PlayDBConnection.instance.execute(<<-SQL, self.title, self.body, self.user_id, self.id)
            UPDATE
                questions
            SET
                title = ?, body = ?, user_id = ?
            where id = ?
        SQL

        return self
    end
end


# module TableHelper
#     def self.result?(data)
#         if data.empty?
#             puts "No entry found."
#             return false
#         else
#             return true
#         end
#     end
# end