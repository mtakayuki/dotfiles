# Google Cloud SDK shell completion
_gcloud_dir="$HOME/.local/share/google-cloud-sdk"
if [ -f "$_gcloud_dir/completion.bash.inc" ]; then
  . "$_gcloud_dir/completion.bash.inc"
fi
unset _gcloud_dir

export CLOUDSDK_CORE_CUSTOM_CA_CERTS_FILE=/etc/ssl/certs/ca-certificates.crt
