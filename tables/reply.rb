class Reply

    attr_accessor :id, :question_id, :parent_reply, :user_id, :body

    def self.all
        data = PlayDBConnection.instance.execute("SELECT * FROM replies")
        data.map {|element| Reply.new(element)}
    end

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @parent_reply = options['parent_reply']
        @user_id = options['user_id']
        @body = options['body']
    end

    def author
        User.find_by_id(self.user_id)
    end

    def question
        Question.find_by_id(self.question_id)
    end

    def self.find_by_id(id)
        data = PlayDBConnection.instance.execute(<<-SQL, id)
            SELECT
            *
            FROM replies
            WHERE id = ?
        SQL

        Reply.new(data.first) if result?(data)
    end

    def parent_reply
        Reply.find_by_id(self.parent_reply)
    end

    def self.result?(data)
        if data.empty?
            puts "No entry found."
            return false
        else
            return true
        end
    end

    def child_replies
        # Reply.find_by_id(self.parent_reply) if parent_reply
    end
end