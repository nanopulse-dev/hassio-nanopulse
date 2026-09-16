#!/usr/bin/with-contenv bashio

if (bashio::config.is_empty 'mqtt' || ! (bashio::config.has_value 'mqtt.server' || bashio::config.has_value 'mqtt.user' || bashio::config.has_value 'mqtt.password')) && bashio::var.has_value "$(bashio::services 'mqtt')"; then
    if bashio::var.true "$(bashio::services 'mqtt' 'ssl')"; then
        export MQTT__SERVER="ssl://$(bashio::services 'mqtt' 'host'):$(bashio::services 'mqtt' 'port')"
    else
        export MQTT__SERVER="tcp://$(bashio::services 'mqtt' 'host'):$(bashio::services 'mqtt' 'port')"
    fi
    export MQTT__USERNAME="$(bashio::services 'mqtt' 'username')"
    export MQTT__PASSWORD="$(bashio::services 'mqtt' 'password')"
fi

case "$(bashio::config 'radio')" in
  "rak2287_8xx_usb")
    export GATEWAY__CHIPSET_VENDOR="semtech"
    export GATEWAY__CHIPSET="sx1302"
    export GATEWAY__BOARD_VENDOR="rak"
    export GATEWAY__BOARD_MODEL="rak2287_8xx"
    export GATEWAY__BOARD_MAPPING="raspberrypi-usb"
    ;;
esac

export GATEWAY__NAME="$(bashio::config 'name')"

/nanopulse-gateway/nanopulse-gateway -c /nanopulse-gateway/config
