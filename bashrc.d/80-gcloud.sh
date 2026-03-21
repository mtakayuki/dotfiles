# Google Cloud SDK shell completion
local _gcloud_dir="$HOME/.local/share/google-cloud-sdk"
if [ -f "$_gcloud_dir/completion.bash.inc" ]; then
  . "$_gcloud_dir/completion.bash.inc"
fi
unset _gcloud_dir
