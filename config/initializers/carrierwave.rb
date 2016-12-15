CarrierWave.configure do |config|
  if ENV["S3_ACCESS_KEY_ID"]
    config.storage :fog

    config.fog_credentials = {
      provider:              "AWS",
      aws_access_key_id:     ENV["S3_ACCESS_KEY_ID"],
      aws_secret_access_key: ENV["S3_SECRET_ACCESS_KEY"],
      region:                ENV["S3_REGION"]
    }
    config.asset_host    = ENV["ASSET_HOST"]
    config.fog_directory = ENV["S3_BUCKET"]
    config.fog_attributes = { 'Cache-Control' => "max-age=#{365.days.to_i}" }
  else
    config.storage :file
  end
end
