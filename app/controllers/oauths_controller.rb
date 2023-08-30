class OauthsController < ApplicationController
  skip_before_action :require_login, raise: false

  def oauth
    login_at(params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    if (@user = login_from(provider))
      redirect_to root_path, notice: "#{provider.titleize}でログインしました"
    else
      begin
        @user = create_from(provider)
        reset_session
        auto_login(@user)
        redirect_to root_path, notice: "#{provider.titleize}でログインしました"
      rescue StandardError
        redirect_to root_path, alert: "#{provider.titleize}でのログインに失敗しました"
      end
    end
  end

  private

  def auth_params
    params.permit(:code, :provider, :error, :state)
  end
end

authorize?response_type=code&client_id=2000514884&redirect_uri=https://70f7-202-177-112-9.ngrok-free.app/oauth/callback?provider=line&state=12345abcde&scope=profile%20openid&nonce=09876xyz