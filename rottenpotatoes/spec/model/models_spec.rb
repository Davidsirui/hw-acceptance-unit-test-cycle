require 'rails_helper'

describe 'find all movies with the same director' do
  it "returns similar movies with the same director" do
    movie1 = Movie.create(title: 'Catch me if you can', director: 'Steven Spielberg')
    movie2 = Movie.create(title: 'Seven', director: 'David Fincher')
    movie3 = Movie.create(title: "Schindler's List", director: 'Steven Spielberg')
    Movie.search_similar_movies('Steven Spielberg').should eq [movie1, movie3]
  end
  
  it "should not return similar movies with the same director" do
    movie1 = Movie.create(title: 'Catch me if you can', director: 'Steven Spielberg')
    movie2 = Movie.create(title: 'Seven', director: 'David Fincher')
    movie3 = Movie.create(title: "Schindler's List", director: 'Steven Spielberg')
    expect(Movie.search_similar_movies('Steven Spielberg')).not_to eq [movie2]
  end
end
