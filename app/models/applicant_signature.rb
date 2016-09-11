class ApplicantSignature < ActiveRecord::Base
  HEIGHT = 160
  WIDTH = 480

  belongs_to :applicant

  before_validation :generate_image

  has_attached_file :image

  validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }

  def generate_image
    require 'open3'
    instructions = JSON.parse(data).map { |h| "line #{h['mx'].to_i},#{h['my'].to_i} #{h['lx'].to_i},#{h['ly'].to_i}" } * ' '
    tempfile = Tempfile.new(["signature", '.png'])
    Open3.popen3("convert -size 298x55 xc:transparent -stroke blue -draw @- #{tempfile.path}") do |input, output, error|
      input.puts instructions
    end
    self.image = tempfile
  end
end
