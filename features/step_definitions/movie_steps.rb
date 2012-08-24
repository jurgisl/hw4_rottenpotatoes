Given /^the following movies exist:$/ do |table|
  Movie.delete_all
  
  table.hashes.each do |movie|
    if !Movie.find_by_title(movie[:title]) then
        a = Movie.create(
        :title => movie[:title],
        :director => movie[:director],
        :rating => movie[:rating],
        :release_date => movie[:release_date]
        )
    end
  end
end

Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |title, director|
    Movie.find_by_title(title)[:director].should == director
end
