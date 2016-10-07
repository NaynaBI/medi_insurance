class Agent < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :validatable, :registerable

  has_many :applicants

  def self.general
    Agent.find_by_name("General")
  end

  def self.find_or_create_agent(email)
    agent = Agent.find_by_email(email)

    unless agent
      agent = Agent.new(email: email)
      agent.password = "123456"
      agent.save
    end

    agent
  end
end
