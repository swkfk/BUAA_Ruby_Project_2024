class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update ]

  def admin
    authenticate_user "Admin"
  end

  def login
  end

  def do_login
    username = params[:username]
    raw_password = params[:password]
    role = params[:user_type]
    user = User.where(name: username, password: helpers.hash_password(username, raw_password)).first
    if user and not user.user_roles.find_by(name: role).nil?
      session[:current_userid] = user.id
      session[:current_role] = role
      if role == "Admin"
        redirect_to admin_url
      else
        redirect_to goods_url
      end
    else
      redirect_to login_users_path, alert: "用户名、密码或者用户角色错误"
    end
  end

  def logout
    session.delete(:current_userid)
    session.delete(:current_role)
    redirect_to login_users_path, notice: "成功退出登录"
  end

  def register
  end

  def do_register
    username = params[:username]
    raw_password = params[:password]
    re_password = params[:re_password]

    if username.empty? or raw_password.empty? or re_password.empty?
      redirect_to register_users_path, alert: "用户名、密码不能为空"
      return
    end

    if raw_password != re_password
      redirect_to register_users_path, alert: "密码不一致！"
      return
    end

    unless User.find_by(name: username).nil?
      redirect_to register_users_path, alert: "用户名已存在"
      return
    end

    email = params[:email]
    role = params[:user_type]

    if role == "Admin" or UserRole.find_by(name: role).nil?
      redirect_to register_users_path, alert: "角色 #{role} 不存在或不允许注册"
      return
    end

    user = User.create(name: username, password: helpers.hash_password(username, raw_password), email: email)
    user.user_roles << UserRole.find_by(name: role)

    user.save!

    redirect_to login_users_path, notice: "成功注册，欢迎来到 Ruby Mailer， #{username}！"
  end

  def update_password
    return unless authenticate_user
    old_password = params[:old_password]
    raw_password = params[:password]
    re_password = params[:re_password]

    user = User.find(session[:current_userid])

    if raw_password != re_password
      redirect_to user, alert: "Password and re-password are not the same."
      return
    end

    if user.password != helpers.hash_password(user.name, old_password)
      redirect_to user, alert: "Password is wrong."
      return
    end

    user.password = helpers.hash_password(user.name, raw_password)
    user.save!
    redirect_to user, notice: "Password updated successfully."
  end

  def reset_password
    authenticate_user "Admin"
    user = User.find(params[:id])
    password = params[:password]
    user.password = helpers.hash_password(user.name, password)
    user.save!
    redirect_to user, notice: "成功重置用户 #{user.name} 的密码"
  end

  # GET /users/1 or /users/1.json
  def show
    authenticate_user
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    return unless authenticate_user "Admin"
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    return unless authenticate_user && assert_current_user(@user.id)
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "成功更新用户信息" }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :password, :email, :avatar)
    end
end
