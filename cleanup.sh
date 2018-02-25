#!/bin/bash

function cleanup {
  excode=$?
  # let this function do its thing
  trap 'echo "Just a sec!"' EXIT HUP INT QUIT PIPE TERM

  # If LINUXBREW is not set -- we have nothing to do!
  [[ x"$LINUXBREW" == x ]] && { trap - EXIT; exit $excode; }
  cd "$(dirname "$LINUXBREW")"
  [[ -f master.zip ]] && /bin/rm -f master.zip
  if [[ $excode -ne 0 ]]; then
    echo ""
    echo "Whooops! Looks like something has failed..."

    if [[ -n "$LINUXBREW" && -d "$LINUXBREW" ]]; then
      local REPLY=""
      while [[ $REPLY != "y" && $REPLY != "n" ]]; do
        readinput -p "Would you like to remove Linuxbrew from '$LINUXBREW'? ([y]/n) " REPLY
        REPLY=${REPLY:-y}
      done
      if [[ $REPLY == "y" ]]; then
        /bin/rm -rf "$LINUXBREW" || echo "Can not remove Linuxbrew ($LINUXBREW)" >&2;
      fi
    fi

    if [[ -n "$HOMEBREW_LOGS" && -d "$HOMEBREW_LOGS" ]]; then
      local RMLOGS=""
      while [[ $RMLOGS != "y" && $RMLOGS != "n" ]]; do
        readinput -p "Would you like to remove Linuxbrew Logs from '$HOMEBREW_LOGS'? ([y]/n) " RMLOGS
        RMLOGS=${RMLOGS:-y}
      done
      if [[ $RMLOGS == "y" ]]; then
        /bin/rm -rf "$HOMEBREW_LOGS" || echo "Can not remove Linuxbrew logs ($HOMEBREW_LOGS)" >&2;
      fi
    fi

    if [[ -n "$HOMEBREW_CACHE" && -d "$HOMEBREW_CACHE" ]]; then
      local REPLY=""
      while [[ $REPLY != "y" && $REPLY != "n" ]]; do
        readinput -p "Would you like to remove Linuxbrew cache from '$HOMEBREW_CACHE'? ([y]/n) " REPLY
        REPLY=${REPLY:-y}
      done
      if [[ $REPLY == "y" ]]; then
        if [[ $RMLOGS == "y" ]]; then
          /bin/rm -rf "$HOMEBREW_CACHE" || echo "Can not remove Linuxbrew cache ($HOMEBREW_CACHE)" >&2;
        else
          echo "hi :)" # TODO: Remove everything but the logs
        fi
      fi
    fi
  fi
  trap - EXIT
  echo "Sorry about that!"
  exit $excode
}

