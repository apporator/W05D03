class Question
    attr_accessor :id, :title, :body, :user_id
    # include TableHelper

    def self.all
        data = PlayDBConnection.instance.execute("SELECT * FROM questions")
        data.map {|element| Question.new(element)}
    end

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