dir=$(dirname "$(readlink -f "$BASH_SOURCE")" | cut -d/ -f-3,5-)

if [[ -d "${dir}/halon-fivem" ]]; then
    datap="${dir}/halon-fivem/server-data"
    conf="${dir}/halon-fivem/server.cfg"  
else
    datap="${dir}/server-data"
    conf="${dir}/server.cfg"
fi

if [[ -d "${dir}/server" ]]; then
    execf="${dir}/server/run.sh"
else
    execf="${dir}/run.sh"
fi

cd $datap && bash $execf +exec $conf
