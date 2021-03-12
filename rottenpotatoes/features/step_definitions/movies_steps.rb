Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create movie
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

When /^I press "(.*)" button/ do |button|
  click_button button
end

Then /^the director of "(.*)" should be "(.*)"/ do |title, director|
  movie = Movie.where(title: title).first
  #expect(movie.director).to eq(director)
  director_a = movie.director
  director_a.should eq(director)
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  # expect(page.body.index(e1) < page.body.index(e2))
  
  first = (/#{e1}/ =~ page.body)
  second = (/#{e2}/ =~ page.body)
  first.should <= second
end

Then /^I should not see : (.*)/ do |movies|
  movies_a = movies.split( "," )
  movies_a.each do |movie|
    m = movie.strip
    step( "I should not see #{m}" )
  end
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # rating_list.split(', ').each do |rating|
  #   step %{I #{uncheck.nil? ? '' : 'un'}check "ratings_#{rating}"}
  # end
  
  ratings = rating_list.split(", ")
  
  ratings.each do |r|
    if(uncheck == 'un')
      uncheck("ratings_#{r}")
    else
      check("ratings_#{r}")
    end
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  # Movie.all.each do |movie|
  #   step %{I should see "#{movie.title}"}
  # end
  
  rows = Movie.count
  rows.should == 10
end