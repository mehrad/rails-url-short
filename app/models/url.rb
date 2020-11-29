class Url < ApplicationRecord
    belongs_to :user, optional: true

    default_scope { order(created_at: :desc) }

    validates :url, presence: true, on: :create
    validates_format_of :url,
      with: /\A(?:(?:http|https):\/\/)?([-a-zA-Z0-9.]{2,256}\.[a-z]{2,4})\b(?:\/[-a-zA-Z0-9@,!:%_\+.~#?&\/\/=]*)?\z/
    validates :short_url, uniqueness: true,  presence: true

    paginates_per 20

    def set_short_url
      return if !self.short_url.blank?

      self.short_url = generate_short_url

      self.short_url = generate_short_url until short_url_already_exist?
    end

    def generate_short_url
      chars = ['0'..'9','A'..'Z','a'..'z'].map{|range| range.to_a}.flatten
      6.times.map{chars.sample}.join
    end

    def short_url_already_exist?
      Url.find_by_short_url(self.short_url).nil?
    end

    def sanitize
      self.url.strip!
      self.sanitized_url = self.url.downcase.gsub(/(https?:\/\/)|(www\.)/, "")
      self.sanitized_url.slice!(-1) if self.sanitized_url[-1] == "/"
      self.sanitized_url = "http://#{self.sanitized_url}"
    end

    def short_url_admin
      "#{self.short_url}+"
    end

    def add_click_count!
      self.click_count +=1
      self.save!
    end

end
