require File.dirname(__FILE__) + '/../../test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  
  context "An admin user" do
    setup do
      @berlusconi = Factory(:user, :login => 'berlusconi', :admin => true)
      @berlusconi.activate!
      @request.session[:user_id]= @berlusconi.id

      @chavez = Factory(:user, :login => 'chavez')
      @chavez.activate!
      
      @fidel = Factory(:user, :login => 'fidel')
      
      @evo = Factory(:user, :login => 'evo')
      @evo.activate!
      @evo.delete!
    end

    context "on GET to index" do  
      
      context "without params" do
        setup do
          get :index
        end
        should "get all users" do
          assert_contains assigns(:users), @berlusconi
          assert_contains assigns(:users), @chavez
          assert_contains assigns(:users), @fidel
          assert_contains assigns(:users), @evo
        end
      end

      context "filtering by state" do

        context "active" do
          setup do
            get :index, :state => 'active'
          end
          should "get only active users" do
            assert_contains assigns(:users), @berlusconi
            assert_contains assigns(:users), @chavez
            assert_does_not_contain assigns(:users), @fidel
            assert_does_not_contain assigns(:users), @evo
          end
        end
        context "pending" do
          setup do
            get :index, :state => 'pending'
          end
          should "get only pending users" do
            assert_does_not_contain assigns(:users), @berlusconi
            assert_does_not_contain assigns(:users), @chavez
            assert_contains assigns(:users), @fidel
            assert_does_not_contain assigns(:users), @evo
          end
        end
        
      end

      context "with search param 'v'" do
        setup do
          get :index, :search_term => 'v'
        end
        should "get only users with 'v' in it's name or email" do
          assert_does_not_contain assigns(:users), @berlusconi
          assert_contains assigns(:users), @chavez
          assert_does_not_contain assigns(:users), @fidel
          assert_contains assigns(:users), @evo
        end
      end
                  
      context "with search param and state active" do
        setup do
          get :index, :search_term => 'v', :state => 'active'
        end
        should "get only active users with 'v' in it's name or email" do
          assert_does_not_contain assigns(:users), @berlusconi
          assert_contains assigns(:users), @chavez
          assert_does_not_contain assigns(:users), @fidel
          assert_does_not_contain assigns(:users), @evo
        end
      end
    
    end
        
   
  end  
end