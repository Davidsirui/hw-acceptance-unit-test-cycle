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
    
    it "When the specified movie has a director, return similar movies with the same director" do
        movie1 = Movie.create(title: 'Catch me if you can', director: 'Steven Spielberg')
        movie2 = Movie.create(title: "Schindler's List", director: 'Steven Spielberg')
        get :search_directors, {:id => movie1.id}
        expect(response).to render_template(:similar_movies)
        assigns(:movie).should eq movie1
    end
    
    it "When the specified movie has no director, redirct to movie path" do
        movie1 = Movie.create(title: 'No director', director: '')
        get :search_directors, {:id => movie1.to_param}
        expect(response).to redirect_to(movies_path)
        assigns(:movie).should eq movie1
    end
    
end
