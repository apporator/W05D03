class QuestionFollow

    attr_accessor :id, :question_id, :user_id

    def self.all
        data = PlayDBConnection.instance.execute("SELECT * FROM question_follows")
        data.map {|element| QuestionFollow.new(element)}
    end

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @user_id = options['user_id']
    end

    def self.followers_for_question_id(q_id)
        data = PlayDBConnection.instance.execute(<<-SQL, q_id)     
            SELECT
            user_id
            FROM question_follows
            where question_id = ?
        SQL
        # debugger

        data.map { |pair| User.find_by_id(pair['user_id']) } if result?(data)
    end

    def self.followed_questions_for_user_id(u_id)
        data = PlayDBConnection.instance.execute(<<-SQL, u_id)     
            SELECT
            question_id
            FROM question_follows
            where user_id = ?
        SQL
        # debugger

        data.map { |pair| Question.find_by_id(pair['question_id']) } if result?(data)
    end

    

    def self.result?(data)
        if data.empty?
            puts "No entry found."
            return false
        else
            return true
        end
    end
end