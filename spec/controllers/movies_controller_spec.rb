require 'spec_helper'

describe MoviesController do

    describe "#similar" do
        it "should call find movies by director" do
            Movie.stub('find').and_return(mock_model(Movie, :director => 'Ridley Scott'))
            Movie.should_receive(:find).with('1')
            Movie.should_receive(:find_all_by_director).with('Ridley Scott')
            get :similar, :id => 1
        end
        
        it "should redirect to home page if movie has no direcotr info" do
            Movie.stub('find').and_return(mock_model(Movie, :title => 'Alien',:director => ''))
            get :similar, :id => 1
            response.should redirect_to movies_path
            flash[:error].should == "'Alien' has no director info"
        end
    end

    describe "#index" do
        it "should find all movies by rating" do
            Movie.should_receive(:find_all_by_rating)
            get :index
        end

        it "should filter movies by rating"  do
            session[:ratings] = {'R'=>"1"}
            Movie.should_receive(:find_all_by_rating).with(['R'], nil)
            get :index, {:ratings => {'R'=>"1"}}
        end

        it "should sort movies by title" do
            session[:sort] = 'title'
            Movie.should_receive(:find_all_by_rating).with([], {:order => :title})
            get :index, {:sort => 'title'}
        end

        it "should sort movies by release date" do
            session[:sort] = 'release_date'
            Movie.should_receive(:find_all_by_rating).with([], {:order => :release_date})
            get :index, {:sort => 'release_date'}
        end

        it "should redirect if session variable not match sort params" do
            session[:sort] = ''
            get :index, {:sort => 'release_date'}
            response.should redirect_to :sort => 'release_date', :ratings => {}
        end

        it "should redirect if session variable not match filter params" do
            session[:ratings] = ''
            get :index, {:ratings => {'R'=>"1"}}
            response.should redirect_to :sort => nil, :ratings => {'R'=>"1"}
        end
    end

    describe "#create" do
      it "should call movie create method when put" do
        Movie.stub('create!').and_return(Movie.new({:title => "test"}))
        Movie.should_receive('create!')
        post :create,  :movie => { :title => "test", :rating => 'G', :release_date => '2012-01-01'}
      end
    end

    describe "#edit" do
        it "should find a movie" do
            Movie.should_receive('find').with("1")
            get :edit, :id => "1"
        end
    end

    describe "#update" do
        it "should call update attributes" do
            movie = mock_model(Movie,{:id=>1, :title => "test", :rating => 'G', :release_date => '2012-01-01'})
            Movie.stub('find').and_return(movie)
            movie.stub('update_attributes').and_return(true)
            movie.should_receive('update_attributes!')
            stub('movie_path')
            put :update, :id => 1, :movie => { :title => "test", :rating => 'G', :release_date => '2012-01-01'}
        end
    end

    describe "#destroy" do
        it "should destroy movie" do
            movie = Movie.new({ :title => "test", :rating => 'G', :release_date => '2012-01-01'})
            Movie.stub('find').with('1').and_return(movie)
            movie.should_receive('destroy')
            delete :destroy, :id => 1
        end
    end

    describe "#show" do
        it "should find a movie" do
            Movie.should_receive('find').with("1")
            get :show, :id => "1"
        end
    end
end
