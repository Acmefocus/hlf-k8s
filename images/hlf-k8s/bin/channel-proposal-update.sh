#!/bin/bash
help() {
    echo -e "Usage: $0  [OPTIONS...] [ARGUMENTS...]"
    echo ""
    echo "Arguments:"
    echo -e "\t- CHANNEL_ID Channel name (required)"
    echo -e "\t- ORDERER_URL url of the orderer (required)"
    echo -e "\t- PROPOSAL_PATH Path of the proposal to use as channel update (required)"
    echo ""
    echo "Options:"
    echo -e "-h Help!"
    echo ""
    echo "Example:"
    echo -e "\t- $0 mychannel orderer-hlf-ord:7050 ./proposal.pb"
}

if [[ $1 == "-h" || $1 == "--help" ]]; then
    help
    exit 0
fi

function channelProposalUpdate() {
    if [[ ! $# -eq 3 ]]; then
        echo "Error: Illegal number of parameters"
        help
        exit 1
    fi

    CHANNEL_ID=$1
    ORDERER_URL=$2
    PROPOSAL_PATH=$3

    printf 'Testing the connection with the orderer:'
    until $(curl --output /dev/null --silent --head $ORDERER_URL); do
        printf '.'
        sleep 2
    done

    peer channel update -f $PROPOSAL_PATH -c $CHANNEL_ID -o $ORDERER_URL --tls --clientauth --cafile /var/hyperledger/tls/ord/cert/cacert.pem --keyfile /var/hyperledger/tls/client/pair/tls.key --certfile /var/hyperledger/tls/client/pair/tls.crt
}

channelProposalUpdate $@
