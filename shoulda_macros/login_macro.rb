module LoginMacros 
  def logged_in_as(user, &block)
    context "logged in as #{user.login}" do
      setup do
        @request.session[:user_id] = user.id
      end

      context '' do
        yield
      end
    end
  end
end 