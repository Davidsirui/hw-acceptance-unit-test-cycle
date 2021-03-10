require 'rails_helper'

describe MoviesController, type: :controller do
    
    it "creates a new movie" do
        parameters = {movie: {title: 'valid title'}}
        expect {post :create, parameters}.to change(Movie, :count).by(1)
    end
    
    it "destroys the requested movie" do
        movie = Movie.create(title: 'Seven')
        expect do
          delete :destroy, {:id => movie.to_param}
        end.to change(Movie, :count).by(-1)
        response.should redirect_to movies_path
    end
    
    it "returns similar movies with the same director" do
        movie1 = Movie.create(title: 'Catch me if you can', director: 'Steven Spielberg')
        movie2 = Movie.create(title: 'Seven', director: 'David Fincher')
        movie3 = Movie.create(title: "Schindler's List", director: 'Steven Spielberg')
        Movie.search_similar_movies('Steven Spielberg').should eq [movie1, movie3]
    end
    
end
