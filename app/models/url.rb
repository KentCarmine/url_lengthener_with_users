class Url < ActiveRecord::Base
  belongs_to :user
  before_save :set_longer_url
  before_save :initialize_click_count
  validates :long_url, format: { with: /^https?:\/\/.+(\..{2,5}).*$/, message: "Must be a valid url."}

  def increment_click_count
    incremented_counter = self.click_count + 1
    write_attribute(:click_count, incremented_counter)
    self.save
  end

  def set_longer_url
    unless longer_url
      longer_url = generate_random_string
      write_attribute(:longer_url, longer_url)
    end
  end

  def generate_random_char
    char_list = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    char_index = rand(0..61)
    char = char_list[char_index]
    char
  end

  def generate_random_string
    random_str = ""

    140.times do
      random_str += generate_random_char
    end

    random_str
  end

  def initialize_click_count
    self.click_count ||= 0
    write_attribute(:click_count, self.click_count)
  end
end
