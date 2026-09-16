#!/usr/bin/with-contenv bashio

if [[ "$(bashio::config 'public_key')" == "" || "$(bashio::config 'private_key')" == "" ]]; then
  output=$(/nanopulse-server/nanopulse-server generate-key-pair)
  public_key=$(echo "$output" | grep "Public key" | cut -d' ' -f3)
  secret_key=$(echo "$output" | grep "Secret" | cut -d' ' -f2)

  bashio::addon.option "public_key" "${public_key}"
  bashio::addon.option "secret_key" "${secret_key}"
fi

if (bashio::config.is_empty 'mqtt' || ! (bashio::config.has_value 'mqtt.server' || bashio::config.has_value 'mqtt.user' || bashio::config.has_value 'mqtt.password')) && bashio::var.has_value "$(bashio::services 'mqtt')"; then
    if bashio::var.true "$(bashio::services 'mqtt' 'ssl')"; then
        export MQTT__SERVER="ssl://$(bashio::services 'mqtt' 'host'):$(bashio::services 'mqtt' 'port')"
        export INTEGRATION__HOME_ASSISTANT__MQTT_SERVER="ssl://$(bashio::services 'mqtt' 'host'):$(bashio::services 'mqtt' 'port')"
    else
        export MQTT__SERVER="tcp://$(bashio::services 'mqtt' 'host'):$(bashio::services 'mqtt' 'port')"
        export INTEGRATION__HOME_ASSISTANT__MQTT_SERVER="tcp://$(bashio::services 'mqtt' 'host'):$(bashio::services 'mqtt' 'port')"
    fi

    export MQTT__USERNAME="$(bashio::services 'mqtt' 'username')"
    export MQTT__PASSWORD="$(bashio::services 'mqtt' 'password')"

    export INTEGRATION__HOME_ASSISTANT__MQTT_USERNAME="$(bashio::services 'mqtt' 'username')"
    export INTEGRATION__HOME_ASSISTANT__MQTT_PASSWORD="$(bashio::services 'mqtt' 'password')"
fi

export KEYPAIR__PUBLIC_KEY="$(bashio::config 'public_key')"
export KEYPAIR__SECRET_KEY="$(bashio::config 'secret_key')"
export GEOLOCATION__WIFI_BACKEND="$(bashio::config 'geolocation.wifi_backend')"
export GEOLOCATION__GOOGLE__API_KEY="$(bashio::config 'geolocation.google_api_key')"

/nanopulse-server/nanopulse-server -c /nanopulse-server/config -p /nanopulse-server/profiles
