require 'rails_helper'

RSpec.describe Url, type: :model do

  it "is valid with a valid url" do
    url = build(:url)
    expect(url).to be_valid
  end

  it "is invalid without a url" do
    url = build(:url, url: nil)
    url.valid?
    expect(url.errors[:url]).to include("Please enter the URL you want to shorten")
  end

  it "is invalid with an invalid URL" do
    url = build(:url, url: "abc")
    url.valid?
    expect(url.errors[:url]).to include("Please enter a valid URL")
  end

  describe "method" do
    before :each do
      @url_google = create(:url, url: "google.com")
      @url_google.sanitize
      @url_google.save
    end

    it "#generate_short_url generates a 6-char string containing only letters and numbers" do
      url = build(:url)
      url.generate_short_url
      expect(url.short_url).to match(/\A[a-z\d]{6}\z/i)
    end

    xit "#generate_short_url always generates a short_url that is not in the database" do
    end

    context "#sanitize" do
      it "changes 'www.google.com' to 'http://google.com'" do
        url = build(:url, url: 'www.google.com')
        url.sanitize
        expect(url.sanitized_url).to eq('http://google.com')
      end

      it "changes 'www.google.com/' to 'http://google.com'" do
        url = build(:url, url: 'www.google.com/')
        url.sanitize
        expect(url.sanitized_url).to eq('http://google.com')
      end

      it "changes 'google.com' to 'http://google.com'" do
        url = build(:url, url: 'google.com')
        url.sanitize
        expect(url.sanitized_url).to eq('http://google.com')
      end

      it "changes 'https://www.google.com' to 'http://google.com'" do
        url = build(:url, url: 'https://www.google.com')
        url.sanitize
        expect(url.sanitized_url).to eq('http://google.com')
      end

      it "changes 'http://www.google.com' to 'http://google.com'" do
        url = build(:url, url: 'http://www.google.com')
        url.sanitize
        expect(url.sanitized_url).to eq('http://google.com')
      end

      it "changes 'www.github.com/DatabaseCleaner/database_cleaner/' to 'http://github.com/DatabaseCleaner/database_cleaner'" do
        url = build(:url, url: 'www.github.com/DatabaseCleaner/database_cleaner/')
        url.sanitize
        expect(url.sanitized_url).to eq('http://github.com/databasecleaner/database_cleaner')
      end

      it "strips leading spaces from url" do
        url = build(:url, url: '  http://www.google.com')
        url.sanitize
        expect(url.url).to eq('http://www.google.com')
      end

      it "strips trailing spaces from url" do
        url = build(:url, url: 'http://www.google.com  ')
        url.sanitize
        expect(url.url).to eq('http://www.google.com')
      end

      it "dowcases url before saving it as sanitized_url" do
        url = build(:url, url: 'Google.com')
        url.sanitize
        expect(url.sanitized_url).to eq('http://google.com')
      end

    end
  end

  describe "is valid with the follwing urls:" do
    it "Normal url" do
      url = build(:url, url: "http://www.google.com")
      expect(url).to be_valid
    end

    it "Url with forward slash at the end" do
      url = build(:url, url: "http://www.google.com/")
      expect(url).to be_valid
    end

    it "Secured https url" do
      url = build(:url, url: "https://www.google.com")
      expect(url).to be_valid
    end

    it "Url without www at the beginning" do
      url = build(:url, url: "https://google.com")
      expect(url).to be_valid
    end

    it "Url without http at the beginning" do
      url = build(:url, url: "google.com")
      expect(url).to be_valid
    end

    it "Url with only dot com at the end" do
      url = build(:url, url: "google.com")
      expect(url).to be_valid
    end

    it "Google map url" do
      url = build(:url, url: "https://www.google.com/search?q=gapfish&oq=gapfish&aqs=chrome.0.69i59j0j69i60l3j69i61j69i65j69i60.3005j0j7&sourceid=chrome&ie=UTF-8")
      expect(url).to be_valid
    end

    it "Google search url" do
      url = build(:url, url: "https://www.google.com/search?newwindow=1&espv=2&biw=1484&bih=777&tbs=qdr%3Am&q=rspec+github&oq=rspec+g&gs_l=serp.1.2.0i20j0l9.10831.11965.0.13856.2.2.0.0.0.0.97.185.2.2.0....0...1c.1.64.serp..0.2.183.kqo6B3dAGtE")
      expect(url).to be_valid
    end

    it "Url with dash" do
      url = build(:url, url: "my-google.com")
      expect(url).to be_valid
    end

    it "Url with sharps" do
      url = build(:url, url: "https://en.wikipedia.org/wiki/HTML_element#Anchor")
      expect(url).to be_valid
    end

    it "Url with passifix for file" do
      url = build(:url, url: "https://gapfish.com/wp-content/uploads/2018/11/GapFish_Panelbook_2018_EN.pdf")
      expect(url).to be_valid
    end

    it "Url with number" do
      url = build(:url, url: "https://www.linkedin.com/company/gapfish-gmbh/?miniCompanyUrn=urn%3Ali%3Afs_miniCompany%3A9488072&lipi=urn%3Ali%3Apage%3Ad_flagship3_company%3BhbnenQNjTziep2AlZme7yg%3D%3D&licu=urn%3Ali%3Acontrol%3Ad_flagship3_company-actor_container&lici=xdF6E5v6RUCohyCkedZ0JA%3D%3D")
      expect(url).to be_valid
    end

    it "Youtube url" do
      url = build(:url, url: "https://www.youtube.com/watch?v=Q6otLsSRBqU")
      expect(url).to be_valid
    end

    it "Challange test case" do
      url = build(:url, url: "https://devs.gapfish.com/")
      expect(url).to be_valid
    end
  end
end
