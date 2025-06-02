#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================
nodejs_version=22

python_version="3.12"

dex_ynh_commit=d04fc79d385313a11bc9982454b4a659148db77c

install_dex() {
  local dex_domain_path
  local dex_domain_path_no_trailing_slash

  oidc_secret=$(ynh_string_random -l 32)
  oidc_name="$app"
  oidc_callback="$domain/api/v1.0/callback/"

  if yunohost app list | grep -q "$dex_domain$dex_path"; then
    ynh_die "The domain provided for Dex is already used by another app. Please choose another one!"
  fi

  yunohost app install https://github.com/YunoHost-Apps/dex_ynh/tree/$dex_ynh_commit --force --args "domain=$dex_domain&path=$dex_path&oidc_name=$oidc_name&oidc_secret=$oidc_secret&oidc_callback=$oidc_callback" 2>&1 | tee dexlog.txt
  dex_app=$(grep -Po 'Installation of\s+\K.*(?=\s+completed)' dexlog.txt)
  rm dexlog.txt

  if [ -z "$dex_app" ]; then
    ynh_die "Dex package installation failed"
  fi

  # Create Dex URIs
  dex_domain_path="${dex_domain}${dex_path}"

  # Doc for the trick below:
  # https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html
  dex_domain_path_no_trailing_slash="${dex_domain_path%/}"

  dex_auth_uri="https://${dex_domain_path_no_trailing_slash}/auth"
  dex_token_uri="https://${dex_domain_path_no_trailing_slash}/token"
  dex_keys_uri="https://${dex_domain_path_no_trailing_slash}/keys"
  dex_user_uri="https://${dex_domain_path_no_trailing_slash}/userinfo"

  ynh_app_setting_set --key=dex_app --value=$dex_app
  ynh_app_setting_set --key=dex_auth_uri --value=$dex_auth_uri
  ynh_app_setting_set --key=dex_token_uri --value=$dex_token_uri
  ynh_app_setting_set --key=dex_keys_uri --value=$dex_keys_uri
  ynh_app_setting_set --key=dex_user_uri --value=$dex_user_uri
  ynh_app_setting_set --key=oidc_name --value=$oidc_name
  ynh_app_setting_set --key=oidc_secret --value=$oidc_secret
  ynh_app_setting_set --key=oidc_callback --value=$oidc_callback
}
